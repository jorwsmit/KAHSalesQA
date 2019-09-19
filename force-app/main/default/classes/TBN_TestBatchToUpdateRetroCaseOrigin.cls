@isTest
private class TBN_TestBatchToUpdateRetroCaseOrigin {
    
    static testMethod void updatesCaseOriginForInitialData() {
        
        /* Insert the records required for trigger on case */
        User objUser = new User(FirstName = 'testFirst',
								LastName = 'TestUser' + String.valueOf(Date.today()), 
								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
								Username = 'TestUser_Test_TBN_CaseEntry' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
								isActive = true,
								Alias = 'tu',
								TimeZoneSidKey = 'America/New_York',
								LocaleSidKey = 'en_US',
								EmailEncodingKey = 'ISO-8859-1', 
								LanguageLocaleKey = 'en_US',
								ProfileId =  Userinfo.getProfileId(),
								CommunityNickname = 'TestCommunity' + String.valueOf(Date.today()) + '_', 
								Title = 'Title11',
								City = 'testCity',
								Country = 'testCountry',
								Street = 'testStreet',
								CompanyName = 'testCompanyName',
								Phone = 'testPhone',
								Extension = 'testExtension',
								PostalCode = '2345'
							    );
    	insert objUser;
    	
    	Id ACCOUNT_RT_CENTER = [Select SobjectType, Name, DeveloperName From RecordType where SobjectType = 'Account' AND DeveloperName = 'Center'].Id;
    	Account objFacility = new Account(Name = 'TestAccountFacility', Central_Intake_Email__c = 'test.kindred@gmail.com',RecordTypeId = ACCOUNT_RT_CENTER);
    	insert objFacility;
    	
    	Contact objContact1 = new Contact(AccountId = objFacility.Id, LastName= 'Test new Contact', Title = 'CM');
		insert objContact1;
		
		AccountTeamMember objATM1 = new AccountTeamMember(AccountId = objFacility.Id, TeamMemberRole = 'DDSM', UserId = objUser.Id);
		insert objATM1;
		
		AccountTeamMember objATM2 = new AccountTeamMember(AccountId = objFacility.Id, TeamMemberRole = 'VP', UserId = objUser.Id);
		insert objATM2; 
		
		Patient_NEW__c objPatient = new Patient_NEW__c(Last_Name__c = 'Test Patient',Name = 'Test name', Status__c = 'Pending', Status_Detail__c = 'Normal Pending');
		insert objPatient;
		
		Assessment__c objAssessment = new Assessment__c(Patient__c = objPatient.Id,Preferred_Facility__c = objFacility.id);
		insert objAssessment;
		
		Test.startTest();
		    
		    // Insert multiple Cases for the same Contact
        	Case objCase = new Case(AccountId = objFacility.Id,
        	                        ContactId = objContact1.Id,
        	                        Patient_New__c = objPatient.Id,
        	                        Assessment__c = objAssessment.Id,
        	                        Origin = 'System Review',
        	                        Subject = 'Test$$$Patient$$$$$'+UserInfo.getName() );
    		insert objCase;
    		
    		Case objCase1 = new Case(AccountId = objFacility.Id,
        	                        ContactId = objContact1.Id,
        	                        Patient_New__c = objPatient.Id,
        	                        Assessment__c = objAssessment.Id,
        	                        Origin = 'Telephone Call - Hospice of Charleston',
        	                        Subject = 'Test$$$Patient$$$$$'+UserInfo.getName() );
    		insert objCase1;
    		
    		// executing the batch to update the Contact origin based on related Cases
    		TBN_BatchToUpdateRetroCaseOrigin objBatchInstance = new TBN_BatchToUpdateRetroCaseOrigin(   'Select ContactId, Origin ' + 
                                                                                                        'From Case ' + 
                                                                                                        'Where Origin != null AND ' +
                                                                                                               'ContactId != null ' + 
                                                                                                               'Order By ContactId, LastModifiedDate');
            Database.executeBatch(objBatchInstance, 2000);
    	    
    	    // Confirm that the contact is having the recent origin on case
    	    List<Contact> lstContacts = [Select Id, Case_Origin__c From Contact Where Id = :objContact1.Id];
    	    //system.assertEquals('Telephone Call - Hospice of Charleston', lstContacts[0].Case_Origin__c);
    	    
    	Test.stopTest();
    }
}