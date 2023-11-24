import { LightningElement,track,api,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getEventDetails from '@salesforce/apex/ElderlyCare.getEventDetails';

export default class EldelyCareMap extends LightningElement {

    @api recordId;

    @track locationArray=[];
    @api mapMarkers=[];
    @track mapMarkers1=[];
    @track mapArray=[];
    zoomLevel = 17;
    LOGO = 'https://i.ibb.co/ZWRZ8QN/Eliza.jpg'


    connectedCallback() {
        getEventDetails({eventRecordId: this.urlId})
        .then(result => {
            this.mapMarkers = result.map( mapItem => {
                return {
                  location: {
                    Street:mapItem.Street,
                    City: mapItem.City, 
                    PostalCode: mapItem.PostalCode,
                    State: mapItem.State,
                    Country:mapItem.Country
                  },
                  title: mapItem.Name,
                  icon: 'standard:account',
                };
              });
              markerOptions = {
                icon: {
                  iconUrl: 'https://cdn.dribbble.com/userupload/3261442/file/original-79302dhttps://cdn.dribbble.com/userupload/3261442/file/original-79302dac2eb04d0f9aecac39e67b596b.png?resize=400x300',
                  iconSize: [32, 32],
                  iconAnchor: [16, 32],
                },
                animation: 'DROP', 
              };
    
        })
        .catch(error => {
            console.log('eventError@@:'+JSON.stringify(error));
        });

    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
       // console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
          this.urlId = currentPageReference.attributes.recordId;
          //console.log('urlId :'+JSON.stringify(this.urlId));
       }
    }

    // @wire(getEventDetails,{ eventRecordId: '$urlId' })
    // wiredAccountUserRecords({ data, error }) {
    //     if (data) {
    //         //this.accountUserRecords = data;
    //         console.log('Account wire :-->'+JSON.stringify(data));
    //         console.log('User wire :-->'+JSON.stringify(data));
    //         // Access the records and their properties as needed
    //     } else if (error) {
    //         // Handle error
    //         console.log('error :'+JSON.stringify(error));

    //     }
    // }

    /*mapMarkers = [
        {
            location: {
                // Location Information
                City: 'San Francisco',
                Country: 'USA',
                PostalCode: '94105',
                State: 'CA',
                Street: '50 Fremont St',
            },

            // For onmarkerselect
            value: 'SF1',

            // Extra info for tile in list & info window
            icon: 'standard:account',
            title: 'Julies Kitchen', // e.g. Account.Name
            description: 'This is a long description',
        },
        {
            location: {
                // Location Information
                City: 'San Francisco',
                Country: 'USA',
                PostalCode: '94105',
                State: 'CA',
                Street: '30 Fremont St.',
            },

            // For onmarkerselect
            value: 'SF2',

            // Extra info for tile in list
            icon: 'standard:account',
            title: 'Tender Greens', // e.g. Account.Name
        },
    ];*/

    selectedMarkerValue = 'SF1';

    // handleMarkerSelect(event) {
    //     this.selectedMarkerValue = event.target.selectedMarkerValue;
    // }
}