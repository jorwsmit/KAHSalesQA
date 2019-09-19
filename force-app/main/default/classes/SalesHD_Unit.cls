global without sharing class SalesHD_Unit {

public Account_Unit__c thisUnit {get; set;}

public Integer currentCensus {get; set;}
public Integer currentBeds {get; set;}

public Integer census {get; set;}
public Integer beds {get; set;}
public Date censusDate {get; set;}
public String currentCensusDateString {get; set;}
public Boolean censusModal {get; set;}

private static Id currentUser = UserInfo.getUserId();

private static Map<String, String> unitContactsMap = new Map<String, String> {
	'Nurse Manager'=>'Nursing',
	'Registered Nurse'=>'Nursing',
	'Educator'=>'Nursing',
	'Navigator'=>'Nursing',
	'Nurse'=>'Nursing',
	'Nurse Supervisor'=>'Nursing',
	'Wound Care Coordinator'=>'Nursing',
	'Case Manager'=>'Nursing',
	'Case Management Manager'=>'Nursing',
	'Social Worker'=>'Nursing',
	'Social worker'=>'Nursing',
	'Social Worker Manager'=>'Nursing',
	'Respiratory Therapist'=>'Nursing',
	'Case Manager'=>'Nursing',

	'Respiratory Therapist Director'=>'Director',
	'Unit Medical Director'=>'Director',

	'Nurse Practitioner'=>'Provider',
	'Physician Assistant'=>'Provider',
	'Director of Critical Care (MD)'=>'Provider',
	'Hospitalist'=>'Provider',
	'Intensivist'=>'Provider',
	'Palliative Care Physician'=>'Provider',
	'Other MDs (IM, Pulm, ID, etc.)'=>'Provider',
	'Fellow'=>'Provider',
	'Physician'=>'Provider'
};

public SalesHD_Unit(ApexPages.StandardController stdController) {
	thisUnit = (Account_Unit__c)stdController.getRecord();
	for(Unit_Census__c uc : [select Census__c,Beds__c,Census_Date__c from Unit_Census__c where
	                         Census_Date__c<=Today and Account_Unit__c=:thisUnit.Id order by Census_Date__c desc limit 1]) {
		currentCensus = Integer.valueOf(uc.Census__c);
		census = Integer.valueOf(uc.Census__c);
		currentBeds = Integer.valueOf(uc.Beds__c);
		beds = Integer.valueOf(uc.Beds__c);
		currentCensusDateString = uc.Census_Date__c.format();
		
	}
	censusDate = System.now().date();
}

public PageReference accountRedirect(){
	PageReference accountPage = new PageReference('/apex/SalesHD_Account?id='+thisUnit.Account__c);
	accountPage.setRedirect(true);
	if(thisUnit.Unit__r.Name == 'Administrative') return accountPage;
	else return null;
}

public PageReference saveCensus() {
	try{
		// update thisUnit;
		if(censusDate<=System.now().date()) {
			List<Account_Unit__c> aus = [select SalesHD_Unit_Census_Date__c, SalesHD_Unit_Census__c, SalesHD_Unit_Beds__c
			                             from Account_Unit__c where Id=:thisUnit.Id];
			List<Account_Unit__c> updateAU = new List<Account_Unit__c>();
			for(Account_Unit__c au : aus) {
				if(au.SalesHD_Unit_Census_Date__c==null || au.SalesHD_Unit_Census_Date__c<=censusDate) {
					au.SalesHD_Unit_Census_Date__c = censusDate;
					au.SalesHD_Unit_Census__c = census;
					au.SalesHD_Unit_Beds__c = beds;
					updateAU.add(au);
				}
			}

			if(!updateAU.isEmpty()) update updateAU;

			List<Unit_Census__c> ucs = [select id,Census__c,Beds__c,Census_Date__c from Unit_Census__c where Census_Date__c=:censusDate and Account_Unit__c=:thisUnit.Id];
			if(ucs.isEmpty()) {
				insert new Unit_Census__c(Census__c=census, Beds__c=beds, Census_Date__c=censusDate, Account_Unit__c=thisUnit.Id);
			} else{
				for(Unit_Census__c uc : ucs) {
					uc.Census__c = census; uc.Beds__c=beds;
				}
				update ucs;
			}
			currentCensus = Integer.valueOf(census);
			currentBeds = Integer.valueOf(beds);
			currentCensusDateString = censusDate.format();
			censusModal = true;
		} else{
			censusModal = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Census cannot be set for future dates.'));
		}

	}
	catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
	return null;
}

public PageReference saveNickname() {
	try{
		update thisUnit;
	}
	catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
	return null;
}

@RemoteAction global static String getNotes(Id unitId){
	List<Id> noteDocumentIds = new List<Id>();
	for(ContentDocumentLink cdl : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId=:unitId]) {
		noteDocumentIds.add(cdl.ContentDocumentId);
	}
	return JSON.serializePretty([select Id, Title, TextPreview from ContentNote where Id =: noteDocumentIds]);
}

