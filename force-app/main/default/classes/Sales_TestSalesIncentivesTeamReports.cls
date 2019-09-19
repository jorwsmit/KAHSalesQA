@isTest(seeAllData=false)
private class Sales_TestSalesIncentivesTeamReports {

	@testSetup static void setup(){
		ID profileID = [SELECT ID FROM Profile WHERE Name = 'Sales - KAH Admin'].ID;
		ID roleID = [SELECT ID FROM UserRole WHERE Name = 'KAH - Corporate'].ID;
		
		ID profileID2 = [SELECT ID FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
		ID roleID2 = [SELECT ID FROM UserRole WHERE Name = 'SA - Test'].ID;
		
		User thisUser = [select Id from User where isActive = true AND userRoleID =: roleID AND ProfileID =: profileID LIMIT 1];
		System.runAs(thisUser){
			User saUsr = new User(Alias = 'sa1', Email='KAHSalesAssociateHH1@testorg.com',
			EmailEncodingKey='UTF-8', FirstName='Test', LastName='SA1', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', Line_of_Business__c='HH', ProfileId = profileID2,
			TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociateHH1@testorg.com', UserRoleId=roleID2);

			insert saUsr;

			Sales_Performance__c sp1 = new Sales_Performance__c(Month__c = Date.newInstance(System.now().year(), 1, 1), KAH_HH_Admit_Target__c=10, KAH_HH_PPS_Qualified_Admits__c=10, OwnerId=saUsr.Id);

			insert sp1;

			Sales_Performance__c sp2 = new Sales_Performance__c(Month__c = Date.newInstance(System.now().year(), 2, 1),KAH_HH_Admit_Target__c=20, KAH_HH_PPS_Qualified_Admits__c=20, OwnerId=saUsr.Id);

			insert sp2;
			}
		}

	@isTest static void getTargetActualTable(){
		ID profileID = [SELECT ID FROM Profile WHERE Name = 'Sales - KAH Admin'].ID;
		ID roleID = [SELECT ID FROM UserRole WHERE Name = 'KAH - Corporate'].ID;
		
		ID profileID2 = [SELECT ID FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
		ID roleID2 = [SELECT ID FROM UserRole WHERE Name = 'SA - Test'].ID;
		User thisUser = [select Id from User where isActive = true AND userRoleID =: roleID LIMIT 1];
		User saUsr = [select Id, Line_of_Business__c from User where Alias = 'sa1'];
		Target_Agreement__c ta = new Target_Agreement__c(Manager_Agreement_By__c=thisUser.Id, SA_Agreement_By__c=saUsr.Id,
		Manager_Agreed__c=true, Manager_Agreement_Date__c=Date.newInstance(System.now().year(), 1, 1));
		insert ta;
		Test.StartTest();
		System.runAs ( thisUser ) { Sales_SalesIncentivesTeamReports.getTargetTable(System.now().year(), saUsr.Line_of_Business__c); }
		Test.StopTest();
	}

	@isTest static void getTargetHiddenTable(){
		ID profileID = [SELECT ID FROM Profile WHERE Name = 'Sales - KAH Admin'].ID;
		ID roleID = [SELECT ID FROM UserRole WHERE Name = 'KAH - Corporate'].ID;
		
		ID profileID2 = [SELECT ID FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
		ID roleID2 = [SELECT ID FROM UserRole WHERE Name = 'SA - Test'].ID;
		User thisUser = [select Id from User where isActive = true AND userRoleID =: roleID LIMIT 1];
		User saUsr = [select Id, Line_of_Business__c from User where Alias = 'sa1'];
		Target_Agreement__c ta = new Target_Agreement__c(Manager_Agreement_By__c=thisUser.Id, SA_Agreement_By__c=saUsr.Id);
		insert ta;
		Test.StartTest();
		System.runAs ( thisUser ) { Sales_SalesIncentivesTeamReports.getTargetHiddenTable(System.now().year(), saUsr.Line_of_Business__c); }
		Test.StopTest();
	}

	@isTest static void getAllTargets(){
		ID profileID = [SELECT ID FROM Profile WHERE Name = 'Sales - KAH Admin'].ID;
		ID roleID = [SELECT ID FROM UserRole WHERE Name = 'KAH - Corporate'].ID;
		
		ID profileID2 = [SELECT ID FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
		ID roleID2 = [SELECT ID FROM UserRole WHERE Name = 'SA - Test'].ID;
		User thisUser = [select Id from User where isActive = true AND userRoleID =: roleID LIMIT 1];
		User saUsr = [select Id, Line_of_Business__c from User where Alias = 'sa1'];
		Target_Agreement__c ta = new Target_Agreement__c(Manager_Agreement_By__c=thisUser.Id, SA_Agreement_By__c=saUsr.Id);
		insert ta;
		Test.StartTest();
		System.runAs ( thisUser ) { Sales_SalesIncentivesTeamReports.getAllTargets(System.now().year(), saUsr.Line_of_Business__c); }
		Test.StopTest();
	}
	
	static testMethod void getReport(){
		Sales_SalesIncentivesTeamReports sitr = new Sales_SalesIncentivesTeamReports();
		sitr.getReportHtml();
		
		ApexPages.currentPage().getParameters().put('report', '1');
		ApexPages.currentPage().getParameters().put('year', string.valueOf(system.now().year()));
		ApexPages.currentPage().getParameters().put('lob', 'HH');
		sitr.getReportHtml();
		
		ApexPages.currentPage().getParameters().put('report', '2');
		ApexPages.currentPage().getParameters().put('year', string.valueOf(system.now().year()));
		ApexPages.currentPage().getParameters().put('lob', 'HP');
		sitr.getReportHtml();
		
		}
		

}