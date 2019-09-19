@isTest(SeeAllData=false)
public class TestBatchCreate12SalesPerf4NextYear {
    
    static testmethod void test() {    
        
        final id Sales_KHRS_Associate_ARU = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
        
        User usr = new User(Alias = 'test', Email='KHRSLiaison@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = Sales_KHRS_Associate_ARU, 
        TimeZoneSidKey='America/Los_Angeles', UserName='KHRSLiaison@testorg.com');
        insert usr;
        
        //this deletes all sales performances created by a trigger for the current year for the new user
        //the batch job creates them for next year so this isn't entirely necessary but further verifies the jobs effectiveness
        for (Sales_Performance__c sp : [select OwnerId from Sales_Performance__c where OwnerId = :usr.Id]){
            //System.debug('Found sp');
            delete sp;
        }
        
        Sales_Performance__c sp = new Sales_Performance__c(ownerId = usr.Id, 
                                      Month__c = Date.newinstance(System.now().year()+1, System.now().month(), 1));
        insert sp;
        
        Test.StartTest();
            BatchCreate12SalesPerf4NextYear insertSPs = new BatchCreate12SalesPerf4NextYear();
            insertSPs.query = 'select Id, ProfileId from user where id = \''+usr.Id+'\'';
            Database.executeBatch(insertSPs);
        Test.StopTest();
        
        for (Integer i=1; i<=12; i++){
                String salesPerformanceId = usr.Id + mmyyyy(Datetime.newInstance(date.newinstance(System.now().year()+1, i, 1), time.newInstance(12, 0, 0, 0)));
                System.assert([select Sales_Performance_ID__c from Sales_Performance__c where Sales_Performance_ID__c = :salesPerformanceId].size() == 1);
        }//end for loop months

    }//end test
    
    public static string mmyyyy(Datetime d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }//end mmyyyy
    
}//end TestBatchCreate12SalesPerf4NextYear