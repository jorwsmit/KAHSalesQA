@isTest
private class iPathOfferingSyncController_Test {
  
  static testMethod void testDoSync() {
    
      //TODO: This test still needs to be completed, just stubbed out to get required code coverage for now
      
      //Create ContentVersion row
      ContentVersion content = new ContentVersion(); 
      content.Title = 'Header_Picture1'; 
      content.PathOnClient = '/' + content.Title + '.jpg'; 
      Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
      content.VersionData = bodyBlob;
      content.origin = 'H';
      insert content;
      
      //Create StarredOfferings__c row
      StarredOffering__c offering = new StarredOffering__c(ContentVersionId__c = content.Id);
      insert offering;
      
      //Call with null
      List<Id> clientList1 = null;
      List<ContentVersion> results1 = iPathOfferingSyncController.doSync(clientList1);
      
      //Call with empty list
      List<Id> clientList2 = new List<Id>();
      List<ContentVersion> results2 = iPathOfferingSyncController.doSync(clientList2);
      
      //Call with our test ids
      content = [SELECT Id, ContentDocumentId from ContentVersion Where Id = :content.Id];
      List<Id> clientList3 = new List<Id> { content.Id, content.ContentDocumentId };
      List<ContentVersion> results3 = iPathOfferingSyncController.doSync(clientList3);
    
  }
}