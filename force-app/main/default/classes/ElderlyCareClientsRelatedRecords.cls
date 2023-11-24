global without sharing class ElderlyCareClientsRelatedRecords {
    
    //public static string clientRecordIds;
    
    @Auraenabled(cacheable=true)
    global static list<ClientRelatedRecords> getClientRelatedRecords(String clientRecordId){
        //clientRecordIds = clientRecordId;
        //system.debug('recIDss : '+clientRecordIds);
        list<ClientRelatedRecords> lstClientRelatedRecords = new list<ClientRelatedRecords>();
        list<contact> con = [select id,Name, AccountId,createdDate from Contact where AccountId =:clientRecordId ORDER BY createdDate desc];
        list<Time_Sheet__c> ts = [select id,name,Account_Name__c,createdDate from Time_Sheet__c where Account_Name__c =:clientRecordId ORDER BY createdDate desc];
        list<Incidents_Complaints__c> ins = [select id,name,Client_Name__c,createdDate from Incidents_Complaints__c where Client_Name__c =:clientRecordId ORDER BY createdDate desc];
        list<Product_Line_Item__c> serviceitem = [select id,name,Account_Name__c,createdDate from Product_Line_Item__c where Account_Name__c =: clientRecordId ORDER BY createdDate desc];
        //for(Contact cont : con){
        ClientRelatedRecords wrap1 = new ClientRelatedRecords();
        wrap1.lstContact = con;
        lstClientRelatedRecords.add(wrap1);
        
        ClientRelatedRecords wrap2 = new ClientRelatedRecords();
        wrap2.lstTimeSheet = ts;
        lstClientRelatedRecords.add(wrap2);
        
        ClientRelatedRecords wrap3= new ClientRelatedRecords();
        wrap3.lstIncident = ins;
        lstClientRelatedRecords.add(wrap3);
        
        ClientRelatedRecords wrap4= new ClientRelatedRecords();
        wrap4.lstService = serviceitem;
        lstClientRelatedRecords.add(wrap4);
        //}
        
        return lstClientRelatedRecords;
    }
    global class ClientRelatedRecords {
        @AuraEnabled 
        global list<Contact> lstContact{get;set;}
        @AuraEnabled 
        global list<Time_Sheet__c> lstTimeSheet {get;set;}
        @AuraEnabled 
        global list<Incidents_Complaints__c> lstIncident {get;set;}
        @AuraEnabled 
        global list<Product_Line_Item__c> lstService {get;set;}
    }
    
    @AuraEnabled
    public static list<WrapperData> getRelatedRecords(string buttonLabel, string clientIds){
        try{
            List<WrapperData> lstWrapperData = new list<WrapperData>();
            WrapperData wrapData = new WrapperData();
            if(buttonLabel =='Contact'){
                list<contact> con = [select id,Name, AccountId,createdDate from Contact where AccountId =:clientIds ORDER BY createdDate desc];
                wrapData.contactWrapper = con;
                lstWrapperData.add(wrapData);
            } 
            if(buttonLabel =='Service Items'){
                list<Product_Line_Item__c> serviceitem	 = [select id,name,Account_Name__c,createdDate from Product_Line_Item__c where Account_Name__c =: clientIds ORDER BY createdDate desc];
                system.debug('serviceitem :'+serviceitem);
                wrapData.serviceWrapper = serviceitem;
                lstWrapperData.add(wrapData);
            }
            if(buttonLabel =='TimeSheet'){
                list<Time_Sheet__c> ts = [select id,name,Account_Name__c,createdDate from Time_Sheet__c where Account_Name__c =:clientIds ORDER BY createdDate desc];
                wrapData.timeSheetWrapper = ts;
                lstWrapperData.add(wrapData);
            }
            if(buttonLabel =='Incident'){
                list<Incidents_Complaints__c> ins = [select id,name,Client_Name__c,createdDate from Incidents_Complaints__c where Client_Name__c =:clientIds ORDER BY createdDate desc];
                wrapData.incidentWrapper = ins;
                lstWrapperData.add(wrapData);
            }
            system.debug('lstWrapperData :'+lstWrapperData);
            return lstWrapperData;
        }
        catch(Exception e){
            system.debug('catch err :'+e.getMessage());
            return null;
        }
    }
    global class WrapperData{
        @AuraEnabled 
        global list<Contact> contactWrapper{get;set;}
        @AuraEnabled 
        global list<Product_Line_Item__c> serviceWrapper{get;set;}
        @AuraEnabled 
        global list<Time_Sheet__c> timeSheetWrapper{get;set;}
        @AuraEnabled 
        global list<Incidents_Complaints__c> incidentWrapper{get;set;}
    }
}