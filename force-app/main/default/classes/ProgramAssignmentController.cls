/*************************************************************************
Name             :  ProgramAssignmentController
Author           :  Vinod Kumar
Task             :  T-12929
Date             :  18 October 2011
Usage            :   Controller class for the ProgramAssignment page 
Modified dat     :
**************************************************************************/
public with sharing class ProgramAssignmentController {

    Program__c currentProgramm;
    public Account searchedAccount{get;set;}
    public list<AccountWrapperCls> lstAccountWrapper{get;set;}
    public list<ContentLinkWrapperCls> lstContentLinkWrapperCls{get;set;}
    public ID districtID{get;set;}
    set<ID> accountIDs;
    public ProgramAssignmentController(ApexPages.StandardController controller) {
         currentProgramm= ( Program__c ) controller.getRecord();
         districtID = null;    
         searchedAccount = new Account();        
         getCreatedContentLink();
    }
    void getCreatedContentLink(){
        // get already created content link 
        accountIDs = new set<ID>(); 
        lstContentLinkWrapperCls = new list<ContentLinkWrapperCls>();       
        for(Program_Link__c cl : [Select Program__c, Name, Id, Center__c,Center__r.name  From Program_Link__c where Program__c = : currentProgramm.ID order by Center__r.name]  ){
            lstContentLinkWrapperCls.add(new ContentLinkWrapperCls(cl));
            accountIDs.add(cl.Center__c);
        }   
        SearchCenter(); 
    }
    public void SearchCenter(){
        districtID = searchedAccount.District_Lookup__c;
        if(districtID != null ){
            lstAccountWrapper = new list<AccountWrapperCls>();
            for(Account acc:[Select id, Name,RecordType.Name, RecordTypeId from Account where id not in :accountIDs And District__c = :districtID and RecordType.Name ='Center' order by Name]){
           // for(Account acc:[Select id, Name,RecordType.Name, RecordTypeId from Account where id not in :accountIDs And District__c = :districtID order by Name]){  
                lstAccountWrapper.add(new AccountWrapperCls(acc));
            }
        }
        else{
            lstAccountWrapper = new list<AccountWrapperCls>(); 
            for(Account acc:[Select id, Name,RecordType.Name, RecordTypeId from Account where id not in :accountIDs and RecordType.Name ='Center' order by Name]){
           // for(Account acc:[Select id, Name,RecordType.Name, RecordTypeId from Account where id not in :accountIDs and RecordType.Name ='Center' order by Name limit 100]){    
                lstAccountWrapper.add(new AccountWrapperCls(acc));
            }
        }       
    }
    public class AccountWrapperCls {
         public Boolean isSelected {get;set;}
         public Account cAccount {get;set;}
    
         public AccountWrapperCls(Account cAccount){
              this.cAccount = cAccount;
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
        list<Program_Link__c> lstContentLinkToBeCreated = new list<Program_Link__c>();
        for(AccountWrapperCls acccWrapeer :lstAccountWrapper){
            if(acccWrapeer.isSelected){
                Program_Link__c newContentLink = new Program_Link__c();
                newContentLink.Center__c = acccWrapeer.cAccount.ID;
                newContentLink.Program__c = currentProgramm.ID;
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
        System.debug('========ProgramLinkIds pAssign'+ProgramLinkIds);
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