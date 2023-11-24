@isTest
public class Test_ManageAvailability {
    @testSetup
    public static void handleAvailbility(){
        List<Event> newEvents = new List<Event>();
        
        Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='testContact@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@zuddhisystems.com.au');
        insert us;
        
        carer__c cr = new carer__c();
        cr.name= 'test 1';
        cr.User_Name__c = us.id;
        cr.Availability__c ='Not Available';
        cr.Start_Date__c = system.now();
        cr.End_Date__c = system.now();
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
        ts.Carer_Name__c = cr.Id;
        ts.ClockIn_Location__Latitude__s = 37.123456;
        ts.ClockIn_Location__Longitude__s = -122.987654;
        ts.Account_Name__c = acc.Id;
        //ts.Service_provider__r.Name=us.Name;
        insert ts;
        Time_Sheet__c ts1 = new Time_Sheet__c();
        ts1.Start_Date__c = Date.today();
        ts1.End_Date__c = Date.today();
        ts1.Start_Time__c = Time.newInstance(11,5,2,7);
        ts1.End_time__c=Time.newInstance(12,5,2,7);
        ts1.Carer_Name__c = cr.Id;
        ts1.ClockIn_Location__Latitude__s = 37.123456;
        ts1.ClockIn_Location__Longitude__s = -122.987654;
        ts1.Account_Name__c = acc.Id;
        //ts.Service_provider__r.Name=us.Name;
        insert ts1;
		  for (Integer i = 0; i < 1; i++) {
            Event e = new Event(
                Subject = 'Aged Care',
                StartDateTime = System.today().addDays(i),
                EndDateTime=System.today().addDays(i),
                OwnerId = us.id
            );
            newEvents.add(e);
        }
        Event existingEvent = new Event(
            Subject = 'Not Available',
            StartDateTime = System.today(),
            EndDateTime=System.today(),
            OwnerId = us.id
        );
        
        insert existingEvent;
  }
    
    public static void deleteEvent(){
        
        carer__c cr1 = [Select id,name,Availability__c,Not_available__c,User_Name__c from carer__c];
        cr1.Availability__c = 'Available';
        cr1.Not_available__c = False;
        cr1.Start_Date__c=System.today();
        update cr1;
        
        
       
    }
    public static testMethod void queryTest(){
        List<Event> eve=[SELECT Id, Subject, StartDateTime, OwnerId,EndDateTime FROM Event];
        Carer__c updatedcr=[Select id,name,Availability__c,Not_available__c,User_Name__c from carer__c];
        
        List<ElderlyCareManageAvailbility.InputvariableFromFlow> inputVariables = new List<ElderlyCareManageAvailbility.InputvariableFromFlow>();
        ElderlyCareManageAvailbility.InputvariableFromFlow inputVariable = new ElderlyCareManageAvailbility.InputvariableFromFlow();
        inputVariable.crid = updatedcr.Id;
        inputVariables.add(inputVariable);
        system.debug('inputVariables :'+inputVariables);
        
        if(inputVariables != null){
        Test.startTest();
        ElderlyCareManageAvailbility.handleAvailbility(eve);
        ElderlyCareManageAvailbility.deleteEvent(inputVariables);
        Test.stopTest();
           } else {
            system.debug('Id is null');
        }
        
    }
}