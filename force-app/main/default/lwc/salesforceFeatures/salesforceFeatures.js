import { LightningElement,api,track,wire } from 'lwc';
import getSalesforcefeatures from '@salesforce/apex/AgedCare.getFeaturesvalue';
import { publish,subscribe,unsubscribe,createMessageContext,releaseMessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import images from '@salesforce/resourceUrl/SalesforceEsscentials';
import SAMPLEMC from "@salesforce/messageChannel/MyMessageChannel__c";
import SAMPLEMC1 from "@salesforce/messageChannel/AnotherMessageChannel__c";

export default class SalesforceFeatures extends LightningElement {
    @track receivedMessage = '';
    @track myMessage = '';
    subscription = null;
    @track featuresList;
    @track featuresError;
    @track quickActionArray=[];
    @track recid;
    context = createMessageContext();
    context1 = createMessageContext(); 
    openvideo=false;
    openyellowslip=true;
    youtube=images + '/images/youtube.jpg';
    sfdcessentials=images +'/images/salesforcefuntions.jpg'
    sfdcfeatures=images +'/images/Salesforcefeatures.jpg' 
    selectVideo;
    sfdcfunction;
    constructor() {
        super();  
    }
 
    connectedCallback(){
       // console.log('connectedCallback run')
        this.subscribeMC();
    }
    subscribeMC(){
        if(this.subscription){
            return;
        }
        this.subscription = subscribe (this.context,SAMPLEMC,(message)=>{
            this.handleMessage(message);
        }, {scope:APPLICATION_SCOPE});
    }

   
    featuresarr=[];
    handleMessage(message){
        console.log('salesforceFeatures');
        console.log("message:::"+JSON.stringify(message));
        this.recid = message.recordId;
        this.selIndx = message.selectedIndex;
        this.sfdcfunction=message.label;
        console.log('selectted index Feature ====>'+this.selIndx);
        this.receivedMessage = message?message.recordData.value:'No message'; 

        getSalesforcefeatures({recordId: this.recid})
            .then((result) => {
               this.openyellowslip=false;
               this.featuresList = result;
               this.featuresarr=[]
                result.forEach(row => { 
                this.featuresarr.push({
                    name:row.label,
                    idval:row.value,
                    image:row.essentialImage,
                    essentials:row.esstentials ,
                    youtube:row.youtubee,
                    isChecked : false
                });
            });
           
            })
            .catch((error) => {
                this.featuresError = error;
                this.featuresList = undefined;
            });
    }

    @track selectedFeaturesVal = [];
    @track setValue =[];
    @track selfinalval = [];  
    selecteFeatureslabel;
    
    handleSelectFeatures(event){
        this.selectedFeaturesValue = event.target.value;
        this.selecteFeatureslabel=event.target.label;
        this.selfinalval.push(this.selectedFeaturesValue);
        const message1 = {
                //recordId : event.target.value,
                recordId : this.selfinalval,
                selval : this.selIndx,
                selectedFeaturesval : this.selfinalval 
                //recordData :  {value : 'message from lWC'}
            };
            this.handleinformation(this.selfinalval);
            publish (this.context1,SAMPLEMC1,message1); 
    }

    handleinformation(event){ 
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Info',
                message: 'Selected '+this.selecteFeatureslabel,
                variant: 'Info',
                 
            }),
        );
       }

    moreInfo(event){ 
        let selectId= event.currentTarget.dataset.id;
        console.log('The selecte video id is' ,selectId);
       let selectVideo=this.featuresarr.find(({idval})=>idval===selectId); 
        this.selectVideo=selectVideo.youtube;
        console.log('The selected viode is' ,this.selectedVideo); 
      
       this.openvideo=true;
      
      
    }  
    
    closevideo(){
        this.openvideo=false; 

    }

}