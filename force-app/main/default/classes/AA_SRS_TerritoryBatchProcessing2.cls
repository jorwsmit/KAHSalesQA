global class AA_SRS_TerritoryBatchProcessing2 implements Database.Batchable<sObject>, Database.Stateful{
 
	global list<Lead> toProcess;
	
	global Iterable<sObject> start(Database.BatchableContext info){
        return toProcess;
    	}
    
    global AA_SRS_TerritoryBatchProcessing2(list<Lead> lst){
    	toProcess = lst;
    	}
    	
    global void execute(Database.BatchableContext info, List<Lead> scope){
        list<Lead> toUpdate = new list<Lead>();
        for(Lead l : scope){
        	l.KRS_SRS_BDO_Territory3__c = null;
        	toUpdate.add(l);
        	}
        update toUpdate;
    	}    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    	}
    
}