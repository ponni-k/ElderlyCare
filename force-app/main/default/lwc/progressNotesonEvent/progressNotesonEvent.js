import { LightningElement,track,api,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import saveSign from '@salesforce/apex/ElderlyCareProgressNotes.saveSign';
import getCarerList from '@salesforce/apex/ElderlyCareProgressNotes.getTimeSheetRecord';
import getServiceList from '@salesforce/apex/ElderlyCareProgressNotes.getServicesRecord';


//declaration of variables for calculations
let isDownFlag, 
    isDotFlag = false,
    prevX = 0,
    currX = 0,
    prevY = 0,
    currY = 0;            
let x = "#0000A0"; //blue color
let y = 1.5; //weight of line width and dot.       
let canvasElement, ctx; //storing canvas context
let attachment; //holds attachment information after saving the sigture on canvas
let dataURL,convertedDataURI; //holds image data
console.log('convertedDataURI :'+convertedDataURI)

export default class ProgressNotesonEvent extends LightningElement {
    @track isModalOpen = false;
    @api recordId;
    @track eventId;
    @track timeSheetDetails;
    @track error;
    @track timeSheetName;
    @track carerName;
    @track clientName;
    @track date;
    @track time;
    //@track isAddAdditionalervices = false;
    @track urlId;

    @track selectedItems;
    @track lstOptions=[];
    @track selectedOptions;
    @track timesheetRecord;
    @track carerRecord;
    @track clientRecord;
    @track currentTime;

    formatNumber(number) {
        return number.toString().padStart(2, '0');
    }
    handleCreateProgressNotes() {
        
    }
    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        this.isModalOpen = false;
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        //console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
          this.urlId = currentPageReference.attributes.recordId;
          console.log('event id :'+JSON.stringify(this.urlId));
       }
    }
    handleCreateProgressNotes(event){
        this.isModalOpen = true;
        this.eventId = event.target.value;
        console.log('eventId :'+this.eventId);
    }

    connectedCallback(){
        getCarerList({eventId:this.urlId})
        .then(result => {
            this.timeSheetDetails = result;
            console.log('timeSheetDetails :'+JSON.stringify(this.timeSheetDetails));
            this.timeSheetName = result[0].Name;
            this.timesheetRecord = result[0].Id;
            console.log('timesheetRecord :'+this.timesheetRecord)
            console.log('timeSheetName :'+this.timeSheetName)
            this.carerRecord = result[0].Carer_Name__c;
            console.log('carerRecord :'+this.carerRecord)
            this.carerName = result[0].Carer_Name__r.Name;
            console.log('carerName :'+this.carerName)
            this.clientName = result[0].Account_Name__r.Name;
            console.log('clientName :'+this.clientName)
            this.clientrecord = result[0].Account_Name__c;;
            console.log('clientrecord :'+this.clientrecord)
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            console.log('TImesheetDetails Error -->'+JSON.stringify(error));
            this.timeSheetDetails = undefined;
        });

        

        // getServiceList({timesheetId:this.urlId})
        // .then(result => {
        //     this.selectedItems = result;

        //     console.log('selectedItems :'+JSON.stringify(this.selectedItems));
        //         for (var key in this.selectedItems) {
        //             //this.lstOptions.push(key);
        //             this.lstOptions.push({
        //             label : key,
        //             value: key
        //         });
        //     }
        //     console.log('lstOptions :'+JSON.stringify(this.lstOptions));
        // this.selectedOptions=(this.lstOptions);
        // console.log('selectedOptions :'+JSON.stringify(this.selectedOptions));
        // })
        // .catch(error => {
        //     this.error = error;
        //     console.log('services Error -->'+JSON.stringify(error));
        //     this.timeSheetDetails = undefined;
        // });
    }

    //event listeners added for drawing the signature within shadow boundary
    constructor() {
        super();
        this.template.addEventListener('mousemove', this.handleMouseMove.bind(this));
        this.template.addEventListener('mousedown', this.handleMouseDown.bind(this));
        this.template.addEventListener('mouseup', this.handleMouseUp.bind(this));
        this.template.addEventListener('mouseout', this.handleMouseOut.bind(this));
    }

    //retrieve canvase and context
    renderedCallback(){
        canvasElement = this.template.querySelector('canvas');
        //ctx = canvasElement.getContext("2d");
    }
    
    //handler for mouse move operation
    handleMouseMove(event){
        this.searchCoordinatesForEvent('move', event);      
    }
    
    //handler for mouse down operation
    handleMouseDown(event){
        this.searchCoordinatesForEvent('down', event);         
    }
    
    //handler for mouse up operation
    handleMouseUp(event){
        this.searchCoordinatesForEvent('up', event);       
    }

    //handler for mouse out operation
    handleMouseOut(event){
        this.searchCoordinatesForEvent('out', event);         
    }
    
    //clear the signature from canvas
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

    //This method is primary called from mouse down & move to setup cordinates.
    setupCoordinate(eventParam){
        //get size of an element and its position relative to the viewport 
        //using getBoundingClientRect which returns left, top, right, bottom, x, y, width, height.
        const clientRect = canvasElement.getBoundingClientRect();
        prevX = currX;
        prevY = currY;
        currX = eventParam.clientX -  clientRect.left;
        currY = eventParam.clientY - clientRect.top;
    }

    //For every mouse move based on the coordinates line to redrawn
    redraw() {
        ctx.beginPath();
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(currX, currY);
        ctx.strokeStyle = x; //sets the color, gradient and pattern of stroke
        ctx.lineWidth = y;        
        ctx.closePath(); //create a path from current point to starting point
        ctx.stroke(); //draws the path
    }
    
    //this draws the dot
    drawDot(){
        ctx.beginPath();
        ctx.fillStyle = x; //blue color
        ctx.fillRect(currX, currY, y, y); //fill rectrangle with coordinates
        ctx.closePath();
    }

    handleSelectedServices(event){
        this.serviceName = event.target.value;
        console.log('service Name :'+this.serviceName);
    }
    handleServiceDescription(event){
        this.serviceDescription = event.target.value;
        console.log('serviceDescription :'+this.serviceDescription);
    }
    handleSaveClick(){    
        ctx.globalCompositeOperation = "destination-over";
        ctx.fillStyle = "#FFF"; //white
        ctx.fillRect(0,0,canvasElement.width, canvasElement.height); 

        //convert to png image as dataURL
        dataURL = canvasElement.toDataURL("image/png");
        console.log('dataURL :'+dataURL);
        //convert that as base64 encoding
        convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        
        //call Apex method imperatively and use promise for handling sucess & failure
        saveSign({strSignElement: dataURL,recId : this.recordId})
            .then(result => {
                
                //this.ContentDocumentLink = result;
                //console.log('ContentDocumentId=' + this.ContentDocumentLink.ContentDocumentId);
                //show success message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Salesforce File created with Signature',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                //show error message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating Salesforce File record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    handleSaveProgresNotes(){
        this.canvasElement = this.template.querySelector('canvas');
        this.ctx = canvasElement.getContext("2d");
        console.log('ctx :'+JSON.stringify(this.ctx))
        dataURL = canvasElement.toDataURL("image/png");
        convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        console.log('convertedDataURI :'+convertedDataURI);
        console.log('convertedDataURI :'+convertedDataURI);
        
        saveProgressNotesDetials({timesheetRec : this.timesheetRecord,carerRecord : this.carerRecord ,clientrecord : this.clientrecord,serviceName :this.serviceName, serviceDescription : this.serviceDescription, strSignElement:dataURL})
        .then(result => {
            console.log('res passed' +result)
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
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
    }
}