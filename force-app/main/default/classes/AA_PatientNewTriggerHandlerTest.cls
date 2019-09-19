@isTest
private class AA_PatientNewTriggerHandlerTest {

    static testMethod void myUnitTest(){
    	Id caseRtGeneral = [Select SobjectType, Name, DeveloperName From RecordType where SobjectType = 'Case' AND DeveloperName = 'General_Inquiry'].Id;
        User objUser = new User(
                FirstName = 'testFirst',
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
                    
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Center'].Id;
        
        list<Account> accToInsert = new list<Account>();
                    
        Account objAccount = new Account(Name = 'Test name',RecordTypeId = strRecordTypeId);
        accToInsert.add(objAccount);
        
        Account objAccount1 = new Account(Name = 'Test name',RecordTypeId = strRecordTypeId, Central_Intake_Email__c = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com');
        accToInsert.add(objAccount1);
        insert accToInsert;
        
        Contact objContact = new Contact(AccountId = objAccount.Id, LastName= 'Test Contact', Title = 'CM',Phone = '123456789');
        insert objContact;
        
        list<AccountTeamMember> atmToInsert = new list<AccountTeamMember>();
        AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'ADSM', UserId = objUser.Id);
        atmToInsert.add(objATM);
        
        AccountTeamMember objATM1 = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'DDSM', UserId = objUser.Id);
        atmToInsert.add(objATM1);
        
        AccountTeamMember objATM2 = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'VP', UserId = objUser.Id);
        atmToInsert.add(objATM2);
        insert atmToInsert;
        
        list<Patient_NEW__c> ptInsert = new list<Patient_NEW__c>();
        Patient_NEW__c objPatient = new Patient_NEW__c(Last_Name__c = 'Test Patient',Name = 'Test name', Status__c = 'Pending', Status_Detail__c = 'Normal Pending');
        ptInsert.add(objPatient);
        
        Patient_NEW__c objPatient2 = new Patient_NEW__c(Last_Name__c = 'Test Patient',Name = 'Test name', Status__c = 'Pending', Status_Detail__c = 'Normal Pending');
        ptInsert.add(objPatient2);
        insert ptInsert;
        
        list<Assessment__c> assessInsert = new list<Assessment__c>();
        Assessment__c objAssessment = new Assessment__c(Patient__c = objPatient.Id,Preferred_Facility__c = objAccount.id);
        assessInsert.add(objAssessment);
        
        Assessment__c objAssessment1 = new Assessment__c(Patient__c = objPatient2.Id,Preferred_Facility__c = objAccount1.id);
        assessInsert.add(objAssessment1);
        insert assessInsert;
        
        Case c = new Case(Status = 'New',
								   Case_Source__c = 'Web', 
    							   Subtype__c = 'Service Recommendation',
    							   Call_Type__c = 'Clinical',
    							   Case_Notes__c = 'Test notes for processing', 
    							   Origin = 'Web', 
    							   Type = 'Lead', 
    							   Subject = 'Lead - Service Recommendation', 
    							   Level_Of_Care__c = 'LTACH', 
    							   Web_First_Name__c = 'Bob', 
    							   Web_Last_Name__c = 'Bobbington', 
    						 	   Web_Street_Address__c = '123 Bob Ln', 
    							   Web_State__c = 'KY',
    							   Web_City__c = 'Louisville', 
    							   Web_Zip_Code__c = '40202', 
    							   SuppliedPhone = '555-555-5555', 
    							   SuppliedEmail = 'noneya@buzzof.com',
    							   RecordTypeId = caseRtGeneral,
    							   Assessment__c = objAssessment1.ID,
    							   Patient_New__c = objPatient2.ID
    							   );
        
        insert c;
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        
        LiveChatTranscript lct = new LiveChatTranscript(CaseID = c.ID, LiveChatVisitorId = lcv.Id);
        insert lct;
        
        Test.startTest();
            objPatient.Status__c = 'Pending';
            update objPatient; 
            
            objPatient2.status__c = 'Pending';
            update objPatient2;
        list<ID> ptIDs = new list<ID>();
        ptIDs.add(objPatient.ID);
        ptIDs.add(objPatient2.ID);
        AA_PatientNewTriggerHandler.updateTranscripts(ptIDs);
        c.Case_Notes__c = 'New Notes for Process check';
        update c;    
        Test.stopTest();
    	}
}