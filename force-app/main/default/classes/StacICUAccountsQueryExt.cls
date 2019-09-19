//StacICUAccountsQueryExt is the controller for StacICUListAccounts and StacICUListAccounts_2
//queryAccounts returns a list of records from accounts with a specific ICU market
//queryAccount returns a record from accounts with a specific Id
//queryICU returns a records from ICU_CCU_Location__c by using the account id
//query returns returns a list of records from ICU_CCU_Location__c with a specific ICU market based on related account

global class StacICUAccountsQueryExt{


    @RemoteAction global static Account[] queryAccounts(String market){
        return [select Id, Name, ShippingAddress__c, Phone, ICU_CCU_Total__c, ICS_Tactical_Next_Steps__c from Account where ICU__c = true and ICU_Market__c = :market]; 
    	}
    
    @RemoteAction global static Account[] queryAccount(Id acctId){
        return [select Id, Name, ICU_CCU_Total__c, ICS_Tactical_Next_Steps__c from Account where Id = :acctId]; 
    	}   
    
    @RemoteAction global static ICU_CCU_Location__c[] queryICU(Id acctId){
        return [select Id, Account__r.name, Account__c, Discharge_Volume__c, ICU_Code__c, Unit__c from ICU_CCU_Location__c where Account__c = :acctId order by ICU_Code__c asc];
    	}

    
    @RemoteAction global static ICU_CCU_Location__c[] query(String market){
        return [select Account__r.name, Account__c, Discharge_Volume__c, ICU_Code__c, Unit__c from ICU_CCU_Location__c where Account__r.ICU_Market__c = :market order by ICU_Code__c asc]; 
    	}
    
    @RemoteAction global static boolean updateICU(String icuID, String unit){
        boolean success = true;
        icuID = icuID.remove('unit');
        ICU_CCU_Location__c icu = [select unit__c from ICU_CCU_Location__c where id=:icuID];
        icu.Unit__c = unit;
        try{
            update icu;
        	} 
        catch(Exception e){
            success = false;
        	}
        return success;
    	}
}