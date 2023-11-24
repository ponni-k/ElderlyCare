public class AgedCareHomeCarePackage {
    
    public static void createRelaedHomeCarePackage(list<HomeCare_Package__c> lstHCP){
        
        list<id> lstid = new list<id>();
        
        for(HomeCare_Package__c hcp : lstHCP){
            lstid.add(hcp.Id);
        }
        system.debug('lstid:'+lstid);
        //list<account> lstaccount = [select id ,name from account where ]
        if(lstid.size()>0){
            //lstid.addError('Related Home Care Packages Is Already Exists');
        }
        
        
        
    }
    
    public static void createRelaedHomeCarePackage(list<Account> listAccount){
        system.debug('listAccount :'+listAccount);
        
        List<Id> lstId = new List<Id>();
        for(Account acc : listAccount){
            lstId.add(acc.Id);
        }
        
        list<HomeCare_Package__c> lstHomeCarePackage = [select id,Account_Name__c from HomeCare_Package__c where Account_Name__c=:lstId];
        system.debug('lstHomeCarePackage :'+lstHomeCarePackage);
        system.debug('lstHomeCarePackage Size :'+lstHomeCarePackage.size());
        
        if(lstHomeCarePackage.size()>1	){
            for(Account account: listAccount){
                account.addError('Related Home Care Package Already Exists');
                system.debug('If condition');
            } 
        }
        else {
            system.debug(' Else condition');
        }
    }
}