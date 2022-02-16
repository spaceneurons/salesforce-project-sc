trigger PaymetTrigger on Payment__c (after insert, after update) {
    for(Payment__c p : Trigger.New){
        Decimal SummPaymet = 0.00;
        Decimal AmountOpportunity = [SELECT Amount FROM Opportunity WHERE Id = :p.Opportunity__c LIMIT 1].Amount;
        for(Payment__c pp : [SELECT Amount__c FROM Payment__c WHERE Opportunity__c = :p.Opportunity__c]){
            SummPaymet += pp.Amount__c;
        }
        if ((SummPaymet > 0) && (SummPaymet < AmountOpportunity)) {
            Opportunity op = [SELECT Id, Name, ContactId FROM Opportunity WHERE Id = :p.Opportunity__c]; op.StageName = 'Partially Paid';
            update op;
        } else {
            Opportunity op = [SELECT Id, Name, OwnerId FROM Opportunity WHERE Id = :p.Opportunity__c]; op.StageName = 'Fully Paid';
            update op;        
            Task tsk = new Task();
            	tsk.OwnerId = op.OwnerId; tsk.Priority = 'High'; tsk.Status = 'Not Started'; tsk.Subject = 'Newtask'; tsk.IsReminderSet = true;
            	tsk.ReminderDateTime = Datetime.newInstanceGmt( Date.today().addDays(2),Time.newInstance(10, 0, 0, 0));
				tsk.WhatId = op.Id; insert tsk; 
	        }
    }
}