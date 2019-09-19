@isTest(SeeAllData=true) 
private class AA_LeadTriggerTest {

	public static ID srsLead = [SELECT ID FROM RecordType WHERE sObjectType = 'Lead' AND DeveloperName = 'KRS_SRS_Lead'].ID;
	public static ID hrsLead = [SELECT ID FROM RecordType WHERE sObjectType = 'Lead' AND DeveloperName = 'KRS_HRS_Lead'].ID;

	private static testMethod void AA_LeadTest(){ 
    	
    	list<User> lstUserToInsert = new list<User>();
        
        Id profileId=userinfo.getProfileId();
        
        for(Integer i=0; i<=14; i++){
            lstUserToInsert.add(new User(Alias = 'teCon'+i, Email='testContactTeam'+i+'@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='testContactTeam'+i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='testContactTeam'+i+'@testorg.com'));
        	}
        insert lstUserToInsert;
        
	    list<Lead>lstLead = new list<Lead>();
        
        List<RecordType> lstRecTypesLead = [Select Name, Id From RecordType where sObjectType='Lead' AND isActive = true];
        List<RecordType> lstRecTypesCon = [Select Name, Id From RecordType where sObjectType='Contact' AND isActive = true];
        
        Lead objLead = new Lead(Company = 'TestLead', LastName = 'Tester', FirstName ='Test', RecordTypeId = lstRecTypesLead[0].Id, NPI__c = '12');
		lstLead.add(objLead);
		
		Lead objLead2 = new Lead(Company = 'TestLead2', LastName = 'Tester', FirstName ='Test', RecordTypeId = lstRecTypesLead[0].Id, NPI__c = '123');
		lstLead.add(objLead2);
		
		Lead objLead5 = new Lead(Company = 'TestLead5', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead5);
		
		Lead objLead6 = new Lead(Company = 'TestLead6', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead6);
		
		Lead objLead7 = new Lead(Company = 'TestLead7', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead7);
		
		Lead objLead8 = new Lead(Company = 'TestLead8', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead8);
		
		Lead objLead9 = new Lead(Company = 'TestLead9', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead9);
		
		Lead objLead10 = new Lead(Company = 'TestLead10', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead10);
		
		Lead objLead11 = new Lead(Company = 'TestLead11', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead11);
		
		Lead objLead12 = new Lead(Company = 'TestLead12', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead12);
		
		Lead objLead13 = new Lead(Company = 'TestLead13', LastName = 'Tester', FirstName ='Test');
		lstLead.add(objLead13);
		
		insert lstLead;
		
		Lead objLead3 = new Lead(Company = 'TestLead3', LastName = 'Tester', FirstName ='Test');
		insert objLead3;
		
		Lead objLead4 = new Lead(Company = 'TestLead4', LastName = 'Tester', FirstName ='Test');
		insert objLead4;
		
		merge objLead3 objLead4; 
	
		objLead11.Street = '680 S 4th St';
		objLead11.City = 'Louisville';
		objLead11.State = 'KY';
		objLead11.PostalCode = '40202';
		update objLead11;
	}
	
	private static testMethod void method2(){
    	ID profileID = userinfo.getProfileId();
    	User u = new User(ProfileId = profileID, 
	    				  FirstName = 'Test',
	    				  LastName = 'User',
	    				  userName = 'test234242423@usertest.none',
	    				  Alias = 'te9000', Email ='testContactTeam10998098@testorg.com', 
            			  EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			  LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
	    insert u;
	    
    	HRS_BDO_Territory__c hrsData = new HRS_BDO_Territory__c(HRS_BDO__c = u.Id,
    															Outside_US_Territories__c = 'PR',
    															US_Territories__c = 'KY');
    	insert hrsData;
    	
    	SRS_BDO_Territory__c srsData = new SRS_BDO_Territory__c(SRS_BDO__c = u.Id,
    															States__c = 'KY');
    	insert srsData;   	
    	    	
    	list<Lead> lToInsert = new list<Lead>();    	
    	Lead objLead = new Lead(FirstName = 'Leadington', Company = 'TestCompany', lastName = 'TestLead', State = 'KY', RecordTypeId = hrsLead);
		lToInsert.add(objLead);
		
		Lead objLead3 = new Lead(FirstName = 'Leadington3', Company = 'TestCompany3', State= 'PR', lastName = 'TestLead3', RecordTypeId = hrsLead);
		lToInsert.add(objLead3);
		
		Lead objLead2 = new Lead(FirstName = 'Leadington2', Company = 'TestCompany2', lastName = 'TestLead2', State = 'KY', PostalCode = '40202', RecordTypeId = srsLead);
		lToInsert.add(objLead2);
		
		Lead objLead4 = new Lead(FirstName = 'Leadington2', Company = 'TestCompany2', lastName = 'TestLead2', State = 'IL', PostalCode = '60001', RecordTypeId = srsLead);
		lToInsert.add(objLead4);
		
		Lead objLead5 = new Lead(FirstName = 'Leadington2', Company = 'TestCompany2', lastName = 'TestLead2', State = 'IL', PostalCode = '61801', RecordTypeId = srsLead);
		lToInsert.add(objLead5);
		insert lToInsert;
		Task t = new Task(WhoID = objLead3.Id, 
        				  ActivityDate = system.today());
        insert t;
        list<ID> processList = new list<ID>();
        processList.add(objLead3.Id);
        AA_HRSTaskandEventHelper.processItems(processList);				  
    	}
    
}