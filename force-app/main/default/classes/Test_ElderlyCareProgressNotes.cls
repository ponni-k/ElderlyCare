/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 07-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Test_ElderlyCareProgressNotes {
    @testSetup
    public static void ElderlyCare(){  
        Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='testContact@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@invalidTest.com');
        insert us;
        
        carer__c cr = new carer__c();
        cr.name= 'test 1';
        cr.User_Name__c = us.id;
        cr.Availability__c = 'Available';
        cr.Not_available__c = False;
        cr.Start_Date__c=System.today();
        insert cr;
        
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.BillingStreet = 'test street';
        acc.BillingCity = 'test city';
        acc.BillingState ='test state';
        acc.BillingCountry ='test country';
        acc.BillingPostalCode='43213';
        acc.Risk_Value_for_Pet__c='test1;test2';
        insert acc;
        
        Time_Sheet__c ts = new Time_Sheet__c();
        ts.Start_Date__c = Date.today();
        ts.End_Date__c = Date.today();
        ts.Start_Time__c = Time.newInstance(11,5,2,7);
        ts.End_time__c=Time.newInstance(12,5,2,7);
        ts.ClockIn_Location__Latitude__s = 37.123456;
        ts.ClockIn_Location__Longitude__s = -122.987654;
        ts.Account_Name__c = acc.Id;
        ts.Carer_Name__c = cr.Id;
        //ts.Service_provider__r.Name=us.Name;
        insert ts;
        
        //list<Event> lstevet = new list<Event>();
        Event eve = new Event();
        eve.Location='test1';
        eve.IsAllDayEvent= True;
        //eve.AccountId = acc.Id;
        eve.ActivityDateTime=System.now();
        eve.ActivityDate=System.today();
        eve.Time_Sheet__c = ts.id;
        eve.StartDateTime= System.today();
        eve.EndDateTime= System.today();
        //eve.EndDate= System.today()+1;
        eve.Description='test description';
        eve.OwnerId = us.Id;
        eve.Subject='Aged Care';
        eve.Status__c='Not Started';
        eve.Care_Type__c='Gardening';
        eve.User__c=us.Id;
        eve.whatid = acc.Id;
        //lstevet.add(eve);
        insert eve;
        
        Progress_Notes__c progressNotes = new Progress_Notes__c();
        progressNotes.Carer__c = cr.id;
        progressNotes.Client__c = acc.id;
        progressNotes.Time_Sheet__c = ts.id;
        progressNotes.Services__c = 'Bathing;Cleaning';
        progressNotes.Service_Description__c ='test desc';
        insert progressNotes;
        
        
        Product_Line_Item__c pr = new Product_Line_Item__c();
        pr.Name='Test Product';
        pr.Account_Name__c=acc.id;
        insert pr;
    }
    
    public static testMethod void queryTest(){
        
        list<string> lststring = new list<string>{'test1','test2'};
            
            String imagename = 'test img';
        String imageDescription = 'test decription';
        
        String strSignElement = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAA50lEQVR42mP4//8/AwyDPQCzGggAKBgeAihEbCZcCQqXkBcYDhzsgjGAHw3MCwEmxxKAlG4gdoYVX1OhCJ08gQKFQLT4zYAW5AAIK8AG/wdXQIWAgAF8CD8LILmDahDc0BBA5DAMAJUwMLAK1Q8QwBIaBJlEUAGxOcApDGgyIkAlKcQKhAKABl2sAOQAnYa0WdwEY7AAAAAElFTkSuQmCC';
        
        carer__c carer = [select id,name from carer__c limit 1];
        Account acc = [select id,name from Account limit 1];
        Time_Sheet__c ts =[select id from Time_Sheet__c limit 1];
        Event evt = [select id from Event];
        Product_Line_Item__c pr1= [select id,Name,Account_Name__c from Product_Line_Item__c limit 1];
        //id servicerecord = pr1[0].id;
        Progress_Notes__c pr = [SELECT Id, Carer__c, Services__c, Services_Count__c,Carer__r.Name, Service_Description__c, Time_Sheet__c,Client__c, Progress_Time__c, Progress_Date__c, Signature__c, Name, OwnerId FROM Progress_Notes__c];
        string tsid = ts.id;
        Test.startTest();
        ElderlyCareProgressNotes.retriveProgressNotes();
        ElderlyCareProgressNotes.getFilterRecords(carer.id,acc.id,'Health Monitoring',system.today(),system.today());
        ElderlyCareProgressNotes.getTimeSheetRecord(evt.id);
        ElderlyCareProgressNotes.saveProgressNotes(tsid,carer.id,acc.id,pr1.id,'Completed','serviceDescription',strSignElement,lststring);
        ElderlyCareProgressNotes.saveAttachementsInProgressNotes(pr.Id,strSignElement,'TEST Title','Test Description');
        ElderlyCareProgressNotes.getProgressNotesRecord(evt.Id);
        ElderlyCareProgressNotes.retriveServiceItems('test1');
        Test.stopTest();
    }
}