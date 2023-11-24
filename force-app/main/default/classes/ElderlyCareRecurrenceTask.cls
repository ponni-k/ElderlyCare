global with sharing class ElderlyCareRecurrenceTask implements schedulable{
    global  void execute(SchedulableContext sc){
        list<Product_Line_Item__c> listProductLineItem = new list<Product_Line_Item__c>();
        list<Product_Line_Item__c> productLineItem = [select id,Name, Account_Name__c, Goal_Name__c, Price__c, Recurrence_Active__c, Sunday__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c,CreatedById  
                                                      from Product_Line_Item__c where Recurrence_Active__c = true];
        list<Task> task = new list<Task>();
        Date dueDate = system.today()+7;
       // system.debug('dueDate: '+dueDate);
        if(!productLineItem.isEmpty()){
        for(Product_Line_Item__c pr:productLineItem){
            if(pr.Recurrence_Active__c == true){
                if(pr.Sunday__c == true){
                    Task tsk1 = new Task();
                    tsk1.Subject = pr.Name;
                    tsk1.OwnerId = pr.CreatedById;
                    tsk1.WhatId = pr.Account_Name__c;
                    tsk1.ActivityDate = dueDate;
                    task.add(tsk1);
                    system.debug('ActivityDate:'+tsk1.ActivityDate);
                }
                if(pr.Monday__c == true){
                    Task tsk2 = new Task();
                    tsk2.Subject = pr.Name;
                    tsk2.OwnerId = pr.CreatedById;
                    tsk2.WhatId = pr.Account_Name__c;
                    tsk2.ActivityDate = dueDate+1;
                    task.add(tsk2);
                }
                if(pr.Tuesday__c == true){
                    Task tsk3 = new Task();
                    tsk3.Subject = pr.Name;
                    tsk3.OwnerId = pr.CreatedById;
                    tsk3.WhatId = pr.Account_Name__c;
                    tsk3.ActivityDate = dueDate+2;
                    task.add(tsk3);
                }
                if(pr.Wednesday__c == true){
                    Task tsk4 = new Task();
                    tsk4.Subject = pr.Name;
                    tsk4.OwnerId = pr.CreatedById;
                    tsk4.WhatId = pr.Account_Name__c;
                    tsk4.ActivityDate = dueDate+3;
                    task.add(tsk4);
                }
                if(pr.Thursday__c == true){
                    Task tsk5 = new Task();
                    tsk5.Subject = pr.Name;
                    tsk5.OwnerId = pr.CreatedById;
                    tsk5.WhatId = pr.Account_Name__c;
                    tsk5.ActivityDate = dueDate+4;
                    task.add(tsk5);
                }
                if(pr.Friday__c == true){
                    Task tsk6 = new Task();
                    tsk6.Subject = pr.Name;
                    tsk6.OwnerId = pr.CreatedById;
                    tsk6.WhatId = pr.Account_Name__c;
                    tsk6.ActivityDate = dueDate+5;
                    task.add(tsk6);
                }
                  if(pr.Saturday__c == true){
                    Task tsk7 = new Task();
                    tsk7.Subject = pr.Name;
                    tsk7.OwnerId = pr.CreatedById;
                    tsk7.WhatId = pr.Account_Name__c;
                    tsk7.ActivityDate = dueDate+6;
                    task.add(tsk7);
                }
            }
        }
        }
        //system.debug('task :'+task);
        if(!task.isEmpty()){
        insert task;
       // return task;
            }
       
    }   
}