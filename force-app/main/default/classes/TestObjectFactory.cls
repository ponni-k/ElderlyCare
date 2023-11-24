@isTest
public with sharing class TestObjectFactory {
    /*
     * Creates a list of SalesforceEssentials__c based on the number of SalesforceEssentials__c requested.
     **/
  
    public static void createEssentials() {
        
            // Id,Name,IsAvailable__c,Image_Url__c,Help_Text__c
            SalesforceEssentials__c essential = new SalesforceEssentials__c();
            essential.Name = 'LeadManagement';
            essential.IsAvailable__c = true;
            essential.Image_Url__c = 'images/LeadManagement.jpg';
            Insert essential;
        
            list<SalesforceFeatures__c> lstFeat = new list<SalesforceFeatures__c> ();
            SalesforceFeatures__c f1 = new SalesforceFeatures__c();
            f1.Name = 'test1';
            f1.IsAvailable__c = true;
            f1.Duration__c = 2.5;
            f1.HelpText__c = 'test text';
            f1.Price__c=40;
            f1.SalesforceEssentialList__c = essential.Id;
            lstFeat.add(f1);
            insert lstFeat;
        
         Lead ld = new Lead();
        ld.Salutation = 'Mr.';
        ld.FirstName = 'test';
        ld.LastName= 'm';
        ld.Company = 'test company';
        ld.Email = 'test@gmail.com';
        ld.Phone = '987654321';
        ld.Status = 'Open - Not Contacted';
        ld.Description = 'test Description';
        ld.LeadsComments__c= 'test comments~';
        insert ld;
    }
 
   
   
}