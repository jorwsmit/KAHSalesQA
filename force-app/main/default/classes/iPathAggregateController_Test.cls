@isTest
private class iPathAggregateController_Test {
  
  static testMethod void testDoGet() {
        
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
      
    //Not testing these but required for insert
    u.Username = 'testemail@kindred.com';
    u.Alias = 'Temp';
    u.CommunityNickname = 'Temp';
    u.TimeZoneSidKey = 'America/New_York';
    u.LocaleSidKey = 'en_US';
    u.EmailEncodingKey = 'ISO-8859-1';
    Profile p = [select id from profile where name='System Administrator']; 
    u.ProfileId = p.Id;
    u.LanguageLocaleKey = 'en_US';
      
    insert u;
      
    Market__c m = new Market__c();
      
   	m.Name = 'Test Market';
      
    insert m;
   
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
         
    req.requestURI = '/services/apexrest/Aggregate';
    req.params.put('UserId', u.Id);
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
 
    iPathAggregateController.Aggregate results = iPathAggregateController.doGet();
    
    System.assertEquals('BradTest', results.user.FirstName);
    System.assertEquals('ThomasTest', results.user.LastName);
      System.assertEquals('DeveloperTest', results.user.Title);
      System.assertEquals('bradley.thomas@kindred.com', results.user.Email);
     System.assertEquals('5022342342', results.user.Phone);
      System.assertEquals('5021231233', results.user.MobilePhone);
      System.assertEquals('AnySt', results.user.Street);
      System.assertEquals('AnyCity', results.user.City);
      System.assertEquals('AZ', results.user.State);
      System.assertEquals('12355', results.user.PostalCode);
      System.assertEquals('USA', results.user.Country);
      System.assertEquals('TCC', results.user.LevelOfCare__c);
      
      System.assertEquals('Test Market', results.markets.get(0).Name);
      System.assertEquals(m.Id,results.markets.get(0).Id);
  }
    
    static testMethod void testDoGenerateError() {
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
         
    	req.requestURI = '/services/apexrest/Aggregate';
        req.params.put('UserId', '17263817623812763812763871263817263817263817263817263812763817263871236');
        req.httpMethod = 'GET';
        RestContext.request = req;
    	RestContext.response = res;
 
    	iPathAggregateController.Aggregate results = iPathAggregateController.doGet();
        
        System.assertEquals(NULL, results);
    }
}