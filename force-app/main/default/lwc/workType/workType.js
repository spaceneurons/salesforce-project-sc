import { LightningElement, track, api} from 'lwc';

export default class WorkType extends LightningElement {
    @track error; 
    
    @api show = 1;

    @track stepOne = true;
    @track stepTwo = false;
    @track stepThree = false;
    @track stepFour = false;
    
    showTemplate() {
        switch (this.show) {
            case 1:
                this.stepOne = true;
                this.stepTwo = false;
                this.stepThree = false;
                this.stepFour = false;
                break;
            case 2: 
                this.stepOne = false;
                this.stepTwo = true;
                this.stepThree = false;
                this.stepFour = false;
                break;
            case 3:
                this.stepOne = false;
                this.stepTwo = false;
                this.stepThree = true;
                this.stepFour = false;
                break;
            case 4:
                this.stepOne = false;
                this.stepTwo = false;
                this.stepThree = false;
                this.stepFour = true;
                break;
            default:
                this.stepOne = true;
        }
    }     

    hanldeStepValueChange(event) {
        this.show = event.detail;
        this.showTemplate();
    }

    workTypeId;
    hanldeSetWorkTypeId(event) {
        this.workTypeId = JSON.parse(event.detail);
    }

    //delete this
    @api objectApiName;
    
}