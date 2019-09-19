global class BatchEventsToSalesPerf  implements Database.Batchable<sObject>{
    //global string query;
    //global string query = 'select Id, OwnerId, ActivityDateTime from events where Sales_Performance_ID__c = null';
    global string query = 'select id from event where sales_performance_id__c = null and calendar_year(activitydatetime) >= 2015';
        
    //execute this batch job (example below) in an execute anonymous window
    //comsider setting the query to include certain profiles instead of all users because the default (shown above) can likely fail
    //an example execution is below
    
    //Batch sizes of 150 may run in  your org
    //but if it fails due to govener run again with smaller batch sizes
    
    /*
     BatchEventsToSalesPerf eventBatch = new BatchEventsToSalesPerf();
     eventBatch.query ='select Id from event where Owner.Profile.Name = \'KHRS Liaison\'';
     Database.executeBatch(eventBatch, 100);

     or 

     BatchEventsToSalesPerf eventBatch = new BatchEventsToSalesPerf();
     Database.executeBatch(eventBatch, 100);
    */
    
    //Note the batch size above is set to 100
    //Also note that the bottom method of the two will utilize the default query located above
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }//end QueryLocator

    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Event> events = new List<Event>();
        List<Task> tasks = new List<Task>();
        RecordType recTypeId = [select id from recordType where name = 'Legacy'];
        
        for(sObject s : scope){
            Event e = (Event)s;
            events.add(e);
        }
        
        
        Map<Id, Event> EventIdToEvents = new Map<Id, Event>();
        Map<Id, String> EventIdToSPIds = new Map<Id, String>();
        Set<String> SPIds = new Set<String>();
        
        
        for (Event e :[select Id, ownerId, ActivityDateTime from event where Id in :events]){
            EventIdToEvents.put(e.Id, e);
            EventIdToSPIds.put(e.id, e.ownerId + mmyyyy(e.ActivityDateTime));
            if (!SPIds.contains(e.ownerId + mmyyyy(e.ActivityDateTime))) SPIds.add(e.ownerId + mmyyyy(e.ActivityDateTime));
        }
        
        Set<String> AllSPIds = SPIds.clone();
        
        List<String> listOfSPsToRemove = new List<String>();
        for (Sales_Performance__c sp : [select Sales_Performance_Id__c from Sales_Performance__c where Sales_Performance_Id__c in :SPIds]){
            listOfSPsToRemove.add(sp.Sales_Performance_Id__c);
        }
        
        SPIds.removeAll(listOfSPsToRemove);
        
        List<Sales_Performance__c> insertSPs = new List<Sales_Performance__c>();
        for (String SPId : SPIds){
            Sales_Performance__c salesPerformance = new Sales_Performance__c(Sales_Performance_ID__c = SPId);
            salesPerformance.Month__c = date.newinstance(Integer.valueOf(SPId.substring(20, 24)), Integer.valueOf(SPId.substring(18, 20)), 1);
            salesPerformance.OwnerId = SPId.substring(0, 18);
            salesPerformance.RecordTypeId = recTypeId.Id;
            insertSPs.add(salesPerformance);
        }
        insert insertSPs;
        
        
        Map<String, Id> SPIdsToSPIds = new Map<String, Id>();
        for(Sales_Performance__c sp : [select Id, Sales_Performance_ID__c from Sales_Performance__c where Sales_Performance_ID__c in :AllSPIds]){
            SPIdsToSPIds.put(sp.Sales_Performance_Id__c, sp.Id);
        }
        
        List<Event> updateEvents = new List<Event>();
        
        for (Event e : EventIdToEvents.values()){
            if(SPIdsToSPIds.containsKey(EventIdToSPIds.get(e.Id))){
                e.Sales_Performance_ID__c = SPIdsToSPIds.get(EventIdToSPIds.get(e.Id));
                updateEvents.add(e);
            }
        }
        
        
        update updateEvents;
        
        
        
        events = [select id, Sales_Performance_ID__c from event where Sales_Performance_ID__c in :AllSPIds and IsRecurrence != true];
        tasks = [select id, Sales_Performance_ID__c from task where Sales_Performance_ID__c in :AllSPIds and IsRecurrence != true];
        
        List<Sales_Performance__c> updateSPs = new List<Sales_Performance__c>();
        
        for (Sales_Performance__c sp : [select id, Sales_Calls__c from Sales_Performance__c where Sales_Performance_Id__c in : AllSPIds]){
            sp.Sales_Calls__c = getEventsAndTasksTotal(sp.Id, events);
            updateSPs.add(sp);
        }
        
        update updateSPs;
        
        

    }//end execute
    
    public static string mmyyyy(Datetime d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }//end mmyyyy
    
    public static Integer getEventsAndTasksTotal(Id spId, List<Event> events){
        Integer eventsAndTasksTotal = 0;
        for (Event e : events){
            if (e.Sales_Performance_ID__c == spId) eventsAndTasksTotal++;
        }
        return eventsAndTasksTotal;
    }

    global void finish(Database.BatchableContext bc) {
        
    }//end finish
}