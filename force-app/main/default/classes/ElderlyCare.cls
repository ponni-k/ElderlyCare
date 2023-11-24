/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 06-14-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class ElderlyCare {
    @AuraEnabled
    global static void saveImageFile(String imageUrl, String recordId, string imagetitle,string imageDescription) {
        //system.debug('imageUrl :'+imageUrl);
        //system.debug('recordId :'+recordId);
        //system.debug('imagetitle :'+imagetitle);
        //system.debug('imageDescription :'+imageDescription);
        id recordId1 = recordId;
        // Schema.SObjectType sObjectType = recordId.getSObjectType();
        //String sObjApiName = String.valueof(sObjectType.getDescribe().getName());
        try {
            // Create Salesforce File
            //Insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = recordId+'.png';
            cVersion.Origin = 'H';
            cVersion.OwnerId = UserInfo.getUserId();
            cVersion.Title = imagetitle+'.png';
            cVersion.Description = imageDescription;
            cVersion.VersionData = EncodingUtil.base64Decode(imageUrl.substring(imageUrl.indexOf(',') + 1));
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;
            cDocLink.LinkedEntityId = recordId;
            cDocLink.ShareType = 'I';
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            //return 'success';
            
        }catch(Exception e){
            system.debug('---------- ' + e.getMessage());
            //return JSON.serialize(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    global static Event getEventValue(string recid){
        Event evt = [SELECT Id, Location, StartDateTime,Time_Sheet__r.Start_Time__c ,Time_Sheet__r.End_time__c, EndDateTime, EndDate, Description, Subject, Status__c, Care_Type__c, User__c,AccountId,Account.Name,OwnerId,Owner.Name,User__r.Name FROM Event where id=:recid limit 1];
        return evt;
    }
    
    @AuraEnabled
    global static Event updateStatusEvent(string eventRecordId,string selectedButton){
        system.debug('eventRecordId :'+eventRecordId);
        system.debug('selectedButton :'+selectedButton);
        String UserId = UserInfo.getUserId();
        //System.Debug('UserId-' + UserId);
        Event evt = [SELECT Id,AgedCare_Type__c, Location, StartDateTime, EndDateTime, EndDate, Description, Subject, Status__c, Care_Type__c, User__c FROM Event where id=:eventRecordId limit 1];
        //system.debug('evt :'+evt);
        if(selectedButton == 'Accept'){
            DateTime dt = evt.StartDateTime;
            system.debug('DateTime: '+dt);
            evt.Status__c= 'Accepted';
            evt.User__c = null;
        } else if(selectedButton =='Decline'){
            evt.User__c = UserId;
            evt.Status__c = 'Declined';
        }
        try{
            update evt;
        } catch(exception e){
            system.debug('ṅed :'+e.getMessage());
         }
        return evt;
    }
    @AuraEnabled
    global static list<Event> createClockInRecord(string eventRecordId,String Buttonlabel){
        //system.debug('Buttonlabel :'+Buttonlabel);
        system.debug('eventRecordId :'+eventRecordId);
        // system.debug('latitude :'+latitude);
        // system.debug('longitude :'+longitude);
        list<Event> evnt = [SELECT Id, ActivityDate,Time_Sheet__c, StartDateTime, EndDateTime, EndDate, Description, AccountId, OwnerId, Status__c, User__c, Care_Type__c FROM Event where id =:eventRecordId];
        // system.debug('evnt :'+evnt);
        id timesheetId = evnt[0].Time_Sheet__c;
        //system.debug('timesheetId :'+timesheetId);
        Time_Sheet__c ts = [select id,Start_Time__c,Start_Date__c,End_time__c,End_Date__c,ClockIn_Location__c,ClockIn_Location__Latitude__s,ClockIn_Location__Longitude__s,Service_Completed__c  from Time_Sheet__c where id=: timesheetId];
        // Get the current time in milliseconds
        Long currentTimeMillis = System.currentTimeMillis();
        DateTime currentTime = DateTime.newInstance(currentTimeMillis);
        Time currentTimeInApex = currentTime.time();
        //System.debug('Current Time: ' + currentTimeInApex);
        String myError ='Please Complete Progress Notes';
        if(Buttonlabel == 'Clock In'){
            ts.Start_Date__c = Date.today();
            ts.Start_Time__c = currentTimeInApex;
            //ts.ClockIn_Location__Latitude__s = latitude;
            //ts.ClockIn_Location__Longitude__s = longitude;
            evnt[0].Status__c = 'In Progress';
        } else if(Buttonlabel == 'Clock Out'){
            if(ts.Service_Completed__c == true){
                evnt[0].Status__c = 'Completed';
                ts.End_Date__c = Date.today();
                ts.End_time__c = currentTimeInApex;
            } else {
                throw new AuraHandledException('Please complete the Progress Notes');
            }
        }
        update ts;
        update evnt;
        system.debug('evnt :'+evnt);
        //system.debug('ts :'+ts);
        return evnt;  
    }
    @AuraEnabled
    global static void createTimeSheetRecord(list<Event> listEvent){
        //system.debug('listEvent :'+listEvent);
        list<string> lstevtid = new list<string>();
        for(Event evtid : listEvent){
            lstevtid.add(evtid.id);
        }
        string EventId = string.join(lstevtid, ',');
        //system.debug('EventId :'+EventId);
        list<Event> evt = [SELECT Id,WhatId,AgedCare_Type__c, Subject, Location, StartDateTime, EndDateTime, EndDate, AccountId, Care_Type__c, User__c, Status__c,Service_Items__c,Service_Items__r.Name, Time_Sheet__c, IsAllDayEvent,OwnerId FROM Event where id =: EventId limit 1];
        Account acc = [SELECT Name, Id, AccountImage_URL__c,Company_Name__c,Reports_to__r.MobilePhone FROM Account where Id=:evt[0].WhatId];
        String URL = String.valueOf(acc.AccountImage_URL__c);
        String companyName = String.valueOf(acc.Company_Name__c);
        string clientName = acc.Name; 
        String serviceName = evt[0].Service_Items__r.Name;
        string carerId= evt[0].OwnerId;
         list<Carer__c> carer = [select id ,name,user_name__c,Contact__r.MobilePhone,Carer_Image_URL__c from carer__c where user_name__c=:carerId];
         String carerNames = carer[0].name;
        String  carerURL = String.valueOf(carer[0].Carer_Image_URL__c );
        String toClientPhone =String.valueOf(acc.Reports_to__r.MobilePhone);
        string carername = carer[0].id;
        String toPhone = String.valueOf(carer[0].Contact__r.MobilePhone);
        DateTime ServiceDate = evt[0].StartDateTime;
        System.Debug('ServiceDate: '+ServiceDate);
        system.debug('carername :'+carername);
        try{
            if(evt[0].Subject !='Not Available'){
                WhatsAppUtils.sendTemplateMessage(toPhone,URL,carerNames,serviceName,clientName,companyName,ServiceDate);
                WhatsAppUtils.serviceMessage(toClientPhone,carerURL,carerNames,serviceName,clientName,companyName,ServiceDate);
                Time_Sheet__c timesheet = new Time_Sheet__c();
                timesheet.Account_Name__c = evt[0].AccountId;
                timesheet.Service_provider__c = evt[0].OwnerId;
                timesheet.Product__c = evt[0].AgedCare_Type__c;
                timesheet.Service_Items__c = evt[0].Service_Items__c;
                timesheet.Carer_Name__c = carername;
                system.debug('timesheet :'+timesheet);
                insert timesheet;
                Time_Sheet__c ts = [select id from Time_Sheet__c where id =:timesheet.Id];
                evt[0].Time_Sheet__c = ts.Id;
                update evt;
                system.debug('ts :'+ts);
                
            }
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static list<Contact> getContact(string contactRecord){
        list<Contact> lstcontact = [select id,name,email,Phone,Relationship_with_Client__c ,AccountId from contact where  AccountId=:contactRecord];
        return lstcontact;
    }
    
    @AuraEnabled(cacheable = true)
    public static list<Time_Sheet__c> getTImeSheet(string timesheetRecord){
        list<Time_Sheet__c> lsttimesheet = [select id,Account_Name__c,Service_provider__r.Name,Start_Date__c,Start_Time__c,Product__r.Name,Price__c from Time_Sheet__c where Account_Name__c=:timesheetRecord];
        return lsttimesheet;
    }
    @AuraEnabled(cacheable = true)
    public static list<Product_Line_Item__c> getProductLineItem(string productLineItemRecord){
        list<Product_Line_Item__c> lstproductlineitem = [select id,Name,Account_Name__c,Goal_Name__r.Name,Goal__c,Product_Price__c from Product_Line_Item__c where Account_Name__c=:productLineItemRecord];
        return lstproductlineitem;
    }
    
    //Event MAp
    
    @AuraEnabled(cacheable = true)
    global static List<UserAccountWrapper> getEventDetails(string eventRecordId){
        Event evt = [select AccountId,OwnerId from event where id=:eventRecordId];
        id relatedid = evt.AccountId;
        List<UserAccountWrapper> wrapper = new List<UserAccountWrapper>();
        account accRec= [select id,Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, BillingPostalCode from Account where id=:relatedid];
        UserAccountWrapper rec1=new UserAccountWrapper();
        rec1.Street=accRec.BillingStreet;
        rec1.City=accRec.BillingCity;
        rec1.State=accRec.BillingState;
        rec1.County=accRec.BillingCountry;
        rec1.PostalCode=accRec.BillingPostalCode;
        rec1.Name=accRec.name;
        wrapper.add(rec1);
        return wrapper; 
    }
    
    global class UserAccountWrapper{
        @AuraEnabled
        global String Street { get; set; }
        @AuraEnabled
        global String City { get; set; }
        @AuraEnabled
        global String State { get; set; }
        @AuraEnabled
        global String County { get; set; }
        @AuraEnabled
        global String PostalCode { get; set; }
        @AuraEnabled
        global String Name { get; set; }
    }
    
    @Auraenabled(cacheable=true)
    global static list<ElderlyCare_Risk__mdt> getriskAlertDetails(){
        list<ElderlyCare_Risk__mdt> riskalertwrapper = new list<ElderlyCare_Risk__mdt>();
        list<ElderlyCare_Risk__mdt> lstRisk = [select id,Label,MasterLabel,Risk_Name__c,Risk_Logo__c,Risk_Order__c from ElderlyCare_Risk__mdt order by Risk_Order__c ASC];
        list<string> lststr = new list<string>();
        Map<String, ElderlyCare_Risk__mdt> lstcomponent=new  Map<String, ElderlyCare_Risk__mdt>(); 
        list<ElderlyCare_Risk__mdt> lstcomponent1 = ElderlyCare_Risk__mdt.getAll().values();
        for(ElderlyCare_Risk__mdt component: lstRisk){
            lstcomponent.put(component.label,component);
        }
        return lstcomponent.values();
    }
    
    @Auraenabled
    public static list<string> getRiskAlertdetails1(string eventRecordId, string riskLabel){
        Event evt = [select id,	AccountId from Event where id =: eventRecordId];
        id accid = evt.AccountId;
        string label = 'Risk_Value_for_'+riskLabel+'__c';
        string sobj = 'Account';
        string query = 'select id,'+label+' from '+ sobj+' where id=:accid LIMIT 1';
        Account lstacc = Database.query(query);
        list<string> listRiskValues =String.valueOf(lstacc.get(label)).split(';') ;
        return listRiskValues;
    }
}