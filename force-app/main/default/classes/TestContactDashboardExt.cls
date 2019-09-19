@isTest (seeAllData=false)
public class TestContactDashboardExt {
  @isTest static void calingAllRemoteQueryFunctions() {
        
        final id Sales_HD_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
        
        Contact con = new Contact(FirstName='Test', LastName = 'Account');
        User u = new User(Alias = 'standt', Email='test@jstestord.com', EmailEncodingKey='UTF-8',
                          LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='test@jstestord.com'); 
        insert con;
        insert u;
        ContactDashboardExt.loadOpps(con.id);
        ContactDashboardExt.queryHms(con.id);
      	ContactDashboardExt.queryAdmits(con.id);
        ContactDashboardExt.queryContactTeam(con.id);
        ContactDashboardExt.queryLastActivty(u.id, con.id);
      	ContactDashboardExt.queryBirthdays(con.id);
      	ContactDashboardExt.queryEvents(con.id);
      	ContactDashboardExt.queryEvent180(con.id);
      	ContactDashboardExt.queryTouchpoints(con.id);
    }
}