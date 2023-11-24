global with sharing class SalesforceEssentials {
    @Auraenabled(cacheable=true)

    global static list<SalesforceEssentials__c> getSalesforceEssentialList(){
            list<SalesforceEssentials__c> lstwrap = new list<SalesforceEssentials__c>();
            list<SalesforceEssentials__c> lstEsstentialList = [select id,Name,IsAvailable__c,Image_Url__c,Help_Text__c from SalesforceEssentials__c];
         for(SalesforceEssentials__c se : lstEsstentialList){
        //system.debug('se--->'+se);
        SalesforceEssentials__c EssentialList = new SalesforceEssentials__c();
        EssentialList.Name = string.valueof(se.Name);
        EssentialList.Id = string.valueof(se.Id);
        EssentialList.Image_Url__c = se.Image_Url__c;
        lstwrap.add(EssentialList);
             
    } 
    //system.debug('Name--->'+lstwrap);
    return lstwrap;
}
   
    @Auraenabled(cacheable=true) 
    global static list<SalesforceFeatures__c> getFeaturesvalue(String recordId){
        //system.debug('apfieldname--->'+recordId);
        list<SalesforceFeatures__c> featuresList = new list<SalesforceFeatures__c>();
        //Decimal priceValue = 0;
        list<SalesforceFeatures__c> lstFeat = [select id,Name,IsAvailable__c,imageURL__c,Duration__c,HelpText__c,SalesforceEssentialList__r.Name,youtube__c from SalesforceFeatures__c where SalesforceEssentialList__c=:recordId];
        for(SalesforceFeatures__c fea: lstFeat){
            SalesforceFeatures__c sfnew = new SalesforceFeatures__c(); 
            sfnew.Id = string.valueOf(fea.id);
            sfnew.Name = string.valueOf(fea.Name);
            sfnew.SalesforceEssentialList__c =string.valueOf(fea.SalesforceEssentialList__c); 
            sfnew.imageURL__c=fea.imageURL__c;
            sfnew.youtube__c=fea.youtube__c;
            //sfnew.totalPriceValue=priceValue+fea.Price__c; 
            featuresList.add(sfnew);
        }
        system.debug('line 36::--->'+lstFeat);
        return featuresList; 
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
        system.debug('============'+lstRecord);
        system.debug('===================+++++');
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
        system.debug(totalprice);
        system.debug(totalduration);
        return summarytotals;
    }
    
    @Auraenabled
    global static void createLead(string salutation,string firstname,string lastname,string companyinfo,string email,string phone,string description,string comment){
        system.debug('phone :'+phone);
        try {
            Lead ld = new Lead();
           
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