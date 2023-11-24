import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import geteventRecord from '@salesforce/apex/ElderlyCare.getEventValue';

export default class ElderlyCareRecordViewForm extends LightningElement {
    
    

    activeSections = ['A', 'C'];
    activeSectionsMessage = '';

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
          this.urlId = currentPageReference.attributes.recordId;
          console.log('urlId :'+JSON.stringify(this.urlId));
       }
    }

    @track eventRecord;
    @track eventRecordError;

    @track ownerName;

    @wire(geteventRecord, { recid: '$urlId'})
    wiredAccount({ error, data }) {
        if (data) {
            this.eventRecord = data;
            console.log('eventRecord Form :'+JSON.stringify(this.eventRecord));
            var subject = data.Subject;
            this.ownerName = data.Owner.Name;
            //var clientName = data.Account.Name;
            var careType = data.Care_Type__c;
            var status = data.Status__c;
           // var declinedBy = data.User__r.Name; 

            console.log('subject :'+subject);
            console.log('ownerName :'+this.ownerName);
            this.eventRecordError = undefined;
        } else if (error) {
            this.eventRecordError = error;
            console.log('eventRecordError Form :'+JSON.stringify(this.eventRecordError));
            this.eventRecord = undefined;
        }
    } 
}