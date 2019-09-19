@isTest
private class TBN_TestRollUpSummaryBatch{
    
    static testMethod void testContactMetrics(){
        /** creating the test data */
        Account acc = new Account(Name = 'TestAccount');    
        insert  acc;
    
        Contact con = new Contact(LastName = 'TestContact', AccountId = acc.Id); 
        insert con;
    
        Sales_Contact_Metrics__c objConMetric = new Sales_Contact_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, Contact__c = con.Id, Month__c =  system.today());
        insert objConMetric;
                                                                          
        Sales_Account_Metrics__c objAccMetric = new Sales_Account_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, Account__c = acc.Id, Month__c = system.today());
        insert objAccMetric;
        
        Test.startTest(); 
        
        /** processing the test data */
        TBN_RollUpSummaryBatch objRollupsummary = new TBN_RollUpSummaryBatch('Sales_Contact_Metrics__c',2);
        
        TBN_ScheduleBatch.scheduleBatchDaily('Sales_Contact_Metrics__c',2);
        
        Database.executeBatch(objRollupsummary,5); 
        
        Test.stopTest();
        
        }
    
    static testMethod void testAccountMetrics(){
        /** creating the test data */
        Account acc = new Account(Name = 'TestAccount');    
        insert  acc;
    
        Contact con = new Contact(LastName = 'TestContact', AccountId = acc.Id); 
        insert con;
    
        Sales_Contact_Metrics__c objConMetric = new Sales_Contact_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, 
                                                                             KAH_HH_Discounted_Qualified_Admits__c = 23, KAH_HP_Qualified_Admits__c = 55,
                                                                             KAH_HH_PPS_Admits__c = 53,
                                                                             Contact__c = con.Id, Month__c =  system.today());
        insert objConMetric;
                                                                          
        Sales_Account_Metrics__c objAccMetric = new Sales_Account_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, 
                                                                             KAH_HH_Discounted_Qualified_Admits__c = 23, KAH_HP_Qualified_Admits__c = 55,
                                                                             KAH_HH_PPS_Admits__c = 53,
                                                                             Account__c = acc.Id, Month__c =  system.today());
        insert objAccMetric;
        
        Test.startTest(); 
        /** processing the test data */
        TBN_RollUpSummaryBatch objRollupsummary = new TBN_RollUpSummaryBatch('Sales_Account_Metrics__c',2);
        TBN_ScheduleBatch.scheduleBatchDaily('Sales_Account_Metrics__c',2);
        Database.executeBatch(objRollupsummary,5);
        Test.stopTest();
        
        }
    
    static testmethod void testinitialBatch(){
        Account acc = new Account(Name = 'TestAccount');    
        insert  acc;
    
        Contact con = new Contact(LastName = 'TestContact', AccountId = acc.Id); 
        insert con;
        
        Sales_Contact_Metrics__c objConMetric = new Sales_Contact_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, Contact__c = con.Id, Month__c = system.today());
        insert objConMetric;
                                                                          
        Sales_Account_Metrics__c objAccMetric = new Sales_Account_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, Account__c = acc.Id, Month__c = system.today());
        insert objAccMetric;
        
        Sales_Contact_Metrics__c objConMetric2 = new Sales_Contact_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, Contact__c = con.Id, Month__c = system.today()-365);
        insert objConMetric2;
                                                                          
        Sales_Account_Metrics__c objAccMetric2 = new Sales_Account_Metrics__c(KAH_HP_Referrals__c = 15, KAH_HP_Admits__c = 16,
                                                                             KAH_HH_Referrals__c = 17, KAH_HH_Admits__c = 18, Account__c = acc.Id, Month__c = system.today()-365);
        insert objAccMetric2;
        
        Test.startTest(); 
        
        TBN_BatchToRollupInitialMetrics objRollupsummary = new TBN_BatchToRollupInitialMetrics('Sales_Account_Metrics__c');
        
        TBN_ScheduleBatch.scheduleBatchDaily('Sales_Account_Metrics__c',2);
        
        Database.executeBatch(objRollupsummary,10);
        
        Test.stopTest();
    }
    
}