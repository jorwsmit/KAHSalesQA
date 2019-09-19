global class AA_UnitProcessingDeactivate implements Database.Batchable<sObject>{
	
	global list<Account_Unit__c> toProcess;
	
	global Iterable<sObject> start(Database.BatchableContext info){
        return toProcess;
    	}
    
    global AA_UnitProcessingDeactivate(list<Account_Unit__c> lst){
    	toProcess = lst;
    	}
    	
    global void execute(Database.BatchableContext info, List<Account_Unit__c> scope){
        list<Account_Unit__c> toUpdate = new list<Account_Unit__c>();
        for(Account_Unit__c au : scope){
        	au.Active__c = false;
        	toUpdate.add(au);
        	}
        update toUpdate;
    	}    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    	}
    
}