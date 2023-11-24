global with sharing class  ElderlyCareReusableLookupController {
    // Method to fetch lookup search result   
    @AuraEnabled(cacheable=true)
    global static list<sObject> fetchLookupData(string searchKey , string sObjectApiName) {    
        String currentUserId = UserInfo.getUserId();
        System.debug('Current User ID: ' + currentUserId);
        String userCompanyName = [select id,Name,CompanyName from User where id=:currentUserId].CompanyName;
        Boolean isCommunityUser = true;
        List < sObject > returnList = new List < sObject > ();
        string sWildCardText = '%' + searchKey + '%';
        String sQuery;
        //string companyName 
        
        if(sObjectApiName == 'Account'){
            sQuery = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%' + sWildCardText + '%\' AND Company_Name__c = \'' + userCompanyName + '\' AND Community_User__c != true ORDER BY CreatedDate DESC LIMIT 5';
            
            system.debug('acc rec :'+sQuery);
        }
        if(sObjectApiName =='Carer__c'){
            sQuery = 'SELECT Id, Name FROM Carer__c WHERE Name LIKE \'%' + sWildCardText + '%\' AND Company_Name__c = \'' + userCompanyName + '\' ORDER BY CreatedDate DESC LIMIT 5';
            system.debug('carer rec:'+sQuery);
        }
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }
    // Method to fetch lookup default value 
    @AuraEnabled
    global static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
        string sRecId = recordId;    
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }
}