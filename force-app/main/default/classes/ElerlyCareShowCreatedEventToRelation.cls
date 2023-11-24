global with sharing class ElerlyCareShowCreatedEventToRelation {
    @AuraEnabled(cacheable=true)
    global static list<Event> getCreatedEvent(){
        Id currentUserId = UserInfo.getUserId();
        list<User> us = [select Id,name,Username, Contact.Name,ContactId,AccountId from user where Id =:currentUserId];
        string conId = us[0].ContactId;
        string accId = us[0].AccountId;
        list<Event> retEvent = new list<Event>();
        List<Event> listEvent = [SELECT Id,Time_Sheet__c,Time_Sheet__r.Name,Time_Sheet__r.Start_Date__c,Time_Sheet__r.End_Date__c, Care_Type__c, Status__c,Service_Items__r.Name, Subject, StartDateTime, EndDateTime, AccountId,Time_Sheet__r.Feedback__c, OwnerId,Owner.Name,ActivityDate, EndDate FROM Event where AccountId=:accId];
        for(Event evt : listEvent){
            if(evt.Status__c =='Completed'){
                retEvent.add(evt);
            } 
        }
        return retEvent;
    }  
    
    
    @AuraEnabled
    global static void getSubmitFeedBack(string eventid ,string rating,string comments){
        try {
            list<Event> lstevent = [select id,Time_Sheet__c,WhoId from Event where id=:eventid];
            string timesheetid = lstevent[0].Time_Sheet__c;
            list<Time_Sheet__c> lstimesheet = [select id,Account_Name__c,Carer_Name__c, Carer_Name__r.Name from Time_Sheet__c where id=:timesheetid];
            string carername = lstimesheet[0].Carer_Name__c;
            id clientid = lstimesheet[0].Account_Name__c;
            Id currentUserId = UserInfo.getUserId();
            system.debug('currentUserId :'+currentUserId);
            list<User> us = [select id,name,Username, Contact.Name,ContactId from user where id=:currentUserId];
            string conId = us[0].ContactId;
            list<Feedback__c> listfeedback = new list<Feedback__c>();
            Feedback__c feedback = new Feedback__c();
            feedback.Contact__c = conId;
            feedback.Time_Sheet__c = timesheetid;
            feedback.Client__c = clientid;
            feedback.Carer__c = carername;
            feedback.Rating__c = rating;
            feedback.Comments__c = comments;
            listfeedback.add(feedback);
            if(!listfeedback.isempty()){
                insert listfeedback;
            }
            Time_Sheet__c timeSheet = [select id ,Name ,Feedback__c from Time_Sheet__c where id =:timesheetid limit 1];
            timeSheet.Feedback__c = listfeedback[0].id;
            update timeSheet;
        }
        catch(Exception e){
            system.debug('Error While Cretaing Feed Back :'+e.getMessage());
        }
    } 
}