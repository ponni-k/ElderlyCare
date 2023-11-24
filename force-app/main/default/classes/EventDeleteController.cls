public with sharing class EventDeleteController {
    @AuraEnabled
    public static void deleteEvent(String eventId){
        Event eventToDelete = [SELECT Id FROM Event WHERE Id = :eventId];

        if (eventToDelete != null) {
            delete eventToDelete;
            System.debug('Event deleted successfully!');
        } else {
            System.debug('Event not found!');
        }
    }
    @AuraEnabled
    public static void EventStatus(Id recordId, String newStatus){
        Event eve=[select Id,Status__c from Event where Id = :recordId ];
        eve.Status__c= newStatus;
        update eve;
        System.debug(eve);
    }
}