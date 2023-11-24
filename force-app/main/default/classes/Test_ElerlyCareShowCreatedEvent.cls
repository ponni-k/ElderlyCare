@isTest
global class Test_ElerlyCareShowCreatedEvent {    
    @isTest
    global static void ElderlyCare(){ 
        
        
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
        
        
        
        
        
        Profile pf = [SELECT Id FROM Profile WHERE Name ='ContactRelationCommunityPlus'];
        

        
        
        user us1 = new User(ProfileId = pf.id,
                            FirstName = '',
                            LastName = 'Lily',
                            Email='testContact@zuddhisystems.com.au',
                            Username = 'testuser@example.com' + System.currentTimeMillis(),
                            Alias = 'tuser',
                            CommunityNickname = 'tuser123',
                            TimeZoneSidKey = 'America/New_York',
                            LocaleSidKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LanguageLocaleKey = 'en_US',
                            contactId = con.Id,
                            IsActive = true                           );
        insert us1;
        
        
        carer__c cr = new carer__c();
        cr.name= 'test';
        cr.User_Name__c = us1.id;
        cr.Availability__c = 'Available';
        cr.Not_available__c = False;
        cr.Start_Date__c=System.today();
        insert cr;
        
        Time_Sheet__c ts = new Time_Sheet__c();
        ts.Start_Date__c = Date.today();
        ts.End_Date__c = Date.today();
        //ts.Carer_Name__c = 'Test Carer';
        ts.Start_Time__c = Time.newInstance(11,5,2,7);
        ts.End_time__c=Time.newInstance(12,5,2,7);
        ts.ClockIn_Location__Latitude__s = 37.123456;
        ts.ClockIn_Location__Longitude__s = -122.987654;
        ts.Account_Name__c = acc.Id;
        //ts.Carer_Name__c = cr.Id;
        //ts.Carer_Name__r.Name = cr.Name;
        //ts.Service_provider__r.Name=us.Name;
        insert ts;
        
        
        Product_Line_Item__c prItem = new Product_Line_Item__c();
        prItem.Name = 'Minor home repairs';
        prItem.Account_Name__c = acc.Id;
        prItem.CareType__c = 'Household Care';
        insert prItem;
        
        
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
        eve.OwnerId = us1.Id;
        //eve.Subject='Aged Care';
        eve.Status__c='Completed';
        eve.Care_Type__c='Gardening';
        eve.User__c=us1.Id;
        eve.whatid = acc.Id;
        //eve.WhoId = con.Id;
        //lstevet.add(eve);
        insert eve;
        
        Feedback__c feedback = new Feedback__c();
        feedback.Contact__c = con.id;
        feedback.Time_Sheet__c = ts.id;
        feedback.Carer__c = cr.id;
        feedback.Rating__c = '5';
        feedback.Comments__c = 'test';
        insert feedback;
        
        Test.startTest();
        system.runAs(us1){
            ElerlyCareShowCreatedEventToRelation.getCreatedEvent();
        }
        ElerlyCareShowCreatedEventToRelation.getSubmitFeedBack(eve.id,'5','test');
        Test.stopTest();
    }
    /*public static testMethod void queryTest(){


event evt = [select id,Time_Sheet__c,WhoId,AccountId from event limit 1];
Time_Sheet__c ts=[select id,name ,Carer_Name__c from Time_Sheet__c limit 1];
test.startTest();
ElerlyCareShowCreatedEventToRelation.getCreatedEvent();
ElerlyCareShowCreatedEventToRelation.getSubmitFeedBack(evt.id,'5','test');
test.stopTest();
}*/
}