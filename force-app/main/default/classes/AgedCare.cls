global class AgedCare {
    @Auraenabled(cacheable=true)
    
    global static list<SalesforceEssentialWrapper> getSalesforceEssentialList(){
        list<SalesforceEssentialWrapper> lstwrap = new list<SalesforceEssentialWrapper>();
        list<SalesforceEssentials__c> lstEsstentialList = [select id,Name,IsAvailable__c,Image_Url__c,Help_Text__c from SalesforceEssentials__c];
        for(SalesforceEssentials__c se : lstEsstentialList){
            //system.debug('se--->'+se);
            SalesforceEssentialWrapper salesforcelistWrapper = new SalesforceEssentialWrapper();
            salesforcelistWrapper.name = string.valueof(se.Name);
            salesforcelistWrapper.value = string.valueof(se.Id);
            salesforcelistWrapper.essentialImage = se.Image_Url__c;
            lstwrap.add(salesforcelistWrapper);
        } 
        system.debug('Name--->'+lstwrap);
        return lstwrap;
    }
    global class SalesforceEssentialWrapper { 
        @AuraEnabled 
        public String name;
        @AuraEnabled
        public string value; 
        @AuraEnabled
        public string essentialImage;  
    }
    @Auraenabled(cacheable=true) 
    global static list<SalesforceFeaturesWrapper> getFeaturesvalue(String recordId){
        //system.debug('apfieldname--->'+recordId);
        list<SalesforceFeaturesWrapper> lstfeaturewrapper = new list<SalesforceFeaturesWrapper>();
        //Decimal priceValue = 0;
        list<SalesforceFeatures__c> lstFeat = [select id,Name,IsAvailable__c,imageURL__c,Duration__c,HelpText__c,SalesforceEssentialList__r.Name,youtube__c from SalesforceFeatures__c where SalesforceEssentialList__c=:recordId];
        for(SalesforceFeatures__c fea: lstFeat){
            SalesforceFeaturesWrapper sfnew = new SalesforceFeaturesWrapper(); 
            sfnew.value = string.valueOf(fea.id);
            sfnew.label = string.valueOf(fea.Name);
            sfnew.featuresIdValue = string.valueOf(fea.Id);
            sfnew.essentials =string.valueOf(fea.SalesforceEssentialList__c); 
            sfnew.essentialImage=fea.imageURL__c;
            sfnew.youtubee=fea.youtube__c;
            //sfnew.totalPriceValue=priceValue+fea.Price__c; 
            lstfeaturewrapper.add(sfnew);
        }
        system.debug('line 36::--->'+lstFeat);
        return lstfeaturewrapper; 
    }
    
    global class SalesforceFeaturesWrapper {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public string value; 
        @AuraEnabled
        public string featuresIdValue;
        @AuraEnabled
        public string essentialImage;
        @AuraEnabled
        public string essentials;
        @AuraEnabled
        public string youtubee;
        /*@AuraEnabled
public Decimal totalPriceValue;*/
        
    }
    @Auraenabled
    global static list<SalesforceFeatures__c> getFeaturesSummary(list<string> lstRecord){
        list<SalesforceFeatures__c> lstSummary = [select id,Name,IsAvailable__c,imageURL__c,Duration__c,HelpText__c,SalesforceEssentialList__c from SalesforceFeatures__c where id=:lstRecord];
        //list<string> lstid = lstRecord.split(',');
        //system.debug('lstSummary==>'+lstSummary);
        return lstSummary;  
    }
    
    @AuraEnabled
    public static SalesforceFeatures__c selectedSummaryDetails(string summaryValue){
        SalesforceFeatures__c summaryVal = [select id,Name,IsAvailable__c,imageURL__c,Duration__c,HelpText__c,SalesforceEssentialList__c,Price__c from SalesforceFeatures__c where id=:summaryValue];
        return summaryVal;
        
    }
    
    @Auraenabled
    global static list<decimal> getpriceandduration(list<string> lstRecord){
        list<SalesforceFeatures__c> lstSummary = [select id,Name,Price__c,Duration__c from SalesforceFeatures__c where id=:lstRecord];
        decimal totalprice=0;
        decimal totalduration=0;
        list<decimal> summarytotals=new list<decimal>();
        for(SalesforceFeatures__c lst:lstSummary)
        {
            totalprice=totalprice+lst.price__c;
            totalduration=totalduration+Integer.valueOf(lst.Duration__c);
        }
        summarytotals.add(totalprice);
        summarytotals.add(totalduration);
        //system.debug(totalprice);
        //system.debug(totalduration);
        return summarytotals;
    }
    
    @Auraenabled
    global static void createLead(string salutation,string firstname,string lastname,string companyinfo,string email,string phone,string description,string comment){
        system.debug('phone :'+phone);
        try {
            Lead ld = new Lead();
            RecordType recordType = [SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName = 'SalesforceEssentials' AND SObjectType = 'Lead' LIMIT 1];
            
            ld.RecordTypeId = recordType.Id;
            ld.Salutation = salutation;
            ld.FirstName = firstname;
            ld.LastName= lastname;
            ld.Company = companyinfo;
            ld.Email = email;
            ld.Phone = phone;
            ld.Status = 'Open - Not Contacted';
            ld.Description = description;
            ld.LeadsComments__c=comment;
            insert ld;
            
            
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    } 
}