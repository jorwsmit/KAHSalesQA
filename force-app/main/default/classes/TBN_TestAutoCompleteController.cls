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
private class TBN_TestAutoCompleteController {

    static testMethod void testAutoCompleteController() {


      User objUser = new User(FirstName = 'testFirst3',
                              LastName = 'TestUser3' + String.valueOf(Date.today()), 
                              Email = 'TestUser3' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                              Username = 'TestUser_Test3' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
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
                              PostalCode = '2345');
        insert objUser;
        
        User objUser2 = new User( username = 'newUserAutoComplete@yahoo.com', 
                                  email = 'pb@ff.com', 
                                  emailencodingkey = 'UTF-8', 
                                  localesidkey = 'en_US', 
                                  languagelocalekey = 'en_US', 
                                  timezonesidkey = 'America/Los_Angeles', 
                                  alias='nuser', 
                                  lastname='lastname', 
                                  ProfileId =  Userinfo.getProfileId(),
                                  managerId= objUser.id); 
        insert objUser2;
          
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Parent' Limit 1];
          
        Account objAccount = new Account(name = 'Test Account', recordTypeId = rt.Id);
        insert objAccount;
        
        States__c objState = new States__c(name = 'Test');
        insert objState;
        
        TBN_AutoCompleteController.findUsers('Test');
        TBN_AutoCompleteController.findActiveUsers('Test');
        TBN_AutoCompleteController.fetchAccount('Test');
    }
}