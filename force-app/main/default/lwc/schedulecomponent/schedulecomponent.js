import { LightningElement, api, track, wire } from 'lwc';

import runBatch from'@salesforce/apex/ScheRun.runBatch';
import getCRON from '@salesforce/apex/ScheGetDetails.getCRON';
import getStateCronTrigger from'@salesforce/apex/ScheGetDetails.getStateCronTrigger';
import isWorkedTrigger from '@salesforce/apex/ScheGetDetails.isWorkedTrigger';
import stopSchedulable from'@salesforce/apex/ScheGetDetails.stopSchedulable';
import tets2 from'@salesforce/apex/ScheGetDetails.tets2';
import infoBatch from'@salesforce/apex/ScheGetDetails.infoBatch';

export default class LwcSchedule extends LightningElement {
    @api BatchName;
    @api ScheduleName;

    @track valueCRON;
    @track State;
    @track isWork;
    @track valueCRON1;
    @track BatchBody;

    @wire(getCRON, {NameCronJobDetail: "$ScheduleName"})valueCRON;
    @wire(isWorkedTrigger, {NameCronJobDetail: "$ScheduleName"})isWork;    
    @wire(infoBatch, {BatchName: "$BatchName"}) BatchBody;

  
    onBatch(){
            runBatch({ apexClass: this.BatchName});
           
    }

    onSchedulable(){
          tets2({NameCronJobDetail: this.ScheduleName, CRONstr:this.valueCRON.data});
          console.log({NameCronJobDetail: this.ScheduleName});
          window.location.reload();
        }
   
    offSchedulable(){
        stopSchedulable({NameCronJobDetail: this.ScheduleName});
        window.location.reload();
       
    }  
    
    infBatch(){
      alert(this.BatchBody.data);
    }

    changevalueCRON(event){
    this.valueCRON.data = event.target.value;
    }
        
  }