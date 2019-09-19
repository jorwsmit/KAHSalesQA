/*
Name:        TestCenterAssignmentController
Created Date:19/10/2011
Created By:  Lalit Malav
Description: Test class for CenterAssignmentController
*/
@isTest
private class TestCenterAssignmentController {

    static testMethod void myUnitTest() 
    {
       //inserting new program to Program__c Object
        List<Program__c> programList = new List<Program__c>();
        Program__c program1 = new Program__c(Name = 'prog1');
        programList.add(program1);
        Program__c program2 = new Program__c(Name = 'prog2');
        programList.add(program2);
        Program__c program3 = new Program__c(Name = 'prog3');
        programList.add(program3);
        Database.insert(programList);
        //Setting up Account id in current page and calling CenterAssignmentController
        PageReference pageRef = Page.CenterAssignment;
        Account accObj = new Account();
        try{
        	accObj = [Select name from Account where  Name='Global Media' Limit 1];
        	}
        catch(Exception E){
        	accObj.Name='Global Media';
        	insert accObj;
        	}	
        ApexPages.StandardController standardController = new ApexPages.standardController(accObj);
        ApexPages.currentPage().getParameters().put('id', accObj.Id);
        Test.setCurrentPageReference(pageRef);
        CenterAssignmentController extension = new CenterAssignmentController(standardController);
       //testing Onload functionality of VF page (CenterAssignment) 
        Map<ID,Program__c> programMap=getProgramMap(extension);
        System.assert(programMap.containsKey(program1.id));
        System.assert(programMap.containsKey(program2.id));
        System.assert(programMap.containsKey(program3.id));
        
        Map<ID, Program_Link__c> contentLinkMap = getContentLinkMap(extension);
        System.assert(!contentLinkMap.containsKey(program1.id));
        System.assert(!contentLinkMap.containsKey(program2.id));
        System.assert(!contentLinkMap.containsKey(program3.id));
        //now make program prog1 checked to be inserted to Content_Link__c object
         for(CenterAssignmentController.ProgramWrapperCls progWrapperObj : extension.lstProgramWrapper) 
         {
            if(progWrapperObj.cProgram.Name == 'prog1')
            {
                progWrapperObj.isSelected = true;
            }
            else
            {
                progWrapperObj.isSelected = false;
            }
         }
       
        //calling controller's function CreateContentLink to create content link in Content_Link__c object
        extension.CreateContentLink();
         //testing Add Center to Program button functionality and asserting that program1 should not appear in result of( Add Center to Program)
        programMap=getProgramMap(extension);
        System.assert(!programMap.containsKey(program1.id));
        System.assert(programMap.containsKey(program2.id));
        System.assert(programMap.containsKey(program3.id));
        //Asserting that program1 should be inserted to Content_Link__c object
        contentLinkMap = getContentLinkMap(extension);
        System.assert(contentLinkMap.containsKey(program1.id));
        System.assert(!contentLinkMap.containsKey(program2.id));
        System.assert(!contentLinkMap.containsKey(program3.id));
        //Now make program1 checked to be deleted from Content_Link__c object
        for(CenterAssignmentController.ContentLinkWrapperCls contentlinkWrapperObj : extension.lstContentLinkWrapperCls) 
        {
            if(contentlinkWrapperObj.ContentLink.Program__c == program1.id)
            {
                contentlinkWrapperObj.isSelected = true;
            }
            else
            {
                contentlinkWrapperObj.isSelected = false;
            }
        }
        //call DeleteContentLink() function of controller to delete program1 from Content_Link__c object
        extension.DeleteContentLink();
        programMap=getProgramMap(extension);
        System.assert(programMap.containsKey(program1.id));
        System.assert(programMap.containsKey(program2.id));
        System.assert(programMap.containsKey(program3.id));
        
        contentLinkMap = getContentLinkMap(extension);
        System.assert(!contentLinkMap.containsKey(program1.id));
        System.assert(!contentLinkMap.containsKey(program2.id));
        System.assert(!contentLinkMap.containsKey(program3.id));
        
        System.debug('========program wrapper'+extension.lstProgramWrapper);
        System.debug('========content link'+extension.lstContentLinkWrapperCls);
    }
    
    //function returns a map of programId and Program__c object by taking Controller's object
    static  Map<ID,Program__c> getProgramMap(CenterAssignmentController extension)
    {
         Map<ID,Program__c> programMap = new Map<Id,Program__c>();
         for(CenterAssignmentController.ProgramWrapperCls progWrapperObj : extension.lstProgramWrapper) 
        {
            programMap.put(progWrapperObj.cProgram.Id,progWrapperObj.cProgram);
        }
        return programMap;
    } 
    
     //function returns a map of programId and Content_Link__c object by taking Controller's object
    static Map<ID, Program_Link__c> getContentLinkMap(CenterAssignmentController extension)
    {
         Map<ID, Program_Link__c> contentLinkMap = new Map<Id, Program_Link__c>();
         for(CenterAssignmentController.ContentLinkWrapperCls contentWrapperObj : extension.lstContentLinkWrapperCls) 
         {
            contentLinkMap.put(contentWrapperObj.ContentLink.Program__c,contentWrapperObj.ContentLink);
         }
          
          return contentLinkMap;
    }
    
}