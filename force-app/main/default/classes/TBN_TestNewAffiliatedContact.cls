@isTest
private class TBN_TestNewAffiliatedContact {

	private static testMethod void TBN_TestNewAffiliatedContact() {
	    
	 // to hold the name of new pratice account   
	 String strAcctNameString = '';
	 
     List<User> lstUsersToInsert = new List<User>{ new User( FirstName = 'testFirst',
                            								 LastName = 'TestUser' + String.valueOf(Date.today()), 
                            								 Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                            								 Username = 'TestUserPracticeAccount' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                            							 	 isActive = true,
                            								 Alias = 'tpa',
                            								 TimeZoneSidKey = 'America/New_York',
                            								 LocaleSidKey = 'en_US',
                            								 EmailEncodingKey = 'ISO-8859-1', 
                            								 LanguageLocaleKey = 'en_US',
                            								 ProfileId =  Userinfo.getProfileId(),
                            								 CommunityNickname = 'Test_PracticeAccountCommunity' + String.valueOf(Date.today()) + '_', 
                            								 Title = 'Title11',
                            								 City = 'testCity',
                            								 Country = 'testCountry',
                            								 Street = 'testStreet',
                            								 CompanyName = 'testCompanyName',
                            								 Phone = 'testPhone',
                            								 Extension = 'testExtension',
                            								 PostalCode = '2345'),
                        								 
                                                new User(   FirstName = 'testFirst1',
                            								LastName = 'TestUser' + String.valueOf(Date.today()), 
                            								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                            								Username = 'TestUser_PracticeAcount' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                            								isActive = true,
                            								Alias = 't_pa',
                            								TimeZoneSidKey = 'America/New_York',
                            								LocaleSidKey = 'en_US',
                            								EmailEncodingKey = 'ISO-8859-1', 
                            								LanguageLocaleKey = 'en_US',
                            								ProfileId =  Userinfo.getProfileId(),
                            								CommunityNickname = 'TestPracticeAccountCommunity' + String.valueOf(Date.today()) + '_', 
                            								Title = 'Title11',
                            								City = 'testCity',
                            								Country = 'testCountry',
                            								Street = 'testStreet',
                            								CompanyName = 'testCompanyName',
                            								Phone = 'testPhone',
                            								Extension = 'testExtension',
                            								PostalCode = '2345'
                            							    ),
                                                new User(   FirstName = 'testFirst1',
                            								LastName = 'TestUser' + String.valueOf(Date.today()), 
                            								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                            								Username = 'PracticeAcount_TestUser' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                            								isActive = true,
                            								Alias = 't_pa',
                            								TimeZoneSidKey = 'America/New_York',
                            								LocaleSidKey = 'en_US',
                            								EmailEncodingKey = 'ISO-8859-1', 
                            								LanguageLocaleKey = 'en_US',
                            								ProfileId =  Userinfo.getProfileId(),
                            								CommunityNickname = 'TestCommunity_PracticeAccount' + String.valueOf(Date.today()) + '_', 
                            								Title = 'Title11',
                            								City = 'testCity',
                            								Country = 'testCountry',
                            								Street = 'testStreet',
                            								CompanyName = 'testCompanyName',
                            								Phone = 'testPhone',
                            								Extension = 'testExtension',
                            								PostalCode = '2345'
                            							    )};
	    
    	insert lstUsersToInsert;
    	
    	// adding value to custom setting
    	List<Email_Notification_On_Merge__c> lstCSToInsert = new List<Email_Notification_On_Merge__c>{ new Email_Notification_On_Merge__c( Name = lstUsersToInsert[0].Id,
    	                                                                                                                                   User_Name__c = lstUsersToInsert[0].Id,
    	                                                                                                                                   Send_Emails__c = true,
    	                                                                                                                                   Notify_Members__c = false,
    	                                                                                                                                   Is_Practice_Account_Owner__c = false),
    	                                                                                               new Email_Notification_On_Merge__c( Name = lstUsersToInsert[1].Id,
    	                                                                                                                                   User_Name__c = lstUsersToInsert[1].Id,
    	                                                                                                                                   Send_Emails__c = false,
    	                                                                                                                                   Notify_Members__c = true,
    	                                                                                                                                   Is_Practice_Account_Owner__c = true) };
    	                                                                                                                                   
    	insert lstCSToInsert;
    	
    	
    	List<Account> lstAccountsToInsert = new List<Account>{ new Account( Name = 'Test Account1', 
    	                                                                    Is_Practice_Account__c = true,  
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 100',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'NY',
                                                                            ShippingPostalCode = '555',
                                                                            ShippingCountry = 'USA'
    	                                                                    ),
    	                                                       new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[1].Id,
    	                                                                    ShippingStreet = 'test 101',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'LA',
                                                                            ShippingPostalCode = '666',
                                                                            ShippingCountry = 'USA' ),
    	                                                       new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 102',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'CO',
                                                                            ShippingPostalCode = '777',
                                                                            ShippingCountry = 'USA'),
                                                               new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 100',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'NY',
                                                                            ShippingPostalCode = '555',
                                                                            ShippingCountry = 'USA'),
                                                               new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 101',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'LA',
                                                                            ShippingPostalCode = '666',
                                                                            ShippingCountry = 'USA')};
	  
	    insert lstAccountsToInsert;
	    
	    
	    List<Contact> lstContactsToInsert = new List<Contact>{  new Contact( LastName = 'Test Contact1',
	                                                                         OwnerId = lstUsersToInsert[0].Id,
	                                                                         AccountId = lstAccountsToInsert[0].Id,
	                                                                         Title = 'Test Title1',
	                                                                         MailingStreet = 'test 100',
	                                                                         MailingCity = 'tcity',
	                                                                         MailingState = 'NY',
	                                                                         MailingPostalCode = '555',
	                                                                         MailingCountry = 'USA'
	                                                                         ),
	                                                            new Contact( LastName = 'Test Contact2',
	                                                                         OwnerId = lstUsersToInsert[1].Id,
	                                                                         AccountId = lstAccountsToInsert[1].Id,
	                                                                         Title = 'Test Title2',
	                                                                         MailingStreet = 'test 101',
	                                                                         MailingCity = 'tcity',
	                                                                         MailingState = 'LA',
	                                                                         MailingPostalCode = '666',
	                                                                         MailingCountry = 'USA'),
	                                                           new Contact( LastName = 'Test Contact3',
	                                                                         OwnerId = lstUsersToInsert[2].Id,
	                                                                         AccountId = lstAccountsToInsert[2].Id,
	                                                                         Title = 'Test Title3',
	                                                                         MailingStreet = 'test 102',
	                                                                         MailingCity = 'tcity',
	                                                                         MailingState = 'CO',
	                                                                         MailingPostalCode = '777',
	                                                                         MailingCountry = 'USA')};
	                                                                         
	    insert lstContactsToInsert;
	    
	    
	    List<Contact_Team__c> lstContactTeamsToInsert = new List<Contact_Team__c>{ new Contact_Team__c( User__c = lstUsersToInsert[0].Id,
	                                                                                                    Contact__c = lstContactsToInsert[0].Id),
	                                                                               new Contact_Team__c( User__c = lstUsersToInsert[0].Id,
	                                                                                                    Contact__c = lstContactsToInsert[1].Id),
	                                                                               new Contact_Team__c( User__c = lstUsersToInsert[2].Id,
	                                                                                                    Contact__c = lstContactsToInsert[2].Id)
	        
	    };
	    
	    insert lstContactTeamsToInsert;
	    
	    
	    
	    
	        // Contact's Account is Practice Account   
	        apexpages.currentPage().getParameters().put('id', lstContactsToInsert[0].Id);
	        
	        TBN_NewAffiliatedContactController objNACC1 = new TBN_NewAffiliatedContactController();
	        
	        objNACC1.objNewContact.LastName = 'TestContact';
	        objNACC1.createPracticeAccount();
	        Test.startTest();
	        system.assertEquals(lstAccountsToInsert[0].Id, [Select AccountId From Contact where LastName = : 'TestContact'].AccountId);
	        
	        // Contact's Account is not a Practice Account and Account's owner is  Unassigned user
	        apexpages.currentPage().getParameters().put('id', lstContactsToInsert[1].Id);
	        
            strAcctNameString = 'Practice of ';
            strAcctNameString += lstContactsToInsert[1].FirstName == null?'':lstContactsToInsert[1].FirstName+'';
            strAcctNameString += lstContactsToInsert[1].LastName;
	        
	        TBN_NewAffiliatedContactController objNACC2 = new TBN_NewAffiliatedContactController();
	        
	        objNACC2.strSelectedAccount = 'New Account';
	        objNACC2.objNewContact.LastName = 'TestContact';
	        objNACC2.accountCreated = false;
        	objNACC2.createPracticeAccount();
	        //system.assertEquals(lstUsersToInsert[1].Id, [Select Id, OwnerId From Account where Name = : strAcctNameString].OwnerId);
	        
	        // Contact's Account is not a Practice Account and Account's owner is not Unassigned user
	        apexpages.currentPage().getParameters().put('id', lstContactsToInsert[2].Id);
	        
	        TBN_NewAffiliatedContactController objNACC3 = new TBN_NewAffiliatedContactController();
	        objNACC2.strSelectedAccount = lstAccountsToInsert[3].Id;
	        objNACC3.objNewContact.LastName = 'TestContact';
	        objNACC3.createPracticeAccount();
	        
	        TBN_NewAffiliatedContactController objNACC4 = new TBN_NewAffiliatedContactController();
	        objNACC4.strSelectedAccount = lstAccountsToInsert[3].Id;
	        objNACC4.objNewContact.LastName = 'TestContact';
	        objNACC4.createContactOnly();
	        
	    Test.stopTest();
		}
		
	private static testMethod void TBN_TestNewAffiliatedContact2() {
	    
	 // to hold the name of new pratice account   
	 String strAcctNameString = '';
	 
     List<User> lstUsersToInsert = new List<User>{ new User( FirstName = 'testFirst',
                            								 LastName = 'TestUser' + String.valueOf(Date.today()), 
                            								 Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                            								 Username = 'TestUserPracticeAccount' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                            							 	 isActive = true,
                            								 Alias = 'tpa',
                            								 TimeZoneSidKey = 'America/New_York',
                            								 LocaleSidKey = 'en_US',
                            								 EmailEncodingKey = 'ISO-8859-1', 
                            								 LanguageLocaleKey = 'en_US',
                            								 ProfileId =  Userinfo.getProfileId(),
                            								 CommunityNickname = 'Test_PracticeAccountCommunity' + String.valueOf(Date.today()) + '_', 
                            								 Title = 'Title11',
                            								 City = 'testCity',
                            								 Country = 'testCountry',
                            								 Street = 'testStreet',
                            								 CompanyName = 'testCompanyName',
                            								 Phone = 'testPhone',
                            								 Extension = 'testExtension',
                            								 PostalCode = '2345'),
                        								 
                                                new User(   FirstName = 'testFirst1',
                            								LastName = 'TestUser' + String.valueOf(Date.today()), 
                            								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                            								Username = 'TestUser_PracticeAcount' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                            								isActive = true,
                            								Alias = 't_pa',
                            								TimeZoneSidKey = 'America/New_York',
                            								LocaleSidKey = 'en_US',
                            								EmailEncodingKey = 'ISO-8859-1', 
                            								LanguageLocaleKey = 'en_US',
                            								ProfileId =  Userinfo.getProfileId(),
                            								CommunityNickname = 'TestPracticeAccountCommunity' + String.valueOf(Date.today()) + '_', 
                            								Title = 'Title11',
                            								City = 'testCity',
                            								Country = 'testCountry',
                            								Street = 'testStreet',
                            								CompanyName = 'testCompanyName',
                            								Phone = 'testPhone',
                            								Extension = 'testExtension',
                            								PostalCode = '2345'
                            							    ),
                                                new User(   FirstName = 'testFirst1',
                            								LastName = 'TestUser' + String.valueOf(Date.today()), 
                            								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                            								Username = 'PracticeAcount_TestUser' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                            								isActive = true,
                            								Alias = 't_pa',
                            								TimeZoneSidKey = 'America/New_York',
                            								LocaleSidKey = 'en_US',
                            								EmailEncodingKey = 'ISO-8859-1', 
                            								LanguageLocaleKey = 'en_US',
                            								ProfileId =  Userinfo.getProfileId(),
                            								CommunityNickname = 'TestCommunity_PracticeAccount' + String.valueOf(Date.today()) + '_', 
                            								Title = 'Title11',
                            								City = 'testCity',
                            								Country = 'testCountry',
                            								Street = 'testStreet',
                            								CompanyName = 'testCompanyName',
                            								Phone = 'testPhone',
                            								Extension = 'testExtension',
                            								PostalCode = '2345'
                            							    )};
	    
    	insert lstUsersToInsert;
    	
    	// adding value to custom setting
    	List<Email_Notification_On_Merge__c> lstCSToInsert = new List<Email_Notification_On_Merge__c>{ new Email_Notification_On_Merge__c( Name = lstUsersToInsert[0].Id,
    	                                                                                                                                   User_Name__c = lstUsersToInsert[0].Id,
    	                                                                                                                                   Send_Emails__c = true,
    	                                                                                                                                   Notify_Members__c = false,
    	                                                                                                                                   Is_Practice_Account_Owner__c = false),
    	                                                                                               new Email_Notification_On_Merge__c( Name = lstUsersToInsert[1].Id,
    	                                                                                                                                   User_Name__c = lstUsersToInsert[1].Id,
    	                                                                                                                                   Send_Emails__c = false,
    	                                                                                                                                   Notify_Members__c = true,
    	                                                                                                                                   Is_Practice_Account_Owner__c = true) };
    	                                                                                                                                   
    	insert lstCSToInsert;
    	
    	
    	List<Account> lstAccountsToInsert = new List<Account>{ new Account( Name = 'Test Account1', 
    	                                                                    Is_Practice_Account__c = true,  
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 100',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'NY',
                                                                            ShippingPostalCode = '555',
                                                                            ShippingCountry = 'USA'
    	                                                                    ),
    	                                                       new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[1].Id,
    	                                                                    ShippingStreet = 'test 101',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'LA',
                                                                            ShippingPostalCode = '666',
                                                                            ShippingCountry = 'USA' ),
    	                                                       new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 102',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'CO',
                                                                            ShippingPostalCode = '777',
                                                                            ShippingCountry = 'USA'),
                                                               new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 100',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'NY',
                                                                            ShippingPostalCode = '555',
                                                                            ShippingCountry = 'USA'),
                                                               new Account( Name = 'Test Account2', 
    	                                                                    Is_Practice_Account__c = false, 
    	                                                                    OwnerId = lstUsersToInsert[0].Id,
    	                                                                    ShippingStreet = 'test 101',
                                                                            ShippingCity = 'tcity',
                                                                            ShippingState = 'LA',
                                                                            ShippingPostalCode = '666',
                                                                            ShippingCountry = 'USA')};
	  
	    insert lstAccountsToInsert;
	    
	    
	    List<Contact> lstContactsToInsert = new List<Contact>{  new Contact( LastName = 'Test Contact1',
	                                                                         OwnerId = lstUsersToInsert[0].Id,
	                                                                         AccountId = lstAccountsToInsert[0].Id,
	                                                                         Title = 'Test Title1',
	                                                                         MailingStreet = 'test 100',
	                                                                         MailingCity = 'tcity',
	                                                                         MailingState = 'NY',
	                                                                         MailingPostalCode = '555',
	                                                                         MailingCountry = 'USA'
	                                                                         ),
	                                                            new Contact( LastName = 'Test Contact2',
	                                                                         OwnerId = lstUsersToInsert[1].Id,
	                                                                         AccountId = lstAccountsToInsert[1].Id,
	                                                                         Title = 'Test Title2',
	                                                                         MailingStreet = 'test 101',
	                                                                         MailingCity = 'tcity',
	                                                                         MailingState = 'LA',
	                                                                         MailingPostalCode = '666',
	                                                                         MailingCountry = 'USA'),
	                                                           new Contact( LastName = 'Test Contact3',
	                                                                         OwnerId = lstUsersToInsert[2].Id,
	                                                                         AccountId = lstAccountsToInsert[2].Id,
	                                                                         Title = 'Test Title3',
	                                                                         MailingStreet = 'test 102',
	                                                                         MailingCity = 'tcity',
	                                                                         MailingState = 'CO',
	                                                                         MailingPostalCode = '777',
	                                                                         MailingCountry = 'USA')};
	                                                                         
	    insert lstContactsToInsert;
	    
	    
	    List<Contact_Team__c> lstContactTeamsToInsert = new List<Contact_Team__c>{ new Contact_Team__c( User__c = lstUsersToInsert[0].Id,
	                                                                                                    Contact__c = lstContactsToInsert[0].Id),
	                                                                               new Contact_Team__c( User__c = lstUsersToInsert[0].Id,
	                                                                                                    Contact__c = lstContactsToInsert[1].Id),
	                                                                               new Contact_Team__c( User__c = lstUsersToInsert[2].Id,
	                                                                                                    Contact__c = lstContactsToInsert[2].Id)
	        
	    };
	    
	    insert lstContactTeamsToInsert;
	    
	    
	    Test.startTest();
	    
	        // Contact's Account is Practice Account   
	        apexpages.currentPage().getParameters().put('id', lstContactsToInsert[0].Id);
	        
	        TBN_NewAffiliatedContactController objNACC1 = new TBN_NewAffiliatedContactController();
	        
	        objNACC1.objNewContact.LastName = 'TestContact';
	        objNACC1.createPracticeAccountWithout();
	        // Contact's Account is not a Practice Account and Account's owner is  Unassigned user
	        apexpages.currentPage().getParameters().put('id', lstContactsToInsert[1].Id);
	        
            strAcctNameString = 'Practice of ';
            strAcctNameString += lstContactsToInsert[1].FirstName == null?'':lstContactsToInsert[1].FirstName+'';
            strAcctNameString += lstContactsToInsert[1].LastName;
	        
	        TBN_NewAffiliatedContactController objNACC2 = new TBN_NewAffiliatedContactController();
	        
	        objNACC2.strSelectedAccount = 'New Account';
	        objNACC2.objNewContact.LastName = 'TestContact';
	        objNACC2.createPracticeAccountAlt();
	        //system.assertEquals(lstUsersToInsert[1].Id, [Select Id, OwnerId From Account where Name = : strAcctNameString].OwnerId);
	        
	        // Contact's Account is not a Practice Account and Account's owner is not Unassigned user
	        apexpages.currentPage().getParameters().put('id', lstContactsToInsert[2].Id);
	        
	        TBN_NewAffiliatedContactController objNACC3 = new TBN_NewAffiliatedContactController();
	        objNACC2.strSelectedAccount = lstAccountsToInsert[3].Id;
	        objNACC3.objNewContact.LastName = 'TestContact';
	        objNACC3.createPracticeAccountAlt();
	        objNACC3.dummyCancel();
        	objNACC3.showContactPanel();
	    Test.stopTest();
	    
	}	
		
}