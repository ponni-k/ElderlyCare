Global class ElderlyCareSelectedServices {
    @auraEnabled(Cacheable=true)
    Global static list<Product_Line_Item__c> getServices(string accId){
        list<Product_Line_Item__c> lstservice = new list<Product_Line_Item__c>();
        List<Product_Line_Item__c> ser = [Select id, name, Account_Name__c,Price__c from Product_Line_Item__c where Account_Name__c=:accId];
        //system.debug('@@@ser: '+ser);
        for(Product_Line_Item__c sr :ser){
            lstservice.add(sr);
        }
        System.debug('lstservice :'+lstservice);
        return lstservice;
    }
     @auraEnabled(Cacheable=true)
    Global static List<String> getPackageLevel(string accId){
        List<string> packageLevel = new List<string>();
        List<Goal__c> goal = [select id, name, Related_Account__c,PackageLevel__c from Goal__c where Related_Account__c=:accId];
       // system.debug('@@@goal: '+goal);
         for(Goal__c gl :goal){
            packageLevel.add(gl.PackageLevel__c);
        }
       // System.debug('Pacakage Level :'+packageLevel);
        return packageLevel;
        
    }

    @auraEnabled
    Global static String updatePhoto(string accId, string imgURL){
        try{
            Account ActImage = [select id,AccountImage_URL__c from Account where Id =:accId];
            ActImage.AccountImage_URL__c=imgURL;
             update ActImage; 
             return 'TRUE' ;  
            }catch(DMLException e){
                System.debug('The following exception has occurred: ' + e.getMessage());
                return e.getMessage();
            }
        
    } 
        
}