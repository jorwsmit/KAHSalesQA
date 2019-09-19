global class BatchSPIdUpdate implements Database.Batchable<sObject>{
    //global string query;
    global string query = 'select Id, OwnerId, Sales_Performance_Id__c, Month__c from Sales_Performance__c where Sales_Performance_Id__c = null';
        
    //execute this batch job (example below) in an execute anonymous window
    //an example execution is below
    
    //Batch sizes of 200 may run in  your org
    //but if it fails due to govener run again with smaller batch sizes
    
    /*
     BatchSPIdUpdate spIdBatch = new BatchSPIdUpdate();
     spIdBatch.query = 'select Id, OwnerId, Sales_Performance_Id__c, Month__c  from Sales_Performance__c where Sales_Performance_Id__c = null and Owner.Profile.Name = \'KHRS Liaison\'';
     Database.executeBatch(spIdBatch, 100);

     or 

     BatchSPIdUpdate spIdBatch = new BatchSPIdUpdate();
     Database.executeBatch(spIdBatch, 100);
    */
    
    //Note the batch size above is set to 100
    //Also note that the bottom method of the two will utilize the default query located above
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }//end QueryLocator

    global void execute(Database.BatchableContext bc, List<sObject> scope) {
  		List<Sales_Performance__c> SPs = new List<Sales_Performance__c>();
        
        for(sObject s : scope){
            Sales_Performance__c sp = (Sales_Performance__c)s;
            sp.Sales_Performance_Id__c = sp.OwnerId + mmyyyy(sp.Month__c);
            SPs.add(sp);
        }
        
        update SPs;

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
}