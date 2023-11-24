import { LightningElement,wire,api, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getAccountDetails from '@salesforce/apex/Highlightpanel.getAccount';


export default class ElderlyCareHighlightPanel extends LightningElement {
    @api recordId;
    @track urlId;

    @track pic;
    @track uname;
    @track userdb;
    @track userphone;
    @track age;
     
    @wire(getAccountDetails)
    wiredAccount({ error, data }) {
        if (data) {
            console.log('data--->'+data);
            this.uname = data[0].Name;
            this.pic = data[0].Account_Image__c;
            this.userphone = data[0].Phone;
            this.userdb= data[0].Birth_date__c;
            this.age= data[0]. Age__c;
            console.log('Name--->'+ this.uname )
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }

}