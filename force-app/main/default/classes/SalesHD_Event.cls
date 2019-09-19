global with sharing class SalesHD_Event {


public Event thisEvent {get; set;}
public Date startDate {get; set;}
public String startDateFormated {get; set;}
public Time startTime {get; set;}
public Integer duration {get; set;}
public Date endDate {get; set;}
public String endDateFormated {get; set;}
public Time endTime {get; set;}
public Id contactId {get; set;}

public String additionalContactIdString {get; set;}
public String removeAdditionalContactIdString {get; set;}
private Map<Id, String> additionalContacts {get; set;}
public String additionalContactsString {get; set;}

public Id accountId {get; set;}
public Id unitId {get; set;}



public String selectedRecurrenceType {get; set;}
public Boolean displayRecurrence {get; set;}

public String contactName {get; set;}
public String accountName {get; set;}
public String unitName {get; set;}

public String unitList {get; set;}

public String encounters {get; set;}




private static Id currentUser = UserInfo.getUserId();

public SalesHD_Event(ApexPages.StandardController stdController) {
	startDate = Date.valueOf(System.now());
	startTime = Time.newInstance(System.now().hour(), System.now().minute()-(math.mod(System.now().minute(), 15)),0,0);
	duration = 15;
	Datetime endDatetime = Datetime.newInstance(startDate, startTime);
	endDatetime = endDatetime.addMinutes(15);
	endTime = endDatetime.time();
	endDate = endDatetime.date();

	thisEvent = (Event)stdController.getRecord();
	for(Event e : [select Id, StartDatetime, EndDatetime, WhoId, Who.Name, WhatId, What.Name, SalesHD_Account_Unit__c, SalesHD_Account_Unit__r.Unit__r.Name from Event where Id=:ApexPages.CurrentPage().getparameters().get('id')]) {
		if(e.StartDatetime!=null) {
			startDateFormated = e.StartDatetime.format();
			startDate = e.StartDatetime.date();
			startTime = e.StartDatetime.time();
		}
		if(e.EndDatetime!=null) {
			endDateFormated = e.EndDatetime.format();
			endDate = e.EndDatetime.date();
			endTime = e.EndDatetime.time();

			Long dt1Long = e.StartDatetime.getTime();
			Long dt2Long = e.EndDatetime.getTime();
			Long milliseconds = dt2Long - dt1Long;
			Long seconds = milliseconds / 1000;
			duration = Integer.valueOf(seconds / 60);
		}
		if(e.WhoId!=null) {
			contactId = e.WhoId;
			contactName = e.Who.Name;
		}
		if(e.WhatId!=null) {
			accountId = e.WhatId;
			accountName = e.What.Name;
		}
		if(e.SalesHD_Account_Unit__c!=null) {
			unitId = e.SalesHD_Account_Unit__c;
			if(e.SalesHD_Account_Unit__r.Unit__r.Name=='Administrative') unitName = 'Global / Director';
			else unitName = e.SalesHD_Account_Unit__r.Unit__r.Name;
		}
	}

	additionalContacts = new Map<Id, String>();
	additionalContactIdString = '';
	for(EventRelation er : [select Relation.Name, RelationId from EventRelation where EventId=:ApexPages.CurrentPage().getparameters().get('id') and IsInvitee=true]) {
		additionalContacts.put(er.RelationId, er.Relation.Name);
		additionalContactIdString += er.RelationId+',';
	}
	additionalContactIdString.removeEnd(',');
	additionalContactsString = JSON.serializePretty(additionalContacts);

	unitList = '[]';
	for(Account a : [select Id, Name from Account where Id=:ApexPages.CurrentPage().getparameters().get('accountId') or Id=:accountId limit 1]) {
		accountId = a.Id;
		accountName = a.Name;
		unitList = getUnits(a.Id);
	}

	for(Account_Unit__c au : [select Account__c, Account__r.Name, Unit__r.Name, Id from Account_Unit__c where Id=:ApexPages.CurrentPage().getparameters().get('unitId') limit 1]) {
		accountId = au.Account__c;
		accountName = au.Account__r.Name;
		unitId = au.Id;
		unitName = au.Unit__r.Name;
		unitList = getUnits(au.Account__c);
	}

	for(Contact c : [select Id, Name from Contact where Id=:ApexPages.CurrentPage().getparameters().get('contactId') limit 1]) {
		contactId = c.Id;
		contactName = c.Name;
	}


	List<Event> encountersList = new List<Event>();
	for(Event e : [select Id, SalesHD_Complete__c, Subject, Type from Event where OwnerId=:currentUser and ActivityDate=THIS_MONTH]) {
		encountersList.add(e);
	}
	encounters = JSON.serializePretty(encountersList);

	if(ApexPages.CurrentPage().getparameters().get('duplicate')=='true') {

	}

}

@RemoteAction global static String getContacts() {
	return JSON.serializePretty([select Contact__r.Id, Contact__r.Name from Contact_Team__c where User__c =: currentUser]);
}

@RemoteAction global static String getAccounts() {
	return JSON.serializePretty([select AccountId, Account.Name from AccountTeamMember where UserId =: currentUser and Account.RecordType.Name='HD Accounts']);
}

@RemoteAction global static String getUnits(Id accountId) {
	return JSON.serializePretty([select Id, Unit__r.Name from Account_Unit__c where Account__c =: accountId and Active__c=true]);
}

public void selectRecurrenceType() {
	if(selectedRecurrenceType == 'RecursDaily') {
		thisEvent.RecurrenceType = 'RecursDaily';
	} else if(selectedRecurrenceType == 'RecursWeekly') {
		thisEvent.RecurrenceType = 'RecursWeekly';
	} else if(selectedRecurrenceType == 'RecursMonthly') {
		thisEvent.RecurrenceType = 'RecursMonthly';
	}
}

private static Integer getRecurrenceWeekdayMask(Integer weekday){
	if(weekday==0) return 1;
	if(weekday==1) return 2;
	if(weekday==2) return 4;
	if(weekday==3) return 8;
	if(weekday==4) return 16;
	if(weekday==5) return 32;
	if(weekday==6) return 64;
	return null;
}

public PageReference saveEvent(){
	thisEvent.WhoId = contactId;
	thisEvent.WhatId = accountId;
	thisEvent.SalesHD_Account_Unit__c = unitId;
	thisEvent.Subject = thisEvent.Type;

	thisEvent.StartDateTime = Datetime.newInstance(startDate, startTime);
	thisEvent.EndDateTime = thisEvent.StartDateTime.addMinutes(duration);
	// thisEvent.EndDateTime = Datetime.newInstance(endDate, endTime);

	if(thisEvent.IsRecurrence) {

		thisEvent.RecurrenceStartDateTime = thisEvent.StartDateTime;
		thisEvent.RecurrenceInterval = 1;

		if(selectedRecurrenceType == null) {
			selectedRecurrenceType = 'RecursDaily';
			thisEvent.RecurrenceType = selectedRecurrenceType;
		}

		if(selectedRecurrenceType == 'RecursDaily') {
			thisEvent.RecurrenceEndDateOnly = Date.valueOf(thisEvent.RecurrenceStartDateTime.addDays(3));
		} else if(selectedRecurrenceType == 'RecursWeekly') {
			Date tempDate = Date.valueOf(thisEvent.StartDateTime).toStartofWeek();
			integer dayOfWeek = tempDate.daysBetween(Date.valueOf(thisEvent.StartDateTime));
			thisEvent.RecurrenceDayOfWeekMask = getRecurrenceWeekdayMask(dayOfWeek);
			thisEvent.RecurrenceEndDateOnly = Date.valueOf(thisEvent.RecurrenceStartDateTime.addDays(7*3));
		} else if(selectedRecurrenceType == 'RecursMonthly') {
			thisEvent.RecurrenceDayOfMonth = thisEvent.RecurrenceStartDateTime.day();
			thisEvent.RecurrenceEndDateOnly = Date.valueOf(thisEvent.RecurrenceStartDateTime.addMonths(3));
		}

	}

	PageReference eventPage = null;

	try{
		if(thisEvent.SalesHD_Complete__c==true && (thisEvent.Result__c==null || thisEvent.SalesHD_Close_Customer_Commitment__c==null)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Results and Close / Customer Commitment must be filled out for a complete encounter.'));
		} else{
			if(ApexPages.CurrentPage().getparameters().get('duplicate')=='true') {
				Event tempEvent = new Event();
				tempEvent = thisEvent.clone(false, true);
				tempEvent.Result__c=null;
				tempEvent.SalesHD_Close_Customer_Commitment__c=null;
				tempEvent.SalesHD_Complete__c=false;
				insert tempEvent;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, additionalContactIdString));
				additionalContacts.clear();
				additionalRelatedContacts(tempEvent);
				removeRelatedContacts(tempEvent);
				eventPage = new PageReference('/apex/SalesHD_Encounter?id='+tempEvent.Id);
			} else {
				upsert thisEvent;
				removeRelatedContacts(thisEvent);
				additionalRelatedContacts(thisEvent);
				eventPage = new PageReference('/apex/SalesHD_Encounter?id='+thisEvent.Id);
			}
		}
	}
	catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}

	return eventPage;

}

