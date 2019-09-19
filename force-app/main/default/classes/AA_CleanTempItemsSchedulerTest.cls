@isTest
private class AA_CleanTempItemsSchedulerTest {

    public static id caseTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Case' AND DeveloperName = 'caseTemp'].Id;
    public static id contactTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'contactTemp'].Id;
    public static id accountLacTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'accountLacTemp'].Id;
    public static id patientTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Patient_New__c' AND DeveloperName = 'patientTemp'].Id;
    public static id assessmentTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Assessment__c' AND DeveloperName = 'assessmentTemp'].Id;
    
    static testMethod void myUnitTest(){
        
        Case c = new Case(RecordTypeId = caseTempID);
        insert c;
        Case c2 = new Case(RecordTypeId = caseTempID);
        insert c2;
        Test.setCreatedDate(c.Id, DateTime.newInstance(system.today().year(),system.today().month(),system.today().day()-1));
        
        Contact ctc = new Contact(LastName = 'Test', RecordTypeID = contactTempID);
        insert ctc;
        Test.setCreatedDate(ctc.Id, DateTime.newInstance(system.today().year(),system.today().month(),system.today().day()-1));
        
        Account a = new Account(Name = 'Name', RecordTypeID = accountLacTempID);
        insert a;
        Test.setCreatedDate(a.Id, DateTime.newInstance(system.today().year(),system.today().month(),system.today().day()-1));
        
        Patient_New__c pt = new Patient_New__c(Last_Name__c = 'TestPatient', RecordTypeId = patientTempID);
        insert pt;
        Test.setCreatedDate(pt.Id, DateTime.newInstance(system.today().year(),system.today().month(),system.today().day()-1));
        
        Assessment__c assess = new Assessment__c(RecordTypeID = assessmentTempID, Patient__c = pt.ID);
        insert assess;
        Test.setCreatedDate(assess.Id, DateTime.newInstance(system.today().year(),system.today().month(),system.today().day()-1));
        
        Test.startTest();
        AA_CleanTempItemsScheduler sh1 = new AA_CleanTempItemsScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test TempCleaner Check', sch, sh1);
        Test.stopTest();
        
        }
}