@isTest
public class AA_PFActivityUpdateTest{

    private static testMethod void method1(){
       	List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
		insert objAccount;
        
        Event e = new Event(WhatID = objAccount.ID,
                           	Type = 'F2F - QBR',
                           	DurationInMinutes = 90,
                           	ActivityDate = system.today(),
                           	ActivityDateTime = system.now());
        
        insert e;
        
        
       }
    
    private static testMethod void method2(){
       	List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
		insert objAccount;
        
        Task t = new Task(WhatID = objAccount.ID,
                           	Type = 'Sales Team Meeting'
                           	);
        
        insert t;
        t.subject= 'test';
        update t;
        
       }
    
}