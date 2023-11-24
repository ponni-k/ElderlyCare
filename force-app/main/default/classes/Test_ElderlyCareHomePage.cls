@isTest
Global class Test_ElderlyCareHomePage {
    @isTest
    global static void elderlyCareHomePage(){
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.BillingStreet = 'test street';
        acc.BillingCity = 'test city';
        acc.BillingState ='test state';
        acc.BillingCountry ='test country';
        acc.BillingPostalCode='43213';
        acc.Risk_Value_for_Pet__c='test1;test2';
        //acc.Reports_to__c = con1.Id;
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.id;
        con.MobilePhone = '+61420598764';
        insert con;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name ='Cloned Customer Community Plus User'];
        
        user us1 = new User(ProfileId = pf.id,
                            FirstName = '',
                            LastName = 'test',
                            Email='testContact@zuddhisystems.com.au',
                            Username = 'testuser@example.com' + System.currentTimeMillis(),
                            Alias = 'tuser',
                            CommunityNickname = 'tuser123',
                            TimeZoneSidKey = 'America/New_York',
                            LocaleSidKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LanguageLocaleKey = 'en_US',
                            User_Type__c = 'Admin',
                            contactId = con.Id,
                            IsActive = true                           );
        insert us1;
        // [SELECT Id,Name,Age__c, Skills__c, Hourly_Price__c, Availability__c, Start_Date__c, End_Date__c, Email__c, Languages_Spoken__c, Contact_No__c, Address__c, Contact__c, User_Name__c FROM carer__c where User_Name__c =:currentUserId]; 
        //system.debug('Carer details: '+cr);
        carer__c cr = new carer__c();
        cr.name= 'test';
        cr.Email__c = 'test@gmail.com';
        cr.Skills__c = 'Personal Care';
        cr.Hourly_Price__c = 30;
        cr.Languages_Spoken__c = 'English';
        cr.Address__c = 'test';
        cr.Contact__c = con.Id;
        cr.Contact_No__c = '6789098765';
        cr.User_Name__c = us1.Id;
        cr.Availability__c = 'Available';
        cr.Not_available__c = False;
        cr.Start_Date__c=System.today();
        insert cr;
        
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
        
        Product_Line_Item__c prItem = new Product_Line_Item__c();
        prItem.Account_Name__c = acc.Id;
        prItem.Name = 'Service';
        insert prItem;
        
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
        eve.OwnerId = us1.Id;
        eve.Subject='Aged Care';
        eve.Status__c='Completed';
        eve.Care_Type__c='Gardening';
        eve.User__c=us1.Id;
        eve.whatid = acc.Id;
        eve.Service_Items__c = prItem.id;
        //lstevet.add(eve);
        insert eve;
        
        
        test.startTest();
        ElderlyCareHomePage.getHomePageDetails();
        //ElderlyCareHomePage.getUserDetails();
        system.runAs(us1){
            ElderlyCareHomePage.updateCarer('Not Available', System.now(), system.now());
            ElderlyCareHomePage.getUserDetails();
            ElderlyCareHomePage.returnDomain();
        }
        test.stopTest();
    }
}