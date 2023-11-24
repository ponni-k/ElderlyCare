public with sharing class CalenderController {
   @AuraEnabled
    public static List<Task> displayTask(){
       List<Task> task=[SELECT Id FROM Task];
        return task;

    }
}