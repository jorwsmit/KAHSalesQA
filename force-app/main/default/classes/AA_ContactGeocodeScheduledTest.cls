@isTest 
private class AA_ContactGeocodeScheduledTest {

    static testMethod void myUnitTest() {
        
        ContactGeocodeScheduled sh1 = new ContactGeocodeScheduled();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test ContactScheduler Check', sch, sh1); 
        
        }
}