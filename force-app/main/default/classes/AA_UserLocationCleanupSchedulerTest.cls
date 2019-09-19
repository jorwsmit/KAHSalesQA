@isTest
private class AA_UserLocationCleanupSchedulerTest {

    static testMethod void myUnitTest() {
        AA_UserLocationCleanupScheduler m = new AA_UserLocationCleanupScheduler();
		String sch = '0 0 23 * * ?';
		String jobID = system.schedule('Deletion', sch, m);
    	}
}