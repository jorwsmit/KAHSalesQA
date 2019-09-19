@isTest(SeeAllData=false)
public class TestScheduleBatchSP4NextYear {
    static testmethod void test() {
        final id Sales_HD_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID; 
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com');
        insert usr;
        
        for (Sales_Performance__c sp : [select OwnerId from Sales_Performance__c where OwnerId = :usr.Id]){
            delete sp;
        }
        
        Datetime currentDatetime = System.now();
        
        Test.startTest();
        ScheduleBatchSP4NextYear job = new ScheduleBatchSP4NextYear();   
        job.query = 'select Id, ProfileId from user where Id = \''+usr.Id+'\'';
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, job);
        //explicitly calling the batch job so that it fully executes after stopTest
        //Without this the scheduled job that calls the batch finishes executing
        //but the batch job does not
        BatchCreate12SalesPerf4NextYear batch = new BatchCreate12SalesPerf4NextYear();
        batch.query = 'select Id, ProfileId from user where Id = \''+usr.Id+'\'';
        Database.executeBatch(batch);
        Test.stopTest();
        System.assert([select count() from Sales_Performance__c where ownerId = :usr.Id] == 12);
        
    }
    
    public static string mmyyyy(Datetime d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }//end mmyyyy
}