import { LightningElement,track } from 'lwc';
import getCurrentUserDetails from '@salesforce/apex/ElderlyCareHomePage.getUserDetails';
import updateCareravailability from '@salesforce/apex/ElderlyCareHomePage.updateCarer';
export default class ElderlyCareProfilePage extends LightningElement {

    @track userName;
    @track userid;
    @track profilePicture;  
    @track address;
    @track hourlyPrice;
    @track skills;
    @track languagesSpoken;
    @track age;
    @track email;
    @track phone;
    @track availability;
    @track isModalOpen = false;
    @track startDate;
    @track endDate;

    connectedCallback(){
        getCurrentUserDetails()
        .then(result => {
           
            this.userName = result[0].carername;
            this.userid = result[0].userid;
            this.profilePicture = result[0].profilePicture;
            this.phone = result[0].carerphone;
            this.email = result[0].careremail; 
            this.address = result[0].careraddress;
            this.age = result[0].carerage;
            this.hourlyPrice = result[0].carerhourlyprice;
            this.skills = result[0].carerskills;
            this.availability = result[0].careravailability;
            this.startDate = result[0].careravailableStartDate;
            this.enddate = result[0].careravailableEndDate;
            console.log('userName :'+this.userName);
        })
        .catch(error => {
            console.log('Current USer error: '+JSON.stringify(error))
        });
    }
    openavailability() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    get statusOptions() {
        return [
            { label: 'Not Available', value: 'Not Available' },
            { label: 'Available', value: 'Available' },
           
        ];
    }
    handleavailability(event){
        this.availability = event.target.value;
        
    }
    handleStartDate(event){
        this.startDate= event.target.value;
        
    }
    handleEndDate(event){
        this.endDate = event.target.value;
        

    }
    submitAvailability(){
        this.isLoaded = true;
        updateCareravailability({
            availability:this.availability,
            startdate:this.startDate,
            enddate:this.endDate
        })
        .then(result => {
            console.log('saved');
            this.isLoaded = false;
            this.isModalOpen = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Availability updated SuccessFully',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            this.isLoaded = true;
            console.log('Incident Error :'+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error While updating availability Report',
                    variant: 'error',
                }),
            );
            this.isModalOpen = true;
        });
    }


}