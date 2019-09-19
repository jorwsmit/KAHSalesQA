@isTest
private class AA_ReferralSourceAuditReportingTest {

    static testMethod void myUnitTest(){
        list<User> lstUserToInsert = new list<User>();
	    ID profileID = userinfo.getProfileId();
	    ID parentRole = [SELECT ID FROM UserRole WHERE Name = 'KAH - Corporate'].ID;
	    list<UserRole> lstUserRole = [SELECT Name, ID FROM UserRole WHERE ParentRoleId =: parentRole];
	    
        list<Account>lstAccount = new list<Account>();
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        List<RecordType> lstRecTypesCon = [Select Name, Id From RecordType where sObjectType='Contact' AND isActive = true];
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
		lstAccount.add(objAccount);
		
		insert lstAccount;
		
		list<Contact>lstContact = new list<Contact>();
        
        Contact objContact = new Contact(LastName='TestContact', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '1263');
		lstContact.add(objContact);
        
        insert lstContact;
        
        User objUser = new User(
									FirstName = 'testFirst',
									LastName = 'TestUser' + String.valueOf(Date.today()), 
									Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
									Username = 'TestUser_Test' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
									isActive = true,
									Alias = 'tu',
									TimeZoneSidKey = 'America/New_York',
									LocaleSidKey = 'en_US',
									EmailEncodingKey = 'ISO-8859-1', 
									LanguageLocaleKey = 'en_US',
									ProfileId =  Userinfo.getProfileId(),
									CommunityNickname = 'TestCommunity1' + String.valueOf(Date.today()) + '_', 
									Title = 'Title11',
									City = 'testCity',
									Country = 'testCountry',
									Street = 'testStreet',
									CompanyName = 'testCompanyName',
									Phone = 'testPhone',
									Extension = 'testExtension',
									PostalCode = '2345',
									Line_of_Business__c = 'HP',
									Perner__c = '88837576'
									);
	    	insert objUser;
        
        User objUser2 = new User(
	    							FirstName = 'testChump',
									LastName = 'superChump',
					                username = 'newUserDataManagement'+ String.valueOf(Date.today()) + '_' +'@yahoo.com', 
					                email = 'pb@ff.com', 
					                emailencodingkey = 'UTF-8', 
					                localesidkey = 'en_US', 
					                languagelocalekey = 'en_US', 
					                timezonesidkey = 'America/Los_Angeles', 
					                alias='nuser', 
					                ProfileId =  Userinfo.getProfileId(),
					                managerId= objUser.id,
					                Perner__c = '546437576',
					                Line_of_Business__c = 'HP' 
					                
	        ); 
	        insert objUser2;
	        
	        Referral_Source_Audit__c rsa = new Referral_Source_Audit__c(User__c = objUser.Id,
        															Account__c = objAccount.Id,
        															Status__c = 'Added');
        	Referral_Source_Audit__c rsa2 = new Referral_Source_Audit__c(User__c = objUser2.Id,
        															Contact__c = objContact.Id,
        															Status__c = 'Deleted');
        															insert rsa;
        															insert rsa2;
	        
	        
	        Account objParentAccount = new Account (Name ='Kindred Healthcare Inc');
	        insert objParentAccount;
	        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Child' Limit 1];
	        Account objAccount2 = new Account(name = 'Test Account2', Facility_Number__c = '5081', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
	 		insert objAccount2;
	 		
	 		Home_Facility__c hf = new Home_Facility__c(Account__c = objAccount2.ID, User__c = objUser2.Id);
	        insert hf;															
        															
        test.startTest();
        string selectedUser = 'superChump, testChump - HP - 546437576';
        string selectedUser2 = objUser.LastName + ', ' + objUser.FirstName + ' - HP - 88837576';
        //u.userRoleId = lstUserRole[0].ID;
        //update u;
        string userFilter = 'superChump';
        AA_ReferralSourceAuditReporting.getFirstUsersList();
        AA_ReferralSourceAuditReporting.getUsersList(userFilter);
        string accountFilter = 'a';
        string contactFilter = 'c';
        string unityFilter = 'u';
        string horizonFilter = 'h';
        string sfIDFilter = objAccount2.ID;
        AA_ReferralSourceAuditReporting.getFirstRoles();
        AA_ReferralSourceAuditReporting.getSubRoleNames('SVP - KAH');
        AA_ReferralSourceAuditReporting.getSelectedUser(selectedUser);
        AA_ReferralSourceAuditReporting.getSelectedUser(selectedUser2);
        AA_ReferralSourceAuditReporting.getReport(lstUserRole[0].Name, String.valueOf(system.today()), String.valueOf(system.today()), null, 'Account__r.Name', true, accountFilter, contactFilter, unityFilter, horizonFilter, sfIDFilter);
        AA_ReferralSourceAuditReporting.getReport(lstUserRole[0].Name, '', String.valueOf(system.today()), null, 'Account__r.Name', true, accountFilter, contactFilter, unityFilter, horizonFilter, sfIDFilter);
        AA_ReferralSourceAuditReporting.getReport(lstUserRole[0].Name, String.valueOf(system.today()), '', null, 'Account__r.Name', true, accountFilter, contactFilter, unityFilter, horizonFilter, sfIDFilter);
        AA_ReferralSourceAuditReporting.getReport(lstUserRole[0].Name, '', '', null, 'Account__r.Name', true, accountFilter, contactFilter, unityFilter, horizonFilter, sfIDFilter);
        AA_ReferralSourceAuditReporting.getReport(null, '', '', selectedUser2, 'Account__r.Name', true, accountFilter, contactFilter, unityFilter, horizonFilter, sfIDFilter);
        AA_ReferralSourceAuditReporting.getReport(null, '', '', selectedUser, 'Account__r.Name', true, accountFilter, contactFilter, unityFilter, horizonFilter, sfIDFilter);
        test.stopTest();
    	}
}