@isTest
private class TBN_TestBatchToUpdateAccountStatus{

  private static testMethod void AccountStatusbatch() {
        
        RecordType rtAccount1 = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
        RecordType rtAccount2 = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Client' Limit 1];
      
        Account objAccount = new Account(name='test Account', PF_Last_Date_of_Service__c = Date.TODAY()-1, recordTypeId = rtAccount1.Id);
        insert objAccount;
        
        Account objAccount1 = new Account(name='test Account', PF_Last_Date_of_Service__c = Date.TODAY()-2, recordTypeId = rtAccount2.Id);
        insert objAccount1;
        
        Account objAccount2 = new Account(name='test Account', PF_Last_Date_of_Service__c = Date.TODAY()+2, recordTypeId = rtAccount2.Id);
        insert objAccount2;
        
        TBN_BatchToUpdateAccountStatus objBatch = new TBN_BatchToUpdateAccountStatus();
        test.startTest();
        Database.executeBatch(objBatch);
        test.stopTest();
        
        system.assertEquals([select Status__c from Account where id=:objAccount1.id].Status__c, 'Inactive');
        system.assertEquals([select Status__c from Account where id=:objAccount2.id].Status__c, 'Active');
  }
  private static testMethod void AccountStatusSchedular() {
  
        Test.startTest();
        system.schedule('Test Schedular', '0 0 0  * * ?', new TBN_Schedular_BatchtoUpdateAccountStatus());
        Test.stopTest();
  }
}