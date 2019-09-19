@isTest
private class iPathAccountSyncController_Test {
  
	static testMethod void testDoSync() {
    	List<Id> clientList = new List<Id>();
    	List<Account> results = iPathAccountSyncController.doSync(clientList);
    	}
    
}