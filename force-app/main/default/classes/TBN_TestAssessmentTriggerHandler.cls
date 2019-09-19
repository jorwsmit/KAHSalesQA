/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TBN_TestAssessmentTriggerHandler {

    static testMethod void myUnitTest() {
        
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
                    
        Account objAccount = new Account(Name = 'Test name',RecordTypeId = strRecordTypeId);
        insert objAccount;
        
        Account objAccount1 = new Account(Name = 'Test name',RecordTypeId = strRecordTypeId, Central_Intake_Email__c = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com');
        insert objAccount1;
        
        Contact objContact = new Contact(AccountId = objAccount.Id, LastName= 'Test Contact', Title = 'CM',Phone = '123456789');
        insert objContact;
        
        AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'ADSM', UserId = objUser.Id);
        insert objATM;
        
        AccountTeamMember objATM1 = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'DDSM', UserId = objUser.Id);
        insert objATM1;
        
        AccountTeamMember objATM2 = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'VP', UserId = objUser.Id);
        insert objATM2;
        
        Patient_NEW__c objPatient = new Patient_NEW__c(Last_Name__c = 'Test Patient',Name = 'Test name', Status__c = 'Pending', Status_Detail__c = 'Normal Pending');
        insert objPatient;
        
        Patient_NEW__c objPatient2 = new Patient_NEW__c(Last_Name__c = 'Test Patient',Name = 'Test name', Status__c = 'Pending', Status_Detail__c = 'Normal Pending');
        insert objPatient2;
        
        Assessment__c objAssessment = new Assessment__c(Patient__c = objPatient.Id,Preferred_Facility__c = objAccount.id);
        insert objAssessment;
        
        Assessment__c objAssessment1 = new Assessment__c(Patient__c = objPatient2.Id,Preferred_Facility__c = objAccount1.id);
        insert objAssessment1;
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objAssessment.id;
        insert attach;
        
        Test.startTest();
            objPatient.Status__c = 'Pending';
            update objPatient; 
            
            objPatient2.status__c = 'Pending';
            update objPatient2;
        Test.stopTest();
    }
}