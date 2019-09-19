@isTest
private class AA_SRS_TerritoryBatchProcessingTest {

    static testMethod void myUnitTest() {
        
        list<Account>lstAccount = new list<Account>();
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        
        Account objAccount = new Account(Name='TestAccount');
        lstAccount.add(objAccount);
        
        Account objAccount2 = new Account(Name='TestAccount2');
        lstAccount.add(objAccount2);
        
        Account objAccount5 = new Account(Name='TestAccount5');
        lstAccount.add(objAccount5);
        
        Account objAccount6 = new Account(Name='TestAccount6');
        lstAccount.add(objAccount6);
        
        Account objAccount7 = new Account(Name='TestAccount7');
        lstAccount.add(objAccount7);
        
        Account objAccount8 = new Account(Name='TestAccount8');
        lstAccount.add(objAccount8);
        
        Account objAccount9 = new Account(Name='TestAccount9');
        lstAccount.add(objAccount9);
        
        Account objAccount10 = new Account(Name='TestAccount10');
        lstAccount.add(objAccount10);
        
        Account objAccount11 = new Account(Name='TestAccount11');
        lstAccount.add(objAccount11);
        
        Account objAccount12 = new Account(Name='TestAccount12');
        lstAccount.add(objAccount12);
        
        Account objAccount3 = new Account(Name='TestAccount3');
        lstAccount.add(objAccount3);
        
        Account objAccount4 = new Account(Name='TestAccount4');
        insert objAccount4;
        
        insert lstAccount;
        
        AA_SRS_TerritoryBatchProcessing bc = new AA_SRS_TerritoryBatchProcessing(lstAccount);
        Database.executeBatch(bc, 50);
        
    	}
    	
    static testMethod void myUnitTest2() {
    	
    	list<Lead>lstLead = new list<Lead>();
        
        List<RecordType> lstRecTypesLead = [Select Name, Id From RecordType where sObjectType='Lead' AND isActive = true];
        
        Lead objLead = new Lead(Company = 'TestLead', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead);
		
		Lead objLead2 = new Lead(Company = 'TestLead2', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead2);
		
		Lead objLead5 = new Lead(Company = 'TestLead5', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead5);
		
		Lead objLead6 = new Lead(Company = 'TestLead6', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead6);
		
		Lead objLead7 = new Lead(Company = 'TestLead7', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead7);
		
		Lead objLead8 = new Lead(Company = 'TestLead8', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead8);
		
		Lead objLead9 = new Lead(Company = 'TestLead9', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead9);
		
		Lead objLead10 = new Lead(Company = 'TestLead10', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead10);
		
		Lead objLead11 = new Lead(Company = 'TestLead11', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead11);
		
		Lead objLead12 = new Lead(Company = 'TestLead12', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead12);
		
		Lead objLead13 = new Lead(Company = 'TestLead13', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead13);
		
		insert lstLead;
    	
    	AA_SRS_TerritoryBatchProcessing2 bc2 = new AA_SRS_TerritoryBatchProcessing2(lstLead);
        Database.executeBatch(bc2,50);
    	}	
}