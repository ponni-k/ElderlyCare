import { LightningElement,track } from 'lwc';
import insertClientRecord from '@salesforce/apex/ELderlyCareCarerAdminClients.insertCarerAdminClients';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getDomainURL from '@salesforce/apex/ElderlyCareHomePage.returnCarerAdminDomain';

export default class ElderlyCareCarerAdminMyClients extends NavigationMixin(LightningElement) {
    isLoaded = false;
    clientName;
    email;
    phone;
    annualBudget;
    dob;
    gender;
    Street;
    City;
    State;
    Zipcode;
    Country;
    countryOfBirth;
    language;
    fileData;
    imgdata;
    filestore;
    imgurl;
    @track originalname = 'Attachment';
    @track domainName;

    get TypeofGender() {
        return [
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
            { label: 'Third Gender', value: 'Third Gender' },
            ];
    }
    get TypeofCountry() {
        return [
            { label: 'Australia', value: 'Australia' },
            { label: 'Canada', value: 'Canada' },
            { label: 'China', value: 'China' },
            { label: 'India', value: 'India' },
            { label: 'Newzeland', value: 'Newzeland' },
            { label: 'USA', value: 'USA' },
            { label: 'UK', value: 'UK' },
            ];
    }
    get TypeofLanguage() {
        return [
            { label: 'English', value: 'English' },
            { label: 'Spanish', value: 'Spanish' },
            { label: 'French', value: 'French' },
            { label: 'German', value: 'German' },
            { label: 'Japanesh', value: 'Japesh' },
            { label: 'Canadian', value: 'Canadian' },
           ];
    }
    handleClient(event){
        this.clientName = event.target.value;
        console.log('this.clientName :'+this.clientName);

    }
    handleEmail(event){
        this.email = event.target.value;
        console.log('this.emaile :'+this.email);

    }
    handlePhone(event){
        this.phone = event.target.value;
        console.log('this.phone :'+this.phone);

    }
    handleAnnualBudget(event){
        this.annualBudget = event.target.value;
        console.log('this.annualBudget :'+this.annualBudget);

    }
    handleDOB(event){
        this.dob = event.target.value;
        console.log('this.dob :'+this.dob);

    }
    handleGender(event){
        this.gender = event.target.value;
        console.log('this.gender :'+this.gender);

    }
    handleStreet(event){
        this.Street = event.target.value;
        console.log('this.Street :'+this.Street);

    }
    handleCity(event){
        this.City= event.target.value;
        console.log('this.City :'+this.City);

    }
    handleState(event){
        this.State = event.target.value;
        console.log('this.State :'+this.State);

    }
    handleZipCode(event){
        this.Zipcode = event.target.value;
        console.log('this.Zipcode :'+this.Zipcode);

    }
    handleBillingCountry(event){
        this.Country = event.target.value;
        console.log('this.Country :'+this.Country);

    }
    handleCountry(event){
        this.countryOfBirth = event.target.value;
        console.log('this.countryOfBirth :'+this.countryOfBirth);

    }
    handleLanguage(event){
        this.language = event.target.value;
        console.log('this.language :'+this.language);

    }
     
    openfileUpload(event) {
        this.dynamicLabel = event.target.label;
        
        const file = event.target.files[0];
        this.filestore=event.target.files[0];
        var reader = new FileReader()
        var form = new FormData();
        form.append("image",file); 
         reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
            this.originalname = 'Attachment : '+this.fileData.filename;
            this.imgdata=base64;
        }
        reader.readAsDataURL(file)  
    }

    async handleClick(){
       console.log('upload clicked');
       
        let endpoint='https://api.imgbb.com/1/upload?expiration=600&key=b44e9a29b4a25bfa403426465206be06';
         let formData = new FormData();
         formData.append("image",this.filestore); 
       const config={
                method: "POST",
                credentials: "omit",
                mimeType: "multipart/form-data", 
                contentType: false,
                processData: false,
                timeout: 600,
                body:formData 
            };
        
            const response =  await fetch(endpoint, config)
            const respondjson = await response.json();

            let responsestringfy = JSON.stringify(respondjson);
            let stringyjson= JSON.parse(responsestringfy);
            this.imgurl= stringyjson.data.display_url;
            console.log('imgurl:  '+this.imgurl);
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
    saveClient(){
        //this.isLoaded = true;
        insertClientRecord({
            clientName : this.clientName,
            phone : this.phone,
            dob : this.dob,
            gender : this.gender,
            billingStreet : this.Street,
            billingCity : this.City,
            billingState : this.State,
            billingzipcode : this.Zipcode,
            billingCountry : this.Country,
            countryOfBirth : this.countryOfBirth,
            language : this.language,
            accountimageURL : this.imgurl
        })
        .then(result => {
            console.log('saved');
            //this.isLoaded = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Client Created SuccessFully',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
           // this.isLoaded = true;
            console.log('Client creation Error :'+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error While Creating client record',
                    variant: 'error',
                }),
            );
            
        });

        const redirectURL =this.domainName+'myclientsview';
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
    cancel(){
        const redirectURL =this.domainName+'myclientsview';
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