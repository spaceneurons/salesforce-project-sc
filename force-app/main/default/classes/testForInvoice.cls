@isTest(SeeAllData = true)
public with sharing class testForInvoice {

    @isTest
    public static void testGetOpp() {
        Opportunity opp = [select Invoice_Number__c, id,  ownerId from Opportunity where Invoice_Number__c =: 'INV-000001'];
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        ForInvoice ext = new ForInvoice(sc); 

        System.assertEquals(ext.getOpp(), opp);
    }

    @isTest
    public static void testGetProducts() {
        Opportunity opp = [select id, Invoice_Number__c, name from Opportunity where Invoice_Number__c =: 'INV-000001'];
        List<OpportunityLineItem> prod=[Select Product2.Name, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where opportunityid =: opp.id];
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        ForInvoice ext = new ForInvoice(sc); 


        System.assertEquals(ext.getProducts2(), prod);
    }


    @isTest
    public static void testGetContacts() {
        Opportunity opp = [select id, Invoice_Number__c, name from Opportunity where Invoice_Number__c =: 'INV-000001'];
        OpportunityContactRole opportunityContacrs=[select contactid from OpportunityContactRole where isprimary=:true and opportunityid =: opp.id limit 1];
        List<Contact> contacts =[select name, email, phone, accountid from contact where id=:opportunityContacrs.contactid limit 1];
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        ForInvoice ext = new ForInvoice(sc); 


        System.assertEquals(ext.getContacts(), contacts);
    }

    @isTest
    public static void testGetAccounts() {
        Opportunity opp = [select id, Invoice_Number__c, name from Opportunity where Invoice_Number__c =: 'INV-000001'];
        
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        ForInvoice ext = new ForInvoice(sc); 

        ext.getContacts(); 
        List<Account> acc = [select name from account where id=:ext.getContacts()[0].accountid limit 1];
        System.assertEquals(ext.getAccounts(), acc);
    }

    @isTest
    public static void testGetTotal() {
        Opportunity opp = [select id, Invoice_Number__c, name from Opportunity where Invoice_Number__c =: 'INV-000001'];
        List<OpportunityLineItem> prod=[Select Name, Quantity, UnitPrice, TotalPrice from OpportunityLineItem where opportunityid =: opp.id];
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        ForInvoice ext = new ForInvoice(sc); 

        ext.getProducts2();
        System.assertEquals(ext.getTotal(), 900000.00);
    }

    @isTest
    public static void testGetTotalWithoutProducts() {
        Opportunity opp = [select id, Invoice_Number__c, name from Opportunity where Invoice_Number__c =: 'INV-000001'];
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        ForInvoice ext = new ForInvoice(sc); 

       System.assertEquals(ext.getTotal(), 0);
    }

    @isTest
    public static void testAttachPDF() {
        Opportunity opp = [select id, Invoice_Number__c, name from Opportunity where Invoice_Number__c =: 'INV-000001'];
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);   

        ForInvoice ext = new ForInvoice(sc); 

        PageReference pageWhereWeWantToGo = Page.pdfrep;
        pageWhereWeWantToGo.getParameters().put('id',opp.Id); 
        pageWhereWeWantToGo.setRedirect(true);


        System.debug(ext.getOpp()); 
        System.assertEquals(ext.attachPDF().getUrl(), pageWhereWeWantToGo.getUrl());
    }

    @isTest
    public static void testAttachPDFWithoutAttachment() {
        Opportunity opp = [select id, Invoice_Number__c, name from Opportunity where Invoice_Number__c =: '' limit 1];
        PageReference testPage = page.pdfrep;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        ForInvoice ext = new ForInvoice(sc); 

        PageReference pageWhereWeWantToGo = Page.pdfrep;
        pageWhereWeWantToGo.getParameters().put('id',opp.Id); 
        pageWhereWeWantToGo.setRedirect(true);


        System.debug(ext.getOpp()); 
        System.assertEquals(ext.attachPDF().getUrl(), pageWhereWeWantToGo.getUrl());
    }
}