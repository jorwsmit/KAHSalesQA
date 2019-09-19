public with sharing class ContentToCenterLinkController 
{
    Account currentAccount;
    public list<ContentWrapperCls> lstContentWrapper{get;set;}
    public list<ContentLinkWrapperCls> lstContentLinkWrapperCls{get;set;}
    set<String> contentDocId;

     //Wrapper Class for Content
    public class ContentWrapperCls {
       public Boolean isSelected {get;set;}
       public ContentVersion content {get;set;}
  
       public ContentWrapperCls(ContentVersion content){
            this.content = content;
       }
    }
   
    //Wrapper Class for Content Link
    public class ContentLinkWrapperCls {
       public Boolean isSelected {get;set;}
       public Content_Link__c contentLink {get;set;}
  
       public ContentLinkWrapperCls(Content_Link__c contentLink){
            this.contentLink = contentLink;
       }
    }
 
     //Get created content
     void getCreatedContentLink(){
        contentDocId  = new set<String>(); 
        lstContentLinkWrapperCls = new list<ContentLinkWrapperCls>();    
        
        for(Content_Link__c cl : [Select Program__c , Account__c , Document_Id__c, Document_Name__c  From Content_Link__c where Account__r.Id = : currentAccount.ID order by Name]){
            lstContentLinkWrapperCls.add(new ContentLinkWrapperCls(cl));
            contentDocId.add(cl.Document_Id__c);
        }  
        SearchContent();  
      }
      
      
     public void SearchContent(){
   
      //strSearch += '%';
      lstContentWrapper = new list<ContentWrapperCls>();
      for(ContentVersion c: [select Id, ContentDocumentId, IsLatest, ContentUrl, VersionNumber, Title, Description, ReasonForChange, PathOnClient, RatingCount, IsDeleted, ContentModifiedDate, ContentModifiedById, PositiveRatingCount, NegativeRatingCount, FeaturedContentBoost, FeaturedContentDate, TagCsv, FileType, PublishStatus, ContentSize, FirstPublishLocationId, Origin, Category_Tags__c, Audience_Tag__c from ContentVersion where IsLatest = true and ContentDocumentId not in :contentDocId order by Title LIMIT 999])
       {
           ContentVersion newContent = new ContentVersion();
           newContent.Title = c.Title;
           newContent.ContentDocumentId = c.ContentDocumentId;
           newContent.VersionData = null;
           lstContentWrapper.add(new ContentWrapperCls(newContent));
       }  
        
      }  
      
    //Constructor
    public ContentToCenterLinkController(ApexPages.StandardController controller) {
         currentAccount= ( Account ) controller.getRecord();
         System.debug('=========currentaccount.id in constructor'+currentAccount.ID);
         getCreatedContentLink();
    }
    
   public void CreateContentLink(){
    list<Content_Link__c> lstContentLinkToBeCreated = new list<Content_Link__c>();
    for(ContentWrapperCls contWrapeer :lstContentWrapper){
      if(contWrapeer != null && contWrapeer.isSelected == true){
        Content_Link__c newContentLink = new Content_Link__c();
        newContentLink.Account__c = currentAccount.ID;
        //newContentLink.Tags__c = contWrapeer.content.
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
  public void DeleteContentLink(){
    //Map<ID,Program_Link__c> ProgramLinkIds = new Map<ID,Program_Link__c>([select Id from Program_Link__c]);
    //System.debug('========ProgramLinkIds'+ProgramLinkIds);
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