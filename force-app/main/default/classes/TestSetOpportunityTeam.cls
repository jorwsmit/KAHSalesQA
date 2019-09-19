@isTest (seeAllData=false)
public class TestSetOpportunityTeam {
    
    @isTest static void ByChangingOppStageName() {
        
        //create and insert new account
        Account acct = new Account(Name='Test Account');
        insert acct;
        
        //create and insert new user
        final id Sales_KHRS_Associate_ARU = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: HD Associate'].ID;
         
        User usr = new User(Alias = 'test', Email='KHRSLiaison@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = Sales_KHRS_Associate_ARU, 
        TimeZoneSidKey='America/Los_Angeles', UserName='KHRSLiaison@testorg.com');
        insert usr;
        
        //add new user to account team
        List<AccountTeamMember> members = new list<AccountTeamMember>();
        members.add(New AccountTeamMember(AccountId = acct.id, TeamMemberRole = 'Clinical Liaison', UserId= usr.Id));
        insert members;
        
        //create and insert new opportunity        
        Opportunity opp = new Opportunity(Name=acct.Name + ' OpportunityTest', StageName='Qualification',
                                      CloseDate=System.today().addMonths(1),AccountId=acct.Id, KHRS_Plan_Id__c='Test');
        insert opp;  
        
        //test by updating the opportunity name to deferred
        Test.startTest();
        
        Opportunity opp2 = [Select Id, StageName from Opportunity where Id =: opp.Id];
        opp2.StageName = 'Deferred';
        update opp2;
        
        Test.stopTest();
        
    }//end ByChangingOppStageName
    
}//end TestSetOpportunityTeam