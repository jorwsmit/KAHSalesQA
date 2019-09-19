@isTest 
private class TBN_TestDeleteRecordtrigger {

    static testMethod void myUnitTest() {
        
        Account objAccount = new Account(Name='TestAcc');
        insert objAccount;
        
		Deleted_Record__c objDeleteRecord = new Deleted_Record__c(status__c='New', Deleted_Record_Id__c = objAccount.Id);
		insert objDeleteRecord;
		
		objDeleteRecord.status__c = 'Success';
		update objDeleteRecord;
    }
}