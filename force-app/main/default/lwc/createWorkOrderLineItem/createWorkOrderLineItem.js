import { LightningElement, api } from 'lwc';

// importing to show toast notifictions
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateWorkOrderLineItem extends LightningElement {
  @api workOrderId;

  stepValue;
  nextStep() {
    this.stepValue = 1;
    // Creates the event with the data next step.
    const selectedEvent = new CustomEvent("stepvaluechange", {
      detail: this.stepValue
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
  }

  handleSuccess() {
    this.dispatchEvent(new ShowToastEvent({
      title: 'Success!!',
      message: 'Work Order Line Item Created Successfully!!',
      variant: 'success'
    }));
    this.nextStep();

  }


}