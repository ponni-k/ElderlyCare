import { LightningElement,api,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getDomainURL from '@salesforce/apex/ElderlyCareHomePage.returnCarerAdminDomain';

export default class ElderlyCareCarerAdminNavigationBar extends NavigationMixin(LightningElement) {
    @track pageName;
    @track loginDetails;

    @track domainName;
    @track loginUserId;

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


    handleNavrBar(event){
        const pageName =event.target.getAttribute('icon-name');
    
        if(pageName=='standard:home'){
            const redirectURL =this.domainName;
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
        else if (pageName =='standard:event') {
            const redirectURL= this.domainName+'events';
            console.log('redirectURL :'+redirectURL);
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: redirectURL
                }
            },true)
            console.log('redirectURL Event'+redirectURL);
            return redirectURL;
        } else if (pageName =='standard:client') {
            const redirectURL= this.domainName+'myclientsview';
            console.log('redirectURL :'+redirectURL);
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: redirectURL
                }
            },true)
            console.log('redirectURL Event'+redirectURL);
            return redirectURL;
        } else if (pageName =='standard:incident') {
            const redirectURL= this.domainName+'incident';
            console.log('incident URL:'+redirectURL)
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: redirectURL
                }
            },true)
            console.log('redirectURL Event'+redirectURL);
            return redirectURL;
        } else if (pageName =='standard:user') {
            const redirectURL= this.domainName+'profilepage';
            console.log('incident URL:'+redirectURL)
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: redirectURL
                }
            },true)
            console.log('redirectURL Event'+redirectURL);
            return redirectURL;
        }
        
    }
 
}