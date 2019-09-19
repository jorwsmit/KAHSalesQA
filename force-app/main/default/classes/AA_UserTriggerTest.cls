@isTest
private class AA_UserTriggerTest {

    static testMethod void unitTest1() {
        final id Sales_HD_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: HD Associate'].ID;  
        User u = new User(Alias = 'test', Email='test@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
        TimeZoneSidKey='America/Los_Angeles', UserName='TestLiaison@testorg.com', perner__c = '9');
        
        Test.startTest();
            insert u;
            u.isActive = false;
            update u;
        Test.stopTest();
        }
        
        
    static testMethod void ByInsertingAUser() {
        final id Sales_HD_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: HD Associate'].ID;  
        
        User u = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
        TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', perner__c = '9');
        
        Test.startTest();
            insert u;
        Test.stopTest();
            for (Integer i=1; i<=12; i++){
                String salesPerformanceId = u.Id + mmyyyy(Datetime.newInstance(date.newinstance(System.now().year(), i, 1), time.newInstance(12, 0, 0, 0)));
                }
        }
    
     public static string mmyyyy(Datetime d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }    
}