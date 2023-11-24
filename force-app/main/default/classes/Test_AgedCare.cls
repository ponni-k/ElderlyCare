@isTest
public class Test_AgedCare {
    //@isTest
    @testSetup
    public static void agedCare(){
        list<SalesforceEssentials__c> lstEsstentialList = new list<SalesforceEssentials__c>();
        //select id,Name,IsAvailable__c,Image_Url__c,Help_Text__c from SalesforceEssentials__c];
        SalesforceEssentials__c e1 = new SalesforceEssentials__c();
        e1.Name = 'test1';
        e1.IsAvailable__c = true;
        e1.Image_Url__c = 'images/AccountContact.jpg';
        e1.Help_Text__c = 'samplet text';
        lstEsstentialList.add(e1);
        
        SalesforceEssentials__c e2 = new SalesforceEssentials__c();
        e2.Name = 'test2';
        e2.IsAvailable__c = true;
        e2.Image_Url__c = 'images/AccountContact.jpg';
        e2.Help_Text__c = 'samplet text';
        lstEsstentialList.add(e2);
        insert lstEsstentialList; 
        
        //list<SalesforceFeatures__c> lstFeat = [select id,Name,IsAvailable__c,imageURL__c,Duration__c,HelpText__c,SalesforceEssentialList__r.Name,youtube__c from SalesforceFeatures__c where SalesforceEssentialList__c=:recordId];
        list<SalesforceFeatures__c> lstFeat = new list<SalesforceFeatures__c> ();
        SalesforceFeatures__c f1 = new SalesforceFeatures__c();
        f1.Name = 'test1';
        f1.IsAvailable__c = true;
        f1.Duration__c = 2.5;
        f1.Price__c=5;
        f1.HelpText__c = 'test text';
        f1.SalesforceEssentialList__c = e1.Id;
        lstFeat.add(f1);
        
        SalesforceFeatures__c f2 = new SalesforceFeatures__c();
        f2.Name = 'test2';
        f2.IsAvailable__c = false;
        f2.Duration__c = 2.556;
        f2.Price__c = 10;
        f2.HelpText__c = 'test text2';
        f2.SalesforceEssentialList__c = e2.Id;
        lstFeat.add(f2);
        insert lstFeat; 
        
        Id LeadRecordtypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SalesforceEssentials').getRecordTypeId();

        Lead ld = new Lead();
        ld.Salutation = 'Mr.';
        ld.FirstName = 'test';
        ld.LastName= 'm';
        ld.Company = 'test company';
        ld.RecordTypeId = LeadRecordtypeId;
        ld.Email = 'test@gmail.com';
        ld.Phone = '987654321';
        ld.Status = 'Open - Not Contacted';
        ld.Description = 'test Description';
        ld.LeadsComments__c= 'test comments~';
        insert ld;
    } 
    public static testMethod void queryTest(){
        list<SalesforceEssentials__c> lstEsstentialList = [select id,Name,IsAvailable__c,Image_Url__c,Help_Text__c from SalesforceEssentials__c];
        list<SalesforceFeatures__c> lstFeatures = [select id,Name,IsAvailable__c,imageURL__c,Duration__c,HelpText__c,SalesforceEssentialList__r.Name,youtube__c,price__c from SalesforceFeatures__c];
        Lead leads = [select id,Name,Salutation,FirstName,LastName,Company,Email,Phone,Status,Description,LeadsComments__c from Lead];
        List<String> lstRecord = new List<String> { lstFeatures[0].Id};
        Test.startTest();
            AgedCare.getSalesforceEssentialList();
            AgedCare.getFeaturesvalue(lstEsstentialList[0].id);
            AgedCare.getFeaturesSummary(lstRecord);
            AgedCare.getpriceandduration(lstRecord);
            AgedCare.selectedSummaryDetails(lstFeatures[0].id);
            AgedCare.createLead(leads.salutation, leads.firstname, leads.lastname, leads.company, leads.email, leads.phone, leads.description, leads.LeadsComments__c);
        Test.stopTest();
    }
}