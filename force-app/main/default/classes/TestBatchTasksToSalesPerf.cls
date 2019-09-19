@isTest(SeeAllData=false)
public class TestBatchTasksToSalesPerf {
    static testmethod void test() {
        final id Sales_HD_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
         
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '111111132121312311');
        insert usr;
       
        Date currentDate = Date.newInstance(System.now().year(), System.now().month(), System.now().day());
        
        Task t = new Task(ActivityDate = currentDate, OwnerId = usr.Id);
        insert t;
        
        Task t2 = new Task(ActivityDate = currentDate.addMonths(10-currentDate.Month()), OwnerId = usr.Id);
        insert t2;
        
        
        for (Sales_Performance__c sp : [select OwnerId from Sales_Performance__c where OwnerId = :usr.Id 
                                        and Month__c = :date.newInstance(currentDate.year(), currentDate.month(), 1)]){
            delete sp;
        }
        
        
        String SPId = usr.Id + mmyyyy(currentdate);

        //Sales_Performance__c SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        Task taskSp = [select Sales_Performance_ID__c from task where Id = :t.Id];
        //System.debug('Task Before: '+taskSp.Sales_Performance_ID__c);
        System.assert(taskSp.Sales_Performance_ID__c == null);
        
        Test.startTest();
            BatchTasksToSalesPerf taskBatch = new BatchTasksToSalesPerf();
            taskBatch.query ='select Id from task where OwnerId = \''+usr.Id+'\'';
            Database.executeBatch(taskBatch, 100);
        Test.stopTest();
        
        //SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        Sales_Performance__c SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        taskSp = [select Sales_Performance_ID__c from task where Id = :t.Id];
        System.debug('SP: '+SP.Id+' Task After: '+taskSp.Sales_Performance_ID__c);
    }
    
    public static string mmyyyy(Datetime d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }//end mmyyyy
}

/*
@isTest(SeeAllData=false)
public class TestBatchTasksToSalesPerf {
    //The doNotRunTrigger code below is used to disable the trigger that
    //sets the Sales_Performance_ID__c field on tasks when inserting an task
    public static Boolean doNotRunTrigger = false;
    
    public static void setDoNotRunTrigger(){
        doNotRunTrigger = true;
    }
    
    public static Boolean shouldRunTrigger() {
        return !doNotRunTrigger;
    }
    
    static testmethod void test() {
        setDoNotRunTrigger();
        Profile p = [SELECT Id FROM Profile WHERE Name='KAH Sales Associate']; 
        User usr = new User(Alias = 'test', Email='KAHSaleAssociate@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSaleAssociate@testorg.com');
        insert usr;
       
        Datetime currentDate = System.now();
        Task e = new Task(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        insert e;
        
        Task e2 = new Task(ActivityDateTime = currentDate.addMonths(10-currentDate.Month()), OwnerId = usr.Id, DurationInMinutes = 15);
        insert e2;
        
        for (Sales_Performance__c sp : [select OwnerId from Sales_Performance__c where OwnerId = :usr.Id 
                                        and Month__c = :date.newInstance(currentDate.year(), currentDate.month(), 1)]){
            delete sp;
        }
        
        String SPId = usr.Id + mmyyyy(currentdate);

        //Sales_Performance__c SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        Task taskSp = [select Sales_Performance_ID__c from task where Id = :e.Id];
        //System.debug('Task Before: '+taskSp.Sales_Performance_ID__c);
        System.assert(taskSp.Sales_Performance_ID__c == null);
        
        Test.startTest();
            BatchTasksToSalesPerf taskBatch = new BatchTasksToSalesPerf();
            taskBatch.query ='select Id from task where OwnerId = \''+usr.Id+'\'';
            Database.executeBatch(taskBatch, 100);
        Test.stopTest();
        
        //SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        Sales_Performance__c SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        taskSp = [select Sales_Performance_ID__c from task where Id = :e.Id];
        //System.debug('SP: '+SP.Id+' Task After: '+taskSp.Sales_Performance_ID__c);
        System.assert(SP.Id == taskSp.Sales_Performance_ID__c);
        
    }
    
    public static string mmyyyy(Datetime d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }//end mmyyyy
}
*/