public with sharing class AA_PatientNewTriggerHandler {
    
    static public void updateTranscripts(list<ID> ids){
        list<Patient_New__c> toFind = new list<Patient_New__c>();
        list<Case> toFindC = new list <Case>();
        map<ID, String> caseInfo = new map<ID, String>();
        list<LiveChatTranscript> toUpdate = new list<LiveChatTranscript>();
        list<ID> caseIds = new list<ID>();
        
        toFind = [SELECT ID, Status__c FROM Patient_New__c WHERE ID IN: ids];
        toFindC = [SELECT ID, Patient_New__c FROM Case WHERE Patient_New__c IN: ids];
        for(Patient_New__c pn : toFind){
            for(Case c : toFindC){
                if(pn.ID == c.Patient_New__c){
                    caseInfo.put(c.ID, pn.Status__c);
                    caseIds.add(c.ID);
                    }
                }
            }
        for(LiveChatTranscript lct: [SELECT ID, CaseID, Patient_New_Status__c FROM LiveChatTranscript WHERE CaseID IN: caseIds]){
            lct.Patient_New_Status__c = caseInfo.get(lct.CaseID);
            toUpdate.add(lct);
            }
        update toUpdate;
        }
    
}