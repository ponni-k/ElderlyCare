import { LightningElement,track ,api,wire } from 'lwc';
import getCompletedJobs from '@salesforce/apex/ElderlyCareHomePage.getUserDetails';

export default class ElderlyCareCompletedService extends LightningElement {

    @track completedJobs

    connectedCallback() {
        getCompletedJobs()
            .then(result => {
                
                this.completedJobs = result;
                console.log('Completed Jobs :'+JSON.stringify(result));
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                console.log('jobs error -->' + JSON.stringify(error));
                this.timeSheetDetails = undefined;
            });
    }

}