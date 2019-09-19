/*************************************************************************
Name             :  testProgramAssignmentController
Author           :  Vinod Kumar
Task             :  T-12929
Date             :  20 October 2011
Usage            :  Test class for the test coverage of the ProgramAssignmentController class
Modified dat     :
**************************************************************************/
@isTest
private class testProgramAssignmentController {
    static testMethod void myUnitProgramAssignment() {
        // create test data
        District__c testDistrict = new District__c(Name='TestDistrict');
        insert testDistrict;
        // Get account recordtype id
        ID accountRecordTypeID = null;
        for(RecordType rt:[Select SobjectType, Name, Id From RecordType where SobjectType = 'Account' and Name='Center' limit 1]){
            accountRecordTypeID = rt.ID;
        }
       // create account
       list<Account> lstAccount = new list<Account>();
       String accountName = 'AccountTest';
       for (Integer i=0;i<5;i++){
            lstAccount.add(new Account(name=accountName+i,District__c=testDistrict.id,District_Lookup__c=testDistrict.id,RecordTypeId= accountRecordTypeID));  
        }
       insert lstAccount;
       // Create a Program
       Program__c currentProgram = new Program__c(Name='TestProgram');
       insert  currentProgram;
       
       // Create a Contact Link for the current program 
       // Add center to program
       list<Program_Link__c> lstContactLink = new List<Program_Link__c>();
       for (Integer i=0;i<2;i++){
            lstContactLink.add(new Program_Link__c(Center__c = lstAccount[i].ID,Program__c=currentProgram.ID)); 
        }
       insert lstContactLink;
       
       ///
       PageReference pageRef = Page.ProgramAssignment;       
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.StandardController(currentProgram);
       ProgramAssignmentController pgrController = new ProgramAssignmentController(sc);
       
       system.assertEquals(pgrController.lstContentLinkWrapperCls.size(),2);
       
       // delete the allredy created Center
       for(Integer i=0;i<pgrController.lstContentLinkWrapperCls.size();i++){
            pgrController.lstContentLinkWrapperCls[i].isSelected = true;
       }
       pgrController.DeleteContentLink();
       system.assertEquals(pgrController.lstContentLinkWrapperCls.size(),0);
       
       // search the center
       pgrController.searchedAccount = lstAccount[0];
       pgrController.SearchCenter();
       system.assertEquals(pgrController.lstAccountWrapper.size(),5);
       
       // add the only 2 center
       for(Integer i=0; i < pgrController.lstAccountWrapper.size();i++){
            if(i< 2)
                pgrController.lstAccountWrapper[i].isSelected = true;
            else
                pgrController.lstAccountWrapper[i].isSelected = false;
       }
       pgrController.CreateContentLink();
       system.assertEquals(pgrController.lstAccountWrapper.size(),3); 
       system.assertEquals(pgrController.lstContentLinkWrapperCls.size(),2);
    }
    
}