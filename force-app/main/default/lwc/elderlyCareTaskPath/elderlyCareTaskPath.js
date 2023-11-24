import { LightningElement,track,wire,api } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getTaskRecord from '@salesforce/apex/ElderlyCareTaskPath.getTaskList';
import updateTaskStatus from '@salesforce/apex/ElderlyCareTaskPath.updateTaskStatus';

export default class ElderlyCareTaskPath extends LightningElement {
    @track urlId;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('currentPageReference-->' + JSON.stringify(currentPageReference));
            this.urlId = currentPageReference.attributes.recordId;
            console.log('urlId :' + JSON.stringify(this.urlId));
        }
    }
     
    @track pathSteps = [
        { label: 'Not Started', value: 'Not Started' },
        { label: 'In Progress', value: 'In progress' },
        { label: 'Deferred', value: 'Deferred' },
        { label: 'Declined by Client', value: 'Declined by Client' },
        { label: 'Declined by Carer', value: 'Declined by Carer' },
        { label: 'Completed', value: 'Completed' },
        
    ];
    @api recordId; // The Task record Id
   taskStatus;  // The Task current status
    @wire(getTaskRecord,{TaskId: '$urlId'})
    wiredTask({error, data}){
        if(data){
            this.taskStatus = data[0].Status;
            console.log(' Task Status :' +this.taskStatus);
        }
        else if(error){
            console.log('Task Status error : '+JSON.stringify(error));
        }
    }
    pathHandler(event) {
        this.isLoading = true;
       let targetValue = event.currentTarget.value;
      console.log('targetValue :'+targetValue);
         let selectedvalue = event.currentTarget.label;
        console.log('selectedvalue :'+selectedvalue);
 
        this.currentvalue = targetValue;
         this.selectedvalue = selectedvalue;
         updateTaskStatus({TaskId :this.urlId,Status : this.selectedvalue})
              .then(result => {
                 // Handle the result from the server
              console.log(' :::'+result);
                refreshApex(this.wiredTask);
                this.isLoading = true;
           })
             .catch(error => {
                  // Handle errors
                  this.isLoading = true;
                  console.log(' Error:::'+JSON.stringify(error)); 
                  console.error(error);
             });
      }       

}