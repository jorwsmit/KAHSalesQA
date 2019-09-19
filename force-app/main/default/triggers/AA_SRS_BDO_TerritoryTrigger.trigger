trigger AA_SRS_BDO_TerritoryTrigger on SRS_BDO_Territory__c(after insert, after update){
	
	ID srsAccount = AA_UtilityClass.getKRSStandardID;
	ID srsLead = AA_UtilityClass.getSRSLead;
   	
	list<String> states = new list<String>();
	set<String> cleanStates = new set<String>();
	if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
		for(ID sbtID : trigger.newMap.keySet()){
			try{
				if((trigger.oldMap.get(sbtID).States__c != null && trigger.newMap.get(sbtID).States__c != null) && (trigger.oldMap.get(sbtID).States__c != trigger.newMap.get(sbtID).States__c)){
					string str = trigger.newMap.get(sbtID).States__c;
					string str2 = trigger.oldMap.get(sbtID).States__c;
					list<String> listNew = new list<String>();
					list<String> listNew2 = new list<String>();
					listNew = str.split(';');
					listNew2 = str2.split(';');
					for(string s : listNew){
						cleanStates.add(s);
						}
					for(string s : listNew2){
						cleanStates.add(s);
						}	
					}
				}
			catch(Exception err){
				system.debug('States null');
				}
			}
			if(cleanStates.size() > 0){
				states.addAll(cleanStates);
				system.debug('States: ' + states);
				list<Account> accList = new list<Account>();
				list<Lead> leadList = new list<Lead>();
				system.debug('accList: ' + accList.size());
				accList = [SELECT ID, 
							      Name 
						   		  FROM Account 
								  WHERE RecordTypeID =: srsAccount
								  AND BillingState IN: cleanStates 
						   		  AND KRS_RHB_Business_Unit__c = 'SRS'];
				set<Account> cleanAccounts = new set<Account>();
				cleanAccounts.addAll(accList);						   		  
			    list<Account> batchAccounts = new list<Account>();
			    batchAccounts.addAll(cleanAccounts);						   		  		   
				leadList = [SELECT ID, 
								  Name 
						   FROM Lead 
						   WHERE RecordTypeId =: srsLead 
						   ];
						   system.debug('leadList: ' + leadList.size());
					if(!test.isRunningTest()){
						AA_SRS_TerritoryBatchProcessing bc = new AA_SRS_TerritoryBatchProcessing(batchAccounts);
                		Database.executeBatch(bc, 50);
                		AA_SRS_TerritoryBatchProcessingContact bcc = new AA_SRS_TerritoryBatchProcessingContact(batchAccounts);
                		Database.executeBatch(bcc, 50);
                		}
            }
		}
}