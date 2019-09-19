@isTest
private class AA_MedparArchiverSchedulerTest {

    static testMethod void myUnitTest() {
        Account a = new Account(Name='TestAccount', NPI__c = '12');
        insert a;
        
        Account a2 = new Account(Name='TestAccount2', NPI__c = '22', KRS_MEDPAR_Master_ID__c = '55555' );
        insert a2;
        
        HRS_MEDPAR__c mData = new HRS_MEDPAR__c(Account__c = a2.ID,
                                                    Acute_ADC__c = 5,
                                      Acute_Beds__c = 10,
                                      Buds_Notes__c = 'Test Notes',
                                      Do_Not_Call_Date__c = system.today(),
                                      HCRIS_Reporting_End_Date__c = system.today(),
                                      HCRIS_Reporting_Months__c = 2,
                                      HRS_Affiliate_1__c = 'aff1',
                                      HRS_Affiliate_2__c = 'aff2',
                                      HRS_Affiliate_3__c = 'aff3',
                                      IP_Cost_PPD__c = 2321,
                                      IP_LOS__c = 6576,
                                      IRF_ADC__c = 2233,
                                      IRF_Beds__c = 233,
                                      IRF_Potential_ADC__c = 55,
                                      LTACH_ADC__c = 44,
                                      LTACH_Beds__c = 33,
                                      MSA_Micro__c = 'Micro',
                                      Non_Compete__c = 'Non compete',
                                      SNF_ADC__c = 34,
                                      SNF_Beds__c = 22,
                                      Type_of_Facility_Secondary__c = 'Secondary',
                                      Year__c = '2019',
                                      Quarter__c = '1');
        
        insert mData;
        
        mData.IRF_ADC__c = 100;
        mData.IRF_Potential_ADC__c = 90;
        update mData;
        test.startTest();
        String CRON_EXP = '0 0 * * * ?';
		AA_MedparArchiverScheduler sch = new AA_MedparArchiverScheduler();
		system.schedule('MedparArchiveTest', CRON_EXP, sch);
		test.stopTest();
        }
        
}