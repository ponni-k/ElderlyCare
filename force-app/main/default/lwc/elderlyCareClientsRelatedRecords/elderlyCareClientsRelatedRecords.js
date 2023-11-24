import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

import { publish,subscribe,unsubscribe,createMessageContext,releaseMessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/RelatedRecordsChannel__c";
import getCLientRelatedRecords from '@salesforce/apex/ElderlyCareClientsRelatedRecords.getClientRelatedRecords';
import showRelatedRecords from '@salesforce/apex/ElderlyCareClientsRelatedRecords.getRelatedRecords';
import LightningModal from 'lightning/modal';

//import recordSelected from '@salesforce/messageChannel/AnotherMessageChannel__c';

const columns=[{label: 'Name', fieldName: 'Name'},];

const col=[{label: 'Name', fieldName: 'Name'},];

export default class ElderlyCareClientsRelatedRecords extends LightningElement {
    @track isModalOpen= false;

    columns = columns;
    col = col;
    hasMoreServiceItemsRecords = false;
    hasMoreIncidentRecords = false;
    hasMoreTimeSheetRecords = false;
    hasMoreContactRecords  =false;


    context = createMessageContext();

    constructor() {
        super();  
    }

    @track urlId;
 

   

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlId = currentPageReference.attributes.recordId;
          console.log('rec Id:'+this.urlId);
       }
    }

    
    @track data

    // @wire(getCLientRelatedRecords,{clientRecordId : this.urlId})
    // wiredData({ data, error }) {
    //     if (data) {
    //         this.data = data.lstContact;
    //         console.log('getCLientRelatedRecords res->'+JSON.stringify(data));
    //         this.error = undefined;
    //     } else if (error) {
    //         this.error = error;

    //         this.data = undefined;
    //     console.log('getCLientRelatedRecords error->'+JSON.stringify(error));}
    // }


    @track contactData;
    @track serviceItemData;
    @track timeSheetData;
    @track incidentsData;

    @track displayServiceItemsRecords;
    @track displayContactRecords;
    @track displayTimeSheetRecords;
    @track displayIncidentRecords;
    @track conId;
    @track serviceItemId;
    @track timesheetId;
    @track incidentId;

    connectedCallback(){    
        console.log('connectedCallback run')
        //this.subscribeMC();
 
         getCLientRelatedRecords({clientRecordId : this.urlId})
         .then(result =>{
            this.subscribeMC();
            let locResult = JSON.parse(JSON.stringify(result));

            this.contactData = locResult[0].lstContact;
            this.timeSheetData = locResult[1].lstTimeSheet;
            this.incidentsData = locResult[2].lstIncident;
            this.serviceItemData = locResult[3].lstService;

            this.conId =  this.contactData.map(obj => obj.Id);
            this.timesheetId =  this.timeSheetData.map(obj => obj.Id);
            this.serviceItemId =  this.serviceItemData.map(obj => obj.Id);
            this.incidentId =  this.incidentsData.map(obj => obj.Id);

            this.displayContactRecords = this.contactData.slice(0, 2);
            this.displayTimeSheetRecords = this.timeSheetData.slice(0, 2);
            this.displayServiceItemsRecords = this.serviceItemData.slice(0, 2);
            this.displayIncidentRecords = this.incidentsData.slice(0, 2);


            this.hasMoreContactRecords = this.displayContactRecords.length >2;
            this.hasMoreTimeSheetRecords = this.displayTimeSheetRecords.length >=2;
            this.hasMoreServiceItemsRecords = this.displayServiceItemsRecords.length >=2;
            this.hasMoreIncidentRecords = this.displayIncidentRecords.length >=2;
            
         })
         .catch(error=>{
             console.log('getCLientRelatedRecords error->'+JSON.stringify(error));
         })
 
         
     }
     subscribeMC(){
         console.log('subscribeMC runs')
         if(this.subscription){
             return;
         }
         this.subscription = subscribe (this.context,SAMPLEMC,(message)=>{
             this.handleMessage(message);
         }, {scope:APPLICATION_SCOPE});
     }
 
     handleMessage(message){
         console.log('salesforceFeatures');
         console.log("message:::"+JSON.stringify(message));
         this.buttonValueId = message.pubButtonValue;
 
         var btnLbl;
 
         if(this.buttonValueId =='Contact'){
             btnLbl = 'Contact';
         } else if(this.buttonValueId =='Service Items'){
             btnLbl = 'ServiceItems';
         } else if(this.buttonValueId =='Time Sheet'){
             btnLbl = 'TimeSheet';
         } else if(this.buttonValueId =='Incident'){
             btnLbl = 'Incident';
         }
         const targetDiv = this.template.querySelector('.'+btnLbl);
         console.log('targetDi :'+JSON.stringify(targetDiv));
         const targetDivPosition = targetDiv.getBoundingClientRect().top;
         console.log('targetDivPosition :'+targetDivPosition);
 
         // Scroll to the position of the target div
         window.scrollTo({ top: targetDivPosition, behavior: 'smooth' });
     }

     @track viewAllBtn;
     @track clientResponseData;

     handleViewAll(event){
        console.log('handleViewAll clicked')
        this.viewAllBtn = event.target.title;
        console.log('ViewAllBtn :'+this.viewAllBtn)

        this.buttonValue;
        if(this.viewAllBtn =='Contact'){
            this.buttonValue = this.conId;
        } else if(this.viewAllBtn =='Service Items'){
            this.buttonValue = this.serviceItemId;
        }  else if(this.viewAllBtn =='TimeSheet'){
            this.buttonValue = this.timesheetId;
        }  else if(this.viewAllBtn =='Incident'){
            this.buttonValue = this.incidentId;
        }
        //console.log('buttonValue :'+this.buttonValue);
        showRelatedRecords({buttonLabel : this.viewAllBtn, clientIds: this.urlId})
       .then(result => {
        
            this.clientResponseData = result;
            console.log('clientResponseData :'+JSON.stringify(this.clientResponseData));
            this.isModalOpen = true;
       })
       .catch(error => {
           console.log('Errorured:- '+error.body.message);
       });
    }

    handleCloseModalPopup(){
        this.isModalOpen = false;
    }
}