global without sharing class ElderlyCareIncidentReport {
    
    @AuraEnabled(cacheable =true)
    global static list<WrapperIncidentRecordDetails> getIncidentRecords(){
        Boolean isAdminUser;
        String userId = UserInfo.getUserId();
        List<WrapperIncidentRecordDetails> listWrapper = new list<WrapperIncidentRecordDetails>();
        List<User> lstUser = [select id,name,Username,ContactId, email,User_Type__c,CompanyName from User where id =:userId];
        //Contact con = [select id,AccountId,Name from Contact where id=:lstUser[0].contactId];
        system.debug('lstUser :'+lstUser);
        string userType = lstUser[0].User_Type__c;
        system.debug('userType :'+userType);
        list<Incidents_Complaints__c> listIncidentReport;
        if(userType =='Clients'){
            listIncidentReport = [SELECT Id, RecordTypeId,Client_Name__r.Name, Client_Name__c, Carer_Name__c, Case_Name__c, Incident_Reason__c, Priority__c, Phone__c, Email__c, Subject__c, Reportable_Incident__c, Description__c, Status__c, Incident_Date_and_TIme__c, Issue_Type__c, CreatedDate FROM Incidents_Complaints__c where CreatedById=:userId ORDER BY CreatedDate DESC];
        } else {
            listIncidentReport = [SELECT Id, RecordTypeId,Client_Name__r.Name, Client_Name__c, Carer_Name__c, Case_Name__c, Incident_Reason__c, Priority__c, Phone__c, Email__c, Subject__c, Reportable_Incident__c, Description__c, Status__c, Incident_Date_and_TIme__c, Issue_Type__c, CreatedDate FROM Incidents_Complaints__c ORDER BY CreatedDate DESC];
        }
        for(Incidents_Complaints__c incidentRecords : listIncidentReport){
            WrapperIncidentRecordDetails wrap = new WrapperIncidentRecordDetails();
            if(userType =='Admin'){
                wrap.isAdminorNot = true;
            } else {
                wrap.isAdminorNot = false;
            }
            wrap.subjectValue = incidentRecords.Subject__c;
            wrap.ClientName = incidentRecords.Client_Name__r.Name;
            wrap.priorityValue = incidentRecords.Priority__c;
            wrap.statusValue = incidentRecords.Status__c;
            wrap.incidentId = incidentRecords.Id;
            wrap.userType = userType;
            listWrapper.add(wrap);
            system.debug('listWrapper :'+listWrapper);
        }
        return listWrapper;
    }
    
    global class WrapperIncidentRecordDetails{
        @AuraEnabled
        global Boolean isAdminorNot{get;set;}
        @AuraEnabled
        global String userType{get;set;}
        @Auraenabled
        global string subjectValue{get;set;}
        @Auraenabled
        global string ClientName{get;set;}
        @Auraenabled
        global string priorityValue{get;set;}
        @Auraenabled
        global string statusValue{get;set;}
        @Auraenabled
        global string incidentId{get;set;}
        @Auraenabled
        global list<Incidents_Complaints__c> listIncidentComplaints{get; set;}
    }
    
    @AuraEnabled
    global static void insertIncidentReport(
        string subject,
        string email,
        string status,
        string phone,
        string client,
        string type,
        string priority,
        datetime incidentdatetime,
        String incidentReport,
        string Description)
    {
        
        String userId = UserInfo.getUserId();
        system.debug('userId :'+userId);
        List<User> lstUser = [select id,name,Username, email,User_Type__c,CompanyName,contactId from User where id =:userId];
        system.debug('lstUser :'+lstUser);
        list<Contact> con = [select id,AccountId,Name from Contact where id=:lstUser[0].contactId];
        
        string connectedContacts = con[0].AccountId;
        
        system.debug('lstUser :'+lstUser);
        string userType = lstUser[0].User_Type__c;
        system.debug('userType :'+userType);
        Id adminRecordTypeId = Schema.SObjectType.Incidents_Complaints__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        system.debug('adminRecordTypeId :'+adminRecordTypeId);
        Id carerRecordTypeId = Schema.SObjectType.Incidents_Complaints__c.getRecordTypeInfosByName().get('Carer').getRecordTypeId();
        system.debug('carerRecordTypeId :'+carerRecordTypeId);
        Id clientRecordTypeId = Schema.SObjectType.Incidents_Complaints__c.getRecordTypeInfosByName().get('Clients').getRecordTypeId();
        system.debug('clientRecordTypeId :'+clientRecordTypeId);
        List<Incidents_Complaints__c> lstIncidentComplaints = new list<Incidents_Complaints__c>();
        try {
            Incidents_Complaints__c incidentComplaints = new Incidents_Complaints__c();
            incidentComplaints.Subject__c = subject;
            incidentComplaints.Incident_Reason__c = subject;
            incidentComplaints.Email__c =email;
            incidentComplaints.Status__c =status;
            incidentComplaints.Phone__c =phone;
            if(userType =='Clients'){
                incidentComplaints.Client_Name__c = connectedContacts;
            } else {
                incidentComplaints.Client_Name__c = client;
            }
            
            incidentComplaints.Priority__c = priority;
            incidentComplaints.Issue_Type__c =type;
            incidentComplaints.Incident_Date_and_TIme__c = incidentdatetime;
            if(incidentReport == 'Yes'){
                incidentComplaints.Reportable_Incident__c=true;
            } else {
                incidentComplaints.Reportable_Incident__c=false;
            }
            incidentComplaints.Description__c =Description;
            if(userType=='Admin'){
                incidentComplaints.RecordTypeId =adminRecordTypeId ;
            } else if(userType=='Carer'){
                incidentComplaints.RecordTypeId = carerRecordTypeId;
            } else if(userType=='Clients'){
                incidentComplaints.RecordTypeId = clientRecordTypeId;
            }
            lstIncidentComplaints.add(incidentComplaints);
            system.debug('lstIncidentComplaints :'+lstIncidentComplaints);
            if(!lstIncidentComplaints.isEmpty()){
                insert lstIncidentComplaints;
            }
        }
        catch(Exception e){
            system.debug('Exception :'+e.getMessage());
        }
    }
    
    @AuraEnabled
    global static IncidentWrapper getIncidentValue(string incidentRecordId){
        Incidents_Complaints__c incidentComplaints = [SELECT Id, RecordTypeId,Client_Name__r.Name, Client_Name__c, Carer_Name__c, Case_Name__c, Incident_Reason__c, Priority__c, Phone__c, Email__c, Subject__c, Reportable_Incident__c, Description__c, Status__c, Incident_Date_and_TIme__c, Issue_Type__c, CreatedDate FROM Incidents_Complaints__c where id =:incidentRecordId];
        IncidentWrapper wrapper = new IncidentWrapper();
        wrapper.subject = incidentComplaints.Subject__c;
        wrapper.email = incidentComplaints.Email__c ;
        wrapper.clientName = incidentComplaints.Client_Name__r.Name ;
        wrapper.status = incidentComplaints.Status__c ;
        wrapper.phone = incidentComplaints.Phone__c;
        wrapper.incidentType = incidentComplaints.Issue_Type__c;
        wrapper.priority = incidentComplaints.Priority__c ;
        wrapper.dateandtime = incidentComplaints.Incident_Date_and_TIme__c;
        wrapper.reportCheck = incidentComplaints.Reportable_Incident__c;
        wrapper.description = incidentComplaints.Description__c;
        system.debug('wrapper :'+wrapper);
        return wrapper;
    }
    
    global class IncidentWrapper{
        @Auraenabled
        global string subject{get;set;}
        @Auraenabled
        global string email{get;set;}
        @Auraenabled
        global string clientName{get;set;}
        @Auraenabled
        global string status{get;set;}
        @Auraenabled
        global string phone{get;set;}
        @Auraenabled
        global string incidentType{get;set;}
        @Auraenabled
        global string priority{get;set;}
        @Auraenabled
        global Datetime dateandtime{get;set;}
        @Auraenabled
        global Boolean reportCheck{get;set;}
        @Auraenabled
        global string description{get;set;}
    } 
    @AuraEnabled
    global static Incidents_Complaints__c updateIncidentValue(string incidentRecordId, String incidentStatus,string incidentSubject,string incidentDescription){
        String userId = UserInfo.getUserId();
        Incidents_Complaints__c incidentComplaint = [select id,Name,Status__c,Subject__c,Description__c,Resolved_by__c,Resolved_On__c from Incidents_Complaints__c where id =:incidentRecordId limit 1];
        if(incidentStatus != null){
            if(incidentStatus == 'Closed'){
                incidentComplaint.Status__c = incidentStatus;
                incidentComplaint.Resolved_by__c = userId;
                incidentComplaint.Resolved_On__c = system.now();
            } else {
                incidentComplaint.Status__c = incidentStatus;
            }
        }
        if(incidentSubject != null){
            incidentComplaint.Subject__c = incidentSubject;
        }
        if(incidentDescription!=null){
            incidentComplaint.Description__c = incidentDescription;
        }
        system.debug('incidentComplaint :'+incidentComplaint);
        update incidentComplaint;
        return incidentComplaint;
    }
    
}