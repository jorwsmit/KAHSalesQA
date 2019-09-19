@isTest(SeeAllData = false)
public class SALES_TestLaunchpadController {
	
    public static Id userId;
    @testSetup static void setup(){
        final ID SALES_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
        User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate,  
        TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');
        
        Datetime cd = System.now();
        list<Account> aInsert = new list<Account>();
        Account unassignedAcct = new Account(Name='Unassigned Account - Admin Maintenance');
        aInsert.add(unassignedAcct);
        
        insert usr;
        Account acct = new Account(Name='Test Account', KAH_Account_Classification__c = 'A+1');
        aInsert.add(acct);
        
        Account acct2 = new Account(Name='Test Account2', KAH_Account_Classification__c = 'A1');
        aInsert.add(acct2);
        insert aInsert;
        
        list<AccountTeamMember> atInsert = new list<AccountTeamMember>();
        AccountTeamMember actm = new AccountTeamMember(UserId = usr.Id, AccountId = acct.Id);
        atInsert.add(actm);
        
        actm = new AccountTeamMember(UserId = usr.Id, AccountId = acct.Id);
        atInsert.add(actm);
        insert atInsert;
        
        list<Sales_account_metrics__c> smInsert = new list<Sales_account_metrics__c>();
        
        Sales_account_metrics__c am = new Sales_account_metrics__c(Name='1', Account__c=acct.Id, Month__c=date.newInstance(System.now().year(), System.now().month(), 1));
        smInsert.add(am);
        Sales_account_metrics__c am2 = new Sales_account_metrics__c(Name='2', Account__c=acct.Id, Month__c=date.newInstance(System.now().year(), System.now().month(), 1).addMonths(-1));
        smInsert.add(am2);
        Sales_account_metrics__c am3 = new Sales_account_metrics__c(Name='3', Account__c=acct.Id, Month__c=date.newInstance(System.now().year()-1, System.now().month(), 1));
        smInsert.add(am3);
        insert smInsert;
        
        list<Contact> cInsert = new list<Contact>();
        list<Contact_Team__c> ctInsert = new list<Contact_Team__c>();
        Contact con = new Contact(FirstName='Test', LastName = 'Account2', KAH_Account_Classification__c = 'A1');
        cInsert.add(con);
        
        Contact con2 = new Contact(FirstName='Test', LastName = 'Account', KAH_Account_Classification__c = 'A+1');
        cInsert.add(con2);
        
        insert cInsert;
        
        Contact_Team__c ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
        ctInsert.add(ct);
        Contact_Team__c ct2 = new Contact_Team__c(User__c = usr.Id, Contact__c = con2.Id);
        ctInsert.add(ct2);
        insert ctInsert;
        
        cd.addDays(-1);
        Event e = new Event(ActivityDateTime = cd, OwnerId = usr.Id, DurationInMinutes = 15, whoId = con.Id, whatId = acct.Id);
        insert e;
        
        list<Sales_contact_metrics__c> cmInsert = new list<Sales_contact_metrics__c>();
        Sales_contact_metrics__c cm = new Sales_contact_metrics__c(Name='1', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), System.now().month(), 1).addMonths(-1));
        cmInsert.add(cm);
        
        Sales_contact_metrics__c cm2 = new Sales_contact_metrics__c(Name='2', Contact__c=con.Id, Month__c=date.newInstance(System.now().year(), System.now().month(), 1));
        cmInsert.add(cm2);
        
        Sales_contact_metrics__c cm3 = new Sales_contact_metrics__c(Name='3', Contact__c=con.Id, Month__c=date.newInstance(System.now().year()-1, System.now().month(), 1));
        cmInsert.add(cm3);
        insert cmInsert;
        
        cd.addDays(-2);
        e = new Event(ActivityDateTime = cd, OwnerId = usr.Id, DurationInMinutes = 15, whoId = con.Id, whatId = acct.Id);
        insert e;
        
        userId = usr.Id;
               
    }
    
    @isTest static void test1() {
        
        User usr = [select Id from user where username='KAHSalesAssociate@testorg.com'];
        
        
        SALES_LaunchpadController.getSPDataSalesCalls(usr.Id, 0);
        SALES_LaunchpadController.getSPData(usr.Id, 0);
        SALES_LaunchpadController.getThisWeeksEvents(usr.Id, 0);
        SALES_LaunchpadController.getRecentBirthdays(usr.Id);
        SALES_LaunchpadController.getReports('Sales: KAH Reports');
        SALES_LaunchpadController.getDefaultRadio(usr.Id);
        SALES_LaunchpadController.getRecordType('name');
        
        Test.StartTest();
        SALES_LaunchpadController.emailLastActivityByClassification(usr.Id, 'Blob');
		
        UserRole ur = [select Id from UserRole where Name='SVP - KAH'];
        SALES_LaunchpadController.getUsersByRole(ur.Id);
        SALES_LaunchpadController.getUsersUnderRoleId(ur.Id);
        ur = [select Id from UserRole where Name like 'SA%' limit 1];
        SALES_LaunchpadController.getLogins(usr.Id, ur.Id);
        SALES_LaunchpadController.getUsersByRole(ur.Id);
        Test.StopTest();
    }
    
    @isTest static void test2() {
        
        User usr = [select Id from user where username='KAHSalesAssociate@testorg.com'];
        
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', 'All', '', 'HH');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', '1', '', 'HH');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A+', '1', '', 'HH');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', '1', '', 'HH');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', 'All', '', 'HH');
            
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', 'All', '', 'HP');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', '1', '', 'HP');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A+', '1', '', 'HP');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', '1', '', 'HP');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', 'All', '', 'HP');
        Test.StartTest();    
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', 'All', '', 'MTD');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', '1', '', 'MTD');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A+', '1', '', 'MTD');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', '1', '', 'MTD');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', 'All', '', 'MTD');
            
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', 'All', '', 'YOY');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'All', '1', '', 'YOY');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A+', '1', '', 'YOY');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', '1', '', 'YOY');
            SALES_LaunchpadController.getLastActivityByClassification(usr.Id, 'A', 'All', '', 'YOY');
        Test.StopTest();
        
    }
    
}