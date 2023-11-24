import { LightningElement,api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['Status'];
export default class ElderlyCareCasePath extends LightningElement {
    @api recordId; // The Case record Id
    currentStatus; // Current case status
    pathSteps = [
        { label: 'Not Started', value: 'Not Started' },
        { label: 'In Progress', value: 'In progress' },
        { label: 'Deferred', value: 'Deferred' },
        { label: 'Declined by Client', value: 'Declined by Client' },
        { label: 'Declined by Carer', value: 'Declined by Carer' },
        { label: 'Completed', value: 'Completed' },
        
    ];

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredCase({ error, data }) {
        if (data) {
            this.currentStatus = data.fields.Status.value;
        } else if (error) {
            // Handle error
        }
    }
}