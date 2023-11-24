@isTest
public class Test_ElderlyCareRecurrenceTask {
    @testSetup
    public static void testScheduledApex(){
        
        Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='testContact@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,CompanyName='ZuddhiSystems',
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@zuddhisystems.com.au');
        insert us;
        
        Account acc = new Account();
        acc.Name='Test';
        acc.Phone= '12345677';
        acc.AccountImage_URL__c= 'https://i.ibb.co/2ZvfLqB/Mar-jp.jpg';
        acc.Birth_date__c=system.today();
        acc.BillingStreet='Test Address';
        acc.BillingCity='Test Address';
        acc.BillingState='Test Address';
        acc.BillingPostalCode='1234';
        acc.BillingCountry='Test Address';
        acc.Gander__c='Male';
        //acc.Reports_to__c= con.Name;
        acc.Annual_Budget__c=10000;
        insert acc;
        
        HomeCare_Package__c hp = new HomeCare_Package__c();
        hp.Name = 'test name';
        hp.Account_Name__c = acc.Id;
        hp.Select_your_Package__c = 'Homecare Package Level 4';
        hp.Personal_Care__c = true;
        hp.Select_personal_Care_Plans__c ='Bathing';
        insert hp;
        
        Goal__c g = new Goal__c();
        g.Name = 'test name';
        insert g;
        list<Product_Line_Item__c> prItem = new list<Product_Line_Item__c>();
        Product_Line_Item__c prItem1 = new Product_Line_Item__c();
        prItem1.Name = 'Bathing';
        prItem1.Recurrence_Active__c = true;
        prItem1.Account_Name__c = acc.Id;
        prItem1.Sunday__c = true;
        prItem.add(prItem1);
        
        Product_Line_Item__c prItem2 = new Product_Line_Item__c();
        prItem2.Name = 'Bathing';
        prItem2.Recurrence_Active__c = true;
        prItem2.Account_Name__c = acc.Id;
        prItem2.Saturday__c = true;
        prItem.add(prItem2);
        
        Product_Line_Item__c prItem3 = new Product_Line_Item__c();
        prItem3.Name = 'Bathing';
        prItem3.Recurrence_Active__c = true;
        prItem3.Account_Name__c = acc.Id;
        prItem3.Monday__c = true;
        prItem.add(prItem3);
        
        Product_Line_Item__c prItem4 = new Product_Line_Item__c();
        prItem4.Name = 'Bathing';
        prItem4.Recurrence_Active__c = true;
        prItem4.Account_Name__c = acc.Id;
        prItem4.Tuesday__c = true;
        prItem.add(prItem4);
        
        Product_Line_Item__c prItem5 = new Product_Line_Item__c();
        prItem5.Name = 'Bathing';
        prItem5.Recurrence_Active__c = true;
        prItem5.Account_Name__c = acc.Id;
        prItem5.Wednesday__c = true;
        prItem.add(prItem5);
        
        Product_Line_Item__c prItem6 = new Product_Line_Item__c();
        prItem6.Name = 'Bathing';
        prItem6.Recurrence_Active__c = true;
        prItem6.Account_Name__c = acc.Id;
        prItem6.Thursday__c= true;
        prItem.add(prItem6);
        
        Product_Line_Item__c prItem7 = new Product_Line_Item__c();
        prItem7.Name = 'Bathing';
        prItem7.Recurrence_Active__c = true;
        prItem7.Account_Name__c = acc.Id;
        prItem7.Friday__c = true;
        prItem.add(prItem7);
        
        if(!prItem.isEmpty()){
            insert prItem;
        }
        
        
        
        list<Task> tasks = new list<Task>();  
        Date dueDate = system.today()+7;
        for(Integer i=0;i<6;i++){
            tasks.add(new Task(Subject='Bathing'+i, OwnerId = us.Id , WhatId = acc.Id , ActivityDate = dueDate ));
        }
        insert tasks;
    }
    
    public static testMethod void queryTest(){
        list<Product_Line_Item__c> productLineItem = [select id,Name, Account_Name__c, Goal_Name__c, Price__c, Recurrence_Active__c, Sunday__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c,CreatedById  
                                                      from Product_Line_Item__c where Recurrence_Active__c = true];
        Test.startTest();
        string jobId = system.schedule('Create Task','0 0 0 ? * * *', new ElderlyCareRecurrenceTask());
        Test.stoptest();
    }  
    
}