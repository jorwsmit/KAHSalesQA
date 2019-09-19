public with sharing class AA_KRSOpportunityStageHistory {
    
    @AuraEnabled 
    public static list<KRS_OppStageHistory__c> getStageHistory(ID id){
        list<KRS_OppStageHistory__c> stageList = new list<KRS_OppStageHistory__c>();
        
        stagelist = [SELECT Amount__c,
                            Close_Date__c,
                            Expected_Rev__c,
                            Forecast_Category__c,
                            Opportunity__c,
                            Opportunity__r.Name,
                            Opportunity__r.Id,
                            Probability__c,
                            Stage__c,
                            User__c,
                            User__r.Name,
                            User__r.ID,
                            LastModifiedDate 
                            FROM KRS_OppStageHistory__c
                            WHERE Opportunity__r.Id =: id 
                            ORDER BY Close_Date__c ASC];
        
        return stageList;
        }
    
}