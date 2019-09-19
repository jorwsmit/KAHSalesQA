trigger AA_HomeFacilityTrigger on Home_Facility__c (before insert, before update){
	
	if(trigger.IsBefore && (trigger.isInsert || trigger.isUpdate)){
		for(Home_Facility__c hf: trigger.new){
			if(hf.Historic_ID__c == null){
				hf.Historic_ID__c = hf.ID;
				}
			}
		}
    
}