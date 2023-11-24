global class ElderlyCare_CA_ServicePackage {
    @AuraEnabled(Cacheable=true)
    global static List<Elderly_Care_Services__c> getServicePackage(){
        Id userId = UserInfo.getUserId();
        List<Elderly_Care_Services__c> elderlyCareservices = new list<Elderly_Care_Services__c>();
        list<Elderly_Care_Services__c> lstElderlyCareServices = [Select id,Name,IsAvailable__c,NDIS_Price__c,NDIS_Service_code__c,Service_Description__c from Elderly_Care_Services__c];
        if(!lstElderlyCareServices.isEmpty()){
            for(Elderly_Care_Services__c elderlyCareService : lstElderlyCareServices){
                if(elderlyCareService.IsAvailable__c == true){
                    elderlyCareservices.add(elderlyCareService);	
                }
            }
        }
        return elderlyCareservices;
    }
}