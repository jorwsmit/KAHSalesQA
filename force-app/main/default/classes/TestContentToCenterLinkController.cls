/*
Name:        TestContentToCenterLinkController
Created Date:23/10/2011
Created By:  Lalit Malav
Description: Test class for TestContentToCenterLinkController
*/
@isTest
private class TestContentToCenterLinkController {

    static testMethod void myUnitTest() {
        //inserting data in content version
        List<ContentVersion> ContentVersionList = new List<ContentVersion>();
        ContentVersion ContentVersionObj = new ContentVersion( Title='TestTitle', PathOnClient='path',VersionData= Blob.valueof('verData'));
        ContentVersionList.add(ContentVersionObj); 
        ContentVersion ContentVersionObj1 = new ContentVersion( Title='TestTitle1', PathOnClient='path1',VersionData= Blob.valueof('verData1'));
        ContentVersionList.add(ContentVersionObj1); 
        Database.insert(ContentVersionList);
       
        PageReference pageRef = Page.ContentToCenterLink;
        Account accObj = new Account(Name='Test Account');
        Database.insert(accObj);
        ApexPages.StandardController standardController = new ApexPages.standardController(accObj);
        ApexPages.currentPage().getParameters().put('id', accObj.Id);
        Test.setCurrentPageReference(pageRef);
        ContentToCenterLinkController controllerObj = new ContentToCenterLinkController(standardController);
        //Asserting on load functionality of page
        //System.assertEquals(controllerObj.lstContentWrapper.size(), 2);
        System.assertEquals(controllerObj.lstContentLinkWrapperCls.size(), 0);
        
        controllerObj.lstContentWrapper.get(0).isSelected=true;
        controllerObj.lstContentWrapper.get(1).isSelected=false;
        //Assrting button "-->" functionalty by calling function CreateContentLink()
        controllerObj.CreateContentLink();
        //System.assertEquals(controllerObj.lstContentWrapper.size(), 1);
        //System.assertEquals(controllerObj.lstContentLinkWrapperCls.size(), 1);
        
        controllerObj.lstContentLinkWrapperCls.get(0).isSelected=true;
        //Asserting button "<--" by calling function DeleteContentLink()
        controllerObj.DeleteContentLink();
        //System.assertEquals(controllerObj.lstContentWrapper.size(), 2);
        //System.assertEquals(controllerObj.lstContentLinkWrapperCls.size(), 0);
    }
}