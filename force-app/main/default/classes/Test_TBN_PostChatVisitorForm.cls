@isTest(SeeAllData=true)

private class Test_TBN_PostChatVisitorForm {

	private static testMethod void PostChatVisitorForm(){
        apexpages.currentpage().getparameters().put('disconnectedBy' , 'agentsUnavailable');
        TBN_PostChatVisitorFormController objPostChatVisitor = new TBN_PostChatVisitorFormController();     
        objPostChatVisitor.fetchPresences();
    	}
	
	private static testMethod void PostChatVisitorForm1(){
        apexpages.currentpage().getparameters().put('disconnectedBy' , 'agent');
        TBN_PostChatVisitorFormController objPostChatVisitor = new TBN_PostChatVisitorFormController();     
        objPostChatVisitor.fetchPresences();
    	}
}