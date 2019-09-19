global without sharing class SalesHD_Account {

	public Account acct {get; set;}

	private static Id currentUser = UserInfo.getUserId();

	private static List<String> csuiteTitles = new List<String>{'CCO', 'CEO', 'CFO', 'COO'};

	public class updateUnit{
		public Id unitId;
		public Boolean isActive;
	}

	public class unitList{
		public String name;
		public Id unitId;
		public String contactCount = 'No Contacts';
		public String census = '';
		public String beds = '';
		public String censusDate = '';
		public String nickname = '';
		public Boolean isActive;
	}


	public SalesHD_Account(ApexPages.StandardController stdController) {
		acct = (Account)stdController.getRecord();
	}

	@RemoteAction global static String getCsuite(Id acctId){
		List<Id> administrativeContactIds = new List<Id>();
		for(Account_unit_contact__c auc : [select Contact__c from Account_unit_contact__c
		where Account_unit__r.Account__c=:acctId and Account_Unit__r.Unit__r.Name='Administrative']){
			administrativeContactIds.add(auc.Contact__c);
		}

		return JSON.serializePretty([select Name, Title__c from Contact where Title__c in :csuiteTitles and
		(Id in :administrativeContactIds)]);
	}

	@RemoteAction global static String getDirectors(Id acctId){
		List<Id> administrativeContactIds = new List<Id>();
		for(Account_unit_contact__c auc : [select Contact__c from Account_unit_contact__c
		where Account_unit__r.Account__c=:acctId and Account_Unit__r.Unit__r.Name='Administrative']){
			administrativeContactIds.add(auc.Contact__c);
		}

		return JSON.serializePretty([select Name, Title__c from Contact where Title__c like '%Director%' and
		(Id in :administrativeContactIds)]);
	}

	@RemoteAction global static String getContacts(Id acctId){
		List<Id> administrativeContactIds = new List<Id>();
		for(Account_unit_contact__c auc : [select Contact__c from Account_unit_contact__c
		where Account_unit__r.Account__c=:acctId and Account_Unit__r.Unit__r.Name='Administrative']){
			administrativeContactIds.add(auc.Contact__c);
		}

		return JSON.serializePretty([select Name, Title__c from Contact where Title__c not in :csuiteTitles and
		(not Title__c like '%Director%') and (Id in :administrativeContactIds)]);
	}

	@RemoteAction global static String getFavoritedContacts(){
		return JSON.serializePretty([select Contact__r.Name from Contact_Team__c where Contact__r.Status__c='Active' and User__c =: currentUser]);
	}

	@RemoteAction global static void saveContact(Id acctId, Id contactId){
		List<Account_Unit__c> au = [select Id from Account_Unit__c where Account__c=:acctId and Unit__r.Name='Administrative' limit 1];
		List<Account_Unit_Contact__c> auc = [select id from Account_Unit_Contact__c where Account_Unit__c in :au and Contact__c=:contactId];
		if(auc.isEmpty()) insert new Account_Unit_Contact__c(Account_Unit__c=au[0].Id, Contact__c=contactId);
	}



	@RemoteAction global static String getUnits(Id acctId){
		List<unitList> units = new List<unitList>();
		Map<Id, Integer> contactCount = new Map<Id, Integer>();

		for(AggregateResult ar : [select Account_unit__c, count(Contact__c) from Account_unit_contact__c
		where Account_unit__r.Account__c=:acctId group by Account_unit__c]){
			contactCount.put(String.valueOf(ar.get('Account_unit__c')), Integer.valueOf(ar.get('expr0')));
		}
		for(Account_Unit__c au : [select Unit__r.Name, Id, Active__c, SalesHD_Unit_Census_Date__c,
		SalesHD_Unit_Census__c, SalesHD_Unit_Beds__c, SalesHD_Unit_Nickname__c from Account_Unit__c
		where Account__c = :acctId and Unit__r.Name!='Administrative' and Unit__r.Active__c=true]){
			unitList temp = new unitList();
			temp.name = au.Unit__r.Name;
			if(au.SalesHD_Unit_Nickname__c!=null) temp.nickname = au.SalesHD_Unit_Nickname__c;
			temp.unitId = au.Id;
			temp.isActive = au.Active__c;
			if(au.SalesHD_Unit_Census_Date__c!=null) temp.censusDate = '<b>Census Date</b></br>'+au.SalesHD_Unit_Census_Date__c.format();
			if(au.SalesHD_Unit_Census__c!=null) temp.census = '<b>Census</b></br>'+au.SalesHD_Unit_Census__c;
			if(au.SalesHD_Unit_Census__c!=null) temp.beds = '<b>Total Beds</b></br>'+au.SalesHD_Unit_Beds__c;
			if(contactCount.containsKey(au.Id) && contactCount.get(au.Id)>1){
				temp.contactCount = String.valueOf(contactCount.get(au.Id)) + ' contacts';
			} else if(contactCount.containsKey(au.Id) && contactCount.get(au.Id)==1){
				temp.contactCount = String.valueOf(contactCount.get(au.Id)) + ' contact';
			}
			units.add(temp);
		}
		return JSON.serializePretty(units);

	}

	@RemoteAction global static Boolean isFavorited(Id acctId){
		List<AccountTeamMember> atm = [select Id from AccountTeamMember where
		AccountId =: acctId and Account.Status__c='Active' and UserId =: currentUser];
		if(atm.size()>=1){
			return true;
		}
		return false;
	}

	@RemoteAction global static void saveFollowup(Id acctId, String dateString){
		Datetime followupDate = Datetime.newInstance(Date.parse(dateString), Time.newInstance(12, 0, 0, 0));
		insert new event(whatId=acctId, ActivityDateTime=followupDate, durationInMinutes=15, type='Follow-up');
	}

	@RemoteAction global static String getNotes(Id acctId){
		List<Id> noteDocumentIds = new List<Id>();
		for(ContentDocumentLink cdl : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId=:acctId]){
			noteDocumentIds.add(cdl.ContentDocumentId);
		}
		return JSON.serializePretty([select Id, Title, TextPreview from ContentNote where Id =: noteDocumentIds]);
	}

	@RemoteAction global static void saveNote(Id acctId, String noteInput, String titleInput){
		ContentNote n = new ContentNote(Title=titleInput, Content=blob.valueOf(noteInput));
		insert n;
		ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId=acctId, ContentDocumentId=n.Id, ShareType='V');
		insert cdl;
	}

	@RemoteAction global static void deleteNote(Id noteId){
		try{
			ContentNote n = [select Id from ContentNote where Id=:noteId limit 1];
			delete n;
		}catch(DmlException ex){
			ApexPages.addMessages(ex);
		}
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

	@RemoteAction global static void saveUnits(Id acctId, String units){
		List<updateUnit> tempUnits = (List<updateUnit>) JSON.deserialize(units, List<updateUnit>.class);
		Map<Id, Boolean> unitMap = new Map<Id, Boolean>();
		for(updateUnit u : tempUnits){
			unitMap.put(u.unitId, u.isActive);
		}
		List<Account_Unit__c> updateUnits = [select Id, Active__c from Account_Unit__c where Id in :unitMap.keySet()];
		for(Account_Unit__c au : updateUnits){
			au.Active__c = unitMap.get(au.Id);
		}
		update updateUnits;
	}

	@RemoteAction global static void favoriteUnfavoriteAccount(Id acctId){
		List<AccountTeamMember> atm = [select Id from AccountTeamMember where AccountId =: acctId and Account.Status__c='Active' and UserId =: currentUser];

		if(atm.size()>=1){
			delete atm;
		} else{
			insert new AccountTeamMember(AccountId=acctId, UserId=currentUser);
		}
	}

	@RemoteAction global static String getEncounters(Id acctId){

		// List<Event> pastEvents = new List<Event>();
		List<EventRelation> pastEvents = new List<EventRelation>();
		List<EventRelation> futureEvents = new List<EventRelation>();
		// List<Event> futureEvents = new List<Event>();

		// pastEvents = [select id, subject, startDateTime, SalesHD_Complete__c, description,
		// who.name, SalesHD_Call_Objective__c, what.Name, SalesHD_Account_Unit__r.Unit__r.Name,
		// SalesHD_Open_Ended_Questions__c, createdby.Name, createdby.SmallPhotoUrl, ActivityDate from event
		// where whatId=:acctId and activityDateTime<TODAY order by activityDateTime desc limit 100 ];

		pastEvents = [select eventId, event.subject, event.startDateTime, event.SalesHD_Complete__c, event.description,
		relation.name, event.SalesHD_Call_Objective__c, event.what.Name, event.SalesHD_Account_Unit__r.Unit__r.Name,
		event.SalesHD_Open_Ended_Questions__c, event.createdby.Name, event.createdby.SmallPhotoUrl, event.ActivityDate from eventRelation
		where event.whatId=:acctId and event.activityDateTime<TODAY and isWhat=false order by event.activityDateTime desc limit 100 ];

		futureEvents = [select eventId, event.subject, event.startDateTime, event.SalesHD_Complete__c, event.description,
		relation.name, event.SalesHD_Call_Objective__c, event.what.Name, event.SalesHD_Account_Unit__r.Unit__r.Name,
		event.SalesHD_Open_Ended_Questions__c, event.createdby.Name, event.createdby.SmallPhotoUrl, event.ActivityDate from eventRelation
		where event.whatId=:acctId and event.activityDateTime>=TODAY and isWhat=false order by event.activityDateTime desc limit 100 ];

		// futureEvents = [select id, subject, startDateTime, SalesHD_Complete__c, description,
		// who.name, SalesHD_Call_Objective__c, SalesHD_Open_Ended_Questions__c, what.Name,
		// SalesHD_Account_Unit__r.Unit__r.Name, createdby.Name, createdby.SmallPhotoUrl, ActivityDate from event
		// where whatId=:acctId and activityDateTime>=TODAY order by activityDateTime desc limit 100];

		return '{"pastEvents" : '+JSON.serialize(pastEvents)+', "futureEvents" : '+JSON.serialize(futureEvents)+'}';
	}

	// @RemoteAction global static void updateAccount(Id acctId, String dataJson){
	// 	Account updateAccount = (Account)JSON.deserializeStrict(dataJson, Account.class);
	// }

	public PageReference save() {
		update acct;
		PageReference accountPage = new PageReference('/apex/SalesHD_Account?id='+acct.Id);
		accountPage.setRedirect(true);
		return accountPage;
	}

}