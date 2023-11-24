import { LightningElement,api,track ,wire} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord,updateRecord } from 'lightning/uiRecordApi';
import savephoto from '@salesforce/apex/ElderlyCareSelectedServices.updatePhoto';
import ID_FIELD from '@salesforce/schema/Account.Id';
import { refreshApex } from '@salesforce/apex';
export default class PhotoUpload extends LightningElement {


    @api recordId;
    @api objectApiName;
    fileData;
    imgdata;
    filestore;
    imgurl;
    @track originalname = 'Attachment'
    @track urlId;

     
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlId = currentPageReference.attributes.recordId;
       }
    }

    // @wire(getRecord, { recordId: '$urlId', fields: [ID_FIELD, Account_Image_URL] })
    // wiredRecord({ error, data }) {
    //     if (data) {
    //         this.recordDescription = data.fields.AccountImage_URL__c.value;
            
    //     } else if (error) {
    //         console.error('Error loading record', error);
    //     }
    // }

    
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
            
            savephoto({accId :this.urlId ,imgURL: this.imgurl})
            .then((result) =>{
                 if(result== 'TRUE')
                 {
                    location.reload();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Photo uploaded successfully',
                            variant: 'Success'
                        })
                    );  
                 }
                 else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Photo uploaded Error' +result,
                            variant: 'error'
                        })
                    );
                 }
            })
            .catch((error) => {
                console.log('The value of result ',error)
            });
           
           
        }

}