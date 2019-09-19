@isTest
private class TBN_ContactTeamTest {

    static testMethod void testContactTeam() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        list<User> lstUserToInsert = new list<User>();
        
        for(Integer i=0; i<=14; i++)
        {
            lstUserToInsert.add(new User(Alias = 'teCon'+i, Email='testContactTeam'+i+'@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='testContactTeam'+i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testContactTeam'+i+'@testorg.com'));
        }
        insert lstUserToInsert;
        
        //create new contact
        Contact objContact = new Contact(LastName='Test Contact');
        insert objContact;
        
        Contact objContact1 = new Contact(LastName='Test Contact');
        insert objContact1;
        
        Contact_Team__c objContactTeam = new Contact_Team__c(Contact__c = objContact.Id,User__c = lstUserToInsert[0].Id);
        insert objContactTeam;
        
        Contact_Team__c objContactTeam1 = new Contact_Team__c(Contact__c = objContact.Id,User__c = lstUserToInsert[1].Id);
        insert objContactTeam1;
        
        Contact_Team__c objContactTeam2 = new Contact_Team__c(Contact__c = objContact1.Id,User__c = lstUserToInsert[1].Id);
        insert objContactTeam2;
        
        Contact_Team__c objContactTeam3 = new Contact_Team__c(Contact__c = objContact1.Id,User__c = lstUserToInsert[1].Id);
        insert objContactTeam3;
        
        objContactTeam1.User__c = lstUserToInsert[0].Id;
        update objContactTeam1;
        
        delete objContactTeam3;
     
    }
}