@isTest
private class TBN_TestLandingPage {

    static testMethod void TBN_LandingPageController() {
        
		TBN_LandingPageController objLandingPage = new TBN_LandingPageController();
			objLandingPage.fetchUserPermissions();
    }
}