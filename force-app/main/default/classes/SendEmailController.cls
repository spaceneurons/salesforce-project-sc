public with sharing class SendEmailController {

    @AuraEnabled(cacheable=true)
    public static EmailTemplate getEmailTemplate(){
        EmailTemplate emailtemp = [select subject, body, id from EmailTemplate where name =: 'qqqq'];
        return emailtemp;
    }

    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunity(String ids){
        return [select Invoice_number__c, Id from Opportunity where id =: ids];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getContactName(String ids){
        OpportunityContactRole opp = [select ContactId, Id from OpportunityContactRole where OpportunityId =: ids and IsPrimary =: true];
        Contact contacts = [select Name, Email, Phone, Accountid from Contact where id =: opp.ContactId];
        return contacts;
    }

    @AuraEnabled(cacheable=true)
    public static ContentVersion retriveFiles(String title){
        ContentDocument doc = [select id from ContentDocument where title =: title];
        return [SELECT Id, Title, FileExtension, ContentDocumentId From ContentVersion where ContentDocumentId =: doc.id and isLatest=:true];
    }

    @AuraEnabled(cacheable=true)
    public static void sendEmailToController(String body, String toSend, String subject, String opportunityId, String invoiceNumber){
        try{
            PageReference pdfPage = Page.pdfrep; 
            pdfPage.getParameters().put('id',opportunityId);
            Blob pdfBlob;

            if(Test.isRunningTest()) { 
                pdfBlob = blob.valueOf('Unit.Test');
              } else {
                pdfBlob = pdfPage.getContentAsPDF();
              }

            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setBody(pdfBlob);
            attach.setFileName(invoiceNumber+'.pdf');

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach}); 
            String[] toAddresses = new String[] {toSend};

            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setreplyto('qqqq@vrkltatditq73xlfmtn4lgsmjldlbvqtzrqke2v6bv0vwkt3k.5j-1vz9ceau.ap27.apex.salesforce.com');
            mail.setHtmlBody('<h1>'+body+'</h1>');
            messaging.Email[] emails = new messaging.Email[]{mail};
            Messaging.sendEmail( emails);
            
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}