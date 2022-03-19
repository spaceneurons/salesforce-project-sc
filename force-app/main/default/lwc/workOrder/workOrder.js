import { LightningElement, track, api } from 'lwc';

export default class WorkOrder extends LightningElement {
    @api show = 1;

    @track createWorkOrder = true;
    @track createWorkOrderLineItem = false;

    showTemplate() {
        switch (this.show) {
            case 1:
                this.createWorkOrder = true;
                this.createWorkOrderLineItem = false;
                break;
            case 2:
                this.createWorkOrder = false;
                this.createWorkOrderLineItem = true;
                break;
            default:
                this.createWorkOrder = true;
        }
    }

    hanldeStepValueChange(event) {
        this.show = event.detail;
        this.showTemplate();
    }

    workOrderId;
    hanldeSetWorkOrderId(event) {
        this.workOrderId = event.detail;
    }
}