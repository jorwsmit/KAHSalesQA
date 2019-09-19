@isTest
private class AA_MergeRequestTest {

    static testMethod void myUnitTest() {
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        list<Account>lstAccount = new list<Account>();
        
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
        lstAccount.add(objAccount);
        
        Account objAccount2 = new Account(Name='TestAccount2', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '123');
        lstAccount.add(objAccount2);
        
        Account objAccount5 = new Account(Name='TestAccount5');
        lstAccount.add(objAccount5);
        insert lstAccount;
        
        list<String> idLst = new list<String>();
        idLst.Add(objAccount5.ID);
        
        AA_MergeRequest.getStateList();
        AA_MergeRequest.assignProfileType();
        AA_MergeRequest.getAccount(objAccount.ID);
        AA_MergeRequest.getAccountItems('Test', objAccount.ID, 'San Francisco', 'CA');
        
        AA_MergeRequest.getAccountItems('Test', objAccount.ID, '', 'CA');
        AA_MergeRequest.getAccountItems('Test', objAccount.ID, 'San Francisco', '');
        AA_MergeRequest.getAccountItems('Test', objAccount.ID, '', '');
        
        AA_MergeRequest.getRequestMergeResult(idLst, objAccount.ID, null, null, 'Test Comments', 'account');
        
        AA_ApprovalReviewController.getApprovals();
        
        boolean bool1 = true;
        string unit1 = 'HRS';
        
        boolean bool2 = true;
        string unit2 = 'SRS';
        
        boolean bool3 = false;
        
        AA_MergeRequest.evalBusUnits(bool1, unit1);
        AA_MergeRequest.evalBusUnits(bool2, unit1);
        AA_MergeRequest.evalBusUnits(bool2, unit2);
        AA_MergeRequest.evalBusUnits(bool3, unit2);
        }
        
    static testMethod void unitTest2(){
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        list<Account>lstAccount = new list<Account>();
        
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
        lstAccount.add(objAccount);
        
        Account objAccount2 = new Account(Name='TestAccount2', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '123');
        lstAccount.add(objAccount2);
        
        Account objAccount5 = new Account(Name='TestAccount5');
        lstAccount.add(objAccount5);
        insert lstAccount;
        
        List<RecordType> lstRecTypesCon = [Select Name, Id From RecordType where sObjectType='Contact' AND isActive = true];
        list<Contact>lstContact = new list<Contact>();
        Contact objContact = new Contact(LastName='TestContact', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '1263', AccountID = objAccount.ID);
        lstContact.add(objContact);
        
        Contact objContact2 = new Contact(LastName='TestContact2', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '5123', AccountID = objAccount2.ID);
        lstContact.add(objContact2);
        
        Contact objContact3 = new Contact(LastName='TestContact3', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '7123', AccountID = objAccount5.ID);
        lstContact.add(objContact3);
        insert lstContact;
        
        list<String> idLst = new list<String>();
        idLst.Add(objContact3.ID);
        test.startTest();
        AA_MergeRequest.getContact(objContact.ID);
        
        AA_MergeRequest.getContactItems('Test', objContact.ID, 'San Francisco', 'CA');
        
        AA_MergeRequest.getContactItems('Test', objContact.ID, '', 'CA');
        AA_MergeRequest.getContactItems('Test', objContact.ID, 'San Francisco', '');
        AA_MergeRequest.getContactItems('Test', objContact.ID, '', '');
        
        AA_MergeRequest.getRequestMergeResult(idLst, null, objContact.ID, null, 'Test Comments', 'contact');
        AA_ApprovalReviewController.getApprovals();
        test.stopTest();
    	}
    	
    static testMethod void unitTest3(){
        list<Lead>lstLead = new list<Lead>();
        ID recordTypeHRS = AA_UtilityClass.getHRSLead;
        
        Lead objLead = new Lead(LastName='TestLead', Company = 'Test1', RecordTypeId = recordTypeHRS);
        lstLead.add(objLead);
        
        Lead objLead2 = new Lead(LastName='TestLead2', Company = 'Test2', RecordTypeId = recordTypeHRS);
        lstLead.add(objLead2);
        
        Lead objLead5 = new Lead(LastName='TestAccount5', Company = 'Test3', RecordTypeId = recordTypeHRS);
        lstLead.add(objLead5);
        insert lstLead;
        
        list<String> idLst = new list<String>();
        idLst.Add(objLead2.ID);
        test.startTest();
        AA_MergeRequest.getLead(objLead.ID);
        
        AA_MergeRequest.getContactItems('Test', objLead.ID, 'San Francisco', 'CA');
        
        AA_MergeRequest.getLeadItems('Test', objLead.ID, '', 'CA');
        AA_MergeRequest.getLeadItems('Test', objLead.ID, 'San Francisco', '');
        AA_MergeRequest.getLeadItems('Test', objLead.ID, '', '');
        
        AA_MergeRequest.getRequestMergeResult(idLst, null, null,objLead.ID, 'Test Comments', 'lead');
        AA_ApprovalReviewController.getApprovals();
        test.stopTest();
    	}	   
}