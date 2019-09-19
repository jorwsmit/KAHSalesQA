@isTest(SeeAllData=false)
public class TestBatchEventsToSalesPerf {
    //The doNotRunTrigger code below is used to disable the trigger that
    //sets the Sales_Performance_ID__c field on events when inserting an event
    public static Boolean doNotRunTrigger = false;
    
    public static void setDoNotRunTrigger(){
        doNotRunTrigger = true;
    }
    
    public static Boolean shouldRunTrigger() {
        return !doNotRunTrigger;
    }
    
    static testmethod void test() {
        
        final id Sales_HD_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
        
        setDoNotRunTrigger();
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '4325235546456231');
        insert usr;
       
        Datetime currentDate = System.now();
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        insert e;
        
        Event e2 = new Event(ActivityDateTime = currentDate.addMonths(10-currentDate.Month()), OwnerId = usr.Id, DurationInMinutes = 15);
        insert e2;
        
        for (Sales_Performance__c sp : [select OwnerId from Sales_Performance__c where OwnerId = :usr.Id 
                                        and Month__c = :date.newInstance(currentDate.year(), currentDate.month(), 1)]){
            delete sp;
        }
        
        String SPId = usr.Id + mmyyyy(currentdate);

        //Sales_Performance__c SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        Event eventSp = [select Sales_Performance_ID__c from event where Id = :e.Id];
        //System.debug('Event Before: '+eventSp.Sales_Performance_ID__c);
        System.assert(eventSp.Sales_Performance_ID__c == null);
        
        Test.startTest();
            BatchEventsToSalesPerf eventBatch = new BatchEventsToSalesPerf();
            eventBatch.query ='select Id from event where OwnerId = \''+usr.Id+'\'';
            Database.executeBatch(eventBatch, 100);
        Test.stopTest();
        
        //SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        Sales_Performance__c SP = [select Id from Sales_Performance__c where Sales_Performance_Id__c = :SPId];
        eventSp = [select Sales_Performance_ID__c from event where Id = :e.Id];
        //System.debug('SP: '+SP.Id+' Event After: '+eventSp.Sales_Performance_ID__c);
        System.assert(SP.Id == eventSp.Sales_Performance_ID__c);
        
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