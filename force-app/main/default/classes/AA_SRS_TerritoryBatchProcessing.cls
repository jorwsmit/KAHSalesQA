global class AA_SRS_TerritoryBatchProcessing implements Database.Batchable<sObject>, Database.Stateful{
 
	global list<Account> toProcess;
	
	global Iterable<sObject> start(Database.BatchableContext info){
        return toProcess;
    	}
    
    global AA_SRS_TerritoryBatchProcessing(list<Account> lst){
    	toProcess = lst;
    	}
    	
    global void execute(Database.BatchableContext info, List<Account> scope){
        list<Account> toUpdate = new list<Account>();
        for(Account a : scope){
        	a.KRS_SRS_BDO_Territory3__c = null;
        	toUpdate.add(a);
        	}
        update toUpdate;
    	}    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    	}
    
}