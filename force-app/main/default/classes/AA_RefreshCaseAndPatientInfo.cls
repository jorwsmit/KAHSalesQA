public with sharing class AA_RefreshCaseAndPatientInfo {
  
  public static void updateItems(){
  	
  	list<Case> cseUpdate = new list<Case>();
    list<Patient_New__c> ptUpdate = new list<Patient_New__c>();
    list<Contact> conUpdate = new list<Contact>();
    list<ID> ptIDs = new list<ID>();
    list<ID> conIDs = new list<ID>();	
    cseUpdate = [SELECT ID, Patient_New__c, Contact.ID, Level_Of_Care__c FROM Case WHERE CreatedDate = TODAY];	
  	
  	for(Case c: cseUpdate){
  		ptIDs.add(c.Patient_New__c);
  		conIDs.add(c.Contact.ID);
  		}
  	
  	ptUpdate = [SELECT ID FROM Patient_New__c WHERE ID IN: ptIDs];
  	conUpdate = [SELECT ID FROM Contact WHERE ID IN: conIDs];
  	
  	
  	update cseUpdate;
  	if(ptUpdate.size() > 0){
  	 	update ptUpdate;
  	 	}
  	 if(conUpdate.size() > 0){
  	 	update conUpdate;
  	 	}	
  	
  	}
    
}