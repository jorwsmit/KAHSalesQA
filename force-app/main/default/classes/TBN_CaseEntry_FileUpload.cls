public with sharing class TBN_CaseEntry_FileUpload {
	/*
	// Global variables
	public String success 			{	get; set;	} 
	public Attachment objAttachment {	get; set;	}
	

	// Constructor
	public TBN_CaseEntry_FileUpload() 
	{
		success = '';
		objAttachment = new Attachment();
		
		if(ApexPages.currentpage().getParameters().containsKey('Success'))	
			success = String.escapeSingleQuotes( ApexPages.currentpage().getParameters().get('Success') );
	}
	
	/* Start - Method for uploading file for chatter post.
	   @Name           - insertContent
	   @Parameters     - None 
	   @Return Type    - pagereference
	   @Description    - Function for uploading file
	
	public Pagereference insertContent() 
	{
		try 
		{
			Pagereference objPR;
			Case objCase = new Case(Subject = 'Test$$$Patient$$$$$'+UserInfo.getName());
			insert objCase;
			//Assessment__c objAssess = new Assessment__c(Patient__c = objPatient.Id);
			//insert objAssess; 
			//Id attachParent = [SELECT Id FROM Assessment__c WHERE Patient__c =: objPatient.Id limit 1].Id;
			
			objAttachment.ParentId = objCase.Id;
        			
            insert objAttachment;
            
			objPR = new Pagereference('/apex/TBN_CaseEntry_FileUpload?Success=true&docId=' + objAttachment.Id);
			objPR.setredirect(true);
			
			objAttachment = new Attachment();
			objCase = new Case();
            return objPR; 
		}
		catch(Exception e)
		{
			system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			objAttachment = new Attachment();
			Pagereference objPR = new Pagereference('/apex/TBN_CaseEntry_FileUpload?Success=false');
			objPR.setredirect(true);
			return objPR;
		}
	}
	/* End - insertContent method */
	
}