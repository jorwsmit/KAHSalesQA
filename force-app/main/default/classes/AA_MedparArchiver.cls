public with sharing class AA_MedparArchiver {
    
    public static void archiveItems(){
    	list<HRS_MEDPAR__c> medList = new list<HRS_MEDPAR__c>();
    	string thisYear = string.valueOf(system.now().year());
    	system.debug('This Year: ' + thisYear);
    	string thisQuarter = AA_MEDPARController.getQuarter();
    	medList = [SELECT ID, Archived__c, Year__c, Quarter__c FROM HRS_MEDPAR__c WHERE ((Year__c <: thisYear) OR (Year__c =: thisYear AND Quarter__c <: thisQuarter)) AND Archived__c = false];
    	
    	for(HRS_MEDPAR__c hmed: medList){
    		hmed.Archived__c = true;
    		}
    		update medList;
    	
    	}    
    
}