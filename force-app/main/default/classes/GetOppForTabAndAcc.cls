public with sharing class GetOppForTabAndAcc {

    @AuraEnabled(cacheable=true)
    public static List<Account> getOpportunitiesWithClosedDate(String searchKey,Integer offsetRange){
        String NameRegex = '^[A-Za-z]+$';
        Pattern MyPattern = Pattern.compile(NameRegex);
        Matcher MyMatcher = MyPattern.matcher(searchKey);
        //возвращает позицию в строке совпадения после последнего совпадающего символа
        Boolean result = MyMatcher.matches();
        
        if(offsetRange == null)
        {  
            if(searchKey != null && searchKey != '' && result)
            {
                String key='%'+searchKey+'%';
                return[select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account where name like :key limit 10];
            }
            else if(searchKey != null && searchKey != '')
            {
                return[select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account];  
            }
            else
            {
                return[select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account limit 10];
            }
        }
        else
        {
            if(searchKey != null && searchKey != '' && result)
            {
                String key='%'+searchKey+'%';
                return[select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account where name like :key limit 10 offset :offsetRange];
            }
            else if(searchKey != null && searchKey != '')
            {
                return[select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account];  
            }
            else
            {
                return[select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account limit 10 offset :offsetRange];
            }
            
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getAccountNumber(){
        //количество записей таблицы
        return [SELECT COUNT() FROM Account];
    }    
// обеспечивает доступ на стороне клиента и сервера к методу контроллера Apex
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getProduct(String ids){
        return [Select name, Quantity, UnitPrice, TotalPrice, id from OpportunityLineItem where opportunityid =: ids];
    }
//это HTTP-ответ, который можно кэшировать , который сохраняется для извлечения и использования позже, сохраняя новый запрос на сервер
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOppoortunitiesForOneAccount(String ids){
        return [select id,name,closedate, createddate, amount from Opportunity where isclosed =: true and accountid =: ids];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalRecords(String accountName, Decimal searchSum){
        Integer totalRecords = 0;
        String search = '%'+accountName+'%';
        
        for(Account a : [SELECT Id, Name FROM Account WHERE Name LIKE :search]){
            Decimal oppSumm = getSummClosedOpp(a.Id);
            if (oppSumm <= searchSum) totalRecords++;
                }
    	return totalRecords;    
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<AccOppInf> searchAcc(String accountName, Decimal searchSum, Integer pageSize, Integer pageNumber) {

        String search = '%'+accountName+'%';
        //Offset for SOQL
        Integer offset = (pageNumber - 1) * pageSize;
                
        
        List<AccOppInf> response = new List<AccOppInf>();
       
        for(Account a : [SELECT Id, Name FROM Account WHERE Name LIKE :search LIMIT :pageSize OFFSET :offset]){
            Decimal oppSumm = getSummClosedOpp(a.Id);
            if (oppSumm <= searchSum) {
            AccOppInf obj = new AccOppInf();
            obj.accId = a.Id;
            obj.name = a.Name +' (' + oppSumm + ') ';
            obj.sum = oppSumm;

            obj.opps = getOppList(a.Id);
            
            response.add(obj);
            }}
            return response;
        }
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<AccOppInf> getAcc(Id idAcc) {

        List<AccOppInf> response = new List<AccOppInf>();
       
        for(Account a : [SELECT Id, Name FROM Account WHERE Id=:idAcc]){
            Decimal oppSumm = getSummClosedOpp(a.Id);
            AccOppInf obj = new AccOppInf();
            obj.accId = a.Id;
            obj.name = a.Name +' (' + oppSumm + ') ';
            obj.sum = oppSumm;

            obj.opps = getOppList(a.Id);
            
            response.add(obj);
            }
            return response;
        }
        
        
    	@AuraEnabled(cacheable=true)
        public static List<OppList> getOppList(Id id){
		List<OppList> response = new List<OppList>();
            for(Opportunity opp : [SELECT Id, Name, CreatedDate, CloseDate, Amount  FROM Opportunity WHERE account.Id=:id AND ForecastCategoryName = 'Closed']){
            	OppList obj = new OppList();    
                obj.oppId = opp.Id;
                obj.name = opp.Name;
                obj.url = '/'+opp.Id;

                Datetime dt = (Datetime) opp.CreatedDate;
                obj.createddate = dt.date();
                
                obj.closedate = opp.CloseDate;
                obj.amount = opp.Amount;
                obj.prods = getProd(opp.Id);
                response.add(obj);
            }    
        

        return response;		
		}
    
    	@AuraEnabled(cacheable=true)
   		public static List<OpportunityLineItem> getProd(Id id){
        return [select Id, Product2.Name from OpportunityLineItem WHERE OpportunityId =:id];
    }
    
    
    public class AccOppInf {
        @AuraEnabled
        public Id accId {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public Decimal sum {get;set;}
        @AuraEnabled
        public List<OppList> opps {get;set;}

        
        
    }
    
    public class OppList {
        @AuraEnabled
        public Id oppId {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String url {get;set;}
        @AuraEnabled
        public Date createddate {get;set;}
        @AuraEnabled
        public Date closedate {get;set;}
        @AuraEnabled
        public Decimal amount {get;set;}
        @AuraEnabled
        public List<OpportunityLineItem> prods {get;set;}
    }
          
    @AuraEnabled(cacheable=true)
    public static Decimal getSummClosedOpp(Id id){
        Decimal sum = 0.00;
        Opportunity[] opp = [
            SELECT 
            Id, 
            Name,
            Amount
            FROM Opportunity
            WHERE account.Id=:id AND ForecastCategoryName = 'Closed'
        ];
        
        for(Opportunity o: opp){
        sum += o.Amount;
     	}
       
    	return sum;
    }
}