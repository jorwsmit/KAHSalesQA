@isTest(seeAllData=false)
private class Sales_TestNewBusinessAdmitRollup {
	@testSetup static void setup(){
		final ID SALES_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].id;
		User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate, perner__c='98698769876861',
		TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');

		insert usr;

		Account acct = new Account(Name='Test Account', Unity_Id__c = '1');
		insert acct;

		New_Business__c nb = new New_Business__c(Account__c=acct.Id, user__c=usr.Id);
		insert nb;

		AccountTeamMember atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct.Id);
		insert atm;
		List<Sales_account_metrics__c> ams = new List<Sales_account_metrics__c>();
		ams.add(new Sales_account_metrics__c(Name='1', Account__c=acct.Id, Month__c=Date.newInstance(System.now().year(), 1, 1),
		KAH_HH_PPS_Admits__c=1));
		ams.add(new Sales_account_metrics__c(Name='2', Account__c=acct.Id, Month__c=Date.newInstance(System.now().year(), 1, 1),
		KAH_HH_PPS_Admits__c=1));
		ams.add(new Sales_account_metrics__c(Name='3', Account__c=acct.Id, Month__c=Date.newInstance(System.now().year(), 6, 15),
		KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=1, KAH_HH_PPS_Admits__c=1));
		ams.add(new Sales_account_metrics__c(Name='4', Account__c=acct.Id, Month__c=Date.newInstance(System.now().year(), 12, 31),
		KAH_HH_PPS_Admits__c=1));
		insert ams;

		Contact con = new Contact(FirstName='Test', LastName = 'Contact', Unity_Id__c = '1');
		insert con;

		nb = new New_Business__c(Contact__c=con.Id, user__c=usr.Id);
		insert nb;

		Contact_Team__c ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
		insert ct;
		List<Sales_contact_metrics__c> cms = new List<Sales_contact_metrics__c>();
		cms.add(new Sales_contact_metrics__c(Name='1', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), 1, 1),
		KAH_HH_PPS_Admits__c=1));
		cms.add(new Sales_contact_metrics__c(Name='2', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), 1, 1),
		KAH_HH_PPS_Admits__c=2));
		cms.add(new Sales_contact_metrics__c(Name='3', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), 6, 15),
		KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=1, KAH_HH_PPS_Admits__c=1));
		cms.add(new Sales_contact_metrics__c(Name='4', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), 12, 31)));
		insert cms;
	}
	@isTest static void usingDefaultYear() {
		Sales_NewBusinessAdmitRollup batch = new Sales_NewBusinessAdmitRollup();
		User usr = [select id from user where username='KAHSalesAssociate@testorg.com'];
		Sales_Performance__c sp = [select Sales_KAH_New_Business_HH_PPS_Admits__c from Sales_Performance__c where
		ownerId=:usr.Id and Month__c=:Date.newInstance(System.now().year(), 1, 1)];
		System.assert(sp.Sales_KAH_New_Business_HH_PPS_Admits__c==0.00);
		batch.query = 'select Id from user where Id=\''+usr.Id+'\'';
		Test.StartTest();
		Database.executeBatch(batch);
		Test.StopTest();
		sp = [select Sales_KAH_New_Business_HH_PPS_Admits__c from Sales_Performance__c where
		ownerId=:usr.Id and Month__c=:Date.newInstance(System.now().year(), 1, 1)];
		System.assert(sp.Sales_KAH_New_Business_HH_PPS_Admits__c==5.00);
	}
}