@RestResource(urlMapping='/Payment/*')
global with sharing class PayManager {
  @HttpPost
    global static String doPost(List<Pay> payments) {
      	List<Payment__c> listPayment = new List<Payment__c>();
		  if (listPayment.size() > 0) { Payment__c a = listPayment.get(0); }
        for (Pay i : payments) {
            Opportunity op = [SELECT Id FROM Opportunity WHERE Id = :i.Opportunity];
            listPayment.add( new Payment__c(Opportunity__c = op.Id, Amount__c = i.Amount, FirstName__c = i.FirstName, LastName__c = i.LastName));
        }     
	   insert listPayment;
		return String.valueOf(listPayment.size());
    } 
    global class Pay {global String Opportunity; global Decimal Amount; global String FirstName; global String LastName;}
}