public PageReference saveNew() {
	PageReference eventPage = null;
	eventPage = saveEvent();
	if(eventPage!=null) eventPage.setRedirect(true);
	return eventPage;
}

private void removeRelatedContacts(Event e){
	List<EventRelation> removeEventContacts = new List<EventRelation>();
	Set<String> removeContactIds = new Set<String>();
	if(removeAdditionalContactIdString!=null && removeAdditionalContactIdString!='') {
		removeContactIds.addAll(removeAdditionalContactIdString.split(','));
		for(EventRelation er : [select RelationId from EventRelation where EventId=:e.Id and IsParent=false]) {
			if(removeContactIds.contains(er.RelationId)) removeEventContacts.add(er);
		}
		delete removeEventContacts;
	}
}

private void additionalRelatedContacts(Event e ){
	List<EventRelation> additionalEventContacts = new List<EventRelation>();
	if(additionalContactIdString!=null && additionalContactIdString!='') {
		for(Id additionalContactId : additionalContactIdString.split(',')) {
			if(!additionalContacts.containsKey(additionalContactId) && e.WhoId!=additionalContactId) additionalEventContacts.add(new EventRelation(RelationId=additionalContactId, IsInvitee=true, EventId=e.Id));
		}
		insert additionalEventContacts;
	}
}
public PageReference saveCompleteEvent() {
	PageReference eventPage = null;
	try{
		thisEvent.SalesHD_Complete__c=true;
		update thisEvent;
		eventPage = new PageReference('/apex/SalesHD_Encounter?id='+thisEvent.Id);
	}
	catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
	return eventPage;
}

