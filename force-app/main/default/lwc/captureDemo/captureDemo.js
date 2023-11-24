import { LightningElement,track,wire,api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import saveCapturedImage from '@salesforce/apex/ElderlyCare.saveImageFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//import saveImageFile from '@salesforce/apex/'

let dataURL,convertedDataURI,imageData;

export default class CaptureDemo extends LightningElement {

  @api recordId;
  @track urlId;
  @track isStartVideoButton = true;
  @track isStopVideoButton = true;
  @track isCaptureButton = false;
@track showImagePlace = false;
  @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
          this.urlId = currentPageReference.attributes.recordId;
          console.log('urlId :'+JSON.stringify(this.urlId));
       }
    }  

    //Capure Functionality
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
               this.videoElement.srcObject = await navigator.mediaDevices.getUserMedia({video:{facingMode: "environment"  } , audio: false});
               this.showImagePlace = true
           } catch (error) {
               console.error('Error accessing the camera: ', JSON.stringify(error));
           }
       } else {
           console.error('getUserMedia is not supported in this browser');
       }
   }
   
   async captureImage() {
    const imageNAme = prompt('Enter the File Name');
    const imageDescription = prompt('Enter th eFile Description');
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

    
        if(imageNAme === null && imageDescription ===null){
            alert('Please Enter Valid Inputs');
        } else {
            saveCapturedImage({imageUrl: convertedDataURI,recordId : this.urlId,imagetitle :imageNAme ,imageDescription:imageDescription})
        .then(result => {
            //this.stopCamera();
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
            console.log('Capture Error:::'+JSON.stringify(error));
            
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
        this.showImagePlace = false;
       const imageElement = this.template.querySelector('.imageElement');
       imageElement.setAttribute('src', "");
       imageElement.classList.add('slds-hide');
       imageElement.classList.remove('slds-show');
   }
}