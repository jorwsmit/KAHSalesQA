@isTest
private class AA_KRSOpportunityStageHistoryTest {

    static testMethod void myUnitTest() {
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        
        Account objAccount = new Account(Name ='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
        insert objAccount;
        
        Opportunity opp = new Opportunity(Name = objAccount.Name + ' OpportunityTest', StageName='Qualification',
                                          CloseDate=System.today().addMonths(1),AccountId = objAccount.Id);
        insert opp;
        
        KRS_OppStageHistory__c testHist = new KRS_OppStageHistory__c(Amount__c = decimal.valueOf('7000'),
                                                                     Close_Date__c = system.today(),
                                                                     Expected_Rev__c = decimal.valueOf('5000'),
                                                                     Forecast_Category__c = 'Test Category',
                                                                     Opportunity__c = opp.ID,
                                                                     Probability__c = decimal.valueOf('.30'),
                                                                     Stage__c = 'Prospecting',
                                                                     User__c = userInfo.getUserId()
                                                                     );
        insert testHist;
        
        
        AA_KRSOpportunityStageHistory.getStageHistory(opp.Id); 
        
        }
}