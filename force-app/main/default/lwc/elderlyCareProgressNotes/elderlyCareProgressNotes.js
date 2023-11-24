import {LightningElement,api,track,wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//import saveSign from '@salesforce/apex/ElderlyCareProgressNotes.saveSign';
import {refreshApex} from '@salesforce/apex';
import getCarerList from '@salesforce/apex/ElderlyCareProgressNotes.getTimeSheetRecord';
//import getProgressNotesRecords from '@salesforce/apex/ElderlyCareProgressNotes.getProgressNotesRecord';
import saveDutyNotesImage from '@salesforce/apex/ElderlyCareProgressNotes.saveAttachementsInProgressNotes';
//import getServiceList from '@salesforce/apex/ElderlyCareProgressNotes.getServicesRecord';
import saveProgressNotesDetials from '@salesforce/apex/ElderlyCareProgressNotes.saveProgressNotes';
//import updateProgressStatus from '@salesforce/apex/ElderlyCareProgressNotes.updateProgressStatus';
//import updateServiceDescriptionValue from '@salesforce/apex/ElderlyCareProgressNotes.updateServiceDescriptionValue';
let dataURL, convertedDataURI, convertedDataURI1; //holds image data
let isDownFlag, 
isDotFlag = false,
prevX = 0,
currX = 0,
prevY = 0,
currY = 0;            
    
let x = "#0000A0";
let y = 1.5;      

let canvasElement, ctx; 
let attachment;
//let dataURL,convertedDataURI;

export default class ElderlyCareProgressNotes extends LightningElement {
@api recordId;
@track timeSheetDetails={};
@track error;
@track timeSheetName;
@track carerName;
@track clientName;
@track serviceName;
@track date;
@track time;
//@track isAddAdditionalervices = false;
@track urlId;

@track selectedItems;
@track lstOptions = [];
@track selectedOptions;
@track timesheetRecord;
@track carerRecord;
@track clientRecord;
@track serviceRecord;
@track currentTime;
@track progressRecordId;
@track progressNotesStatus;
@track progressNotesDescription;
@track isLoading = false;
@track progressNotesIdVal;
// @track isProgrogressNotesData = false;
@track isNoProgreeeData = false;
@track isModalOpen = false;
@track profileName;
@track isCameraBtn = true;

//Digital Signature

constructor() {
    super();
    this.template.addEventListener('mousemove', this.handleMouseMove.bind(this));
    this.template.addEventListener('mousedown', this.handleMouseDown.bind(this));
    this.template.addEventListener('mouseup', this.handleMouseUp.bind(this));
    this.template.addEventListener('mouseout', this.handleMouseOut.bind(this));
}
renderedCallback(){
    canvasElement = this.template.querySelector('canvas');
    ctx = canvasElement.getContext("2d");
}
handleMouseMove(event){
    this.searchCoordinatesForEvent('move', event);      
}
handleMouseDown(event){
    this.searchCoordinatesForEvent('down', event);         
}
handleMouseUp(event){
    this.searchCoordinatesForEvent('up', event);       
}
handleMouseOut(event){
    this.searchCoordinatesForEvent('out', event);         
}
handleSaveClick(){    
    ctx.globalCompositeOperation = "destination-over";
    ctx.fillStyle = "#FFF"; //white
    ctx.fillRect(0,0,canvasElement.width, canvasElement.height); 
    dataURL = canvasElement.toDataURL("image/png");
    convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
}

handleClearClick(){
    ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);          
}

searchCoordinatesForEvent(requestedEvent, event){
    event.preventDefault();
    if (requestedEvent === 'down') {
        this.setupCoordinate(event);           
        isDownFlag = true;
        isDotFlag = true;
        if (isDotFlag) {
            this.drawDot();
            isDotFlag = false;
        }
    }
    if (requestedEvent === 'up' || requestedEvent === "out") {
        isDownFlag = false;
    }
    if (requestedEvent === 'move') {
        if (isDownFlag) {
            this.setupCoordinate(event);
            this.redraw();
        }
    }
}
setupCoordinate(eventParam){
    const clientRect = canvasElement.getBoundingClientRect();
    prevX = currX;
    prevY = currY;
    currX = eventParam.clientX -  clientRect.left;
    currY = eventParam.clientY - clientRect.top;
}

redraw() {
    ctx.beginPath();
    ctx.moveTo(prevX, prevY);
    ctx.lineTo(currX, currY);
    ctx.strokeStyle = x;
    ctx.lineWidth = y;        
    ctx.closePath();
    ctx.stroke(); 
}

drawDot(){
    ctx.beginPath();
    ctx.fillStyle = x;
    ctx.fillRect(currX, currY, y, y);
    ctx.closePath();
}
    

//End


connectedCallback() {
    getCarerList({eventId: this.urlId})
        .then(result => {
            console.log('result :'+JSON.stringify(result));
            this.inputClass = 'red-text';
            // this.isProgrogressNotesData = false;
            this.isNoProgreeeData = true
            this.timeSheetDetails = result;
            // const timeSheetValues = JSON.stringify(this.timeSheetDetails);
            // console.log('timeSheetValues :'+this.timeSheetValues);
            // this.profileName = Object.values(result);
            //     console.log('profileName :'+this.profileName);

            this.timeSheetName = result[0].timesheetName;
            this.timesheetRecord = result[0].timeSheetId;
            this.carerRecord = result[0].carerId;
            this.carerName = result[0].carerName;
            this.clientName = result[0].clientName;
            this.clientrecord =result[0].clientId;
            if(result[0].seviceName==null){
                this.serviceName = result[0].clientServiceName;
            }else {
                this.serviceName = result[0].seviceName;
            }
                
            
           
            this.serviceRecord = result[0].serviceId;
            this.progressNotesIdVal = result[1].progressNotesValue;
            console.log('progressNotesIdVal # ::::'+ this.progressNotesIdVal);
            // console.log('carerName # ::::'+ this.carerName);
            // if(this.progressnotesIdval === null){
            //     this.isCameraBtn = false;
            //     console.log('null id');
            // } else {
            //     this.isCameraBtn = false;
            //     console.log('value is there');
            // }
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            console.log('TImesheetDetails Error -->' + JSON.stringify(error));
            this.timeSheetDetails = undefined;
        });
}




handleSelectedServices(event) {
    this.serviceName = event.target.value;
    console.log('service Name :' + this.serviceName);
}
// handleServiceDescription(event) {
//     this.serviceDescription = event.target.value;
//     console.log('serviceDescription :' + this.serviceDescription);
// }

@track urlId;
@track isStartVideoButton = true;
@track isStopVideoButton = true;
@track isCaptureButton = false;
@track showImagePlace = false;
@track isStopButton = true;
@wire(CurrentPageReference)
getStateParameters(currentPageReference) {
    if (currentPageReference) {
        console.log('currentPageReference-->' + JSON.stringify(currentPageReference));
        this.urlId = currentPageReference.attributes.recordId;
        console.log('urlId :' + JSON.stringify(this.urlId));
    }
}

@track steps = [{
        label: 'Not Started',
        value: 'step-1'
    },
    {
        label: 'Initial Assessment',
        value: 'step-2'
    },
    {
        label: 'In Progress',
        value: 'step-3'
    },
    {
        label: 'On Hold',
        value: 'step-4'
    },
    {
        label: 'Completed',
        value: 'step-5'
    },
];




@track progressNotesStatus = '';

@track currentvalue;
@track progressNotesData;

@track timeSheetNameData;
@track carerNameDate;
@track dutyDate;
@track serviceNameDate;
@track statusData;
//@track serviceDescriptionData;
@track clientNameDate;

@track proId;

@api inputClass = '';


// voice
@api language = "en-US";
@track value = "";

handleInputChange(e) {
    this.value = e.detail;
    console.log('voiceValue--->'+this.value);
}




get dutyProgressOptions() {
    return [
        {
            label: 'Not Started',
            value: 'Not Started'
        },
        {
            label: 'Initial Assessment',
            value: 'Initial Assessment'
        },
        {
            label: 'In Progress',
            value: 'In Progress'
        },
        {
            label: 'On Hold',
            value: 'On Hold'
        },
        {
            label: 'Completed',
            value: 'Completed'
        },
    ];
}
@track dutyProgressStatus='';
handleDutyProgress(event) {
    this.dutyProgressStatus = event.target.value;
    console.log('dutyProgressStatus :'+this.dutyProgressStatus);
}

@track checklistValues;
@track selectedValues=[];
    handleChecklistValues(event){
    this.checklistValues = event.detail;
    this.selectedValues= JSON.stringify(this.checklistValues);
    
}


@track imgName;
@track imgDescription;
@track convertedData;
@track signValue;
@track childValue;

@track valueFromCanvas = '';

handleCanvasChange(event) {
    this.valueFromCanvas ='data:image/png;base64,'+ event.detail;
    console.log('valueFromCanvas ::'+this.valueFromCanvas);
}



handleSaveProgresNotes() {
    this.childValue =  this.template.querySelector("c-signature-capture").handleCanvasChange();
    if (this.dutyProgressStatus == null && this.dutyProgressStatus == '') {
        LightningAlert.open({
            message: 'Fields Should Not Be Blank',
            theme: "error",
            label: "Error!"
        });
    } else {
        saveProgressNotesDetials({
                timesheetRec: this.timesheetRecord,
                carerRecord: this.carerRecord,
                clientrecord: this.clientrecord,
                serviceRecord: this.serviceRecord,
                serviceDescription: this.value,
                dutyNotesStatus: this.dutyProgressStatus,
                strSignElement : this.valueFromCanvas,
                selectedChecklistValues: this.selectedValues
            })
            .then(result => {
                console.log('progress Notes Result id ::::' + JSON.stringify(result));
                this.proId = result[0].Id;
                console.log('proId :' + this.proId);
                //console.log('res passed' + result);
                //window.location.reload();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Progress Notes Created SuccessFully',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                console.error('Error retrieving records:', JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error While Creating Progress Notes',
                        message: 'Fields Should Not be Blank.',
                        variant: 'error',
                    }),
                );
            });
    }
}
@track imageTitle = '';
@track imageDescription ='';
@track showImageTitle = false;

