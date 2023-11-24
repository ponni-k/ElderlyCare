global class Highlightpanel{
    @AuraEnabled(cacheable=true)
    global static Account getAccount(string accountrecordId){
        system.debug('Record Id:' +accountrecordId);
        Account acc =[select id,Name,Phone,Profile__c, Account_Image__c,AccountImage_URL__c, Annual_Budget__c, Birth_date__c, Age__c,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Gander__c, Reports_to__c,Reports_to__r.Name from Account where id=:accountrecordId];
        system.debug('acc=' +acc);
        return acc;
    }
    
    @AuraEnabled(cacheable=true)
    global static Account getRelatedAccountDetails(string eventRecordId){
        Event evt = [select id,AccountId from event where id =:eventRecordId];
        //system.debug('Record Id:' +accountrecordId);
        Account acc =[select id,Name,Phone,Profile__c, Account_Image__c,BillingCity,AccountImage_URL__c, Birth_date__c, Age__c,BillingAddress,Gander__c, Reports_to__c,Reports_to__r.Name from Account where id=:evt.AccountId ];
        system.debug('acc=' +acc);
        return acc;
    }
    
    //@AuraEnabled(cacheable=true)
    global class InputVariables {
        @InvocableVariable 
        global String acid;
    }
        @InvocableMethod(label='AG Goal record Creation flow from HCP' description='Description of my method')
    global static void getValues(list<InputVariables> inputvariable){
    //public static void getValues(string  accid){
        string accid = inputvariable[0].acid;
        list<Goal__c> lst = [SELECT Id, Related_Account__c, Selected_Comprehensive_allied_healthPlan__c, Selected_ExtensiveHomeModification_Plans__c, Selected_HomeModifications__c, Selected_Home_modification_Plans__c, Selected_Medication_plans__c, Selected_SocialSupport_Cares__c, Selected_Personal_Care_Plans__c, Selected_Specialized_nursing_plans__c, Selected_Support_for_personal_plans__c, Selected_Transportation_plans__c, Selected_advanced_nursing_care__c, Selected_allied_health_plans__c, Selected_great_allied_health_plans__c, Selected_intensive_pesonal_plans__c, Selected_household_cares__c, Selected_meal_plans__c, Selected_mobility_plans__c, Selected_more_complex_medication__c, Selected_specialized_pallative_plans__c,Property_Maintenance__c,Security_Services__c,Select_Property_Maintenance_Service__c,Select_Security_Services__c FROM Goal__c where Related_Account__c=:accId]; 
        list<Product_Line_Item__c> serviceItems = new list<Product_Line_Item__c>();
        
        list<string> lststring = new list<string>();
        for (Goal__c record : lst) {
            Product_Line_Item__c seritem = new Product_Line_Item__c();
            if(record.Selected_Comprehensive_allied_healthPlan__c != null){
                String splitfirst = record.Selected_Comprehensive_allied_healthPlan__c;
                //system.debug('splitfirst :'+splitfirst);  
                lststring.add(splitfirst);
            }
            if(record.Selected_ExtensiveHomeModification_Plans__c != null){
                string splitsecond = record.Selected_ExtensiveHomeModification_Plans__c;
                //system.debug('splitsecond :'+splitsecond);
                lststring.add(splitsecond);
            }
            if(record.Selected_HomeModifications__c != null){
                string splitthird= record.Selected_HomeModifications__c;
                //system.debug('splitthird :'+splitthird);
                lststring.add(splitthird);
            }
            if(record.Selected_Home_modification_Plans__c != null){
                string splitfourth= record.Selected_Home_modification_Plans__c;
                //system.debug('splitfourth :'+splitfourth);
                lststring.add(splitfourth);
            }
            if(record.Selected_Medication_plans__c != null){
                string splitfifth= record.Selected_Medication_plans__c;
                //system.debug('splitfifth :'+splitfifth);
                lststring.add(splitfifth);
            }
            if(record.Selected_SocialSupport_Cares__c != null){
                string splitsixth= record.Selected_SocialSupport_Cares__c;
                //system.debug('splitsixth :'+splitsixth);
                lststring.add(splitsixth);
            }
            if(record.Selected_Personal_Care_Plans__c != null){
                string splitseventh= record.Selected_Personal_Care_Plans__c;
                //system.debug('splitseventh :'+splitseventh);
                lststring.add(splitseventh);
            }
            if(record.Selected_Specialized_nursing_plans__c != null){
                string spliteighth= record.Selected_Specialized_nursing_plans__c;
               // system.debug('spliteighth :'+spliteighth);
                lststring.add(spliteighth);
            }
            if(record.Selected_Support_for_personal_plans__c != null){
                string splitnineth= record.Selected_Support_for_personal_plans__c;
                //system.debug('splitnineth :'+splitnineth);
                lststring.add(splitnineth);
            }
            if(record.Selected_Transportation_plans__c != null){
                string splittenth= record.Selected_Transportation_plans__c;
               // system.debug('splittenth :'+splittenth);
                lststring.add(splittenth);
            }
            if(record.Selected_allied_health_plans__c != null){
                string spliteleventh= record.Selected_allied_health_plans__c;
                //system.debug('spliteleventh :'+spliteleventh);
                lststring.add(spliteleventh);
            }
            if(record.Selected_great_allied_health_plans__c != null){
                string splittwelveth= record.Selected_great_allied_health_plans__c;
                //system.debug('splittwelveth :'+splittwelveth);
                lststring.add(splittwelveth);
            }
            if(record.Selected_intensive_pesonal_plans__c != null){
                string splitthirteen= record.Selected_intensive_pesonal_plans__c;
                //system.debug('splitthirteen :'+splitthirteen);
                lststring.add(splitthirteen);
            }
            if(record.Selected_household_cares__c != null){
                string splitfourteen= record.Selected_household_cares__c;
                //system.debug('splitfourteen :'+splitfourteen);
                lststring.add(splitfourteen);
            }
            if(record.Selected_meal_plans__c != null){
                string splitfifteen= record.Selected_meal_plans__c;
                //system.debug('splitfifteen :'+splitfifteen);
                lststring.add(splitfifteen);
            }
            if(record.Selected_mobility_plans__c != null){
                string splitsixteen= record.Selected_mobility_plans__c;
                system.debug('splitfifteen :'+splitsixteen);
                lststring.add(splitsixteen);
            }
            if(record.Selected_more_complex_medication__c != null){
                string splitseventeen= record.Selected_more_complex_medication__c;
                ////system.debug('splitseventeen :'+splitseventeen);
                lststring.add(splitseventeen);
            }
            if(record.Selected_specialized_pallative_plans__c  != null){
                string spliteighteen= record.Selected_specialized_pallative_plans__c ;
                //system.debug('spliteighteen :'+spliteighteen);
                lststring.add(spliteighteen);
            }
             if(record.Select_Property_Maintenance_Service__c  != null){
                string splitnineteen= record.Select_Property_Maintenance_Service__c ;
                //system.debug('spliteighteen :'+spliteighteen);
                lststring.add(splitnineteen);
            }if(record.Select_Security_Services__c  != null){
                string splittwenty= record.Select_Security_Services__c ;
                //system.debug('spliteighteen :'+spliteighteen);
                lststring.add(splittwenty	);
            }
            String str;
            for (Integer i = 0; i < lststring.size(); i++) {
                str = lststring[i].replace(';', ',');
            }
            List<string> strList = new List<string>();
            
            for(string s1 : lststring){                   
                if(s1.contains(';')) {
                    List<String> splitedVal = s1.split(';'); 
                    for(string s: splitedVal) {
                        strList.add(s);    
                    }
                } else {
                    strList.add(s1);
                }
            }
            
            list<string> clientname = new list<string>();
            list<string> relatedgoal = new list<string>();
            list<string> packagename = new list<string>();

            List<String> splitStrings = str.split(','); 
            for(string s1 : strList){
                Product_Line_Item__c seritem1 = new Product_Line_Item__c();
                seritem1.Name = s1;
                seritem1.Goal_Name__c=record.Id;
                relatedgoal.add(record.Id);
                seritem1.Account_Name__c= record.Related_Account__c;
                serviceItems.add(seritem1);
            }
            
            if(!serviceItems.isempty()){
                try {
                    Database.saveResult[] results = Database.insert(serviceItems, false);
                    system.debug('results :'+results);
                    system.debug('results size :'+results.size());
                } catch(DMLException e) {
                    throw new DMLException('Unable to Perform the DML Operation on Product Line Item :' +e.getMessage());
                }
            } 
        }
    } 
}