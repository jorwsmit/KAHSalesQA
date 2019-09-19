@isTest (SeeAllData = false)
private class Sales_TestMarketingToolAlpha {
	@testSetup static void dataSetup() {
		final ID SALES_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].id;
		User usr = new User(Alias = 'test', Email='testuser@kindredtest.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate,
		TimeZoneSidKey='America/Los_Angeles', UserName='testuser@kindredtest.com');
		insert usr;

		Program__c bereavement = new Program__c(name='Bereavement');
		insert bereavement;

		Program__c vet = new Program__c(name='We Honor Veterans');
		insert vet;

		Program__c vol = new Program__c(name='Volunteer');
		insert vol;

		Program__c networks = new Program__c(name='Kindred Networks');
		insert networks;

		Program__c spec = new Program__c(name='TestSpec');
		insert spec;

		ContentVersion cv = new ContentVersion(Title='CV1', ContentUrl='TestUrl1', LOB__c='HH', Category_Tags__c='Collateral (Salesforce)', Program__c=bereavement.Id);
		insert cv;

		cv = new ContentVersion(Title='CV2', ContentUrl='TestUrl2', LOB__c='HP', Category_Tags__c='Collateral (Salesforce)', Program__c=networks.Id, Sales_Market__c='Kentuckiana');
		insert cv;

		cv = new ContentVersion(Title='CV3', ContentUrl='TestUrl3', LOB__c='TCH', Category_Tags__c='Collateral (Salesforce)', Program__c=networks.Id, Audience_Tag__c='Patient');
		insert cv;

		cv = new ContentVersion(Title='CV4', ContentUrl='TestUrl4', LOB__c='HP', Category_Tags__c='Specialty', Program__c=spec.Id, Audience_Tag__c='Patient', Sales_Market__c='Kentuckiana');
		insert cv;

		cv = new ContentVersion(Title='CV5', ContentUrl='TestUrl5', LOB__c='HP', Category_Tags__c='Success Story Videos');
		insert cv;

		cv = new ContentVersion(Title='CV6', ContentUrl='TestUrl1', LOB__c='HH', Category_Tags__c='Collateral (Salesforce)', Program__c=vet.Id);
		insert cv;

		cv = new ContentVersion(Title='CV7', ContentUrl='TestUrl1', LOB__c='HH', Category_Tags__c='Collateral (Salesforce)', Program__c=vol.Id);
		insert cv;

	}

	@isTest static void getPrograms() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getSpecPrograms();
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getMarkets() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getMarkets();
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral1() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Home Health', 'Core Collateral', 'TestSpec', 'Bereavement', 'Kentuckiana');
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral2() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Hospice', 'Specialty Programs', 'TestSpec', 'Kindred Networks', 'Kentuckiana');
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral3() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Hospice', 'Core Collateral', 'TestSpec', 'Kindred Networks', 'Kentuckiana');
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral4() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Hospice', 'Specialty Programs', 'TestSpec', 'Customer', 'Kentuckiana');
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral5() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Hospital', 'Core Collateral', 'TestSpec', 'Customer', 'Kentuckiana');
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral6() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Hospice', 'Success Story Videos', null, null, null);
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral7() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Home Health', 'Core Collateral', 'TestSpec', 'We Honor Veterans', 'Kentuckiana');
		Test.StopTest();
		System.assert(result!=null);
	}

	@isTest static void getCollateral8() {
		String result;
		Test.StartTest();
		result = Sales_MarketingToolControllerAlpha.getCollateral('Home Health', 'Core Collateral', 'TestSpec', 'Volunteer', 'Kentuckiana');
		Test.StopTest();
		System.assert(result!=null);
	}
}