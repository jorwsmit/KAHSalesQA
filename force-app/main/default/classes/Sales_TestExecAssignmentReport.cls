@isTest (SeeAllData = false)
private class Sales_TestExecAssignmentReport {
	/*
    @testSetup static void dataSetup() {
        User usr = new User(Alias = 'test', Email='testuser@kindredtest.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = '00e1300000225C9',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser@kindredtest.com');
        insert usr;
        
        Account acct = new Account(Name='Test Account1');
        insert acct;
        insert new Home_Facility__c(User__c=usr.Id, Account__c=acct.Id);
        AccountTeamMember atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct.Id);
        insert atm;
        
        Contact con = new Contact(LastName = 'Test Contact1');
        insert con;
        Contact_Team__c ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
        insert ct;
    }
    
    @isTest static void zeroReferrals() {
        User usr = [select id from user where username='testuser@kindredtest.com'];
        insert new Sales_Performance__c(OwnerId=usr.Id, Sales_Calls__c=10, Planned_Sales_Calls__c=15, KAH_HH_Admit_Target__c=1,
                                     KAH_HH_Referrals__c=0, KAH_HH_PPS_Qualified_Admits__c=1, KAH_HP_Admit_Target__c=1,
                                     KAH_HP_Referrals__c=0, KAH_HP_Total_Admits__c=1);
        System.debug([select count() from user]);
        String result;
        Test.StartTest();
        result = Sales_ExecAssignmentReport.getData(null, 50000);
        Test.StopTest();
        System.assert(result!=null);
    }
    
    @isTest static void twoReferrals() {
        User usr = [select id from user where username='testuser@kindredtest.com'];
        insert new Sales_Performance__c(OwnerId=usr.Id, Sales_Calls__c=10, Planned_Sales_Calls__c=15, KAH_HH_Admit_Target__c=1,
                                     KAH_HH_Referrals__c=1, KAH_HH_PPS_Qualified_Admits__c=1, KAH_HP_Admit_Target__c=1,
                                     KAH_HP_Referrals__c=1, KAH_HP_Total_Admits__c=1);
        String result;
        Test.StartTest();
        result = Sales_ExecAssignmentReport.getData(null, 50000);
        Test.StopTest();
        System.assert(result!=null);
    }
    
    @isTest static void withOffset() {
        List<User> users = [select Id from user order by Id];
        String result;
        Test.StartTest();
        result = Sales_ExecAssignmentReport.getData(users[0].Id, 1);
        Test.StopTest();
        System.assert(result!=null);
    }*/
}