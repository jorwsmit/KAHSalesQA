global class AA_MedparBatchable implements Database.Batchable<ID>, Database.Stateful{
    
	global list<ID> toProcess;
	
	global Iterable<ID> start(Database.BatchableContext info){
        return toProcess;
    	}
    
    global AA_MedparBatchable(list<ID> lst){
    	toProcess = lst;
    	}
    	
    global void execute(Database.BatchableContext info, List<ID> scope){
        list<HRS_MEDPAR__c> mds = new list<HRS_MEDPAR__c>();
		mds = [SELECT ID, Account__c, IRF_Occupancy_Rank__c, IRF_Potential_Rank__c FROM HRS_MEDPAR__c WHERE ID IN: scope];
		list<ID> accIDs = new list<ID>();
		
		for(HRS_MEDPAR__c m: mds){
			accIDs.add(m.Account__c);
			}
		
		list<Account> accs = new list<Account>();
		set<Account> toProcess = new set<Account>();
		list<Account> toUpdate = new list<Account>();
		
		accs = [SELECT ID, SRS_IRF_Occupancy_Rank__c, SRS_IRF_Potential_Rank__c FROM Account WHERE ID IN: accIDs];
		for(Account a: accs){
			for(HRS_MEDPAR__c m: mds){
			if(m.Account__c == a.ID){
				a.SRS_IRF_Occupancy_Rank__c = m.IRF_Occupancy_Rank__c;
				a.SRS_IRF_Potential_Rank__c = m.IRF_Potential_Rank__c;
				}
			toProcess.add(a);
			}
			}
			toUpdate.addAll(toProcess);
			update toUpdate;
    	}    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    	}
    

}