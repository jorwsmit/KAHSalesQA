global class Create12SalesPerf4NewUserBatch implements Database.Batchable<String> {
    Map<String, String> SPIdToRecordTypeId = new Map<String, String>();
    global Create12SalesPerf4NewUserBatch(Map<String, String> SPIdToRecordTypeIdFromTrigger) {
        SPIdToRecordTypeId.putAll(SPIdToRecordTypeIdFromTrigger);
    }
    
    global Iterable<String> start(Database.BatchableContext BC) {
        List<String> SPIds = new List<String>();
        for (String SPId : SPIdToRecordTypeId.keySet()){
        	SPIDs.add(SPId);   
        }
        return SPIDs;
    }
      
    global void execute(Database.BatchableContext info, List<String> SPIds) {
        List<Sales_Performance__c> SPs = new List<Sales_Performance__c>();
        for (String SPId : SPIds){
            Sales_Performance__c salesPerformance = new Sales_Performance__c(Sales_Performance_ID__c = SPId);
            salesPerformance.Sales_Calls__c = 0;
            salesPerformance.Month__c = date.newinstance(Integer.valueOf(SPId.substring(20, 24)), Integer.valueOf(SPId.substring(18, 20)), 1);
            salesPerformance.OwnerId = SPId.substring(0, 18);
            salesPerformance.RecordTypeId = SPIdToRecordTypeId.get(SPId);
            //add the new Sales Performance object to a list to be inserted
            SPs.add(salesPerformance);
        }
        insert SPs;
    }
    
    global void finish(Database.BatchableContext BC) {}
}