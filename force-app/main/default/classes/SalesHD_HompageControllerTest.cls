@isTest
private class SalesHD_HompageControllerTest
{

	@testSetup static void setup(){
		ID profileID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
		ID roleID1 = [SELECT ID, Name FROM UserRole WHERE Name = 'HD Central - Atlanta CL'].ID;
		ID roleID2 = [SELECT ID, Name FROM UserRole WHERE Name = 'MM - Test'].ID;
		User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
		System.runAs ( thisUser ) {
			User u = new User(Alias = 'CL', Email='KindredTestCL@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', Line_of_Business__c='HD', ProfileId = profileID,
			TimeZoneSidKey='America/Los_Angeles', UserName='KindredTestCL@testorg.com', UserRoleId=roleID1);

			insert u;
			list<Event> eInsert = new list<Event>();
			Event e = new Event(OwnerId=u.Id, Type='Test',
			StartDateTime=Datetime.newInstance(System.now().year(), System.now().month(), 1),
			EndDateTime=Datetime.newInstance(System.now().year(), System.now().month(), 1));
			eInsert.add(e);

			Event e2 = new Event(OwnerId=u.Id, Type='Test',
			StartDateTime=Datetime.newInstance(System.now().year(), System.now().month(), 1),
			EndDateTime=Datetime.newInstance(System.now().year(), System.now().month(), 1));
			eInsert.add(e2);
			insert eInsert;
		}
	}

	@isTest
	static void getCorporateMessages()
	{
		// Given
		List<String> testList;

		// When
		testList = SalesHD_HompageController.getCorporateMessages();

		// Then
		System.assert(testList.size()==3);

	}

	@isTest
	static void getCalendar()
	{
		// Given
		String testString;

		// When

		User u = [select id from user where username='KindredTestCL@testorg.com'];
		System.runAs ( u ) {
			testString = SalesHD_HompageController.getCalendar(0);
		}

		// Then
		System.assert(testString!=null);

	}
}