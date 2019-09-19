@isTest(SeeAllData=false)
public class TestBatchSPIdUpdate {
    static testmethod void test() {
        final id Sales_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
        
        User usr = new User(Alias = 'test', Email='KAHSaleAssociate@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_KAH_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSaleAssociate@testorg.com', Perner__c = '08757453543235256561');
        
        Test.startTest();
            insert usr;
        Test.stopTest();
        
        Date currentDate = Date.newInstance(System.now().year(), System.now().month(), System.now().day());
        
        BatchSPIdUpdate spIdBatch = new BatchSPIdUpdate();
            spIdBatch.query = 'select Id, OwnerId, Sales_Performance_Id__c, Month__c from Sales_Performance__c where OwnerId = \''+usr.Id+'\'';
            Database.executeBatch(spIdBatch, 200);
        
        Sales_Performance__c sp = [select Sales_Performance_Id__c from Sales_Performance__c where OwnerId = :usr.Id 
                                        and Month__c = :date.newInstance(currentDate.year(), currentDate.month(), 1)];
        String SPIdAfter = sp.Sales_Performance_Id__c;
        System.assert([select Sales_Performance_Id__c from Sales_Performance__c where OwnerId = :usr.Id].size() == 12);
        System.assert(sp.Sales_Performance_Id__c != null);   
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