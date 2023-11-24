/*
     * @Start date: 12/05/2023
     * @autor: Sai Natarajan
     * Test class for SalesforceEssentials app Zuddhisystems 
  */
  @isTest
public with sharing class SalesforceEssentialsTest {

     /**
    * Statics to hold data that can be used for each test. These are populated by the
    * setupData() method.
    **/
    public static SalesforceEssentials__c Essentials{get; set;}
    public static SalesforceFeatures__c Features{get; set;}
    public static List<String> FeaturesList{get;set;} 
    

/**
    * Create the data we will be re-using for many of the tests so it only 
    * needs to be created once.
    **/
    @testSetup static void initializeData(){
       TestObjectFactory.createEssentials();   
       
    }

    Public static testMethod void queryTest(){
        list<SalesforceEssentials__c> lstEsstentialList = [select id,Name,IsAvailable__c,Image_Url__c,Help_Text__c from SalesforceEssentials__c];
        list<SalesforceFeatures__c> lstFeatures = [select id,Name,IsAvailable__c,imageURL__c,Duration__c,HelpText__c,SalesforceEssentialList__r.Name,youtube__c,price__c from SalesforceFeatures__c];
        Lead leads = [select id,Name,Salutation,FirstName,LastName,Company,Email,Phone,Status,Description,LeadsComments__c from Lead];
        List<String> lstRecord = new List<String> { lstFeatures[0].Id}; 
         Test.startTest();
            SalesforceEssentials.getSalesforceEssentialList();
            SalesforceEssentials.getFeaturesvalue(lstEsstentialList[0].id);
            SalesforceEssentials.getFeaturesSummary(lstRecord);
            SalesforceEssentials.getpriceandduration(lstRecord);
            SalesforceEssentials.selectedSummaryDetails(lstFeatures[0].id);
            SalesforceEssentials.createLead(leads.salutation, leads.firstname, leads.lastname, leads.company, leads.email, leads.phone, leads.description, leads.LeadsComments__c);
        Test.stopTest();
        
    }

     
 }