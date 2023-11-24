trigger ElderlyCareEventTrigger on Event (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        ElderlyCare.createTimeSheetRecord(trigger.new);
    }
}