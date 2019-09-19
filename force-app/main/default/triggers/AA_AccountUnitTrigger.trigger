trigger AA_AccountUnitTrigger on Account_Unit__c (before insert) {
    
    list<ID> activeUnits = AA_UtilityClass.getActiveUnitIDList;
    list<ID> inactiveUnits = AA_UtilityClass.getInactiveUnitIDList;
    
    for(Account_Unit__c au : trigger.New){
    	if(inactiveUnits.contains(au.Unit__c)){
    		au.addError('You may not add this account unit.  The related master Unit record has been deactivated.');
    		}
    	}
    
}