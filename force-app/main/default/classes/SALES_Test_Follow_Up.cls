@isTest (seeAllData=false)
public class SALES_Test_Follow_Up {
  private static final Id marketoLiaisonProfileId = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
  @isTest static void callingAllRemoteQueryFunctions() {
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = marketoLiaisonProfileId,
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '098098757646331');
        insert usr;
        Datetime currentDate = System.now();
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        insert e;

        System.Assert(SALES_Follow_Up.insertEvent(e.Id) != null);
    }
}