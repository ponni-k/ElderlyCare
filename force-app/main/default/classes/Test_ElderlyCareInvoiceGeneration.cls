@isTest
public class Test_ElderlyCareInvoiceGeneration {
    @testSetup
    public static void ElderlyCare(){  
        Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='example11111@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@invalidTest.com');
        insert us;
        
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.BillingStreet = 'test street';
        acc.BillingCity = 'test city';
        acc.BillingState ='test state';
        acc.BillingCountry ='test country';
        acc.BillingPostalCode='43213';
        acc.Risk_Value_for_Pet__c='test1;test2';
        insert acc;
        
        carer__c cr = new carer__c();
        cr.Name = 'Test carer';
        cr.Hourly_Price__c = 3.81;
        cr.Availability__c ='Not Available';
        cr.Start_Date__c = system.now();
        cr.End_Date__c = system.now();
        cr.User_Name__c = us.id;
        insert cr;
        
        Time_Sheet__c ts = new Time_Sheet__c();
        ts.Start_Date__c = system.today();
        ts.End_Date__c = system.today();
        ts.Start_Time__c = Time.newInstance(11,5,2,7);
        ts.End_time__c=Time.newInstance(12,5,2,7);
        //ts.ClockIn_Location__Latitude__s = 37.123456;
        //ts.ClockIn_Location__Longitude__s = -122.987654;
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
        eve.StartDateTime= System.today();
        eve.EndDateTime= System.today();
        //eve.EndDate= System.today()+1;
        eve.Description='test description';
        eve.OwnerId = us.Id;
        eve.Subject='Aged Care';
        eve.Status__c='Not Started';
        eve.Care_Type__c='Gardening';
        eve.User__c=us.Id;
        eve.Time_Sheet__c = ts.id;
        eve.whatid = acc.Id;
        //lstevet.add(eve);
        insert eve;
    }
    
    public static testMethod void invoiceTest(){
        Time_Sheet__c ts1 = [select id,Start_Date__c,End_Date__c,Start_Time__c,End_time__c,Service_provider__r.Name,Account_Name__c from Time_Sheet__c limit 1];
        string clientid = ts1.Account_Name__c;
        
        Test.startTest();
        ElderlyCareInvoiceGeneration.getRecordsForClient(clientid,ts1.Start_Date__c,ts1.End_Date__c);
        Test.stopTest();
    }
}