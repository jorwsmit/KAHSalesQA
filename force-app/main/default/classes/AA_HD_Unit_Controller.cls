public with sharing class AA_HD_Unit_Controller{
	
	@AuraEnabled(cacheable=true)
	public static list<unitWrapper> getUnits(ID id){
		list<unitWrapper> units = new list<unitWrapper>();
		
		list<ID> unitIDs = new list<ID>();
		list<ID> conIDs = new list<ID>();
		list<Account_Unit__c> accountUnits = new list<Account_Unit__c>();
		list<Contact> cons = new list<Contact>();
		try{
		accountUnits = [SELECT Account__c, Account__r.Name, Unit__c, Unit_Name__c, Active__c FROM Account_Unit__c WHERE Account__c =: id Order By Unit_Name__c];
		system.debug('accountUnits: ' + accountUnits);
		for(Account_Unit__c au: accountUnits){
			unitIDs.add(au.ID);
			}
		system.debug('unitIds: ' + unitIDs);	
		list<Account_Unit_Contact__c> unitContacts = new list<Account_Unit_Contact__c>();
		unitContacts = [SELECT Contact__c, Account_Unit__c, Unit_Name__c FROM Account_Unit_Contact__c WHERE Account_Unit__c IN : unitIDs];
		system.debug('unitContacts: ' + unitContacts);
		for(Account_Unit_Contact__c uc: unitContacts){
			conIDs.add(uc.Contact__c);
			}
		
		cons = [SELECT Name, ID, Title, Email FROM Contact WHERE ID IN: conIDs];	
		system.debug('cons: ' + cons);
		for(Account_Unit__c un: accountUnits){
			list<Contact> consTemp = new list<Contact>();
			for(Account_Unit_Contact__c uc: unitContacts){
				if(uc.Account_Unit__c == un.ID){
					for(Contact c : cons){
						if(c.ID == uc.Contact__c){
							consTemp.add(c);
							}
						}
					}
				}
			units.add(new unitWrapper(un.Unit_Name__c, consTemp, un.Active__c));
			}
		system.debug('units: ' + units);	
		return units;
		}
	catch(Exception E){
			system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			return null;
			}	
		}
		
	public class unitWrapper{
		@AuraEnabled
		public list<Contact> ctcsUnit	{get;set;}
		@AuraEnabled
		public string accUnit	{get;set;}
		@AuraEnabled
		public string accUnitStatus	{get;set;}
		
		public unitWrapper(string accUnit, list<Contact> ctcsUnit, boolean accUnitStatus){
			this.accUnit = accUnit;
			this.ctcsUnit = ctcsUnit;
			if(accUnitStatus == true){
				this.accUnitStatus = 'Active';
				}
			else{
				this.accUnitStatus = 'Inactive';
				}	
			}
		}	
    
}