global class BatchCreate12SalesPerf4NextYear implements Database.Batchable<sObject> {
    //global string query;
    global string query = 'select Id, ProfileId from user';
    static final ID kahAssocID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
    static final ID kahManID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Manager'].ID;
    static final ID kahMarManID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Market Manager'].ID;
    static final ID kahCorSalesID = [SELECT ID, Name FROM Profile WHERE Name = 'KAH Corporate Sales'].ID;
    static final ID rtKAH = [SELECT ID, Name FROM RecordType WHERE sObjectType = 'Sales_Performance__c' AND DeveloperName = 'KAH'].ID;
    static final ID rtLegacy = [SELECT ID, Name FROM RecordType WHERE sObjectType = 'Sales_Performance__c' AND DeveloperName = 'Legacy'].ID;
    
    //execute this batch job (example below) in an execute anonymous window
    //set the query to include certain profiles instead of all users because the default (shown above) will most likely fail
    //an example execution is below
    
    //Batch sizes of 150 may run in  your org
    //but if it fails due to govener run again with smaller batch sizes
    
    /*
     Profile p = [select Id from profile where Name = 'KHRS Liaison'];
     BatchCreate12SalesPerf4NextYear insertSPs = new BatchCreate12SalesPerf4NextYear();
     insertSPs.query ='select Id, ProfileId from user where ProfileId = \''+p.Id+'\'';
     Database.executeBatch(insertSPs, 12);

     or

     BatchCreate12SalesPerf4NextYear insertSPs = new BatchCreate12SalesPerf4NextYear();
     insertSPs.query ='select Id, ProfileId from user where Profile.Name = \'KHRS Liaison\'';
     Database.executeBatch(insertSPs, 12);
    */
    
    //note the batch size above is set to 12
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }//end QueryLocator

    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        Set<String> newSpIds = new Set<String>();
        Map<Id, User> users = new Map<Id, User>();
        for(sObject s : scope){
            User u = (User)s;
            for (Integer i=1; i<=12; i++){
            	newSpIds.add(u.Id + mmyyyy(Date.newinstance(System.now().year()+1, i, 1)));
            }
            users.put(u.Id, u);
        }
        
        Set<String> preexistingSPs = new Set<String>();
        for (Sales_Performance__c sp : [select Id, Sales_Performance_ID__c from Sales_Performance__c where Sales_Performance_Id__c in :newSpIds]){
            preexistingSPs.add(sp.Sales_Performance_ID__c);
        }
        
        List<Sales_Performance__c> SPsToInsert = new List<Sales_Performance__c>();
        for(Id userId : users.keySet()){
            for (Integer i=1; i<=12; i++){
                //create sales_performance_id__c by using User ID + MM + YYYY
                //This is setting the YYYY portion of the ID to the current system time year+1
                //This is setting the MM portion of thr ID to i (1-12)
                String salesPerformanceId = userId + mmyyyy(date.newinstance(System.now().year()+1, i, 1));
                if(!preexistingSPs.contains(salesPerformanceId)){
                    Id rtId = rtLegacy;
                    if(users.get(userId).ProfileId == kahAssocID || users.get(userId).ProfileId == kahManID
                       || users.get(userId).ProfileId == kahMarManID || users.get(userId).ProfileId == kahCorSalesID) rtId = rtKAH;
                    Sales_Performance__c salesPerformance = new Sales_Performance__c(Sales_Performance_ID__c = salesPerformanceId,
                                                                                     Month__c = date.newinstance(System.now().year()+1, i, 1),
                                                                                    OwnerId = userId, RecordTypeId = rtId);
                    //add the new Sales Performance object for insertion
                    SPsToInsert.add(salesPerformance);
                }//end if
            }//end for 12 months
        }//end for s objects
        insert SPsToInsert;
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

    global void finish(Database.BatchableContext bc) {
        
    }//end finish
    
}//BatchCreate12SalesPerf4NextYear