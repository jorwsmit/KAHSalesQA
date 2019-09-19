@isTest
private class AA_HRS_BDO_TerritoryTriggerTest{

    static testMethod void myUnitTest(){
        
        ID profileID = userinfo.getProfileId();
        
        	list<User> toInsertU = new list<User>();
        	User u5 = new User(ProfileId = profileID, 
       	                   FirstName = 'Tes@#$t',
                          LastName = 'Use@#$r',
                          userName = 'nmnmnmzzznmnmnmne@thistestmethodislame.com',
                          Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u6 = new User(ProfileId = profileID, 
                          FirstName = 'TestUser',
                          LastName = 'UserUsfser',
                          userName = 'xcvxcvzzzzzzxcvxva@thistestmethodislame.com',
                          Alias = 'te9034', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u7 = new User(ProfileId = profileID, 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'xcvcxxxxxxvxcvxcv@thistestmethodislame.com',
                          Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u8 = new User(ProfileId = profileID, 
                          FirstName = 'TestUser',
                          LastName = 'UserUser',
                          userName = 'xcvcvxcvxcvcvccccc@thistestmethodislame.com',
                          Alias = 'te9034', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        toInsertU.add(u5);
        toInsertU.add(u6);
        toInsertU.add(u7);
        toInsertU.add(u8);
        insert toInsertU;
        
        list<HRS_BDO_Territory__c> hrsToInsert = new list<HRS_BDO_Territory__c>();
		HRS_BDO_Territory__c hrsData = new HRS_BDO_Territory__c(HRS_BDO__c = u5.Id,
                                                                Outside_US_Territories__c = 'PR',
                                                                US_Territories__c = 'KY');
        hrsToInsert.add(hrsData);
        HRS_BDO_Territory__c hrsData2 = new HRS_BDO_Territory__c(HRS_BDO__c = u6.Id,
                                                                Outside_US_Territories__c = 'ON',
                                                                US_Territories__c = 'NY');
        hrsToInsert.add(hrsData2);
        HRS_BDO_Territory__c hrsData3 = new HRS_BDO_Territory__c(HRS_BDO__c = u7.Id,
                                                                Outside_US_Territories__c = 'NT',
                                                                US_Territories__c = 'AZ');
        hrsToInsert.add(hrsData3);
        HRS_BDO_Territory__c hrsData4 = new HRS_BDO_Territory__c(HRS_BDO__c = u8.Id,
                                                                Outside_US_Territories__c = 'PR',
                                                                US_Territories__c = 'KY');
        hrsToInsert.add(hrsData4);
        
        insert hrsToInsert;
        
        hrsData4.Outside_US_Territories__c = 'ON';
        hrsData4.US_Territories__c = 'NY';
        
        hrsData3.Outside_US_Territories__c = 'PR';
        hrsData3.US_Territories__c = 'KY';
        
        update hrsData3;
        update hrsData4;
        
    	}
}