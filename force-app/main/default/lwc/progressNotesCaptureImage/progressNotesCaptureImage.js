import { LightningElement,api,track,wire } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import getProgressNotesRecords from '@salesforce/apex/ElderlyCareProgressNotes.getProgressNotesRecord';
import saveDutyNotesImage from '@salesforce/apex/ElderlyCareProgressNotes.saveAttachementsInProgressNotes';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import progressNotesBG from '@salesforce/resourceUrl/progressNotesBG';
let dataURL, convertedDataURI, convertedDataURI1; //holds image data

export default class ProgressNotesCaptureImage extends LightningElement {
    @api recordId;

    @track urlId;
    @track isStartVideoButton = true;
    @track isStopVideoButton = true;
    @track isCaptureButton = false;
    @track showImagePlace = false;  
    @track isStopButton = true;
    progressNotesBG = progressNotesBG;


    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('currentPageReference-->' + JSON.stringify(currentPageReference));
            this.urlId = currentPageReference.attributes.recordId;
            console.log('urlId :' + JSON.stringify(this.urlId));
        }
    }

    @track timeSheetNameData;
    @track progressRecordId;
    @track carerNameDate;
    @track clientNameDate;
    @track dutyDate;
    @track serviceNameDate;
    @track statusData;
    @track serviceDescriptionData;


    @wire(getProgressNotesRecords, {getEventId: '$urlId'})
    wiredPathList({ data, error }) {
        if (data) {
            console.log('Progress Notes Result:'+JSON.stringify(data));
            this.timeSheetNameData= data[0].Time_Sheet__r.Name;
            this.progressRecordId = data[0].Id;
            console.log('progressRecordId :'+this.progressRecordId);
            // console.log('timeSheetNameData : '+this.timeSheetNameData);
            this.carerNameDate = data[0].Carer_Name__c;
            this.clientNameDate = data[0].Client_Name__c;
            console.log('carerNameDate : '+this.carerNameDate);
            this.dutyDate= data[0].Progress_Date__c;
            console.log('dutyDate : '+this.dutyDate);
            this.serviceNameDate= data[0].Service_Name__c;
            console.log('serviceNameDate : '+this.serviceNameDate);
            this.statusData = data[0].Duty_Notes__c;
            console.log('statusData : '+this.statusData);
            this.serviceDescriptionData = data[0].Service_Description__c;
            console.log('serviceDescriptionData : '+this.serviceDescriptionData);
        } else if (error) {
            console.log('pro error : '+JSON.stringify(error));
        }
    }

    videoElement;
    canvasElement;

    renderedCallback() {
        this.videoElement = this.template.querySelector('.videoElement');
        this.canvasElement = this.template.querySelector('.canvas');
    }

    async initCamera() {
        this.showImagePlace = true;
        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
            try {
                this.isCaptureButton = true;
                this.isStopButton = true;
                this.videoElement.srcObject = await navigator.mediaDevices.getUserMedia({
                    video: {
                        facingMode: "environment"
                    },
                    audio: false
                });
                this.showImagePlace = true
            } catch (error) {
                console.error('Error accessing the camera: ', JSON.stringify(error));
            }
        } else {
            console.error('getUserMedia is not supported in this browser');
        }
    }


    async captureImage() {
        // const imageNAme = prompt('Enter the File Name');
        // const imageDescription = prompt('Enter th eFile Description');
        if (this.videoElement && this.videoElement.srcObject !== null) {
            this.canvasElement.height = this.videoElement.videoHeight;
            this.canvasElement.width = this.videoElement.videoWidth;
            const context = this.canvasElement.getContext('2d');
            context.drawImage(this.videoElement, 0, 0, this.canvasElement.width, this.canvasElement.height);
            const imageData = this.canvasElement.toDataURL('image/png');
            convertedDataURI1 = imageData.replace(/^data:image\/(png|jpg);base64,/, "");
            const imageElement = this.template.querySelector('.imageElement');
            //console.log('convertedDataURI ::' + convertedDataURI1);
            imageElement.setAttribute('src', imageData);
            imageElement.classList.add('slds-show');
            imageElement.classList.remove('slds-hide');
            if (imageNAme === null && imageDescription === null) {
                alert('Please Enter Valid Inputs');
            } else {
                saveDutyNotesImage({
                    progressNotesId : this.progressRecordId,
                    imageUrl: convertedDataURI1,
                    imagetitle: imageNAme,
                    imageDescription: imageDescription
                })
                .then(result => {
                    this.showImagePlace = false;
                    const imageElement = this.template.querySelector('.imageElement');
                    imageElement.setAttribute('src', "");
                    imageElement.classList.add('slds-hide');
                    imageElement.classList.remove('slds-show');
                    console.log('success :'+JSON.stringify(result));
                    window.location.reload();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Images Uploaded Successfully',
                            variant: 'success',
                        }),
                    );
                })
                .catch(error => {
                    window.location.reload();
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please Enter Valid Input',
                        variant: 'success',
                    }),
                    console.log('error camere :'+JSON.stringify(error));
                })
            }
        }
    }

    async stopCamera() {
        this.isCaptureButton = false;
        const video = this.template.querySelector(".videoElement");
        video.srcObject.getTracks().forEach((track) => track.stop());
        video.srcObject = null;
        this.isModalOpen = false;
        this.hideImageElement();
    }

    hideImageElement() {
        this.showImagePlace = false;
        const imageElement = this.template.querySelector('.imageElement');
        imageElement.setAttribute('src', "");
        imageElement.classList.add('slds-hide');
        imageElement.classList.remove('slds-show');
    }

    @track imgName;
    @track imgDescription;
    @track convertedData;


    @api language = "en-US";
    value = "";

    handleInputChange(e) {
        this.value = e.detail;
        console.log('recognitation value :'+this.value);
    }
    
}