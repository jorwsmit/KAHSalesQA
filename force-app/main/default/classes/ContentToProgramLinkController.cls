public with sharing class ContentToProgramLinkController 
{
    Program__c currentProgram;
    public list<ContentWrapperCls> lstContentWrapper{get;set;}
    public list<ContentLinkWrapperCls> lstContentLinkWrapperCls{get;set;}
    set<String> contentDocId;
    
    //Wrapper Class for Content
    public class ContentWrapperCls{
      public Boolean isSelected {get;set;}
      public ContentVersion content {get;set;}
    
      public ContentWrapperCls(ContentVersion content){
              this.content = content;
         }
    }
    
     //Wrapper Class for Content Link
     public class ContentLinkWrapperCls {
           public Boolean isSelected {get;set;}
           public Content_Link__c ContentLink {get;set;}
      
           public ContentLinkWrapperCls(Content_Link__c cContentLink){
                this.ContentLink = cContentLink;
           }
      }
    
    //get Created Content
    void getCreatedContentLink(){
       contentDocId  = new set<String>(); 
       lstContentLinkWrapperCls = new list<ContentLinkWrapperCls>();    
       for(Content_Link__c cl : [Select Program__c , Account__c, Document_Id__c, Document_Name__c  From Content_Link__c where Program__r.Id = : currentProgram.ID order by Name]){
        lstContentLinkWrapperCls.add(new ContentLinkWrapperCls(cl));
        contentDocId.add(cl.Document_Id__c);
    }  
    SearchContent();  
      
  }
  
  //Constructor
    public ContentToProgramLinkController(ApexPages.StandardController controller) {
         currentProgram= ( Program__c ) controller.getRecord();
         //System.debug('=========currentaccount.id in constructor'+currentAccount.ID);
         getCreatedContentLink();
         
  }
    
   //Search for content
   public void SearchContent(){
   
      //strSearch += '%';
      lstContentWrapper = new list<ContentWrapperCls>();
      //for(Content_Link__c prog:[Select Program__c , Account__c , Content_Id__c, Document_Id__c, Document_Name__c  From Content_Link__c where Document_Name__c not in :contentNames order by Name]){
      //  lstContentWrapper.add(new ContentWrapperCls(prog));
      //}
      
      for(ContentVersion c: [select Id, ContentDocumentId, IsLatest, ContentUrl, VersionNumber, Title, Description, ReasonForChange, PathOnClient, RatingCount, IsDeleted, ContentModifiedDate, ContentModifiedById, PositiveRatingCount, NegativeRatingCount, FeaturedContentBoost, FeaturedContentDate, TagCsv, FileType, PublishStatus, ContentSize, FirstPublishLocationId, Origin, Category_Tags__c, Audience_Tag__c from ContentVersion where IsLatest = true and ContentDocumentId not in :contentDocId order by Title LIMIT 999])
       {
           ContentVersion newContent = new ContentVersion();
           newContent.Title = c.Title;
           newContent.ContentDocumentId = c.ContentDocumentId;
           newContent.VersionData = null;
           lstContentWrapper.add(new ContentWrapperCls(newContent));
       }
        
  }
 
  //Create Content link
  public void CreateContentLink(){
    list<Content_Link__c> lstContentLinkToBeCreated = new list<Content_Link__c>();
    for(ContentWrapperCls contWrapeer :lstContentWrapper){
      if(contWrapeer != null && contWrapeer.isSelected == true){
        Content_Link__c newContentLink = new Content_Link__c();
        newContentLink.Program__c = currentProgram.ID;
        newContentLink.Document_Name__c = contWrapeer.content.Title;
        newContentLink.Document_Id__c = contWrapeer.content.ContentDocumentId;
        
        lstContentLinkToBeCreated.add(newContentLink);
       
      }      
    }
   
    // insert the new clint link
    if(lstContentLinkToBeCreated.size() > 0){
      insert lstContentLinkToBeCreated;  
      getCreatedContentLink();      
    }
    
  }
  
  //Delete Content link
  public void DeleteContentLink(){
    list<Content_Link__c> lstContentLinkToBeDeleted = new list<Content_Link__c>();
    for(ContentLinkWrapperCls clWrapeer :lstContentLinkWrapperCls){
      if(clWrapeer.isSelected ){
        lstContentLinkToBeDeleted.add(clWrapeer.ContentLink);      
      }      
    }
    
    // delete seleted Content Link
    if(lstContentLinkToBeDeleted.size() > 0){
      delete lstContentLinkToBeDeleted;
      getCreatedContentLink();      
    }
   
  }

}