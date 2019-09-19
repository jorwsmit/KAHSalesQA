trigger AA_CaseTrigger on Case (after insert, after update){
	
	list<ID> caseIDs = new list<ID>();
	set<ID> caseSet = new set<ID>();
	
	ID afterHoursCase = AA_UtilityClass.getCaseAfterHoursID;
	
	if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
		for(Case c: trigger.new){
			if(c.Case_Notes__c != null){
				caseSet.add(c.ID);
				}
			}
			if(caseSet.size() > 0){
				caseIDs.addAll(caseSet);
				AA_CaseNotesHelper.processNotes(caseIDs);
				}
			list<ID> toProcess = new list<ID>();
			if(trigger.isInsert){
				for(Case c : trigger.new){
					system.debug('After Hours: ' + boolean.valueOf(c.RecordTypeID == afterHoursCase));
					if(c.RecordTypeID == afterHoursCase){
						toProcess.add(c.Id);
						}
					}
				if(toProcess.size() > 0){
					AA_CaseEntryController.createContactAccountPatient(toProcess);
					}
				}
		}
}