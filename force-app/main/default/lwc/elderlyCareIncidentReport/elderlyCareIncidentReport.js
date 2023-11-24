import { LightningElement,track,api,wire } from 'lwc';
import getIncidentReportDetails  from '@salesforce/apex/ElderlyCareIncidentReport.getIncidentRecords';
import insertIncident  from '@salesforce/apex/ElderlyCareIncidentReport.insertIncidentReport';
import getIncidentVal from '@salesforce/apex/ElderlyCareIncidentReport.getIncidentValue';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import incidentUpdatedValues from '@salesforce/apex/ElderlyCareIncidentReport.updateIncidentValue';
import updatedIncidentValue from '@salesforce/apex/ElderlyCareIncidentReport.updateIncidentValue';

const columns = [
    { label: 'Subject', fieldName: 'Subject__c' },
    { label: 'Client', fieldName: 'Client_Name__c',},
    { label: 'Piority', fieldName: 'Priority__c',},
    { label: 'Status', fieldName: 'Status__c',},
];



export default class ElderlyCareIncidentReport extends LightningElement {


    @track isLoaded = false;
    @track data =[];
    columns = columns;
    @track subject;
    @track email;
    @track status;
    @track phone;
    @track Type;
    @track priority;
    @track selectedClientrecord;
    @track dateandtime;
    @track reportCheck ='';
    @track description;
    @track incidentData;
    @track isAdminOrNot;
    @track isModalOpen = false;
    @track incidentSubject;
    @track incidentClient;
    @track incidentPriority;
    @track incidentStatus;
    @track incidentStatus;
    @track incidentIdval
    @track incidentdata;
    @track buttonValue ='Edit';
    @track visibleRecords;
    @track userType;
    @track isClientContact;

    // connectedCallback() {
    //     this.buttonValue = 'Edit';
    // }

    @wire(getIncidentReportDetails)
    wiredRecords({ data, error }) {
        if (data) {
            //console.log('data : '+JSON.stringify(data));

            this.incidentdata = data;
            this.isLoaded = false;
            console.log('incidentdata :'+JSON.stringify(this.incidentdata.length));
            this.isAdminOrNot = data[0].isAdminorNot;
            this.userType = data[0].userType;
            console.log('userType :'+this.userType);
            if(this.userType =='Clients'){
                this.isClientContact = false;
            } else {
                this.isClientContact = true;
            }
            // console.log('isAdminOrNot : '+this.isAdminOrNot);
            // console.log('incidentSubject : '+this.incidentSubject);
            // console.log('incidentClient : '+this.incidentClient);
            // console.log('incidentPriority : '+this.incidentPriority);
            // console.log('incidentStatus : '+this.incidentStatus);
            // console.log('incidentIdval : '+this.incidentIdval);
        } else if (error) {
            this.isLoaded = false;
            console.error('Error fetching records:', error);
        }
    }

    updateIncidentHandler(event){
        this.visibleRecords=[...event.detail.records];
        //console.log('update Incident Record :'+JSON.stringify(this.visibleRecords));
        console.log(event.detail.records)
    }

    openIncidentForm() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    

    get statusOptions() {
        return [
            { label: 'New', value: 'New' },
            { label: 'In Progress', value: 'In Progress' },
            { label: 'On Hold', value: 'On Hold' },
            { label: 'Closed', value: 'Closed' },
        ];
    }

    get TypeOfIssue() {
        return [
            { label: 'Physical', value: 'Physical' },
            { label: 'Emergency', value: 'Emergency' },
            { label: 'Property Damage Or Loss', value: 'Property Damage Or Loss' },
            { label: 'Others', value: 'Others' },
        ];
    }
    
    get priorityOptions() {
        return [
            { label: 'High', value: 'High' },
            { label: 'Medium', value: 'Medium' },
            { label: 'Low', value: 'Low' },
        ];
    }