public PageReference completeEvent() {
	PageReference eventPage = saveCompleteEvent();
	if(eventPage!=null) eventPage.setRedirect(true);
	return eventPage;
}

public PageReference completeAndNew() {
	saveCompleteEvent();
	PageReference eventPage = new PageReference('/apex/SalesHD_NewEncounter');
	eventPage.setRedirect(true);
	return eventPage;
}

public PageReference completeAndNext() {
	PageReference eventPage = null;
	try{
		thisEvent.SalesHD_Complete__c=true;
		update thisEvent;

		Event tempEvent = new Event();
		Event e = [select StartDateTime, EndDateTime, WhoId, WhatId,
		           SalesHD_Account_Unit__c, Type, SalesHD_Call_Objective__c,
		           SalesHD_Open_Ended_Questions__c, SalesHD_Marketing_Collateral__c,
		           SalesHD_Agenda_Preparation__c, SalesHD_Data_Preparation__c,
		           Subject from Event where Id=:thisEvent.Id];
		tempEvent = e.clone(false, true);
		tempEvent.SalesHD_Last_Encounter__c = thisEvent.SalesHD_Next_Encounter__c;
		insert tempEvent;
		additionalContacts.clear();
		additionalRelatedContacts(tempEvent);
		eventPage = new PageReference('/apex/SalesHD_NewEncounter?id='+tempEvent.Id);
	}
	catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
	if(eventPage!=null) eventPage.setRedirect(true);
	return eventPage;
}

