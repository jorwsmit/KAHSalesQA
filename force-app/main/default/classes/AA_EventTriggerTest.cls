@isTest
private class AA_EventTriggerTest {

@isTest static void ByInsertingTwoEvents() {
	
        final id Sales_HD_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
         
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '1675867544345346645');
        
        
        
        Test.startTest();
            insert usr;
        Test.stopTest();
        
        Datetime currentDate = System.now();
       
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        
        if (Integer.valueOf(currentDate.month()) > 10){
            currentDate = currentDate.addMonths(10-Integer.valueOf(currentDate.month()));
        } else {
            currentDate = currentDate.addMonths(3);
        }
        
        Event e2 = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        
        insert e;
        insert e2;
        
        e = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e.Id];
        e2 = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e2.Id];
        Sales_Performance__c sp = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.assert(e.Sales_Performance_ID__c == sp.Id);
    }//end ByInsertingTwoEvents
    
    @isTest static void ByUpdatingAnEvent() {
        final id Sales_HD_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '156757844534523525423');
        
        Test.startTest();
            insert usr;
            BatchCreate12SalesPerf4NextYear insertSPs = new BatchCreate12SalesPerf4NextYear();
            insertSPs.query = 'select Id, ProfileId from user where id = \''+usr.Id+'\'';
            Database.executeBatch(insertSPs);
        Test.stopTest();
        
        Datetime currentDate = System.now();
        
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        insert e;
        
        Sales_Performance__c spBefore = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.debug('Before: '+spBefore+' Date: '+e.ActivityDateTime);
        
        e.ActivityDateTime = e.ActivityDateTime.addMonths(1);
        
        update e;
        
        e = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e.Id];
        Sales_Performance__c spAfter = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.debug('After: '+spAfter+' Date: '+e.ActivityDateTime);
        //System.assert(spBefore != spAfter);
        
    }//end ByUpdatingAnEvent
    
    @isTest static void ByUpdatingAnEventToPTO() {
        final id Sales_HD_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
         
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '1545678473676767432');
        
        
        
        Test.startTest();
            insert usr;
            BatchCreate12SalesPerf4NextYear insertSPs = new BatchCreate12SalesPerf4NextYear();
            insertSPs.query = 'select Id, ProfileId from user where id = \''+usr.Id+'\'';
            Database.executeBatch(insertSPs);
        Test.stopTest();
        
        
        Datetime currentDate = System.now();
        
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        insert e;
        
        Sales_Performance__c spBefore = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.debug('Before: '+spBefore+' Date: '+e.ActivityDateTime);
        
        e.ActivityDateTime = e.ActivityDateTime.addMonths(1);
        e.Type = 'PTO';
        
        update e;
        
        e = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e.Id];
        Sales_Performance__c spAfter = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.debug('After: '+spAfter+' Date: '+e.ActivityDateTime);
        //System.assert(spBefore != spAfter);
        
    }//end ByUpdatingAnEventToPTO
    
    @isTest static void ByDeletingAnEvent() {
        
        final id Sales_HD_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: HD Associate'].ID; 
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '17895654636496');
        
        
        
        Test.startTest();
            insert usr;
        Test.stopTest();
        
        Datetime currentDate = System.now();
        
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        insert e;
        Sales_Performance__c spBefore = [select Sales_Calls__c from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.debug('Before: '+spBefore+' Date: '+e.ActivityDateTime);
        
        delete e;
        
        Sales_Performance__c spAfter = [select Sales_Calls__c from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        delete spAfter;
        //System.debug('After: '+spAfter+' Date: '+e.ActivityDateTime);
        //System.assert(spBefore.Sales_Calls__c > spAfter.Sales_Calls__c);
        
    }//end ByDeletingAnEvent
    
    @isTest static void ByInsertingRecurringEvents() {
        final id Sales_HD_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
         
        User usr = new User(Alias = 'test', Email='MarketoLiaison@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_HD_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='MarketoLiaison@testorg.com', Perner__c = '1968658468456432');
        insert usr;
        Datetime currentDate = System.now();
        
        String dayOfWeek = currentDate.format('E');
        Integer RecDayOfWeek;
        
        if (dayOfWeek == 'Sun') RecDayOfWeek = 1; if (dayOfWeek == 'Mon') RecDayOfWeek = 2; if (dayOfWeek == 'Tue') RecDayOfWeek = 4; 
        if (dayOfWeek == 'Wed') RecDayOfWeek = 8; if (dayOfWeek == 'Thu') RecDayOfWeek = 16; if (dayOfWeek == 'Fri') RecDayOfWeek = 32; 
        if (dayOfWeek == 'Sat') RecDayOfWeek = 64; 
        
        Event e = new Event(IsRecurrence = true, RecurrenceStartDateTime = currentDate, RecurrenceType = 'RecursWeekly', RecurrenceInterval = 1,
                            RecurrenceDayOfWeekMask = RecDayOfWeek, RecurrenceEndDateOnly = currentDate.addMonths(2).date(), ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        
        Integer numOfWeeks = currentDate.date().daysBetween(currentDate.addMonths(2).date());
        numOfWeeks = (numOfWeeks+2)/7;
        
        Test.startTest();
        insert e;
        Test.stopTest();
        e = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e.Id];
        //System.debug('Event: '+e.Sales_Performance_ID__c);
        Sales_Performance__c sp = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.assert(e.Sales_Performance_ID__c == sp.Id);
        //System.debug('Number of events: '+[select id from event where (Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate) 
        //                                   or Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate.addMonths(1))) and IsRecurrence != true].size() +' Number of weeks: '+numOfWeeks);
        //System.assert([select id from event where (Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate) 
                                                   //or Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate.addMonths(1))) and IsRecurrence != true].size() <= numOfWeeks);
        
    }//end ByInsertingRecurringEvents
    
    @isTest static void ByDeletingRecurringEvents() {
        final ID Sales_KAH_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
        
         
        User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_KAH_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com', Perner__c = '1568567869090089');
        insert usr;
        Datetime currentDate = System.now();
        
        String dayOfWeek = currentDate.format('E');
        Integer RecDayOfWeek;
        
        if (dayOfWeek == 'Sun') RecDayOfWeek = 1; if (dayOfWeek == 'Mon') RecDayOfWeek = 2; if (dayOfWeek == 'Tue') RecDayOfWeek = 4; 
        if (dayOfWeek == 'Wed') RecDayOfWeek = 8; if (dayOfWeek == 'Thu') RecDayOfWeek = 16; if (dayOfWeek == 'Fri') RecDayOfWeek = 32; 
        if (dayOfWeek == 'Sat') RecDayOfWeek = 64; 
        
        Event e = new Event(IsRecurrence = true, RecurrenceStartDateTime = currentDate, RecurrenceType = 'RecursWeekly', RecurrenceInterval = 1,
                            RecurrenceDayOfWeekMask = RecDayOfWeek, RecurrenceEndDateOnly = currentDate.addMonths(2).date(), ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15);
        
        Integer numOfWeeks = currentDate.date().daysBetween(currentDate.addMonths(2).date());
        numOfWeeks = (numOfWeeks+2)/7;
        
        insert e;
        
        Test.startTest();
        delete e;
        //System.debug('By deleting recurrence');
        Test.stopTest();
        //e = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e.Id];
        //System.debug('Event: '+e.Sales_Performance_ID__c);
        //Sales_Performance__c sp = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.assert(e.Sales_Performance_ID__c == sp.Id);
        //System.debug('Number of events: '+[select id from event where Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate) 
        //              or Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate.addMonths(1))].size() +' Number of weeks: '+numOfWeeks);
        //System.assert([select id from event where Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate) 
        //               or Sales_Performance_ID__r.Sales_Performance_ID__c = :e.OwnerId + mmyyyy(currentDate.addMonths(1))].size() == 0);
        
    }//end ByDeletingRecurringEvents
    
    @isTest static void ByInsertingKAHEvents() {
        final ID Sales_KAH_Associate = [SELECT ID FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
         
        User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_KAH_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com', Perner__c = '456475786973333661');
        
        
        
        Test.startTest();
            insert usr;
        
        Test.stopTest();
        
        Datetime currentDate = System.now();
        
        //System.debug([select Sales_Performance_Id__c from Sales_Performance__c where ownerId = :usr.Id]);
        
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15, type = 'Cold Call', Complete__c = true);
        
        if (Integer.valueOf(currentDate.month()) > 10){
            currentDate = currentDate.addMonths(10-Integer.valueOf(currentDate.month()));
        } else {
            currentDate = currentDate.addMonths(3);
        }
        
        Event e2 = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 15, type = 'Cold Call');
        
        insert e;
        insert e2;
        
        e = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e.Id];
        e2 = [select Sales_Performance_ID__c, OwnerId, ActivityDateTime from event where Id = :e2.Id];
        //System.debug('Event: '+e.Sales_Performance_ID__c);
        Sales_Performance__c sp = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e.OwnerId + mmyyyy(e.ActivityDateTime)];
        //System.assert(e.Sales_Performance_ID__c == sp.Id);
        //sp = [select Id from Sales_Performance__c where Sales_Performance_ID__c = :e2.OwnerId + mmyyyy(e2.ActivityDateTime)];
        //System.assert(e2.Sales_Performance_ID__c == sp.Id);
        
    }//end ByInsertingKAHEvents
    
    public static string mmyyyy(Datetime d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        
        return mmyyyy;
    }//end mmyyyyy
         
}