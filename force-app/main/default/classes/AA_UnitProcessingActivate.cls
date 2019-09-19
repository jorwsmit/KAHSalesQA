global class AA_UnitProcessingActivate implements Database.Batchable<sObject>, Database.Stateful{
	
	global list<Account_Unit__c> toProcess;
	
	global Iterable<sObject> start(Database.BatchableContext info){
        return toProcess;
    	}
    
    global AA_UnitProcessingActivate(list<Account_Unit__c> lst){
    	toProcess = lst;
    	}
    	
    global void execute(Database.BatchableContext info, List<Account_Unit__c> scope){
        list<Account_Unit__c> toInsert = new list<Account_Unit__c>();
        for(Account_Unit__c au : scope){
        	toInsert.add(au);
        	}
        insert toInsert;
    	}    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    	}
    
}