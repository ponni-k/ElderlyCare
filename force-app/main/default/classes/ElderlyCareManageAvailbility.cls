Global class ElderlyCareManageAvailbility {
    Global static void handleAvailbility(List<Event> newEvents){
        Set<Id> assignedToIds = new Set<Id>();
        Set<Datetime> startDatetimes = new Set<Datetime>();
        Set<Datetime> endDatetimes = new Set<Datetime>();
        // Collect Assigned To User Ids and Start Date Times for new Events
        for (Event newEvent : newEvents) {
            assignedToIds.add(newEvent.OwnerId);
            startDatetimes.add(newEvent.StartDateTime);
            endDatetimes.add(newEvent.EndDateTime);
        }
        
        // Query for existing Events with the same Assigned To user, subject 'Not Available', and start date time
        List<Event> existingEvents = [SELECT Id, Subject, StartDateTime,EndDateTime, OwnerId
                                      FROM Event
                                      WHERE Subject = 'Not Available'
                                      AND OwnerId IN :assignedToIds
             						  ];
        
        // Check if any matching record is found and throw an exception with a custom error message
        for (Event newEvent : newEvents) {
            for (Event existingEvent : existingEvents) {
                
                if (newEvent.OwnerId == existingEvent.OwnerId
                    && newEvent.StartDateTime >= existingEvent.StartDateTime && newEvent.StartDateTime <= existingEvent.EndDateTime ) {
                        newEvent.addError('The Carer is not available for the selected date and time ');
                    }
            }
        }
    }
      global class InputvariableFromFlow {
        @InvocableVariable 
        global String crid;
      }
    @InvocableMethod(label='Carer Availability and Event Management Flow' description='Description of my method')

    Global static void deleteEvent(List<InputvariableFromFlow> carer){
        string carerid = carer[0].crid;
        list<carer__c> care= [select id,name,Availability__c,Not_Available__c,User_Name__c,Start_Date__c from carer__c where id =:carerid];
        Set<Id> crId = new Set<Id>();
        Set<Datetime> startDatetimes = new Set<Datetime>();
       // Collect Carer Ids  
        for (carer__c carer1 : care) {
            crId.add(carer1.id);
            startDatetimes.add(carer1.Start_Date__c);
        }

       //Query for carer with Availability__c "Available" and Not_Available__c checkbox unchecked
        list<carer__c> cr = [select id,name,Availability__c,Not_Available__c,User_Name__c,Start_Date__c from carer__c where id IN :crId AND Start_Date__c IN :startDatetimes];
        
        string carerUserName = cr[0].User_Name__c;
        Datetime startDate = cr[0].Start_Date__c;
        List<Event> eventsToDelete = [SELECT Id,OwnerId,Subject,StartDateTime FROM Event WHERE OwnerId = :carerUserName AND Subject='Not Available'AND StartDateTime = :startDate];
        system.debug('eventsToDelete :'+eventsToDelete);
        
        List<Event> eventIdsToDelete = new List<Event>();
        
        for (carer__c carer1 : cr) {
            if (carer1.Availability__c == 'Available' && !carer1.Not_Available__c) {
                eventIdsToDelete.add(eventsToDelete[0]);
            }
        }
        system.debug('eventIdsToDelete :'+eventIdsToDelete);
        if (!eventIdsToDelete.isEmpty()) {
         delete eventIdsToDelete;
        }
    }
}