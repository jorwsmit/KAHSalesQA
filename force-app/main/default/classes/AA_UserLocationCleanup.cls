public class AA_UserLocationCleanup {
    
    static public void fetchRecords(){
    	list<UserLocation__c> toClear = new list<UserLocation__c>();
    	toClear = [SELECT ID, CreatedDate FROM UserLocation__c WHERE CreatedDate < LAST_N_DAYS:365 LIMIT 10000];
    	delete toClear;
    	}
    
    
}