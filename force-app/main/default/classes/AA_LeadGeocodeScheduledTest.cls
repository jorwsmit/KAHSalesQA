@isTest 
private class AA_LeadGeocodeScheduledTest {

    static testMethod void myUnitTest() {
        
        LeadGeocodeScheduled sh1 = new LeadGeocodeScheduled();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test LeadScheduler Check', sch, sh1); 
        
        }
}