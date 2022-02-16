public with sharing  class SchedulableDetailLWC {
   
    
    public static ID IdCronJobDetail(String NameCronJobDetail){
        System.debug('============================>');
        System.debug(NameCronJobDetail);
        return [SELECT Id  FROM CronJobDetail WHERE Name =: NameCronJobDetail LIMIT 1].Id;
    }
    
    public static Boolean isCronJobDetail(String NameCronJobDetail){
        Boolean isCron = true;
        List<CronJobDetail> CronJobDetails = [SELECT Id, Name  FROM CronJobDetail WHERE Name =: NameCronJobDetail LIMIT 1];
        if(CronJobDetails.size() == 0 ) {isCron=false;}
        return isCron;
    }

    @AuraEnabled(cacheable=true)
    public static String getCRON(String NameCronJobDetail){
        if (isCronJobDetail(NameCronJobDetail)){
        System.debug('++++++++++++++++++++++++++++');
        System.debug(NameCronJobDetail);
        ID IdCJD = IdCronJobDetail(NameCronJobDetail);
        System.debug('============================>');
        System.debug(IdCJD);        
        return [SELECT CronExpression  FROM CronTrigger WHERE CronJobDetailId =: IdCJD LIMIT 1].CronExpression;
        }else{
            return '0 0 22 * * ? *';}
        
    }
    
    @AuraEnabled(cacheable=true)
    public static String getStateCronTrigger(String NameCronJobDetail){
        if (isCronJobDetail(NameCronJobDetail)){
        Id IdCJD = IdCronJobDetail(NameCronJobDetail);
        return [SELECT State  FROM CronTrigger WHERE CronJobDetailId =: IdCJD LIMIT 1].State;
        } else {return null;}
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean isWorkedTrigger(String NameCronJobDetail){
        boolean isWork = false;
        if (isCronJobDetail(NameCronJobDetail)){
        Id IdCJD = IdCronJobDetail(NameCronJobDetail);
        String State = [SELECT State  FROM CronTrigger WHERE CronJobDetailId =: IdCJD LIMIT 1].State;
        System.debug('------------------------->');
        System.debug(State);
        if (State == 'WAITING')  {
            isWork = true;
        }}
        System.debug('-----isWork------------>');
        System.debug(isWork); 
       return isWork;
    }
    
    @AuraEnabled()
    public static void stopSchedulable(String NameCronJobDetail){
        Id IdCronJobDetail = IdCronJobDetail(NameCronJobDetail);
        Id jobId = [SELECT Id FROM CronTrigger WHERE CronJobDetailId =: IdCronJobDetail LIMIT 1].Id;
        System.abortJob(jobId);
        
    }
    
    @AuraEnabled(cacheable=true)
    public static void runSchedulable(String NameCronJobDetail, String CRONstr){
        System.debug('-----CRONstr------------>');
        System.debug(CRONstr); 
        Type newSchedulerType = Type.forName('SchedulableDetail');
		System.schedule(NameCronJobDetail, CRONstr, (Schedulable)newSchedulerType.newInstance());
    } 

    @AuraEnabled(cacheable=true)
    public static void tets2(String NameCronJobDetail, String CRONstr){
         try {
        System.debug('-----CRONstr------------>');
        System.debug(CRONstr); 
        System.debug('-----NameCronJobDetail------------>');
        System.debug(NameCronJobDetail); 
        Type newSchedulerType = Type.forName('SchedulableDetail');
		System.schedule(NameCronJobDetail, CRONstr, (Schedulable)newSchedulerType.newInstance());
        } catch (Exception e) {
           System.debug('updateUsersFirstName error: ' + e.getMessage());
       }
            }
  
            

    @AuraEnabled(cacheable=true)   
    public static String infoBatch(String BatchName){
        if (BatchName!=null) return [SELECT Body FROM ApexClass WHERE Name =: BatchName LIMIT 1].Body;
        else return 'class name is incorrect';
    }        
     
}