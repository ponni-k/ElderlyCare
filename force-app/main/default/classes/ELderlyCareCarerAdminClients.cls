global with sharing class ELderlyCareCarerAdminClients {
    @AuraEnabled(cacheable=true)
    global static list<Account> getClients(){
        Id currentUserId = UserInfo.getUserId();
        list<User> us = [select Id,name,Username,CompanyName ,Contact.Name,ContactId,AccountId from user where Id =:currentUserId];
        List<Account> lstacc = [SELECT Id, Name, LastName, FirstName, BillingAddress, Phone,Profile__c, PhotoUrl, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, AnnualRevenue, CreatedById, OwnerId,Reports_to__c FROM Account where CreatedById=:currentUserId];
        system.debug('List of Accounts: '+lstacc);
        return lstacc;
    }
}