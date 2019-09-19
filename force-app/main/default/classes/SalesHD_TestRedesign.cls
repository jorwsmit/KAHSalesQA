@isTest(seeAllData=false)
private class SalesHD_TestRedesign {
@testSetup static void setup(){
	Account acct = new Account(Name='Test Account', Status__c='Active');
	insert acct;

	AccountTeamMember atm = new AccountTeamMember(AccountId=acct.Id, UserId=UserInfo.getUserId());
	insert atm;

	Unit__c u1 = new Unit__c(Name='Administrative', Active__c=True);
	insert u1;

	Unit__c u2 = new Unit__c(Name='ICU - CARDIAC', Active__c=True);
	insert u2;

	Account_unit__c au1 = new Account_unit__c(Unit__c=u1.Id, Account__c=acct.Id, Active__c=True);
	insert au1;

	Account_unit__c au2 = new Account_unit__c(Unit__c=u2.Id, Account__c=acct.Id, Active__c=True);
	insert au2;

	Contact con = new Contact(FirstName='Test', LastName = 'Contact', Status__c='Active', Title__c='ICU Director');
	insert con;

	Contact con2 = new Contact(FirstName='Test', LastName = 'Contact2', Status__c='Active', Title__c='Nurse Manager');
	insert con2;

	Contact_Team__c ct = new Contact_Team__c(Contact__c=con.Id, User__c=UserInfo.getUserId());
	insert ct;

	Contact csuiteCon = new Contact(FirstName='Test', LastName = 'Contact2', Title__c='CEO');
	insert csuiteCon;

	Account_unit_contact__c auc = new Account_unit_contact__c(Account_Unit__c=au1.Id, Contact__c=con.Id);
	insert auc;
	auc = new Account_unit_contact__c(Account_Unit__c=au1.Id, Contact__c=csuiteCon.Id);
	insert auc;
	auc = new Account_unit_contact__c(Account_Unit__c=au2.Id, Contact__c=con.Id);
	insert auc;

	Sales_Performance__c sp = new Sales_Performance__c(Month__c=Date.newInstance(System.now().year(), System.now().month(), 1));
	insert sp;

	sp = new Sales_Performance__c(Month__c=Date.newInstance(System.now().addMonths(-1).year(),
	                                                        System.now().addMonths(-1).month(), 1), Actual_Revenue__c=1, Targeted_Revenue__c=1);
	insert sp;

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id);
	insert e;

	e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now().addDays(-1),
	              EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id);
	insert e;

	e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now().addDays(1),
	              EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id);
	insert e;


	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
	System.runAs ( thisUser ) {
		User usr = new User(Alias = 'newUser2', Email='testhduser2@kndcrm.com',
		                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		                    LocaleSidKey='en_US', ProfileId = '00ea0000001serv',
		                    TimeZoneSidKey='America/Los_Angeles', UserName='testhduser2@kndcrm.com', UserRoleId='00E130000020vp7');
		insert usr;

		Alert_and_Comment__c ac = new Alert_and_Comment__c(Datetime__c=System.now(), Comment_By__c=usr.Id,
		                                                   Type__c='HD Corporate Message', Comment__c='Test');
		insert ac;
	}
}

