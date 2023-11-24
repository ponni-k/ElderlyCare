import { LightningElement,api,track,wire } from 'lwc';
import getSalesforceList from '@salesforce/apex/AgedCare.getSalesforceEssentialList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, releaseMessageContext, createMessageContext } from "lightning/messageService";
import SAMPLEMC from "@salesforce/messageChannel/MyMessageChannel__c";

import images from '@salesforce/resourceUrl/SalesforceEsscentials';
//import listOfSEDetails from "@salesforce/apex/AgedCare.getEssDet";

export default class SalesforceEssentialList extends LightningElement {
    context = createMessageContext();
    @track listRecord;
    @track listRecordvalue=[];
    @track ltval;

    @track checkValue;
    @api selectedValue;


    @track detailsvalue;
    @track quickActionArray=[];

    connectedCallback(){
        console.log('Connected Callback');
        getSalesforceList()
        .then(result=>{
            this.detailsvalue = result;
                result.forEach(row => { 
                this.quickActionArray.push({ 
                    name:row.name,
                    idval:row.value,
                      image:images+'/'+row.essentialImage,
                      isChecked : false
                }); 
            });
            for(let i=0;i<this.quickActionArray.length;i++){
                this.quickActionArray[i] ['index'] = i;
             }
            
        })
       this.handleinformation();
       
    }
    

   handleinformation(event){
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Welcome',
            message: 'This site can be best viewed in Laptop & Desktop',
            variant: 'success',
            
        }),
    );
   }

    handleCheckChange(event){
        this.selectedValue = event.target.value; 
        this.selectdIndex = event.target.dataset.id;
       
        for(let i=0;i<this.quickActionArray.length;i++){
            //console.log('--iteration--->',i)
            if(this.selectdIndex!=i){
                this.quickActionArray[i] ['isChecked'] =false;
            }  else {
                this.quickActionArray[i] ['isChecked'] =true;
            }           

            
        }
       
        const message = {
            recordId : event.target.value,
            selectedIndex : event.target.dataset.id,
            labelvalue:event.target.label,
            recordData :  {value : 'message from lWC'}
           
        };
       
        publish (this.context,SAMPLEMC,message);
    }

    handleInputChange(event){
       

    }
}