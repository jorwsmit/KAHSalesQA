@isTest
private class AA_TranscriptCleanerTest {

    static testMethod void myUnitTest() {
        LiveChatVisitor objvisitor = new LiveChatVisitor();
		insert objvisitor;
		update objvisitor;
        
        LiveChatTranscript lct = new LiveChatTranscript(Status = 'Completed', LiveChatVisitorId = objvisitor.Id,
															Email__c = 'test@test.com',
															First_Name__c = 'TestFirstName',
															Last_Name__c = 'TestLastName');
        insert lct;
        String CRON_EXP = '0 0 * * * ?';
		AA_TranscriptCleanerScheduler sch = new AA_TranscriptCleanerScheduler();
		system.schedule('TranscriptCleanerHourly', CRON_EXP, sch);
        }
}