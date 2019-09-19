@isTest
private class AA_ActivityCleanerTest {

    static testMethod void myUnitTest() {
        AA_ActivityCleanerScheduler m = new AA_ActivityCleanerScheduler();
		String sch = '0 0 23 * * ?';
		String jobID = system.schedule('ActivityDeletion', sch, m);
    	}
}