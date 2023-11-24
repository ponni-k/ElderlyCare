import { LightningElement,track,api,wire } from 'lwc';
import getProgressNotes from '@salesforce/apex/ElderlyCareProgressNotes.retriveProgressNotes';
import getFilterRecords from '@salesforce/apex/ElderlyCareProgressNotes.getFilterRecords';
import searchServiceRecords from '@salesforce/apex/ElderlyCareProgressNotes.retriveServiceItems';
import { refreshApex } from '@salesforce/apex';


const columns = [
    { label: 'Progress Notes Id', fieldName: 'Name' },
    // { label: 'TIme Sheet', fieldName: 'Time_Sheet__c' },
    { label: 'Carer', fieldName: 'Carer__r.Name' },
    { label: 'Client', fieldName: 'Client_Name__c' },
    { label: 'Progress Date', fieldName: 'Progress_Date__c', },
    { label: 'Services', fieldName: 'Service_Name__c',},
    { label: 'Service Description', fieldName: 'Service_Description__c',},
];


let i=0;

export default class EllderlyCareProgressNotesRecords extends LightningElement {

    page = 1; //initialize 1st page
    items = []; //contains all the records.
    data = []; //data  displayed in the table
    columns; //holds column info.
    startingRecord = 1; //start record position per page
    endingRecord = 0; //end record position per page
    pageSize = 10; //default value we are assigning
    totalRecountCount = 0; //total record count received from all retrieved records
    totalPage = 0; //total number of page is needed to display all records

    @track progressNotesRecord;
    @track progressNotesRecordError;
    @track selectedrecord;
    @track startDate;
    @track endDate;
    @track dataerror;
    @track error;
    @track tasks;
    @track listofobjects;
    @track errorMessage = '';
    @track isDisableGetRecords = true;
    @track serviceItemRecords =[];
    @track serviceItemError;
    @track searchTerm;
    @track showDropdown = false;
    @track serviceName = '';
    @track isNoRecords = false;
    @track isRecords= false;
    @api iconName = 'standard:account';

    handleServiceChange(event){
        this.searchTerm = event.target.value;
        console.log('searchTerm :'+this.searchTerm);
        if (this.searchTerm.length >= 1 && this.searchTerm != null) {
            this.getSuggestions();
        }
        else {
            this.showDropdown = false;
            this.serviceItemRecords = [];
        }
        if(this.searchTerm  ='' && this.searchTerm == null){
            this.isDisableGetRecords = true;
        }
    }

