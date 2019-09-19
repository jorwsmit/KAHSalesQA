trigger AA_PatientNewTrigger on Patient_New__c (after insert, after update){
    
    list<ID> ids = new list<ID>();
    
    for(Patient_New__c pn: trigger.new){
        ids.add(pn.ID);
        }
        
    AA_PatientNewTriggerHandler.updateTranscripts(ids);
    
}