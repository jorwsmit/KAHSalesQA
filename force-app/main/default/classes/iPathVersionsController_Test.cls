@isTest
private class iPathVersionsController_Test {
  
  static testMethod void testVersions() {
    
    final id Sales_HD_Associate = '00ea0000001serv';
    
    User u = new User();
      
    u.FirstName = 'BradTest';
    u.LastName = 'ThomasTest';
    u.Title = 'DeveloperTest';
    u.Email = 'bradley.thomas@kindred.com';
    u.Phone = '5022342342';
    u.MobilePhone = '5021231233';
    u.Street = 'AnySt';
    u.City = 'AnyCity';
    u.State = 'AZ';
    u.PostalCode = '12355';
    u.Country = 'USA';
    u.LevelOfCare__c = 'TCC';
    u.Username = 'testemail@kindred.com';
    u.Alias = 'Temp';
    u.CommunityNickname = 'Temp';
    u.TimeZoneSidKey = 'America/New_York';
    u.LocaleSidKey = 'en_US';
    u.EmailEncodingKey = 'ISO-8859-1';
    u.ProfileId = Sales_HD_Associate;
    u.LanguageLocaleKey = 'en_US';
      
    insert u;
 
    System.runAs(u) {
        iPathVersionsController.patchVersions('10.2','3.1.124');
    }
    
    User result1 = [SELECT iOS_Version__c, iOS_Version_Last_Updated__c, iPath_Version__c, iPath_Version_Last_Updated__c FROM User WHERE Id = :u.Id];
  
    System.assertEquals('10.2', result1.iOS_Version__c);
    System.assertNotEquals(null, result1.iOS_Version_Last_Updated__c);
    System.assertEquals('3.1.124', result1.iPath_Version__c);
    System.assertNotEquals(null, result1.iPath_Version_Last_Updated__c);
    
    System.runAs(u) {
        iPathVersionsController.patchVersions('10.2','3.1.124');
    }
    
    User result2 = [SELECT iOS_Version__c, iOS_Version_Last_Updated__c, iPath_Version__c, iPath_Version_Last_Updated__c FROM User WHERE Id = :u.Id];
  
    // Not testing modified times here because that would require inserting a delay into the test method or some other workaround
    System.assertEquals('10.2', result2.iOS_Version__c);
    System.assertEquals('3.1.124', result2.iPath_Version__c);
    
    System.runAs(u) {
        iPathVersionsController.patchVersions('10.3','3.1.124');
    }
    
    User result3 = [SELECT iOS_Version__c, iOS_Version_Last_Updated__c, iPath_Version__c, iPath_Version_Last_Updated__c FROM User WHERE Id = :u.Id];
  
    System.assertEquals('10.3', result3.iOS_Version__c);
    System.assertEquals('3.1.124', result3.iPath_Version__c);
    
    System.runAs(u) {
        iPathVersionsController.patchVersions('10.3','3.2');
    }
    
    User result4 = [SELECT iOS_Version__c, iOS_Version_Last_Updated__c, iPath_Version__c, iPath_Version_Last_Updated__c FROM User WHERE Id = :u.Id];
  
    System.assertEquals('10.3', result4.iOS_Version__c);
    System.assertEquals('3.2', result4.iPath_Version__c);
  }
  
}