@isTest
private class SalesHD_IncentiveFormsTest {

	public class data {
		public String cl;
		public String patient;
		public String facility;
		public String payor;
		public String referralDate;
		public String reason;
		public String days;
		public String comments;
		public Boolean delayed;
		public Boolean lost;
	}

	@testSetup static void setup(){
		User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
		ID profileID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
		ID roleID1 = [SELECT ID, Name FROM UserRole WHERE Name = 'HD Central - Atlanta CL'].ID;
		System.runAs ( thisUser ) {
			User u = new User(Alias = 'CL', Email='KindredTestCL@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', Line_of_Business__c='HD', ProfileId = profileID,
			TimeZoneSidKey='America/Los_Angeles', UserName='KindredTestCL@testorg.com', UserRoleId=roleID1);

			insert u;
		}
	}

	@isTest static void test_method_one() {
		// Given
		String testString;

		// When
		testString = Sales_MissedOpportunityHD.getUsers();

		// Then
		System.assert(testString!=null);
	}

	@isTest static void test_method_two() {
		// Given
		String testString;

		// When
		User u = [select Name from user where username='KindredTestCL@testorg.com'];
		Data d = new Data();
		d.cl=u.Name; d.patient='test'; d.facility='test'; d.payor='test'; d.referralDate='01/01/01';
		d.reason='test'; d.days='1'; d.comments='test'; d.delayed=false; d.lost=true;
		testString = Sales_MissedOpportunityHD.sendEmail(JSON.serialize(d));

		// Then
		System.assert(testString!=null);


	}

}