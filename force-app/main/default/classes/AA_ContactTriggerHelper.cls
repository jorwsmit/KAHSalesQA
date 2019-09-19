public with sharing class AA_ContactTriggerHelper{
	
	@Future
	public static void processContacts(set<ID> ids){
		list<Contact> conToUpdate = new list<Contact>();
		for(Contact c: [SELECT ID, Merge_Master__c, Merge_Approved__c FROM Contact WHERE ID IN: ids AND Merge_Master__c = true]){
            		c.Merge_Master__c = false;
            		c.Merge_Approved__c = false;
            		conToUpdate.add(c);
            		}
            		update conToUpdate;
		}
    
}