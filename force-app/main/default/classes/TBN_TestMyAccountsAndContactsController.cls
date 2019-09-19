@isTest
private class TBN_TestMyAccountsAndContactsController {

	private static testMethod void TBN_MyAccountsAndContactsController() {
	    
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
                                                                            ShippingCountry = 'USA'),
                                                                            new Account( Name = 'Test Account1', 
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
                                                                            ShippingCountry = 'USA')
		    
		};
	  
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
	                                                                         )};
	                                                                         
	    insert lstContactsToInsert;
	                                                                         
        List<Contact_Team__c> lstContactTeamsToInsert = new List<Contact_Team__c>{ new Contact_Team__c( User__c = lstUsersToInsert[0].Id,
                                                                                        Contact__c = lstContactsToInsert[0].Id)
        };
	        
	    insert lstContactTeamsToInsert;
	    
	    List<AccountTeamMember> lstAccountTeamsToInsert = new List<AccountTeamMember>{ new AccountTeamMember( AccountId = lstAccountsToInsert[0].Id,
	                                                                                                          UserId = lstUsersToInsert[0].Id ),
	                                                                                   new AccountTeamMember( AccountId = lstAccountsToInsert[1].Id,
	                                                                                                          UserId = lstUsersToInsert[0].Id ),
                                                                                       new AccountTeamMember( AccountId = lstAccountsToInsert[2].Id,
                                                                                                             UserId = lstUsersToInsert[0].Id ),
                                                                                       new AccountTeamMember( AccountId = lstAccountsToInsert[3].Id,
                                                                                                             UserId = lstUsersToInsert[0].Id ),
                                                                                       new AccountTeamMember( AccountId = lstAccountsToInsert[4].Id,
                                                                                                             UserId = lstUsersToInsert[0].Id ),
                                                                                       new AccountTeamMember( AccountId = lstAccountsToInsert[5].Id,
                                                                                                             UserId = lstUsersToInsert[0].Id ),
                                                                                       new AccountTeamMember( AccountId = lstAccountsToInsert[6].Id,
                                                                                                            UserId = lstUsersToInsert[0].Id ),
                                                                                      new AccountTeamMember( AccountId = lstAccountsToInsert[7].Id,
                                                                                                            UserId = lstUsersToInsert[0].Id ),
                                                                                      new AccountTeamMember( AccountId = lstAccountsToInsert[8].Id,
                                                                                                            UserId = lstUsersToInsert[0].Id ),
                                                                                      new AccountTeamMember( AccountId = lstAccountsToInsert[9].Id,
                                                                                                            UserId = lstUsersToInsert[0].Id )
	    };
	                                                                                                          
	   insert lstAccountTeamsToInsert;
	   
	   System.runAs(lstUsersToInsert[0]) {
    	   Test.startTest();
    	        TBN_MyAccountsAndContactsController objMyAccContact = new TBN_MyAccountsAndContactsController();
    	        system.assertEquals(objMyAccContact.intTotalCount, 11);
    	        TBN_MyAccountsAndContactsController.getRecords();
    	        
    	   Test.stopTest();
	   }
	}
		
}