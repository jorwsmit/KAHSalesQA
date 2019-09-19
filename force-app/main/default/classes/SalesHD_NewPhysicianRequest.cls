public with sharing class SalesHD_NewPhysicianRequest {

	// public New_Physician_Request__c physician {get; set;}

	public Contact physician {get; set;}

	public SalesHD_NewPhysicianRequest(ApexPages.StandardController stdController) {
		physician = (Contact)stdController.getRecord();
	}

	public PageReference saveNew() {
		PageReference homepage = new PageReference('/apex/SalesHD_homepage');
		try{
			RecordType requestRecordType = [select Id from RecordType where Name='HD Physician Requests' and SObjectType='Contact' limit 1];

			List<Account> unassignHdAccount = [select Id from Account where name ='Unassigned HD Accounts - Admin Maintenance' limit 1];
			if(!unassignHdAccount.isEmpty()) physician.AccountId = unassignHdAccount[0].Id;

			physician.RecordTypeId=requestRecordType.Id;
			insert physician;
		}
		catch(DmlException ex){
			ApexPages.addMessages(ex);
		}
		homepage.setRedirect(true);
		return homepage;
	}

	public static void sendEmail(){
		string header = 'Meditech Assigned Mnemonic, 6-digit Dictation ID, Request Type, '+
		'Facility Name(s) and Meditech Mnemonic(s), Provider Type, Last Name, First Name, Middle Initial'+
		'State License #, DEA#, NPI Number, UPIN, Address, City, State, Zip Code, Phone Number,'+
		'Specialty, Group Name (If applicable), On Staff?, Admit Privileges?\n';
		string finalstr = header ;

		// List<New_Physician_Request__c> physianRequests = [select First_Name__c, Last_Name__c,
		// Specialty__c, Mailing_Street__c, Mailing_City__c, Mailing_State__c,
		// Mailing_Postal_Code__c, NPI__c, Phone__c, Provider_Type__c, Request_Type__c,
 		// Physician_Group__c, Facility_Names__c
		// from New_Physician_Request__c where Requested__c = false];

		List<Contact> physianRequests = [select FirstName, LastName,
		HD_Specialties__c, MailingStreet, MailingCity, MailingState,
		MailingPostalCode, Requested_Physician_NPI__c, Phone from Contact
		where HD_Physician_Requested__c = false and RecordType.Name='HD Physician Requests'];

		for(Contact pr: physianRequests){
			String recordString = ', , Addition, ,'+
			'Referring ,'+pr.LastName+','+pr.FirstName+', , , '+
			pr.Requested_Physician_NPI__c+', ,'+pr.MailingStreet+','+pr.MailingCity+','+
			pr.MailingState+','+pr.MailingPostalCode+','+pr.Phone+','+
			pr.HD_Specialties__c+', , , \n';
			finalstr = finalstr + recordString.replaceAll('null', '');
			pr.HD_Physician_Requested__c = true;
		}
		update physianRequests;
		Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
		blob csvBlob = Blob.valueOf(finalstr);
		string csvname= 'PhysiciansMaintenanceForm_'+System.now().date().format().replaceAll('/','-')+'.csv';
		csvAttc.setFileName(csvname);
		csvAttc.setBody(csvBlob);
		Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();

		List<String> toAddresses = new List<String>();
		toAddresses.add(SalesHD_Redesign__c.getValues('Meditech Team Email').Meditech_Request_Email__c);
		String subject ='New Physician Requests from Salesforce';
		email.setSubject(subject);
		email.setToAddresses( toAddresses );
		email.setReplyTo(SalesHD_Redesign__c.getValues('HD Admin ReplyTo Physician Requests').Meditech_Request_Email__c);
		email.setPlainTextBody('Number of new physician requests: '+ physianRequests.size() + '\n See attachment for request form.');
		email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
		if(physianRequests.size()>0) Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	}

}