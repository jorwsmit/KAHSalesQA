public with sharing class AA_HRSTaskandEventHelper{
	@future 
	public static void processItems(list<ID> processList){
		
		list<Account> accToUpdate = new list<Account>();
		list<Contact> ctcToUpdate = new list<Contact>();
		list<Opportunity> oppToUpdate = new list<Opportunity>();
		list<Lead> leadToUpdate = new list<Lead>();
		
		set<Account> accClean = new set<Account>();
		set<Contact> ctcClean = new set<Contact>();
		set<Opportunity> oppClean = new set<Opportunity>();
		set<Lead> leadClean = new set<Lead>();
		
		for(Account a : [SELECT ID, Activity_Last_Updated__c FROM Account WHERE ID IN: processList]){
			a.Activity_Last_Updated__c = system.now();
			accClean.add(a);
			}
			
		for(Contact c : [SELECT ID, Activity_Last_Updated__c FROM Contact WHERE ID IN: processList]){
			c.Activity_Last_Updated__c = system.now();
			ctcClean.add(c);
			}
			
		for(Opportunity o : [SELECT ID, Activity_Last_Updated__c FROM Opportunity WHERE ID IN: processList]){
			o.Activity_Last_Updated__c = system.now();
			oppClean.add(o);
			}
		
		for(Lead l : [SELECT ID, Activity_Last_Updated__c FROM Lead WHERE ID IN: processList]){
			l.Activity_Last_Updated__c = system.now();
			leadClean.add(l);
			}			
			
			accToUpdate.addAll(accClean);
			ctcToUpdate.addAll(ctcClean);
			oppToUpdate.addAll(oppClean);
			leadToUpdate.addAll(leadClean);
			
			if(accToUpdate.size() > 0){
				update accToUpdate;
				}
			if(ctcToUpdate.size() > 0){
				update ctcToUpdate;
				}
			if(oppToUpdate.size() > 0){
				update oppToUpdate;
				}
			if(leadToUpdate.size() > 0){
				update leadToUpdate;
				}			
		
		}
    
}