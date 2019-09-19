global class AA_SRS_TerritoryBatchProcessingContact implements Database.Batchable<sObject>, Database.Stateful{
 
	global list<Account> toProcess;
	
	global Iterable<sObject> start(Database.BatchableContext info){
        return toProcess;
    	}
    
    global AA_SRS_TerritoryBatchProcessingContact(list<Account> lst){
    	toProcess = lst;
    	}
    	
    global void execute(Database.BatchableContext info, List<Account> scope){
    	list<ID> accIDs = new list<ID>();
    	for(Account a: scope){
    		accIDs.add(a.ID);
    		}
        list<Contact> toUpdate = new list<Contact>();
        list<Contact> cleanUpdate = new list<Contact>();
        list<Contact> processUpdate = new list<Contact>();
        toUpdate = [SELECT ID, OwnerID, Account.OwnerID FROM Contact WHERE AccountID IN: accIDs];
        for(Contact c : toUpdate){
        	c.OwnerID = c.Account.OwnerID;
        	cleanUpdate.add(c);
        	}
        processUpdate.addAll(cleanUpdate);	
        update processUpdate;
    	}    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    	}
    
}