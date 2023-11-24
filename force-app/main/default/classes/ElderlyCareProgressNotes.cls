/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 07-26-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class ElderlyCareProgressNotes {
    @AuraEnabled(cacheable = true)
    global static list<Progress_Notes__c> retriveProgressNotes(){
        list<Progress_Notes__c> lstProgressNotes;
        lstProgressNotes = [SELECT Id, Carer__c, Services__c,Client_Name__c,Service_Name__c, Services_Count__c,Carer__r.Name,Client__c,Client__r.Name, Service_Description__c, Time_Sheet__c, Progress_Time__c, Progress_Date__c, Signature__c, Name, OwnerId,	Service_Items__c,Service_Items__r.Name FROM Progress_Notes__c ORDER BY Progress_Date__c desc];
        return lstProgressNotes;
    }
    @AuraEnabled
    global static list<Product_Line_Item__c> retriveServiceItems(String searchTerm){
        list<Product_Line_Item__c> lstServiceItems;
        searchTerm = '%' + searchTerm + '%';
        lstServiceItems = [select id,Name  from Product_Line_Item__c WHERE Name LIKE :searchTerm ];
        Set<String> uniqueNames = new Set<String>(); 
        List<Product_Line_Item__c> uniqueRecords = new List<Product_Line_Item__c>();
        for (Product_Line_Item__c record : lstServiceItems) {
            if (!uniqueNames.contains(record.Name)) {
                uniqueNames.add(record.Name);
                uniqueRecords.add(record);
            }
        }
        return uniqueRecords;
    }
    
    @AuraEnabled
    global static list<Progress_Notes__c> getFilterRecords(string carerid,string clientid,string serviceName,date startdate ,date enddate){
        list<Progress_Notes__c> lstProgressNotes;
        String dateString = string.valueOf(startdate);
        String endDateString = string.valueOf(enddate);
        //lstProgressNotes = [SELECT Id, Carer__c, Services__c, Services_Count__c,Carer__r.Name, Service_Description__c, Time_Sheet__c,Client__c, Progress_Time__c, Progress_Date__c, Signature__c, Name, OwnerId FROM Progress_Notes__c where Carer__c=:carerid and(Client__c=:clientid and Progress_Date__c>=:startdate and Progress_Date__c<=:enddate) ];
        String baseQuery = 'SELECT Id, Carer__c, Services__c,Client__r.Name,Client_Name__c,Service_Name__c, Services_Count__c,Carer__r.Name,Service_Items__c, Service_Description__c, Time_Sheet__c,Client__c, Progress_Time__c, Progress_Date__c, Signature__c, Name, OwnerId FROM Progress_Notes__c WHERE ';
        String whereClause = '';
        if (carerid != null && carerid != '') {
            whereClause += 'Carer__c = \'' + String.escapeSingleQuotes(carerid) + '\' AND ';
        }
        if (clientid != null && clientid != '') {
            whereClause += 'Client__c = \'' + String.escapeSingleQuotes(clientid) + '\' AND ';
        }
        if (serviceName != null && serviceName != '') {
            whereClause += 'Service_Name__c = \'' + String.escapeSingleQuotes(serviceName) + '\' AND ';
        }
        if (startdate != null) {
            //whereClause += 'Progress_Date__c >= \'' + Date.valueOf(startdate) + '\' AND ';
            whereClause += 'Progress_Date__c >= :startdate AND ';
        }
        if (enddate != null) {
            //whereClause += 'Progress_Date__c <= \'' + Date.valueOf(enddate) + '\' AND ';
            whereClause += 'Progress_Date__c <= :enddate AND ';
            
        }
        if (whereClause != '') {
            whereClause = whereClause.substring(0, whereClause.length() - 5);
        }
        String finalQuery = baseQuery + whereClause;
        system.debug('finalQuery :'+finalQuery);
        system.debug('result :'+Database.query(finalQuery));
        return Database.query(finalQuery);
    }
    
    @AuraEnabled(cacheable=true)
    global static list<ProgressNotesWrapper> getTimeSheetRecord(string eventId){
        list<ProgressNotesWrapper> progressnotes = new list<ProgressNotesWrapper>();
        list<Event> lstEvent = [select id,Time_Sheet__c from Event where id=:eventId];
        id timesheetId = lstEvent[0].Time_Sheet__c;
        list<Time_Sheet__c> lstTimeSheet=[select id,Name,Account_Name__c,Service_provider__c,Carer_Name__c,Service_Items__r.Name,Carer_Name__r.Name,Account_Name__r.Name from Time_Sheet__c where id=:timesheetId];
        if(!lstTimeSheet.isEmpty()){
            ProgressNotesWrapper p1 = new ProgressNotesWrapper();
            p1.timesheetName = lstTimeSheet[0].Name ;
            p1.timeSheetId = lstTimeSheet[0].Id ;
            p1.carerName = lstTimeSheet[0].Carer_Name__r.Name ;
            p1.carerId = lstTimeSheet[0].Carer_Name__c ;
            p1.clientName = lstTimeSheet[0].Account_Name__r.Name;
            p1.clientId = lstTimeSheet[0].Account_Name__c ;
            p1.seviceName = lstTimeSheet[0].Service_Items__r.Name;
            p1.serviceId = lstTimeSheet[0].Service_Items__c;
            progressnotes.add(p1);
        } else {
            system.debug('No Data');
        }
        list<Progress_Notes__c> lstProgressNotes = [select id,Time_Sheet__c from Progress_Notes__c where Time_Sheet__c=:timesheetId];
        if(!lstProgressNotes.isEmpty()){
            system.debug('Progress Notes is There');
            for(Progress_Notes__c lstProgress: lstProgressNotes ){
                ProgressNotesWrapper p2 = new ProgressNotesWrapper();
                p2.progressNotesValue = lstProgress.id;
                progressnotes.add(p2);
            }
        } else {
            system.debug('No Progress Notes');
          }
        system.debug('progressnotes :'+progressnotes);
        return progressnotes;
    }
    
    global class ProgressNotesWrapper{
        @AuraEnabled
        global string timesheetName;
        @AuraEnabled
        global string timeSheetId;
        @AuraEnabled
        global string carerName;
        @AuraEnabled
        global string carerId;
        @AuraEnabled
        global string clientName;
        @AuraEnabled
        global string clientId;
        @AuraEnabled
        global string seviceName;
        @AuraEnabled
        global string serviceId;
        @AuraEnabled
        public string progressNotesValue;
    }
    
    @AuraEnabled
    global static id saveProgressNotes(string timesheetRec,string carerRecord,string clientrecord, string serviceRecord,string dutyNotesStatus,string serviceDescription,string strSignElement,list<string> selectedChecklistValues){
        String concatenatedChecklistValues = String.join(selectedChecklistValues, '\n');
        system.debug('selectedChecklistValues :'+selectedChecklistValues);
        List<Progress_Notes__c> listProgressNOtes = new List<Progress_Notes__c>();
        Progress_Notes__c progressNotes = new Progress_Notes__c();
        DateTime dt = DateTime.now();
        Time currentTime = dt.time();
        progressNotes.Progress_Date__c = system.today();
        progressNotes.Progress_Time__c = currentTime;
        progressNotes.Time_Sheet__c = timesheetRec;
        progressNotes.Carer__c = carerRecord;
        progressNotes.Client__c =clientrecord;
        progressNotes.Service_Items__c=serviceRecord;
        progressNotes.CheckList_Values__c=concatenatedChecklistValues;
        progressNotes.Service_Description__c= serviceDescription.replaceAll('<p>', '').replaceAll('</p>', '');
        //progressNotes.Service_Description__c= serviceDescription;
        progressNotes.Duty_Notes__c = dutyNotesStatus;
        progressNotes.Signature__c = '<img alt="Image" src="' +strSignElement+ '" />';
        listProgressNOtes.add(progressNotes);
        list<Time_Sheet__c> lsttimesheet = [select id, name,Service_Completed__c from Time_Sheet__c where id=:timesheetRec];
        system.debug('lsttimesheet :'+lsttimesheet);
        lsttimesheet[0].Service_Completed__c = true;
        if(!listProgressNOtes.isEmpty()){
            insert listProgressNOtes;
        }
        list<Progress_Notes__c> insProgressNotes = [select id,name from Progress_Notes__c where id=:listProgressNOtes[0].id];
        if(!insProgressNotes.isEmpty()){
            update lsttimesheet;
        }
        system.debug('lsttimesheet---->'+lsttimesheet);
        return listProgressNOtes[0].id;
    }
    @AuraEnabled(cacheable=true)
    global static list<Progress_Notes__c> getProgressNotesRecord(string getEventId){
        list<Event> listEvent = [SELECT Id, Time_Sheet__c FROM Event where id=:getEventId];
        string timesheetid = listEvent[0].Time_Sheet__c;
        list<Progress_Notes__c> listProgressNotes = [SELECT Id, Name, Client__c,Carer_Name__c,Duty_Notes__c, Client_Name__c, Carer__c,Time_Sheet__r.Name, Services__c, Service_Name__c, Service_Description__c, Time_Sheet__c, Service_Items__c, Progress_Date__c, OwnerId FROM Progress_Notes__c where Time_Sheet__c=:timesheetid];
        return listProgressNotes;
    }
    /* @AuraEnabled
public static void updateProgressStatus(string getEventId,string Progressstatus){
list<Event> listEvent = [SELECT Id, Time_Sheet__c FROM Event where id=:getEventId];
string timesheetid = listEvent[0].Time_Sheet__c;
list<Progress_Notes__c> listProgressNotes = [SELECT Id,Duty_Notes__c, Time_Sheet__c FROM Progress_Notes__c where Time_Sheet__c=:timesheetid];
string progressNotesId = listProgressNotes[0].id;
Progress_Notes__c prRec = [SELECT Id,Duty_Notes__c, Time_Sheet__c FROM Progress_Notes__c where id=:progressNotesId limit 1];
prRec.Duty_Notes__c = Progressstatus;
update prRec;
} */
    @Auraenabled
    global static void saveAttachementsInProgressNotes(string progressNotesId,String imageUrl, string imagetitle,string imageDescription){
        system.debug('progressNotesId :'+progressNotesId);
        system.debug('imageUrl :'+imageUrl);
        system.debug('imagetitle :'+imagetitle);
        system.debug('imageDescription :'+imageDescription);
        Attachment attachment = new Attachment();
        attachment.Name = imagetitle;
        Blob imageBlob = EncodingUtil.base64Decode(imageUrl);
        attachment.Description =imageDescription;
        attachment.Body = imageBlob; 
        attachment.ParentId = progressNotesId;
        attachment.ContentType = 'image/png';	
        system.debug('attachment :'+attachment);
        insert attachment;
    }
}