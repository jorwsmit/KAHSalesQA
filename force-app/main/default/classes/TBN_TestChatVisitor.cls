@isTest
private class TBN_TestChatVisitor {

	private static testMethod void TestChatVisitor() {
        
        list<Live_Agent_Ids__c>lstLiveAgenttoinsert = new list<Live_Agent_Ids__c>();
      
        Live_Agent_Ids__c objLiveAgent = new Live_Agent_Ids__c(Name = 'DeploymentId', Value__c = 'test');
        lstLiveAgenttoinsert.add(objLiveAgent);
        Live_Agent_Ids__c objLiveAgent1 = new Live_Agent_Ids__c(Name = 'OrgId', Value__c = 'test');
        lstLiveAgenttoinsert.add(objLiveAgent1);
        Live_Agent_Ids__c objLiveAgent2 = new Live_Agent_Ids__c(Name = 'ButtonId', Value__c = 'test');
        lstLiveAgenttoinsert.add(objLiveAgent2);
        Live_Agent_Ids__c objLiveAgent3 = new Live_Agent_Ids__c(Name = 'LAResourceDomain', Value__c = 'test');
        lstLiveAgenttoinsert.add(objLiveAgent3);
        Live_Agent_Ids__c objLiveAgent4 = new Live_Agent_Ids__c(Name = 'LAChatDomain', Value__c = 'test');
        lstLiveAgenttoinsert.add(objLiveAgent4);
        Live_Agent_Ids__c objLiveAgent5 = new Live_Agent_Ids__c(Name = 'RedirectURL', Value__c = 'test.com');
        lstLiveAgenttoinsert.add(objLiveAgent5);
        
        insert lstLiveAgenttoinsert;
        
        TBN_ChatVisitorController objChatVisitor = new TBN_ChatVisitorController();
        
       /* BusinessHours stdBusinessHours = [select id, FridayEndTime, FridayStartTime, MondayEndTime, MondayStartTime, 
                                                        SaturdayEndTime, SaturdayStartTime, SundayEndTime, SundayStartTime, 
                                                        ThursdayEndTime, ThursdayStartTime, TuesdayEndTime, TuesdayStartTime, 
                                                        WednesdayEndTime, WednesdayStartTime  from BusinessHours where Name = 'Agent Chat Hours'];
        
        for(integer i=0; i<7;i++){
            
            objChatVisitor.dateForTestRun = DateTime.now().addDays(i);

            objChatVisitor.init();
        }*/
        objChatVisitor.checkForAgentsCapacity();
        TBN_ChatVisitorController.getIsAgentOnline();
	}
}