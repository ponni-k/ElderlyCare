import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getContactRecord from '@salesforce/apex/ElderlyCare.getContact';
import getTimesheetRecord from '@salesforce/apex/ElderlyCare.getTImeSheet';
import getProductLineItemRecord from '@salesforce/apex/ElderlyCare.getProductLineItem';
import getRelatedFiles from '@salesforce/apex/ElderlyCare.getRelatedFilesByRecordId';
import {NavigationMixin} from 'lightning/navigation';



export default class ElderlyCareAccountOverview extends NavigationMixin(LightningElement) {
    @api recordId;
    @api urlId;
    @track conactrecord;
    @track conactrecordlength;
    @track conactrecorderror;

    @track timesheetrecord;
    @track timesheetrecordlength;
    @track timesheeterror;

    @track ProdLineItemrecord;
    @track ProdLineItemrecordlength;
    @track ProdLineItemerror;




    activeSectionsMessage = '';

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }

    connectedCallback() {
        getContactRecord({contactRecord: this.urlId})
        .then(result => {
            this.conactrecord = result;
            this.conactrecordlength = result.length;
            this.conactrecorderror = undefined;
            console.log('####COntact record########-->'+JSON.stringify(result));
        })
        .catch(error => {
            this.conactrecorderror = error;
            this.conactrecord = undefined;
            console.log('eventError :'+JSON.stringify(error));
            //this.eventRecord = undefined;
        });

        getTimesheetRecord({timesheetRecord: this.urlId})
        .then(result => {
            this.timesheetrecord = result;
            this.timesheetrecordlength = result.length;
            this.timesheeterror = undefined;
            console.log('####Time sheet record########-->'+JSON.stringify(result));
        })
        .catch(error => {
            this.timesheeterror = error;
            this.timesheetrecord = undefined;
            console.log('eventError :'+JSON.stringify(error));
            //this.eventRecord = undefined;
        });

        //Product Line Item
        getProductLineItemRecord({productLineItemRecord: this.urlId})
        .then(result => {
            this.ProdLineItemrecord = result;
            this.ProdLineItemrecordlength = result.length;
            this.ProdLineItemerror = undefined;
            console.log('####Time sheet record########-->'+JSON.stringify(result));
        })
        .catch(error => {
            this.ProdLineItemerror = error;
            this.ProdLineItemrecord = undefined;
            console.log('eventError :'+JSON.stringify(error));
            //this.eventRecord = undefined;
        });
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
          this.urlId = currentPageReference.attributes.recordId;
          console.log('urlId :'+JSON.stringify(this.urlId));
       }
    }
    filesList =[]
    @wire(getRelatedFiles, {accountRelatedFiles: '$urlId'})
    wiredResult({data, error}){ 
        if(data){ 
            console.log(data)
            this.filesList = Object.keys(data).map(item=>({"label":data[item],
             "value": item,
             "url":`/sfc/servlet.shepherd/document/download/${item}`
            }))
            console.log(this.filesList)
        }
        if(error){ 
            console.log(error)
        }
    }
    previewHandler(event){
        console.log(event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
            }
        })
    }

    
}