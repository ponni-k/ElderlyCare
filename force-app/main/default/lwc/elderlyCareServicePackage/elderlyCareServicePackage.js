import { LightningElement,track,api,wire } from 'lwc';
import servicePackages from '@salesforce/apex/ElderlyCare_CA_ServicePackage.getServicePackage';
import { CurrentPageReference } from 'lightning/navigation';
import insertServices  from '@salesforce/apex/ElderlyCare_CA_ServicePackage.insertServices';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import clientServices from '@salesforce/apex/ElderlyCare_CA_ServicePackage.getClientServices';


export default class ElderlyCareServicePackage extends LightningElement {

    @track isModalOpen = false;
    @api servicePackage = [];
    @track servicePackageerror;
    @track isAddServices;
    @track visibleRecords;
    urlId;
    @track clientServices;
    @track clientServiceerror;
    @track clientServiceName=[];
    @track clientNames=[];
    @track columns = [
        { label: 'Name', fieldName: 'Name',},
    ];
   
    //columns= columns;


    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        this.urlId = currentPageReference.attributes.recordId;
        }
    }
   

    @wire(servicePackages)
    wiredData({ data, error }) {
        if (data) {
            this.servicePackage =  data;
            console.log('servicePackage---->'+JSON.stringify(this.servicePackage));
            this.servicePackageerror = undefined;
        } else if (error) {
            this.servicePackage = undefined;
            this.servicePackageerror = error;
            console.log('servicePacage error->'+JSON.stringify(error));
        }
    }

    @wire(clientServices, {accId: '$urlId'})
    wired({ data, error }) {
        if (data) {
            this.clientServices =  data;
            for (const service of this.clientServices) {
                const ServiceName = service.Name;
                this.clientServiceName.push(ServiceName);
            }
            console.log('clientServiceName--->'+ this.clientServiceName);
            //console.log('clientServices---->'+JSON.stringify(this.clientServiceerror));
            this.clientServiceerror = undefined;
            for(const lstService of this.clientServices){
                    const Name = lstService.Client__r.Name;
                    this.clientNames.push(Name);
            }
            console.log('clientName--->'+ this.clientNames);
            
        } else if (error) {
            this.clientServices = undefined;
            this.clientServiceerror = error;
            console.log('clientServiceerror error->'+JSON.stringify(error));
        }
    }
    get clientName(){
        return this.clientNames.length > 0 ? this.clientNames[0] : 'No values';       
    }
    updateIncidentHandler(event){
        this.visibleRecords=[...event.detail.records];
        //console.log('update Incident Record :'+JSON.stringify(this.visibleRecords));
        console.log(event.detail.records)
    }


    @track selectedIds = [];

    @track selectedRows = []
    handleRowSelection(event){
        const selectedRows = event.detail.selectedRows;
        this.selectedIds = [];
        for (const row of selectedRows) {
            const selectedId = row.Id;
            this.selectedIds.push(selectedId);
        }
        console.log('Selected ID---->'+ this.selectedIds);
    }
    handleselecteServices(){
        this.isAddServices = true;
    }
    handleSaveServices(){
         insertServices({
            servicesId:this.selectedIds,
            clientId:this.urlId
        })
        .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'services Created SuccessFully',
                        variant: 'success',
                    }),
                );
                window.location.reload();
                }
             
        ).catch(error => {
           //console.log('Incident Error :'+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error While Creating service Record',
                    variant: 'error',
                }),
            );
           
        });
    }
        
       
       handleViewServices(){
        this.isModalOpen = true;
       }
       closeModal() {
        this.isModalOpen = false;
    }
    
}