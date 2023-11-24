import { LightningElement } from 'lwc';

export default class FeedbackCmp extends LightningElement {
    showRating(){
        this.template.querySelector('c-rating-cmp').getvalues();
    }
}