trigger TBN_DeletedRecordTrigger on Deleted_Record__c (after update) {

    TBN_DeletedRecordTriggerHandler handler = new TBN_DeletedRecordTriggerHandler();
    
    //After update of Deleted_Record
    if(trigger.isUpdate && trigger.isAfter){
        
        handler.isAfterUpdate(trigger.newmap);
    }
}