@isTest
private class AA_AssociateDataManagementControllerTest {

    static testMethod void myUnitTest(){
          User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser){
        
        AA_AssociateDataManagementController objDataManagement = new AA_AssociateDataManagementController();
        String PARENT_ROLE = 'SVP - KAH';
        UserRole objUserRole = [select id from UserRole where Name =:PARENT_ROLE Limit 1];
        UserRole objUserRole1 = [select id from UserRole where ParentRoleId =:objUserRole.Id Limit 1];
        UserRole objUserRole2 = [select id from UserRole where Name =:'HD Central Region' Limit 1];
      
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
                  UserRoleid= objUserRole.id
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
          
          RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Child' Limit 1];
          RecordType rtContact = [select id,Name from RecordType where SobjectType='Contact' and DeveloperName='General_Contact' Limit 1];
          
          list<Account> toInsertacc = new list<Account>();
          Account objParentAccount = new Account (Name ='Kindred Healthcare Inc');
          toInsertacc.add(objParentAccount);
          
          Account objAccount = new Account(name = 'Test AccountTest AccountTest Account', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       	  toInsertacc.add(objAccount);
       
       	  Account objAccount2 = new Account(name = 'Test Account2', Facility_Number__c = '5081', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       	  toInsertacc.add(objAccount2);
       	  
       	  Account objA = new Account(name = 'Unassigned Account - Admin Maintenance');
       	  toInsertacc.add(objA);
       	  
       	  Account objAccount1 = new Account(name = 'Test ,Account1,', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 33.49,Shipping_Geolocation__Latitude__s = 64.66, KAH_HH_Referrals_YTD__c = 10);
          toInsertacc.add(objAccount1);
       	  
       	  insert toInsertacc;
       	  
       	  list<Contact> toInsCtc = new list<Contact>();
       	  
       	  Contact objContact = new Contact(LastName = 'Test Contact,', FirstName ='TestCont,', recordTypeId = rtContact.Id, Geolocation__Longitude__s=86.1 ,Geolocation__Latitude__s =33.1, KAH_HH_Referrals_YTD__c = 10 );
       	  toInsCtc.add(objContact);
      
          Contact objContact1 = new Contact(LastName = 'Test Contact1,', FirstName='Contact,', recordTypeId = rtContact.Id, Geolocation__Longitude__s=86.1 ,Geolocation__Latitude__s =33.1, KAH_HH_Referrals_YTD__c = 10);
       	  toInsCtc.add(objContact1);
       
       	  Contact objContact2 = new Contact(LastName = 'Test Contact2,', FirstName='Contact2,', recordTypeId = rtContact.Id, Geolocation__Longitude__s=86.1 ,Geolocation__Latitude__s =33.1, KAH_HH_Referrals_YTD__c = 14);
       	  toInsCtc.add(objContact2);
      	  insert toInsCtc;
      	  
      	  list<Home_Facility__c> hfToInsert = new list<Home_Facility__c>();
      	  Home_Facility__c hf = new Home_Facility__c(Account__c = objAccount2.ID, User__c = objUser2.Id);
          hfToInsert.add(hf);
      	  
          Home_Facility__c objHomeFacility = new Home_Facility__c (User__c = objUser.id, Account__c = objAccount.Id);
          hfToInsert.add(objHomeFacility);
        
          Home_Facility__c objHomeFacility1 = new Home_Facility__c (User__c = UserInfo.getUserId(), Account__c = objAccount.Id);
          hfToInsert.add(objHomeFacility1);
          insert hfToInsert;
        	
          list<AccountTeamMember> atToInsert = new list<AccountTeamMember>();	
      	  AccountTeamMember objATM =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount.Id);
      	  atToInsert.add(objATM);
       
      	  AccountTeamMember objATM1 =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount1.Id);
      	  atToInsert.add(objATM1);
      	  
      	  insert atToInsert;
       	  
      	  test.startTest();   
        ID roleID = [SELECT ID, Name FROM UserRole WHERE Name = 'SA - Missouri/Southern Indiana'].ID;
        string newAcc = 'Test Account2 - 5081 - HH';
        string selectedUser = 'superChump, testChump - HP - 546437576';
        string lob = 'HP';
        string sortField = 'Name';
        string distanceFilter = 'Currently Assigned';
        string distanceFilter2 = 'All';
        string typeFilter = 'All';
        string isAsc = 'Asc';
        string location = '';
        string strSelectedUserRole = roleID;
        string reqType = 'Referral';
        string title = 'testTitle';
        string phone = '555-555-5555';
        list<string> idList = new list<string>();
        idList.add(objAccount1.Id);
            string idList2 = '';
            idList2 = objAccount1.Id;
        list<string> filters = new list<string>();
        filters.add('sourceFilter: HPAS');
      filters.add('activeFilter: Customer');
      filters.add('stateFilter: KY' ); 
      filters.add('nameFilter: Kindred Healthcare' );
      filters.add('npiFilter: 34533' );
      filters.add('hmsFilter: 35345' );
      filters.add('sfIDFilter: 345434' );
      filters.add('addressFilter: 480 S 4th St' );
      filters.add('cityFilter: Louisville');
      filters.add('stFilter: KY');
      filters.add('zipFilter: 40202');
      filters.add('specialtyFilter: Rehab');
      filters.add('hhYTDAdmitFilter: '  + 1);
      filters.add('hhPYAdmitFilter: '  + 1);
      filters.add('hpYTDAdmitFilter: '  + 1);
      filters.add('hpPYAdmitFilter: '  + 1);
      filters.add('hdYTDAdmitFilter: '  + 1);
      filters.add('hdPYAdmitFilter: '  + 1);
      filters.add('hhPPSYTDAdmitFilter: '  + 1);
      filters.add('hhPPSPYAdmitFilter: '  + 1);
      filters.add('hhYTDReferralFilter: '  + 1);
      filters.add('hhDiscQualAdmitYTDFilter: '  + 1);
      filters.add('hpQualifiedYTDAdmitFilter: '  + 1);
      filters.add('hpQualifiedPYAdmitFilter: '  + 1);
      filters.add('hpYTDReferralFilter: '  + 1);
      filters.add('hpLengthFilter: '  + 1);
        AA_AssociateDataManagementController.getLoggedInUser();
        AA_AssociateDataManagementController.getSourceList();
        AA_AssociateDataManagementController.getDistanceList();
        AA_AssociateDataManagementController.getStatusList();
        AA_AssociateDataManagementController.getStateList();
        AA_AssociateDataManagementController.getAccountList();
        AA_AssociateDataManagementController.getBusinessList();
        
        AA_AssociateDataManagementController.getTypeList();
        test.stopTest();
        }
    }
    
    static testMethod void myUnitTest2() {
        String PARENT_ROLE = 'SVP - KAH';
        UserRole objUserRole = [select id from UserRole where Name =:PARENT_ROLE Limit 1];
        UserRole objUserRole1 = [select id from UserRole where ParentRoleId =:objUserRole.Id Limit 1];
        UserRole objUserRole2 = [select id from UserRole where Name =:'HD Central Region' Limit 1];
        id kahAssocID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
      test.startTest();
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
                  ProfileId =  kahAssocID,
                  CommunityNickname = 'TestCommunity1' + String.valueOf(Date.today()) + '_', 
                  Title = 'Title11',
                  City = 'testCity',
                  Country = 'testCountry',
                  Street = 'testStreet',
                  CompanyName = 'testCompanyName',
                  Phone = 'testPhone',
                  Extension = 'testExtension',
                  PostalCode = '2345',
                  UserRoleid= objUserRole2.id
                );
        insert objUser;
        
        System.runAs(objUser){
          S2_custom_permissions__c S2 = new S2_custom_permissions__c(Name = kahAssocID);
          insert S2;
          AA_AssociateDataManagementController.getPermissions();
          
          }
        test.stopTest();
      }
      
    static testMethod void myUnitTest3() {
        User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser){
        
        AA_AssociateDataManagementController objDataManagement = new AA_AssociateDataManagementController();
        String PARENT_ROLE = 'SVP - KAH';
        UserRole objUserRole = [select id from UserRole where Name =:PARENT_ROLE Limit 1];
        UserRole objUserRole1 = [select id from UserRole where ParentRoleId =:objUserRole.Id Limit 1];
        UserRole objUserRole2 = [select id from UserRole where Name =:'HD Central Region' Limit 1];
      
      list<User> uToInsert = new list<User>();
      
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
                  UserRoleid= objUserRole.id
                );
        uToInsert.add(objUser);
        
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
          uToInsert.add(objUser2);
          
          RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Child' Limit 1];
          RecordType rtContact = [select id,Name from RecordType where SobjectType='Contact' and DeveloperName='General_Contact' Limit 1];
          
          
          list<Account> accToInsert = new list<Account>();
          Account objParentAccount = new Account (Name ='Kindred Healthcare Inc');
          accToInsert.add(objParentAccount);
          Account objAccount = new Account(name = 'Test AccountTest AccountTest Account', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
          accToInsert.add(objAccount);
          
       Account objAccount2 = new Account(name = 'Test Account2', Facility_Number__c = '5081', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       accToInsert.add(objAccount2);
       
       Account objA = new Account(name = 'Unassigned Account - Admin Maintenance');
       accToInsert.add(objA);
       
       
       Account objAccount1 = new Account(name = 'Test ,Account1,', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 33.49,Shipping_Geolocation__Latitude__s = 64.66, KAH_HH_Referrals_YTD__c = 10);
       accToInsert.add(objAccount1);
       
       insert accToInsert;
       
       list<AccountTeamMember> atmInsert = new list<AccountTeamMember>();
       AccountTeamMember objATM =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount.Id);
       atmInsert.add(objATM);
       
      AccountTeamMember objATM1 =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount1.Id);
      atmInsert.add(objATM1);
        ID roleID = [SELECT ID, Name FROM UserRole WHERE Name = 'SA - Missouri/Southern Indiana'].ID;
       insert atmInsert;
       
       test.startTest();
       
      
        string newAcc = 'Test Account2 - 5081 - HH - ' + objAccount2.ID;
        string selectedUser = 'superChump, testChump - HP - 546437576';
        string lob = 'HP';
        string sortField = 'Name';
        string distanceFilter = 'Currently Assigned';
        string distanceFilter2 = 'All';
        string typeFilter = 'All';
        string isAsc = 'Asc';
        string location = '';
        string strSelectedUserRole = roleID;
        string reqType = 'Referral';
        string title = 'testTitle';
        string phone = '555-555-5555';
        list<string> idList = new list <string>();
        
        list<string> filters = new list<string>();
        filters.add('sourceFilter: HPAS');
      	filters.add('activeFilter: Customer');
      filters.add('stateFilter: KY' ); 
      filters.add('nameFilter: Kindred Healthcare' );
      filters.add('npiFilter: 34533' );
      filters.add('sfIDFilter: 345434' );
      filters.add('addressFilter: 480 S 4th St' );
      filters.add('cityFilter: Louisville');
      filters.add('stFilter: KY');
      filters.add('zipFilter: 40202');
      filters.add('specialtyFilter: Rehab');
      filters.add('hhYTDAdmitFilter: '  + 1);
      filters.add('hhPYAdmitFilter: '  + 1);
      filters.add('hpYTDAdmitFilter: '  + 1);
      filters.add('hpPYAdmitFilter: '  + 1);
      filters.add('hdYTDAdmitFilter: '  + 1);
      filters.add('hdPYAdmitFilter: '  + 1);
      filters.add('hhPPSYTDAdmitFilter: '  + 1);
      filters.add('hhPPSPYAdmitFilter: '  + 1);
      filters.add('hhYTDReferralFilter: '  + 1);
      filters.add('hhDiscQualAdmitYTDFilter: '  + 1);
      filters.add('hpQualifiedYTDAdmitFilter: '  + 1);
      filters.add('hpQualifiedPYAdmitFilter: '  + 1);
      filters.add('hpYTDReferralFilter: '  + 1);
      filters.add('hpLengthFilter: '  + 1);
        idList.add(objAccount1.Id);
        idList.add(objAccount2.Id);
        
        AA_AssociateDataManagementController.removeAllUserAssignments(objUser);
        AA_AssociateDataManagementController.getUpdatedInfo(objUser, newAcc, lob, title, phone);
        AA_AssociateDataManagementController.getSelectedUser(selectedUser, true);
        test.stopTest();
        }
      }      
    
    static testMethod void myUnitTest4(){
          User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser){
        
        AA_AssociateDataManagementController objDataManagement = new AA_AssociateDataManagementController();
        String PARENT_ROLE = 'SVP - KAH';
        UserRole objUserRole = [select id from UserRole where Name =:PARENT_ROLE Limit 1];
        UserRole objUserRole1 = [select id from UserRole where ParentRoleId =:objUserRole.Id Limit 1];
        UserRole objUserRole2 = [select id from UserRole where Name =:'HD Central Region' Limit 1];
      
      list<User> uInsert = new list<User>();
      
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
                  UserRoleid= objUserRole.id
                );
        uInsert.add(objUser);
        
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
          uInsert.add(objUser2);
          
          RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Child' Limit 1];
          RecordType rtContact = [select id,Name from RecordType where SobjectType='Contact' and DeveloperName='General_Contact' Limit 1];
          
          insert uInsert;
          
          list<Account> aInsert = new list<Account>();
          
          Account objParentAccount = new Account (Name ='Kindred Healthcare Inc');
          aInsert.add(objParentAccount);
          
          Account objAccount = new Account(name = 'Test AccountTest AccountTest Account', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       aInsert.add(objAccount);
       
       
       Account objAccount2 = new Account(name = 'Test Account2', Facility_Number__c = '5081', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       aInsert.add(objAccount2);
       
       Account objA = new Account(name = 'Unassigned Account - Admin Maintenance');
       aInsert.add(objA);
       
       Account objAccount1 = new Account(name = 'Test ,Account1,', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 33.49,Shipping_Geolocation__Latitude__s = 64.66, KAH_HH_Referrals_YTD__c = 10);
       aInsert.add(objAccount1);
       insert aInsert;
       
       
       List<Home_Facility__c> hfInsert = new list<Home_Facility__c>();
       
       Home_Facility__c hf = new Home_Facility__c(Account__c = objAccount2.ID, User__c = objUser2.Id);
          hfInsert.add(hf);
       
       Contact objContact = new Contact(LastName = 'Test Contact,', FirstName ='TestCont,', recordTypeId = rtContact.Id, Geolocation__Longitude__s=86.1 ,Geolocation__Latitude__s =33.1, KAH_HH_Referrals_YTD__c = 10 );
       insert objContact;
       
       Contact_Team__c objContactTeamMember1 = new Contact_Team__c(Contact__c = objContact.Id, User__c = objUser.Id);
	    insert objContactTeamMember1;
       
        Home_Facility__c objHomeFacility = new Home_Facility__c (User__c = objUser.id, Account__c = objAccount.Id);
        hfInsert.add(objHomeFacility);
        
        Home_Facility__c objHomeFacility1 = new Home_Facility__c (User__c = UserInfo.getUserId(), Account__c = objAccount.Id);
        hfInsert.add(objHomeFacility1);
        insert hfInsert;
        
        list<AccountTeamMember> atInsert = new list<AccountTeamMember>();
        AccountTeamMember objATM =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount.Id);
	    atInsert.add(objATM);
       
      	AccountTeamMember objATM1 =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount1.Id);
      	atInsert.add(objATM1);
        insert atInsert;
        
        test.startTest();
        
        ID roleID = [SELECT ID, Name FROM UserRole WHERE Name = 'SA - Missouri/Southern Indiana'].ID;
        string newAcc = 'Test Account2 - 5081 - HH';
        string selectedUser = 'superChump, testChump - HP - 546437576';
        string lob = 'HP';
        string sortField = 'Name';
        string distanceFilter = 'Currently Assigned';
        string distanceFilter2 = 'All';
        string typeFilter = 'All';
        string isAsc = 'Asc';
        string location = '';
        string strSelectedUserRole = roleID;
        string reqType = 'Referral';
        string title = 'testTitle';
        string phone = '555-555-5555';
        list<string> idList = new list<string>();
        idList.add(objAccount1.Id);
            string idList2 = '';
            idList2 = objAccount1.Id;
        list<string> filters = new list<string>();
        filters.add('sourceFilter: HPAS');
      filters.add('activeFilter: Customer');
      filters.add('stateFilter: KY' ); 
      filters.add('nameFilter: Kindred Healthcare' );
      filters.add('npiFilter: 34533' );
      filters.add('hmsFilter: 35345' );
      filters.add('sfIDFilter: 345434' );
      filters.add('addressFilter: 480 S 4th St' );
      filters.add('cityFilter: Louisville');
      filters.add('stFilter: KY');
      filters.add('zipFilter: 40202');
      filters.add('specialtyFilter: Rehab');
      filters.add('hhYTDAdmitFilter: '  + 1);
      filters.add('hhPYAdmitFilter: '  + 1);
      filters.add('hpYTDAdmitFilter: '  + 1);
      filters.add('hpPYAdmitFilter: '  + 1);
      filters.add('hdYTDAdmitFilter: '  + 1);
      filters.add('hdPYAdmitFilter: '  + 1);
      filters.add('hhPPSYTDAdmitFilter: '  + 1);
      filters.add('hhPPSPYAdmitFilter: '  + 1);
      filters.add('hhYTDReferralFilter: '  + 1);
      filters.add('hhDiscQualAdmitYTDFilter: '  + 1);
      filters.add('hpQualifiedYTDAdmitFilter: '  + 1);
      filters.add('hpQualifiedPYAdmitFilter: '  + 1);
      filters.add('hpYTDReferralFilter: '  + 1);
      filters.add('hpLengthFilter: '  + 1);
        
        
        AA_AssociateDataManagementController.getUsersList();
        AA_AssociateDataManagementController.getUsersList2();
        string filter = 'Chump';
        AA_AssociateDataManagementController.filterUserList(filter);
        AA_AssociateDataManagementController.filterUserList2(filter);
        AA_AssociateDataManagementController.getTeamAssigned(objAccount.ID);
        AA_AssociateDataManagementController.getUpdatedInfo(objUser, newAcc, lob, title, phone);
        AA_AssociateDataManagementController.getSelectedUser(selectedUser, true);
        AA_AssociateDataManagementController.getReferralSourceCount(objUser);
        AA_AssociateDataManagementController.getReferralList(objUser, filters, sortField, distanceFilter, typefilter, isAsc, location, reqType);
        filters.clear();
        
        AA_AssociateDataManagementController.getReferralList(thisUser, filters, sortField, distanceFilter2, typefilter, isAsc, location, reqType);
        test.stopTest();
        }
    }
    
    static testMethod void myUnitTest5(){
    	  User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser){
        
        AA_AssociateDataManagementController objDataManagement = new AA_AssociateDataManagementController();
        String PARENT_ROLE = 'SVP - KAH';
        UserRole objUserRole = [select id from UserRole where Name =:PARENT_ROLE Limit 1];
        UserRole objUserRole1 = [select id from UserRole where ParentRoleId =:objUserRole.Id Limit 1];
        UserRole objUserRole2 = [select id from UserRole where Name =:'HD Central Region' Limit 1];
      
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
                  UserRoleid= objUserRole.id
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
          
          RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Child' Limit 1];
          RecordType rtContact = [select id,Name from RecordType where SobjectType='Contact' and DeveloperName='General_Contact' Limit 1];
          
          list<Account> toInsert = new list<Account>();
          list<Home_Facility__c> toHFInsert = new list<Home_Facility__c>();
          list<AccountTeamMember> atmInsert = new list<AccountTeamMember>();
          Account objParentAccount = new Account (Name ='Kindred Healthcare Inc');
       	  Account objAccount = new Account(name = 'Test AccountTest AccountTest Account', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       	  Account objAccount2 = new Account(name = 'Test Account2', Facility_Number__c = '5081', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);	
       	  Account objA = new Account(name = 'Unassigned Account - Admin Maintenance');
       	  Account objAccount1 = new Account(name = 'Test ,Account1,', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 33.49,Shipping_Geolocation__Latitude__s = 64.66, KAH_HH_Referrals_YTD__c = 10);
       	  	Home_Facility__c objHomeFacility = new Home_Facility__c (User__c = objUser.id, Account__c = objAccount.Id);
        	toHFInsert.add(objHomeFacility);
        
        	Home_Facility__c objHomeFacility1 = new Home_Facility__c (User__c = UserInfo.getUserId(), Account__c = objAccount.Id);
        	toHFInsert.add(objHomeFacility1);
       	  	Home_Facility__c hf = new Home_Facility__c(Account__c = objAccount2.ID, User__c = objUser2.Id);
          	toHFInsert.add(hf);
       	  
       	  AccountTeamMember objATM =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount.Id);
      	  atmInsert.add(objATM);
       
      		AccountTeamMember objATM1 =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount1.Id);
      		atmInsert.add(objATM1);
       	  
       	  toInsert.add(objParentAccount);
       	  toInsert.add(objAccount);
       	  toInsert.add(objAccount2);
       	  toInsert.add(objAccount1);
       	  toInsert.add(objA);
       	  
       	  insert toInsert;
       	  insert toHFInsert;
       	  //insert atmInsert;
       	  Contact objContact = new Contact(LastName = 'Test Contact,', FirstName ='TestCont,', recordTypeId = rtContact.Id, Geolocation__Longitude__s=86.1 ,Geolocation__Latitude__s =33.1, KAH_HH_Referrals_YTD__c = 10 );
       		insert objContact;
        ID roleID = [SELECT ID, Name FROM UserRole WHERE Name = 'SA - Missouri/Southern Indiana'].ID;
       	  test.startTest();
            string newAcc = 'Test Account2 - 5081 - HH';
        string selectedUser = 'superChump, testChump - HP - 546437576';
        string lob = 'HP';
        string sortField = 'Name';
        string distanceFilter = 'Currently Assigned';
        string distanceFilter2 = 'All';
        string typeFilter = 'All';
        string isAsc = 'Asc';
        string location = '';
        string strSelectedUserRole = roleID;
        string reqType = 'Referral';
        string title = 'testTitle';
        string phone = '555-555-5555';
        list<string> idList = new list<string>();
        idList.add(objAccount1.Id);
            string idList2 = '';
            idList2 = objAccount1.Id;
        list<string> filters = new list<string>();
        filters.add('sourceFilter: HPAS');
      filters.add('activeFilter: Customer');
      filters.add('stateFilter: KY' ); 
      filters.add('nameFilter: Kindred Healthcare' );
      filters.add('npiFilter: 34533' );
      filters.add('hmsFilter: 35345' );
      filters.add('sfIDFilter: 345434' );
      filters.add('addressFilter: 480 S 4th St' );
      filters.add('cityFilter: Louisville');
      filters.add('stFilter: KY');
      filters.add('zipFilter: 40202');
      filters.add('specialtyFilter: Rehab');
      filters.add('hhYTDAdmitFilter: '  + 1);
      filters.add('hhPYAdmitFilter: '  + 1);
      filters.add('hpYTDAdmitFilter: '  + 1);
      filters.add('hpPYAdmitFilter: '  + 1);
      filters.add('hdYTDAdmitFilter: '  + 1);
      filters.add('hdPYAdmitFilter: '  + 1);
      filters.add('hhPPSYTDAdmitFilter: '  + 1);
      filters.add('hhPPSPYAdmitFilter: '  + 1);
      filters.add('hhYTDReferralFilter: '  + 1);
      filters.add('hhDiscQualAdmitYTDFilter: '  + 1);
      filters.add('hpQualifiedYTDAdmitFilter: '  + 1);
      filters.add('hpQualifiedPYAdmitFilter: '  + 1);
      filters.add('hpYTDReferralFilter: '  + 1);
      filters.add('hpLengthFilter: '  + 1);
      
    	AA_AssociateDataManagementController.fetchParentRoles(selectedUser, strSelectedUserRole);
        AA_AssociateDataManagementController.fetchNewRoles(selectedUser, 'SVP - KAH');
        AA_AssociateDataManagementController.setNewRole('SVP - KAH', objUser);
        AA_AssociateDataManagementController.getProcessAssignReferralSources(objUser, idList2);
        AA_AssociateDataManagementController.getProcessAssignReferralSources(objUser, idList2);
        AA_AssociateDataManagementController.getProcessReassignReferralSources(objUser, objUser2, idList);
      test.stopTest();  
    	}
    }
 
 	static testMethod void myUnitTest6(){
 		User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser){
        
        AA_AssociateDataManagementController objDataManagement = new AA_AssociateDataManagementController();
        String PARENT_ROLE = 'SVP - KAH';
        UserRole objUserRole = [select id from UserRole where Name =:PARENT_ROLE Limit 1];
        UserRole objUserRole1 = [select id from UserRole where ParentRoleId =:objUserRole.Id Limit 1];
        UserRole objUserRole2 = [select id from UserRole where Name =:'HD Central Region' Limit 1];
      
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
                  UserRoleid= objUserRole.id
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
          
          RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Child' Limit 1];
          RecordType rtContact = [select id,Name from RecordType where SobjectType='Contact' and DeveloperName='General_Contact' Limit 1];
          
          list<Account> aInsert = new list<Account>();
          
          Account objParentAccount = new Account (Name ='Kindred Healthcare Inc');
          aInsert.add(objParentAccount);
          
          Account objAccount = new Account(name = 'Test AccountTest AccountTest Account', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       
       aInsert.add(objAccount);
       
       Account objAccount2 = new Account(name = 'Test Account2', Facility_Number__c = '5081', Status__c ='Active', parentId = objParentAccount.id, shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       aInsert.add(objAccount2);
       
       Account objA = new Account(name = 'Unassigned Account - Admin Maintenance');
       aInsert.add(objA);
       
       Account objAccount1 = new Account(name = 'Test ,Account1,', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 33.49,Shipping_Geolocation__Latitude__s = 64.66, KAH_HH_Referrals_YTD__c = 10);
       aInsert.add(objAccount1);
       insert aInsert;
      
      list<AccountTeamMember> atInsert = new list<AccountTeamMember>(); 
      AccountTeamMember objATM =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount.Id);
      atInsert.add(objATM);
       
      AccountTeamMember objATM1 =  new  AccountTeamMember(UserId =UserInfo.getUserId(), TeamMemberRole='Clinical Liason', AccountId =objAccount1.Id);
      atInsert.add(objATM1);
      
      insert atInsert;
      
      test.startTest();
       ID roleID = [SELECT ID, Name FROM UserRole WHERE Name = 'SA - Missouri/Southern Indiana'].ID;
        string newAcc = 'Test Account2 - 5081 - HH';
        string selectedUser = 'superChump, testChump - HP - 546437576';
        string lob = 'HP';
        string sortField = 'Name';
        string distanceFilter = 'Currently Assigned';
        string distanceFilter2 = 'All';
        string typeFilter = 'All';
        string isAsc = 'Asc';
        string location = '';
        string strSelectedUserRole = roleID;
        string reqType = 'Referral';
        string title = 'testTitle';
        string phone = '555-555-5555';
        string facilityListFilter = 'Kindred';
        string nameListFilter = 'chump';
        string nameListFilter2 = ' testChump';
        list<string> idList = new list <string>();
        idList.add(objAccount1.Id);
        idList.add(objAccount2.Id);
        list<string> filters = new list<string>();
        test.stopTest();
 		AA_AssociateDataManagementController.getLoggedInUser();
        AA_AssociateDataManagementController.getSourceList();
        AA_AssociateDataManagementController.getDistanceList();
        AA_AssociateDataManagementController.getStatusList();
        AA_AssociateDataManagementController.getStateList();
        AA_AssociateDataManagementController.getAccountList();
        AA_AssociateDataManagementController.getBusinessList();
        AA_AssociateDataManagementController.getTypeList();
        AA_AssociateDataManagementController.getUsersList();
        AA_AssociateDataManagementController.getUsersList2();
        AA_AssociateDataManagementController.getTeamAssigned(objAccount.ID);
        }
 	}
 
 	static testMethod void myUnitTest7(){
 		id centerType = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND developerName = 'Center'].ID;
 		Account a = new Account(Name = 'TestAccount', RecordTypeID = centerType);
 		insert a;
 		string facilityListFilter = 'TestAccount';
 		AA_AssociateDataManagementController.filterAccountList(facilityListFilter);
 		}   
    
}