@isTest
private class TBN_TestLiveChatTranscriptHandler {
    
    @testSetup public static void methodName() {
    
        //create a Live Chat Visitor
		LiveChatVisitor objvisitor = new LiveChatVisitor();
		insert objvisitor;
		update objvisitor; 
		
		//create Case records
		list<Case> lstCase = new list<Case>();
		Case objCase = new Case(Subject = 'testcase1');
        lstCase.add(objCase);
        
        Case objCase1 = new Case(Subject = 'testcase2');
        lstCase.add(objCase1);
        
        Case objCase2 = new Case(Subject = 'testcase3');
        lstCase.add(objCase2);
        
        Case objCase3 = new Case(Subject = 'testcase4');
        lstCase.add(objCase3);
        
        Case objCase4 = new Case(Subject = 'testcase5');
        lstCase.add(objCase4);
        
        Case objCase5= new Case(Subject = 'testcase6');
        lstCase.add(objCase5);
        
        Case objCase6 = new Case(Subject = 'testcase7');
        lstCase.add(objCase6);
        
        Case objCase7 = new Case(Subject = 'testcase8');
        lstCase.add(objCase7);
        
        insert lstCase;
        
        //create Attachment record
        Attachment objAttach=new Attachment();    
        objAttach.parentId=objCase.id;
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        objAttach.body=bodyBlob1;
        objAttach.Name='Unit Test Attachment';
        insert objAttach;
        
        Attachment objAttachment=new Attachment();    
        objAttachment.parentId=objCase3.id;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        objAttachment.body=bodyBlob;
        objAttachment.Name='Unit Test Attachment';
        insert objAttachment;
        
        
        Attachment objAttachment2=new Attachment();    
        objAttachment2.parentId=objCase5.id;
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        objAttachment2.body=bodyBlob2;
        objAttachment2.Name='Unit Test Attachment';
        insert objAttachment2;
        
        Attachment objAttachment3=new Attachment();    
        objAttachment3.parentId=objCase6.id;
        Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body');
        objAttachment3.body=bodyBlob3;
        objAttachment3.Name='Unit Test Attachment';
        insert objAttachment3;
        
		//create Live Chat Transcripts records
		LiveChatTranscript objTrans = new LiveChatTranscript(
															LiveChatVisitorId = objvisitor.Id,
															Email__c = 'test@test.com',
															First_Name__c = 'TestFirstName',
															Last_Name__c = 'TestLastName');
		insert objTrans;
		
		LiveChatTranscript objTrans1 = new LiveChatTranscript(
															LiveChatVisitorId = objvisitor.Id,
															Email__c = 'test1@test.com',
															First_Name__c = 'TestFirstName1',
															Last_Name__c = 'TestLastName1' , New_Case_Id__c = objCase3.Id);
		insert objTrans1;
		
		LiveChatTranscript objTrans2 = new LiveChatTranscript(
															LiveChatVisitorId = objvisitor.Id,
															Email__c = 'test2@test.com',
															First_Name__c = 'TestFirstName1',
															Last_Name__c = 'TestLastName1', New_Case_Id__c = objCase4.Id );
		insert objTrans2;
		
		LiveChatTranscript objTrans3 = new LiveChatTranscript(
															LiveChatVisitorId = objvisitor.Id,
															Email__c = 'test3@test.com',
															CaseId = objCase3.Id,
															First_Name__c = 'TestFirstName1',
															Last_Name__c = 'TestLastName1', New_Case_Id__c = objCase5.Id );
		insert objTrans3;
		
		LiveChatTranscript objTrans4 = new LiveChatTranscript(
															LiveChatVisitorId = objvisitor.Id,
															Email__c = 'test4@test.com',
															First_Name__c = 'TestFirstName1',
															Last_Name__c = 'TestLastName1', New_Case_Id__c = objCase7.Id );
		insert objTrans4;
    }
    
	private static testMethod void LiveChatTranscript1() {
		
		list<LiveChatTranscript> lstLiveChatTranscripttoUpdate = new list<LiveChatTranscript>();
		Case objCase1 = [select id,Subject from Case where Subject =: 'testcase1'];
		//updates Live Chat Transcripts records 
        LiveChatTranscript objTrans2 = [select CaseId, Status from LiveChatTranscript where Email__c=:'test2@test.com' ];
        objTrans2.CaseId = objCase1.Id;
        objTrans2.Status = 'Completed';
        lstLiveChatTranscripttoUpdate.add(objTrans2);
       
       
        Case objCase7 = [select id,Subject from Case where Subject =: 'testcase8'];
        LiveChatTranscript objTrans1 = [select CaseId, Status from LiveChatTranscript where Email__c=:'test4@test.com' ];
        objTrans1.CaseId = objCase7.Id;
        objTrans1.Status = 'Missed';
        lstLiveChatTranscripttoUpdate.add(objTrans1);
        update lstLiveChatTranscripttoUpdate;

	}
	
	private static testMethod void LiveChatTranscript2() {
	    
	    Case objCase1 = [select id,Subject from Case where Subject =: 'testcase2'];
		//updates Live Chat Transcripts records 
        LiveChatTranscript objTrans2 = [select CaseId, Status from LiveChatTranscript where Email__c=:'test@test.com' ];
        objTrans2.CaseId = objCase1.Id;
        objTrans2.Status = 'Completed';
        update objTrans2;
	}
	
	private static testMethod void LiveChatTranscript3() {
	    
	    Case objCase7 = [select id,Subject from Case where Subject =: 'testcase4'];
	    LiveChatTranscript objTrans2 = [select CaseId, Status, New_Case_Id__c from LiveChatTranscript where Email__c=:'test3@test.com' ];
	  //  objTrans2.CaseId = objCase7.Id;
        objTrans2.Status = 'Completed'; 
        
        update objTrans2;
	    
	}

}