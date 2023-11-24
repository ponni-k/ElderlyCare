import { LightningElement,api,wire ,track} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
// import { getRecord } from "lightning/uiRecordApi";
import getCheckListRecord from '@salesforce/apex/ElderlyCareChecklist.getchecklistValue';
import getCarerAdminCheckList from '@salesforce/apex/ElderlyCareChecklist.getCarerAdminchecklistValue';
import Icon_Image from '@salesforce/resourceUrl/Checklist';
import { decodeDefaultPageReference } from 'lightning/pageReferenceUtils';

export default class ElderlyCareChecklist extends LightningElement {
@api recordId;
urlId;
@track isModalOpen = false;
subject;
@track keys ;
@track values;
@track recid = '00U0p00000LLlrFEAT';
@track serviceImge;
@track keyString = '';
@track emptyChecklist = false;
siteName = '';


@wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
    if (currentPageReference) {
        console.log('currentPageReference-->' + JSON.stringify(currentPageReference));
        this.urlId = currentPageReference.attributes.recordId;
        }
}


@track stringArray= [];
    @track splitstr;


@wire(getCheckListRecord, {eventId: '$urlId'})
wiredRecord({error,data}){
    if (data) {
        this.keys = Object.keys(data);
        console.log('keys: '+this.keys)
        const keyStr = JSON.stringify(this.keys);
        const keyStringValue = keyStr.replace(/\[|\]/g, ''); 
        console.log('keyStringValue@@: '+keyStringValue);
        const stringList = keyStr.split(',');
        this.keyString = keyStr.replace(/[\[\]",/ /]+/g, '');
        console.log(this.keyString );
        this.serviceImge = Icon_Image + '/' + this.keyString + ".png";
        this.values = Object.values(data);
        const varStr = JSON.stringify(this.values);
        console.log('Checklist Values: '+varStr)
        const ValueString = varStr.replace(/\[|\]/g, ''); // Remove square brackets
        console.log('ValueString:  '+ValueString);
        if (keyStringValue.localeCompare(ValueString) === 0) {
            this.emptyChecklist = true;
        } else {
            this.emptyChecklist = false;
            const valuesArray = Object.keys(this.values).map(key => this.values[key]);
            const str = valuesArray.join(',');
            this.splitstr = str.split(',');
            console.log('splitstr====>  '+this.splitstr)
        }
    } 
        else if(error)  {
        console.error('@@@ERROR: '+JSON.stringify(error));
    }
}
  

openChecklist() {
    // to open modal set isModalOpen tarck value as true
    this.isModalOpen = true;
}
closeModal() {
    this.isModalOpen = false;
}
submitDetails() {
    this.isModalOpen = false;
    
    if(this.keys==true){
        console.log('Key Value:  '+this.keys);
        const selectedChecklistValues = new CustomEvent("checklistvaluechange", {
            detail: this.splitstr
        });
        this.dispatchEvent(selectedChecklistValues);
        
    }
    else if(this.serviceName==true){
        console.log('Key Value:  '+this.serviceName);

        const selectedChecklistValues = new CustomEvent("checklistvaluechange", {
            detail: this.splitstr1
        });
        this.dispatchEvent(selectedChecklistValues);
        
    }
    
    
}
    
}