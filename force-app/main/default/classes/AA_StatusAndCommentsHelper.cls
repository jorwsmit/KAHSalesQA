public with sharing class AA_StatusAndCommentsHelper {
    
    @future 
    public static void updateAccounts(set<ID> accountIDs){
    	
    	list<Account> toUpdate = new list<Account>();
    	toUpdate = [SELECT ID, Status_Comments_Last_Updated__c FROM Account WHERE ID IN: accountIDs];
    	
    	for(Account a : toUpdate){
    		a.Status_Comments_Last_Updated__c = system.now();
    		}
    	update toUpdate;	
    	}
    	
    @future 
    public static void updateContacts(set<ID> contactIDs){
    	
    	list<Contact> toUpdate = new list<Contact>();
    	toUpdate = [SELECT ID, Status_Comments_Last_Updated__c FROM Contact WHERE ID IN: contactIDs];
    	
    	for(Contact a : toUpdate){
    		a.Status_Comments_Last_Updated__c = system.now();
    		}
    	update toUpdate;	
    	}
    	
    @future 
    public static void updateOpportunities(set<ID> oppIDs){
    	
    	list<Opportunity> toUpdate = new list<Opportunity>();
    	toUpdate = [SELECT ID, Status_Comments_Last_Updated__c FROM Opportunity WHERE ID IN: oppIDs];
    	
    	for(Opportunity a : toUpdate){
    		a.Status_Comments_Last_Updated__c = system.now();
    		}
    	update toUpdate;	
    	}
    	
    @future 
    public static void updateLeads(set<ID> leadIDs){
    	
    	list<Lead> toUpdate = new list<Lead>();
    	toUpdate = [SELECT ID, Status_Comments_Last_Updated__c FROM Lead WHERE ID IN: leadIDs];
    	
    	for(Lead a : toUpdate){
    		a.Status_Comments_Last_Updated__c = system.now();
    		}
    	update toUpdate;	
    	}			
    
}