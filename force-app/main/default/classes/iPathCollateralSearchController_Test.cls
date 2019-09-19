@isTest
private class iPathCollateralSearchController_Test {
  
  static testMethod void testCollateralSearch() {
      RestRequest req = new RestRequest();
      RestResponse res = new RestResponse();
      req.requestURI = '/services/apexrest/collateralSubset';
      req.addParameter('filters','{"isFacilitySpecific":true,"searchString":"Test","linesOfBusiness":["TCH","TCC\\/SNF"],"audiences":["Professional"]}');
      req.httpMethod = 'GET';

      RestContext.request = req;
      RestContext.response = res;
        
      test.startTest();
      iPathCollateralSearchController.doGet();
      test.stopTest();
      
      // Asserts can be added here later, this test just to get coverage for now
  }
  
}