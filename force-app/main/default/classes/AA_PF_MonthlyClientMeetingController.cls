public with sharing class AA_PF_MonthlyClientMeetingController {
    
    @AuraEnabled
    public static string getInfo(){
        string userTitle;
        Id userId = UserInfo.getUserId();
        user u = [SELECT Name, Title FROM User WHERE ID =: userID];
        
        userTitle = u.Title + ' ' + u.Name;
        return userTitle;
    	}
    
    /*@AuraEnabled
    public static list<string> getAccounts(string accSearch){
        system.debug('accSearch: ' + accSearch);
        string query;
        if(accSearch != null && accSearch != '--None--'){
            string val = '\'%' + String.escapeSingleQuotes(accSearch.trim()) + '%\'';
        	query = 'SELECT ID, Name FROM Account WHERE Name LIKE ' + val + 'LIMIT 1000';
        	}
        else{
        	query = 'SELECT ID, Name FROM Account LIMIT 1000';
        	}
        list<string> options = new list<string>();
        	options.add('--None--');
        for(Account a : database.query(query)){
            options.add(a.Name + '-' + a.ID);
        	}
        options.sort();
        system.debug('Options: ' + options);
        return options;
    	}*/
    
    @AuraEnabled
    public static Account populateAccount(Id accID){
        Account acc = new Account();
        
        	acc = [SELECT ID, Name, PF_Smart_ID__c, PF_SAP_ID__c FROM Account WHERE ID =: accID];
    		system.debug('Account: ' + acc);
    		
        return acc;
    	}
    
    @AuraEnabled
    public static string saveForm(string repNameTitle, string facID, string cAttendees, string rhbAttendees, boolean reportPresented, string meetDate, string mClReport, string disc1, string concl1, string action1, string dueD1, string disc2, string concl2, string action2, string dueD2, string disc3, string concl3, string action3, string dueD3, boolean cliCon, string cliConSpec, boolean nonImed, string specif2, string specificGJ, string comments){
        try{
        	system.debug('repNameTitle: ' + repNameTitle);
        	system.debug('facID: ' + facID);
       	 	system.debug('cAttendees: ' + cAttendees);
        	system.debug('rhbAttendees: ' + rhbAttendees);
        	system.debug('reportPresented: ' + reportPresented);
        	system.debug('meetDate: ' + meetDate);
        	system.debug('mClReport: ' + mClReport);
        	system.debug('disc1: ' + disc1);
        	system.debug('concl1: ' + concl1);
        	system.debug('action1: ' + action1);
        	system.debug('dueD1: ' + dueD1);
        	system.debug('disc2: ' + disc2);
        	system.debug('concl2: ' + concl2);
        	system.debug('action2: ' + action2);
        	system.debug('dueD2: ' + dueD2);
        	system.debug('disc3: ' + disc3);
        	system.debug('concl3: ' + concl3);
        	system.debug('action3: ' + action3);
        	system.debug('dueD3: ' + dueD3);
        	system.debug('cliCon: ' + cliCon);
        	system.debug('cliConSpec: ' + cliConSpec);
        	system.debug('nonImed: ' + nonImed);
        	system.debug('specif2: ' + specif2);
        	system.debug('specificGJ: ' + specificGJ);
        	system.debug('comments: ' + comments);
        
        	string suc = JSON.serialize('Report Submitted.');
    		return suc;
        	}
        catch(Exception E){
            string error = e.getMessage() + ' Line:' + e.getLineNumber();
            return error;
        	}
    	}
    
}