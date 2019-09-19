@isTest(seeAllData=true)
private class AA_AccountTriggerTest {

	public static ID krsAccount = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'KRS_Standard_Account'].Id;

    private static testMethod void TBN_TestAccountTrigger(){
        
        list<User> lstUserToInsert = new list<User>();
        ID profileID = userinfo.getProfileId();
        
        User u = new User(ProfileId = profileID, 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'test234242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
        insert u;                 
        
        for(Integer i=0; i<=14; i++){
            lstUserToInsert.add(new User(Alias = 'teCon'+i, Email ='testContactTeam'+i+'@testorg.com', 
            EmailEncodingKey ='UTF-8', LastName ='testContactTeam'+i, LanguageLocaleKey ='en_US', 
            LocaleSidKey ='en_US', ProfileId = profileID, TimeZoneSidKey ='America/Los_Angeles', UserName ='testContactTeam'+i+'@testorg.com'));
            }
        insert lstUserToInsert;
        
        list<Account>lstAccount = new list<Account>();
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        List<RecordType> lstRecTypesCon = [Select Name, Id From RecordType where sObjectType='Contact' AND isActive = true];
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
        lstAccount.add(objAccount);
        
        Account objAccount2 = new Account(Name='TestAccount2', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '123');
        lstAccount.add(objAccount2);
        
        Account objAccount5 = new Account(Name='TestAccount5');
        lstAccount.add(objAccount5);
        
        Account objAccount6 = new Account(Name='TestAccount6');
        lstAccount.add(objAccount6);
        
        Account objAccount7 = new Account(Name='TestAccount7');
        lstAccount.add(objAccount7);
        
        Account objAccount8 = new Account(Name='TestAccount8');
        lstAccount.add(objAccount8);
        
        Account objAccount9 = new Account(Name='TestAccount9');
        lstAccount.add(objAccount9);
        
        Account objAccount10 = new Account(Name='TestAccount10');
        lstAccount.add(objAccount10);
        
        Account objAccount11 = new Account(Name='TestAccount11');
        lstAccount.add(objAccount11);
        
        Account objAccount12 = new Account(Name='TestAccount12');
        lstAccount.add(objAccount12);
        
        Account objAccount3 = new Account(Name='TestAccount3', Merge_Master__c = true);
        lstAccount.add(objAccount3);
        
        Account objAccount4 = new Account(Name='TestAccount4');
        insert objAccount4;
        
        insert lstAccount;
        
        Sales_Account_Metrics__c objAccountMetric = new Sales_Account_Metrics__c(name='test AM' , Account__c=objAccount2.id, Month__c=date.today());
        insert objAccountMetric;
        
        Restrict_Deletion__c objRestrictDel = new Restrict_Deletion__c(Name = profileId, Account_RT__c = lstRecTypesAcc[0].Id, Contact_RT__c = lstRecTypesCon[0].Id, Profile_Name__c = 'KAH Liason');
        insert objRestrictDel;
        
        test.startTest();
        merge objAccount3 objAccount4; 
    
        objAccount11.ShippingStreet = '680 S 4th St';
        objAccount11.ShippingCity = 'Louisville';
        objAccount11.ShippingState = 'KY';
        objAccount11.ShippingPostalCode = '40202';
        update objAccount11;
        test.stopTest();
        }
    
    private static testMethod void method2(){
    	list<Account> toInsert = new list<Account>();
    	
        Account objAccount = new Account(Name='TestAccount');
        toInsert.add(objAccount);
        
        Account objAccount2 = new Account(Name='TestAccount2');
        toInsert.add(objAccount2);
        insert toInsert;
        
        objAccount2.Merge_Requested_With_ID__c = objAccount.ID;
        objAccount2.Merge_Request_With_Name__c = objAccount.Name;
        objAccount2.Merge_Approved__c = true;
        
        update objAccount2;
        
        }
        
    private static testMethod void method3(){
        ID profileID = userinfo.getProfileId();
        
        list<User> toInsertU = new list<User>();
        User u = new User(ProfileId = profileID, 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'te11st234242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u2 = new User(ProfileId = profileID, 
                          FirstName = 'TestUser',
                          LastName = 'UserUser',
                          userName = 'te22s23434312423@usertest.none',
                          Alias = 'te9034', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u3 = new User(ProfileId = profileID, 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 't3est333332423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u4 = new User(ProfileId = profileID, 
                          FirstName = 'TestUser',
                          LastName = 'UserUser',
                          userName = 't4es444423@usertest.none',
                          Alias = 'te9034', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        toInsertU.add(u);
        toInsertU.add(u2);
        toInsertU.add(u3);
        toInsertU.add(u4);
        insert toInsertU;
        
        list<Account> toInsertAcc = new list<Account>();
        Account objAccount = new Account(Name='TestAccount', BillingState = 'KY', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'HRS');
        Account objAccount2 = new Account(Name='TestAccount2', BillingState = 'NY', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'SRS');
        Account objAccount3 = new Account(Name='TestAccount', BillingState = 'AZ', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'HRS');
        Account objAccount4 = new Account(Name='TestAccount2', BillingState = 'WI', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'SRS');
        Account objAccount5 = new Account(Name='TestAccount2', BillingState = 'ON', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'HRS');
        
        toInsertAcc.add(objAccount);
        toInsertAcc.add(objAccount2);
        toInsertAcc.add(objAccount3);
        toInsertAcc.add(objAccount4);
        toInsertAcc.add(objAccount5);
        insert toInsertAcc;
        
        list<HRS_BDO_Territory__c> hrsToInsert = new list<HRS_BDO_Territory__c>();
        list<SRS_BDO_Territory__c> srsToInsert = new list<SRS_BDO_Territory__c>();
        
        HRS_BDO_Territory__c hrsData = new HRS_BDO_Territory__c(HRS_BDO__c = u.Id,
                                                                Outside_US_Territories__c = 'PR',
                                                                US_Territories__c = 'KY');
        hrsToInsert.add(hrsData);
        HRS_BDO_Territory__c hrsData2 = new HRS_BDO_Territory__c(HRS_BDO__c = u2.Id,
                                                                Outside_US_Territories__c = 'ON',
                                                                US_Territories__c = 'NY');
        hrsToInsert.add(hrsData2);
        HRS_BDO_Territory__c hrsData3 = new HRS_BDO_Territory__c(HRS_BDO__c = u3.Id,
                                                                Outside_US_Territories__c = 'NT',
                                                                US_Territories__c = 'AZ');
        hrsToInsert.add(hrsData3);
        HRS_BDO_Territory__c hrsData4 = new HRS_BDO_Territory__c(HRS_BDO__c = u4.Id,
                                                                Outside_US_Territories__c = 'PR',
                                                                US_Territories__c = 'KY');
        hrsToInsert.add(hrsData4);
        
        SRS_BDO_Territory__c srsData = new SRS_BDO_Territory__c(SRS_BDO__c = u.Id,
                                                                Role__c = 'CT BDO',
                                                                States__c = 'KY',
                                                                CT_VP__c = u2.id);
        srsToInsert.add(srsData);
        SRS_BDO_Territory__c srsData2 = new SRS_BDO_Territory__c(SRS_BDO__c = u2.Id,
                                                                Role__c = 'CT BDO',
                                                                States__c = 'NY'
                                                                );
        srsToInsert.add(srsData2); 
        SRS_BDO_Territory__c srsData3 = new SRS_BDO_Territory__c(SRS_BDO__c = u3.Id,
                                                                Role__c = 'CT BDO',
                                                                States__c = 'WI',
                                                                CT_VP__c = u2.id);
        srsToInsert.add(srsData3); 
        SRS_BDO_Territory__c srsData4 = new SRS_BDO_Territory__c(SRS_BDO__c = u4.Id,
                                                                Role__c = 'CT BDO',
                                                                States__c = 'AZ',
                                                                CT_VP__c = u2.id);
        srsToInsert.add(srsData4);      
        
        
        insert hrsToInsert;
        insert srsToInsert;        
        
        list<HRS_BDO_Territory__c> hrsToUpdate = new list<HRS_BDO_Territory__c>();
        list<SRS_BDO_Territory__c> srsToUpdate = new list<SRS_BDO_Territory__c>();
        
        srsData3.States__c = 'AZ';
        srsData4.States__c = 'WI';
        
        srsToUpdate.add(srsData3);
        srsToUpdate.add(srsData4);
        
        update srsToUpdate;
        
        hrsData4.Outside_US_Territories__c = 'NT';
        hrsData3.Outside_US_Territories__c = 'PR';
        hrsToUpdate.add(hrsData3);
        hrsToUpdate.add(hrsData4);
        update hrsToUpdate;
        
        list<Opportunity> opptoInsert = new list<Opportunity>();
        
        Date dt = date.newInstance(system.today().Year(), system.today().month()-21, system.today().day());
        Opportunity opp = new Opportunity(Name = objAccount.Name + ' OpportunityTest', StageName='Closed Lost',
                                          CloseDate = dt, KRS_Future_Task__c = true
                                          );
        opptoInsert.add(opp);
        
        Opportunity opp2 = new Opportunity(Name = objAccount.Name + ' OpportunityTest', StageName='Closed Won',
                                          CloseDate = dt, KRS_Future_Task__c = true
                                          );
        opptoInsert.add(opp2);
        insert opptoInsert;
        String CRON_EXP = '0 0 * * * ?';
        AA_KRSFutureTaskProcessScheduler sch = new AA_KRSFutureTaskProcessScheduler();
        system.schedule('KRSFutureTaskSchedulerTest', CRON_EXP, sch);
        } 
        
        private static testMethod void method4(){
        ID profileID = userinfo.getProfileId();
        
        list<User> toInsertU = new list<User>();
        User u = new User(ProfileId = profileID, 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'test234242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u2 = new User(ProfileId = profileID, 
                          FirstName = 'TestUser',
                          LastName = 'UserUser',
                          userName = 'tes23434312423@usertest.none',
                          Alias = 'te9034', Email ='testContactTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
        User u3 = new User(ProfileId = profileID, 
                          FirstName = 'TestUser',
                          LastName = 'UserUser',
                          userName = 'tes23555523@usertest.none',
                          Alias = 'te905', Email ='testContactTea555998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
        User u4 = new User(ProfileId = profileID, 
                          FirstName = 'TestUser',
                          LastName = 'UserUser',
                          userName = 'tes29993@usertest.none',
                          Alias = 't9905', Email ='testCon99ctTea555998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');                                    
        
        toInsertU.add(u);
        toInsertU.add(u2);
        toInsertU.add(u3);
        toInsertU.add(u4);
        insert toInsertU;
        
        SRS_BDO_Territory__c srsData = new SRS_BDO_Territory__c(SRS_BDO__c = u.Id,
                                                                Role__c = 'CT BDO',
                                                                States__c = 'KY',
                                                                CT_VP__c = u2.id);
        insert srsData;     
                
        Account objAccount = new Account(Name='TestAccount', BillingState = 'KY', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'HRS');
        Account objAccount2 = new Account(Name='TestAccount2', BillingState = 'KY', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'SRS');
        Account objAccount3 = new Account(Name='TestAccount2', BillingState = 'IL', BillingPostalCode = '60001', RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'SRS');
        Account objAccount4 = new Account(Name='TestAccount2', BillingState = 'IL', BillingPostalCode = '61801',  RecordTypeId = krsAccount, KRS_New_Construction__c = true, KRS_RHB_Business_Unit__c = 'SRS');
        list<Account> toInsertAcc = new list<Account>();
        
        toInsertAcc.add(objAccount);
        toInsertAcc.add(objAccount2);
        toInsertAcc.add(objAccount3);
        toInsertAcc.add(objAccount4);
        
        insert toInsertAcc;
        
        test.startTest();
        SRS_BDO_Territory__c srsData2 = new SRS_BDO_Territory__c(SRS_BDO__c = u3.Id,
                                                                Role__c = 'CT BDO',
                                                                States__c = 'KY',
                                                                CT_VP__c = u4.id);
        insert srsData2;     
        objAccount2.Fax = '555-555-5555';
        update objAccount2;
        test.stopTest();
        }  
    
}