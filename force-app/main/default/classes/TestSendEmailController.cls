@isTest (SeeAllData=true)
public with sharing class TestSendEmailController {
    
    static testMethod void testGetEmailTemplate(){
        EmailTemplate emailtemp = [select subject, body, id from EmailTemplate where name =: 'qqqq'];

        Test.startTest();
        System.assertEquals(SendEmailController.getEmailTemplate(), emailtemp);
        Test.stopTest();
    }

    static testMethod void testGetOpportunity(){
        Opportunity opp = [select id, Invoice_number__c from Opportunity limit 1];

        Test.startTest();
        System.assertEquals(SendEmailController.getOpportunity(opp.id), opp);
        Test.stopTest();
    }

    static testMethod void testGetContactName(){
        Opportunity opp = [select id from Opportunity where Invoice_number__c =: 'INV-000001'];
        OpportunityContactRole oppContactRole= [select ContactId, Id from OpportunityContactRole where OpportunityId =: opp.id and  IsPrimary =: true limit 1];
        Contact contacts = [select Name, Email, Phone, Accountid from Contact where id =: oppContactRole.ContactId];

        Test.startTest();
        System.assertEquals(SendEmailController.getContactName(opp.id), contacts);
        Test.stopTest();
    }


    static testMethod void testSendEmailToController(){
        Opportunity opp= [select id, Invoice_number__c from Opportunity where Invoice_number__c =: 'INV-000001'];
        Test.startTest();
        SendEmailController.sendEmailToController('test','rushevamar@gmail.com','test',opp.id,'INV-000001');
        Test.stopTest();
    }
}