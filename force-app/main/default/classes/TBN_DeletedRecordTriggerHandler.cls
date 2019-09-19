public with sharing class TBN_DeletedRecordTriggerHandler {
	
	//constructor
	public TBN_DeletedRecordTriggerHandler(){
		
	}
	
	/*
    Method Name: isAfterUpdate
    Return type: void
    Description: To delete 'Deleted Record' when the status gets updated to success.
    */
	public void isAfterUpdate(map <id,Deleted_Record__c>mapNewDeletedRecords){
		
		delete [SELECT id, Status__c FROM Deleted_Record__c WHERE Status__c='Success' and id IN:mapNewDeletedRecords.keyset()];
	}
}