@RemoteAction global static void deleteNote(Id noteId){
	try{
		ContentNote n = [select Id from ContentNote where Id=:noteId limit 1];
		delete n;
	}catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
}

@RemoteAction global static void updateNote(Id noteId, String noteInput, String titleInput){
	try{
		ContentNote n = [select Id, Title, Content from ContentNote where Id=:noteId limit 1];
		n.Title=titleInput;
		n.Content=blob.valueOf(noteInput);
		update n;
	}catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
}

@RemoteAction global static void saveNote(Id unitId, String noteInput, String titleInput){
	ContentNote n = new ContentNote(Title=titleInput, Content=blob.valueOf(noteInput));
	insert n;
	ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId=unitId, ContentDocumentId=n.Id, ShareType='V');
	insert cdl;
}

@RemoteAction global static String getFavoriedContacts(){
	return JSON.serializePretty([select Contact__r.Name from Contact_Team__c where Contact__r.Status__c='Active' and User__c =: currentUser]);
}

@RemoteAction global static List<Contact> saveContact(Id unitId, Id contactId, String title){
	List<Contact> updateContacts = new List<Contact>();
	for(Contact c : [select Title__c, MailingPostalCode from Contact where Id=:contactId]) {
		c.Title__c = title;
		if(c.MailingPostalCode != null) {
			if(c.MailingPostalCode.length()==9) {
				c.MailingPostalCode = c.MailingPostalCode.left(5) + '-' + c.MailingPostalCode.right(4);
			} else if(c.MailingPostalCode.length()!=10 && c.MailingPostalCode.length()!=5) {
				c.MailingPostalCode = null;
			}
		}
		updateContacts.add(c);
	}
	update updateContacts;
	List<Account_Unit_Contact__c> auc = [select id from Account_Unit_Contact__c where Account_Unit__c=:unitId and Contact__c=:contactId];
	if(auc.isEmpty()) insert new Account_Unit_Contact__c(Account_Unit__c=unitId, Contact__c=contactId);
	return updateContacts;
}

@RemoteAction global static String getEncounters(Id unitId){

	List<EventRelation> pastEvents = new List<EventRelation>();
	List<EventRelation> futureEvents = new List<EventRelation>();

	pastEvents = [select eventId, event.subject, event.startDateTime, event.SalesHD_Complete__c, event.description,
	              relation.name, event.SalesHD_Call_Objective__c, event.what.Name, event.SalesHD_Account_Unit__r.Unit__r.Name,
	              event.SalesHD_Open_Ended_Questions__c, event.createdby.Name, event.createdby.SmallPhotoUrl, event.ActivityDate from eventRelation
	              where event.SalesHD_Account_Unit__c=:unitId and event.activityDateTime<TODAY and isWhat=false order by event.activityDateTime desc limit 100 ];

	futureEvents = [select eventId, event.subject, event.startDateTime, event.SalesHD_Complete__c, event.description,
	                relation.name, event.SalesHD_Call_Objective__c, event.what.Name, event.SalesHD_Account_Unit__r.Unit__r.Name,
	                event.SalesHD_Open_Ended_Questions__c, event.createdby.Name, event.createdby.SmallPhotoUrl, event.ActivityDate from eventRelation
	                where event.SalesHD_Account_Unit__c=:unitId and event.activityDateTime>=TODAY and isWhat=false order by event.activityDateTime desc limit 100 ];

	return '{"pastEvents" : '+JSON.serialize(pastEvents)+', "futureEvents" : '+JSON.serialize(futureEvents)+'}';
}

@RemoteAction global static String getCensus(Id unitId){
	Integer census = null;
	Integer beds = null;
	String censusDate = null;
	for(Unit_Census__c uc : [select Census__c,Beds__c,Census_Date__c from Unit_Census__c where
	                         Census_Date__c<=Today and Account_Unit__c=:unitId order by Census_Date__c desc limit 1]) {
		census = Integer.valueOf(uc.Census__c);
		beds = Integer.valueOf(uc.Beds__c);
		censusDate = uc.Census_Date__c.format();
	}
	return '{"census":'+census+' , "beds":'+beds+', "censusDate":"'+censusDate+'"}';
}

@RemoteAction global static String getContacts(Id unitId){
	Map<String, List<Account_Unit_Contact__c> > contacts = new Map<String, List<Account_Unit_Contact__c> >();

	for(Account_Unit_Contact__c auc : [select Contact__r.Title__c, Contact__r.Name, Contact__r.Id, Contact__r.HD_Specialties__c
	                                   from Account_Unit_Contact__c where Account_Unit__c=:unitId order by Contact__r.Title__c]) {
		if(unitContactsMap.containsKey(auc.Contact__r.Title__c) && contacts.containsKey(unitContactsMap.get(auc.Contact__r.Title__c))) {
			contacts.get(unitContactsMap.get(auc.Contact__r.Title__c)).add(auc);
		} else{
			if(unitContactsMap.containsKey(auc.Contact__r.Title__c)) contacts.put(unitContactsMap.get(auc.Contact__r.Title__c), new List<Account_Unit_Contact__c> {auc});
		}
	}

	return JSON.serializePretty(contacts);

}

}