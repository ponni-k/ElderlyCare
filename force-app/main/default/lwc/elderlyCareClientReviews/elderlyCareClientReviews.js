import { LightningElement,api,track,wire } from 'lwc';
import customerreviews from '@salesforce/apex/ElderlyCareCustomerReviews.getFeedBack';

export default class ElderlyCareClientReviews extends LightningElement {

    @track feedBackDetails;
    @track feedBackError;

    @wire(customerreviews)
    wiredEvent({ error, data }) {
        if (data) {
            this.feedBackDetails = data;
            console.log('feedBackDetails :'+JSON.stringify(this.feedBackDetails));
            this.feedBackError = undefined
        } else if (error) {
            this.feedBackError = error;
            this.feedBackDetails = undefined;
        }
    }
}