@isTest 
private class AA_YearEndMetricRollupTest {

    static testMethod void myUnitTest() {
        String CRON_EXP = '0 0 * * * ?';
		AA_YearEndMetricRollupScheduler sch = new AA_YearEndMetricRollupScheduler();
		system.schedule('MetricRollUpYearly', CRON_EXP, sch);
        }
        
    static testMethod void myUnitTest2() {
    	Date lastYearDate = date.newInstance((system.today().year() -1),system.today().month(),system.today().day());
        Account acc = new Account(Name='Test Account');
        insert acc;
        Sales_Account_Metrics__c sam = new Sales_Account_Metrics__c(Month__c = lastYearDate, 
        															Account__c = acc.ID,
        															KAH_HH_Admits__c = 11,
        															KAH_HH_Discounted_Qualified_Admits__c = 7,
        															KAH_HH_PPS_Admits__c = 4,
        															KAH_HH_Referrals__c = 3,
        															KAH_HP_Admits__c = 55,
        															KAH_HP_Qualified_Admits__c = 44,
        															KAH_HP_Referrals__c = 33);
        insert sam;															
        test.startTest();
        AA_YearEndMetricRollup obj = new AA_YearEndMetricRollup('Sales_Account_Metrics__c');
		database.executeBatch(obj);
		test.stopTest();
		Account a = new Account();
		a = [SELECT HH_Admits_PY__c, 
					KAH_HH_Discounted_Qualified_Admits_PY__c, 
					HH_Referrals_PY__c,
					KAH_HH_PPS_Prior_Year_Admits_Prior__c,
					KAH_HP_Qualified_Admits_PY__c,
					HP_Admits_PY__c,
					HP_Referrals_PY__c,
					KAH_HH_Admits_YTD__c,
					KAH_HH_Discounted_Qualified_Admits_YTD__c,
					KAH_HH_Referrals_YTD__c,
					KAH_HH_PPS_Admits_YTD__c,
					KAH_HP_Qualified_Admits_YTD__c,
                    KAH_HP_Admits_YTD__c,
                    KAH_HP_Referrals_YTD__c
					FROM Account 
					WHERE ID =: acc.ID];
		
		system.assert(a.KAH_HH_Discounted_Qualified_Admits_PY__c == 7);
		}
    
    static testMethod void myUnitTest3() {
        Date lastYearDate = date.newInstance((system.today().year() -1),system.today().month(),system.today().day());
        Contact ctc = new Contact(LastName='Contact',
        						  FirstName = 'Test');
        insert ctc;
        Sales_Contact_Metrics__c scm = new Sales_Contact_Metrics__c(Month__c = lastYearDate, 
        															Contact__c = ctc.ID,
        															KAH_HH_Admits__c = 11,
        															KAH_HH_Discounted_Qualified_Admits__c = 7,
        															KAH_HH_PPS_Admits__c = 4,
        															KAH_HH_Referrals__c = 3,
        															KAH_HP_Admits__c = 55,
        															KAH_HP_Qualified_Admits__c = 44,
        															KAH_HP_Referrals__c = 33);
        insert scm;						  
        test.startTest();
        AA_YearEndMetricRollup obj = new AA_YearEndMetricRollup('Sales_Contact_Metrics__c');
		database.executeBatch(obj);
		test.stopTest();
		Contact c = new Contact();
		c = [SELECT HH_Admits_PY__c, 
					KAH_HH_Discounted_Qualified_Admits_PY__c, 
					HH_Referrals_PY__c,
					KAH_HH_PPS_Prior_Year_Admits_Prior__c,
					KAH_HP_Qualified_Admits_PY__c,
					HP_Admits_PY__c,
					HP_Referrals_PY__c,
					KAH_HH_Admits_YTD__c,
					KAH_HH_Discounted_Qualified_Admits_YTD__c,
					KAH_HH_Referrals_YTD__c,
					KAH_HH_PPS_Admits_YTD__c,
					KAH_HP_Qualified_Admits_YTD__c,
                    KAH_HP_Admits_YTD__c,
                    KAH_HP_Referrals_YTD__c
					FROM Contact 
					WHERE ID =: ctc.ID];
		system.assert(C.KAH_HH_Discounted_Qualified_Admits_PY__c == 7);
        }
            
}