@isTest
private class AA_AccountUnitTriggerTest {

    static testMethod void myUnitTest() {
        
        ID hdType = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND developerName = 'HD_Accounts'].ID;
        
        Account a = new Account(Name = 'TestUnitAccount', RecordTypeID = hdType);
        insert a;
        
        Unit__c u = new Unit__c(Active__c = true, Active_Date__c = system.today(),
        Name = 'Test Unit', Meditech_ID__c = 'ewrwqr342342332');
        insert u;
        
        Unit__c u2 = new Unit__c(Active__c = true, Active_Date__c = system.today(),
        Name = 'Administrative', Meditech_ID__c = 'ewrwqr332');
        insert u2;
        
        Account_Unit__c au = new Account_Unit__c(Account__c = a.ID,
        										Active__c = true,
        										Unit__c = u.ID);
		insert au;
        
        u.Active__c = false;
        update u; 
        
        }
        
	static testMethod void myUnitTest2() {
        
        ID hdType = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND developerName = 'HD_Accounts'].ID;
        
        Account a = new Account(Name = 'TestUnitAccount', RecordTypeID = hdType);
        insert a;
        
        Unit__c u = new Unit__c(Active__c = true, Active_Date__c = system.today(),
        Name = 'Test Unit', Meditech_ID__c = 'ewrwqr342342332');
        insert u;
        
        Unit__c u2 = new Unit__c(Active__c = true, Active_Date__c = system.today(),
        Name = 'Administrative', Meditech_ID__c = 'ewrwqr332');
        insert u2;
        
        Unit__c u3 = new Unit__c(Active__c = false, Active_Date__c = system.today(),
        Name = 'Administrative', Meditech_ID__c = 'ewrwqr332');
        insert u3;
        
        Account_Unit__c au = new Account_Unit__c(Account__c = a.ID,
        										Active__c = true,
        										Unit__c = u3.ID);
		try{
			insert au;
			}
		catch(Exception e){
			system.debug('Error condition activated successfully.');
			}	        										
         
        
        }
                
}