    get reportableIncident() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }

    handleSubject(event){
        this.subject = event.target.value;
        console.log('this.subject :'+this.subject);
    }

    handleEmail(event){
        this.email = event.target.value;
        console.log('this.email :'+this.email);
    }

    handleStatus(event){
        this.status = event.target.value;
        console.log('this.status :'+this.status);
    }

    handlePhone(event){
        this.phone = event.target.value;
        console.log('this.phone :'+this.phone);
    }

    handleType(event){
        this.Type = event.target.value;
        console.log('this.Type :'+this.Type);
    }

    handlePriority(event){
        this.priority = event.target.value;
        console.log('this.priority :'+this.priority);
    }
    
    handleClientChange(event){
        this.selectedClientrecord = event.detail.selectedRecord.Id;
        console.log('selectedClientrecord :'+this.selectedClientrecord);
    }

    handleDateandTime(event){
        this.dateandtime = event.target.value;
        console.log('this.dateandtime :'+this.dateandtime);
    }
    handleReportCheck(event){
        this.reportCheck = event.detail.value;
        console.log('this.handleReportCheck :'+this.reportCheck);
    }
    handleDescription(event){
        this.description = event.target.value;
        console.log('this.description :'+this.description);
    }

    submitIncident() { 
        this.isLoaded = true;
        insertIncident({subject:this.subject,
            email:this.email, 
            status:this.status, 
            phone:this.phone, 
            type:this.Type,
            priority:this. priority, 
            client:this.selectedClientrecord, 
            incidentdatetime:this. dateandtime, 
            incidentReport:this.reportCheck, 
            Description:this.description})
            .then(result => {
                console.log('saved');
                this.isLoaded = false;
                this.isModalOpen = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Incident Created SuccessFully',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.isLoaded = true;
                console.log('Incident Error :'+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error While Creating Incident Report',
                        variant: 'error',
                    }),
                );
                this.isModalOpen = true;
            });
    }
    @track isPreviewModal = false;
    @track incidentVal;

    @track incidentSubject;
    @track incidentCLientName;
    @track incidentStatus;
    @track incidentDescription;
    handlePreview(event){
        this.isPreviewModal = true;
        this.incidentVal = event.target.value;
        console.log('incidentVal :'+this.incidentVal);
    }
    submitPreviewButton(){
        this.isPreviewModal = false;
        
    }
    @track isPreview= true;
    @track isEditIncident = false;

    handlePreviewAndEdit(event){
        this.isLoaded = true
        this.incidentVal = event.target.value;
        //console.log('incidentVal :'+this.incidentVal);


        this.isPreviewModal = true;
        
        if(event.target.title =='Edit'){
            this.incidentVal =  event.target.value;
            console.log('in val :'+this.incidentVal);
            this.buttonValue = 'Edit'
            this.isPreview= false;
            this.isEditIncident = true;
        } 
        if(event.target.title == 'Close'){
            this.isPreviewModal = false;
        }

        

        getIncidentVal({incidentRecordId : this.incidentVal })
        .then(result => {
            this.recordData = result;
            console.log('recordData :'+JSON.stringify(this.recordData))
            this.incidentSubject  = result.subject;
            console.log('incidentSubject :'+JSON.stringify(this.incidentSubject))
            this.incidentCLientName  = result.clientName;
            console.log('incidentCLientName :'+JSON.stringify(this.incidentCLientName))
            this.incidentStatus  = result.status;
            console.log('incidentStatus :'+JSON.stringify(this.incidentStatus))
            this.incidentDescription  = result.description;
            console.log('incidentDescription :'+JSON.stringify(this.incidentDescription));
            this.isLoaded = false;

        })
        .catch(error => {
            this.isLoaded = true;
            console.error('Error fetching record', error);
        });
    }

    handleCloseEditIncident(){
        this.isPreviewModal = false;
    }

    handleUpdateIncidentRecords(){
        this.isLoaded = true;
        updatedIncidentValue({incidentRecordId : this.incidentVal,incidentStatus:this.status ,incidentSubject :this.subject,incidentDescription:this.description})
        .then(result => {
            this.incidentUpdatedValue = result;
            this.isLoaded = false
            console.log('incidentUpdatedValue :'+JSON.stringify(this.incidentUpdatedValue));
            this.dispatchEvent(
                new ShowToastEvent({
                    //title: 'Success',
                    message: 'Incident Report updated SuccessFully',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            this.isLoaded =true;
            console.error('Error fetching record', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error While updating Incident Report',
                    variant: 'error',
                }),
            );
        });
    }
}