public PageReference saveAndNext() {

	thisEvent.WhoId = contactId;
	thisEvent.WhatId = accountId;
	thisEvent.SalesHD_Account_Unit__c = unitId;
	thisEvent.Subject = thisEvent.Type;

	thisEvent.StartDateTime = Datetime.newInstance(startDate, startTime);
	thisEvent.EndDateTime = thisEvent.StartDateTime.addMinutes(duration);
	// thisEvent.EndDateTime = Datetime.newInstance(endDate, endTime);

	PageReference eventPage;

	try{
		if(thisEvent.SalesHD_Complete__c==true && (thisEvent.Result__c==null || thisEvent.SalesHD_Close_Customer_Commitment__c==null)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Results and Close / Customer Commitment must be filled out for a complete encounter.'));
		} else{
			if(ApexPages.CurrentPage().getparameters().get('duplicate')=='true') {
				Event tempEvent = new Event();
				tempEvent = thisEvent.clone(false, true);
				insert tempEvent;
				additionalRelatedContacts(tempEvent);
				removeRelatedContacts(tempEvent);
				Event tempEvent2 = new Event();
				tempEvent2 = tempEvent.clone(false, true);
				tempEvent2.SalesHD_Next_Encounter__c = null;
				tempEvent2.Result__c=null;
				tempEvent2.SalesHD_Close_Customer_Commitment__c=null;
				tempEvent2.SalesHD_Complete__c=false;
				tempEvent2.SalesHD_Last_Encounter__c = tempEvent.SalesHD_Next_Encounter__c;
				insert tempEvent2;
				additionalRelatedContacts(tempEvent2);
				removeRelatedContacts(tempEvent2);
				eventPage = new PageReference('/apex/SalesHD_NewEncounter?id='+tempEvent2.Id);
			} else {
				upsert thisEvent;
				removeRelatedContacts(thisEvent);
				additionalRelatedContacts(thisEvent);
				Event tempEvent = new Event();
				tempEvent = thisEvent.clone(false, true);
				tempEvent.SalesHD_Next_Encounter__c = null;
				tempEvent.Result__c=null;
				tempEvent.SalesHD_Close_Customer_Commitment__c=null;
				tempEvent.SalesHD_Complete__c=false;
				tempEvent.SalesHD_Last_Encounter__c = thisEvent.SalesHD_Next_Encounter__c;
				insert tempEvent;
				additionalRelatedContacts(tempEvent);
				removeRelatedContacts(tempEvent);
				eventPage = new PageReference('/apex/SalesHD_NewEncounter?id='+tempEvent.Id);
			}
		}
	} catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}

	eventPage.setRedirect(true);
	return eventPage;
}

public PageReference saveAndNew() {
	saveEvent();
	PageReference eventPage = new PageReference('/apex/SalesHD_NewEncounter');
	eventPage.setRedirect(true);
	return eventPage;
}

public PageReference deleteEvent() {
	PageReference eventPage = null;
	try{
		delete thisEvent;
		eventPage = new PageReference('/apex/SalesHD_Encounters');
		eventPage.setRedirect(true);
	}
	catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
	return eventPage;
}

public PageReference recurrenceClicked() {

	displayRecurrence = thisEvent.IsRecurrence;

	return null;
}


public class calendarEvent {
public Id eventId;
public String eventSubject;
public Datetime eventDatetime;
public Boolean complete;
}

