@isTest 
private class AA_AccountGeocodeScheduledTest {

    static testMethod void myUnitTest() {
        
        AccountGeocodeScheduled sh1 = new AccountGeocodeScheduled();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Scheduler Check', sch, sh1); 
		} 
    	
}