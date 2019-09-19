@isTest
private class TBN_TestCreateUser {

    static testMethod void TestUserCreate() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            
            test.StartTest();   
            User objUser1 = new User(
                                        FirstName = 'testFirst4',
                                        LastName = 'TestUser4' + String.valueOf(Date.today()), 
                                        Email = 'TestUser4' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                                        Username = 'TestUser_Test4' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
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
        //  insert objUser1;            
            TBN_CreateUserController objCreateUser = new TBN_CreateUserController();
            objCreateUser.objUser = objUser1;
            
                objCreateUser.CreateNewUserRecord();
            User objUser2 = new User(
                                        FirstName = 'testFirst4',
                                        LastName = 'TestUser4' + String.valueOf(Date.today()), 
                                        Email = 'TestUser4' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                                        Username = 'TestUser_Test4' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
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
            objCreateUser.objUser = objUser2;
            
                objCreateUser.CreateNewUserRecord();    
            test.stoptest();    
        }
    }
}