// --------------- SalesHD_Account Tests --------------------
@isTest static void Account_getCsuite() {
	Test.startTest();
	SalesHD_Account.getCsuite([select Id from account where name='Test Account' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Account_getContacts() {
	Test.startTest();
	SalesHD_Account.getContacts([select Id from account where name='Test Account' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Account_saveContact() {
	Test.startTest();
	SalesHD_Account.saveContact([select Id from account where name='Test Account' limit 1][0].Id,
	                            [select Id from contact where name='Test Contact' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Account_getFavoritedContacts() {
	Test.startTest();
	SalesHD_Account.getFavoritedContacts();
	Test.stopTest();
}

@isTest static void Account_getUnits() {
	Test.startTest();
	SalesHD_Account.getUnits([select Id from account where name='Test Account' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Account_isFavorited() {
	Test.startTest();
	SalesHD_Account.isFavorited([select Id from account where name='Test Account' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Account_saveFollowup() {
	Test.startTest();
	SalesHD_Account.saveFollowup([select Id from account where name='Test Account' limit 1][0].Id, Date.valueOf(System.now()).format());
	Test.stopTest();
}

@isTest static void Account_saveNoteGetNotes() {
	Test.startTest();
	SalesHD_Account.saveNote([select Id from account where name='Test Account' limit 1][0].Id,
	                         'noteInput', 'titleInput');
	String s = SalesHD_Account.getNotes([select Id from account where name='Test Account' limit 1][0].Id);
	List<ContentNote> notes = (List<ContentNote>) JSON.deserialize(s, List<ContentNote>.class);
	SalesHD_Account.deleteNote(notes[0].Id);
	Test.stopTest();
}

public class updateUnit {
public Id unitId;
public Boolean isActive;
}

@isTest static void Account_saveUnits() {
	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];
	List<updateUnit> units = new List<updateUnit>();
	updateUnit temp = new updateUnit();
	temp.unitId=au.Id;
	temp.isActive=au.Active__c;
	units.add(temp);
	Test.startTest();
	SalesHD_Account.saveUnits(acct.Id, JSON.serializePretty(units));
	Test.stopTest();
}

@isTest static void Account_getEncounters() {
	Account acct = [select Id from account where name='Test Account' limit 1];
	Test.startTest();
	SalesHD_Account.getEncounters(acct.Id);
	Test.stopTest();
}

@isTest static void Account_favoriteUnfavoriteAccount() {
	Test.startTest();
	SalesHD_Account.favoriteUnfavoriteAccount([select Id from account where name='Test Account' limit 1][0].Id);
	Test.stopTest();
}


@isTest static void Account_constructor() {
	Account acct = [select Id from account where name='Test Account' limit 1];
	PageReference pageRef = Page.SalesHD_Account;
	Test.setCurrentPage(pageRef);
	Test.startTest();
	pageRef.getParameters().put('id',acct.id);
	ApexPages.StandardController sc = new ApexPages.standardController(acct);
	SalesHD_Account controller = new SalesHD_Account(sc);
	Test.stopTest();
}

@isTest static void Account_save() {
	Account acct = [select Id from account where name='Test Account' limit 1];
	PageReference pageRef = Page.SalesHD_Account;
	Test.setCurrentPage(pageRef);
	Test.startTest();
	pageRef.getParameters().put('id',acct.id);
	ApexPages.StandardController sc = new ApexPages.standardController(acct);
	SalesHD_Account controller = new SalesHD_Account(sc);
	controller.save();
	Test.stopTest();
}
// --------------- END SalesHD_Account Tests --------------------


// --------------- SalesHD_Contact Tests --------------------

@isTest static void Contact_getUnits() {
	Test.startTest();
	SalesHD_Contact.getUnits([select Id from contact where name='Test Contact' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Contact_getFavoritedAccounts() {
	Test.startTest();
	SalesHD_Contact.getFavoritedAccounts();
	Test.stopTest();
}

@isTest static void Contact_getAccounts() {
	Test.startTest();
	SalesHD_Contact.getAccounts([select Id from contact where name='Test Contact' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Contact_saveFollowup() {
	Test.startTest();
	SalesHD_Contact.saveFollowup([select Id from contact where name='Test Contact' limit 1][0].Id, Date.valueOf(System.now()).format());
	Test.stopTest();
}

@isTest static void Contact_isFavorited() {
	Test.startTest();
	SalesHD_Contact.isFavorited([select Id from contact where name='Test Contact' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Contact_favoriteUnfavoriteContact() {
	Test.startTest();
	SalesHD_Contact.favoriteUnfavoriteContact([select Id from contact where name='Test Contact' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Contact_saveNoteGetNotes() {
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Test.startTest();
	SalesHD_Contact.saveNote(con.Id,'noteInput', 'titleInput');
	String s = SalesHD_Contact.getNotes(con.Id);
	List<ContentNote> notes = (List<ContentNote>) JSON.deserialize(s, List<ContentNote>.class);
	SalesHD_Contact.updateNote(notes[0].Id,'noteInputUpdate', 'titleInputUpdate');
	SalesHD_Contact.deleteNote(notes[0].Id);
	Test.stopTest();
}

@isTest static void Contact_removeUnit() {
	Account_Unit_Contact__c auc = [select Id from Account_Unit_Contact__c where
	                               Account_Unit__r.Account__r.Name='Test Account' and Contact__r.Name='Test Contact'
	                                                                                                   and Account_Unit__r.Unit__r.Name!='Administrative' limit 1];
	Test.startTest();
	SalesHD_Contact.removeUnit(auc.Id,
	                           [select Id from contact where name='Test Contact' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Contact_removeAccount() {
	Test.startTest();
	SalesHD_Contact.removeAccount([select Id from account where name='Test Account' limit 1][0].Id,
	                              [select Id from contact where name='Test Contact' limit 1][0].Id);
	Test.stopTest();
}

@isTest static void Contact_constructor() {
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	PageReference pageRef = Page.SalesHD_Contact;
	Test.setCurrentPage(pageRef);
	Test.startTest();
	pageRef.getParameters().put('id',con.id);
	ApexPages.StandardController sc = new ApexPages.standardController(con);
	SalesHD_Contact controller = new SalesHD_Contact(sc);
	Test.stopTest();
}

@isTest static void Contact_constructorWithAccount() {
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where name='Test Account' limit 1];
	PageReference pageRef = Page.SalesHD_Contact;
	Test.setCurrentPage(pageRef);
	Test.startTest();
	pageRef.getParameters().put('id',con.id);
	pageRef.getParameters().put('accountId',acct.id);
	ApexPages.StandardController sc = new ApexPages.standardController(con);
	SalesHD_Contact controller = new SalesHD_Contact(sc);
	Test.stopTest();
}

@isTest static void Contact_save() {
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	PageReference pageRef = Page.SalesHD_Contact;
	Test.setCurrentPage(pageRef);
	Test.startTest();
	pageRef.getParameters().put('id',con.id);
	ApexPages.StandardController sc = new ApexPages.standardController(con);
	SalesHD_Contact controller = new SalesHD_Contact(sc);
	controller.save();
	Test.stopTest();
}

@isTest static void Contact_getEncounters() {
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Test.startTest();
	SalesHD_Contact.getEncounters(con.Id);
	Test.stopTest();
}

@isTest static void Contact_saveNew() {
	PageReference pageRef = Page.SalesHD_Contact;
	Test.setCurrentPage(pageRef);
	Contact addContact = new Contact();
	addContact.firstName='test'; addContact.lastName='contact';
	addContact.mailingStreet='1 Main St'; addContact.mailingCity='Louisville';
	addContact.mailingState='KY'; addContact.mailingPostalCode='47129';
	addContact.title__c='test'; addContact.phone='555-555-5555';
	Test.startTest();
	ApexPages.StandardController sc = new ApexPages.standardController(addContact);
	SalesHD_Contact controller = new SalesHD_Contact(sc);
	controller.cont = addContact;
	controller.saveNew();
	Test.stopTest();
}

// --------------- END SalesHD_Event Tests --------------------

@isTest static void Event_saveNew() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), StartDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');
	Test.startTest();
	pageRef.getParameters().put('unitId',au.id);

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.thisEvent = e;
	controller.saveNew();
	Test.stopTest();
}

@isTest static void Event_saveNewDuplicate() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), StartDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	pageRef.getParameters().put('duplicate','true');

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.thisEvent = e;
	controller.saveNew();
	Test.stopTest();
}

@isTest static void Event_saveAndNew() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), StartDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');
	Test.startTest();
	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.thisEvent = e;
	controller.saveAndNew();
	Test.stopTest();
}

@isTest static void Event_saveAndNext() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), StartDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');
	Test.startTest();
	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.thisEvent = e;
	controller.saveAndNext();
	Test.stopTest();
}

@isTest static void Event_saveAndNewDuplicate() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), StartDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	pageRef.getParameters().put('duplicate','true');

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.thisEvent = e;
	controller.saveAndNew();
	Test.stopTest();
}

@isTest static void Event_saveAndNextDuplicate() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), StartDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	pageRef.getParameters().put('duplicate','true');

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.thisEvent = e;
	controller.saveAndNext();
	Test.stopTest();
}

@isTest static void Event_Update() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	insert e;

	pageRef.getParameters().put('id',e.id);

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.saveNew();
	Test.stopTest();
}

@isTest static void Event_Delete() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	insert e;

	pageRef.getParameters().put('id',e.id);

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.deleteEvent();
	Test.stopTest();
}

@isTest static void Event_Complete() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	insert e;

	pageRef.getParameters().put('id',e.id);

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.completeEvent();
	Test.stopTest();
}

@isTest static void Event_CompleteAndNew() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	insert e;

	pageRef.getParameters().put('id',e.id);

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.completeAndNew();
	Test.stopTest();
}

@isTest static void Event_CompleteAndNext() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	insert e;

	pageRef.getParameters().put('id',e.id);

	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.completeAndNext();
	Test.stopTest();
}

@isTest static void Event_Recurrence() {
	PageReference pageRef = Page.SalesHD_NewEncounter;
	Test.setCurrentPage(pageRef);
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test', IsRecurrence=true);

	Test.startTest();
	ApexPages.StandardController sc = new ApexPages.standardController(e);
	SalesHD_Event controller = new SalesHD_Event(sc);
	controller.thisEvent = e;
	controller.selectedRecurrenceType = 'RecursDaily';
	controller.selectRecurrenceType();
	controller.saveNew();

	controller.selectedRecurrenceType = 'RecursWeekly';
	controller.selectRecurrenceType();
	controller.saveNew();

	controller.selectedRecurrenceType = 'RecursMonthly';
	controller.selectRecurrenceType();
	controller.saveNew();
	Test.stopTest();
}

@isTest static void Event_getCalendar() {
	Test.startTest();
	SalesHD_Event.getCalendar(0, 0, false, UserInfo.getUserId());
	SalesHD_Event.getCalendar(0, 0, true, UserInfo.getUserId());
	Test.stopTest();
}

@isTest static void Event_getUsersUnderRoleId() {
	Test.startTest();
	SalesHD_Event.getUsersUnderRoleId(UserInfo.getUserRoleId());
	Test.stopTest();
}

@isTest static void Event_getUsersByRole() {
	Test.startTest();
	SalesHD_Event.getUsersByRole(UserInfo.getUserRoleId());
	Test.stopTest();
}

@isTest static void Event_getDay() {
	Datetime d = System.now();
	Test.startTest();
	SalesHD_Event.getDay(d.format('yyyy-MM-dd'));
	Test.stopTest();
}

@isTest static void Event_getContactsgetAccounts() {
	Test.startTest();
	SalesHD_Event.getContacts();
	SalesHD_Event.getAccounts();
	Test.stopTest();
}




// --------------- SalesHD_Homepage Tests --------------------

@isTest static void Homepage_constructor() {
	Test.startTest();
	PageReference pageRef = Page.SalesHD_Homepage;
	Test.setCurrentPage(pageRef);
	SalesHD_Homepage controller = new SalesHD_Homepage();
	controller.accountSearchString = 'test';
	controller.selectedAccountId = 'test';
	controller.contactSearchString = 'test';
	controller.selectedContactId = 'test';
	Test.stopTest();
}

@isTest static void Homepage_getDirectory() {
	Test.startTest();
	SalesHD_Homepage.getDirectory();
	Test.stopTest();
}

@isTest static void Homepage_getAccounts() {
	Test.startTest();
	SalesHD_Homepage.getAccounts();
	Test.stopTest();
}

@isTest static void Homepage_getContacts() {
	Test.startTest();
	SalesHD_Homepage.getContacts();
	Test.stopTest();
}

@isTest static void Homepage_searchAccounts() {
	Test.startTest();
	SalesHD_Homepage.searchAccounts('Test', '');
	Test.stopTest();
}

@isTest static void Homepage_searchContacts() {
	Test.startTest();
	SalesHD_Homepage.searchContacts('Test', '');
	Test.stopTest();
}

@isTest static void Homepage_getLeaderboard() {
	Test.startTest();
	SalesHD_Homepage.getLeaderboard();
	Test.stopTest();
}

@isTest static void Homepage_getMessages() {
	User u = new User(Alias = 'newUser', Email='testhduser@kndcrm.com',
	                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
	                  LocaleSidKey='en_US', ProfileId = '00ea0000001serv',
	                  TimeZoneSidKey='America/Los_Angeles', UserName='testhduser@kndcrm.com', UserRoleId='00E3000000128JB');
	insert u;

	Test.startTest();
	System.runAs(u) {
		SalesHD_Homepage.getMessages();
	}
	Test.stopTest();
}

@isTest static void Homepage_getNotifications() {
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now().addDays(-1),
	                    EndDateTime=system.now().addDays(-1)+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	insert e;

	SalesHD_Homepage.getNotifications();
	Test.stopTest();
}

@isTest static void Homepage_getDischargeDisposition() {
	Test.startTest();
	SalesHD_Homepage.getDischargeDisposition();
	Test.stopTest();
}

@isTest static void Homepage_getReports() {
	Test.startTest();
	SalesHD_Homepage.getReports();
	Test.stopTest();
}

// --------------- END SalesHD_Homepage Tests --------------------

// --------------- SalesHD_Unit Tests --------------------

@isTest static void Unit_constructor() {
	PageReference pageRef = Page.SalesHD_Unit;
	Test.setCurrentPage(pageRef);

	// SalesHD_Unit controller = new SalesHD_Unit();
	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Test.startTest();
	ApexPages.StandardController sc = new ApexPages.standardController(au);
	SalesHD_Unit controller = new SalesHD_Unit(sc);

	pageRef.getParameters().put('id',au.id);
	Test.stopTest();
}

@isTest static void Unit_saveNoteGetNotes() {
	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];
	Test.startTest();
	SalesHD_Unit.saveNote(au.Id,
	                      'noteInput', 'titleInput');
	String s = SalesHD_Unit.getNotes(au.Id);
	List<ContentNote> notes = (List<ContentNote>) JSON.deserialize(s, List<ContentNote>.class);
	SalesHD_Unit.updateNote(notes[0].Id,'noteInputUpdate', 'titleInputUpdate');
	SalesHD_Unit.deleteNote(notes[0].Id);
	Test.stopTest();
}

@isTest static void Unit_getFavoriedContacts() {
	Test.startTest();
	SalesHD_Unit.getFavoriedContacts();
	Test.stopTest();
}

@isTest static void Unit_saveContact() {
	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];
	Contact con = [select Id from contact where name='Test Contact2' limit 1];
	Test.startTest();
	SalesHD_Unit.saveNote(au.Id,
	                      'noteInput', 'titleInput');
	SalesHD_Unit.saveContact(au.Id, con.Id, 'Nurse Manager');
	Test.stopTest();
}

@isTest static void Unit_saveContactPostalCode() {
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c in (select Id from account where name='Test Account') and Unit__r.Name!='Administrative' limit 1];
	Contact con = new Contact(FirstName='Test', LastName = 'PostalCodeTest',
	                          Status__c='Active', Title__c='Nurse Manager', MailingPostalCode='111111111');
	Test.startTest();
	insert con;
	SalesHD_Unit.saveContact(au.Id, con.Id, 'Nurse Manager');
	Test.stopTest();
}

@isTest static void Unit_saveContactPostalCodeInvalid() {
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c in (select Id from account where name='Test Account') and Unit__r.Name!='Administrative' limit 1];
	Contact con = new Contact(FirstName='Test', LastName = 'PostalCodeTest',
	                          Status__c='Active', Title__c='Nurse Manager', MailingPostalCode='111');
	Test.startTest();
	insert con;
	SalesHD_Unit.saveContact(au.Id, con.Id, 'Nurse Manager');
	Test.stopTest();
}

@isTest static void Unit_getContact() {
	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];
	Test.startTest();
	SalesHD_Unit.getContacts(au.Id);
	Test.stopTest();
}

@isTest static void Unit_getEncounters() {
	Contact con = [select Id from contact where name='Test Contact' limit 1];
	Account acct = [select Id from account where Name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];

	Event e = new Event(ownerId=UserInfo.getUserId(), ActivityDateTime=System.now(),
	                    EndDateTime=system.now()+5, Type='Follow-up', whoId=con.Id, whatId=acct.Id,
	                    SalesHD_Account_Unit__c=au.Id, SalesHD_Call_Objective__c='Other',
	                    SalesHD_Open_Ended_Questions__c='test');

	Test.startTest();
	insert e;

	SalesHD_Unit.getEncounters(au.Id);
	Test.stopTest();

}


@isTest static void Unit_saveCensusGetCensus() {


	PageReference pageRef = Page.SalesHD_Unit;
	Test.setCurrentPage(pageRef);

	// SalesHD_Unit controller = new SalesHD_Unit();
	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];
	ApexPages.StandardController sc = new ApexPages.standardController(au);
	// pageRef.getParameters().put('id',pr.id);
	SalesHD_Unit controller = new SalesHD_Unit(sc);

	Test.startTest();
	controller.censusDate = System.now().date();
	controller.census = 5;
	controller.beds = 5;
	controller.saveCensus();
	SalesHD_Unit.getCensus(au.Id);
	Test.stopTest();
}

@isTest static void Unit_saveNickname() {


	PageReference pageRef = Page.SalesHD_Unit;
	Test.setCurrentPage(pageRef);
	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c, SalesHD_Unit_Nickname__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];
	ApexPages.StandardController sc = new ApexPages.standardController(au);
	SalesHD_Unit controller = new SalesHD_Unit(sc);

	Test.startTest();
	au.SalesHD_Unit_Nickname__c = 'test';
	controller.saveNickname();
	Test.stopTest();
}

// --------------- SalesHD_Census Tests --------------------

@isTest static void Census_constructor() {


	PageReference pageRef = Page.SalesHD_Census;
	Test.setCurrentPage(pageRef);

	Account acct = [select Id from account where name='Test Account' limit 1];
	Account_Unit__c au = [select Id, Active__c from Account_Unit__c where
	                      Account__c=:acct.Id and Unit__r.Name!='Administrative' limit 1];
	ApexPages.StandardController sc = new ApexPages.standardController(new Unit_Census__c());
	// pageRef.getParameters().put('id',pr.id);
	SalesHD_Census controller = new SalesHD_Census(sc);

	Test.startTest();
	controller.censusDate = System.now().date();
	controller.census = 5;
	controller.beds = 5;
	controller.unitId = au.Id;
	controller.saveCensus();
	SalesHD_Census.getCensus(au.Id);
	Test.stopTest();
}


// --------------- SalesHD_NewPhysicianRequest Tests --------------------

@isTest static void NewPhysicianRequest_saveNew() {
	PageReference pageRef = Page.SalesHD_NewPhysicianRequest;
	Test.setCurrentPage(pageRef);

	Contact pr = new Contact();
	pr.FirstName='test'; pr.LastName='request'; pr.Requested_Physician_NPI__c='12345';
	pr.MailingStreet='680 South Fourth Street'; pr.MailingCity='Louisville';
	pr.MailingState='KY'; pr.MailingPostalCode='40202';

	Test.startTest();
	ApexPages.StandardController sc = new ApexPages.standardController(pr);
	SalesHD_NewPhysicianRequest controller = new SalesHD_NewPhysicianRequest(sc);
	controller.physician = pr;
	controller.saveNew();
	Test.stopTest();
}

@isTest static void NewPhysicianRequest_saveNewError() {
	PageReference pageRef = Page.SalesHD_NewPhysicianRequest;
	Test.setCurrentPage(pageRef);

	Contact pr = new Contact();
	pr.FirstName='test'; pr.LastName='request';
	insert pr;
	pageRef.getParameters().put('id',pr.id);
	ApexPages.StandardController sc = new ApexPages.standardController(pr);
	SalesHD_NewPhysicianRequest controller = new SalesHD_NewPhysicianRequest(sc);
	controller.physician = pr;
	Test.startTest();
	controller.saveNew();
	Test.stopTest();
}

@isTest static void NewPhysicianRequest_sendEmail() {
	RecordType requestRecordType = [select Id from RecordType where
	                                Name='HD Physician Requests' and SObjectType='Contact' limit 1];

	Contact pr = new Contact();
	pr.FirstName='test'; pr.LastName='request'; pr.Requested_Physician_NPI__c='12345';
	pr.MailingStreet='680 South Fourth Street'; pr.MailingCity='Louisville';
	pr.MailingState='KY'; pr.MailingPostalCode='40202'; pr.RecordTypeId=requestRecordType.Id;

	insert pr;

	SalesHD_Redesign__c setting = new SalesHD_Redesign__c();
	setting.Name = 'Meditech Team Email';
	setting.Meditech_Request_Email__c = 'test@test.org';
	insert setting;

	setting = new SalesHD_Redesign__c();
	setting.Name = 'HD Admin ReplyTo Physician Requests';
	setting.Meditech_Request_Email__c = 'test@test.org';
	insert setting;

	Test.startTest();
	SalesHD_NewPhysicianRequest.sendEmail();
	Test.stopTest();
}

// @isTest static void NewPhysicianRequest_saveNew() {
// 	PageReference pageRef = Page.SalesHD_NewPhysicianRequest;
// 	Test.setCurrentPage(pageRef);
//
// 	New_Physician_Request__c pr = new New_Physician_Request__c();
// 	pr.First_Name__c='test'; pr.Last_Name__c='request'; pr.Requested_Physician_NPI__c='12345';
// 	pr.Mailing_Street__c='680 South Fourth Street'; pr.Mailing_City__c='Louisville';
// 	pr.Mailing_State__c='KY'; pr.Mailing_Postal_Code__c='40202';
//
//
// 	ApexPages.StandardController sc = new ApexPages.standardController(pr);
// 	SalesHD_NewPhysicianRequest controller = new SalesHD_NewPhysicianRequest(sc);
// 	controller.physician = pr;
// 	controller.saveNew();
// }
//
// @isTest static void NewPhysicianRequest_saveNewError() {
// 	PageReference pageRef = Page.SalesHD_NewPhysicianRequest;
// 	Test.setCurrentPage(pageRef);
//
// 	New_Physician_Request__c pr = new New_Physician_Request__c();
// 	pr.First_Name__c='test'; pr.Last_Name__c='request';
// 	insert pr;
// 	pageRef.getParameters().put('id',pr.id);
// 	ApexPages.StandardController sc = new ApexPages.standardController(pr);
// 	SalesHD_NewPhysicianRequest controller = new SalesHD_NewPhysicianRequest(sc);
// 	controller.physician = pr;
// 	Test.startTest();
// 	controller.saveNew();
// 	Test.stopTest();
// }
//
// @isTest static void NewPhysicianRequest_sendEmail() {
// 	New_Physician_Request__c pr = new New_Physician_Request__c();
// 	pr.First_Name__c='test'; pr.Last_Name__c='request'; pr.Requested_Physician_NPI__c='12345';
// 	pr.Mailing_Street__c='680 South Fourth Street'; pr.Mailing_City__c='Louisville';
// 	pr.Mailing_State__c='KY'; pr.Mailing_Postal_Code__c='40202';
//
// 	insert pr;
//
// 	SalesHD_Redesign__c setting = new SalesHD_Redesign__c();
// 	setting.Name = 'Meditech Team Email';
// 	setting.Meditech_Request_Email__c = 'test@test.org';
// 	insert setting;
//
// 	setting = new SalesHD_Redesign__c();
// 	setting.Name = 'HD Admin ReplyTo Physician Requests';
// 	setting.Meditech_Request_Email__c = 'test@test.org';
// 	insert setting;
//
// 	Test.startTest();
// 	SalesHD_NewPhysicianRequest.sendEmail();
// 	Test.stopTest();
// }



}