@isTest
private class AA_DashboardTest {

    static testMethod void myUnitTest() {
        AA_Dashboard objDashboard = new AA_Dashboard();
	    
	    AA_Dashboard.getRoles('DVP');
	    AA_Dashboard.getIndividuals('DVP - Reifenrath');
	    AA_Dashboard.getRoleNames();
	    AA_Dashboard.getReportNames();
	    AA_Dashboard.getRoleAlt();
	    AA_Dashboard.getRoleAlt2();
        }
}