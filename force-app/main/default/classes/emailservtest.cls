@isTest(SeeAllData=true)
public class emailservtest{
    static testMethod void testInboundEmailWithoutNormalPlainTextBody(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        email.plainTextBody = 'teset';
        email.fromAddress = 'rushemar@gmail.com';
        email.subject = 'INV-000001';

        emailserv edr = new emailserv();
        edr.handleInboundEmail(email,env); 

        Test.startTest();
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        System.assertEquals(result.success, true);
        Test.stopTest();
   }

   static testMethod void testInboundEmailWithApproved(){
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

       email.plainTextBody = 'Approved';
       email.fromAddress = 'rushemar@gmail.com';
       email.subject = 'INV-000007';

       emailserv edr = new emailserv();
       edr.handleInboundEmail(email,env); 

       Test.startTest();
       Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
       System.assertEquals(result.success, true);
       Test.stopTest();
  }

  static testMethod void testInboundEmailWithRejected(){
    Messaging.InboundEmail email = new Messaging.InboundEmail() ;
    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

    email.plainTextBody = 'Rejected';
    email.fromAddress = 'rushemar@gmail.com';
    email.subject = 'INV-000001';

    emailserv edr = new emailserv();
    edr.handleInboundEmail(email,env); 

    Test.startTest();
    Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
    System.assertEquals(result.success, true);
    Test.stopTest();
}
}