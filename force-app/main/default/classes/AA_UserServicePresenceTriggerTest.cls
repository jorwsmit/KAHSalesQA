@isTest
private class AA_UserServicePresenceTriggerTest {

    static testMethod void myUnitTest() {
        
        User u = new User(FirstName = 'testFirst',
                          LastName = 'TestUser' + String.valueOf(Date.today()), 
                          Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                          Username = 'TestUserSessionAccount' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                          isActive = true,
                          Alias = 'tus',
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
                          PostalCode = '2345',
                          UserPermissionsLiveAgentUser = true
                          );
        insert u;
        
        LiveAgentSession las = new LiveAgentSession(AgentID = u.ID,
                                                    OwnerID = u.ID,
                                                    loginTime = system.now(),
                                                    logoutTime = system.now()
                                                    );
                                                    insert las;
        
        UserServicePresence usp = new UserServicePresence(OwnerID = u.ID,
                                                          UserID = u.ID
                                                          );
        insert usp;
        
        ServicePresenceStatus sps = [SELECT ID, MasterLabel FROM ServicePresenceStatus WHERE MasterLabel = 'Online' LIMIT 1];
        ServicePresenceStatus sps2 = [SELECT ID, MasterLabel FROM ServicePresenceStatus WHERE MasterLabel = 'Unavailable' LIMIT 1];

        usp.ServicePresenceStatusId = sps2.ID;
        update usp;
        
        usp.ServicePresenceStatusId = sps.ID;
        update usp;

        }
}