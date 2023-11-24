import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import images from '@salesforce/resourceUrl/ElderlyCareRisk';
import getRiskAlertDetails from '@salesforce/apex/ElderlyCare.getriskAlertDetails';
import getRiskAlertDetailsValue from '@salesforce/apex/ElderlyCare.getRiskAlertdetails1';
import { loadScript } from 'lightning/platformResourceLoader';



export default class ElderlyCareRiskAlert extends LightningElement {
    @api recordId;
    @track isResourceLoaded = false;
    @track detailsvalue;
    @track quickActionArray=[];
    @api isLoaded = false;
    connectedCallback(){
        //console.log('RiskImages :'+images)
        getRiskAlertDetails()
        .then(result=>{
            this.detailsvalue = result;
                result.forEach(row => { 
                //console.log('@@row-->'+JSON.stringify(row)); 
                this.quickActionArray.push({ 
                    name: row.Risk_Name__c,
                    label: row.Label,
                    order:row.Risk_Order__c,
                    image : images+'/'+row.Risk_Logo__c+".png",
                    //img1 :'resource/ElderlyCareRisk/Environment.JPG'
                }); 
                console.log('quickActionArray :'+JSON.stringify(this.quickActionArray));
            });
        })
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
            //console.log('currentPageReference-->'+JSON.stringify(currentPageReference));
            this.urlId = currentPageReference.attributes.recordId;
            //console.log('urlId :'+JSON.stringify(this.urlId));
        }
    }

    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    @track labelname;
    @track alertvalues;
    @track alertError;
    @track isRiskValue = false;
    @track isRiskValue = false;
    handleRiskAlert(event) {
        this.isLoaded = true;
        this.isModalOpen = true;
        this.labelname = event.target.alt;
        
        //console.log('labelname :'+this.labelname);

        getRiskAlertDetailsValue({ eventRecordId: this.urlId , riskLabel : this.labelname})
        .then(result => {
            this.isLoaded = false;
            //console.log('risk result :'+JSON.stringify(result))
            this.alertvalues = result;
            this.alertError = undefined;
            this.isRiskValue = true;
            
            //this.error = undefined;
        })
        .catch(error => {
            //console.log('risk error:'+JSON.stringify(error))
           // this.isLoaded = true;
            this.alertvalues = error;
            this.alertError = error ;
            this.isRiskValue = false;
        });
    }
    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        this.isModalOpen = false;
    }
}