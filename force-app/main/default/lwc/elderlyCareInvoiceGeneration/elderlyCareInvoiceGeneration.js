import { LightningElement,track ,wire,api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import fetchClientInvoice from '@salesforce/apex/ElderlyCareInvoiceGeneration.getRecordsForClient';
//import sendPdf from "@salesforce/apex/ElderlyCareInvoiceGeneration.sendPdf";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class ElderlyCareInvoiceGeneration extends LightningElement {

    @api carrerobjapi = 'carer__c';
    @api accountObjapi = 'Account';

    @track isModalOpen = false;
    @track isClientInvoice = false;
    @track isProviderInvoice = false;


    get options() {
        return [
            { label: 'Generate Invoice for Client', value: 'client' },
            { label: 'Generate Invoice for Service Provider', value: 'serviceprovider' },
        ];
    }

    handleInvoiceGenerate(event){
        this.isModalOpen = true;
        this.invoiceGenerate = event.target.value;
        console.log('invoiceGenerate :'+this.invoiceGenerate);
        if(this.invoiceGenerate =='client'){
            //this.isModalOpen = true;
           this.isClientInvoice = true;
            this.isProviderInvoice = false;
        } else {
            this.isClientInvoice = false;
            this.isProviderInvoice = true;
        }
    }
    handleStartDate(event){
        this.startDate= event.target.value;
        console.log('startDate :'+this.startDate)
    }
    handleEndDate(event){
        this.endDate = event.target.value;
        console.log('endDate :'+this.endDate);

    }

    lookupRecord(event){
        this.selectedrecord = event.detail.selectedRecord.Id;
        console.log('selectedrecord :'+this.selectedrecord);
        console.log('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
    }

    generatePDF() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    @track showSpinner = false;
    generateInvoice() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        //this.isModalOpen = false;
        if(this.invoiceGenerate =='client'){
            this.showSpinner = true;
            fetchClientInvoice({clientid :this.selectedrecord , startDate: this.startDate,endDate: this.endDate })
            .then(result => {
                console.log('Client data :'+JSON.stringify(result));
                this.clientdata = result;
                this.recordzise = result.tm.length;
                this.clientnamr = result.totalprice;
                if(this.recordzise > 0){
                    this.showSpinner = false;
                    //this.isModalOpen = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Invoice Generated Successfully SuccessFully',
                            variant: 'success',
                        }),
                    );
                } else {
                    this.showSpinner = false;
                    this.isModalOpen = true;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'warning',
                            message: 'No Records to GenerateInvoice',
                            variant: 'warning',
                        }),
                    );
                } 
            })
            .catch(error => {
                this.showSpinner = false;
                this.isModalOpen = true;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error While Generating Invoice',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log('Client Error :'+JSON.stringify(error));
            })
        }
    }










    // @api recordId;
    // @track urlId;

    // @wire(CurrentPageReference)
    // getStateParameters(currentPageReference) {
    //    if (currentPageReference) {
    //     console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
    //       this.urlId = currentPageReference.attributes.recordId;
    //       console.log('urlId :'+JSON.stringify(this.urlId));
    //    }
    // }

    // @wire(fetchRecords, {timesheetRecordId : '$urlId'})
    // wireData({error, data}) {
    //     if (data) {
    //         this.timesheetresult = data;
    //         this.accStreet = data.Account_Name__r.BillingStreet;
    //         this.accCity = data.Account_Name__r.BillingCity;
    //         //console.log('accCity :'+this.accCity);
    //         this.accState = data.Account_Name__r.Billingstate;
    //         this.accCountry = data.Account_Name__r.BillingCountry;
    //         this.accPostalCode = data.Account_Name__r.BillingPostalCode;
    //         this.servicePrice = data.Account_Name__r.Price__c;
    //         this.serviceStartTime = data.Start_Time__c;
    //         //console.log('serviceStartTime :'+this.serviceStartTime);
    //         this.serviceEndTime = data.End_time__c;
    //         this.clientName = data.Account_Name__r.Name;
    //         //console.log('clientName :'+this.clientName);
    //         //console.log('ti data :'+JSON.stringify(data));
    //     } else if (error) {
    //         console.error('check error here', error);
    //     }
        
    // }

    // generatePDF(){
    //     sendPdf({contactId : this.urlId,clientname : this.clientName})
    //     .then(res=>{
    //         this.ShowToast('Success', res, 'success', 'dismissable');
    //     })
    //     .catch(error=>{
    //         this.ShowToast('Error', 'Error in send email!!', 'error', 'dismissable');
    //     })
    // }

    ShowToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
            title: title,
            message:message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}