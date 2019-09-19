@isTest 
private class AA_ContactTriggerTest {

    private static testMethod void TBN_TestContactTrigger() {
        
        list<User> lstUserToInsert = new list<User>();
        
        Id profileId=userinfo.getProfileId();
        
        for(Integer i=0; i<=14; i++){
            lstUserToInsert.add(new User(Alias = 'teCon'+i, Email='testContactTeam'+i+'@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='testContactTeam'+i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='testContactTeam'+i+'@testorg.com'));
        	}
        insert lstUserToInsert;
        
        list<Contact>lstContact = new list<Contact>();
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        List<RecordType> lstRecTypesCon = [Select Name, Id From RecordType where sObjectType='Contact' AND isActive = true];
        
        Restrict_Deletion__c objRestrictDel = new Restrict_Deletion__c(Name = profileId, Account_RT__c = lstRecTypesAcc[0].Id, Contact_RT__c = lstRecTypesCon[0].Id, Profile_Name__c = 'KAH Liason');
		insert objRestrictDel;
		
		Contact objContact = new Contact(LastName='TestContact', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '1263');
		lstContact.add(objContact);
		
		Contact objContact2 = new Contact(LastName='TestContact2', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '5123');
		lstContact.add(objContact2);
		
		Contact objContact4 = new Contact(LastName='TestContact4', Merge_Master__c = true);
		lstContact.add(objContact4);
		
		insert lstContact; 
		
		Sales_Contact_Metrics__c objContactMetric = new Sales_Contact_Metrics__c(name='test CM' , Contact__c=objContact4.id, Month__c=date.today());
		insert objContactMetric;
		
		Contact_Team__c objContactTeamMember1 = new Contact_Team__c(Contact__c = objContact4.Id, User__c = lstUserToInsert[0].Id);
	    insert objContactTeamMember1;
	    
	    test.startTest();
		
		Contact objContact7 = new Contact(LastName='TestContact5');
		insert objContact7;
		
		Contact_Team__c objContactTeamMember2 = new Contact_Team__c(Contact__c = objContact7.Id, User__c = lstUserToInsert[1].Id, Previous_ContactId__c = objContact4.id);
	    insert objContactTeamMember2;
		
		merge objContact4 objContact7;
		
		test.stopTest();
		}
    
    private static testMethod void method2(){
    	Contact objContact = new Contact(LastName='TestContact12');
		insert objContact;
		
		Contact objContact2 = new Contact(LastName='TestContact13');
		insert objContact2;
        
        objContact2.Merge_Requested_With_ID__c = objContact.ID;
        objContact2.Merge_Request_With_Name__c = objContact.Name;
        objContact2.Merge_Approved__c = true;
        
        update objContact2;
        
    	}
    	
     private static testMethod void method3(){
    	list<User> lstUserToInsert = new list<User>();
        
        Id profileId=userinfo.getProfileId();
        
        for(Integer i=0; i<=14; i++){
            lstUserToInsert.add(new User(Alias = 'teCon'+i, Email='testContactTeam'+i+'@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='testContactTeam'+i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='testContactTeam'+i+'@testorg.com'));
        	}
        insert lstUserToInsert;
        
        list<Contact>lstContact = new list<Contact>();
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        List<RecordType> lstRecTypesCon = [Select Name, Id From RecordType where sObjectType='Contact' AND isActive = true];
        
        Restrict_Deletion__c objRestrictDel = new Restrict_Deletion__c(Name = profileId, Account_RT__c = lstRecTypesAcc[0].Id, Contact_RT__c = lstRecTypesCon[0].Id, Profile_Name__c = 'KAH Liason');
		insert objRestrictDel;
		
		Contact objContact = new Contact(LastName='TestContact', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '1263');
		lstContact.add(objContact);
		
		Contact objContact2 = new Contact(LastName='TestContact2', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '5123');
		lstContact.add(objContact2);
		
		Contact objContact3 = new Contact(LastName='TestContact3', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '7123');
		lstContact.add(objContact3);
		
		Contact objContact4 = new Contact(LastName='TestContact4', Merge_Master__c = true);
		lstContact.add(objContact4);
		
		
		Contact objContact11 = new Contact(LastName='TestContact11');
		lstContact.add(objContact11);
		
		Contact objContact12 = new Contact(LastName='TestContact12');
		lstContact.add(objContact12);
		
		Contact objContact13 = new Contact(LastName='TestContact13');
		lstContact.add(objContact13);
		
		insert lstContact; 
        Contact objContact6 = new Contact(LastName='TestContact6');
		insert objContact6;
		
		test.startTest();
		
		list<Sales_Contact_Metrics__c>lstSalesContact = [select id from Sales_Contact_Metrics__c where Contact__c=: objContact2.id];
		System.assertEquals(lstSalesContact.size(),0);
		
		    
	    Contact_Team__c objContactTeamMember = new Contact_Team__c(Contact__c = objContact3.Id, User__c = lstUserToInsert[0].Id);
	    insert objContactTeamMember;
		
		delete objContact6;
		
		objContact13.MailingStreet = '680 S 4th St';
		objContact13.MailingCity = 'Louisville';
		objContact13.MailingState = 'KY';
		objContact13.MailingPostalCode = '40202';
		update objContact13;
		merge objContact12 objContact13;
		test.stopTest();
    	}
    	
    static testMethod void addContactForProcess(){
        Account a = new Account();
   		a.Name = 'Test Account';
    	insert a;
        Profile p = [Select Id From Profile Limit 1];
        ID crRT = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact_KRS'].ID;
   		User u = new User();
    	u.FirstName = 'New';
    	u.LastName = 'User';
    	u.Username = 'ARGLARGLEDIE@test.test';
    	u.Email = 'test@test23.test';
    	u.Alias = 'test';
    	u.TimeZoneSidKey = 'America/Chicago';
    	u.LocaleSidKey = 'en_US';
    	u.EmailEncodingKey = 'UTF-8';
    	u.ProfileId = p.Id;
    	u.LanguageLocaleKey = 'en_US';
    	insert u;
        Contact c = new Contact(RecordTypeID = crRT, Account = a, KRS_Marketo_Process__c = true, KRS_Marketo_Processed__c = false, LastName = 'TLastName');
        insert c;
        Task t = new Task(WhoID = c.Id, 
        				  ActivityDate = system.today());
        insert t;
        list<ID> processList = new list<ID>();
        processList.add(c.Id);
        AA_HRSTaskandEventHelper.processItems(processList);
      }	
	
}