@isTest 
private class AA_RHCReportControllerTest {

    static testMethod void myUnitTest(){
    	ID accType = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'PF_Chain'].ID;
		ID ctcType = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact_Partner_First'].ID;
		ID roleIDDVP = [SELECT ID, Name FROM UserRole WHERE Name = 'DVP - Black'].ID;
		ID roleIDRVP = [SELECT ID, Name FROM UserRole WHERE Name = 'RVP - Dunn'].ID;
		ID roleIDADO = [SELECT ID, Name FROM UserRole WHERE Name = 'ADO - Dunn'].ID;
    	
        User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser){
        ID profileID = userinfo.getProfileId();
		list<User> toInsert = new list<User>();
		
		User u = new User(ProfileId = profileID, 
	    				  FirstName = 'Test',
	    				  LastName = 'User',
	    				  userName = 'test234242423@usertest.none',
	    				  UserRoleId = roleIDDVP,
	    				  Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
            			  
        toInsert.add(u);
         
        User u2 = new User(ProfileId = profileID, 
	    				  FirstName = 'Test2',
	    				  LastName = 'User2',
	    				  userName = 'test223@usernonetest.none',
	    				  UserRoleId = roleIDRVP,
	    				  Alias = 'te90', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
            			  
        toInsert.add(u2);
         
         
        User u3 = new User(ProfileId = profileID, 
	    				  FirstName = 'Test3',
	    				  LastName = 'User3',
	    				  userName = 'test2333@user3nonetest.none',
	    				  UserRoleId = roleIDADO,
	    				  Alias = 'te30', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
            			  
        toInsert.add(u3);
         
        insert toInsert;
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = accType, NPI__c = '12');
		insert objAccount;
        test.startTest();
        list<AccountTeamMember> atmToInsert = new list<AccountTeamMember>();
        AccountTeamMember atm = new AccountTeamMember(AccountId = objAccount.ID,
													  TeamMemberRole = 'ADO (Partner First)',
													  UserId = u3.Id);
		atmToInsert.add(atm);
		
		AccountTeamMember atm2 = new AccountTeamMember(AccountId = objAccount.ID,
													  TeamMemberRole = 'RVP (Partner First)',
													  UserId = u2.Id);
		atmToInsert.add(atm2);
		
		AccountTeamMember atm3 = new AccountTeamMember(AccountId = objAccount.ID,
													  TeamMemberRole = 'DVP (Partner First)',
													  UserId = u.Id);
		atmToInsert.add(atm3);
		insert atmToInsert;
		
		list<Contact>lstContact = new list<Contact>();
		Contact objContact = new Contact(LastName='TestContact', RecordTypeId = ctcType, NPI__c = '1263', AccountID = objAccount.ID);
		lstContact.add(objContact);
		
		Contact objContact2 = new Contact(LastName='TestContact2', RecordTypeId = ctcType, NPI__c = '5123', AccountID = objAccount.ID);
		lstContact.add(objContact2);
		
		Contact objContact3 = new Contact(LastName='TestContact3', RecordTypeId = ctcType, NPI__c = '7123', AccountID = objAccount.ID);
		lstContact.add(objContact3);
		insert lstContact;
		
		list<Contact_Team__c> ctToInsert = new list<Contact_Team__c>();
		Contact_Team__c ctm = new Contact_Team__c(Contact__c = objContact.ID,
												  User__c = u2.ID
												  );
		ctToInsert.add(ctm);
		
		Contact_Team__c ctm2 = new Contact_Team__c(Contact__c = objContact2.ID,
												  User__c = u3.ID
												  );
		ctToInsert.add(ctm2);
		insert ctToInsert;
		list<Task> toInsertTask = new list<Task>();
		
		Task t = new Task(Subject = 'NPS Survey Follow-up', OwnerID = u3.Id, ActivityDate = system.today(), WhoID = objContact3.ID, WhatID = objAccount.ID);
        toInsertTask.add(t);
        
		Task t2 = new Task(WhatID = objAccount.ID, Type = 'PDPM Contract Renewal', OwnerID = u3.Id, ActivityDate = system.today());													     			  
        toInsertTask.add(t2);
        
        Task t3 = new Task(WhatID = objAccount.ID, Type = 'PDPM Contract Renewal', OwnerID = u2.Id, ActivityDate = system.today());													     			  
        toInsertTask.add(t3);
        
        Task t4 = new Task(WhatID = objAccount.ID, Type = 'PDPM Contract Renewal', OwnerID = u.Id, ActivityDate = system.today());													     			  
        toInsertTask.add(t4);
        
        insert toInsertTask;
		
		string letterStart = 't';
		string letterEnd = 'u';
		list<string> ADO_Filter = new list<string>();
		list<string> RVP_Filter = new list<string>();
		list<string> DVP_Filter = new list<string>();
		
		
        AA_RHCReportController.getReportNames();
        AA_RHCReportController.getAccounts();
        AA_RHCReportController.getContacts('TestAccount');
        AA_RHCReportController.getDVPTeams('TestAccount');
        AA_RHCReportController.getRVPTeams('TestAccount');
        AA_RHCReportController.getADOTeams('TestAccount');
        AA_RHCReportController.getFacility('TestAccount');
        AA_RHCReportController.getDVPActivities('TestAccount');
        AA_RHCReportController.getRVPActivities('TestAccount');
        AA_RHCReportController.getADOActivities('TestAccount');
        AA_RHCReportController.getReportTable('Contacts Reporting', 'TestAccount');
        test.stopTest();
        }
    	}
    	
    static testMethod void myUnitTest2(){
    	ID accType = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'PF_Chain'].ID;
		ID ctcType = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact_Partner_First'].ID;
		ID roleIDDVP = [SELECT ID, Name FROM UserRole WHERE Name = 'DVP - Black'].ID;
		ID roleIDRVP = [SELECT ID, Name FROM UserRole WHERE Name = 'RVP - Dunn'].ID;
		ID roleIDADO = [SELECT ID, Name FROM UserRole WHERE Name = 'ADO - Dunn'].ID;
    	
        User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser){
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = accType, NPI__c = '12', Status__c = 'Active');
		insert objAccount;
		
		ID adoProfileID = [SELECT ID, Name FROM Profile WHERE Name = 'RHC Ops: ADO'].ID;
		ID managerProfileID = [SELECT ID, Name FROM Profile WHERE Name = 'RHC Ops: Manager'].ID;
		list<User> toInsert = new list<User>();
		
		User u = new User(ProfileId = managerProfileID, 
	    				  FirstName = 'Test',
	    				  LastName = 'User',
	    				  userName = 'test234242423@usertest.none',
	    				  UserRoleId = roleIDDVP,
	    				  Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u2 = new User(ProfileId = managerProfileID, 
	    				  FirstName = 'Test',
	    				  LastName = 'User',
	    				  userName = 't222est234242423@usertest.none',
	    				  UserRoleId = roleIDRVP,
	    				  Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
            			  
        User u3 = new User(ProfileId = adoProfileID, 
	    				  FirstName = 'Test',
	    				  LastName = 'User',
	    				  userName = 't33est234242423@usertest.none',
	    				  UserRoleId = roleIDADO,
	    				  Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
            			  
        User u4 = new User(ProfileId = adoProfileID, 
	    				  FirstName = 'Test',
	    				  LastName = 'User',
	    				  userName = 't444est234242423@usertest.none',
	    				  UserRoleId = roleIDADO,
	    				  Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');    			      			  
            			  
        toInsert.add(u);
        toInsert.add(u2);
        toInsert.add(u3);
        toInsert.add(u4);
         
        insert toInsert;
        
        list<AccountTeamMember> atmToInsert = new list<AccountTeamMember>();
		
		AccountTeamMember atm = new AccountTeamMember(AccountId = objAccount.ID,
													  TeamMemberRole = 'ADO (Partner First)',
													  UserId = u4.Id);
		atmToInsert.add(atm);
		
		AccountTeamMember atm2 = new AccountTeamMember(AccountId = objAccount.ID,
													  TeamMemberRole = 'RVP (Partner First)',
													  UserId = u2.Id);
		atmToInsert.add(atm2);
		
		AccountTeamMember atm3 = new AccountTeamMember(AccountId = objAccount.ID,
													  TeamMemberRole = 'DVP (Partner First)',
													  UserId = u.Id);
		atmToInsert.add(atm3);
		
		insert atmToInsert;
		
		list<Contact>lstContact = new list<Contact>();
		Contact objContact = new Contact(LastName='TestContact', RecordTypeId = ctcType, NPI__c = '1263', AccountID = objAccount.ID);
		lstContact.add(objContact);
		
		list<Task> toInsertTask = new list<Task>();
		
		Task t5 = new Task(WhatID = objAccount.ID, Type = 'NPS Survey Follow-up', OwnerID = u.Id, ActivityDate = system.today());													     			  
        toInsertTask.add(t5);
		
		Task t4 = new Task(WhatID = objAccount.ID, Type = 'PDPM Contract Renewal', OwnerID = u.Id, ActivityDate = system.today());													     			  
        toInsertTask.add(t4);
        
        insert toInsertTask;
		
		string letterStart = 't';
		string letterEnd = 'u';
		list<string> ADO_Filter = new list<string>();
		list<string> RVP_Filter = new list<string>();
		list<string> DVP_Filter = new list<string>();
		
		test.startTest();
        AA_RHCReportController.getAllRHBActive(letterStart, letterEnd, ADO_Filter, RVP_Filter, DVP_Filter);
        
        AA_RHCReportController.getNPSTasks(ADO_Filter, RVP_Filter, DVP_Filter, letterStart, letterEnd);
        ADO_Filter.clear();
        RVP_Filter.clear();
        DVP_Filter.clear();
        AA_RHCReportController.getNPSTasks(ADO_Filter, RVP_Filter, DVP_Filter, letterStart, letterEnd);
        ADO_Filter.add('Test3 User3');
        RVP_Filter.add('Test2 User2');
        DVP_Filter.add('Test User');
        string reportName = 'PDPM Contract Renewal';
        AA_RHCReportController.getPDPMTasks(ADO_Filter, RVP_Filter, DVP_Filter, letterStart, letterEnd, reportName);
        AA_RHCReportController.getAllRHBActive(letterStart, letterEnd, ADO_Filter, RVP_Filter, DVP_Filter);
        AA_RHCReportController.getADOs();
        AA_RHCReportController.getRVPs();
        AA_RHCReportController.getDVPs();
        
        test.stopTest();
        }
    	}	
}