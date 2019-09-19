@isTest 
private class AA_AutoDataValidationAlertTest {
	
	public static ID accID = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND developerName = 'Referring_Facility_Child'].ID;
	public static ID ctcID = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND developerName = 'General_Contact'].ID;

    static testMethod void myUnitTest(){
    	
        Account a = new Account(Name='TestAccount', RecordTypeId = accID, NPI__c = '12');
        Contact c = new Contact(LastName='TestContact', RecordTypeId = ctcID, NPI__c = '1263');
        
        insert a;
        insert c;
        
        String CRON_EXP = '0 0 * * * ?';
		AA_AutoDataValidationAlertScheduler sch = new AA_AutoDataValidationAlertScheduler();
		system.schedule('MonthlyEmailDataAlert', CRON_EXP, sch);
        }
        
}