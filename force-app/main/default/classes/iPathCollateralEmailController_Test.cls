@isTest
private class iPathCollateralEmailController_Test {
  
    static testMethod void myMethod() {
        // Create test lead
        Lead x1 = new Lead(LastName = 'Test Lead 1', Company = 'TestCo');
        insert x1;
        
        //Create test contact
        Contact x2 = new Contact(LastName = 'TestContact1');
        insert x2;
        
        // Create some content
        ContentVersion doc = new ContentVersion();
        doc.Title = 'Any title';
        doc.PathOnClient = 'Any path';
        doc.VersionData = Blob.valueOf('Any text');
        insert doc;
        doc = [select ContentDocumentId from ContentVersion where id = :doc.id];
        List<Id> docs = new List<Id>();
        docs.add(doc.ContentDocumentId);
        //Map<String,String> sendEmail(String trackingId, Id recipientId, String email, String centerId, List<Id> contentDocumentIds, String emailContent, String firstName, String lastName)
        Map<String,String> testResult = iPathCollateralEmailController.sendEmail('0036def2-9255-4712-a98a-876d41639fa2', x1.Id, 'test@none.com', '', docs, 'Hi there', null, null);
    	testResult = iPathCollateralEmailController.sendEmail('9999def2-9255-4712-a98a-876d41639fa2', x2.Id, 'bradley.thomas@kindred.com', '', docs, 'Hi there', null, null);
    	}
    
    static testMethod void testValidationMethod() {
        // Test nulls
        Map<String,String> testResult = iPathCollateralEmailController.sendEmail('', null, '', '', null, '', '', '');
        System.assertEquals(testResult.get('Result'), 'Failed');
        
        // Test task search
        testResult = iPathCollateralEmailController.sendEmail('SOME-RANDOM-ID', null, '', '', null, '', '', '');
        System.assertEquals(testResult.get('Result'), 'Failed');
        
        // Test null contentDocumentId
        List<Id> contentDocumentIds = new List<Id>();
        contentDocumentIds.add(null);
        testResult = iPathCollateralEmailController.sendEmail('', null, '', '', contentDocumentIds, '', '', '');
        System.assertEquals(testResult.get('Result'), 'Failed');
    	}
    
    static testMethod void testSendEmailMethod() {
        // Create test lead
        Lead x1 = new Lead(LastName = 'Test Lead 1', Company = 'TestCo');
        insert x1;
        
        //Create test contact
        Contact x2 = new Contact(LastName = 'TestContact1');
        insert x2;
        
        // Create some content
        ContentVersion doc = new ContentVersion();
        doc.Title = 'Any title';
        doc.PathOnClient = 'Any path';
        doc.VersionData = Blob.valueOf('Any text');
        insert doc;
        doc = [select ContentDocumentId from ContentVersion where id = :doc.id];
        List<Id> docs = new List<Id>();
        docs.add(doc.ContentDocumentId);
        
        // Test bad email address with random tracking id
        Map<String,String> testResult = iPathCollateralEmailController.sendEmail('0036def2-9255-4712-a98a-876d41639fa2', x1.Id, 'BAD-EMAIL-HERE', '', docs, 'Hi there', '', '');
        System.assertEquals(testResult.get('Result'), 'Failed');
        
        // Test happy path for lead
        testResult = iPathCollateralEmailController.sendEmail('0036def2-9255-4712-a98a-876d41639fa2', x1.Id, 'bradley.thomas@kindred.com', '', docs, 'Hi there', '', '');
        System.assertEquals(testResult.get('Result'), 'Success');
        
        // Test resend same email
        testResult = iPathCollateralEmailController.sendEmail('0036def2-9255-4712-a98a-876d41639fa2', x1.Id, 'bradley.thomas@kindred.com', '', docs, 'Hi there', '', '');
        System.assertEquals(testResult.get('Result'), 'Failed');
        
        // Test happy path for contact
        testResult = iPathCollateralEmailController.sendEmail('9999def2-9255-4712-a98a-876d41639fa2', x2.Id, 'bradley.thomas@kindred.com', '', docs, 'Hi there', '', '');
        System.assertEquals(testResult.get('Result'), 'Success');
    	}
    
    static testMethod void testVisualForceController() {
    	ID accountCtr = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Center'].ID;
    	
        // Instantiating the controller
        iPathMobileEmailTemplate_Controller controller = new iPathMobileEmailTemplate_Controller();
        
        // Call image methods
        String x = controller.getemail_bar_general();
        x = controller.getlogo_kindred();
        x = controller.geticn_twitter();
        x = controller.geticn_facebook();
        
        x = controller.geticn_linkedin();
        x = controller.geticn_youtube();
        x = controller.getctc_email();
        
        // Call weblink methods
        x = controller.getfindKindredLocationsWeblink();
        x = controller.getsuccessStoriesWeblink();
        x = controller.gettwitterWeblink();
        x = controller.getfacebookWeblink();
        x = controller.getyoutubeWeblink();
        x = controller.getcontinueTheCareWeblink();
    	x = controller.getlinkedinWeblink();
    	x = controller.getcenterWebsiteLink();
    	x = controller.getscheduleATourLink();
    	x = controller.getrequestMoreInformationLink();
    	
    	Account center = new Account(Name = 'Test Center',
    								 Facility_Number__c = '5555',
    								 Website = 'www.kindred.com',
    								 QL_ScheduleTour__c = 'www.kindred.com',
    								 QL_ContactUs__c = 'www.kindred.com',
    								 RecordTypeID = accountCtr);
    								 insert center;
    	ApexPages.currentPage().getParameters().put('centerId', center.ID);
    	iPathMobileEmailTemplate_Controller controller2 = new iPathMobileEmailTemplate_Controller();
    	x = controller2.getcenter_logo();
    	x = controller2.getcenterWebsiteLink();
    	x = controller2.getscheduleATourLink();
    	x = controller2.getrequestMoreInformationLink();
    	}
  
}