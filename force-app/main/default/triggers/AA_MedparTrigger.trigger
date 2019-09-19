trigger AA_MedparTrigger on HRS_MEDPAR__c(after insert, after update){
	
	if(trigger.isUpdate){
		set<ID> updateSet = new set<ID>();
		for(ID mID : trigger.newMap.keySet()){
			if((!trigger.oldMap.get(mID).IRF_Occupancy_Rank__c.isWhitespace() && !trigger.newMap.get(mID).IRF_Occupancy_Rank__c.isWhitespace()) && trigger.newMap.get(mID).Archived__c == false){
					updateSet.add(mID);
				}
			if((!trigger.oldMap.get(mID).IRF_Potential_Rank__c.isWhitespace() && !trigger.newMap.get(mID).IRF_Potential_Rank__c.isWhitespace()) && trigger.newMap.get(mID).Archived__c == false){
					updateSet.add(mID);
				}
			}
			list<ID> updateList = new list<ID>();
			updateList.addAll(updateSet);
			AA_MedparBatchable bc = new AA_MedparBatchable(updateList);
	        Database.executeBatch(bc,50);
		}
		
	if(trigger.isInsert){
		set<ID> updateSet = new set<ID>();
		for(HRS_MEDPAR__c m: trigger.new){
			if(m.IRF_Occupancy_Rank__c != null){
				updateSet.add(m.ID);
				}
			if(m.IRF_Potential_Rank__c != null){
				updateSet.add(m.ID);
				}
			}
			list<ID> insertList = new list<ID>();
			insertList.addAll(updateSet);
			AA_MedparBatchable bc = new AA_MedparBatchable(insertList);
	        Database.executeBatch(bc,50);
		}	
    
}