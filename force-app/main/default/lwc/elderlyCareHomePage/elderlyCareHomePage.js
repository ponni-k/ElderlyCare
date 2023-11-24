import { LightningElement,track,api,wire } from 'lwc';
import getCurrentUserDetails from '@salesforce/apex/ElderlyCareHomePage.getUserDetails';
import getEventDetails from '@salesforce/apex/ElderlyCareHomePage.getHomePageDetails';
import { NavigationMixin } from 'lightning/navigation';
import getDomainURL from '@salesforce/apex/ElderlyCareHomePage.returnDomain';

export default class ElderlyCareHomePage extends NavigationMixin(LightningElement) {


    @track userName;
    @track userid;
    @track profilePicture;

    @track monthNumber;
    @track day;
    @track hours;
    @track minutes;
    @track timeforEvent;

    @track isModalOpen = false;

    @track futureEvents;
    @track CompletedEvents;
    @track myClients;
    @track clientsize;
    @track mapValuesArray=[];
    @track mapValues;
    @track profileName;
    @track careAdminClientSize;


@track valuesArray;
    
    connectedCallback(){
        getCurrentUserDetails()
        .then(result => {
            console.log('Current USer: '+JSON.stringify(result))
            this.userName = result[0].name;
            this.userid = result[0].userid;
            this.profilePicture = result[0].profilePicture;
            
            console.log('userName :'+this.userName);
        })
        .catch(error => {
            console.log('Current USer error: '+JSON.stringify(error))
        });

        getDomainURL()
            .then(result=>{
                console.log('Domain result : '+JSON.stringify(result));
                this.myMap = result;

                console.log('myMap :'+this.myMap);

                this.profileName = Object.keys(result);
                console.log('profileName :'+this.profileName);
                this.domainNames = Object.values(result);
                console.log('domainNames :'+this.domainNames);

                // const profileName = result[0];
                // console.log('profileName :'+profileName);

                this.loginDetails = result;
                // this.domainName = result;
                // console.log('domainName--> :'+this.domainName);
                
            })
            .catch(error=>{
                console.log('Domain error :'+error);
            })

        getEventDetails()
        .then(result => {
            console.log('us res :'+JSON.stringify(result));

            this.wrapperValues = result;            
            this.futureEvents =result[0].futureEvents;
            this.CompletedEvents = result[1].completedEvent;
            this.myClients = result[2].myClientsValues;

            if(this.profileName=='Cloned Customer Community Plus User'){
                this.clientsize = Object.values(this.myClients).length;
                console.log('myClients :'+JSON.stringify(this.myClients));
            } else {
                this.clientsize = result[3].carerAdminClientSize;
                console.log('carerAdminClientSize :'+this.clientsize);
            }
            
            

            // this.mapValues = Array.from(result.mapProperty.values());
            // console.log('mapValues :'+JSON.stringify(this.mapValues));
            

            // this.mapValuesArray = Array.from(this.myClients.values()).map((value, index) => ({
            //     key: Array.from(this.myClients.keys())[index],
            //     value: value
            // }));
            // console.log('mapValuesArray : '+JSON.stringify(this.mapValuesArray));
        })
        .catch(error => {
            console.log('us err: '+JSON.stringify(error))
        });
    }  
    // connectedCallback(){
    //    
    // }
    handleViewMyClients(){
        if(this.profileName=='Cloned Customer Community Plus User'){
            this.isModalOpen = true;
        } else {
        const redirectURL =this.domainNames+'myclientsview';
        console.log('--->'+redirectURL);
       this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: redirectURL
            }
        },true)
        console.log('redirectURL Home :'+redirectURL);
        return redirectURL;
        }
    }
    closeModalPopUp(){
        this.isModalOpen = false;
    }  

    handleNavigateClientPage(event){
        var clientVal = event.target.title;
        console.log('clientVal :'+clientVal);
        

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: clientVal,
                actionName: 'view',
            },
        });
    }
}