@isTest
private class AA_VisualChartControllerTest {

    private static testMethod void TestVisualChartController() {
	    AA_VisualChartController noArg = new AA_VisualChartController();
	    User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
	    System.runAs ( thisUser ) {
            UserRole objUserRole = [select id from UserRole where Name =:'DVP - Black' Limit 1];
            User objUser = new User(
    								FirstName = 'testFirst',
    								LastName = 'TestUser' + String.valueOf(Date.today()), 
    								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
    								Username = 'TestVisualChartController' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
    								timezonesidkey = 'America/Los_Angeles',
    								alias='newser', 
    								emailencodingkey = 'UTF-8',
    								ProfileId =  Userinfo.getProfileId(),
    								localesidkey = 'en_US', 
    								languagelocalekey = 'en_US', 
    								UserRoleid= objUserRole.id
    								);
    	    insert objUser;
            
            RecordType AccRecordType = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
            Account objAccount = new Account(Name = 'Test Account', recordTypeId = AccRecordType.Id, PF_Product_Type__c = 'SNFSAU');
            insert objAccount;
            AccountTeamMember objAccountTeamMember = new AccountTeamMember(UserId = objUser.id, AccountId = objAccount.Id);
            insert objAccountTeamMember;
            string selRole = 'DVP';
            string selRoleName = 'DVP - Black';
            string selReport = 'Accounts Without Activity';
            string SelDteFrom;
            string SelDteTo;
            string selIndividual;
            string sortField;
            boolean isAsc = false;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart.Name = '#00CCCC';
            insert objCustomSettingChart;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart1 = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart1.Name = '#66CC66';
            insert objCustomSettingChart1;

            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            selRole = 'National';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'accountName';
            isAsc = true;
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'ownerName';
            isAsc = false;
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'riskDate';
            isAsc = true;
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'activity';
            isAsc = true;
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'risk';
            isAsc = true;
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'tier';
            isAsc = true;
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            selRole = 'ADO';
            selRoleName = 'Individual';
            selIndividual = 'Joana Jefferies';
            selReport = 'Accounts Without Activity';
            SelDteFrom = '1/1/2016';
            SelDteTo = '12/31/2017';
            sortField = 'tier';
            isAsc = true;
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'risk';
            /*selReport = 'PD Monthly Meeting';
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            */
            selReport = 'QBR Tracking';
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'activity';
            selReport = 'Risk Account (SNF Only)';
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'ownerName';
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'accountName';
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            sortField = 'riskDate';
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    }
	}
    
    private static testMethod void TestVisualChartController2() {
    	User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
	    System.runAs ( thisUser ) {
            UserRole objUserRole = [select id from UserRole where Name =:'DVP - Black' Limit 1];
            User objUser = new User(
    								FirstName = 'testFirst',
    								LastName = 'TestUser' + String.valueOf(Date.today()), 
    								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
    								Username = 'TestVisualChartController' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
    								timezonesidkey = 'America/Los_Angeles',
    								alias='newser', 
    								emailencodingkey = 'UTF-8',
    								ProfileId =  Userinfo.getProfileId(),
    								localesidkey = 'en_US', 
    								languagelocalekey = 'en_US', 
    								UserRoleid= objUserRole.id
    								);
    	    insert objUser;
            
            RecordType AccRecordType = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
            Account objAccount = new Account(Name = 'Test Account', recordTypeId = AccRecordType.Id, PF_Product_Type__c = 'SNFSAU');
            insert objAccount;
            AccountTeamMember objAccountTeamMember = new AccountTeamMember(UserId = objUser.id, AccountId = objAccount.Id);
            insert objAccountTeamMember;
            string selRole = 'DVP';
            string selRoleName = 'DVP - Black';
            string selReport = 'Accounts Without Activity';
            string SelDteFrom;
            string SelDteTo;
            string selIndividual;
            string sortField;
            boolean isAsc = false;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart.Name = '#00CCCC';
            insert objCustomSettingChart;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart1 = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart1.Name = '#66CC66';
            insert objCustomSettingChart1;
            
    		/*selReport = 'PD Monthly Meeting';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            */
            selReport = 'QBR Tracking';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            selReport = 'Risk Account (SNF Only)';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            selRole = 'National';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            selRole = 'DVP';
            selRoleName = 'DVP - Black';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            }
        }
    private static testMethod void testVisualCharts3(){
        	User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
	    System.runAs ( thisUser ) {
            UserRole objUserRole = [select id from UserRole where Name =:'DVP - Black' Limit 1];
            User objUser = new User(
    								FirstName = 'testFirst',
    								LastName = 'TestUser' + String.valueOf(Date.today()), 
    								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
    								Username = 'TestVisualChartController' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
    								timezonesidkey = 'America/Los_Angeles',
    								alias='newser', 
    								emailencodingkey = 'UTF-8',
    								ProfileId =  Userinfo.getProfileId(),
    								localesidkey = 'en_US', 
    								languagelocalekey = 'en_US', 
    								UserRoleid= objUserRole.id
    								);
    	    insert objUser;
            
            RecordType AccRecordType = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
            Account objAccount = new Account(Name = 'Test Account', recordTypeId = AccRecordType.Id, PF_Product_Type__c = 'SNFSAU');
            insert objAccount;
            AccountTeamMember objAccountTeamMember = new AccountTeamMember(UserId = objUser.id, AccountId = objAccount.Id);
            insert objAccountTeamMember;
            string selRole = 'DVP';
            string selRoleName = 'DVP - Black';
            string selReport = 'Accounts Without Activity';
            string SelDteFrom;
            string SelDteTo;
            string selIndividual;
            string sortField;
            boolean isAsc = false;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart.Name = '#00CCCC';
            insert objCustomSettingChart;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart1 = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart1.Name = '#66CC66';
            insert objCustomSettingChart1;
        	
        	selReport = 'QBR Tracking';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            selRole = 'National';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            /*selReport = 'PD Monthly Meeting';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
    		selRole = 'National';
            AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            AA_VisualChartController.sortTable(sortField, isAsc, selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
    		*/
    		selRole = 'DVP';
            selReport = 'Accounts Without Activity';
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
        }
    }
    
