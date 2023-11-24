public without sharing class DashboardsController {
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getAllOppsByStage(){
        List<AggregateResult> result =  [SELECT Count(Id) cnt, StageName FROM  Opportunity GROUP BY StageName];
        system.debug('result :'+result);
        List<DataSet> dataSet = new List<DataSet>();
        for(AggregateResult ar : result) {
            String stage =  (String)ar.get('StageName') ;
            Integer total =  (Integer)ar.get('cnt');
            dataSet.add(new DataSet(stage ,total));
        }
        system.debug('dataSet :'+dataSet);
        return dataSet ;
    }
    
    public class DataSet {
        public DataSet(String label ,Integer count){
            this.label  = label ;
            this.count  = count ;
        }
        
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public Integer  count {get;set;}
    }
}