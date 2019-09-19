@isTest(SeeAllData=false)
public class Sales_TestAssignmentSnapshot {
    /*
    @testSetup static void dataSetup() {
        final ID SALES_KAH_Associate = '00e1300000225C9';
        User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');
        insert usr;
        
        Account acct = new Account(Name='Unassigned Account - Admin Maintenance');
        insert acct;
        
        Account acct1 = new Account(Name='Test Account1');
        insert acct1;
        AccountTeamMember atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct1.Id);
        insert atm;
        
        Contact con = new Contact(LastName = 'Test Contact1');
        insert con;
        Contact_Team__c ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
        insert ct;
        
        Account acct2 = new Account(Name='Test Account2');
        insert acct2;
        atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct2.Id);
        insert atm;
        
        con = new Contact(LastName = 'Test Contact2');
        insert con;
        ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
        insert ct;
        
        Account acct3 = new Account(Name='Test Account3');
        insert acct3;
        atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct3.Id);
        insert atm;
        
        con = new Contact(LastName = 'Test Contact3');
        insert con;
        ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
        insert ct;
    }
    
    static testmethod void addingAllAssignmentsWithPreexistingUser() {    
        User usr = [select Id, profileId from user where Email='KAHSalesAssociate@testorg.com'];
        
        User usr2 = new User(Alias = 'testPre', Email='KAHSalesAssociatePre@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='TestingPre', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = usr.ProfileId, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociatePre@testorg.com');
        insert usr2;
        
        
        Account acct = [select Id from account where name = 'Test Account1'];
        Test.startTest();
        Contact con = [select Id from contact where lastName = 'Test Contact1'];
        AccountTeamMember atm = new AccountTeamMember(UserId = usr.Id, AccountId = acct.Id);
        insert atm;
		
        Contact_Team__c ct = new Contact_Team__c(User__c = usr.Id, Contact__c = con.Id);
        insert ct;
        
        
        Sales_AssignmentSnapshot batch = new Sales_AssignmentSnapshot();
        batch.query = 'select Id from user where id = \''+usr.Id+'\'';
        Database.executeBatch(batch);
        
        
        
        Map<Id, Referral_Source_Audit__c> idsToMonthlyAssignment = new Map<Id, Referral_Source_Audit__c>();
        for(Referral_Source_Audit__c rsa : [select contact__c, account__c, status__c, request_date__c from Referral_Source_Audit__c where user__c = :usr.Id and request_date__c = this_month]){
            if(rsa.account__c!=null)idsToMonthlyAssignment.put(rsa.Account__c, rsa);
            else if(rsa.contact__c!=null)idsToMonthlyAssignment.put(rsa.Contact__c, rsa);
        }
        
        Account acct1 = [select Id from account where name = 'Test Account1'];
        Account acct2 = [select Id from account where name = 'Test Account2'];
        Account acct3 = [select Id from account where name = 'Test Account3'];
        Test.stopTest();
        Contact con1 = [select Id from contact where lastName = 'Test Contact1'];
        Contact con2 = [select Id from contact where lastName = 'Test Contact2'];
        Contact con3 = [select Id from contact where lastName = 'Test Contact3'];
        
      	
    	}
    
    
    static testmethod void AddingSameAssignmentWithDeletedLastMonth() {       
        User usr = [select Id from user where Email='KAHSalesAssociate@testorg.com'];
        
        Account acct1 = [select Id from account where name = 'Test Account1'];
        Account acct2 = [select Id from account where name = 'Test Account2'];
        Account acct3 = [select Id from account where name = 'Test Account3'];
        
        Contact con1 = [select Id from contact where lastName = 'Test Contact1'];
        Contact con2 = [select Id from contact where lastName = 'Test Contact2'];
        Contact con3 = [select Id from contact where lastName = 'Test Contact3'];
        
        List<Referral_Source_Audit__c> insertMonthlyAssignment = new List<Referral_Source_Audit__c>();
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(account__c = acct1.Id, status__c = 'Deleted', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(account__c = acct2.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(account__c = acct3.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(contact__c = con1.Id, status__c = 'Deleted', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(contact__c = con2.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(contact__c = con3.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        
        insert insertMonthlyAssignment;
        Test.startTest();
        Sales_AssignmentSnapshot batch = new Sales_AssignmentSnapshot();
        batch.query = 'select Id from user where id = \''+usr.Id+'\'';
        Database.executeBatch(batch);
        Test.stopTest();
        
        Map<Id, Referral_Source_Audit__c> idsToMonthlyAssignment = new Map<Id, Referral_Source_Audit__c>();
        for(Referral_Source_Audit__c rsa : [select contact__c, account__c, status__c, request_date__c from Referral_Source_Audit__c where user__c = :usr.Id and request_date__c = this_month]){
            if(rsa.account__c!=null)idsToMonthlyAssignment.put(rsa.Account__c, rsa);
            else if(rsa.contact__c!=null)idsToMonthlyAssignment.put(rsa.Contact__c, rsa);
        }
        
        
    }
    
    static testmethod void DeletedThisMonth() {       
        User usr = [select Id from user where Email='KAHSalesAssociate@testorg.com'];
        
        Account acct1 = [select Id from account where name = 'Test Account1'];
        Account acct2 = [select Id from account where name = 'Test Account2'];
        Account acct3 = [select Id from account where name = 'Test Account3'];
        
        Contact con1 = [select Id from contact where lastName = 'Test Contact1'];
        Contact con2 = [select Id from contact where lastName = 'Test Contact2'];
        Contact con3 = [select Id from contact where lastName = 'Test Contact3'];
        
        List<Referral_Source_Audit__c> insertMonthlyAssignment = new List<Referral_Source_Audit__c>();
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(account__c = acct1.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(account__c = acct2.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(account__c = acct3.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(contact__c = con1.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(contact__c = con2.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        insertMonthlyAssignment.add(new Referral_Source_Audit__c(contact__c = con3.Id, status__c = 'Remaining', user__c = usr.Id,
                                                              request_date__c = Date.newInstance(System.now().year(), System.now().month(), System.today().day()-1)));
        
        insert insertMonthlyAssignment;
        Test.startTest();
        AccountTeamMember atm = [select Id from AccountTeamMember where accountId = :acct1.Id];
        delete atm;
        
        Contact_Team__c ct = [select Id from Contact_Team__c where contact__c = :con1.Id and user__c = :usr.Id];
        delete ct;
        
        
        Sales_AssignmentSnapshot batch = new Sales_AssignmentSnapshot();
        batch.query = 'select Id from user where id = \''+usr.Id+'\'';
        Database.executeBatch(batch);
        Test.stopTest();
        
        Map<Id, Referral_Source_Audit__c> idsToMonthlyAssignment = new Map<Id, Referral_Source_Audit__c>();
        for(Referral_Source_Audit__c rsa : [select contact__c, account__c, status__c, request_date__c from Referral_Source_Audit__c where user__c = :usr.Id and request_date__c = this_month]){
            if(rsa.account__c!=null)idsToMonthlyAssignment.put(rsa.Account__c, rsa);
            else if(rsa.contact__c!=null)idsToMonthlyAssignment.put(rsa.Contact__c, rsa);
        }
        
        
    }
    
    static testMethod void runScheduledJob() {
        User usr = [select Id from user where Email='KAHSalesAssociate@testorg.com'];
        
        Sales_AssignmentSnapshotScheduled job = new Sales_AssignmentSnapshotScheduled();
        job.query = 'select id from user where id=\''+usr.Id+'\'';
        Test.startTest();
        System.schedule('AssignmentSnapshotScheduledTest', '0 0 1 * * ?', job);
        Test.stopTest();
    }
    */
}