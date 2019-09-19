global with sharing class AA_CaseEntryController{

	private static Id contactRTIndividual = AA_UtilityClass.getindvCtc;
    private static Id accountRtHousehold = AA_UtilityClass.gethouseAcc;
    private static Id caseRtReferral = AA_UtilityClass.getCaseReferralID;
    private static Id caseRtGeneral = AA_UtilityClass.getCaseInquiryID;
    private static Id accountCenter = AA_UtilityClass.getCenterID;     
    private static id caseTemp = AA_UtilityClass.getCaseTempID;
    private static id contactTemp = AA_UtilityClass.gettempContact;
    private static id accountLacTemp = AA_UtilityClass.getAccountTempID;
    private static id patientTemp = AA_UtilityClass.getPatientTempID;
    private static id assessmentTemp = AA_UtilityClass.getAssessmentTempID;
    private static id patientValid = AA_UtilityClass.getPatientValidID;
    private static id assessmentValid = AA_UtilityClass.getAssessmentValidID;
    private static id ParentLibraryID = [SELECT ID FROM ContentWorkspace WHERE Name = 'Lacuna Documentation'].ID;
    
    //public pdfWrapper formWrap	{get;set;}
    
    @future
    public static void createContactAccountPatient(list<ID> caseIDs){
    	system.debug('caseIDs: ' + caseIDs);
    	try{
    	list<Case> cases = new list<Case>();
    	list<Case> toUpdate = new list<Case>();
    	cases = [SELECT ID,
    					Case_Notes__c, 
    					Contact_First_Name__c, 
    					Contact_Last_Name__c,
    					Contact_Phone__c, 
    					ContactID, 
    					Patient_Last_Name__c, 
    					Patient_First_Name__c,
    					Patient_DOB__c,
    					Patient_Gender__c,
    					Patient_New__c
    					FROM Case WHERE ID IN: caseIDs];
    	
    	for(Case c: cases){
    		Case activeCase = c;
    		Patient_New__c activePatient = new Patient_New__c();
    		Contact activeContact = new Contact();
    		Account activeAccount = new Account();
    		
    		activePatient.Last_Name__c = c.Patient_Last_Name__c;
    		activePatient.First_Name__c = c.Patient_First_Name__c;
    		activePatient.Date_of_Birth__c = c.Patient_DOB__c;
    		activePatient.Sex__c = c.Patient_Gender__c;
    		activePatient.RecordTypeID = patientValid;
    		
    		activeContact.LastName = c.Contact_Last_Name__c;
    		activeContact.FirstName = c.Contact_First_Name__c;
    		activeContact.Phone = c.Contact_Phone__c;			
    		activeContact.RecordTypeId = contactRTIndividual;
    		
    		if(activePatient.Last_Name__c != null){
        		if(activePatient.First_Name__c == null || activePatient.First_Name__c == ''){
           			activeAccount.name = 'The Household of ' + activePatient.Last_Name__c;	
           			}
       			else{
            		activeAccount.name = 'The Household of ' + activePatient.First_Name__c + ' ' + activePatient.Last_Name__c;
            		}
        		}
        	else{
           		if(activeContact.FirstName == '' || activeContact.FirstName == null){
               		activeAccount.Name =  'The Household of ' + activeContact.LastName;	
           			}
           		else{
	           		activeAccount.Name =  'The Household of ' + activeContact.FirstName + ' ' + activeContact.LastName;
    	       		}
        		}
        	activeAccount.RecordTypeID = accountRtHousehold;	
        	insert activeAccount;	
    		
    		if(activeContact != null && activeContact.LastName != null){
    			activeContact.AccountID = activeAccount.ID;
    			insert activeContact;
    			}
    		
    		if(activePatient != null && activePatient.Last_Name__c != null){
    		 system.debug('newPatient: ' + activePatient);
    			if(((activeContact.FirstName != activePatient.First_Name__c) || (activeContact.LastName != activePatient.Last_Name__c))){
                        Contact objPatientContact = new Contact(FirstName = activePatient.First_Name__c, 
                                                                LastName = activePatient.Last_Name__c, 
                                                                AccountId = ActiveAccount.Id, 
                                                                RecordTypeId = contactRTIndividual, 
                                                                phone = activePatient.Phone__c, 
                                                                Email = activePatient.E_mail__c);
                        insert objPatientContact;
                        
                        activePatient.Contact__c = objPatientContact.Id;
                        activePatient.Parent_Contact__c = activeContact.Id;
                    	}
            insert activePatient;
    		}
    			
    		if(activePatient.ID != null){
    			activeCase.Patient_New__c = activePatient.Id;
    			}
    		if(activeContact.Id != null){
    			activeCase.ContactId = activeContact.Id;
    			}
    		toUpdate.add(activeCase);	
    		}
    		
    		if(toUpdate.size() > 0){
    			update toUpdate;
    			}
    	}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		}
    	}
    
    @AuraEnabled(cacheable=true)
	public static list<RecordType> getChoices(){
		try{
			list<RecordType> rtList = new list<RecordType>();
			rtList = [SELECT ID, Name FROM RecordType WHERE sObjectType = 'Case' AND (DeveloperName = 'AfterHours' OR DeveloperName = 'General_Inquiry')]; 
			return rtList;
			}
		catch(Exception e){
			system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			return null;
			}	
		}
	
	@AuraEnabled(cacheable=true)
	public static ID getGeneral(){
		ID generalID;
		generalID = AA_UtilityClass.getCaseInquiryID;
		return generalID;
		}	
		
	@AuraEnabled(cacheable=true)
	public static ID getAfter(){
		ID afterID;
		afterID = AA_UtilityClass.getCaseAfterHoursID;
		return afterID;
		}
		
	@AuraEnabled
	public static ID getCaseRecordType(ID recordId){
		try{
			ID recordTypeID = [SELECT RecordTypeID FROM Case WHERE ID =: recordId].RecordTypeID;
			return recordTypeID;
			}
		catch(Exception E){
			system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			return null;
			}	
		}    
    
    @AuraEnabled(cacheable=true)
	public static list<string> getEmailStatusList(){
		list<string> EmailStatusList = new list <string>();
		EmailStatusList.add('--None--');
		EmailStatusList.add('Valid');
		EmailStatusList.add('Refused');
		EmailStatusList.add('No email');
		return EmailStatusList;
		}
		
	@AuraEnabled(cacheable=true)
	public static list<string> getLOCList(){
		list<string> locList = new list <string>();
		locList.add('--None--');
		locList.add('ALF');
		locList.add('ARU');
		locList.add('CC');
		locList.add('HH');
		locList.add('HP');
		locList.add('IHPC');
		locList.add('IRF');
		locList.add('PHCA');
		locList.add('SAU');
		locList.add('TCH');
		locList.add('TCC/SNF');
		locList.add('Not Applicable');
		return locList;
		}	
	
	@AuraEnabled(cacheable=true) 
    public static list<string> getPhoneTypeList(){
    	list<string> phoneTypeList = new list<string>();
    	phoneTypeList.add('Phone');
        phoneTypeList.add('Home Phone');
        phoneTypeList.add('Mobile');
        phoneTypeList.add('Other');
    	return phoneTypeList;
    	}
    
    @AuraEnabled(cacheable=true) 
    public static list<string> getFacilityTypeList(){
    	list<string> facilityTypeList = new list<string>();
    	facilityTypeList.add('--None--');
    	facilityTypeList.add('ALF');
		facilityTypeList.add('ARU');
		facilityTypeList.add('CC');
		facilityTypeList.add('HH');
		facilityTypeList.add('HP');
		facilityTypeList.add('IHPC');
		facilityTypeList.add('IRF');
		facilityTypeList.add('PHCA');
		facilityTypeList.add('SAU');
    	facilityTypeList.add('TCH');
		facilityTypeList.add('TCC/SNF');
		return facilityTypeList;
    	}
    
    @AuraEnabled 
    public static Case getNewServerCase(){
    	Case activeCase = new Case();
    	try{
    		Case tempCase = new Case();
    		tempCase.RecordTypeId = caseTemp;
    		insert tempCase;
    		activeCase = [SELECT Id,
    							 Status,
    							 CaseNumber,
    					 		 Description, 
    					 		 Case_Source__c, 
    					 		 Subtype__c,
    					 		 Call_Type__c,
    					 		 Case_Notes__c, 
    					 		 Origin, 
    					 		 Type, 
    					 		 Subject, 
    					 		 ContactId, 
    					 		 Assessment__c, 
    					 		 Patient_New__c, 
    					 		 AccountId, 
    					 		 Level_Of_Care__c, 
    					 		 Web_First_Name__c, 
    					 		 Web_Last_Name__c, 
    					 		 Web_Street_Address__c, 
    					 		 Web_State__c, 
    					 		 Web_City__c, 
    					 		 Web_Zip_Code__c, 
    					 		 SuppliedPhone, 
    					 		 SuppliedEmail,
    					 		 RecordTypeId
    					 		 FROM Case 
    					 		 WHERE ID =: tempCase.Id];
    			
    		system.debug('activeCase: ' + activeCase);
    		return activeCase;
    		}
    	catch(Exception err){
    		system.debug('Error: ' + err.getMessage() + ' Line: ' + err.getLineNumber());
    		return null;
    		}	
    	}
    
    @AuraEnabled 
    public static Case getExistingCase(ID recordId){
    	system.debug('recordID: ' + recordId);
    	Case activeCase = new Case();
    	try{
    		activeCase = [SELECT Id,
    							 CaseNumber,
    					 		 Description, 
    					 		 Case_Source__c, 
    					 		 Subtype__c,
    					 		 Call_Type__c,
    					 		 Case_Notes__c, 
    					 		 Origin, 
    					 		 Type, 
    					 		 Subject, 
    					 		 ContactId, 
    					 		 Status,
    					 		 Assessment__c, 
    					 		 Patient_New__c, 
    					 		 AccountId, 
    					 		 Level_Of_Care__c, 
    					 		 Web_First_Name__c, 
    					 		 Web_Last_Name__c, 
    					 		 Web_Street_Address__c, 
    					 		 Web_State__c, 
    					 		 Web_City__c, 
    					 		 Web_Zip_Code__c, 
    					 		 SuppliedPhone, 
    					 		 SuppliedEmail,
    					 		 RecordTypeId
    					 		 FROM Case 
    					 		 WHERE ID =: recordId];
    				
    		system.debug('activeCase: ' + activeCase);
    		return activeCase;
    		}
    	catch(Exception err){
    		system.debug('Error: ' + err.getMessage() + ' Line: ' + err.getLineNumber());
    		return null;
    		}
    	}
    	
    @AuraEnabled	
    public static Contact getExistingContact(Case activeCase){
    	Contact activeContact = new Contact();
    	try{
    		if(activeCase.ContactId != null){
    				activeContact = [SELECT LastName,
            								FirstName,
            								AccountID, 
            								Phone,
            								Extension__c,
            								Level_of_Care__c,
            								HomePhone,
            								MobilePhone,
            								OtherPhone,
            								Case_State__c,
            								Email,
            								Email_Status__c,
            								Facility__c,
            								Facility__r.Name,
            								MailingState, 
            								MailingStreet, 
            								MailingCity, 
            								MailingPostalCode, 
        	    							Caller_id__c,
            								RecordTypeId
                	           	  			FROM Contact
                    	       	  			WHERE Id =: activeCase.ContactId
                        	      			LIMIT 1];
                    system.debug('activeContact 1st check' + activeContact);
    				}
    			if(activeCase.ContactId == null){
    				Contact tempContact = new Contact();
    				tempContact.RecordTypeId = contactTemp;
    				tempContact.LastName = 'Last Name';
    				insert tempContact;
    		
    				activeContact = [SELECT LastName,
            							FirstName,
            							AccountID, 
            							Phone,
            							Extension__c,
            							Level_of_Care__c,
            							HomePhone,
            							MobilePhone,
            							OtherPhone,
            							Case_State__c,
            							Email,
            							Email_Status__c,
            							Facility__c,
            							Facility__r.Name,
            							MailingState, 
            							MailingStreet, 
            							MailingCity, 
            							MailingPostalCode, 
            							Caller_id__c,
            							RecordTypeId
                       		  			FROM Contact
                       		  			WHERE Id =: tempContact.Id
                       	    			LIMIT 1];
    				system.debug('activeContact 2nd check' + activeContact);				
    				}
    			return activeContact;	
    			}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}
    	}
    	
    @AuraEnabled	
    public static Contact getNewServerContact(){
    	Contact activeContact = new Contact();
    	try{
    		Contact tempContact = new Contact();
    		tempContact.RecordTypeId = contactTemp;
    		tempContact.LastName = 'Last Name';
    		insert tempContact;
    		
    		activeContact = [SELECT LastName,
            						FirstName,
            						AccountID, 
            						Phone,
            						Extension__c,
            						Level_of_Care__c,
            						HomePhone,
            						MobilePhone,
            						OtherPhone,
            						Case_State__c,
            						Email,
            						Email_Status__c,
            						Facility__c,
            						Facility__r.Name,
            						MailingState, 
            						MailingStreet, 
            						MailingCity, 
            						MailingPostalCode, 
            						Caller_id__c,
            						RecordTypeId
                       	  			FROM Contact
                       	  			WHERE Id =: tempContact.Id
                           			LIMIT 1];
    		system.debug('active Contact: ' + activeContact);
    		return activeContact;
    		}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}		
    	}	
    
    @AuraEnabled
    public static Account getNewServerAccount(){
    	Account activeAccount = new Account();
    	try{
    		Account tempAccount = new Account();
    		tempAccount.Name = 'Temp Case Account';
    		tempAccount.RecordTypeId = accountLacTemp;
    		insert tempAccount;
    		
    		activeAccount = [SELECT ID, 
    								Name,
    								Type,
    								RecordTypeId
    								FROM Account
    								WHERE ID =: tempAccount.Id];
    		system.debug('Active account: ' + activeAccount);						
    		return activeAccount;
    		}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}	
    	}
    	
    @AuraEnabled
    public static Account getExistingAccount(Case activeCase, Contact activeContact){
    	system.debug('ActiveCase: ' + activeCase);
    	Account activeAccount = new Account();
    	try{
    	if(String.isNotBlank(string.valueOf(activeCase.AccountId))){
    			activeAccount = [SELECT ID, 
    									Name,
    									Shipping_Geolocation__Latitude__s, 
    									Shipping_Geolocation__Longitude__s,
    									Type,
    									RecordTypeId
    									FROM Account
    									WHERE ID =: activeCase.AccountId];
    		}
    	else{
    		Account tempAccount = new Account();
    		tempAccount.RecordTypeId = accountLacTemp;
    		tempAccount.Name = 'The Household of ' + activeContact.FirstName + ' ' + activeContact.LastName;
    		tempAccount.Type = activeCase.Level_Of_Care__c;
    		insert tempAccount;
    		
    		activeAccount = [SELECT ID, 
    								Name,
    								Shipping_Geolocation__Latitude__s, 
    								Shipping_Geolocation__Longitude__s,
    								Type,
    								RecordTypeId
    								FROM Account
    								WHERE ID =: tempAccount.Id];
    		}
        	return activeAccount;
    		}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}	
    	}
    
    @AuraEnabled
    public static Patient_New__c getNewServerPatient(Contact activeContact){
    	Patient_New__c activePatient = new Patient_New__c();
    	try{
    		Patient_New__c tempPatient = new Patient_New__c();
    		tempPatient.RecordTypeId = patientTemp;
    		tempPatient.Contact__c = activeContact.ID;
    		tempPatient.Last_Name__c = 'temp';
    		insert tempPatient;
    		system.debug('tempPatient: ' + tempPatient);
    		activePatient = [SELECT ID,
    								Name,
    								Status__c,
    								Status_Detail__c,
    								Consent_For_Callback__c,
    								Next_Call_Date__c,
    								Lead_Lost_Date__c,
    								Street__c,
    								City__c,
    								Age__c,
    								State__c,
    								Postal_Code__c,
    								Phone__c,
    								E_mail__c,
    								Sex__c,
    								Date_of_Birth__c,
    								Suffix__c,
    								Last_Name__c,
    								Middle_Initial__c,
    								First_Name__c,
    								RecordTypeId
    								FROM Patient_New__c
    								WHERE Id =: tempPatient.ID];
				system.debug('activePatient: ' + activePatient);    								
    			return activePatient;	
    			}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}	
    	}
    
    @AuraEnabled
    public static Patient_New__c getServerPatient(Case activeCase){
    	Patient_New__c activePatient = new Patient_New__c();
    	system.debug('activeContact' + activeCase);
    	try{
    		if(activeCase.Patient_New__c != null){
    		activePatient = [SELECT ID,
    								Name,
    								Status__c,
    								Status_Detail__c,
    								Consent_For_Callback__c,
    								Next_Call_Date__c,
    								Lead_Lost_Date__c,
    								Street__c,
    								City__c,
    								State__c,
    								Age__c,
    								Postal_Code__c,
    								Phone__c,
    								E_mail__c,
    								Sex__c,
    								Date_of_Birth__c,
    								Suffix__c,
    								Last_Name__c,
    								Middle_Initial__c,
    								First_Name__c
    								FROM Patient_New__c
    								WHERE Id =: activeCase.Patient_New__c];
    				system.debug('activePatient 1st check' + activePatient);
    				}
    			else if(activeCase.Patient_New__c == null){
    				Patient_New__c tempPatient = new Patient_New__c();
    				tempPatient.RecordTypeId = patientTemp;
    				tempPatient.Contact__c = activeCase.ContactId;
    				tempPatient.Last_Name__c = 'temp';
    				insert tempPatient;
    		
					activePatient = [SELECT ID,
    										Name,
    										Status__c,
    										Status_Detail__c,
    										Consent_For_Callback__c,
    										Next_Call_Date__c,
    										Lead_Lost_Date__c,
    										Street__c,
    										City__c,
    										State__c,
    										Age__c,
    										Postal_Code__c,
    										Phone__c,
    										E_mail__c,
    										Sex__c,
    										Date_of_Birth__c,
    										Suffix__c,
    										Last_Name__c,
    										Middle_Initial__c,
    										First_Name__c,
    										RecordTypeId
    										FROM Patient_New__c
    										WHERE Id =: tempPatient.ID];
    				system.debug('activePatient 2nd check' + activePatient);				
    				}
    			return activePatient;	
    			}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}		
    	}
    	
    @AuraEnabled
    public static Assessment__c getNewServerAssessment(Patient_New__c activePatient){
    	Assessment__c activeAssessment = new Assessment__c();
    	try{
    		system.debug('activePatient: ' + activePatient);
    		Assessment__c tempAssessment = new Assessment__c();
    		tempAssessment.RecordTypeId = assessmentTemp;
    		tempAssessment.Patient__c = activePatient.ID;
    		insert tempAssessment;
    		
    		activeAssessment = [SELECT ID,
    								   Name,
									   Clinical_Appropriateness__c,
									   CreatedById,
									   LastModifiedById,
									   Medical_Surgical_History__c,
									   Patient__c,
									   Preferred_Facility__c,
									   Preferred_Facility__r.Name,
									   Primary_Conditions__c,
									   Primary_Insurance_Name__c,
									   Primary_Payer_Source__c,
									   Payor__c,
									   Member_ID__c,
									   Subscriber_Name__c,
									   Primary_Reason_for_LTAC_Admission__c,
									   Referral_Notes__c,
									   Referral_Time__c,
									   Referring_Facility__c,
									   Secondary_Payor__c,
									   Secondary_Member_ID__c,
									   Secondary_Payer_Source__c,
									   Secondary_Subscriber_Name__c,
									   Status__c,
									   Type_of_Admission__c,
									   RecordTypeId
    								   FROM Assessment__c
    								   WHERE Id =: tempAssessment.ID];
    			
    			return activeAssessment;
    			}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}	
    	}
    
    @AuraEnabled
    public static Assessment__c getExistingAssessment(Patient_New__c activePatient){
    	Assessment__c activeAssessment = new Assessment__c();
    	try{
    		activeAssessment = [SELECT ID,
    								   Name,
									   Clinical_Appropriateness__c,
									   CreatedById,
									   LastModifiedById,
									   Medical_Surgical_History__c,
									   Patient__c,
									   Preferred_Facility__c,
									   Preferred_Facility__r.Name,
									   Payor__c,
									   Member_ID__c,
									   Subscriber_Name__c,
									   Primary_Conditions__c,
									   Primary_Insurance_Name__c,
									   Primary_Payer_Source__c,
									   Primary_Reason_for_LTAC_Admission__c,
									   Referral_Notes__c,
									   Referral_Time__c,
									   Referring_Facility__c,
									   Secondary_Payor__c,
									   Secondary_Member_ID__c,
									   Secondary_Payer_Source__c,
									   Secondary_Subscriber_Name__c,
									   Status__c,
									   Type_of_Admission__c,
									   RecordTypeId
    								FROM Assessment__c
    								WHERE Patient__c =: activePatient.ID];
    			return activeAssessment;
    			}
    			catch(Exception e2){
    			try{
    			Assessment__c tempAssessment = new Assessment__c();
    				tempAssessment.RecordTypeId = assessmentTemp;
    				tempAssessment.Patient__c = activePatient.ID;
    				insert tempAssessment;
    		
    				activeAssessment = [SELECT ID,
    										   Name,
											   Clinical_Appropriateness__c,
											   CreatedById,
											   LastModifiedById,
											   Medical_Surgical_History__c,
											   Patient__c,
											   Preferred_Facility__r.Name,
											   Payor__c,
											   Member_ID__c,
											   Subscriber_Name__c,
											   Primary_Conditions__c,
											   Primary_Insurance_Name__c,
											   Primary_Payer_Source__c,
											   Primary_Reason_for_LTAC_Admission__c,
											   Referral_Notes__c,
											   Referral_Time__c,
											   Referring_Facility__c,
											   Secondary_Payor__c,
											   Secondary_Member_ID__c,
											   Secondary_Payer_Source__c,
											   Secondary_Subscriber_Name__c,
											   Status__c,
											   Type_of_Admission__c,
											   RecordTypeId
    										   FROM Assessment__c
    										   WHERE Id =: tempAssessment.ID];
    										   return activeAssessment;		
    				}
    			catch(Exception e){
    				system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    				return null;
    				}	
    			}
    	}		
    
    @AuraEnabled()
    public static integer getServerAge(Date birthDate){
    	integer age = 0;
    	try{
    		Date checkDate = system.today();
    		Integer numberDaysDue = birthDate.daysBetween(checkDate);
    		age = Math.round((numberDaysDue/365));
    		return age;
    		}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return age;
    		}	
    	}
    
   	@AuraEnabled(cacheable=true)
    public static string getGeocode(string streetAddr, string cityAddr, string stateAddr, string zipAddr){
    	
    	string street =  '';
    	
    	if(string.isBlank(streetAddr) || streetAddr == null){
    		street = '123 St';
    		}
    	else{
    		street = streetAddr;
    		}	
    	string city = cityAddr;
    	string state = stateAddr;
    	string zip = zipAddr;
    	string country = 'USA';
    	string loc = '';
    	system.debug('streetAddr: ' + streetAddr);
    	system.debug('cityAddr: ' + cityAddr);
    	system.debug('stateAddr: ' + stateAddr);
    	system.debug('zipAddr: ' + zipAddr);
    	
    	Map<String, Double> geocode = new Map<String, Double> {'Latitude' => null, 'Longitude' => null};
        HttpResponse res = new HttpResponse();
    	try{
    		if(city != null && state != null && zip != null){
    	// init variable to hold our result latitude and longitude
        	try{
            	// create an address string
        		String address = GeoGoogleForBusiness.AddressString(street, city, state, zip, country);
            	HttpRequest req = GeoGoogleForBusiness.GeocodeRequest(address);
                Http h = new Http();
            	// allow follow on lines to proceed for code coverage if this is a test
            	if(Test.isRunningTest()){
            		system.debug('Test Confirmed');
            		}
            	else{	
            		res = h.send(req);
            		}
            		String jsonResult;
            		if(!test.isRunningTest()){
            			jsonResult = res.getBody();
            			}
            		else{
            			jsonResult = AA_UtilityClass.getTestJSON;
            			}	
            		System.Debug(jsonResult);
            		loc = GeoGoogleForBusiness.ExtractLatLongAlt(jsonResult);
        			system.debug('geoCode: ' + geocode);
        			}
        	catch(Exception e){
	        	System.debug(e.getMessage());
    	    	}
        	return loc;
    			}
    		else{
    			try{
            	// create an address string
        		String address = GeoGoogleForBusiness.AddressString(street, city, state, zip, country);
            	HttpRequest req = GeoGoogleForBusiness.GeocodeRequest(address);
                Http h = new Http();
            	// allow follow on lines to proceed for code coverage if this is a test
            	if(Test.isRunningTest()) {
            		system.debug('Test Confirmed');     
            		}
            	else{	
            		res = h.send(req);
            		}
            		String jsonResult;
            		if(!test.isRunningTest()){
            			jsonResult = res.getBody();
            			}
            		else{
            			jsonResult = AA_UtilityClass.getTestJSON;
            			}
            		System.Debug('zip only: ' + jsonResult);
            		JSONParser parser = JSON.createParser(jsonResult);
					string latLon = '';
					double lat = null;
        			double lon = null;
            
	 	       while (parser.nextToken() != null){
            		if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'formatted_address')){
	               		while (parser.nextToken() != JSONToken.END_OBJECT) {
	                   		String txt = parser.getText();
	                   		parser.nextToken();
	                   		if (txt == 'lat'){
	                       		lat = parser.getDoubleValue();
	                   			}
	                   		else if (txt == 'lng'){
	                       		lon = parser.getDoubleValue();
	                   			}
	               		}
            		}
        		}
        		//Must have good coords in both or we'll return nulls in both
        		if(lat == null || lon == null) {
        			loc = latLon;
        			}
        		else{
        			latLon = lat + ',' + lon;
        			loc = latLon;
        			}
        			system.debug('Zip only Loc: ' + loc);
        			}
        	catch(Exception e){
	        	System.debug(e.getMessage());
    	    	}
        	return loc;
    			}
    		}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}
    	}
    
    /*
    Method Name: getNearByAccounts
    Return Type: void
    Description; To search account in 100 mile radius based on given geolocation  where record type is 'Center'
    */
    @AuraEnabled(cacheable=true) 
    public static List<LocationMap> getNearByAccounts(String city, String state, String zipCode, string loc, string accType){
    	List<LocationMap> result = new List<LocationMap>();
    	Integer maxDistance = 100;
      	system.debug('city: ' + city);
      	system.debug('state: ' + state);
      	system.debug('zipCode: ' + zipCode);
      	system.debug('location: ' + loc);
      	system.debug('Facility Type: ' + accType);
      	
      	string latitude = '';
      	string longitude = '';
      	try{
      		latitude = loc.substringBefore(',').trim();
      		longitude = loc.substringAfter(',').trim();
      	
      		decimal lat = decimal.valueOf(latitude);
      		decimal lon = decimal.valueOf(longitude);
      		
      		system.debug('latitude: ' + latitude);
      		system.debug('longitude: ' + longitude);
      	
      		Location loc1 = Location.newInstance(lat, lon);

        	String strQueryString;
        	string status = 'Active';
        	strQueryString = 'SELECT Name, Central_Intake_Email__c, Facility_Number__c, ShippingStreet, ShippingLatitude, Shipping_Geolocation__Longitude__s, Shipping_Geolocation__Latitude__s, ShippingLongitude, ShippingCity, ShippingState, ShippingCountry, Type, Phone, ShippingPostalCode FROM Account WHERE RecordTypeId = : accountCenter AND Type != null AND Status__c=: status';
           	if(accType != '' && accType != '--None--' && accType != null){
           		strQueryString += ' AND Type =: accType';
           		}
        	if(city != '' || zipCode != '' ){
        		strQueryString += ' AND DISTANCE(Shipping_Geolocation__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\') < '+ maxDistance+
                	                ' ORDER BY DISTANCE(Shipping_Geolocation__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\') limit 250';
        		}
        	else if(state != ''){     
            	strQueryString +=' AND ShippingState = : state ORDER BY DISTANCE(Shipping_Geolocation__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\') ASC limit 250';
        		}
    		system.debug('query: ' + strQueryString);
        	List<Account> accounts = new List<Account>();
        	if(!test.isRunningTest()){
        		accounts = Database.query(strQueryString);
        		}
        	else{
        		accounts = AA_UtilityClass.getTestList;
        		}	
        	system.debug('Accounts: ' + accounts);
        	
        	list<ID> accIDs = new list<ID>();
        	for(Account a: accounts){
        		accIDs.add(a.ID);
        		}
        		
        		map<ID, Integer> accContentMap = new map<ID, Integer>();
        		
        		for(AggregateResult agrA :  [SELECT COUNT(Id) countIds, 
        						Center__c accID
        						FROM ContentVersion 
                				WHERE Center__c IN:accIDs 
                				AND IsLatest = true 
                				AND  FileType In ('MP4','PDF')
                				Group By Center__c 
                				]){
								accContentMap.put(string.valueOf(agrA.get('accID')), integer.valueOf(agrA.get('countIds')));                					
                				}
        		
        	 for(Account acc :accounts){
        	 	GeoLocation geoInfo = new GeoLocation();
            	geoInfo.street = acc.ShippingStreet;
            	geoInfo.postalCode = acc.ShippingPostalCode;
            	geoInfo.city = acc.ShippingCity;
            	geoInfo.state = acc.ShippingState;
            	geoInfo.country = 'USA';
            	geoInfo.latitude = acc.ShippingLatitude;
            	geoInfo.longitude = acc.ShippingLongitude;
            	LocationMap locDetail = new LocationMap();
            	Location loc2 = Location.newInstance(acc.Shipping_Geolocation__Latitude__s, acc.Shipping_Geolocation__Longitude__s);
            	system.debug('Loc1: ' + loc1 + 'Loc2: ' + loc2);
            	decimal dist = Location.getDistance(loc1, loc2, 'mi');
            	if(dist != null){
            		dist = dist.setScale(2);
            		}
            	locDetail.icon = 'standard:account'; 
            	locDetail.title = acc.Name  + ': ' + acc.Facility_Number__c;
            	locDetail.description = acc.ShippingStreet + ' ' + 
            							acc.ShippingCity + ', ' + acc.ShippingState + ' ' + acc.ShippingPostalCode;
				locDetail.street = acc.ShippingStreet;
				locDetail.city = acc.ShippingCity;
				locDetail.state = acc.ShippingState;
				locDetail.zip = acc.ShippingPostalCode;
				locDetail.dist = dist  + ' mi';
				locDetail.accType = acc.Type;             							
            	if(acc.Phone != null){
            		locDetail.phone = acc.Phone;
            		}
            	locDetail.contentCount = 0;
            	if(accContentMap.get(acc.ID) != null){
                    locDetail.contentCount = accContentMap.get(acc.ID);
                    }
                locDetail.accId = acc.Id;    
            	
            	locDetail.location = geoInfo;
            	result.add(locDetail);
            		}
        	system.debug('mapPips: ' + result);
        	return result;
        	}
      	catch(Exception e){
      		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
      		return null;
      		}	
    	}    
    
    public class LocationMap{
        @AuraEnabled 
        public String icon	{get;set;} 
        @AuraEnabled 
        public String title	{get;set;} 
        @AuraEnabled
        public String description	{get;set;}
        @AuraEnabled
        public String street	{get;set;}
        @AuraEnabled
        public String city	{get;set;}
        @AuraEnabled
        public String state	{get;set;}
        @AuraEnabled
        public String zip	{get;set;}
        @AuraEnabled
        public String phone	{get;set;}
        @AuraEnabled
        public String dist	{get;set;} 
        @AuraEnabled 
        public GeoLocation location	{get;set;}
        @AuraEnabled 
        public integer contentCount	{get;set;}
        @AuraEnabled
        public string accId	{get;set;}
        @AuraEnabled
        public string accType	{get;set;} 
    	}
    	
    public class GeoLocation{
        @AuraEnabled 
        public String Street	{get;set;}
        @AuraEnabled 
        public String PostalCode	{get;set;}
        @AuraEnabled 
        public String City	{get;set;}
        @AuraEnabled 
        public String State	{get;set;}
        @AuraEnabled 
        public String country	{get;set;}
        @AuraEnabled 
        public decimal Latitude	{get;set;}
        @AuraEnabled 
        public decimal Longitude	{get;set;}
    	}
    
    /*
    Method Name: retreiveFacilityContent
    Return type: List<ContentVersion> 
    Description: called when we click on facility either at map or at list of faclity and retrun related Content of facility
    */
    @AuraEnabled
    public static List<ContentVersion> retreiveFacilityContent(String selectedAccount){
    	system.debug('selectedAccount: ' + selectedAccount);
    	try{
    		string id = selectedAccount.substringAfterLast('-').trim();
    		Id accId = id;
        	return [SELECT Id, Title, FileType, ContentDocumentId, ContentSize 
            	    FROM ContentVersion 
                	WHERE Center__c =:accId And IsLatest = true And  FileType In ('MP4','PDF') ORDER BY Title LIMIT 1000];
    		}
    	catch(Exception E){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}	
    	}
    	
    @AuraEnabled
    public static list<noteWrapper> getNoteHistory(ID id){
    	system.debug('ID: ' + id);
    	list<ContentNote> history = new list<ContentNote>();
    	list<noteWrapper> notes = new list<noteWrapper>();
    	list<ID> users = new list<ID>();
    	try{
    		list<ContentDocumentLink> linkList = new list<ContentDocumentLink>();
    		list<ID> linkIDs = new list<ID>();
    		linkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: id];
    		for(ContentDocumentLink cdl : linkList){
    			linkIDs.add(cdl.ContentDocumentId);
    			}	
    		history = [SELECT ID, Title, TextPreview, CreatedDate, OwnerID, LastModifiedDate FROM ContentNote WHERE ID IN: linkIDs];
    		system.debug('History: ' + history);
    		for(ContentNote n : history){
    			users.add(n.OwnerID);
    			}
    		list<User> usr = new list<User>();
    		usr = [SELECT ID, Name FROM User WHERE ID IN: users];
    	
    		for(User u: usr){
    			for(ContentNote n2 : history){
    				if(n2.OwnerID == u.ID){
    					notes.add(new noteWrapper(n2, u.Name));
    					}
    				}
    			}
    		system.debug('Notes: ' + notes);	
    		return notes;
    		}
    	catch(Exception E){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}
    	}
    	
    public class noteWrapper{
    	@AuraEnabled
    	public ContentNote n	{get;set;}
    	@AuraEnabled
    	public string userName	{get;set;}
    	
    	public noteWrapper(ContentNote n, string userName){
    		this.n = n;
    		this.userName = userName;
    		}
    
    	}		
    
    @AuraEnabled 
    public static string processSaveItems(Case activeCase, Contact activeContact, Account activeAccount, Patient_New__c activePatient, Assessment__c activeAssessment){
    	string result = '';
    	try{
    		system.debug('Case: ' + activeCase);
    		system.debug('Contact: ' + activeContact);
    		system.debug('Account: ' + activeAccount);
    		system.debug('Patient: ' + activePatient);
    		system.debug('Assessment: ' + activeAssessment);
    		if(activeCase != null){
    			activeCase.RecordTypeID = caseRtGeneral;
    			}
    		if(activeContact != null){
    			activeContact.AccountID = activeAccount.Id;
    			activeContact.RecordTypeID = contactRTIndividual;
    			activeContact.Case_Origin__c = activeCase.Origin;
    			try{
    				upsert activeContact;
    				activeCase.ContactId = activeContact.Id;
    				}
    			catch(Exception ctc){
    				system.debug('Error: ' + ctc.getMessage() + ' Line: ' + ctc.getLineNumber());
    				result = 'Error: ' + ctc.getMessage() + ' Line: ' + ctc.getLineNumber();
    				return result;
    				}	
    			}
    		if(activeAccount != null){
    			activeAccount.RecordTypeId = accountRtHousehold;
    			try{
    				upsert activeAccount;
    				}
    			catch(Exception acc){
    				system.debug('Error: ' + acc.getMessage() + ' Line: ' + acc.getLineNumber());
    				result = 'Error: ' + acc.getMessage() + ' Line: ' + acc.getLineNumber();
    				return result;
    				}	
    		
    		if(activePatient != null && activePatient.Last_Name__c != 'temp' && activePatient.Last_Name__c != ''){
    		 	system.debug('activePatient: ' + activePatient);
    			if(((activeContact.FirstName != activePatient.First_Name__c) || (activeContact.LastName != activePatient.Last_Name__c) || 
                                        (activeContact.phone != activePatient.Phone__c) || (activeContact.Email != activePatient.E_mail__c))){
                        
                        Contact objPatientContact = new Contact(FirstName = activePatient.First_Name__c, 
                                                                LastName = activePatient.Last_Name__c, 
                                                                AccountId = ActiveAccount.Id, 
                                                                RecordTypeId = contactRTIndividual, 
                                                                phone = activePatient.Phone__c, 
                                                                Email = activePatient.E_mail__c);
                        insert objPatientContact;
                        
                        activePatient.Contact__c = objPatientContact.Id;
                        activePatient.Parent_Contact__c = activeContact.Id;
                    	}
                    activePatient.recordTypeID = patientValid;
                    try{
    					upsert activePatient;
    					activeCase.Patient_New__c = activePatient.ID;
    					}
    				catch(Exception pt){
    					system.debug('Error: ' + pt.getMessage() + ' Line: ' + pt.getLineNumber());
    					result = 'Error: ' + pt.getMessage() + ' Line: ' + pt.getLineNumber();
    					return result;
    					}	
    				}
    			else{
    				try{
    					delete activePatient;
    					}
    				catch(Exception e){
    					system.debug('Patient Already deleted or did not exist on an old case.');
    					}	
    				}
    			}		
    		if(activeAssessment != null){
    			activeAssessment.RecordTypeId = assessmentValid;	
    			try{
    				upsert activeAssessment;
    				activeCase.Assessment__c = activeAssessment.ID;
    				}
    			catch(Exception ex){
    				system.debug('Patient is deleted.');
    				try{
    					delete activeAssessment;
    					}
    				catch(Exception ex2){
    					system.debug('Assessment already deleted.');
    					}	
    				}	
    			}
    		upsert activeCase;	
    		result = 'Success';
    		return result;
    		}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		result = 'Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber();
    		return result;
    		}	
    	}
    
    @AuraEnabled
    public static string processCancelCase(Case activeCase, Contact activeContact, Account activeAccount, Patient_New__c activePatient, Assessment__c activeAssessment){
    	string result = '';
    	try{
    		system.debug('activeCase: ' + activeCase);
    		system.debug('activeContact: ' + activeContact);
    		system.debug('activeAccount: ' + activeAccount);
    		system.debug('activePatient: ' + activePatient);
    		system.debug('activeAssessment: ' + activeAssessment);
    		if(activeCase != null){
    			try{
    				try{
    					integer deductNum = integer.valueOf(activeCase.CaseNumber) - 1;
    					string caseName = string.valueOf(deductNum);
    					if(caseName.length() < 8){
    						for(integer i = caseName.length(); i < 8; i ++){
    							caseName = '0' + caseName;
    							}
    						}
    					system.debug('glitchName: ' + caseName);
    					Case glitchCase = [SELECT ID FROM Case WHERE RecordTypeID =: caseTemp AND CaseNumber =:caseName AND OwnerID =: userInfo.getUserId() LIMIT 1];
    					if(glitchCase != null){
    						delete glitchCase;
    						}
    					}
    				catch(Exception gli){
    					system.debug('No Glitch Case ' + gli.getMessage() + ' Line: ' + gli.getLineNumber());
    					}	
    				delete activeCase;
    				system.debug('activeCase: ' + activeCase);
    				if(activeCase != null){
    					delete activeCase;
    					}
    				}
    			catch(exception e){
    				system.debug('This item may have already been deleted: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    				}
    				
    			}
    		if(activeContact != null){
    			try{
    				delete activeContact;
    				}
    			catch(exception e){
    				system.debug('This item may have already been deleted: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    				}	
    			}
    		if(activeAccount != null){
    			try{
    				delete activeAccount;
    				}
    			catch(exception e){
    				system.debug('This item may have already been deleted: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    				}	
    			}
    		if(activePatient != null){
    			try{
    				delete activePatient;
    				}
    			catch(exception e){
    				system.debug('This item may have already been deleted: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    				}
    			}
    		if(activeAssessment != null){
    			try{
    				delete activeAssessment;
    				}
    			catch(exception e){
    				system.debug('This item may have already been deleted: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    				}	
    			}				
    		result = 'Success';
    		system.debug('result: ' + result);
    		return result;
    		}
    	catch(Exception e){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		result = 'Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber();
    		system.debug('result: ' + result);
    		return result;
    		}	
    	}
    
    @AuraEnabled
    public static String getUIThemeDescription(){
        String theme = UserInfo.getUiThemeDisplayed();
        system.debug('Theme: ' + theme);
        return theme;
    	}
    	
	@AuraEnabled(cacheable=true)
    public static list<ContentDocument> getAttachments(ID parentId){
    	system.debug('parentID: ' + parentId);
    	list<ContentDocumentLink> links = new list<ContentDocumentLink>();
    	list<ID> ids = new list<ID>();
    	links = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink WHERE LinkedEntityId =: parentId];
    	for(ContentDocumentLink cdl : links){
    		ids.add(cdl.ContentDocumentID);
    		}
    	list<ContentDocument> attachments = new list<ContentDocument>();
    	attachments = [SELECT Title, FileType, CreatedDate FROM ContentDocument WHERE ID IN: ids AND FileType != 'SNOTE'];
    	system.debug('attachments: ' + attachments);
    	return attachments;
    	}
        
	@AuraEnabled
	public static string cancelReturn(){
		string result = 'Success';
		return result;
		}
		
	@AuraEnabled(cacheable=true)
	public static list<Account> searchFacilities(string searchString){
		list<Account> results = new list<Account>();
		string query = 'SELECT ID, Name, ShippingStreet, ShippingCity, Facility_Number__c, ShippingState, ShippingPostalCode FROM Account WHERE RecordTypeId=: accountCenter AND (Name LIKE \'%'+ searchString + '%\' OR Facility_Number__c LIKE \'%'+ searchString + '%\' OR ShippingStreet LIKE \'%'+ searchString + '%\' OR ShippingCity LIKE \'%'+ searchString + '%\' OR ShippingState LIKE \'%'+ searchString + '%\' OR ShippingPostalCode LIKE \'%'+ searchString + '%\')';
		results = database.query(query);
		system.debug('result:' + results);
		return results;
		}
		
	/*
    Method Name: filterArticles
    */
    @AuraEnabled(cacheable=true)
    public static list<articleWrapper> filterKnowledgeArticles(String articleSearchString, String articleTypeFilter){
        list<articleWrapper> kArticles = new list<articleWrapper>();
        list<Contact_Center__kav> lstSKAV = new list<Contact_Center__kav>();
        system.debug('searchString: ' + articleSearchString);
        system.debug('articleTypeFilter: ' + articleTypeFilter);
        try{
        	String dataCategoryFilter = '';
        	if(articleTypeFilter != 'All' && (articleSearchString == null || articleSearchString == '')){
        		system.debug('Type Filter is not all and search string is blank.');
            	dataCategoryFilter = ' WITH DATA CATEGORY Contact_Center__c ABOVE_OR_BELOW '+ articleTypeFilter + '__c';
        		system.debug('dataCategoryFilter: ' + dataCategoryFilter);
        		String qryString = 'SELECT Id, Title, Summary, How_To_Resolve__c FROM '+
                	                'Contact_Center__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') '+ dataCategoryFilter;
                                
            	lstSKAV = Database.query(qryString);
            	for(Contact_Center__kav ka : lstSKAV){
            		kArticles.add(new articleWrapper(ka));
            		}
            	system.debug('kArticles' + kArticles);
            	return kArticles;
        		}
        	else{
        		if((articleSearchString == '' || articleSearchString == null) && articleTypeFilter == 'All'){
        			system.debug('Type Filter is All and search string is blank.');
        			lstSKAV = [SELECT Id, Title, Summary, How_To_Resolve__c FROM Contact_Center__kav WHERE PublishStatus = 'online' AND Language = 'en_US' Order By Title];
            		}
            	else if((articleSearchString != null && articleSearchString != '') && articleTypeFilter != 'All'){
            		system.debug('Type Filter not All and search string is not blank.');
        			dataCategoryFilter = ' WITH DATA CATEGORY Contact_Center__c ABOVE_OR_BELOW '+ articleTypeFilter + '__c';
        			String searchquery = 'FIND \'' + String.escapeSingleQuotes(articleSearchString) + '*\'IN ALL FIELDS RETURNING'+
                	          ' Contact_Center__kav(Id, Title, Summary ,How_To_Resolve__c where'+
                    	      ' PublishStatus =\'online\' and Language = \'en_US\') ' + dataCategoryFilter;
                    	      lstSKAV = search.query(searchquery)[0];
            		}
            	else if(articleSearchString != null && articleSearchString!= '' && articleTypeFilter == 'All'){
            		system.debug('Type Filter is All and search string is not blank.');
        			String searchquery = 'FIND \'' + String.escapeSingleQuotes(articleSearchString) + '*\'IN ALL FIELDS RETURNING'+
                	          ' Contact_Center__kav(Id, Title, Summary ,How_To_Resolve__c where'+
                    	      ' PublishStatus =\'online\' and Language = \'en_US\') ';
                    	      lstSKAV = search.query(searchquery)[0];
            		}	
            	for(Contact_Center__kav ka : lstSKAV){
            		kArticles.add(new articleWrapper(ka));
            		}
            		system.debug('kArticles' + kArticles);
            		return kArticles;	
        			}
        	}
        catch(Exception E){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		return null;
    		}
    	}
    
    /*
    Wrapper class for Knowledge Article used in infinite scroll
    */
    public class articleWrapper{
    	@AuraEnabled 
        public Contact_Center__kav record;
        public articleWrapper(Contact_Center__kav record){
        	if(record.How_to_Resolve__c != null){
            	record.How_to_Resolve__c = record.How_to_Resolve__c.stripHtmlTags().abbreviate(50);
            	}
            this.record = record;
            }
        }
    	
    @AuraEnabled(cacheable=true)
    public static list<ContentDocument> getLacunaFileList(){
        list<ContentDocument> lacunaFileList = new list<ContentDocument>();
        lacunaFileList = [SELECT ID, ParentID, FileType, Title FROM ContentDocument WHERE ParentID =: ParentLibraryID ORDER BY Title];
        return lacunaFileList;
    	}			        
	
	@AuraEnabled
	public static ID getCaseAndNavigate(ID recordID){
		system.debug('recordID: ' + recordID);
		ID caseID;
		LiveChatTranscript lct = [SELECT ID, CaseID FROM LiveChatTranscript WHERE ID =: recordID];
		caseID = lct.CaseID;
		return caseID;
		}
	/*
	@AuraEnabled
	public static pdfWrapper getFormDisplay(ID recordId){
		Case activeCase = getExistingCase(recordId);
		Contact activeContact = getExistingContact(activeCase);
		Account activeAccount = getExistingAccount(activeCase, activeContact);
		Patient_New__c activePatient = getServerPatient(activeCase);
		Assessment__c activeAssessment = getExistingAssessment(activePatient);
		pdfWrapper formDisplay = new pdfWrapper(activeCase, activeContact, activeAccount, activePatient, activeAssessment);
		return formDisplay;
		}
		
	public class pdfWrapper{
			public string preferredFacilityName	{get;set;}
			public string contactName	{get;set;}
			public string patientName	{get;set;}
			public string contactRelationship	{get;set;}
			public string contactPhone	{get;set;}
			public string contactEmail	{get;set;}
			public string patientAge	{get;set;}
			public string patientBirthDate	{get;set;}
			public string patientStreet	{get;set;}
			public string patientCity	{get;set;}
			public string patientState	{get;set;}
			public string patientZip	{get;set;}
			public string patientPhone	{get;set;}
			public string assessmentPayor	{get;set;}
			public string assessmentMemberID	{get;set;}
			public string assessmentSubscriberName	{get;set;}
			public string assessmentSecondaryPayor	{get;set;}
			public string assessmentSecondaryMemberID	{get;set;}
			public string assessmentSecondarySubscriberName	{get;set;}
			public string formCallEndTime {get;set;}
			public string formDXHX	{get;set;}
			public string formSituationConcerns	{get;set;}
			public string formLocationAndDate	{get;set;}
			public string preferredFacilityNameAddressPhone	{get;set;}
			public string formSSN	{get;set;}
			public string formPhysicianSpecialtyPhone	{get;set;}
			public string formUserName	{get;set;}
			public string formUserPhone	{get;set;}
			public string formUrgentNeed	{get;set;}
			public boolean formPhysicianConsent	{get;set;}
			public string formLastPhysicianDate	{get;set;}
			public string formKindredLink	{get;set;}
			public string formServicesRequested	{get;set;}
			public string formSpecifySN	{get;set;}
			public string formPhysicianF2F	{get;set;}
			public string formHomeboundStatus	{get;set;}
			public string formCurrentHospiceProvider	{get;set;}
			public string formPatientDestination	{get;set;}
			public string formPlannedTravelDates	{get;set;}
			public string facilityType	{get;set;}
			public boolean showLTACHForm	{get;set;}
			public boolean showHHForm	{get;set;}
			public boolean showHPForm	{get;set;}
			public boolean showPHCAForm	{get;set;}
			
			public pdfWrapper(Case activeCase, Contact activeContact, Account activeAccount, Patient_NEW__c activePatient, Assessment__c activeAssessment){
				this.facilityType = activeAccount.Type;
				this.preferredFacilityName = activeAssessment.Preferred_Facility__r.Name;
				this.contactName = activeContact.FirstName + ' ' + activeContact.LastName;
				this.patientName = activePatient.First_Name__c + ' ' + activePatient.Last_Name__c;
				this.contactPhone = activeContact.Phone;
				this.contactEmail = activeContact.Email;
				this.patientAge = string.valueOf(activePatient.Age__c);
				this.patientBirthDate = string.valueOf(activePatient.Date_of_Birth__c);
				this.patientStreet = activePatient.Street__c;
				this.patientCity = activePatient.City__c;
				this.patientState = activePatient.State__c;
				this.patientZip = activePatient.Postal_Code__c;
				this.patientPhone = activePatient.Phone__c;
				this.assessmentPayor = activeAssessment.Payor__c;
				this.assessmentMemberID = activeAssessment.Member_ID__c;
				this.assessmentSubscriberName = activeAssessment.Subscriber_Name__c;
				this.assessmentSecondaryPayor = activeAssessment.Secondary_Payor__c;
				this.assessmentSecondaryMemberID = activeAssessment.Secondary_Member_ID__c;
				this.assessmentSecondarySubscriberName = activeAssessment.Secondary_Subscriber_Name__c;
				this.preferredFacilityNameAddressPhone = activeAssessment.Preferred_Facility__r.Name + ': ' + activeAssessment.Preferred_Facility__r.ShippingStreet + ' ' + activeAssessment.Preferred_Facility__r.ShippingCity + ' ' + activeAssessment.Preferred_Facility__r.ShippingState + ' ' + activeAssessment.Preferred_Facility__r.ShippingPostalCode; 
				}
			
			public pdfWrapper(list<string> formFields, boolean showLTACHForm, boolean showHHForm, boolean showHPForm, boolean showPHCAForm){
				
				this.showLTACHForm = showLTACHForm;
				this.showHHForm = showHHForm;
				this.showHPForm = showHPForm;
				this.showHPForm = showPHCAForm;
				
				for(String s : formFields){
					if(s.contains('preferredFacilityName:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.preferredFacilityName = s.substringAfterLast(':');
						}
					if(s.contains('contactName:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.contactName = s.substringAfterLast(':');
						}	
					if(s.contains('patientName:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientName = s.substringAfterLast(':');
						}
					if(s.contains('contactRelationship:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.contactRelationship = s.substringAfterLast(':');
						}
					if(s.contains('contactPhone:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.contactPhone = s.substringAfterLast(':');
						}
					if(s.contains('contactEmail:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.contactEmail = s.substringAfterLast(':');
						}	
					if(s.contains('patientAge:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientAge = s.substringAfterLast(':');
						}
					if(s.contains('patientBirthDate:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientBirthDate = s.substringAfterLast(':');
						}
					if(s.contains('patientStreet:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientStreet = s.substringAfterLast(':');
						}
					if(s.contains('patientCity:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientCity = s.substringAfterLast(':');
						}
					if(s.contains('patientState:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientState = s.substringAfterLast(':');
						}
					if(s.contains('patientZip:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientZip = s.substringAfterLast(':');
						}
					if(s.contains('patientPhone:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.patientPhone = s.substringAfterLast(':');
						}
					if(s.contains('assessmentPayor:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.assessmentPayor = s.substringAfterLast(':');
						}
					if(s.contains('assessmentMemberID:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.assessmentMemberID = s.substringAfterLast(':');
						}	
					if(s.contains('assessmentSubscriberName:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.assessmentSubscriberName = s.substringAfterLast(':');
						}
					if(s.contains('assessmentSecondaryPayor:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.assessmentSecondaryPayor = s.substringAfterLast(':');
						}
					if(s.contains('assessmentSecondaryMemberID:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.assessmentSecondaryMemberID = s.substringAfterLast(':');
						}	
					if(s.contains('assessmentSecondarySubscriberName:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.assessmentSecondarySubscriberName = s.substringAfterLast(':');
						}
					if(s.contains('formCallEndTime:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formCallEndTime = s.substringAfterLast(':');
						}
					if(s.contains('formDXHX:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formDXHX = s.substringAfterLast(':');
						}	
					if(s.contains('formSituationConcerns:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formSituationConcerns = s.substringAfterLast(':');
						}
					if(s.contains('formLocationAndDate:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formLocationAndDate = s.substringAfterLast(':');
						}	
					if(s.contains('preferredFacilityNameAddressPhone:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.preferredFacilityNameAddressPhone = s.substringAfterLast(':');
						}
					if(s.contains('formSSN:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formSSN = s.substringAfterLast(':');
						}	
					if(s.contains('formPhysicianSpecialtyPhone:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formPhysicianSpecialtyPhone = s.substringAfterLast(':');
						}
					if(s.contains('formUserName:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formUserName = s.substringAfterLast(':');
						}
					if(s.contains('formUserPhone:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formUserPhone = s.substringAfterLast(':');
						}
					if(s.contains('formUrgentNeed:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formUrgentNeed = s.substringAfterLast(':');
						}
					if(s.contains('formPhysicianConsent:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formPhysicianConsent = boolean.valueOf(s.substringAfterLast(':'));
						}
					if(s.contains('formLastPhysicianDate:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formLastPhysicianDate = s.substringAfterLast(':');
						}
					if(s.contains('formKindredLink:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formKindredLink = s.substringAfterLast(':');
						}	
					if(s.contains('formServicesRequested:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formServicesRequested = s.substringAfterLast(':');
						}
					if(s.contains('formSpecifySN:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formSpecifySN = s.substringAfterLast(':');
						}
					if(s.contains('formPhysicianF2F:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formPhysicianF2F = s.substringAfterLast(':');
						}
					if(s.contains('formHomeboundStatus:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formHomeboundStatus = s.substringAfterLast(':');
						}
					if(s.contains('formCurrentHospiceProvider:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formCurrentHospiceProvider = s.substringAfterLast(':');
						}		
					if(s.contains('formPatientDestination:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formPatientDestination = s.substringAfterLast(':');
						}
					if(s.contains('formPlannedTravelDates:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
						this.formPlannedTravelDates = s.substringAfterLast(':');
						}
					}
				}
			}
		
		public void saveReferralPDF(){
			ID caseID = ApexPages.currentPage().getParameters().get('id');
			string formURLParam = ApexPages.currentPage().getParameters().get('formFields');
			list<string> formFields =  formURLParam.split(',');
			boolean showLTACHForm;
			boolean showHHForm;
			boolean showHPForm;
			boolean showPHCAForm;
			try{
				showLTACHForm = boolean.valueOf(ApexPages.currentPage().getParameters().get('showLTACHForm'));
				}
			catch(Exception ltachErr){
				system.debug('Argument Empty');
				}
			
			try{		
				showHHForm = boolean.valueOf(ApexPages.currentPage().getParameters().get('showHHForm'));
				}
			catch(Exception hhErr){
				system.debug('Argument Empty');
				}
				
			try{		
				showHPForm = boolean.valueOf(ApexPages.currentPage().getParameters().get('showHPForm'));
				}
			catch(Exception hpErr){
				system.debug('Argument Empty');
				}
			
			try{		
				showPHCAForm = boolean.valueOf(ApexPages.currentPage().getParameters().get('showPHCAForm'));
				}
			catch(Exception phcaErr){
				system.debug('Argument Empty');
				}
					
			pdfWrapper formWrap = new pdfWrapper(formFields, showLTACHForm, showHHForm, showHPForm, showPHCAForm);
			//PageReference pdfPage = Page.AA_ReferralFormPDF;﻿
			//ContentNote n = new ContentNote(Title = 'Note on: ' + string.valueof(system.today()), Content = pdfPage.getContent());
			//insert n;
			//ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityID = caseID, ContentDocumentId = n.Id, ShareType = 'V');
			//insert cdl;
			}
			*/
	
}