@isTest
private class AA_RejectedAccountDeleteSchedulerTest {

    static testMethod void myUnitTest() {
    	
    	string accName = 'TestKRSAcc';
    	string accType = 'STACH'; 
    	string accStreet = '123 sT';
    	string accState = 'KY'; 
    	string accCity = 'Louisville'; 
    	string accZip = '40202';
    	string accPhone = '555-555-5555'; 
    	string accDefID = '21312';
        boolean accNewConst = true;
    	
    	AA_SRSAccountRequest.getStateList();
    	AA_SRSAccountRequest.getTypes();
    	
    	AA_SRSAccountRequest.processAccount(accName, accType, accStreet, accState, accCity, accZip, accPhone, accDefID, accNewConst);
    	
        Account objAccount4 = new Account(Name='TestAccount4', Approval_Denied__c = true );
		insert objAccount4;
		
		String CRON_EXP = '0 0 * * * ?';
		AA_RejectedAccountDeleteScheduler sch = new AA_RejectedAccountDeleteScheduler();
		system.schedule('KRSeAccountDeleteTest', CRON_EXP, sch);
		
        }
}