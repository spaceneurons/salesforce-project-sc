global with sharing class ScheRun implements Schedulable{
   
    public static String NameBatch;
    
    
    global void execute(SchedulableContext ctx) {
     runBatch(NameBatch);
    }
    
    @AuraEnabled(cacheable=true)
    public static void runSchedulable(String apexClass){
        NameBatch = apexClass;
        
        
    }
    

  
    @AuraEnabled(cacheable=true)
    public static ID runBatch(String apexClass){
        
        Type t = Type.forName(apexClass);
        if (t == null){
           throw new TWSException (apexClass + ' not found');
        }
        Object s = t.newInstance();
        ID batchprocessid =
        Database.executeBatch((Database.Batchable<sObject>)s);
        System.debug(LoggingLevel.Info, 'Job ID: '+batchprocessid);
        return batchprocessid;    }
    

    
    
    
    
    public class TWSException extends Exception{}


}