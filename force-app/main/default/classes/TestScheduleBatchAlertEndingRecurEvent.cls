@isTest(SeeAllData=false)
public class TestScheduleBatchAlertEndingRecurEvent {
    static testmethod void test() {
        
        final id Sales_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
        
        User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = Sales_KAH_Associate, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');
        insert usr;
        
        Datetime currentDate = System.now();
        Event e = new Event(ActivityDateTime = currentDate, OwnerId = usr.Id, DurationInMinutes = 60, IsRecurrence = true, RecurrenceStartDateTime = currentDate,
                            endDateTime = currentDate.addHours(1), RecurrenceType = 'RecursDaily', RecurrenceInterval = 1, RecurrenceEndDateOnly = currentDate.date().addDays(1));
        insert e;
        
        Test.startTest();
            ScheduleBatchAlertEndingRecurEvent job = new ScheduleBatchAlertEndingRecurEvent();   
            job.query = 'select Id, OwnerId, Owner.Email from event where Id = \''+e.Id+'\'';
            String chron = '0 0 23 * * ?';        
            system.schedule('Test Sched', chron, job);
        Test.stopTest();
        
    }
}