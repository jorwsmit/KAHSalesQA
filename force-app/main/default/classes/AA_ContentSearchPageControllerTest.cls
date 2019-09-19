@isTest 
private class AA_ContentSearchPageControllerTest {

    static testMethod void myUnitTest() {
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Center'].Id;
        
        //Create an Account
        Account acc = new Account(Name = 'Test Account'
                                 ,RecordTypeid = strRecordTypeId
                                 ,Type = 'Center');
        insert Acc;
        
        
        //Create a Program
        Program__c prog = new Program__c(Name = 'Test-Program');
        insert prog;
        // Create a Content
        List<ContentVersion> ContentVersionList = new List<ContentVersion>();
        ContentVersion ContentVersionObj = new ContentVersion( Title='new test'
                                                            , PathOnClient='path'
                                                            ,VersionData= Blob.valueof('verData')
                                                            );
        ContentVersionList.add(ContentVersionObj); 
        
        ContentVersion ContentVersionObj1 = new ContentVersion( Title='TestTitle1', PathOnClient='path1',VersionData= Blob.valueof('verData1'));
        ContentVersionList.add(ContentVersionObj1); 
        Database.insert(ContentVersionList);
        
        ContentVersionObj = [select ContentDocumentId from ContentVersion where id = :ContentVersionObj.id];
        //ContentWorkspace shareWorkspace = [select id from ContentWorkspace 
          //        where name = :workspaceName limit 1];
		id workID = [SELECT ID FROM ContentWorkspace WHERE NAME = 'NCD Mobile'].Id;
        ContentWorkspaceDoc docLink = new ContentWorkspaceDoc();
        docLink.ContentDocumentId = ContentVersionObj.ContentDocumentId;
        docLink.ContentWorkspaceId = workID;
        insert docLink;
        
        list<Content_Link__c> contentLinkList = new list<Content_Link__c>();
        Content_Link__c link1 = new Content_Link__c(Account__c = acc.id
                                                    , Document_Name__c = 'new test'
                                                    ,Document_Id__c = '');   
        //insert
       contentLinkList.add(link1);
        Content_Link__c link2 = new Content_Link__c(Account__c = acc.id
                                                    , Document_Name__c = 'new test1'
                                                    ,Document_Id__c = ContentVersionObj.ContentDocumentId);
        contentLinkList.add(link2);
        
        PageReference pageRef = Page.ContentSearchPage;
        Test.setCurrentPage(pageRef);
        ContentSearchPageController controller = new ContentSearchPageController();
        controller.searchString = 'test';
        controller.searchByDocumentTitle();
        controller.documentwrapperList[0].selected = true;
        controller.checkAssociation();
        controller.documentwrapperList[0].selected = true;
        controller.selectedCenters.add(new SelectOption(acc.Id, acc.Name));
        controller.onConfirm();
        controller.onReset();
        
        controller.searchString = 'Test Account';
        controller.searchByDocumentCenter();
        
        controller.searchCenter = 'Test';
        controller.updateAvailableList();
        
        controller.searchProgram = 'Test';
        controller.updateAvailableList();
        
        
        controller.onReset();
        controller.searchString = 'test';
        controller.searchByDocumentTitle();
        controller.documentwrapperList[0].selected = true;
        controller.checkAssociation();
        controller.documentwrapperList[0].selected = true;
        ApexPages.currentPage().getParameters().put('serialnumber','1');
        controller.delRow();
        }
        
    static testMethod void myUnitTest2(){
        ContentSearchPageController controller = new ContentSearchPageController();
        string searchType = 'FileType';
        controller.searchString = 'jk';
        controller.dosearch(searchType);
        
        controller.searchbyCenter = false;
        controller.checkAssociation();
        
        controller.searchbyCenter = true;
        controller.checkAssociation();
        
        controller.inertContentLinkData();
        
        controller.onConfirm();
        
        }   
        
}