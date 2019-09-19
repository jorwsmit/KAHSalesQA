@isTest
private class AA_CaseEntryControllerTest {

	private static id caseTemp = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Case' AND DeveloperName = 'caseTemp'].Id;
	private static id ACCOUNT_RT_CENTER = [Select SobjectType, Name, DeveloperName From RecordType where SobjectType = 'Account' AND DeveloperName = 'Center'].Id;
	
    static testMethod void myUnitTest() {
        
        AA_CaseEntryController.getPhoneTypeList();
        AA_CaseEntryController.getFacilityTypeList();
        AA_CaseEntryController.getEmailStatusList();
        AA_CaseEntryController.getLOCList();
        
        Date birthDate = date.newInstance(1920, 1, 2);
        
        AA_CaseEntryController.getServerAge(birthDate);
        Case glitchC = new Case(RecordTypeID = caseTemp);
        insert glitchC;
        Case activeCase = AA_CaseEntryController.getNewServerCase();
        Contact activeContact = AA_CaseEntryController.getNewServerContact();
        Account activeAccount = AA_CaseEntryController.getNewServerAccount();
        Patient_New__c activePatient = AA_CaseEntryController.getNewServerPatient(activeContact);
        Assessment__c activeAssessment = AA_CaseEntryController.getNewServerAssessment(activePatient);
        
        activeCase.Case_Notes__c = 'Test Description for Notes';
        
        ContentVersion cv = new ContentVersion(Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'));
        insert cv;
        
        ID document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1].ID;
        
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = document, LinkedEntityId = activeCase.Id, ShareType = 'I');
        insert cdl;
        
        activeContact.LastName = 'Testerly1';
        activeContact.FirstName = 'Important';
        
        activePatient.First_Name__c = 'NotAsImportant';
        activePatient.Last_Name__c = 'Testerlyington2';
        
        activeAssessment.Payor__c = 'Test Payor Name';
        string streetAddr = '680 S 4th St';
    	string cityAddr = 'Louisville';
    	string stateAddr = 'KY';
    	string zipAddr = '40202';
        AA_CaseEntryController.getGeocode(streetAddr, cityAddr, stateAddr, zipAddr);
        test.startTest();
        Account objFacility = new Account(Name = 'TestAccountFacility', ShippingStreet = '680 S 4th St', ShippingCity = 'Louisville', ShippingState = 'KY', ShippingPostalCode = '40202', Central_Intake_Email__c = 'test.kindred@gmail.com', RecordTypeId = ACCOUNT_RT_CENTER, Status__c = 'Active');
    	insert objFacility;
        
