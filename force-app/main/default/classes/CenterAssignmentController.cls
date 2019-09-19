/*************************************************************************
Name             :  CenterAssignmentController
Author           :  Lalit Malav
Task             :  T-12930
Date             :  18 October 2011
Usage            :  Controller class for the CenterAssignment page 
**************************************************************************/
public with sharing class CenterAssignmentController 
{
   Account currentAccount;
  public Program__c searchedProgram{get;set;}
  public list<ProgramWrapperCls> lstProgramWrapper{get;set;}
  public list<ContentLinkWrapperCls> lstContentLinkWrapperCls{get;set;}
  public String strSearch{get;set;} 
  set<ID> programIDs;
  public CenterAssignmentController(ApexPages.StandardController controller) {
         currentAccount= ( Account ) controller.getRecord();
         System.debug('=========currentaccount.id in constructor'+currentAccount.ID);
         strSearch = '';    
         searchedProgram = new Program__c();        
         getCreatedContentLink();
  }
  void getCreatedContentLink(){
    // get already created content link  
    programIDs = new set<ID>();  
    lstContentLinkWrapperCls = new list<ContentLinkWrapperCls>();    
    for(Program_Link__c cl : [Select Program__c, Name, Id, Center__c,Center__r.name,Program__r.name  From Program_Link__c where center__c = : currentAccount.ID order by Center__r.name]){
      lstContentLinkWrapperCls.add(new ContentLinkWrapperCls(cl));
      programIDs.add(cl.Program__c);
    }  
    SearchProgram();  
  }
  public void SearchProgram(){
    strSearch = searchedProgram.Name;
    if(strSearch != null && strSearch !=''){
      strSearch = '%'+strSearch+'%';
      lstProgramWrapper = new list<ProgramWrapperCls>();
      for(Program__c prog:[Select id, Name from Program__c where id not in :programIDs And name like :strSearch limit 1000]){
        lstprogramWrapper.add(new ProgramWrapperCls(prog));
      }
    }
    else{
      //strSearch += '%';
      lstProgramWrapper = new list<ProgramWrapperCls>();
      for(Program__c prog:[Select id, Name from Program__c where id not in :programIDs order by Name]){
        lstProgramWrapper.add(new ProgramWrapperCls(prog));
      }
    }    
  }
  public class ProgramWrapperCls {
       public Boolean isSelected {get;set;}
       public Program__c cProgram {get;set;}
  
       public ProgramWrapperCls(Program__c cProgram){
            this.cProgram = cProgram;
       }
  }
  public class ContentLinkWrapperCls {
       public Boolean isSelected {get;set;}
       public Program_Link__c ContentLink {get;set;}
  
       public ContentLinkWrapperCls(Program_Link__c cContentLink){
            this.ContentLink = cContentLink;
       }
  }
  public void CreateContentLink(){
     System.debug('=========currentaccount.id in createContentLink()'+currentAccount.ID);
     System.debug('=========lstProgramWrapper in createContentLink()'+lstProgramWrapper);
    list<Program_Link__c> lstContentLinkToBeCreated = new list<Program_Link__c>();
    for(ProgramWrapperCls progWrapeer :lstProgramWrapper){
      if(progWrapeer.isSelected){
        Program_Link__c newContentLink = new Program_Link__c();
        newContentLink.Center__c = currentAccount.ID;
        newContentLink.Program__c = progWrapeer.cProgram.ID;
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
  	Map<ID,Program_Link__c> ProgramLinkIds = new Map<ID,Program_Link__c>([select Id from Program_Link__c]);
  	System.debug('========ProgramLinkIds'+ProgramLinkIds);
    list<Program_Link__c> lstContentLinkToBeDeleted = new list<Program_Link__c>();
    for(ContentLinkWrapperCls clWrapeer :lstContentLinkWrapperCls){
      if(clWrapeer.isSelected && ProgramLinkIds.containsKey(clWrapeer.ContentLink.Id)){
        lstContentLinkToBeDeleted.add(clWrapeer.ContentLink);      
      }      
    }
    // delete seleted Content Link
    if(lstContentLinkToBeDeleted.size() > 0){
      delete lstContentLinkToBeDeleted;
      getCreatedContentLink();      
    }
   else
        {
        	getCreatedContentLink();
        }
  }

}