import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getRelatedAccountDetails from '@salesforce/apex/Highlightpanel.getRelatedAccountDetails';

export default class ElderlyCareEventHighlightPannel extends LightningElement {


    @api recordId;
    @track urlId;

@track Name;
@track accImage;
@track accId;
@track phone;
@track dob;
@track age;
@track gendar;
@track reports;
@track address;
@track package;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlId = currentPageReference.attributes.recordId;
       }
    }

    

    connectedCallback() {
        getRelatedAccountDetails({eventRecordId : this.urlId})
        .then(result => {
            this.accountrecord = result;
            this.Name = result.Name;
            this.accImage = result.AccountImage_URL__c;
            this.phone = result.Phone;
            this.address = result.BillingCity;
            console.log('address :'+this.address);
            this.dob = result.Birth_date__c;
            this.age = result.Age__c;
            this.gendar = result.Gander__c;
            this.reports = result.Reports_to__r.Name;
            this.package = result.Selected_Service_Packages__c;
           // console.log('@@ Name :'+this.Name);
           // console.log('@@ accImage :'+this.accImage);
            //console.log('@@ phone :'+this.phone);
            this.accountrecorderror = undefined;
            //console.log('@@@@@@@@@@ACC'+JSON.stringify(result));
        })
        .catch(error => {
            this.accountrecorderror = error;
            this.accountrecord = undefined;
            //console.log('@@@ error :'+JSON.stringify(error));
            //this.eventRecord = undefined;
        });
    }
    
}