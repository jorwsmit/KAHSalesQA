@isTest
private class SalesHD_TestSalesTrainingController {

	@isTest static void getAgreementById(){
		Test.StartTest();
		SalesHD_SalesTrainingController.loadPowerpoint();
		Test.StopTest();
	}
}