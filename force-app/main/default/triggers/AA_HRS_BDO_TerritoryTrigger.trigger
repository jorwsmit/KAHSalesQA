trigger AA_HRS_BDO_TerritoryTrigger on HRS_BDO_Territory__c (after insert, after update) {
    ID srsAccount = AA_UtilityClass.getKRSStandardID;
	ID hrsLead = AA_UtilityClass.getHRSLead;
	
	list<String> states = new list<String>();
	set<String> cleanStates = new set<String>();
	if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
		for(ID sbtID : trigger.newMap.keySet()){
			try{
				if(trigger.oldMap.get(sbtID).US_Territories__c != null && trigger.newMap.get(sbtID).US_Territories__c != null){
					if(trigger.oldMap.get(sbtID).US_Territories__c != trigger.newMap.get(sbtID).US_Territories__c){
						string str = trigger.newMap.get(sbtID).US_Territories__c;
						list<String> listNew = new list<String>();
						listNew = str.split(';');
						for(string s : listNew){
							cleanStates.add(s);
							}
						}
					}
				}
			catch(Exception err){
				system.debug('US Territories Null');
				}
			try{	
				if(trigger.oldMap.get(sbtID).Outside_US_Territories__c != null && trigger.newMap.get(sbtID).Outside_US_Territories__c != null){
					if(trigger.oldMap.get(sbtID).Outside_US_Territories__c != trigger.newMap.get(sbtID).Outside_US_Territories__c){
						string str = trigger.newMap.get(sbtID).Outside_US_Territories__c;
						list<String> listNew = new list<String>();
						listNew = str.split(';');
						for(string s : listNew){
							cleanStates.add(s);
							}
						}	
					}
				}
			catch(Exception err2){
				system.debug('Non US Territories Null');
				}
			}
			if(cleanStates.size() > 0){
				system.debug('cleanStates: ' + cleanStates);
				states.addAll(cleanStates);
				list<Account> accList = new list<Account>();
				list<Lead> leadList = new list<Lead>();
				accList = [SELECT ID, 
								  Name 
						   FROM Account 
						   WHERE RecordTypeID =: srsAccount 
						   AND KRS_RHB_Business_Unit__c = 'HRS' 
						   ];
						   
				leadList = [SELECT ID, 
								  Name 
						   FROM Lead 
						   WHERE RecordTypeId =: hrsLead 
						   ];
						   system.debug('leadList: ' + leadList.size());
						if(!test.isRunningTest()){	   
							AA_SRS_TerritoryBatchProcessing bc = new AA_SRS_TerritoryBatchProcessing(accList);
	                		Database.executeBatch(bc,50);
    	            		AA_SRS_TerritoryBatchProcessing2 bc2 = new AA_SRS_TerritoryBatchProcessing2(leadList);
        	        		Database.executeBatch(bc2,50);
							}
							   
			}
		}
   
}