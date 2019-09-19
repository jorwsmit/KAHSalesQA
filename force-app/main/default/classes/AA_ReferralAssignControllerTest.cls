@isTest
private class AA_ReferralAssignControllerTest{

    static testMethod void myUnitTest() {
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
        insert objAccount;
        
        Account objAccount2 = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[1].Id, NPI__c = '13');
        insert objAccount2;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        AA_ReferralAssignController testAccPlan = new AA_ReferralAssignController(sc);
        
        
        AA_ReferralAssignController.assignUnassignAccountAlt();
        PageReference myPage = new Pagereference('/apex/AA_AccountReferralAssign');
        myPage.getParameters().put('id',objAccount.ID);
        Test.setCurrentPage(myPage);
        AA_ReferralAssignController.assignUnassignAccountAlt();
        AA_ReferralAssignController.assignUnassignAccountAlt();
        
        myPage.getParameters().put('id',objAccount2.ID);
        AA_ReferralAssignController.assignUnassignAccountAlt();
        }
        
    static testMethod void myUnitTest2(){
        List<RecordType> lstRecTypesCon = [Select Name, Id From RecordType where sObjectType='Contact' AND isActive = true];
        
        Contact objContact = new Contact(LastName='TestContact', RecordTypeId = lstRecTypesCon[0].Id, NPI__c = '1263');
        
        insert objContact;
        
        AA_ReferralAssignController.assignUnassignContactAlt();
        PageReference myPage = new Pagereference('/apex/AA_ContactReferralAssign');
        myPage.getParameters().put('id',objContact.ID);
        Test.setCurrentPage(myPage);
        
        AA_ReferralAssignController.assignUnassignContactAlt();
        AA_ReferralAssignController.assignUnassignContactAlt();
        }   
}