handleTitle(event){
    this.imageTitle = event.target.value;
    console.log(this.imageTitle)
}
handleDescription(event){
    this.imageDescription = event.target.value;
    console.log(this.imageDescription)
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
        this.showImageTitle = true;
    }
}

async stopCamera() {
    this.isCaptureButton = false;
    const video = this.template.querySelector(".videoElement");
    video.srcObject.getTracks().forEach((track) => track.stop());
    video.srcObject = null;
    this.isModalOpen = false;
    this.hideImageElement();
    this.showImageTitle = false;
}

hideImageElement() {
    this.showImagePlace = false;
    const imageElement = this.template.querySelector('.imageElement');
    imageElement.setAttribute('src', "");
    imageElement.classList.add('slds-hide');
    imageElement.classList.remove('slds-show');
}

handleSaveImage(){
    if(!this.imageTitle==''&& !this.imageTitle== null && this.imageDescription=='' && this.imageDescription==null){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Fields should Not Be Blank',
                variant: 'error',
            })
        );
    }  else {
        saveDutyNotesImage({
            progressNotesId : this.progressNotesIdVal,
            imageUrl: convertedDataURI1,
            imagetitle: this.imageTitle,
            imageDescription: this.imageDescription
        })
        .then(result => {
            this.showImagePlace = false;
            const imageElement = this.template.querySelector('.imageElement');
            imageElement.setAttribute('src', "");
            imageElement.classList.add('slds-hide');
            imageElement.classList.remove('slds-show');
            console.log('success---------------> :'+JSON.stringify(result));
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
            console.log('error camera---------------> :'+JSON.stringify(error));
        })
    }
}

handleClearClick(){
    this.dutyProgressStatus = '';
    this.value = "";
    this.childValue =  this.template.querySelector("c-signature").handleClearClick();
}
}