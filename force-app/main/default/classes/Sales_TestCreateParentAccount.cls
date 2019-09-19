@isTest(SeeAllData=false)
public class Sales_TestCreateParentAccount {

  @testSetup static void dataSetup() {
    final ID SALES_KAH_Associate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
    User usr = new User(Alias = 'test', Email='KAHSalesAssociate@testorg.com',
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
    LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate,
    TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate@testorg.com');
    insert usr;

    usr = new User(Alias = 'test2', Email='KAHSalesAssociate2@testorg.com',
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
    LocaleSidKey='en_US', ProfileId = SALES_KAH_Associate,
    TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociate2@testorg.com');
    insert usr;

  }



  static testmethod void AddingContacts() {
  Account unassigned = new Account(Name='Unassigned Account - Admin Maintenance');
  insert unassigned;
  User usr = [select id from user where email='KAHSalesAssociate@testorg.com'];

  Contact con1 = new Contact(FirstName='Test', LastName = 'Account1', Unity_Id__c = '1', accountId=unassigned.Id, MailingCity='Louisville', MailingState='KY');
  insert con1;
  Contact_Team__c ct1 = new Contact_Team__c(User__c = usr.Id, Contact__c = con1.Id);
	Test.startTest();
  //The following four should not populate postal code field because it is invalid
  Contact con2 = new Contact(LastName='Account2', Unity_Id__c = '2', accountId=unassigned.Id, MailingCity='Louisville', MailingState='KY', MailingPostalCode='0000', phone='1111111111');
  insert con2;
  Contact_Team__c ct2 = new Contact_Team__c(User__c = usr.Id, Contact__c = con2.Id);

  Contact con3 = new Contact(LastName='Account3', Unity_Id__c = '3', accountId=unassigned.Id, MailingCity='Louisville', MailingState='KY', MailingPostalCode='00000--000', phone='111-111-1111');
  insert con3;
  Contact_Team__c ct3 = new Contact_Team__c(User__c = usr.Id, Contact__c = con3.Id);

  Contact con4 = new Contact(LastName='Account4', Unity_Id__c = '4', accountId=unassigned.Id, MailingCity='Louisville', MailingState='KY', MailingPostalCode='000000000', phone='(111) 111-1111');
  insert con4;
  Contact_Team__c ct4 = new Contact_Team__c(User__c = usr.Id, Contact__c = con4.Id);

  
  System.assert(con1.practice_account__c == null && con2.practice_account__c == null
  && con3.practice_account__c == null && con4.practice_account__c == null);

  Test.stopTest();
  	System.runAs(usr){
  		insert ct1;
  		insert ct2;
  		insert ct3;
  		insert ct4;
		}


}

static testmethod void AddingOneContact() {
Account unassigned = new Account(Name='Unassigned Account - Admin Maintenance');
insert unassigned;
User usr = [select id from user where email='KAHSalesAssociate@testorg.com'];

Account acct = new Account(name='Test');
insert acct;

//This should not attach to an account, because it has a practice account
Contact con1 = new Contact(FirstName='Test', LastName = 'Account', Unity_Id__c = '1', AccountId = acct.Id, practice_account__c = acct.Id);
insert con1;
Contact_Team__c ct1 = new Contact_Team__c(User__c = usr.Id, Contact__c = con1.Id);

//This should not attach to an account, because it does not have a Unity or Horizon ID
Contact con2 = new Contact(FirstName='Test', LastName = 'Account', accountId=unassigned.Id);
insert con2;
Contact_Team__c ct2 = new Contact_Team__c(User__c = usr.Id, Contact__c = con2.Id);

System.assert(con1.practice_account__c == acct.Id && con2.practice_account__c == null);

Test.startTest();
insert ct1;
insert ct2;
Test.stopTest();

con1 = [select practice_account__c from contact where id = :con1.id];
con2 = [select practice_account__c from contact where id = :con2.id];
//System.assert(con1.practice_account__c == acct.Id && con2.practice_account__c == null);

}

static testmethod void alreadyAssigned() {
Account unassigned = new Account(Name='Unassigned Account - Admin Maintenance');
insert unassigned;
User usr = [select id from user where email='KAHSalesAssociate@testorg.com'];

User usr2 = [select id from user where email='KAHSalesAssociate2@testorg.com'];

Account acct = new Account(name='Cats, [Practice]', is_practice_account__c=true);
insert acct;

AccountTeamMember atm = new AccountTeamMember(accountId=acct.Id, userId=usr2.Id);
insert atm;
Test.startTest();
Contact con1 = new Contact(FirstName='Test', LastName = 'Account', Unity_Id__c = '1', accountId=unassigned.Id);
insert con1;
Contact_Team__c ct1 = new Contact_Team__c(User__c = usr.Id, Contact__c = con1.Id);

//user2 has an assignment already, so the removal of duplicate account team members should be hit at the bottom of the trigger
Contact con2 = new Contact(LastName='Account', Unity_Id__c = '2', accountId=acct.Id, practice_account__c=acct.Id);
insert con2;
Contact_Team__c ct2 = new Contact_Team__c(User__c = usr2.Id, Contact__c = con2.Id);

//This should not attach to an account, because it does not have a Unity ID
Contact con3 = new Contact(FirstName='Test', LastName = 'Account');
insert con3;
Contact_Team__c ct3 = new Contact_Team__c(User__c = usr.Id, Contact__c = con3.Id);

System.assert(con1.practice_account__c == null && con2.practice_account__c == acct.Id && con3.practice_account__c == null);


insert ct1;
insert ct2;
insert ct3;
Test.stopTest();

con1 = [select practice_account__r.name from contact where id = :con1.id];
con2 = [select practice_account__r.name from contact where id = :con2.id];
con3 = [select practice_account__r.name from contact where id = :con3.id];

//System.assert(con1.practice_account__r.name == 'Account, Test [Practice]' && con2.practice_account__r.name == 'Cats, [Practice]' && con3.practice_account__r.name == null);

}


static testmethod void addingUnassigned() {
  Account unassigned = new Account(Name='Unassigned Account - Admin Maintenance');
  insert unassigned;
  User usr = [select id from user where email='KAHSalesAssociate@testorg.com'];

  Account acct2 = new Account(name='Cats', is_practice_account__c=true);
  insert acct2;

  //This should attach a practice account and override the unassigned account
  Contact con1 = new Contact(FirstName='Test', LastName = 'Account', Unity_Id__c = '1', AccountId = unassigned.Id);
  insert con1;
  Contact_Team__c ct1 = new Contact_Team__c(User__c = usr.Id, Contact__c = con1.Id);

  //This should attach a practice account and not override the account
  Contact con2 = new Contact(LastName='Account', Unity_Id__c = '2', accountId=acct2.Id);
  insert con2;
  Contact_Team__c ct2 = new Contact_Team__c(User__c = usr.Id, Contact__c = con2.Id);

  System.assert(con1.AccountId == unassigned.Id);

  con1 = [select practice_account__r.name, account.name from contact where id = :con1.id];
  con2 = [select practice_account__r.name, account.name from contact where id = :con2.id];
  //System.debug('Before: '+con1.practice_account__r.name +' '+ con1.account.name);

  Test.startTest();
  insert ct1;
  insert ct2;
  Test.stopTest();

  con1 = [select practice_account__r.name, account.name from contact where id = :con1.id];
  con2 = [select practice_account__r.name, account.name from contact where id = :con2.id];
  //System.debug('After: '+con1.practice_account__r.name +' '+ con1.account.name);
  /*
  System.assert(con1.practice_account__r.name == 'Account, Test [Practice]' && con1.account.name == 'Account, Test [Practice]');
  System.assert(con2.practice_account__r.name == 'Account, [Practice]' && con2.account.name == 'Cats');
  */
}

}