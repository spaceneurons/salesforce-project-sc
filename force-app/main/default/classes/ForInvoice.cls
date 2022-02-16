public with sharing class ForInvoice {
    private final Opportunity opportunity;

    public ForInvoice(ApexPages.StandardController stdController){
        this.opportunity=(Opportunity)stdController.getRecord();
    }

    String ids;
    Opportunity opps;
    String str;

    public Opportunity getOpp(){
        opps=[select Invoice_Number__c, id, ownerId from Opportunity where id=:opportunity.id];
        ids=opportunity.id;
        return opps;
    }

    List<OpportunityLineItem> products2;

    public List<OpportunityLineItem> getProducts2(){
        if(products2==null){
            ids=opportunity.id;
            products2=[Select Product2.Name, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where opportunityid =: ids];
        }
        
        return products2;
    }
    
    List<Contact> contacts;

    public List<Contact> getContacts(){
        if(contacts==null){
            OpportunityContactRole opportunityContacrs=[select contactid from OpportunityContactRole where isprimary=:true and opportunityid =: opportunity.id limit 1];
            contacts =[select name, email, phone, accountid from contact where id=:opportunityContacrs.contactid limit 1];
        }
        return contacts;
    }

    List<Account> accounts;

    public List<Account> getAccounts(){
        if(accounts==null){
            accounts=[select name from account where id=:contacts[0].accountid limit 1];
        }
        return accounts;
    }

    Decimal total=0;

    public Decimal getTotal(){
        if(products2!=null){
            for(Integer i=0; i<products2.size();i++){
                total+=products2[i].TotalPrice;
            }
        }
        else{
            total=0;
        }
        return total;
    }
    
    public PageReference attachPDF() {
        PageReference pdfPage = Page.pdfrep;
        pdfPage.getParameters().put('id',opportunity.Id);
        opps=[select Invoice_Number__c, id from Opportunity where id =: opportunity.id];
        str=opps.Invoice_Number__c;
        Blob pdfBlob; 
        if (!Test.isRunningTest()) { 
            pdfBlob = pdfPage.getContentasPDF(); 
        } else { 
            pdfBlob = Blob.valueOf('Some Text');
        }
        attachment[] attchToDelete=[select  parentId, name, body from attachment where parentId=:opportunity.id and name=:str+'.pdf'];
        delete attchToDelete;
        
        Attachment attach = new Attachment(parentId = opportunity.Id, Name =str+'.pdf', body = pdfBlob);
        insert attach;
        
        List<ContentDocument> document=[select id, title from ContentDocument where title=:str limit 1];

        if(document.size() > 0){
        ContentVersion v = new ContentVersion();
        v.versionData=pdfBlob;
        v.title=str;
        v.ContentLocation='S';
        v.PathOnClient=str+'.pdf';
        v.ContentDocumentId=document[0].id;
        insert v;
        }  
        else{
            ContentVersion v = new ContentVersion();
            v.versionData=pdfBlob;
            v.title=str;
            v.ContentLocation='S';
            v.PathOnClient=str+'.pdf';
            insert v;
        }
        

        PageReference pageWhereWeWantToGo = Page.pdfrep;
        pageWhereWeWantToGo.getParameters().put('id',opportunity.Id); 
        pageWhereWeWantToGo.setRedirect(true);
        return pageWhereWeWantToGo;    
    }
}