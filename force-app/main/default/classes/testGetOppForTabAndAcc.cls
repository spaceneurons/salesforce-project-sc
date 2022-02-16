@isTest (SeeAllData=true)
public with sharing class testGetOppForTabAndAcc {
    static testMethod void testGetOpportunitiesWithClosedDateWithoutSearchStringAndOffsetRang(){
        List<Account> acc = [select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account limit 10];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getOpportunitiesWithClosedDate('',null), acc);
        Test.stopTest();
    }

    static testMethod void testGetOpportunitiesWithClosedDateWithSearchString(){
        String key='%'+'e'+'%';
        List<Account> acc = [select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account where name like :key limit 10];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getOpportunitiesWithClosedDate('e',null), acc);
        Test.stopTest();
    }

    static testMethod void testGetOpportunitiesWithClosedDateWithSearchStringNoLetters(){
        String key='%'+'2'+'%';
        List<Account> acc = [select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getOpportunitiesWithClosedDate('2',null), acc);
        Test.stopTest();
    }

    static testMethod void testGetOpportunitiesWithClosedDateWithOffsetRagne(){
        String key='%'+''+'%';
        List<Account> acc = [select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account limit 10 offset :2];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getOpportunitiesWithClosedDate('',2), acc);
        Test.stopTest();
    }

    static testMethod void testGetOpportunitiesWithClosedDateWithOffsetRagneAndSearchKey(){
        String key='%'+'e'+'%';
        List<Account> acc = [select id, name, (select id,name,closedate, createddate, amount from opportunities where isclosed =: true) from account where name like :key limit 10 offset :2];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getOpportunitiesWithClosedDate('e',2), acc);
        Test.stopTest();
    }

    static testMethod void testGetAccountNumber(){
        Integer testCount = [SELECT COUNT() FROM Account];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getAccountNumber(), testCount);
        Test.stopTest();
    }

    static testMethod void testGetProduct(){
        List<OpportunityLineItem> oppLineItem=[Select name, Quantity, UnitPrice, TotalPrice, id from OpportunityLineItem where opportunityid =: '0065j00000Kj2isAAB'];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getProduct('0065j00000Kj2isAAB'), oppLineItem);
        Test.stopTest();
    }

    static testMethod void testGetOppoortunitiesForOneAccount(){
        List<Opportunity> opp=[select id,name,closedate, createddate, amount from Opportunity where isclosed =: true and accountid =: '0015j00000ACAWyAAP'];

        Test.startTest();
        System.assertEquals(GetOppForTabAndAcc.getOppoortunitiesForOneAccount('0015j00000ACAWyAAP'), opp);
        Test.stopTest();
    }
    
    
    static testMethod void testsearchAcc(){
        for (Integer i = 0; i < 10; i++){
        Account a = new Account(Name='TestAccount'+1);
		insert a; 
            for (Integer j = 0; j < 5; j++){
                Opportunity opp = new Opportunity(Name='TestAccount'+1, Amount=Integer.valueof((Math.random() * 1000)), StageName='Closed Won',  CloseDate = date.newInstance(2020, 09, 30));
		insert opp; 
            }
                               } 
       List<GetOppForTabAndAcc.AccOppInf> response = new List<GetOppForTabAndAcc.AccOppInf>();
       response = GetOppForTabAndAcc.searchAcc('yyy', 10, 1, 10); 
    }    
    

    static testMethod void testgetAcc(){
        Account a = new Account(Name='TestAccount');
		insert a; 
         for (Integer j = 0; j < 5; j++){
                Opportunity opp = new Opportunity(Name='TestAccount'+1, accountid = a.Id, Amount=10, ForecastCategoryName = 'Closed', StageName='Closed Won', CloseDate = date.newInstance(2020, 09, 30));
		insert opp; 
   		}
        List<GetOppForTabAndAcc.AccOppInf> response = new List<GetOppForTabAndAcc.AccOppInf>();
       response = GetOppForTabAndAcc.getAcc(a.Id); 
    }
    
    
    
     static testMethod void testgetSummClosedOpp(){
        Account a = new Account(Name='TestAccount');
		insert a; 
         for (Integer j = 0; j < 5; j++){
                Opportunity opp = new Opportunity(Name='TestAccount'+1, accountid = a.Id, Amount=10, ForecastCategoryName = 'Closed', StageName='Closed Won', CloseDate = date.newInstance(2020, 09, 30));
		insert opp; 
   		}
    Decimal summ = GetOppForTabAndAcc.getSummClosedOpp(a.Id);
    System.assertEquals(50.00, summ, '++++!');   
    }
}