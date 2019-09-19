@isTest(seeAllData=false)
private class Sales_TestReferralSourceTrend {
    @testSetup static void setup(){
    	final ID SALES_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].id;
        User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate,
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');

        insert usr;

        Account acct = new Account(Name='Test Account', Unity_Id__c = '1');
        insert acct;
        AccountTeamMember atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct.Id);
        insert atm;
        List<Sales_account_metrics__c> ams = new List<Sales_account_metrics__c>();
        ams.add(new Sales_account_metrics__c(Name='1-1', Account__c=acct.Id, Month__c=Date.newInstance(System.now().year(), 1, 1)));
        ams.add(new Sales_account_metrics__c(Name='1-2', Account__c=acct.Id, Month__c=Date.newInstance(System.now().year(), 6, 15),
                                             KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=1));
        ams.add(new Sales_account_metrics__c(Name='1-3', Account__c=acct.Id, Month__c=Date.newInstance(System.now().year(), 12, 31)));
        ams.add(new Sales_account_metrics__c(Name='2-1', Account__c=acct.Id, Month__c=date.newInstance(System.now().year()-1, 1, 1)));
        ams.add(new Sales_account_metrics__c(Name='2-2', Account__c=acct.Id, Month__c=date.newInstance(System.now().year()-1, 6, 15),
                                            KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=2));
        ams.add(new Sales_account_metrics__c(Name='2-3', Account__c=acct.Id, Month__c=date.newInstance(System.now().year()-1, 12, 31)));
        ams.add(new Sales_account_metrics__c(Name='3-1', Account__c=acct.Id, Month__c=date.newInstance(System.now().year()-2, 1, 1)));
        ams.add(new Sales_account_metrics__c(Name='3-2', Account__c=acct.Id, Month__c=date.newInstance(System.now().year()-2, 6, 15),
                                            KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=1));
        ams.add(new Sales_account_metrics__c(Name='3-3', Account__c=acct.Id, Month__c=date.newInstance(System.now().year()-2, 12, 31)));
        insert ams;

        Contact con = new Contact(FirstName='Test', LastName = 'Contact', Unity_Id__c = '1');
        insert con;
        Contact_Team__c ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
        insert ct;
        List<Sales_contact_metrics__c> cms = new List<Sales_contact_metrics__c>();
        cms.add(new Sales_contact_metrics__c(Name='1-1', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), 1, 1)));
        cms.add(new Sales_contact_metrics__c(Name='1-2', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), 6, 15),
                                            KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=1));
        cms.add(new Sales_contact_metrics__c(Name='1-3', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), 12, 31)));
        cms.add(new Sales_contact_metrics__c(Name='2-1', Contact__c=con.Id, Month__c=date.newInstance(System.now().year()-1, 1, 1)));
        cms.add(new Sales_contact_metrics__c(Name='2-2', Contact__c=con.Id, Month__c=date.newInstance(System.now().year()-1, 6, 15),
                                            KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=1));
        cms.add(new Sales_contact_metrics__c(Name='2-3', Contact__c=con.Id, Month__c=date.newInstance(System.now().year()-1, 12, 31)));
        cms.add(new Sales_contact_metrics__c(Name='3-1', Contact__c=con.Id, Month__c=date.newInstance(System.now().year()-2, 1, 1)));
        cms.add(new Sales_contact_metrics__c(Name='3-2', Contact__c=con.Id, Month__c=date.newInstance(System.now().year()-2, 6, 15),
                                            KAH_HH_Admits__c=1, KAH_HP_Admits__c=1, KAH_HH_Referrals__c=1, KAH_HP_Referrals__c=2));
        cms.add(new Sales_contact_metrics__c(Name='3-3', Contact__c=con.Id, Month__c=date.newInstance(System.now().year()-2, 12, 31)));
        insert cms;

        List<Event> events = new List<Event>();
        events.add(new Event(ActivityDateTime = date.newInstance(System.now().year(), 1, 15), OwnerId = usr.Id, DurationInMinutes = 15, Complete__c=true, WhoId=con.Id, WhatId=acct.Id));
        events.add(new Event(ActivityDateTime = date.newInstance(System.now().year()-1, 1, 15), OwnerId = usr.Id, DurationInMinutes = 15, Complete__c=true, WhoId=con.Id, WhatId=acct.Id));
        events.add(new Event(ActivityDateTime = date.newInstance(System.now().year()-2, 1, 15), OwnerId = usr.Id, DurationInMinutes = 15, Complete__c=true, WhoId=con.Id, WhatId=acct.Id));
        insert events;
    }
    @isTest static void getUsers() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getUsers(usr.Id);
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataAdmit_1() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Admit');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataQualifiedAdmit_1() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Qualified Admit');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataReferral_1() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Referral');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataConversion_1() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Conversion %');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataCalls_1() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Sales Calls');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataAdmitCalls_1() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Admits / Calls');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataAdmit_2() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Admit');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataQualifiedAdmit_2() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Qualified Admit');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataReferral_2() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Referral');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataConversion_2() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Conversion %');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataCalls_2() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Sales Calls');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataAdmitCalls_2() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Admits / Calls');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataAdmit_3() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        years.add(String.valueOf(System.now().year()-2));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Admit');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataQualifiedAdmit_3() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        years.add(String.valueOf(System.now().year()-2));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Qualified Admit');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataReferral_3() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        years.add(String.valueOf(System.now().year()-2));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Referral');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataConversion_3() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        years.add(String.valueOf(System.now().year()-2));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Conversion %');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataCalls_3() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        years.add(String.valueOf(System.now().year()-2));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Sales Calls');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataAdmitCalls_3() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        years.add(String.valueOf(System.now().year()-2));
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HP', 'Admits / Calls');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getDataRatings() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        String result;
        List<String> years = new List<String>();
        years.add(String.valueOf(System.now().year()));
        years.add(String.valueOf(System.now().year()-1));
        years.add(String.valueOf(System.now().year()-2));
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        Contact con = [SELECT Id FROM Contact WHERE FirstName='Test' and LastName = 'Contact'];
        List<Sales_5x5x5_Ratings__c> ratings = new List<Sales_5x5x5_Ratings__c>();
        ratings.add(new Sales_5x5x5_Ratings__c(Account__c=acct.Id, Rating__c='Top', User__c=usr.Id));
        ratings.add(new Sales_5x5x5_Ratings__c(Account__c=acct.Id, Rating__c='Flat', User__c=usr.Id));
        ratings.add(new Sales_5x5x5_Ratings__c(Account__c=acct.Id, Rating__c='Bottom', User__c=usr.Id));
        ratings.add(new Sales_5x5x5_Ratings__c(Contact__c=con.Id, Rating__c='Top', User__c=usr.Id));
        ratings.add(new Sales_5x5x5_Ratings__c(Contact__c=con.Id, Rating__c='Flat', User__c=usr.Id));
        ratings.add(new Sales_5x5x5_Ratings__c(Contact__c=con.Id, Rating__c='Bottom', User__c=usr.Id));
        insert ratings;
        List<Business_Plan__c> bps = new List<Business_Plan__c>{new Business_Plan__c(user__c=usr.Id, Account__c=acct.Id),
            new Business_Plan__c(user__c=usr.Id, Contact__c=con.Id)};
        insert bps;
        Test.StartTest();
        result = Sales_ReferralSourceTrendReport.getData(usr.Id, years, 'HH', 'Admits');
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void updateRating() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        Contact con = [SELECT Id FROM Contact WHERE FirstName='Test' and LastName = 'Contact'];
        List<Sales_5x5x5_Ratings__c> ratings = new List<Sales_5x5x5_Ratings__c>();
        ratings.add(new Sales_5x5x5_Ratings__c(Account__c=acct.Id, Rating__c='Top', User__c=usr.Id));
        ratings.add(new Sales_5x5x5_Ratings__c(Contact__c=con.Id, Rating__c='Top', User__c=usr.Id));
        insert ratings;
        Test.StartTest();
        Boolean resultAccount = Sales_ReferralSourceTrendReport.rateReferral(acct.Id, usr.Id, 'Top');
        Boolean resultContact = Sales_ReferralSourceTrendReport.rateReferral(con.Id, usr.Id, 'Top');
        Test.StopTest();
        System.assert(resultAccount==true);
        System.assert(resultContact==true);
    }

    @isTest static void insertRating() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        Contact con = [SELECT Id FROM Contact WHERE FirstName='Test' and LastName = 'Contact'];
        Test.StartTest();
        Boolean resultAccount = Sales_ReferralSourceTrendReport.rateReferral(acct.Id, usr.Id, 'Top');
        Boolean resultContact = Sales_ReferralSourceTrendReport.rateReferral(con.Id, usr.Id, 'Top');
        Test.StopTest();
        System.assert(resultAccount==true);
        System.assert(resultContact==true);
    }

    @isTest static void deleteRating() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        Contact con = [SELECT Id FROM Contact WHERE FirstName='Test' and LastName = 'Contact'];
        List<Sales_5x5x5_Ratings__c> ratings = new List<Sales_5x5x5_Ratings__c>();
        ratings.add(new Sales_5x5x5_Ratings__c(Account__c=acct.Id, Rating__c='Top', User__c=usr.Id));
        ratings.add(new Sales_5x5x5_Ratings__c(Contact__c=con.Id, Rating__c='Top', User__c=usr.Id));
        insert ratings;
        Test.StartTest();
        Boolean resultAccount = Sales_ReferralSourceTrendReport.rateReferral(acct.Id, usr.Id, 'Remove');
        Boolean resultContact = Sales_ReferralSourceTrendReport.rateReferral(con.Id, usr.Id, 'Remove');
        Test.StopTest();
        System.assert(resultAccount==true);
        System.assert(resultContact==true);
    }

    @isTest static void getSwot_hasSwot() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        insert new Business_Plan__c(user__c=usr.Id, Account__c=acct.Id, Strength__c='"test"');
        Test.StartTest();
        String result = Sales_ReferralSourceTrendReport.getSwot(acct.Id, usr.Id);
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void getSwot_noSwot() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        Test.StartTest();
        String result = Sales_ReferralSourceTrendReport.getSwot(acct.Id, usr.Id);
        Test.StopTest();
        System.assert(result!=null);
    }

    @isTest static void updateSwot() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        insert new Business_Plan__c(user__c=usr.Id, Account__c=acct.Id);
        Test.StartTest();
        Boolean result = Sales_ReferralSourceTrendReport.saveSwot(acct.Id, usr.Id,
                                                                 null, 'cats', '',
                                                                 null, 'more tests', '');
        Test.StopTest();
        System.assert(result==true);
    }

    @isTest static void insertSwot() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        Contact con = [SELECT Id FROM Contact WHERE FirstName='Test' and LastName = 'Contact'];
        Test.StartTest();
        Boolean resultAccount = Sales_ReferralSourceTrendReport.saveSwot(acct.Id, usr.Id,
                                                                 null, 'cats', '',
                                                                 null, 'more tests', '');
        Boolean resultContact = Sales_ReferralSourceTrendReport.saveSwot(con.Id, usr.Id,
                                                                 null, 'cats', '',
                                                                 null, 'more tests', '');
        Test.StopTest();
        System.assert(resultAccount==true);
        System.assert(resultContact==true);
    }

    @isTest static void deleteSwot() {
        User usr = [SELECT id FROM User WHERE UserName='KAHSalesAssociate@testorg.com'];
        Account acct = [SELECT Id FROM account WHERE Name='Test Account'];
        insert new Business_Plan__c(user__c=usr.Id, Account__c=acct.Id);
        Test.StartTest();
        Boolean resultAccount = Sales_ReferralSourceTrendReport.deleteSwot(acct.Id, usr.Id);
        Test.StopTest();
        System.assert(resultAccount==true);
    }
}