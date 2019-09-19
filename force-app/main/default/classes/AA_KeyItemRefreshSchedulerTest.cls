@isTest
private class AA_KeyItemRefreshSchedulerTest {
    
    public static ID accID = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND developerName = 'Referring_Facility_Child'].ID;
	public static ID ctcID = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND developerName = 'General_Contact'].ID;
    
    static testMethod void unitTest(){
    	
    	Account a = new Account(Name='TestAccount', RecordTypeId = accID, NPI__c = '12');
        Contact c = new Contact(LastName='TestContact', RecordTypeId = ctcID, NPI__c = '1263');
        Id profileId=userinfo.getProfileId();
        
        insert a;
        insert c;
        
        Date dte = date.parse('8/1/2014');
        
        //Home_Facility__c hfs = new Home_Facility__c(Account__c = a.ID);
		//insert hfs;
        //Target_Agreement__c tgts = new Target_Agreement__c();
		//insert tgts;
		
		//Contact_Team__c cteams = new Contact_Team__c(Contact__c = c.ID, User__c = usrs.ID);
		//insert cteams;
        
        Sales_Account_Metrics__c sams = new Sales_Account_Metrics__c(Account__c = a.ID, Month__c = dte);
		Sales_Contact_Metrics__c scms = new Sales_Contact_Metrics__c(Contact__c = c.ID, Month__c = dte);
				
		insert sams;
		insert scms;
		
		test.startTest();
		User usrs = new User(Alias = 'teCon55', Email='testContactTeam324233@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='testContactTeam3333221', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='testContactTeam123123qq@testorg.com');
        insert usrs;
        
		Sales_Performance__c sPerf = new Sales_Performance__c(User__c = usrs.ID, Clinical_Liaison__c = usrs.ID, Month__c = dte);
		insert sPerf;
        String CRON_EXP = '0 0 * * * ?';
		AA_KeyItemRefreshScheduler sch = new AA_KeyItemRefreshScheduler();
		system.schedule('HistoricItemRefresh', CRON_EXP, sch);
		test.stopTest();
    	}
    
}