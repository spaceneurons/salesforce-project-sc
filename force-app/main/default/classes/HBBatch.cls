//запускаются по заданному расписанию
global class HBBatch implements Database.Batchable<sObject>{
    
    global database.querylocator start(Database.BatchableContext BC){
         Date tday = system.today(); 
        
        String SOQL = 'SELECT ID, Name, Email, Birthdate FROM Contact WHERE DAY_IN_MONTH(Birthdate) = ' + 
                      tday.day() +  ' AND CALENDAR_MONTH(Birthdate) = ' + tday.month();
        return Database.getQueryLocator(SOQL);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        
        for(Contact cnt : scope) {
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
            String[] toAddresses = new String[] {cnt.Email};
            mail.setToAddresses(toAddresses);
        	mail.setUseSignature(false); 
   			mail.setBccSender(false); 
   			mail.setSaveAsActivity(false); 
	        mail.setTargetObjectId(cnt.Id);
	        mail.setTemplateId('00X5j000001ESNYEA4');        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    

}