    handleSuggestionClick(event) {
        const selectedId = event.currentTarget.outerHTML.match(/title="(.*?)"/)[1];;
        console.log('selectedId :'+selectedId);
        this.serviceName = selectedId.replace(/['"]/g, '');
        console.log('serviceName :'+this.serviceName);
        this.showDropdown = false;
        this.isDisableGetRecords = false;
    }

    handleCarerChange(event){
        this.selectedrecord = event.detail.selectedRecord.Id;
        //console.log('Selected Record :'+this.selectedrecord);
        this.isDisableGetRecords = false;
    }
    getSuggestions() {
        searchServiceRecords({ searchTerm: this.searchTerm })
            .then((data) => {
                this.serviceItemRecords = data;
                //console.log('this.serviceItemRecords :'+JSON.stringify(this.serviceItemRecords))
                this.showDropdown = true;
            })
            .catch((error) => {
                console.error('Error fetching suggestions:', error);
            });
    }

    handleClientChange(event){
       this.selectedClientrecord = event.detail.selectedRecord.Id;
        //console.log('selectedClientrecord :'+this.selectedClientrecord);
        this.isDisableGetRecords = false;
    }

    handleStartDate(event){
        this.startDate = event.target.value;
        //console.log('startDate :'+this.startDate)
        this.validateDates();
    }

    handleEndDate(event){
        this.endDate = event.target.value;
        //console.log('endDate :'+this.endDate)
        this.validateDates();
    }

    validateDates() {
        if (this.startDate && this.endDate) {
            if (this.startDate > this.endDate) {
                this.errorMessage = 'Start date cannot be greater than end date.';
                this.isDisableGetRecords = true;
            } else {
                this.errorMessage = '';
                this.isDisableGetRecords = false;
            }
        }
    }
    
    @track carername;
    @wire(getProgressNotes)
    wiredNamesList({ data, error }) {
        if (data) {
            if(data.length>1){
                this.isRecords = true;
                this.isNoRecords = false;
                this.disableDownLoadBtn = false;
                this.items =  data.map(record => Object.assign({ 
                    "Carer__r.Name": (record.Carer__c != null && record.Carer__c != '') ? record.Carer__r.Name: '',
                    "Client__r.Name": (record.Client__c != null && record.Client__c != '') ? record.Client__r.Name: '',
                    "Service_Items__r.Name": (record.Service_Items__c != null && record.Service_Items__c != '') ? record.Service_Items__r.Name: ''
                },record));
                //here we slice the data according page size
                this.data = this.items.slice(0,this.pageSize); 
                this.endingRecord = this.pageSize;
                this.columns = columns;
                this.totalRecountCount = data.length;
                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                this.progressNotesRecordError = undefined;
            } else {
                this.isRecords = false;
                this.isNoRecords = true;
            }
        } else if (error) {
            // Handle error if needed
            this.progressNotesRecordError = error;
        }
    }

    
    //press on previous button this method will be called   
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }
 
    //press on next button this method will be called
    nextHandler() {
        if((this.page < this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }             
    }
 
    //this method displays records page by page
    displayRecordPerPage(page){
         
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount)? this.totalRecountCount : this.endingRecord; 
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
 
        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;
    }    
 
    showToast(message, variant, title) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    // @wire(getFilterRecords, {carerid: '$selectedrecord' ,serviceName :'$serviceName',clientid: '$selectedClientrecord',serviceId :'$serviceChange', startdate: '$startDate' ,enddate: '$endDate'})
    // wiredApexMethod({ error, result }) {
    //     if (result) {
    //         this.listofobjects = JSON.parse(JSON.stringify(result));
    //         console.log('this.listofobjects :'+JSON.stringify(this.listofobjects));
    //         this.items =  this.listofobjects.map(record => Object.assign({ 
    //             "Carer__r.Name": (record.Carer__c != null && record.Carer__c != '') ? record.Carer__r.Name: '',
    //         },record));
    //         this.data = this.items.slice(0,this.pageSize);
    //         console.log('this.data '+JSON.stringify(this.data));
    //         this.endingRecord = this.pageSize;
    //         this.columns = columns;
    //         this.totalRecountCount = this.data.length;
    //         this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
    //         this.progressNotesRecordError = undefined;
    //         this.dataerror = undefined;
            
    //     } else if (error) {
    //         console.log('error :'+JSON.stringify(error))
    //         this.dataerror = error;
    //         console.log('IMP data :'+JSON.stringify(this.dataerror));
    //         this.data = undefined;
    //     }
    // }
    

   
    handleGetRecords(){
        if(!this.serviceName.trim() || this.serviceName == null || this.serviceName == ''){
            throw new Error('Service field Should Not be blank.');
        }
        getFilterRecords({ carerid: this.selectedrecord ,serviceName :this.serviceName,clientid: this.selectedClientrecord,serviceId :this.serviceChange, startdate: this.startDate ,enddate: this.endDate })
        .then(result => {
            if(result.length >= 1){
                this.isDisableGetRecords = false
                this.disableDownLoadBtn = false;
                this.isRecords = true;
                this.isNoRecords = false;
                this.listofobjects = JSON.parse(JSON.stringify(result));
                this.items =  this.listofobjects.map(record => Object.assign({ 
                    "Carer__r.Name": (record.Carer__c != null && record.Carer__c != '') ? record.Carer__r.Name: '',
                },record));
                this.data = this.items.slice(0,this.pageSize);
                this.endingRecord = this.pageSize;
                this.columns = columns;
                this.totalRecountCount = this.data.length;
                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                this.progressNotesRecordError = undefined;
                this.dataerror = undefined;
            } else {
                this.isDisableGetRecords = true;
                this.isRecords = false;
                this.isNoRecords = true;
                this.disableDownLoadBtn = true;
            }
        })
        .catch(error => {
            this.isNoRecords = true;
            this.disableDownLoadBtn = true;
            //console.log('error :'+JSON.stringify(error))
            this.dataerror = error;
            //console.log('IMP data :'+JSON.stringify(this.dataerror));
            this.data = undefined;
        });
    }


    columnHeader = ['Progress Notes Id', 'Carer', 'Client','Duty Date', 'Service','Service Description'];
    handleDownloadReports(){
        let abrecfull= [];
        if(abrecfull= ''){
           // this.disableDownLoadBtn = false;
        } 
        //abrecfull= this.defdaultattreport == false ? this.attendancedata : this.defdaultattreport;
        abrecfull= this.data;
        //console.log('abrecfull-->'+abrecfull);
        
        //console.log('defdaultattreport-->'+JSON.stringify(defdaultattreport))
        //console.log('===>download csv btn clicked=<==='+JSON.stringify(abrecfull));
        // Prepare a html table
        let doc = '<table>';
        // Add styles for the table
        doc += '<style>';
        doc += 'table, th, td {'
        doc += '    border: 1px solid black;';
        doc += '    border-collapse: collapse;';
        doc += '}';          
        doc += '</style>';
        // Add all the Table Headers
        doc += '<tr>';
        this.columnHeader.forEach(element => {            
            doc += '<th>'+ element +'</th>'           
        });
        doc += '</tr>';
        // Add the data rows
        abrecfull.forEach(record => {
            doc += '<tr>';
            doc += '<th>'+record.Name+'</th>'; 
            doc += '<th>'+record.Carer__r.Name+'</th>'; 
            doc += '<th>'+record.Client_Name__c+'</th>';
            doc += '<th>'+record.Progress_Date__c+'</th>'; 
            doc += '<th>'+record.Service_Name__c+'</th>'; 
            doc += '<th>'+record.Service_Description__c+'</th>'; 
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        const date = new Date();
        let currentDay= String(date.getDate()).padStart(2, '0');
        let currentMonth = String(date.getMonth()+1).padStart(2,"0");
        let currentYear = date.getFullYear();
        // we will display the date as DD-MM-YYYY 
        let currentDate = `${currentDay}-${currentMonth}-${currentYear}`;
        downloadElement.download = currentDate+' Reports.xls';
        document.body.appendChild(downloadElement); 
        downloadElement.click();
    }
}