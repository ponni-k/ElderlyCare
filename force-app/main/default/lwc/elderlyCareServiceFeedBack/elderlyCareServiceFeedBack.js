import { LightningElement, api,track,wire} from 'lwc';
import getEventDetails from '@salesforce/apex/ElerlyCareShowCreatedEventToRelation.getCreatedEvent';
import saveFeedBack from '@salesforce/apex/ElerlyCareShowCreatedEventToRelation.getSubmitFeedBack';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ElderlyCareServiceFeedBack extends LightningElement {
    @track eventDetails;
    @track eventError;
    @track isModalOpen = false;
    @track isCompleted = true;  
    @track servicecount;
    @track hasRelatedAccount;
    ServiceToDisplay = [];
    @wire(getEventDetails)
    wiredEvent({ error, data }) {
        if (data) {
            var evtdetails=[];
            var activityservices;
            evtdetails = data;
             this.evtdetails.forEach(details => {
                activityservices.TimesheetName=details.Time_Sheet__r.Name;
                activityservices.OwnerName=details.Owner.Name;
                activityservices.Subject=details.Subject;
                activityservices.ServiceName=details.Service_Items__r.Name;
                activityservices.Status__c=details.Status__c
                activityservices.TimesheetFeedback=details.Time_Sheet__r.Feedback__c 
            })
            this.eventDetails.push(activityservices)
            console.log('The eventDetails costructor '+ JSON.stringify(this.eventDetails));
            this.servicecount = this.eventDetails.length;       
        }
        else{
          console.log('The data load error'+error);  
        }
    } 

}