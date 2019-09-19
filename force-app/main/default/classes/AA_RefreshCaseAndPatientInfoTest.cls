@isTest
private class AA_RefreshCaseAndPatientInfoTest {

    static testMethod void myUnitTest() {
        AA_RefreshCaseAndPatientInfoScheduler sh1 = new AA_RefreshCaseAndPatientInfoScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test CaseUpdater Check', sch, sh1); 
        }
}