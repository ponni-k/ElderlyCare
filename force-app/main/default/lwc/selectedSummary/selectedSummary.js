import { LightningElement,api,track,wire } from 'lwc';

import { publish,subscribe,unsubscribe,createMessageContext,releaseMessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
import SAMPLEMC1 from "@salesforce/messageChannel/AnotherMessageChannel__c";
import getSummaryList from '@salesforce/apex/AgedCare.getFeaturesSummary';
import getPriceAndDuration from "@salesforce/apex/AgedCare.getpriceandduration";
import images from '@salesforce/resourceUrl/SalesforceEsscentials';
import saveTOLead from "@salesforce/apex/AgedCare.createLead";
import  NAME_FIELD from '@salesforce/schema/Lead.Name';
import  COMPANY_FIELD from '@salesforce/schema/Lead.Company';
import  EMAIL from '@salesforce/schema/Lead.Email';
import  PHONE from '@salesforce/schema/Lead.Phone';
import  COMMENTS from '@salesforce/schema/Lead.LeadsComments__c';
import  DESC from '@salesforce/schema/Lead.Description';
import { refreshApex } from '@salesforce/apex';
import LightningAlert from 'lightning/alert';
import { NavigationMixin } from 'lightning/navigation';


const columns = [
    { label: 'Selected Features', fieldName: 'Name',initialWidth: 150,wrapText:true },
    { label: 'Dev duration hrs', fieldName: 'Duration__c' ,initialWidth: 160,wrapText:true}    
];

export default class SelectedSummary extends NavigationMixin(LightningElement) { 
    @api objectApiName='Lead';
    @track receivedMessage = '';
    @track summaryRecordId;
    @track summaryList;
    @track showSummaryValue = true;
    @track showNoRecords = true;
    @track col = columns;

    @track selectedRows=[]
    @track summaryalueLength; 
    @track showLoading = false;

    @track SalutaionValue;
    @track Companyname;
    @track firstname;
    @track emailvalue;
    @track lastname;
    @track phoneval;
    @track priceval;
    @track durationval;
    @track descriptionValue;
    @track totalPriceAndDuration=[];
    @track fInalvalue;
    @track fInalIdVal = []; 

    context = createMessageContext();
    subscription = null;

    constructor() { 
        super();
    }

    connectedCallback(){
        console.log('connected callback run');
        this.subscribeLMC();
    }
    subscribeLMC(){
        if(this.subscription){
            console.log('no subsribe');
            return;
        }
        this.subscription = subscribe (this.context,SAMPLEMC1,(message1)=>{
            this.handleMessage(message1);
        }, {scope:APPLICATION_SCOPE});
    }
    sfdcesst=images + '/images/essentials.jpg';
    zsys=images + '/images/zsys.jpg';
    handpoint=images + '/images/handpointing.jpg';
    handleMessage(message1){ 
        this.recid = message1.recordId;
        this.selval1 = message1.selval;
        this.selectedFeaturesvalue = message1.selectedFeaturesval;
       
        getSummaryList({ lstRecord: this.recid })
            .then((result) => {
                
                //console.log('summary result====>'+result);
                this.summaryList = result;
                this.summaryalueLength = result.length;
                console.log('summaryalueLength-->'+this.summaryalueLength);
                console.log('summaryList===>'+JSON.stringify(this.summaryList));
                this.showSummaryValue = true;
                this.showNoRecords = false;
                this.summaryError = undefined;
            })
            .catch((error) => {
                this.summaryError = error;
                console.log('summaryList===>'+JSON.stringify(this.summaryList));
                this.summaryList = undefined;
            });
    }

    statusOptions = [
        { value: '--None--', label: '--None--' },
        { value: 'Mr.', label: 'Mr.' },
        { value: 'Ms.', label: 'Ms.' },
        { value: 'Mrs.', label: 'Mrs.' },
        { value: 'Dr.', label: 'Dr.' },
        { value: 'Prof.', label: 'Prof.' },
    ];

    @track isModalOpen = false;
   
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    @track selectedRecords=[];
    @track tempvar=[];
    @track selectedElementIdVal=[];

    handleRowSelection(event){
        this.selectedRows = event.detail.selectedRows.map(row => row.Id);
        console.log( 'Selected Rows are ' + JSON.stringify (this.selectedRows));
    }

    @track tempVal =[];

    handleRemoveSelection(){
        console.log('remove');
        this.tempVal=[];
        for (let index = 0; index < this.selectedFeaturesvalue.length; index++) {
            //console.log("index :"+index);
            const element = this.selectedFeaturesvalue[index];
            //console.log("element :"+element);
            if(this.selectedRows.includes(element)){
                this.tempVal.push(index);
            } else{
                //console.log("Not working");
            }
        }
        console.log('tempval--->'+this.tempVal);
        const filteredArray = this.selectedFeaturesvalue.filter((element, index) => {
            return !this.tempVal.includes(index);
        });

        console.log("##########filteredArray--->"+filteredArray);
        
        getSummaryList({ lstRecord:filteredArray })
        .then((result) => {
            //console.log('summary result====>'+result);
            // this.summaryList.removeAll();
            this.summaryList=result;
            this.summaryalueLength = result.length;
            console.log('summaryalueLength-->'+this.summaryalueLength);
            console.log('summaryList===>'+JSON.stringify(this.summaryList));
            this.showSummaryValue = true;
            this.showNoRecords = false;
            this.summaryError = undefined;
        })
        .catch((error) => {
            this.summaryError = error;
            console.log('summaryList===>'+JSON.stringify(this.summaryList));
            this.summaryList = undefined;
        }); 
        refreshApex(this.summaryList);
    }
    
    @track selId =[];
    handleRowAction(event){

        const actionName = event.detail.action.name;
        console.log('actionName-->'+actionName);
        const row = event.detail.selectedRows.map(row => row.Id);
        console.log('row-->'+JSON.stringify(row))
        if(actionName =='delete'){
            // for(let i=0;i<selectedRows;i++){
            //     console.log('i val :'+i);
            // }
        }
    }  
    deleteRow(row) {
        console.log("removeROw");
       
    } 




    @track SalutaionValue ='';
    @track Companyname='';
    @track firstname='';
    @track emailvalue='';
    @track lastname='';
    @track phoneva='';
    @track priceval;
    @track durationval;
    comments;
    @track descriptionValue;
    @track totalPriceAndDuration=[];
    @track fInalvalue;
    @track fInalIdVal = [];

    

    handleSaveRecords() {
        console.log('handleSaveRecords')
        // to open modal set isModalOpen tarck value as true

        
        this.finalvalue = [...this.summaryList];
        console.log('finalvalue--->'+JSON.stringify(this.finalvalue));

        for(let i=0;i<this.finalvalue.length;i++){
            this.fInalIdVal.push(this.finalvalue[i].Id);
        }
        console.log('fInalIdVal ---->'+JSON.stringify(this.fInalIdVal));

        getPriceAndDuration({ lstRecord:this.fInalIdVal })
        .then((result) => {
            console.log('handleSave-->'+result)
            this.totalPriceAndDuration = result;
            console.log('priceDuration--->'+JSON.stringify(this.totalPriceAndDuration));
           this.priceval = this.totalPriceAndDuration[0]
           this.durationval = this.totalPriceAndDuration[1];
           this.descriptionValue = `Our high level effort for selected features development is ${this.durationval} hours \n We also provide best salesforce consulting  and implementation services. \n Please complete the form to email the cost of the selected features`;
           this.totalPriceAndDurationError = undefined;
        }) 
        .catch((error) => {
            this.totalPriceAndDurationError = error;
            console.log('priceDurationError===>'+JSON.stringify(this.totalPriceAndDurationError));
            this.totalPriceAndDuration = undefined;
        }); 

        this.isModalOpen = true;
    }

    
    //DESC=this.descriptionValue;
    fields = [NAME_FIELD, COMPANY_FIELD, EMAIL,PHONE,COMMENTS,DESC];

    handleSuccess(event){
       
            const evt = new ShowToastEvent({
                title: 'Lead created',
                message: 'Record ID: ' + event.detail.id,
                variant: 'success',
            });
            this.dispatchEvent(evt);
            //this.isModalOpen=false;
       
    }

    handleSalutaionValue(event){
       this.SalutaionValue = event.target.value;
       console.log('SalutaionValue-->'+this.SalutaionValue);
    }

    handleCompanyChange(event){
        this.Companyname = event.target.value;
        console.log('Companyname-->'+this.Companyname);
    }
    handleFirstChange(event){
        this.firstname = event.target.value;
        console.log('firstname-->'+this.firstname);
    }

    handleEmailChange(event){
        var freeRegex = /^[\w-\.]+@([hotmail+\.]|[yahoo+\.]|[gmail+\.])+[\w-]{2,4}$/;
         this.emailvalue = event.target.value;
        
         if(this.emailvalue.match(freeRegex)){
            event.target.setCustomValidity('Please do no use free email ,Use org email ');

         }
         else{
            event.target.setCustomValidity('');
         }
         console.log('emailvalue-->'+this.emailvalue);
    }
    handleLastNameChange(event){
        this.lastname = event.target.value;
        console.log('lastname-->'+this.lastname);
    }
   
    isPhoneNumberValid = false;
    handlePhoneChange(event){
        this.phoneval = event.target.value;
        console.log('phoneval-->'+this.phoneval);
        const phoneNumberPattern = /^(\+?61|0|\+?64)[2|3|4|7|8][0-9]{8}$/;

        const isValidPhoneNumber = phoneNumberPattern.test(this.phoneval);

        if (!phoneNumberPattern.test(this.phoneval)) {
            // Set an error message or apply appropriate error styling
            event.target.setCustomValidity('Please enter a valid phone number');
            this.disableOkButton = true;
          } else {
            // Clear any existing error messages or error styling
            isPhoneNumberValid
            event.target.setCustomValidity('');
            this.disableOkButton = false;
          }
    }
    // validatePhoneNumber(){
    //     const phoneNumberPattern = /^(\+?61|0|\+?64)[2|3|4|7|8][0-9]{8}$/;
    // }

    handleComments(event){
        this.comments = event.target.value;
    }
    
    
    @track leadresult;
    @track leadresultError;
    @track disableOkButton = true;
    

    handleCreateLead(event){
      if(this.Companyname != "" && this.lastname != "" &&  this.emailvalue != "")
      {
        this.disableOkButton = false;
       this.showLoading = true;
       saveTOLead({ salutation: this.SalutaionValue,
            companyinfo: this.Companyname,
            firstname: this.firstname,
            email: this.emailvalue,
            lastname: this.lastname,
            phone: this.phoneval,
            comment:  this.comments,
            description: this.descriptionValue + "\n" + JSON.stringify(this.summaryList) + "\n" +this.priceval
            
         })
            .then(result => {
                //const redirectURL = 'https://zuddhisystems.my.site.com/SalesforceEssentials/s/thankyou';
                //console.log('Record id ===>'+result.Id);
                this.showLoading = false;
                this.isModalOpen = false;
                this.leadresult = result;
                
                console.log('leadresult-->'+this.leadresult); 
                this.leadresultError = undefined;
                this[NavigationMixin.Navigate]({
                    type: 'comm__namedPage', 
                    attributes: {
                      componentName: 'thankYou__c' // Replace with the name of your destination component
                    },
                    state: {
                      // Define parameters to pass to the destination component
                      //paramName: 'paramValue'
                    }
                  });
                
            }) 
            .catch(error => {
                //const redirectURL = 'https://zuddhisystems.my.site.com/SalesforceEssentials/s/';

                this.leadresultError = error;
                this.isModalOpen = true;
                this.showLoading =true;
                console.log('summaryList===>'+JSON.stringify(this.leadresultError));
                this.leadresult = undefined;
                this[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                      componentName: 'c__ThankYouPage' // Replace with the name of your destination component
                    },
                    state: {
                      // Define parameters to pass to the destination component
                      //paramName: 'paramValue'
                    }
                  });
                
            })
            .finally(()=>{
                //const redirectURL = 'https://zuddhisystems.my.site.com/SalesforceEssentials/s/thankyou';
                this.showLoading =false;
                this.isModalOpen = false;
                this[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                      name: 'thankYou__c' // Replace with the name of your destination component
                    },
                    state: {
                      // Define parameters to pass to the destination component
                      //paramName: 'paramValue'
                    }
                  });
                
            });
        } 
        
       else{
        //this.disableOkButton = true;
        this.handleAlertClick();
       }

    }
    async handleAlertClick() {
        await LightningAlert.open({
            message: 'Please enter the required fields to complete form',
            theme: 'error', // a red theme intended for error states
            label: 'Error!', // this is the header text
        });
        //Alert has been closed
    }

}