global with sharing class SalesHD_Contact {


	public Contact cont {get; set;}

	// private Contact cont = [select Id, MailingCity, MailingStreet, MailingState, MailingPostalcode, MailingCountry
	// from Contact where Id = :ApexPages.currentPage().getParameters().get('id')];

	private static Id currentUser = UserInfo.getUserId();

	public String contactAddress {get; set;}


	public SalesHD_Contact(ApexPages.StandardController stdController) {
		cont = (Contact)stdController.getRecord();
		if(ApexPages.currentPage().getParameters().get('accountId')!=''){
			List<Account> accountAddress = [select ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode from Account where Id = :ApexPages.currentPage().getParameters().get('accountId')];
			if(!accountAddress.isEmpty()){
				cont.MailingStreet = accountAddress[0].ShippingStreet;
				cont.MailingCity = accountAddress[0].ShippingCity;
				cont.MailingState = accountAddress[0].ShippingState;
				cont.MailingPostalCode = accountAddress[0].ShippingPostalCode;
			}
		}
	}

	@RemoteAction global static String getUnits(Id contId){
		return JSON.serializePretty([select Account_Unit__r.Unit__r.Name, Account_Unit__r.Account__r.Name, Id from Account_Unit_Contact__c
		where Contact__c = :contId and Account_Unit__r.Unit__r.Name!='Administrative' and Account_Unit__r.Active__c=true]);
	}

	@RemoteAction global static void saveFollowup(Id contId, String dateString){
		Datetime followupDate = Datetime.newInstance(Date.parse(dateString), Time.newInstance(12, 0, 0, 0));
		insert new event(whoId=contId, ActivityDateTime=followupDate, durationInMinutes=15, type='Follow-up');
	}

	@RemoteAction global static void removeUnit(Id unitId, Id contId){
		List<Account_Unit_Contact__c> deleteUnit = new List<Account_Unit_Contact__c>();
		for(Account_Unit_Contact__c auc : [select Id from Account_Unit_Contact__c where Contact__c = :contId and
		Account_Unit__r.Unit__r.Name!='Administrative' and Account_Unit__r.Active__c=true and Id=:unitId]){
			deleteUnit.add(auc);
		}
		delete deleteUnit;
	}

	@RemoteAction global static void removeAccount(Id accountId, Id contId){
		List<Account_Unit_Contact__c> deleteAccount = new List<Account_Unit_Contact__c>();
		for(Account_Unit_Contact__c auc : [select Id from Account_Unit_Contact__c where Contact__c = :contId and
		Account_Unit__r.Unit__r.Name='Administrative' and Account_Unit__r.Active__c=true and Id=:accountId]){
			deleteAccount.add(auc);
		}
		delete deleteAccount;
	}

	@RemoteAction global static String getAccounts(Id contId){
		return JSON.serializePretty([select Account_Unit__r.Account__r.Name, Id from Account_Unit_Contact__c
		where Contact__c = :contId and Account_Unit__r.Unit__r.Name='Administrative' and Account_Unit__r.Active__c=true]);
	}

	@RemoteAction global static Boolean isFavorited(Id contId){
		List<Contact_Team__c> ct = [select Id from Contact_Team__c where
		Contact__c =: contId and Contact__r.Status__c='Active' and User__c =: currentUser];
		if(ct.size()>=1){
			return true;
		}
		return false;
	}

	@RemoteAction global static void favoriteUnfavoriteContact(Id contId){
		List<Contact_Team__c> ct = [select Id from Contact_Team__c where
		Contact__c =: contId and Contact__r.Status__c='Active' and User__c =: currentUser];

		if(ct.size()>=1){
			delete ct;
		} else{
			insert new Contact_Team__c(Contact__c=contId, User__c=currentUser);
		}
	}

	@RemoteAction global static String getNotes(Id contId){
		List<Id> noteDocumentIds = new List<Id>();
		for(ContentDocumentLink cdl : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId=:contId]){
			noteDocumentIds.add(cdl.ContentDocumentId);
		}
		return JSON.serializePretty([select Id, Title, TextPreview from ContentNote where Id =: noteDocumentIds]);
	}

	@RemoteAction global static void updateNote(Id noteId, String noteInput, String titleInput){
		try{
			ContentNote n = [select Id, Title, Content from ContentNote where Id=:noteId limit 1];
			n.Title=titleInput;
			n.Content=blob.valueOf(noteInput);
			update n;
		}catch(DmlException ex){
			ApexPages.addMessages(ex);
		}
	}

	@RemoteAction global static void deleteNote(Id noteId){
		try{
			ContentNote n = [select Id from ContentNote where Id=:noteId limit 1];
			delete n;
		}catch(DmlException ex){
			ApexPages.addMessages(ex);
		}
	}

	@RemoteAction global static void saveNote(Id contId, String noteInput, String titleInput){
		ContentNote n = new ContentNote(Title=titleInput, Content=blob.valueOf(noteInput));
		insert n;
		ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId=contId, ContentDocumentId=n.Id, ShareType='V');
		insert cdl;
	}

	@RemoteAction global static String getEncounters(Id contId){

		List<EventRelation> pastEvents = new List<EventRelation>();
		List<EventRelation> futureEvents = new List<EventRelation>();

		pastEvents = [select eventId, event.subject, event.startDateTime, event.SalesHD_Complete__c, event.description,
		relation.name, event.SalesHD_Call_Objective__c, event.what.Name, event.SalesHD_Account_Unit__r.Unit__r.Name,
		event.SalesHD_Open_Ended_Questions__c, event.createdby.Name, event.createdby.SmallPhotoUrl, event.ActivityDate from eventRelation
		where relationId=:contId and event.activityDateTime<TODAY and isWhat=false order by event.activityDateTime desc limit 100 ];

		futureEvents = [select eventId, event.subject, event.startDateTime, event.SalesHD_Complete__c, event.description,
		relation.name, event.SalesHD_Call_Objective__c, event.what.Name, event.SalesHD_Account_Unit__r.Unit__r.Name,
		event.SalesHD_Open_Ended_Questions__c, event.createdby.Name, event.createdby.SmallPhotoUrl, event.ActivityDate from eventRelation
		where relationId=:contId and event.activityDateTime>=TODAY and isWhat=false order by event.activityDateTime desc limit 100 ];

		return '{"pastEvents" : '+JSON.serialize(pastEvents)+', "futureEvents" : '+JSON.serialize(futureEvents)+'}';
	}

	public PageReference save() {
		PageReference contactPage;
		try{
			update cont;
			contactPage = new PageReference('/apex/SalesHD_Contact?id='+cont.Id);
		}
		catch(DmlException ex){
			ApexPages.addMessages(ex);
		}
		if(contactPage!=null) contactPage.setRedirect(true);
		return contactPage;
	}

	public PageReference saveNew() {
		PageReference contactPage;
		try{
			List<RecordType> hdContactsRecordType = [select Id from RecordType where sobjecttype='Contact' and Name='HD Contacts' limit 1];
			List<Account> unassignHdAccount = [select Id from Account where name ='Unassigned HD Accounts - Admin Maintenance' limit 1];
			if(!hdContactsRecordType.isEmpty()) cont.RecordTypeId = hdContactsRecordType[0].Id;
			if(!unassignHdAccount.isEmpty()) cont.AccountId = unassignHdAccount[0].Id;
			insert cont;
			insert new Contact_Team__c(Contact__c=cont.Id, User__c=currentUser);
			contactPage = new PageReference('/apex/SalesHD_Contact?id='+cont.Id);
			if(ApexPages.currentPage().getParameters().get('accountId')!=''){
				List<Account_Unit__c> au = [select Id from Account_Unit__c where Account__c=:ApexPages.currentPage().getParameters().get('accountId') and Unit__r.Name='Administrative' limit 1];
				List<Account_Unit_Contact__c> auc = [select id from Account_Unit_Contact__c where Account_Unit__c in :au and Contact__c=:cont.Id];
				if(auc.isEmpty() && au.size()>0) insert new Account_Unit_Contact__c(Account_Unit__c=au[0].Id, Contact__c=cont.Id);
			}
		}
		catch(DmlException ex){
			ApexPages.addMessages(ex);
		}
		if(contactPage!=null) contactPage.setRedirect(true);
		return contactPage;
	}

	@RemoteAction global static String getFavoritedAccounts() {
		return JSON.serializePretty([select AccountId, Account.Name, Account.ShippingStreet, Account.ShippingCity,
		Account.ShippingState, Account.ShippingPostalCode, Account.ShippingAddress__c from AccountTeamMember where UserId =: currentUser and Account.RecordType.Name='HD Accounts']);
	}

}