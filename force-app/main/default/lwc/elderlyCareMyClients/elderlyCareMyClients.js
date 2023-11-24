import { LightningElement, track,wire } from 'lwc';
import getDomainURL from '@salesforce/apex/ElderlyCareHomePage.returnCarerAdminDomain';
import getMyClients from '@salesforce/apex/ELderlyCareCarerAdminClients.getClients';
import { NavigationMixin } from 'lightning/navigation';
export default class ElderlyCareMyClients extends NavigationMixin(LightningElement) {
    @track clientDetails = [];
    @track loginDetails;
    @track clientList =[];
    @track clientImage;

    @track domainName;
    constructor(){
        super();
     }
    @wire(getMyClients)  
    wiredData({error, data }) {   
        let clientInfo = [];
        if(data){
            console.log('if runs@@@');
            this.clientDetails = data;
            console.log('Client details--> '+ this.clientDetails);
            debugger;
            
            for(var i=0;i<=this.clientDetails.length;i++){
                let row={}; 
                if(this.clientDetails[i]){
                    //console.log('Inside Forloop');
                    row.Id=this.clientDetails[i].Id;
                    //console.log('Id@@@:  '+row.Id);
                    row.clientName=this.clientDetails[i].Name;
                     console.log('Name'+row.clientName);
                     row.billingCity=this.clientDetails[i].BillingCity;
                    console.log('City :'+row.billingCity);
                    row.billingState=this.clientDetails[i].BillingState;
                    row.phone=this.clientDetails[i].Phone;
                    row.Profile=this.clientDetails[i].Profile__c;
                    row.clientImage = this.clientDetails[i].AccountImage_URL__c;
                    //console.log('clientImage Url:  '+row.clientImage);
                    clientInfo.push(row);
                    //console.log('Client info:   '+JSON.stringify(clientInfo));
                    this.clientList = clientInfo;

                 } 

        }
        }else if (error) {
                        this.error = error;
                        console.log('service Error :'+JSON.stringify(this.error));
                    }

    }
    connectedCallback(){
        getDomainURL()
        .then(result=>{
            console.log('Domain result : '+JSON.stringify(result));
            this.loginDetails = result;
            this.domainName = result;
            console.log('domainName--> :'+this.domainName);
            
        })
        .catch(error=>{
            console.log('Domain error :'+error);
        })
    }


    newClientForm(event){
       
        const pageName =event.target.getAttribute('icon-name');
        if(pageName=='action:new'){
            const redirectURL =this.domainName+'myclients';
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
    
    handleClient(event){
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