        string loc = '38.2459027,-85.7704417';
        String city = 'Louisville';
        String state = 'KY';
        String zipCode = '40202';
        string accType;
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = ACCOUNT_RT_CENTER, NPI__c = '12', ShippingPostalCode = '40202', ShippingStreet = '680 S 4th S', ShippingCity = 'Louisville', ShippingState = 'KY');
        Insert objAccount;
        
        AA_CaseEntryController.getNearByAccounts(city, state, zipCode, loc, accType);
        
        String articleSearchString;
        String articleTypeFilter;
        
        AA_CaseEntryController.filterKnowledgeArticles(articleSearchString, articleTypeFilter);
        String selectedAccount = objFacility.Name + ' - ' + objFacility.Id;
        
        string theme = AA_CaseEntryController.getUIThemeDescription();
        test.stopTest();
        }
    	
    
    static testMethod void myUnitTest2() {
        Case activeCase = AA_CaseEntryController.getNewServerCase();
        Contact activeContact = AA_CaseEntryController.getExistingContact(activeCase);
        activeCase.ContactID = activeContact.ID;
        
        string streetAddr;
    	string cityAddr;
    	string stateAddr;
    	string zipAddr = '40202';
        AA_CaseEntryController.getGeocode(streetAddr, cityAddr, stateAddr, zipAddr);
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        
        LiveChatTranscript lct = new LiveChatTranscript(CaseID = activeCase.Id, LiveChatVisitorId = lcv.Id);
        insert lct;
        
        Patient_New__c activePatient = AA_CaseEntryController.getServerPatient(activeCase);
        Assessment__c activeAssessment = AA_CaseEntryController.getExistingAssessment(activePatient);
        
        AA_CaseEntryController.getLacunaFileList();
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = ACCOUNT_RT_CENTER, NPI__c = '12');
        Insert objAccount;
        
        string searchString = 'TestAccount';
        AA_CaseEntryController.searchFacilities(searchString);
        
        string articleSearchString = ''; 
        
        string articleTypeFilter = 'All';
        
        AA_CaseEntryController.filterKnowledgeArticles(articleSearchString, articleTypeFilter);
        
        articleSearchString = 'benefits';
        
        AA_CaseEntryController.filterKnowledgeArticles(articleSearchString, articleTypeFilter);
        articleSearchString = 'benefits';
        articleTypeFilter = 'Kindred';
        AA_CaseEntryController.filterKnowledgeArticles(articleSearchString, articleTypeFilter);
        
        articleTypeFilter = 'Gentiva';
        AA_CaseEntryController.filterKnowledgeArticles(articleSearchString, articleTypeFilter);
        
        test.startTest();
        AA_CaseEntryController.getCaseAndNavigate(lct.Id);
    	test.stopTest();
    	}
    	
    static testMethod void myUnitTest3(){
        Case glitchC = new Case(RecordTypeID = caseTemp);
        insert glitchC;
        Case activeCase = AA_CaseEntryController.getNewServerCase();
        test.startTest();
        Contact activeContact = AA_CaseEntryController.getNewServerContact();
        Account activeAccount = AA_CaseEntryController.getNewServerAccount();
        activeCase.Case_Notes__c = 'Test Description for Notes';
        Patient_New__c activePatient = AA_CaseEntryController.getNewServerPatient(activeContact);
        Assessment__c activeAssessment = AA_CaseEntryController.getNewServerAssessment(activePatient);
        
        AA_CaseEntryController.processSaveItems(activeCase, activeContact, activeAccount, activePatient, activeAssessment);
        
        activeContact.LastName = 'Testerly1';
        activeContact.FirstName = 'Important';
        
        activePatient.First_Name__c = 'NotAsImportant';
        activePatient.Last_Name__c = 'Testerlyington2';
        
        activeAssessment.Payor__c = 'Test Payor Name';
        
        
        
        AA_CaseEntryController.getAttachments(activeCase.Id);
        AA_CaseEntryController.getNoteHistory(activeCase.Id);
        AA_CaseEntryController.getExistingCase(activeCase.Id);
        
        AA_CaseEntryController.getExistingContact(activeCase);
        AA_CaseEntryController.getExistingAccount(activeCase, activeContact);
        AA_CaseEntryController.getServerPatient(activeCase);
        AA_CaseEntryController.getExistingAssessment(activePatient);
        AA_CaseEntryController.cancelReturn();
        list<ID> caseIDs = new list<ID>();
        caseIDs.add(activeCase.Id);
        AA_CaseEntryController.createContactAccountPatient(caseIDs);
        test.stopTest();
        AA_CaseEntryController.processCancelCase(activeCase, activeContact, activeAccount, activePatient, activeAssessment);
    	}
    	
    static testMethod void myUnitTest4(){
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = ACCOUNT_RT_CENTER, NPI__c = '12', ShippingPostalCode = '40202', ShippingStreet = '680 S 4th S', ShippingCity = 'Louisville', ShippingState = 'KY');
        Insert objAccount;
        string selectedAccount = objAccount.Name + ' - ' + objAccount.Id;
        test.startTest();
        AA_CaseEntryController.retreiveFacilityContent(selectedAccount);
        test.stopTest();
    	}
    	
    static testMethod void myUnitTest5(){
        Id caseRtGeneral = [Select SobjectType, Name, DeveloperName From RecordType where SobjectType = 'Case' AND DeveloperName = 'General_Inquiry'].Id;
        id contactTemp = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'contactTemp'].Id;
        id patientTemp = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Patient_New__c' AND DeveloperName = 'patientTemp'].Id;
        id assessmentTemp = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Assessment__c' AND DeveloperName = 'assessmentTemp'].Id;
        
        Case activeCase = new Case(Status = 'New',
								   Case_Source__c = 'Web', 
    							   Subtype__c = 'Service Recommendation',
    							   Call_Type__c = 'Clinical',
    							   Case_Notes__c = 'Test notes for processing', 
    							   Origin = 'Web', 
    							   Type = 'Lead', 
    							   Subject = 'Lead - Service Recommendation', 
    							   Level_Of_Care__c = 'LTACH', 
    							   Web_First_Name__c = 'Bob', 
    							   Web_Last_Name__c = 'Bobbington', 
    						 	   Web_Street_Address__c = '123 Bob Ln', 
    							   Web_State__c = 'KY',
    							   Web_City__c = 'Louisville', 
    							   Web_Zip_Code__c = '40202', 
    							   SuppliedPhone = '555-555-5555', 
    							   SuppliedEmail = 'noneya@buzzof.com',
    							   RecordTypeId = caseRtGeneral);
    							   
    	Contact activeContact = new Contact(LastName = 'ThisLastName',
            								FirstName = 'FirstLastName',
            								Phone = '555-555-5555',
            								HomePhone = '666-666-6666',
            								MobilePhone = '777-777-7777',
            								OtherPhone = '888-888-8888',
            								Email = 'test@none.com',
            								Email_Status__c = 'Refused',
            								MailingState = 'KY', 
            								MailingStreet = '680 S 4th St', 
            								MailingCity = 'Louisville', 
            								MailingPostalCode = '40202', 
        	    							RecordTypeId = contactTemp);
        	    							
        Account activeAccount = new Account(Name = 'Household of SecondLastName');
        
        Patient_New__c activePatient = new Patient_New__c(Last_Name__c = 'SecondLastName',
        												  First_Name__c = 'ThatFirstName',
    													  Status__c = 'Lead',
    													  Status_Detail__c = 'Lost',
    													  Consent_For_Callback__c = 'No',
														  Street__c = '55 Arbor Place',
    													  City__c = 'New Albany',
    													  Age__c = 55,
    													  State__c = 'IN',
    													  Postal_Code__c = '47150',
    													  Phone__c = '555-555-5555',
    													  E_mail__c = 'test@otherNone.com',
    													  Sex__c = 'Male',
    													  Middle_Initial__c = 'T',
    													  RecordTypeId = patientTemp);
        	    													   
        Assessment__c activeAssessment = new Assessment__c(Payor__c = 'Aetna',
														   Member_ID__c = 'Bletna',
									   					   Subscriber_Name__c = 'Cetna',
									   					   Secondary_Payor__c = 'Anthem',
									   					   Secondary_Member_ID__c = 'Blanthem',
									   					   Secondary_Subscriber_Name__c = 'Clanthem',
									   					   RecordTypeID = assessmentTemp);
        
        test.startTest();
        AA_CaseEntryController.processSaveItems(activeCase, activeContact, activeAccount, activePatient, activeAssessment);
        AA_CaseEntryController.getCaseRecordType(activeCase.Id);
        list<ID> caseIDs = new list<ID>();
        caseIDs.add(activeCase.Id);
        AA_CaseEntryController.createContactAccountPatient(caseIDs);
        test.stopTest();
    	}				
    	
    	
    static testMethod void myUnitTest6(){
    	string loc = '38.2459027,-85.7704417';
        String city;
        String state;
        String zipCode;
        string accType;
        
        AA_CaseEntryController.getNearByAccounts(city, state, zipCode, loc, accType);
    	}
    	
    static testMethod void myUnitTest7(){
    	AA_CaseEntryController.getChoices();
    	AA_CaseEntryController.getGeneral();
    	AA_CaseEntryController.getAfter();
    	AA_CaseEntryController.getUIThemeDescription();
    	
    	}
    		
}