import { LightningElement, api, wire } from 'lwc';

// Importing Apex Class method
import saveWorkType from '@salesforce/apex/WorkTypeController.saveWorkType';

// importing to show toast notifictions
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import DurationType_FIELD from '@salesforce/schema/WorkType.DurationType';
import WORKTYPE_OBJECT from '@salesforce/schema/WorkType';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class StepOne extends LightningElement {

    @api options;

    @wire(getObjectInfo, { objectApiName: WORKTYPE_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: DurationType_FIELD })
    WorkTypePicklistValues({ error, data }) {
        if (data) {
            this.options = data.values;
        } else if (error) {
            // eslint-disable-next-line no-console
            console.log(error);
        }
    }

    workType = { 'sobjectType': 'WorkType' };
    workTypeId;

    setWorkTypeInput(event) {
        if (event.target.name === 'workType') {
            this.workType.Name = event.target.value;
        }
        else if (event.target.name === 'description') {
            this.workType.Description = event.target.value;
        }
        else if (event.target.name === 'estimatedDuration') {
            this.workType.EstimatedDuration = event.target.value;
        }
        else if (event.target.name === 'durationType') {
            this.workType.DurationType = event.target.value;
        }
        else if (event.target.name === 'shouldAutoCreateSvcAppt') {
            this.workType.ShouldAutoCreateSvcAppt = event.target.checked;
        }
    }

    handleSaveWorkType() {
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        const boxValid = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (!allValid && !boxValid) {
            // eslint-disable-next-line no-alert
            alert('Please update the invalid form entries and try again.');
            return;
        }
        saveWorkType({ workType: this.workType })
            .then(result => {
                this.workType = {};
                this.workTypeId = JSON.stringify(result);
                // Show success messsage
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Work Type Created Successfully!!',
                    variant: 'success'
                }));
                this.nextStep();
            })
            .catch(error => {
                // Show error messsage
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error'
                }));
            });
    }

    stepValue;
    nextStep() {
        this.stepValue = 2;
        // Creates the event with the data next step.
        const selectedEvent = new CustomEvent("stepvaluechange", {
            detail: this.stepValue
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        // Creates the event with the data workTypeId.
        const selectedEvent2 = new CustomEvent("setworktypeid", {
            detail: this.workTypeId
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent2);
    }

}