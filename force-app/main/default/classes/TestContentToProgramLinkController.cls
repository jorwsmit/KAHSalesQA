/*
Name:        TestContentToCenterLinkController
Created Date:23/10/2011
Created By:  Lalit Malav
Description: Test class for TestContentToProgramLinkController
*/
@isTest
private class TestContentToProgramLinkController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<ContentVersion> ContentVersionList = new List<ContentVersion>();
        ContentVersion ContentVersionObj = new ContentVersion( Title='TestTitle', PathOnClient='path',VersionData= Blob.valueof('verData'));
        ContentVersionList.add(ContentVersionObj); 
        ContentVersion ContentVersionObj1 = new ContentVersion( Title='TestTitle1', PathOnClient='path1',VersionData= Blob.valueof('verData1'));
        ContentVersionList.add(ContentVersionObj1); 
        Database.insert(ContentVersionList);
       
        PageReference pageRef = Page.ContentToCenterLink;
        Program__c programObj = new Program__c(Name='Test Program');
        Database.insert(programObj);
        ApexPages.StandardController standardController = new ApexPages.standardController(programObj);
        ApexPages.currentPage().getParameters().put('id', programObj.Id);
        Test.setCurrentPageReference(pageRef);
        ContentToProgramLinkController controllerObj = new ContentToProgramLinkController(standardController);
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