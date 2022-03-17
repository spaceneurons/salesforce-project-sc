import { LightningElement, track, api } from 'lwc';

// importing to show toast notifictions
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class StepTwo extends LightningElement {
  @api workTypeId;

  @track skillRequirement = {};

  @api stepValue;
  nextStep() {
    this.stepValue = 3;
    // Creates the event with the data next step.
    const selectedEvent = new CustomEvent("stepvaluechange", {
      detail: this.stepValue
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
  }

  handleInputFieldChange(event) {
    this.skillRequirement[event.currentTarget.fieldName] = event.target.value;
  }

  handleSuccess() {
    this.dispatchEvent(new ShowToastEvent({
      title: 'Success',
      message: 'Skill Requirement Created Successfully!!',
      variant: 'success'
    }));
    this.nextStep();

  }



}