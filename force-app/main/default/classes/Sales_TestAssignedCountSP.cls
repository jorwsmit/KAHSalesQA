@isTest(seeAllData=false)
private class Sales_TestAssignedCountSP {
	@testSetup static void setup(){
		ID profileID = [SELECT Name, ID FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
		User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = profileID,
		TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');

		insert usr;

		Sales_Performance__c sp = new Sales_Performance__c(OwnerId=usr.Id, Month__c=date.newInstance(System.now().year(), System.now().month(), 1));
		insert sp;

		Account acct = new Account(Name='Test Account', Unity_Id__c = '1');
		insert acct;
		AccountTeamMember atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct.Id);
		insert atm;

		Contact con = new Contact(FirstName='Test', LastName = 'Contact', Unity_Id__c = '1');
		insert con;
		Contact_Team__c ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
		insert ct;
	}

	@isTest static void executeBatch() {
		Sales_Performance__c sp = [select Sales_KAH_Number_of_Assigned_Accounts__c, Sales_KAH_Number_of_Assigned_Contacts__c
		from Sales_Performance__c where ownerId in (select id from user where Alias='test') and month__c=this_month];
		System.assert(sp.Sales_KAH_Number_of_Assigned_Accounts__c==null && sp.Sales_KAH_Number_of_Assigned_Contacts__c==null);
		Sales_AssignedCountSP b = new Sales_AssignedCountSP();
		b.query = 'select id from user where Alias=\'test\'';
		Test.StartTest();
		Database.executeBatch(b, 200);
		Test.StopTest();
		sp = [select Sales_KAH_Number_of_Assigned_Accounts__c, Sales_KAH_Number_of_Assigned_Contacts__c
		from Sales_Performance__c where ownerId in (select id from user where Alias='test') and month__c=this_month];
		System.assert(sp.Sales_KAH_Number_of_Assigned_Accounts__c==1 && sp.Sales_KAH_Number_of_Assigned_Contacts__c==1);
	}

	@isTest static void executeScheduled() {
		Sales_ScheduleAssignedCountSP sh1 = new Sales_ScheduleAssignedCountSP();
		String sch = '0 0 23 * * ?';
		Test.StartTest();
		system.schedule('Test Sales_ScheduleAssignedCountSP', sch, sh1);
		Test.stopTest();
	}

}