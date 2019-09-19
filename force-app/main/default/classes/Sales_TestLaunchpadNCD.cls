@isTest (SeeAllData = false)
private class Sales_TestLaunchpadNCD {

    @isTest static void NoSP() {
        String result;
        Test.StartTest();
            result = SALES_LaunchpadNCDController.getSPdata();
        Test.StopTest();
        System.assert(result==null);
    }

    @isTest static void SP() {
        final ID SALES_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].id;
        User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate,
        TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');
        insert usr;

        Sales_Performance__c sp = new Sales_Performance__c(ownerId=usr.Id, Month__c=date.newinstance(System.now().year(), System.now().month(), 1));
        insert sp;

        System.debug([select count() from sales_performance__c]);

        String result;
        Test.StartTest();
            System.runAs(usr){
                result = SALES_LaunchpadNCDController.getSPdata();
            }
        Test.StopTest();
        System.assert(result!=null);
    }
}