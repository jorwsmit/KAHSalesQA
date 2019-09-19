global class Sales_KAHSendGoalEmailBatch implements Database.Batchable<sObject> {

	global String query = 'select Id, SA_Agreement_By__r.Name, SA_Agreement_By__r.Email, Manager_Agreement_By__r.Name,'+
	'SA_Agreed__c, Manager_Agreed__c, Manager_Agreement_By__r.Email, Date__c '+
	'from target_agreement__c where SA_Agreed__c=true and Manager_Agreed__c=true';

	private static String salesIncentivesEmail = 'SalesIncentives@gentiva.com';

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		for(sObject s : scope){
	  	emailPdf((Target_Agreement__c)s);
		}
	}

	global void finish(Database.BatchableContext BC) {

	}
	//***pre***
	//takes in completed GA forms
	//***post***
	//sends an email to the SA and Manager
	private static void emailPdf(Target_Agreement__c ta){
		PageReference pageRef = new PageReference('/apex/Sales_TargetAgreementEmail');
		pageRef.getParameters().put('id', String.valueOf(ta.Id));
		Blob pdf = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pageRef.getContent();

		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setFileName(ta.SA_Agreement_By__r.Name+' Goal Acknowledgement Form - '+dateFile(ta.Date__c)+'.pdf');
		efa.setBody(pdf);

		List<String> toAddresses = new List<String>();
		toAddresses.add(ta.SA_Agreement_By__r.Email);
		toAddresses.add(ta.Manager_Agreement_By__r.Email);
		List<String> ccAddresses = new List<String>();
		ccAddresses.add(salesIncentivesEmail);
		email.setReplyTo(salesIncentivesEmail);
		email.setSenderDisplayName('Sales Incentives Team');
		email.setSubject('Target Acknowledgement Has Been Completed');
		email.setToAddresses(toAddresses);
		email.setCcAddresses(ccAddresses);
		email.setPlainTextBody('Hi,\n\nAttached to this email you will find a pdf containing the targets that were acknowledged by '+
		ta.SA_Agreement_By__r.Name+', and their manager, '+ta.Manager_Agreement_By__r.Name+'.\n\nThanks,\nSales Incentives Team');

		email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

		Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	}

	private static String dateFile(Date d){
		return d.format().replace('/','-');
	}
}