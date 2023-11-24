@isTest
Global class Test_ElderlyCareIncidentReport {
    @isTest
    global static void elderlyCareIncident(){
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
                            IsActive = true);
        insert us1;
        
        carer__c cr = new carer__c();
        cr.name= 'test';
        cr.User_Name__c = us1.id;
        cr.Availability__c = 'Available';
        cr.Not_available__c = False;
        cr.Start_Date__c=System.today();
        insert cr;
        Id adminRecordTypeId = Schema.SObjectType.Incidents_Complaints__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        
        
        //[SELECT Id, RecordTypeId,Client_Name__r.Name, Client_Name__c, Carer_Name__c, Case_Name__c, Incident_Reason__c, Priority__c, Phone__c, Email__c, Subject__c, Reportable_Incident__c, Description__c, Status__c, Incident_Date_and_TIme__c, Issue_Type__c, CreatedDate FROM Incidents_Complaints__c];
        Incidents_Complaints__c incidents = new Incidents_Complaints__c();
        incidents.Carer_Name__c =cr.id;
        incidents.Client_Name__c =acc.id;
        incidents.Email__c ='test@gmail.com';
        incidents.Incident_Reason__c ='testing';
        incidents.Incident_Date_and_TIme__c = system.now();
        incidents.Phone__c = '1234567890';
        incidents.Priority__c ='High';
        incidents.Incident_Reason__c = 'Testing';
        incidents.RecordTypeId = adminRecordTypeId;
        incidents.Status__c ='New';
        incidents.Subject__c = 'test';
        insert incidents;
        
        list<Incidents_Complaints__c> listIncidentReport = [SELECT Id, RecordTypeId,Client_Name__r.Name, Client_Name__c, Carer_Name__c, Case_Name__c, Incident_Reason__c, Priority__c, Phone__c, Email__c, Subject__c, Reportable_Incident__c, Description__c, Status__c, Incident_Date_and_TIme__c, Issue_Type__c, CreatedDate FROM Incidents_Complaints__c];
        system.debug('listIncidentReport--> : '+listIncidentReport[0].Client_Name__c);
        test.startTest();
        ElderlyCareIncidentReport.getIncidentRecords();
        system.runAs(us1){
            ElderlyCareIncidentReport.insertIncidentReport('testsubject', 'test@gmail.com', 'New', '0998765432', listIncidentReport[0].Client_Name__c, 'Physical', 'High', system.Now(), 'true', 'test desc');
            
        }
        ElderlyCareIncidentReport.getIncidentValue(listIncidentReport[0].Id);
        ElderlyCareIncidentReport.updateIncidentValue(listIncidentReport[0].Id, 'Closed','test','test description');
        test.stopTest();
        
        
    }
    /* public static testMethod void queryTest(){
list<Incidents_Complaints__c> listIncidentReport = [SELECT Id, RecordTypeId,Client_Name__r.Name, Client_Name__c, Carer_Name__c, Case_Name__c, Incident_Reason__c, Priority__c, Phone__c, Email__c, Subject__c, Reportable_Incident__c, Description__c, Status__c, Incident_Date_and_TIme__c, Issue_Type__c, CreatedDate FROM Incidents_Complaints__c];
system.debug('listIncidentReport : '+listIncidentReport[0].Client_Name__c);
//string subject ='test';
//WrapperIncidentRecordDetails res = new WrapperIncidentRecordDetails();
test.startTest();
//List<WrapperIncidentRecordDetails> result = ElderlyCareIncidentReport.getIncidentRecords();
ElderlyCareIncidentReport.getIncidentRecords();
ElderlyCareIncidentReport.insertIncidentReport('testsubject', 'test2gmail.com', 'New', '0998765432', listIncidentReport[0].Client_Name__c, 'Physical', 'High', system.Now(), true, 'test desc');

//ElderlyCareIncidentReport.insertIncidentReport(listIncidentReport[0].Subject__c, email, status, phone, client, type, priority, incidentdatetime, incidentReport, Description)
test.stopTest();
}*/
    
    
}