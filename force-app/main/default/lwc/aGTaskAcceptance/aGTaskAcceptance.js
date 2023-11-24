import { LightningElement, wire,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateStatus from '@salesforce/apex/ElderlyCare.updateStatusEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import geteventRecord from '@salesforce/apex/ElderlyCare.getEventValue';
import declineEvent from '@salesforce/apex/ElderlyCare.updateStatusEvent';
import updateClockRecord from '@salesforce/apex/ElderlyCare.createClockInRecord';
import saveCapturedImage from '@salesforce/apex/ElderlyCare.saveImageFile';
import LightningAlert from "lightning/alert";
import { refreshApex } from '@salesforce/apex';
import { refreshPage } from 'lightning/navigation';


let dataURL,convertedDataURI,imageData;

export default class AGTaskAcceptance extends LightningElement {
    @api recordId;
    urlId = null;
    @track isLoading = false;
    @track hideClockIn = false;
    @track hideAcceptButton = true;
    @track isdisableDecline = false;
    @track eventStartTime;
    @track startDate;
    @track evtStartTime;
    @track evtEndTime;
    @track frmtStartTime;
    @track frmtEndTime;
    @track currentLatitude;
    @track currentLongtitude;


    @track isAcceptButton = true;
    @track isClockInButton = false;
    @track isClockOutButton = false;
    @track isDeclineButton = true;
    @track isStartVideoButton = false;
    @track isStopVideoButton = false;
    @track isCaptureButton = false;
    @track isStatusCompleted = false;

    @track eventTIme;

    @track checklistValues;
    handleChecklistValues(event){
    this.checklistValues = event.detail;
    console.log('checklistValues@@:  '+this.checklistValues);
    } 

    connectedCallback(){
        //console.log('connected callback run :'+this.urlId);
        geteventRecord({recid: this.urlId})
        .then(result => {
            this.eventRecord = result;
            this.eventStatusValue = result.Status__c;
            this.eventStartTime = result.StartDateTime;
            this.evtStartTime = result.Time_Sheet__r.Start_Time__c;
            this.evtEndTime = result.Time_Sheet__r.End_time__c;

            const stDate = new Date(this.evtStartTime);
            const sthrs = stDate.getUTCHours().toString().padStart(2, '0');
            const stmins = stDate.getUTCMinutes().toString().padStart(2, '0');
            const stsecs = stDate.getUTCSeconds().toString().padStart(2, '0');
            this.frmtStartTime = `${sthrs}:${stmins}:${stsecs}`;
            const endDate = new Date(this.evtEndTime);
            const edhrs = endDate.getUTCHours().toString().padStart(2, '0');
            const edmins = endDate.getUTCMinutes().toString().padStart(2, '0');
            const edsecs = endDate.getUTCSeconds().toString().padStart(2, '0');
            this.frmtEndTime = `${edhrs}:${edmins}:${edsecs}`;


            const dateObj = new Date(this.eventStartTime);
            const hours = dateObj.getHours();
            const minutes = dateObj.getMinutes();
            const seconds = dateObj.getSeconds();

            const currentDate = new Date();
            const threeHoursAgo = new Date(currentDate);
            threeHoursAgo.setHours(currentDate.getHours() - 3);
            this.isdisableDecline = new Date(dateObj) < threeHoursAgo;

            this.eventTime = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            console.log('Time :'+this.eventTIme);

            const beforeThreeHours = dateObj.getHours()-3;
            const beforeThreeHoursminutes = dateObj.getMinutes();
            const beforeThreeHoursseconds = dateObj.getSeconds();
            this.eventTime = `${beforeThreeHours.toString().padStart(2, '0')}:${beforeThreeHoursminutes.toString().padStart(2, '0')}:${beforeThreeHoursseconds.toString().padStart(2, '0')}`;
            console.log('eventTime :'+this.eventTime);

            
            

            
            if(this.eventStatusValue =='Accepted'){
                this.isAcceptButton = false;
                this.isDeclineButton = false;
                this.isClockInButton = true;
                this.isStatusCompleted = false;
            } else if(this.eventStatusValue == 'In Progress') {
                this.isAcceptButton = false;
                this.isClockOutButton = true;
                this.isStartVideoButton = true;
                this.isStopVideoButton = true;
                this.isCaptureButton = false;
                this.isClockInButton = false;
                this.isDeclineButton = false;
                this.isStatusCompleted = false;

            } else if(this.eventStatusValue == 'Completed') {
                this.isAcceptButton = false;
                this.isClockOutButton = false;
                this.isClockInButton = false;
                this.isDeclineButton = false;
                this.isStatusCompleted = true;
            }
            //console.log('####eventRecord########-->'+JSON.stringify( this.eventRecord));
        })
        .catch(error => {
            this.eventError = error;
            //console.log('eventError :'+JSON.stringify(this.eventError));
            this.eventRecord = undefined;
        });
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        //console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
          this.urlId = currentPageReference.attributes.recordId;
          //console.log('urlId :'+JSON.stringify(this.urlId));
       }
    }


    @track acceptrecordError;
    @track acceptrecord;

    handleAcceptClick(event){
      var selectedButton = event.target.label;
        console.log('Selected Button :'+selectedButton);
        window.location.reload();
        this.handleIsLoading(true);
        updateStatus({ eventRecordId: this.urlId,selectedButton : selectedButton })
        .then(result => {
            console.log('res :'+JSON.stringify(result));
            this.acceptrecord = result;
            //refreshPage();
            window.location.reload();
            console.log('result : '+jSON.stringify(this.acceptrecord));
            //this.updateRecordView();
            this.acceptrecordError = undefined;
            this.handleIsLoading(false);
        })
        .catch(error => {
            this.hideClockIn  =true;
            this.acceptrecordError = error;
            console.log('error : '+JSON.stringify(error));
            this.acceptrecord = undefined;
        })
        .finally(()=>{
            this.handleIsLoading(false);
        });
    }

    handleIsLoading(isLoading) {
        this.isLoading = isLoading;
    }
    handleDeclineEvent(event) {
      var selectedButton = event.target.label;
      //console.log('Selected Button :'+selectedButton);
      //window.location.reload();
      this.handleIsLoading(true);

        //console.log('delete clicked')
        declineEvent({eventRecordId : this.urlId,selectedButton : selectedButton})
          .then(() => {
            window.location.reload();
            this.updateRecordView();
            this.dispatchEvent(
              new ShowToastEvent({
                title: 'Success',
                message: 'Event  Successfully Declined.',
                variant: 'success'
              })
            );
          })
          .catch(error => {
            this.err =error;
            //console.log('err :'+JSON.stringify(this.err));
            this.dispatchEvent(
              new ShowToastEvent({
                title: 'Error',
                message: 'An error occurred while removing the event.',
                variant: 'error'
              })
            );
          })
          .finally(()=>{
            this.handleIsLoading(false);
        });
      }

      updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
     }
     @track ClockButtonLabel;
     @track clockstatus;

    handleClockEvent(event){
       // this.ClockButtonLabel = null;
       this.handleIsLoading(true);
        this.ClockButtonLabel = event.target.label; 
        console.log('ClockButtonLabel :'+this.ClockButtonLabel);
        //window.location.reload();
        this.handleIsLoading(true);
        updateClockRecord({ eventRecordId: this.urlId , Buttonlabel:this.ClockButtonLabel})
        .then(result => {
            window.location.reload();
            this.handleIsLoading(false);
            this.clockstatus = result;
            console.log('status :'+this.clockstatus);
        })
        .catch(error => {
            LightningAlert.open({
                message: 'Please complete the Progress Notes',
                theme: "error",
                label: "Error!"
            });
           console.log('clock status error:'+JSON.stringify(error));
           this.handleIsLoading(true);
        })
        .finally(()=>{
            //window.location.reload();
            this.handleIsLoading(false);
        });
    }


     //Capure Functionality
     videoElement;
     canvasElement;
     @track isModalOpen = false;
    renderedCallback() {
       this.videoElement = this.template.querySelector('.videoElement');
       this.canvasElement = this.template.querySelector('.canvas');
   }
   
   
   async initCamera() {
       if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
           try {
               this.isCaptureButton = true;
               this.videoElement.srcObject = await navigator.mediaDevices.getUserMedia({video:{facingMode: "environment"  } , audio: false});
           } catch (error) {
               console.error('Error accessing the camera: ', JSON.stringify(error));
           }
       } else {
           console.error('getUserMedia is not supported in this browser');
       }
   }
   
   async captureImage() {
       if(this.videoElement && this.videoElement.srcObject !== null) {
           this.canvasElement.height = this.videoElement.videoHeight;
           this.canvasElement.width = this.videoElement.videoWidth;
           const context = this.canvasElement.getContext('2d');
           context.drawImage(this.videoElement, 0, 0, this.canvasElement.width, this.canvasElement.height);
           const imageData = this.canvasElement.toDataURL('image/png');
           convertedDataURI = imageData.replace(/^data:image\/(png|jpg);base64,/, "");
           const imageElement = this.template.querySelector('.imageElement');
           console.log('convertedDataURI ::'+convertedDataURI);
           imageElement.setAttribute('src', imageData);
           imageElement.classList.add('slds-show');
           imageElement.classList.remove('slds-hide');


        saveCapturedImage({imageUrl: convertedDataURI,recordId : this.urlId})
        .then(result => {
            this.stopCamera();
          console.log('res:::'+JSON.stringify(result.message));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Signature Image saved in record',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            console.log('Capture Error:::'+JSON.stringify(error.message));
            
            //show error message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error uploading Image in Salesforce record',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
       }
   }
   
   async stopCamera(){
       this.isCaptureButton = false;
       const video = this.template.querySelector(".videoElement");
       video.srcObject.getTracks().forEach((track) => track.stop());
       video.srcObject = null;
       this.isModalOpen = false;
       this.hideImageElement();
   }
   
   hideImageElement(){
       const imageElement = this.template.querySelector('.imageElement');
       imageElement.setAttribute('src', "");
       imageElement.classList.add('slds-hide');
       imageElement.classList.remove('slds-show');
   }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
}