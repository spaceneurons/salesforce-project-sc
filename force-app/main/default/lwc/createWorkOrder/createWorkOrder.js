import { LightningElement } from 'lwc';

// importing to show toast notifictions
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateWorkOrder extends LightningElement {
  stepValue;
  nextStep() {
    this.stepValue = 2;
    // Creates the event with the data next step.
    const selectedEvent = new CustomEvent("stepvaluechange", {
      detail: this.stepValue
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
  }

  handleSuccess(event) {
    this.dispatchEvent(new ShowToastEvent({
      title: 'Success!!',
      message: 'Work Order Created Successfully!!',
      variant: 'success'
    }));
    // Creates the event with the data workOrderId.
    const selectedEvent2 = new CustomEvent("setworkorderid", {
      detail: event.detail.id
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent2);

    this.nextStep();

  }
}