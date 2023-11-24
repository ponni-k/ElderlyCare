import { LightningElement,api,track,wire } from 'lwc';
import getEventDetails from '@salesforce/apex/ElerlyCareShowCreatedEventToRelation.getCreatedEvent';
import saveFeedBack from '@salesforce/apex/ElerlyCareShowCreatedEventToRelation.getSubmitFeedBack';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';



export default class ElderlyCareShowEventForRelatedContact extends LightningElement {

    @track eventDetails = []; 
    card=[];
    feedback=[];
    @track eventError;
    @track isModalOpen = false;
    @track isCompleted = true;  
    @track servicecount;
    @track hasRelatedAccount;

    constructor(){
        super();
    }
    
    @wire(getEventDetails)
    wiredEvent({error, data }) {
        let tempEventInfo = [];
        if (data) { 
            console.log('if runs')
            this.eventDetails = data; 
            debugger;
             for(var i=0;i<=this.eventDetails.length;i++){
                let row={}; 
               if(this.eventDetails[i]) {   
                console.log('inside if');   
                row.Id=this.eventDetails[i].Id;
                row.ActivityDate=this.eventDetails[i].ActivityDate;
                row.eventSubject=this.eventDetails[i].Subject;
                row.EndDate=this.eventDetails[i].EndDate;
                row.Status=this.eventDetails[i].Status__c;
                    if(this.eventDetails[i].Time_Sheet__r){
                        row.TimesheetName=this.eventDetails[i].Time_Sheet__r.Name;
                        row.timeSheetFeedBack=this.eventDetails[i].Time_Sheet__r.Feedback__c;
                    }
                    if(this.eventDetails[i].Service_Items__r){
                        row.ServiceName=this.eventDetails[i].Service_Items__r.Name;
                    }
                    if(this.eventDetails[i].Owner){
                        row.OwnerName=this.eventDetails[i].Owner.Name
                    }
                    tempEventInfo.push(row);
               }
                else{
                    console.log('else runs')
                    this.feedback=  tempEventInfo;
                    this.servicecount=this.feedback.length;
                }
                
               }
            }
            
    }   
    handleCreateFeedBack(event){
        this.isModalOpen = true;
        this.eventId = event.target.value;
    }
    handleCloseFeedbackForm(){
        this.isModalOpen = false;
    }

    @track receivedMessage;
    handleMessage(event){
        this.receivedMessage = event.detail;
    }
    handleComments(event){
        this.comments = event.target.value;
    }
 
    @track ratingvalues;

    handleSubmitFeedBack(){
        saveFeedBack({eventid : this.eventId,rating :this.receivedMessage, comments :this.comments})
        .then(result => {
                this.feedbackresult = result;
                this.feedbackerror = undefined;
                this.receivedMessage = null;
                location.reload();
                refreshApex(this.wiredEvent); 
                this.comments = null;
                this.isModalOpen = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'FeedBack Submited SuccessFully',
                        variant: 'success',
                    }),
                );
        })
        .catch(error => {
            //console.log('Errorured:- '+error.body.message);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: 'Error While Submitting FeedBack',
                    variant: 'error',
                }),
            );
        });
    }
}