    private static testMethod void testVisualCharts4(){
        	User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
	    System.runAs ( thisUser ) {
            UserRole objUserRole = [select id from UserRole where Name =:'DVP - Black' Limit 1];
            User objUser = new User(
    								FirstName = 'testFirst',
    								LastName = 'TestUser' + String.valueOf(Date.today()), 
    								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
    								Username = 'TestVisualChartController' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
    								timezonesidkey = 'America/Los_Angeles',
    								alias='newser', 
    								emailencodingkey = 'UTF-8',
    								ProfileId =  Userinfo.getProfileId(),
    								localesidkey = 'en_US', 
    								languagelocalekey = 'en_US', 
    								UserRoleid= objUserRole.id
    								);
    	    insert objUser;
            
            RecordType AccRecordType = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
            Account objAccount = new Account(Name = 'Test Account', recordTypeId = AccRecordType.Id, PF_Product_Type__c = 'SNFSAU');
            insert objAccount;
            AccountTeamMember objAccountTeamMember = new AccountTeamMember(UserId = objUser.id, AccountId = objAccount.Id);
            insert objAccountTeamMember;
            string selRole = 'DVP';
            string selRoleName = 'DVP - Black';
            string selReport = 'Accounts Without Activity';
            string SelDteFrom;
            string SelDteTo;
            string selIndividual;
            string sortField;
            boolean isAsc = false;
            
            date plDte = date.newInstance(2016,1,1);
	    	date plDte2 = date.newInstance(2017,12,31);
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart.Name = '#00CCCC';
            insert objCustomSettingChart;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart1 = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart1.Name = '#66CC66';
            insert objCustomSettingChart1;
        	
        	selReport = 'QBR Tracking';
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = null;
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = null;
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            selRole = 'National';
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = null;
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = null;
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            
            /*selReport = 'PD Monthly Meeting';
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = null;
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = null;
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
    		selRole = 'National';
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = null;
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = null;
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            */
    		selRole = 'DVP';
            selReport = 'Accounts Without Activity';
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = null;
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = null;
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            selRole = 'National';
            selReport = 'Accounts Without Activity';
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = null;
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = null;
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            
            selRole = 'ADO';
            selRoleName = 'Individual';
            selIndividual = 'Joana Jefferies';
            selReport = 'Accounts Without Activity';
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = string.valueOf(plDte);
            SelDteTo = null;
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
            SelDteFrom = null;
            SelDteTo = string.valueOf(plDte2);
            AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
        }
    }
    
    private static testMethod void testVisualCharts5(){
    	User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
	    System.runAs(thisUser){
            UserRole objUserRole = [select id from UserRole where Name =:'DVP - Black' Limit 1];
            User objUser = new User(
    								FirstName = 'testFirst',
    								LastName = 'TestUser' + String.valueOf(Date.today()), 
    								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
    								Username = 'TestVisualChartController' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
    								timezonesidkey = 'America/Los_Angeles',
    								alias='newser', 
    								emailencodingkey = 'UTF-8',
    								ProfileId =  Userinfo.getProfileId(),
    								localesidkey = 'en_US', 
    								languagelocalekey = 'en_US', 
    								UserRoleid= objUserRole.id
    								);
    	    insert objUser;
            
            RecordType AccRecordType = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
            Account objAccount = new Account(Name = 'Test Account', recordTypeId = AccRecordType.Id, PF_Product_Type__c = 'SNFSAU');
            insert objAccount;
            AccountTeamMember objAccountTeamMember = new AccountTeamMember(UserId = objUser.id, AccountId = objAccount.Id);
            insert objAccountTeamMember;
            string selRole = 'DVP';
            string selRoleName = 'DVP - Black';
            string selReport = 'Accounts Without Activity';
            string SelDteFrom;
            string SelDteTo;
            string selIndividual;
            string sortStr;
            boolean isAsc = false;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart.Name = '#00CCCC';
            insert objCustomSettingChart;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart1 = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart1.Name = '#66CC66';
            insert objCustomSettingChart1;
	    	date plDte = date.newInstance(2016,1,1);
	    	date plDte2 = date.newInstance(2017,12,31);
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	selReport = 'Risk Account (SNF Only)';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	//AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	//AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	//AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	
	    	}
    	}

