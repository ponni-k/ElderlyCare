global class ElderlyCareChecklist {
    @AuraEnabled(cacheable=true)
    global static map<string,list<string>> getchecklistValue(string eventId){
        Event eve = [select id,Subject, Service_Items__c,Service_Items__r.Name,WhatId from event where id = :eventId];
        string serviceId = eve.Service_Items__c;
        list<string> lstCHeckList = new list<string>();
        Product_Line_Item__c prItem = [select id,Account_Name__c, Name, Price__c, CareType__c, Service_Checklist__c from Product_Line_Item__c where id= :serviceId];
        string lststr = prItem.Service_Checklist__c ;
        List<String> splitStrings;
        list<string> dupList  = new list<String>();
        if(lststr != null && lststr !='') {
            splitStrings = lststr.split(';');
            system.debug('if runs');
        } else {
       		dupList.add(prItem.Name);
            splitStrings = dupList;
            system.debug('else runs');
        }
        system.debug('splitStrings :'+splitStrings);
        map<string,list<string>> checklistval = new map<string,list<string>>();
        checklistval.put(prItem.Name,splitStrings);
        system.debug('checklistval :'+checklistval);
        system.debug('checklistval :'+checklistval.Keyset());
        return checklistval;
    }
    /*public static list<string> getchecklistValue(string eventId){
Event eve = [select id,Subject, Service_Items__c,Service_Items__r.Name,WhatId from event where id = :eventId];
string serviceId = eve.Service_Items__c;
list<string> lstCHeckList = new list<string>();
Product_Line_Item__c prItem = [select id,Account_Name__c, Name, Price__c, CareType__c, Service_Checklist__c from Product_Line_Item__c where id= :serviceId];
string lststr = prItem.Service_Checklist__c ;
List<String> splitStrings = lststr.split(';');
system.debug('splitStrings :'+splitStrings);
return splitStrings;
}*/
    
}