@RemoteAction public static String getCalendar(Integer monthOffset, Integer weekOffset, Boolean isWeekly, Id userId){
	Datetime firstDay;
	Integer numberOfDays;
	if(isWeekly) {
		firstDay =  Datetime.newInstance(Date.valueOf(System.now()).addDays(weekOffset*7).toStartOfWeek(), System.now().time());
		numberOfDays = 7;
	} else{
		firstDay =  Datetime.newInstance(Date.valueOf(System.now()).addMonths(monthOffset).toStartOfMonth(), System.now().time());
		numberOfDays = Date.daysInMonth(firstDay.year(), firstDay.month());
	}

	String startDay = String.valueOf(firstDay.format('EEEE'));
	Date lowDate = Date.newInstance(firstDay.year(), firstDay.month(), firstDay.day());
	Date highDate = Date.newInstance(firstDay.year(), firstDay.addDays(numberOfDays).month(), firstDay.addDays(numberOfDays).day());

	List<Event> eventList = [select id, subject, StartDateTime, EndDateTime, SalesHD_Complete__c, description,
	                         who.name, SalesHD_Call_Objective__c, SalesHD_Open_Ended_Questions__c from event where
	                         ownerId=:userId and startDateTime>=:lowDate and endDateTime<=:highDate];
	List<Id> whoIds = new List<Id>();
	for(Event e : eventList) {
		if(e.WhoId!=null) whoIds.add(e.WhoId);
	}
	Map<Id, Contact> contactTiles = new Map<Id, Contact>([select Id, Title__c from contact where Id in: whoIds]);
	Map<Integer, List<calendarEvent> > calendarEvents = new Map<Integer, List<calendarEvent> >();
	for(Event e : eventList) {
		String eventSubject = '';
		if(e.Subject == 'Assessment') {
			eventSubject = String.valueOf(event.Description);
			if(eventSubject!=null && (eventSubject.contains('Submitted Assessment for ') || eventSubject.contains('Submitted Reassessment for '))) {
				eventSubject = eventSubject.replace('Submitted Assessment for ', '').replace('Submitted Reassessment for ', '');
				eventSubject = eventSubject + ': '+e.Subject;
			}
		} else if(e.Who.Name != null) {
			if(contactTiles.containsKey(e.WhoId)) eventSubject = e.Who.Name + ' - '+contactTiles.get(e.WhoId).Title__c+': '+e.Subject;
			else eventSubject = e.Who.Name + ': '+e.Subject;
		}
		calendarEvent temp = new calendarEvent();
		temp.eventId=e.Id; temp.eventSubject=eventSubject; temp.eventDatetime=e.startDateTime;
		temp.complete=e.SalesHD_Complete__c;
		if(calendarEvents.containsKey(e.startDateTime.day())) {
			calendarEvents.get(e.startDateTime.day()).add(temp);
		} else{
			calendarEvents.put(e.startDateTime.day(), new List<calendarEvent> {temp});
		}
	}

	return '{"startDay": "'+startDay+'", "startDayNumber": '+firstDay.day()+', "numberOfDays": '+numberOfDays+', "events":'+JSON.serialize(calendarEvents)+',"lowDate": "'+lowDate.format()+'","highDate": "'+highDate.format()+'"}';
}

@RemoteAction global static List<User> getUsersUnderRoleId(Id roleId) {
	set<Id> allSubRoleIds = getSubRoleIds(new set<ID> {roleId});
	return [select Id, Name, UserRoleId, UserRole.Name from User where UserRoleId in : allSubRoleIds and IsActive=true];
}

private static set<Id> getSubRoleIds(set<Id> roleIds) {
	set<Id> returnRoleIds = new set<Id>();
	for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
		returnRoleIds.add(r.Id);
	}
	if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
	return returnRoleIds;
}

@RemoteAction global static String getUsersByRole(String roleId) {
	String currentRoleName = '';
	List<UserRole> currentRoleNameList = [select Name from UserRole where Id = :roleId];
	if(!currentRoleNameList.isEmpty()) {
		currentRoleName = currentRoleNameList[0].Name;
	}
	List<UserRole> subRoles = [select Id, Name from UserRole where parentRoleId = :roleId order by Name];
	List<User> users = [select Id, Name from User where UserRoleId = :roleId and isActive=true order by Name];
	return '{ "currentRoleName":"'+currentRoleName+
	       '", "subRoles": '+JSON.serializePretty(subRoles)+
	       ', "users": '+JSON.serializePretty(users)+'  }';
}

@RemoteAction public static String getDay(String dateString){
	Time startTime = Time.newInstance(0,0,0,0);
	Time endTime = Time.newInstance(23,59,59,999);
	Datetime startDate = Datetime.newInstance(System.now().date(), startTime);
	Datetime endDate = Datetime.newInstance(System.now().date(), endTime);
	if(dateString!=null){
		Date d = Date.valueOf(dateString);
		startDate = Datetime.newInstance(d, startTime);
		endDate= Datetime.newInstance(d, endTime);
	}
	// return startDate.format() + ' '+endDate.format();

	return JSON.serialize([select id, subject, StartDateTime, EndDateTime, SalesHD_Complete__c, description,
	                       who.name, SalesHD_Call_Objective__c, SalesHD_Open_Ended_Questions__c from event
	                       where ownerId=: currentUser and startDateTime>=:startDate and endDateTime<=:endDate]);
}

}