	private static testMethod void testVisualCharts6(){
	User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
	    System.runAs(thisUser){
            UserRole objUserRole = [select id from UserRole where Name =:'DVP - Black' Limit 1];
            User objUser = new User(
    								FirstName = 'testFirst',
    								LastName = 'TestUser' + String.valueOf(Date.today()), 
    								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
    								Username = 'TestVisualChartController' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
    								timezonesidkey = 'America/Los_Angeles',
    								alias='newser', 
    								emailencodingkey = 'UTF-8',
    								ProfileId =  Userinfo.getProfileId(),
    								localesidkey = 'en_US', 
    								languagelocalekey = 'en_US', 
    								UserRoleid= objUserRole.id
    								);
    	    insert objUser;
            
            RecordType AccRecordType = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
            Account objAccount = new Account(Name = 'Test Account', recordTypeId = AccRecordType.Id, PF_Product_Type__c = 'SNFSAU');
            insert objAccount;
            AccountTeamMember objAccountTeamMember = new AccountTeamMember(UserId = objUser.id, AccountId = objAccount.Id);
            insert objAccountTeamMember;
            string selRole = 'DVP';
            string selRoleName = 'DVP - Black';
            string selReport = 'Accounts Without Activity';
            string SelDteFrom;
            string SelDteTo;
            string selIndividual = '--None Selected--';
            string sortStr;
            boolean isAsc = false;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart.Name = '#00CCCC';
            insert objCustomSettingChart;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart1 = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart1.Name = '#66CC66';
            insert objCustomSettingChart1;
	    	date plDte = date.newInstance(2016,1,1);
	    	date plDte2 = date.newInstance(2017,12,31);
	    	
	    	/*selReport = 'PD Monthly Meeting';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	*/
	    	selRole = 'National';
	    	selReport = 'Risk Account (SNF Only)';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getTotalAccounts(selRole, selRoleName, selIndividual);
	    	
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	/*selReport = 'PD Monthly Meeting';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	*/
	    	selIndividual = '--None Selected--';
	    	selRole = 'DVP';
            selRoleName = 'DVP - Black';
	    	selReport = 'Accounts Without Activity';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getTotalAccounts(selRole, selRoleName, selIndividual);
	    	
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	
		}
	}
	
	private static testMethod void testVisualCharts7(){
	User thisUser = [ select Id,UserRoleId, FirstName from User where Id = :UserInfo.getUserId()];
	    System.runAs(thisUser){
            UserRole objUserRole = [select id from UserRole where Name =:'DVP - Black' Limit 1];
            User objUser = new User(
    								FirstName = 'testFirst',
    								LastName = 'TestUser' + String.valueOf(Date.today()), 
    								Email = 'TestUser' + String.valueOf(Date.today()) + '_' + '@gmail.com',
    								Username = 'TestVisualChartController' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
    								timezonesidkey = 'America/Los_Angeles',
    								alias='newser', 
    								emailencodingkey = 'UTF-8',
    								ProfileId =  Userinfo.getProfileId(),
    								localesidkey = 'en_US', 
    								languagelocalekey = 'en_US', 
    								UserRoleid= objUserRole.id
    								);
    	    insert objUser;
            
            RecordType AccRecordType = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PF_Chain' Limit 1];
            Account objAccount = new Account(Name = 'Test Account', recordTypeId = AccRecordType.Id, PF_Product_Type__c = 'SNFSAU');
            insert objAccount;
            AccountTeamMember objAccountTeamMember = new AccountTeamMember(UserId = objUser.id, AccountId = objAccount.Id);
            insert objAccountTeamMember;
            string selRole = 'ADO';
            string selRoleName = 'ADO - Black*';
            string selReport = 'Facility Reporting';
            string SelDteFrom;
            string SelDteTo;
            string selIndividual = '--None Selected--';
            string sortStr;
            boolean isAsc = false;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart.Name = '#00CCCC';
            insert objCustomSettingChart;
            
            Chart_Colors_for_Partner_Charts__c objCustomSettingChart1 = new Chart_Colors_for_Partner_Charts__c();
            objCustomSettingChart1.Name = '#66CC66';
            insert objCustomSettingChart1;
	    	date plDte = date.newInstance(2016,1,1);
	    	date plDte2 = date.newInstance(2017,12,31);
	    	
	    	selRole = 'National';
	    	selReport = 'Facility Reporting';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	selRole = 'COO';
	    	selReport = 'Facility Reporting';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	test.startTest();
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	
	    	selRole = 'ADO';
	    	selReport = 'ADO Activities';
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = null;
	    	
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = null;
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	
	    	SelDteFrom = string.valueOf(plDte);
	    	SelDteTo = string.valueOf(plDte2);
	    	AA_VisualChartController.getReportTable(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
	    	AA_VisualChartController.getReportVals(selRole, selRoleName, selReport, selIndividual, SelDteFrom, SelDteTo);
			test.stopTest();
		}
	}
}