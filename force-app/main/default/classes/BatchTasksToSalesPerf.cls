global class BatchTasksToSalesPerf  implements Database.Batchable<sObject>{
    //global string query;
    global string query = 'select id from task where sales_performance_id__c = null and activitydate >= 2015-01-01';
        
    //execute this batch job (example below) in an execute anonymous window
    //comsider setting the query to include certain profiles instead of all users because the default (shown above) can likely fail
    //an example execution is below
    
    //Batch sizes of 150 may run in  your org
    //but if it fails due to govener run again with smaller batch sizes
    
    /*
     BatchTasksToSalesPerf taskBatch = new BatchTasksToSalesPerf();
     taskBatch.query ='select Id from task where Owner.Profilt.Name = \'KHRS Liaison\'';
     Database.executeBatch(taskBatch, 100);

     or 

     BatchTasksToSalesPerf taskBatch = new BatchTasksToSalesPerf();
     Database.executeBatch(taskBatch, 100);
    */
    
    //Note the batch size above is set to 100
    //Also note that the bottom method of the two will utilize the default query located above
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }//end QueryLocator

    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Task> tasks = new List<Task>();
        
        for(sObject s : scope){
            Task t = (Task)s;
            tasks.add(t);
        }
        
        
        Map<Id, Task> TaskIdToTasks = new Map<Id, Task>();
        Map<Id, String> TaskIdToSPIds = new Map<Id, String>();
        Set<String> SPIds = new Set<String>();
        
        
        for (Task t :[select Id, ownerId, ActivityDate from task where Id in :tasks]){
            TaskIdToTasks.put(t.Id, t);
            TaskIdToSPIds.put(t.id, t.ownerId + mmyyyy(t.ActivityDate));
            if (!SPIds.contains(t.ownerId + mmyyyy(t.ActivityDate))) SPIds.add(t.ownerId + mmyyyy(t.ActivityDate));
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
            insertSPs.add(salesPerformance);
        }
        insert insertSPs;
        
        
        Map<String, Id> SPIdsToSPIds = new Map<String, Id>();
        for(Sales_Performance__c sp : [select Id, Sales_Performance_ID__c from Sales_Performance__c where Sales_Performance_ID__c in :AllSPIds]){
            SPIdsToSPIds.put(sp.Sales_Performance_Id__c, sp.Id);
        }
        
        List<Task> updateTasks = new List<Task>();
        
        for (Task t : TaskIdToTasks.values()){
            if(SPIdsToSPIds.containsKey(TaskIdToSPIds.get(t.Id))){
                t.Sales_Performance_ID__c = SPIdsToSPIds.get(TaskIdToSPIds.get(t.Id));
                updateTasks.add(t);
            }
        }
        
        
        update updateTasks;
        
        
        
        tasks = [select id, Sales_Performance_ID__c from task where Sales_Performance_ID__c in :AllSPIds and IsRecurrence != true];
        tasks = [select id, Sales_Performance_ID__c from task where Sales_Performance_ID__c in :AllSPIds and IsRecurrence != true];
        
        List<Sales_Performance__c> updateSPs = new List<Sales_Performance__c>();
        
        for (Sales_Performance__c sp : [select id, Sales_Calls__c from Sales_Performance__c where Sales_Performance_Id__c in : AllSPIds]){
            sp.Sales_Calls__c = getTasksAndTasksTotal(sp.Id, tasks);
            updateSPs.add(sp);
        }
        
        update updateSPs;
        
        

    }//end execute
    
    public static string mmyyyy(Date d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }//end mmyyyy
    
    public static Integer getTasksAndTasksTotal(Id spId, List<Task> tasks){
        Integer tasksAndTasksTotal = 0;
        for (Task t : tasks){
            if (t.Sales_Performance_ID__c == spId) tasksAndTasksTotal++;
        }
        return tasksAndTasksTotal;
    }

    global void finish(Database.BatchableContext bc) {
        
    }//end finish
}