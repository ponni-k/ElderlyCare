/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 10-05-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with Sharing class ElderlyCareHomePage {
    @AuraEnabled(cacheable=true)
    global static string returnDomain(){
        string domainname = System.Label.elderlyCareCarerCustomDomain;
        return domainname;
    }
    @AuraEnabled(cacheable=true)
    global static list<HomePageDetails> getHomePageDetails(){
        String userId = UserInfo.getUserId();
        list<HomePageDetails> lstHomePageDetails = new list<HomePageDetails>();
        list<Event> eventCount = [SELECT id, AccountId,WhatId,StartDateTime,OwnerId FROM Event where OwnerId =:userId AND StartDateTime >= TODAY ORDER BY StartDateTime];
        HomePageDetails e1 = new HomePageDetails();
        e1.futureEvents = eventCount.size();
        lstHomePageDetails.add(e1);
        list<Event> recentlyCompletedJobs = [SELECT id, AccountId,Account.Name,WhatId,StartDateTime,Status__c,CreatedDate,OwnerId FROM Event where OwnerId =:userId AND Status__c = 'Completed' AND CreatedDate >= LAST_N_DAYS:7 AND CreatedDate <= TODAY];
        HomePageDetails e2 = new HomePageDetails();
        e2.completedEvent = recentlyCompletedJobs.size();
        lstHomePageDetails.add(e2);
  
        Map<id,Event> clinentvalues = new Map<id,Event>();
        List<Event> lstMyclients = [SELECT id, AccountId,Account.Name,CreatedDate,OwnerId FROM Event where OwnerId =:userId AND Account.Name != null];
        for(Event removeDuplicateName : lstMyclients){
            clinentvalues.put(removeDuplicateName.AccountId,removeDuplicateName);
        }
        list<Event> lsEvt = new list<Event>(clinentvalues.values());
        system.debug('lsEvt :'+lsEvt);
        HomePageDetails e3 = new HomePageDetails();
        e3.myClientsValues = lsEvt;
        lstHomePageDetails.add(e3);
        return lstHomePageDetails;
    }
    global class HomePageDetails{
        @Auraenabled
        global Integer futureEvents{get;set;}
        @Auraenabled
        global Integer completedEvent{get;set;}
        @Auraenabled
        global string pendingEvent{get;set;}
        @Auraenabled
        global List<Event> myClientsValues{get;set;}
    }
    @AuraEnabled(cacheable=true)
    global static list<LoginCarer> getUserDetails(){
        list<LoginCarer> loginUser = new list<LoginCarer>();
        Id currentUserId = UserInfo.getUserId();
        system.debug('Current user id'+currentUserId);
        User loggedInUser = [SELECT Id, Username, LastName, FirstName, Name, Email,MediumPhotoUrl FROM User where id=:currentUserId];
        LoginCarer logincarer = new LoginCarer();
        logincarer.userid = loggedInUser.id;
        logincarer.username = loggedInUser.Username;
        logincarer.useremail = loggedInUser.email;
        logincarer.name = loggedInUser.Name;
        logincarer.profilePicture = loggedInUser.MediumPhotoUrl;
        loginUser.add(logincarer);
        
        list<Event> lstEvent = [SELECT Id, Subject,Service_Items__r.Name,Status__c,Account.Name,  StartDateTime, EndDateTime,CreatedDate, Time_Sheet__r.Start_Date__c,Time_Sheet__r.Start_Time__c, Time_Sheet__r.End_time__c FROM Event WHERE OwnerId =:logincarer.userid AND Status__c ='Completed' ORDER BY CreatedDate DESC];
        for(Event evt : lstEvent){
            logincarer.eventStartDate = evt.Time_Sheet__r.Start_Date__c;
            logincarer.eventStartTIme = evt.Time_Sheet__r.Start_Time__c;
            logincarer.eventEndTime = evt.Time_Sheet__r.End_time__c;
            logincarer.eventDuration = evt.Account.Name;
            logincarer.eventServiceType = evt.Service_Items__r.Name;
            logincarer.client = evt.Account.Name;
            logincarer.status = evt.Status__c;
            loginUser.add(logincarer);
        }
        
        Carer__c cr = [SELECT Id,Name,Age__c, Skills__c, Hourly_Price__c, Availability__c, Start_Date__c, End_Date__c, Email__c, Languages_Spoken__c, Contact_No__c, Address__c, Contact__c, User_Name__c FROM carer__c where User_Name__c =:currentUserId]; 
        system.debug('Carer details: '+cr);
        logincarer.carername = cr.Name;
        logincarer.careraddress = cr.Address__c;
        logincarer.carerage = cr.Age__c;
        logincarer.carerhourlyprice = cr.Hourly_Price__c;
        logincarer.carerskills = cr.Skills__c;
        logincarer.careremail = cr.Email__c;
        logincarer.carerphone = cr.Contact_No__c;
        logincarer.carerlanguagesspoken = cr.Languages_Spoken__c;
        logincarer.careravailability = cr.Availability__c;
        logincarer.careravailableStartDate =cr.Start_Date__c;
        logincarer.careravailableEndDate =cr.End_Date__c;
        loginUser.add(logincarer);
        
        system.debug('loginUser :'+loginUser);
        return loginUser;
    }
    
    global class LoginCarer{
        @Auraenabled
        global List<user> lstUser {get;set;}
        @Auraenabled
        global string userid {get;set;}
        @Auraenabled
        global string username {get;set;}
        @Auraenabled
        global string useremail {get;set;}
        @Auraenabled
        global string name {get;set;}
        @Auraenabled
        global string profilePicture {get;set;}
        
        @Auraenabled
        global string eventId {get;set;}
        @Auraenabled
        global Date eventStartDate {get;set;}
        @Auraenabled
        global Time eventStartTIme {get;set;}
        @Auraenabled
        global Time eventEndTime {get;set;}
        @Auraenabled
        global string eventDuration {get;set;}
        @Auraenabled
        global string eventServiceType {get;set;}
        @Auraenabled
        global string client {get;set;}
        @Auraenabled
        global string status {get;set;}
        
        //carer Information
        @AuraEnabled
        global string carername {get;set;}
        @AuraEnabled
        global string careraddress {get;set;}
        @AuraEnabled
        global decimal carerage {get;set;}
        @AuraEnabled
        global decimal carerhourlyprice {get;set;}
        @AuraEnabled
        global string carerskills {get;set;}
        @AuraEnabled
        global string careremail {get;set;}
        @AuraEnabled
        global string carerphone {get;set;}
        @AuraEnabled
        global string carerlanguagesspoken {get;set;}
        @AuraEnabled
        global string careravailability {get;set;}
        @AuraEnabled
        global Datetime careravailableStartDate{get;set;}
        @AuraEnabled
        global Datetime careravailableEndDate {get;set;}
    }
    @AuraEnabled
    global static Carer__c updateCarer(String availability, DateTime startdate, DateTime enddate){
        String userId  = UserInfo.getUserId();
        Carer__c cr =[select id, Name,Availability__c, Start_Date__c, End_Date__c, Email__c,User_Name__c from carer__c where User_Name__c =:userId];
        cr.Availability__c = availability;
        cr.Start_Date__c = startdate;
        cr.End_Date__c = enddate;
        update cr;
        return cr;
    }
}