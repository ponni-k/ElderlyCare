@isTest
global class Test_ElderlyCareChecklist {
	@testSetup
    public static void ElderlyCareChecklist(){
         Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        AgedCare_Product__c agedcare = new AgedCare_Product__c();
        agedcare.Name='Test Care';
        agedcare.CareType__c = 'Personal Care';
        agedcare.Price__c = 2.0;
        agedcare.Company_Name__c = 'ZuddhiSystems';
        agedcare.Check_List__c = 'Ensure all necessary supplies are ready;i.e Soaps;Shampoo;Towels;Cleancloths after wash;Prepare the environment;Assist with mobility;Verify water temperature';
        insert agedcare; 
        
         HomeCare_Package__c hp = new HomeCare_Package__c();
        hp.Name = 'test name';
        hp.Account_Name__c = testAccount.Id;
        hp.Select_your_Package__c = 'Homecare Package Level 4';
        hp.Personal_Care__c = true;
        hp.Select_personal_Care_Plans__c = 'Bathing';
       insert hp;
        
        Goal__c g = new Goal__c();
        g.Name = 'test name';
        g.Related_Account__c = testAccount.id;
        g.Type__c ='Personal Care';
        g.PackageLevel__c = 'Homecare Package Level 1';
        g.Additional_information__c ='Test Info';
        //g.Select_Product__c = agedcare.id;
      	 g.Personal_Care__c = true;
         g.Selected_Personal_Care_Plans__c ='Bathing;Toileting';
        insert g;
        
        Product_Line_Item__c prItem = new Product_Line_Item__c();
        prItem.Account_Name__c = testAccount.Id;
        prItem.CareType__c = agedcare.CareType__c;
        prItem.Name = 'Service';
        prItem.Price__c =agedcare.Price__c;
        prItem.Service_Checklist__c =agedcare.Check_List__c;
        insert prItem;
        
         Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='testContact@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@invalidTest.com');
        insert us;
        
         carer__c cr = new carer__c();
        cr.name= 'test 1';
        cr.Email__c = 'test@gmail.com';
        cr.Contact_No__c = '6789098765';
        cr.User_Name__c = us.id;
        cr.Availability__c ='Not Available';
        cr.Start_Date__c = system.now();
        cr.End_Date__c = system.now();
        insert cr;
        
          Time_Sheet__c ts = new Time_Sheet__c();
        ts.Start_Date__c = Date.today();
        ts.End_Date__c = Date.today();
        ts.Start_Time__c = Time.newInstance(11,5,2,7);
        ts.End_time__c=Time.newInstance(12,5,2,7);
        ts.ClockIn_Location__Latitude__s = 37.123456;
        ts.ClockIn_Location__Longitude__s = -122.987654;
        ts.Account_Name__c = testAccount.Id;
        ts.Carer_Name__c = cr.Id;
        //ts.Service_provider__r.Name=us.Name;
        insert ts;
        
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
        eve.whatid = testAccount.Id;
        eve.Service_Items__c = prItem.id;
        //lstevet.add(eve);
        insert eve;
    }
    public static testMethod void queryTest(){
         Event eve = [select id,Subject, Service_Items__c,Service_Items__r.Name,WhatId from event];
        //Product_Line_Item__c prItem = [select id,Account_Name__c, Name, Price__c, CareType__c, Service_Checklist__c from Product_Line_Item__c where id=prItem.id];
        Test.startTest();
        ElderlyCareChecklist.getchecklistValue(eve.id);
        Test.stopTest();
    }
}