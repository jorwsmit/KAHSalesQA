@isTest(seeAllData=false)
private class Sales_TestTargetAgreementController {

	@testSetup static void setup(){
		ID profileID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
		ID roleID1 = [SELECT ID, Name FROM UserRole WHERE Name = 'SA - Test'].ID;
		ID roleID2 = [SELECT ID, Name FROM UserRole WHERE Name = 'MM - Test'].ID;
		
		User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
		System.runAs ( thisUser ) {
			list<User> uInsert = new list<User>();
			User saUsr1 = new User(Alias = 'sa1', Email='KAHSalesAssociateHH1@testorg.com',
			EmailEncodingKey='UTF-8', FirstName='Test', LastName='SA1', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', Line_of_Business__c='HH', ProfileId = profileID,
			TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociateHH1@testorg.com', UserRoleId=roleID1);

			uInsert.add(saUsr1);

			User saUsr2 = new User(Alias = 'sa2', Email='KAHSalesAssociateHH2@testorg.com',
			EmailEncodingKey='UTF-8', FirstName='Test', LastName='SA2', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', Line_of_Business__c='HP', ProfileId = profileID,
			TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociateHH2@testorg.com', UserRoleId=roleID1);

			uInsert.add(saUsr2);

			User mmUsr = new User(Alias = 'mm', Email='KAHMarketManagerHH@testorg.com',
			EmailEncodingKey='UTF-8', FirstName='Test', LastName='MM', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', Line_of_Business__c='HH', ProfileId = profileID,
			TimeZoneSidKey='America/Los_Angeles', UserName='KAHMarketManagerHH@testorg.com', UserRoleId=roleID2);

			uInsert.add(mmUsr);
			insert uInsert;
			
			list<Sales_Performance__c> spInsert = new list<Sales_Performance__c>();
			Sales_Performance__c sp1 = new Sales_Performance__c(KAH_HH_Admit_Target__c=10, KAH_HH_PPS_Qualified_Admits__c=10, OwnerId=saUsr1.Id);

			spInsert.add(sp1);

			Sales_Performance__c sp2 = new Sales_Performance__c(KAH_HH_Admit_Target__c=20, KAH_HH_PPS_Qualified_Admits__c=20, OwnerId=saUsr2.Id);

			spInsert.add(sp2);
			insert spInsert;
		}
	}

	@isTest static void getAgreementById(){
		User usr = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta = new Target_Agreement__c(Manager_Agreed__c=true, Manager_Agreement_Date__c=Date.valueOf(System.Now()) , SA_Agreed__c=true, SA_Agreement_By__c=usr.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta;
		Test.StartTest();
		System.runAs (usr){
			Sales_TargetAgreementController.getAgreementById(ta.Id);
		}
		delete ta;
		Sales_TargetAgreementController.getAgreementById(ta.Id);
		Test.StopTest();
	}

	@isTest static void getAgreementById2(){
		User usr = [SELECT id FROM User WHERE Alias='sa2'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta = new Target_Agreement__c(Manager_Agreed__c=true, Manager_Agreement_Date__c=Date.valueOf(System.Now()), SA_Agreed__c=true, SA_Agreement_By__c=usr.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta;
		Test.StartTest();
		System.runAs (usr){
			Sales_TargetAgreementController.getAgreementById(ta.Id);
		}
		delete ta;
		Sales_TargetAgreementController.getAgreementById(ta.Id);
		Test.StopTest();
	}

	@isTest static void getAgreementByIdWithTypes(){
		User usr = [SELECT id FROM User WHERE Alias='sa2'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta = new Target_Agreement__c(Sales_KAH_Form_Type__c='CTL', Manager_Agreed__c=true, Manager_Agreement_Date__c=Date.valueOf(System.Now()), SA_Agreed__c=true, SA_Agreement_By__c=usr.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta;
		Test.StartTest();
		System.runAs (usr){
			Sales_TargetAgreementController.getAgreementById(ta.Id);
		}
		ta.Sales_KAH_Form_Type__c='HHS';
		update ta;
		System.runAs (usr){
			Sales_TargetAgreementController.getAgreementById(ta.Id);
		}
		ta.Sales_KAH_Form_Type__c='HCS/HS';
		update ta;
		System.runAs (usr){
			Sales_TargetAgreementController.getAgreementById(ta.Id);
		}
		ta.Sales_KAH_Form_Type__c='MM';
		update ta;
		System.runAs (usr){
			Sales_TargetAgreementController.getAgreementById(ta.Id);
		}
		ta.Sales_KAH_Form_Type__c='Dual';
		update ta;
		System.runAs (usr){
			Sales_TargetAgreementController.getAgreementById(ta.Id);
		}
		Test.StopTest();
	}

	@isTest static void getAgreementByIndex(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User usr2 = [SELECT id FROM User WHERE Alias='sa2'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(SA_Agreement_By__c=usr1.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		Target_Agreement__c ta2 = new Target_Agreement__c(SA_Agreement_By__c=usr2.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		insert ta2;
		Test.StartTest();
		Sales_TargetAgreementController.getAgreement(1, System.now().year(), new List<Boolean>{true, true, true});
		Test.StopTest();
	}

	@isTest static void getList(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User usr2 = [SELECT id FROM User WHERE Alias='sa2'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(SA_Agreement_By__c=usr1.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		Target_Agreement__c ta2 = new Target_Agreement__c(SA_Agreement_By__c=usr2.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		insert ta2;
		Test.StartTest();
		Sales_TargetAgreementController.getAgreement(null, System.now().year(), new List<Boolean>{true, true, true});
		Test.StopTest();
	}

	@isTest static void getList2(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(SA_Agreement_By__c=usr1.Id, SA_Agreement_Date__c=Date.valueOf(System.now()), SA_Agreed__c=true, Manager_Agreement_By__c=manager.Id, Manager_Agreed__c=true, Manager_Agreement_Date__c=Date.valueOf(System.now()), Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		Test.StartTest();
		Sales_TargetAgreementController.getAgreementById(ta1.Id);
		Test.StopTest();
	}

	@isTest static void managerAgree(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta = new Target_Agreement__c(SA_Agreement_By__c=usr1.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta;
		Test.StartTest();
		System.runAs (manager){
			Sales_TargetAgreementController.agree(ta.Id);
		}
		Test.StopTest();
	}

	@isTest static void saAgree(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta = new Target_Agreement__c(SA_Agreement_By__c=usr1.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta;
		Test.StartTest();
		System.runAs (usr1){
			Sales_TargetAgreementController.agree(ta.Id);
		}
		Test.StopTest();
	}

	@isTest static void getUsers(){
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Test.StartTest();
		System.runAs (manager){
			Sales_TargetAgreementController.getUsers();
		}
		Test.StopTest();
	}

	@isTest static void getUserData(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(Retired__c=false, SA_Agreement_By__c=usr1.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		Alert_and_Comment__c ac = new Alert_and_Comment__c(Comment_By__c=manager.Id, Comment_To__c=usr1.Id, Datetime__c=System.now(), Comment__c='Cats');
		insert ac;
		Test.StartTest();
		System.runAs (manager){
			Sales_TargetAgreementController.getUserData(usr1.Id, System.now().year(), 'actual');
			Sales_TargetAgreementController.getUserData(usr1.Id, System.now().year(), 'hidden');
		}
		Test.StopTest();
	}

	@isTest static void emailPdf(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta = new Target_Agreement__c(SA_Agreed__c=true, SA_Agreement_By__c=usr1.Id, Manager_Agreed__c=true, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta;
		Test.StartTest();
		Sales_TargetAgreementController.emailPdf(ta.id);
		Test.StopTest();
	}

	@isTest static void getPdf(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(SA_Agreed__c=true, SA_Agreement_By__c=usr1.Id, Manager_Agreed__c=true, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		Test.StartTest();
		Sales_TargetAgreementController.pdfText(ta1);
		Test.StopTest();
	}

	@isTest static void getPdf2(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(SA_Agreed__c=true, SA_Agreement_By__c=usr1.Id, Manager_Agreed__c=true, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		Test.StartTest();
		Sales_TargetAgreementController.pdfText(ta1);
		Test.StopTest();
	}

	@isTest static void updateManager(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Test.StartTest();
		Sales_TargetAgreementController.updateManager(usr1.Id, manager.Id, System.now().year());
		Test.StopTest();
	}

	@isTest static void saveComment(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		Test.StartTest();
		Sales_TargetAgreementController.saveComment(usr1.Id, 'test');
		Test.StopTest();
	}

	@isTest static void sendQuestion(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(SA_Agreement_By__c=usr1.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		Test.StartTest();
		Sales_TargetAgreementController.sendQuestion(ta1.Id, 'test');
		Test.StopTest();
	}

	@isTest static void createSP(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		Test.StartTest();
		Sales_TargetAgreementController.createSP(usr1.Id, System.now().year());
		Test.StopTest();
	}

	@isTest static void saveTargets(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		List<String> hhTargets = new List<String> {'1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1'};
		List<String> hpTargets = new List<String> {'1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1'};
		Test.StartTest();
		Sales_TargetAgreementController.saveTargets(usr1.Id, System.now().year(), hhTargets, hpTargets, 'actual', true);
		Sales_TargetAgreementController.saveTargets(usr1.Id, System.now().year(), hhTargets, hpTargets, 'hidden', false);
		Test.StopTest();
	}

	@isTest static void createAgreement(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Test.StartTest();
		Sales_TargetAgreementController.createAgreement(usr1.Id, manager.Id, System.now().year(), true);
		Test.StopTest();
	}

	@isTest static void updateFormType(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Test.StartTest();
		Sales_TargetAgreementController.updateFormType(usr1.Id, System.now().year(), 'Test');
		Test.StopTest();
	}

	@isTest static void KAHSendGoalEmailBatch(){
		User usr1 = [SELECT id FROM User WHERE Alias='sa1'];
		User manager = [SELECT id FROM User WHERE Alias='mm'];
		Target_Agreement__c ta1 = new Target_Agreement__c(SA_Agreement_By__c=usr1.Id, Manager_Agreement_By__c=manager.Id, Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta1;
		Sales_KAHSendGoalEmailBatch batch = new Sales_KAHSendGoalEmailBatch();
		batch.query = 'select Id, SA_Agreement_By__r.Name, SA_Agreement_By__r.Email, Manager_Agreement_By__r.Name,'+
		'SA_Agreed__c, Manager_Agreed__c, Manager_Agreement_By__r.Email, Date__c '+
		'from target_agreement__c where Id = \''+ta1.Id+'\'';
		Test.StartTest();
		Database.executeBatch(batch);
		Test.StopTest();
	}


}