global with sharing  class ElderlyCareInvoiceGeneration {
    global list<Time_Sheet__c> timesheet {get;set;}
    @AuraEnabled
    global static ClientInvoiceWrapper getRecordsForClient(string clientid,date startDate, Date endDate) {
        system.debug('clientid :'+clientid);
        system.debug('startDate :'+startDate);
        system.debug('endDate :'+endDate);
        date d1 = date.valueof(startDate);
        Decimal totalprice;
        list<Time_Sheet__c> clientinvoicerecord = [select id,name,Account_Name__c,Service_Name__c,Service_Items__r.Name,Service_Items__c,Account_Name__r.Name,Account_Name__r.Billingstate,Account_Name__r.BillingCity, Account_Name__r.BillingStreet, Account_Name__r.BillingCountry, Account_Name__r.BillingPostalCode,Service_provider__c,Start_Date__c,End_Date__c,Time_Duration__c,Price__c,Homecare_Product__c,Start_Time__c,End_time__c,AgedCare_Product__r.Name,Carer_Name__c from Time_Sheet__c  WHERE Account_Name__c =:clientid AND Start_Date__c >=:startDate AND End_Date__c <=:endDate];
        system.debug('clientinvoicerecord :'+clientinvoicerecord);
        list<Invoice__c> lstInvoice = [SELECT Id, Name, Generated_Date__c, Invoice_Number__c,CreatedDate FROM Invoice__c where Invoice_Number__c!=null ORDER BY Invoice_Number__c DESC LIMIT 1];
        Integer randomThreeDigitNumber = Integer.valueOf(Math.floor(Math.random() * 900) + 100);
        String idAsString = String.valueOf(clientinvoicerecord[0].id);
        String invoiceNumber ='INV-'+ Date.today().Year()+Date.today().month()+Date.today().Day()+ idAsString.substring(idAsString.length() - 3)+randomThreeDigitNumber;
        
        Pagereference pg = Page.ElderlyCareInvoiceGeneration;
        Decimal gstPercentage = 10.00;
        Double baseValue = 100.00;
        Double GSTValue = (gstPercentage / 100);
        decimal i=0;
        Decimal finalAmountWithGST = 0;
        date dt;
        for(Time_Sheet__c t:clientinvoicerecord){
            Decimal totalamount = t.Price__c * GSTValue;
            Decimal invPlusGSTAmount = totalamount + t.Price__c;
            finalAmountWithGST += invPlusGSTAmount;
            i += t.Price__c;
            pg.getParameters().put('invoiceNumber',invoiceNumber);
            pg.getParameters().put('clientname',t.Account_Name__r.Name);
            pg.getParameters().put('invoicestartdate',string.valueOf(startDate));
            pg.getParameters().put('invoiceenddate',string.valueOf(endDate));
            pg.getParameters().put('billingstate',t.Account_Name__r.Billingstate);
            pg.getParameters().put('billingcity',t.Account_Name__r.BillingCity);
            pg.getParameters().put('billingstreet',t.Account_Name__r.BillingStreet);
            pg.getParameters().put('billingcountry',t.Account_Name__r.BillingCountry);
            pg.getParameters().put('postalcode',t.Account_Name__r.BillingPostalCode);
            pg.getParameters().put('startdate',string.valueOf(t.Start_Date__c));
            pg.getParameters().put('enddate',string.valueOf(t.End_Date__c));
            pg.getParameters().put('timeduration',string.valueOf(t.Time_Duration__c));
            pg.getParameters().put('price',string.valueOf(t.Price__c));
            pg.getParameters().put('starttime',string.valueOf(t.Start_Time__c));
            pg.getParameters().put('endtime',string.valueOf(t.End_time__c));
            pg.getParameters().put('serviceItem',t.Service_Name__c);
            system.debug('---->'+pg.getParameters().put('serviceItem',t.Service_Items__r.Name));
            pg.getParameters().put('clientid',t.Account_Name__c);
            pg.getParameters().put('timesheetid',t.Id);
        }        
        pg.getParameters().put('invoicestartdate',string.valueof(startDate));
        pg.getParameters().put('invoiceenddate',string.valueof(endDate));
        
        set<id> dd=new set<id>();
        List<ContentDocumentLink> ContentDocumentLinkList =[SELECT ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: clientid order by ContentDocumentId];
        for(ContentDocumentLink cd: ContentDocumentLinkList){
            dd.add(cd.ContentDocumentId);
        }
        List<ContentVersion> cvList3 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: dd]; 
        Integer count=cvList3.size()+1;  
        ContentVersion v = new ContentVersion();
        if(Test.isRunningTest()){
            v.versionData = blob.valueOf('Unit.Test');
        }else{
            v.versionData = pg.getContentAsPDF();
        }	
        //v.FirstPublishLocationId = inv.id;
        v.FirstPublishLocationId = clientid;
        v.title = 'Invoice'+'-'+'V'+count;
        v.pathOnClient ='/invoice.pdf';
        insert v;
        String pdfUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/sfc/servlet.shepherd/version/download/' +v.id;
        
        List<Invoice__c> lst = new list<Invoice__c>();
        for(integer ival=0;ival<clientinvoicerecord.size();ival++){
            Invoice__c inv = new Invoice__c();
            inv.Client_Name__c = clientinvoicerecord[ival].Account_Name__c;
            inv.Carer_Name__c =  clientinvoicerecord[ival].Carer_Name__c;
            inv.Service_Items__c = clientinvoicerecord[ival].Service_Items__c;
            inv.Amount__c = string.valueof(clientinvoicerecord[ival].Price__c);
            inv.Invoice_URL__c = pdfUrl;
            Datetime invoiceGeneratedDate = system.now();
            Datetime invoiceDueDate = system.now()+10;
            inv.Generated_Date__c = system.now();
            inv.Invoice_Number__c = invoiceNumber;
            inv.Generated_Date__c = invoiceGeneratedDate;
            lst.add(inv);
        }
        if(!lst.isempty()){
            insert lst;
        } 
        
        ClientInvoiceWrapper cw = new ClientInvoiceWrapper();
        cw.tm=clientinvoicerecord;
        cw.totalprice=finalAmountWithGST;
        system.debug('lstCLientInvoiceWrapper :'+cw);
        pg.getParameters().put('totalprice',string.valueof(totalprice));
        return cw; 
    }
    global class ClientInvoiceWrapper{
        @Auraenabled
        global list<Time_Sheet__c> tm;
        @Auraenabled
        global Decimal totalprice;
    }
}