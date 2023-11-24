import { LightningElement,track,api,wire } from 'lwc';
import getControllingPicklistOptions from '@salesforce/apex/ElderlyCareProgressNotes.getControllingValue';
import getDependentPicklistOptions from '@salesforce/apex/ElderlyCareProgressNotes.getDependentPicklistOptions';

export default class DemoComponent extends LightningElement {
@track controllingOptions;
@track dependentOptions;
@track controllingValue;
@track dependentValue;

@track controllingMap =[];
@track selectedOptions;

@track dependentMap;
@track dependentSelectedOptions;

    @wire(getControllingPicklistOptions)
    wiredControllingPicklistOptions({ error, data }) {
        if (data) {
            this.controllingOptions = data;
            for (var key in this.controllingOptions) {
                console.log('key :'+key)
                this.controllingMap.push({
                label : this.controllingOptions[key],
                value: this.controllingOptions[key]
            });
        }
        this.selectedOptions=(this.controllingMap);
            console.log('controllingMap :'+JSON.stringify(this.controllingMap));
        } else if (error) {
            console.error('Error loading controlling picklist options', error);
        }
    }

  handleControllingValueChange(event) {
    this.controllingValue = event.target.value;
    console.log('controllingValue :'+this.controllingValue)
    this.dependentValue = null;
    this.loadDependentPicklistOptions();
  }

loadDependentPicklistOptions() {
getDependentPicklistOptions({ controllingValue: this.controllingValue })
    .then((result) => {
        this.dependentOptions = result.map(option => ({ label: option, value: option }));
        console.log('dependentMap :'+this.dependentMap);
        this.dependentSelectedOptions=(this.dependentMap);
    })
    
    .catch((error) => {
    console.error('Error loading dependent picklist options', error);
    });
}

  handleDependentValueChange(event) {
    this.dependentValue = event.target.value;
    // Handle the selected dependent picklist value here if needed.
  }
}