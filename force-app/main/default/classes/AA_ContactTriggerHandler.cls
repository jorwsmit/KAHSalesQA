public with sharing class AA_ContactTriggerHandler{
    @future 
    public static void updateTranscript(list<ID> ids){
        list<Contact> toFind = new list<Contact>();
        list<Case> toFindC = new list <Case>();
        map<ID, String> caseInfo = new map<ID, String>();
        list<LiveChatTranscript> toUpdate = new list<LiveChatTranscript>();
        list<ID> caseIds = new list<ID>();
        
        toFind = [SELECT ID, Name FROM Contact WHERE ID IN: ids];
        toFindC = [SELECT ID, Contact.ID FROM Case WHERE Contact.ID IN: ids];
        for(Contact pn : toFind){
            for(Case c : toFindC){
                if(pn.ID == c.Contact.ID){
                    caseInfo.put(c.ID, pn.Name);
                    caseIds.add(c.ID);
                    }
                }
            }
        for(LiveChatTranscript lct: [SELECT ID, CaseID, Patient_New_Status__c FROM LiveChatTranscript WHERE CaseID IN: caseIds]){
            lct.Contact_Name__c = caseInfo.get(lct.CaseID);
            toUpdate.add(lct);
            }
        update toUpdate;
        }
        
    
}