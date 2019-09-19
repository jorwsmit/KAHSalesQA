@isTest 
private class AA_PF_MonthlyClientMeetingControllerTest {

    private static testMethod void myUnitTest(){
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        list<Account>lstAccount = new list<Account>();
        
        string repNameTitle;
        string facID;
        string cAttendees;
        string rhbAttendees;
        boolean reportPresented;
        string meetDate;
        string mClReport;
        string disc1;
        string concl1;
        string action1;
        string dueD1;
        string disc2;
        string concl2;
        string action2;
        string dueD2;
        string disc3;
        string concl3;
        string action3;
        string dueD3;
        boolean cliCon;
        string cliConSpec;
        boolean nonImed;
        string specif2;
        string specificGJ;
        string comments;
        
        Account objAccount = new Account(Name='Texas Account', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
		lstAccount.add(objAccount);
		
		Account objAccount2 = new Account(Name='TestAccount2', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '123');
		lstAccount.add(objAccount2);
		
		Account objAccount5 = new Account(Name='TestAccount5');
		lstAccount.add(objAccount5);
		insert lstAccount;
        
        AA_PF_MonthlyClientMeetingController.populateAccount(objAccount.ID);
        AA_PF_MonthlyClientMeetingController.getInfo();
        AA_PF_MonthlyClientMeetingController.saveForm(repNameTitle, facID, cAttendees, rhbAttendees, reportPresented, meetDate, mClReport, disc1, concl1, action1, dueD1, disc2, concl2, action2, dueD2, disc3, concl3, action3, dueD3, cliCon, cliConSpec, nonImed, specif2, specificGJ, comments);
    	}
}