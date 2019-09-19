@isTest
private class AA_AccountUnitContactTriggerTest {

    static testMethod void myUnitTest() {
        ID hdID = [SELECT ID, DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'HD_Accounts'].ID;
        Account a = new Account(Name = 'TestUnitAccount', RecordTypeID = hdID);
        insert a;
        
        Unit__c u = new Unit__c(Active__c = true, Active_Date__c = system.today(),
        Name = 'Test Unit', Meditech_ID__c = 'ewrwqr342342332');
        insert u;
        
        Unit__c u2 = new Unit__c(Active__c = true, Active_Date__c = system.today(),
        Name = 'Administrative', Meditech_ID__c = 'ewrwqr332');
        insert u2;
        
        Account_Unit__c au = new Account_Unit__c(Active__c= true,
        Unit__c = u.ID, Account__c = a.ID);
        insert au;
        
        Contact c = new Contact(LastName = 'LastName');
        insert c;
        
        Account_Unit_Contact__c auc = new Account_Unit_Contact__c(Contact__c = c.ID, Account_Unit__c = au.ID);
        insert auc;
        
        Account_Unit_Contact__c auc2 = new Account_Unit_Contact__c(Contact__c = c.ID, Account_Unit__c = au.ID);
        try{
            insert auc2;
            }
        catch(Exception E){
            system.debug('Error Catch worked');
            }   
        AA_HD_Unit_Controller.getUnits(a.ID);
        
        Account a2 = new Account(Name = 'TestUnitAccount2', RecordTypeID = hdID);
        insert a2;
        }
}