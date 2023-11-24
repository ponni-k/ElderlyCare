public class ElderlyCareTaskPath {
  @AuraEnabled(cacheable=true)
    public static list<Task> getTaskList(String TaskId){
        list<Task> tsk = [select id,WhatId, ActivityDate, Account.Name,Status,Subject from task where id= :TaskId];
        system.debug(tsk);
        return tsk;
        
    }
@AuraEnabled
    public static void updateTaskStatus(String TaskId, String Status){
        Task task = [select id,WhatId, ActivityDate, Account.Name,Status,Subject from task where id= :TaskId];
        task.Status = Status;
        update task;
        System.debug('Updated Status'+task);
    }
}