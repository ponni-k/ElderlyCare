/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 06-22-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Test_ElderlyCare {
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
        
        
        
        
        //list<Contact> lstcontact = [select id,name,email,Phone,Relationship_with_Client__c ,AccountId from contact where  AccountId=:contactRecord];
        list<Contact> lstcon = new list<contact>();
        Contact con1 = new Contact();
        con1.LastName='Test';
        con1.email='test@test.com';
        con1.Phone='1234567890';
        con1.Relationship_with_Client__c='Son';
        con1.AccountId= acc.Id;
        insert con1;
        
        Contact con2 =new Contact();
        con2.LastName='Test1';
        con2.email='test1@test.com';
        con2.Phone='1234567890';
        con2.Relationship_with_Client__c='Son';
        con2.AccountId= acc.Id;
        insert con2;
        
        lstcon.add(con1);
        lstcon.add(con2);
        
        //[select id,Name,Account_Name__c,Goal_Name__r.Name,Goal__c,Product_Price__c from Product_Line_Item__c where Account_Name__c=:productLineItemRecord];
        Goal__c gl = new Goal__c();
        gl.Name='test goal';
        insert gl;
        
        Product_Line_Item__c pr = new Product_Line_Item__c();
        pr.Name='Test Product';
        pr.Account_Name__c=acc.id;
        // pr.Goal_Name__r.Name= gl.Id;
        insert pr;
        
    }
    
    public static testMethod void queryTest(){
        
        String imageUrl = 'data:image/png;base64,iVBORw0KG'; 
        String recordId = '001XXXXXXXXXXXX';
        String imageTitle = 'Test Image';
        String imageDescription = 'This is a test image.';
        
        Account acc1 = [select id,name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, BillingPostalCode from Account limit 1]; 
        Time_Sheet__c ts1 = [select id,Start_Date__c,End_Date__c,Start_Time__c,End_time__c,Service_provider__r.Name,Account_Name__c from Time_Sheet__c limit 1];
        Product_Line_Item__c pr1= [select id,Name,Account_Name__c,Goal_Name__r.Name,Goal__c,Product_Price__c from Product_Line_Item__c limit 1];
        
        Event evt1 = [SELECT Id,IsAllDayEvent, Location, StartDateTime, EndDateTime, EndDate, Description, Subject, Status__c, Care_Type__c, User__c FROM Event];
        string accBtn = 'Accept';
        string decBtn = 'Decline';
        if(accBtn =='Accept'){
            evt1.Status__c='Accepted';
        } else {
            evt1.Status__c='Declined';
        }
        update evt1;
        
        // Contact con1 = new Contact();
        //List<Contact> lstcon1 = [Select id,name,email,Phone,Relationship_with_Client__c ,AccountId from Contact];
        ElderlyCare_Risk__mdt lstRisk = [select id,Label,MasterLabel,Risk_Name__c,Risk_Logo__c,Risk_Order__c from ElderlyCare_Risk__mdt limit 1];

        
        Test.startTest();
            ElderlyCare.saveImageFile(imageUrl,acc1.id,imageTitle,imageDescription);
            ElderlyCare.getEventValue(evt1.Id);
            //ElderlyCare.createClockInRecord(evt1.Id);
            ElderlyCare.createClockInRecord(evt1.Id,'Clock In');
            ElderlyCare.updateStatusEvent(evt1.Id,accBtn);
            List<Contact> result = ElderlyCare.getContact(acc1.Id);
            ElderlyCare.getTImeSheet(ts1.Id);
            ElderlyCare.getProductLineItem(pr1.Id);
            ElderlyCare.getriskAlertDetails();
            ElderlyCare.getEventDetails(evt1.Id);
            ElderlyCare.getRiskAlertdetails1(evt1.Id,'Pet');
        Test.stopTest();
    }
}