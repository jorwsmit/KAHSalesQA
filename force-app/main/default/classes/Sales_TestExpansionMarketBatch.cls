@isTest(seeAllData=false)
private class Sales_TestExpansionMarketBatch {

	@testSetup static void setup(){
		User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
		id proID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].Id;
		id roleID = [SELECT ID, Name FROM UserRole WHERE Name = 'SA - Test'].Id;
		System.runAs ( thisUser ) {
			User saUsr1 = new User(Alias = 'sa1', Email='KAHSalesAssociateHH1@testorg.com',
			EmailEncodingKey='UTF-8', FirstName='Test', LastName='SA1', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', Line_of_Business__c='HH', ProfileId = proID, KAH_Growth__c = true,
			TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociateHH1@testorg.com', UserRoleId=roleID);
			
			list<Sales_Performance__c> spInsert = new list<Sales_Performance__c>();
			list<Account> accInsert = new list<Account>();
			list<AccountTeamMember> atmInsert = new list<AccountTeamMember>();
			list<Sales_Account_Metrics__c> samInsert = new list<Sales_Account_Metrics__c>();
			list<Contact> ctInsert = new list<Contact>();
			list<Contact_Team__c> teamInsert = new list<Contact_Team__c>(); 
			list<Sales_Contact_Metrics__c> scmInsert = new list<Sales_Contact_Metrics__c>();
			
			insert saUsr1;

			Sales_Performance__c sp1 = new Sales_Performance__c(KAH_HH_Admit_Target__c=10, Month__c=Date.newInstance(System.now().year(),01,01),
			KAH_HH_PPS_Qualified_Admits__c=10, OwnerId=saUsr1.Id);

			spInsert.add(sp1);

			Sales_Performance__c sp2 = new Sales_Performance__c(KAH_HH_Admit_Target__c=10, Month__c=Date.newInstance(System.now().year(),02,01),
			KAH_HH_PPS_Qualified_Admits__c=10, OwnerId=saUsr1.Id);

			spInsert.add(sp2);

			Account a1 = new Account(Name='test1');
			accInsert.add(a1);

			Account a2 = new Account(Name='test2');
			accInsert.add(a2);

			insert spInsert;
			insert accInsert;
			
			AccountTeamMember atm = new AccountTeamMember(UserId=saUsr1.Id, AccountId=a1.Id);
			atmInsert.add(atm);

			AccountTeamMember atm2 = new AccountTeamMember(UserId=saUsr1.Id, AccountId=a2.Id);
			atmInsert.add(atm2);
			
			insert atmInsert;
			
			Sales_Account_Metrics__c am = new Sales_Account_Metrics__c(Account__c=a1.Id, KAH_HH_Admits__c=1.0, Month__c=Date.newInstance(System.now().year(),01,01));
			samInsert.add(am);

			Sales_Account_Metrics__c am2 = new Sales_Account_Metrics__c(Account__c=a1.Id, KAH_HP_Admits__c=2.0, Month__c=Date.newInstance(System.now().year(),02,01));
			samInsert.add(am2);
			
			insert samInsert;
			
			Contact c1 = new Contact(FirstName='test', LastName='test');
			ctInsert.add(c1);

			Contact c2 = new Contact(FirstName='test', LastName='test');
			ctInsert.add(c2);
			
			insert ctInsert;
			
			Contact_Team__c ct = new Contact_Team__c(User__c=saUsr1.Id, Contact__c=c1.Id);
			teamInsert.add(ct);

			Contact_Team__c ct2 = new Contact_Team__c(User__c=saUsr1.Id, Contact__c=c2.Id);
			teamInsert.add(ct2);
			
			insert teamInsert; 
			
			Sales_Contact_Metrics__c cm = new Sales_Contact_Metrics__c(Contact__c=c1.Id, KAH_HH_Admits__c=1.0, Month__c=Date.newInstance(System.now().year(),01,01));
			scmInsert.add(cm);

			Sales_Contact_Metrics__c cm2 = new Sales_Contact_Metrics__c(Contact__c=c1.Id, KAH_HP_Admits__c=2.0, Month__c=Date.newInstance(System.now().year(),02,01));
			scmInsert.add(cm2);
			
			insert scmInsert;
		}
	}

	@isTest static void runBatchDefaultYear(){
		Sales_ExpansionMarketBatch batch = new Sales_ExpansionMarketBatch();
		Test.StartTest();
		Database.executeBatch(batch);
		Test.StopTest();
	}

	@isTest static void runBatchSetYear(){
		Sales_ExpansionMarketBatch batch = new Sales_ExpansionMarketBatch();
		batch.year = System.now().year();
		Test.StartTest();
		Database.executeBatch(batch);
		Test.StopTest();
	}

}