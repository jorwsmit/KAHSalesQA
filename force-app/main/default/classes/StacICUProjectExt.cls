//StacICUProjectExt returns a list of records on the users current account page that contain data from the ICU/CCU Location related list

global class StacICUProjectExt {


    private final Account acct;

    public StacICUProjectExt(ApexPages.StandardController stdController){
        this.acct = (Account)stdController.getRecord();
    	}
      
    @RemoteAction global static ICU_CCU_Location__c[] query(Id acctId){
        return [select Account__c, Discharge_Volume__c, ICU_Code__c, Unit__c from ICU_CCU_Location__c where Account__c = :acctId order by ICU_Code__c asc]; 
    	}   
}