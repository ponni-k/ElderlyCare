@isTest
global class Test_ElderlyCareReusableLookupController {
    
     @testSetup
    global static void ElderlyCare(){ 
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

    }
    
    public static testMethod void invoiceTest(){
        Account acc = [select id ,Name  from Account limit 1];
        
        
        Test.startTest();
        	ElderlyCareReusableLookupController.fetchLookupData(acc.Name, 'Account');
        	ElderlyCareReusableLookupController.fetchDefaultRecord(ACC.Id, 'Account');
        Test.stopTest();
    }
}