import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getAccountDetails from '@salesforce/apex/Highlightpanel.getAccount';
import getServices from '@salesforce/apex/ElderlyCareSelectedServices.getServices';
import packageName from '@salesforce/apex/ElderlyCareSelectedServices.getPackageLevel';
import { NavigationMixin } from 'lightning/navigation';

import { publish,subscribe,unsubscribe,createMessageContext,releaseMessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/RelatedRecordsChannel__c";


export default class HighlightPanel extends NavigationMixin(LightningElement) {


@api recordId;
@track accData;
@track accError;
@track urlId;

@track Name;
@track accImage;
@track accId;
@track phone;
@track dob;
@track age;
@track gender;
@track reports;
@track Street;
@track City;
@track State;
@track Country;
@track package;
@track budget;

@track SelectedService=[];
@track serviceError;
@track selectedItem = [];
@track services;
@track packagelevel;



@track accountrecord = [];
@track accountrecorderror;

@track location;
//@api currentWeather = false;
@track description;
@track sunrise;
@track temperature;
@track sunset;
@track humidity;
@track buttonValue;
@track profileName;
@track admin = false;
@track carer = false;
context = createMessageContext();


@wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
            console.log('page type --->'+this.getStateParameters.type);
          this.urlId = currentPageReference.attributes.recordId;
       }
    }



    handleSideButton(e) {

        const tabName = window.location.href;
        console.log('tabName :'+tabName);
        this.buttonValue = e.target.label;
        console.log('button Value :'+this.buttonValue)
        const message = {
            pubButtonValue : this.buttonValue,
        };
        console.log('message :'+message.pubButtonValue);
        publish (this.context,SAMPLEMC,message);

        // this[NavigationMixin.Navigate]({
        //     type: 'standard__navItemPage',
        //     attributes: {
        //         URL: tabName+'?tabset-4eec3=2'
        //     }
        // });

        const pageReference = {
            type: 'standard__navItemPage',
            attributes: {
                apiName: tabName+'?tabset-4eec3=2'
            }
        };
        this[NavigationMixin.Navigate](pageReference);



    }

    connectedCallback() {


        if (this.getStateParameters) {
            const state = this.getStateParameters;
            console.log('state -->'+state);
            
            if (state && state.navItemId) {
                console.log('Current Tab ID:', state.navItemId);

                // You can use additional logic to fetch the tab details
                // For example, you might query for the tab information using the state.navItemId
                // and then extract the tab name or other relevant details.
            }
        }

        


        getAccountDetails({accountrecordId : this.urlId})
        .then(result => {
            this.profileName = Object.keys(result);
            if(this.profileName == 'AdminCommunityPlus'){
                this.admin = true;

            }else{
                this.admin = false;

            }
            this.accountrecord = Object.values(result);
            this.Name =this.accountrecord[0].Name;
            this.accImage = this.accountrecord[0].AccountImage_URL__c;
            this.phone = this.accountrecord[0].Phone;
            this.Street = this.accountrecord[0].BillingStreet;
            this.City = this.accountrecord[0].BillingCity;
            this.State = this.accountrecord[0].BillingState;
            this.Country = this.accountrecord[0].BillingCountry;
            this.dob = this.accountrecord[0].Birth_date__c;
            this.age = this.accountrecord[0].Age__c;
            this.gender = this.accountrecord[0].Gander__c;
            this.reports = this.accountrecord[0].Reports_to__r.Name;
            this.package = this.accountrecord[0].Selected_Service_Packages__c;
            this.budget = this.accountrecord[0].Annual_Budget__c;           
            this.accountrecorderror = undefined;
        })
        .catch(error => {
            this.accountrecorderror = error;
            this.accountrecord = undefined;
        });
    }

    getTabNameById(tabId) {
        // Implement logic to retrieve tab name based on the tabId
        // This may involve querying your data or using a configuration object
        // Replace this with your actual logic
        const tabIdToNameMap = {
            // Sample mapping, replace with your actual mapping
            'tab1': 'Detail',
            'tab2': 'Related',
        };

        return tabIdToNameMap[tabId] || 'Unknown Tab';
    }

    @track totalprice = 0;
    @wire(getServices ,{accId : '$urlId'})
    wiredNamesList({ data, error }) {
        if (data) {
            this.selectedItem = data;
            this.totalPrices();
        } else if (error) {
            this.error = error;
            console.log('service Error :'+JSON.stringify(this.error));
        }
    }

    @track total;
    totalPrices() {
        this.total = 0;
        for (let product of this.selectedItem) {
            if(product.Price__c != null){
                //console.log('product :'+JSON.stringify(product));
                this.total += product.Price__c; 
            }
        }
        //console.log('this.total :'+this.total);
        return this.total;
    }

   
    @wire(packageName ,{accId : '$urlId'})
    wiredList({ data, error }) {
        if (data) {
            this.packagelevel = data;
            console.log('packagelevel :'+JSON.stringify(this.packagelevel));
        } else if (error) {
            this.error = error;
            console.log('Package Error :'+JSON.stringify(this.error));
        }
    }  
}