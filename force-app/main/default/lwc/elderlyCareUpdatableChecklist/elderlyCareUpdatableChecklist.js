import {LightningElement,api,wire,track} from 'lwc';
import Icon_Image from '@salesforce/resourceUrl/Checklist';
import {CurrentPageReference
} from 'lightning/navigation';
import getCheckListRecord from '@salesforce/apex/ElderlyCareChecklist.getchecklistValue';
import getCarerAdminCheckList from '@salesforce/apex/ElderlyCareChecklist.getCarerAdminchecklistValue';
export default class ElderlyCareUpdatableChecklist extends LightningElement {
    @api recordId;
    urlId;
    @track isModalOpen = false;
    subject;
    @track keys;
    @track values;
    @track recid = '00U0p00000LLlrFEAT';
    @api selectedValues = [];
    @track serviceImge;
    @track keyString = '';
    @track emptyChecklist = false;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlId = currentPageReference.attributes.recordId;
        }
    }

    @wire(getCheckListRecord, {
        eventId: '$urlId'
    })
    wiredRecord({
        error,
        data
    }) {
        if (data) {
            this.keys = Object.keys(data);
            const keyStr = JSON.stringify(this.keys);
            const keyStringValue = keyStr.replace(/\[|\]/g, ''); // Remove square brackets
            const stringList = keyStr.split(',');
            this.keyString = keyStr.replace(/[\[\]",/ /]+/g, '');
            console.log(this.keyString );
            this.serviceImge = Icon_Image + '/' + this.keyString + ".png";
            this.values = Object.values(data);
            const varStr = JSON.stringify(this.values);
            const ValueString = varStr.replace(/\[|\]/g, ''); // Remove square brackets
            if (keyStringValue.localeCompare(ValueString) === 0) {
                this.emptyChecklist = true;
            } else {
                this.emptyChecklist = false;
                const valuesArray = Object.keys(this.values).map(key => this.values[key]);
                const str = valuesArray.join(',');
                this.splitstr = str.split(',');
            }
        } else if (error) {
            console.error('@@@ERROR: ' + JSON.stringify(error));
        }
    }
    @track serviceName;
    @track carerserviceImge;
    @track keyString1;
    @track checklistvalues;
    @wire(getCarerAdminCheckList, {eventId: '$urlId'})
    wiredRecordValue({error,data}){
        if (data) {
            this.serviceName = Object.keys(data);
            const keyStr1 = JSON.stringify(this.serviceName);
            const keyStringValue1 = keyStr1.replace(/\[|\]/g, ''); // Remove square brackets
            console.log('keyStringValue1@@: '+keyStringValue1);
            const stringList1 = keyStr1.split(',');
            this.keyString1 = keyStr1.replace(/[\[\]",/ /]+/g, '');
            console.log(this.keyString1 );
            this.carerserviceImge = Icon_Image + '/' + this.keyString1 + ".png";
            this.checklistvalues = Object.values(data);
            const varStr1 = JSON.stringify(this.checklistvalues);
            const ValueString1 = varStr1.replace(/\[|\]/g, ''); 
            console.log('ValueString1@@ '+ValueString1);    
            if (keyStringValue1.localeCompare(ValueString1) === 0) {
                this.emptyChecklist1 = true;
            } else {
                this.emptyChecklist1 = false;
                const valuesArray1 = Object.keys(this.checklistvalues).map(key => this.checklistvalues[key]);
                const str1 = valuesArray1.join(',');
                this.splitstr1 = str1.split(',');
                console.log('splitstr1:  '+this.splitstr1);
            }
        } 
            else if(error)  {
            console.error('@@@ERROR@@@: '+JSON.stringify(error));
        }
    }
    
    handleCheckboxChange(event) {
        const value = event.target.dataset.value;
        const checked = event.target.checked;
        if (checked) {
            this.selectedValues.push(value);
        } else {
            this.selectedValues = this.selectedValues.filter(item => item !== value);
        }
    }
    openChecklist() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.selectedValues = [];
    }
    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        const selectedChecklistValues = new CustomEvent("checklistvaluechange", {
            detail: this.selectedValues
        });
        this.dispatchEvent(selectedChecklistValues);
        this.isModalOpen = false;
    }
}