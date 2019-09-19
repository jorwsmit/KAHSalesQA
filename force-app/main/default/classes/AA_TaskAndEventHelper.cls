public class AA_TaskAndEventHelper{
    
    public static void updateAccountsEvent(map<ID, Event> accLst){
    	list<ID> ids = new List<ID>();
    	list<Account> accUpd = new list <Account>();
    	set<Account> accSet = new set<Account>();
    	try{
    		for(Id i : accLst.keySet()){
    			ids.add(i);
    			}
            system.debug('IDs: ' + ids);
    		accUpd = [SELECT ID, PF_Last_Activity_Date__c, RecordTypeID FROM Account WHERE ID IN: ids];
    		for(Id recordId : accLst.keySet()){
    			Event e = accLst.get(recordId);
    			for(Account a : accUpd){
    				if(a.ID == recordID){
    					a.PF_Last_Activity_Date__c = e.ActivityDate;
    					a.Last_Activity_Type__c = e.Type;
    					accSet.add(a);
    					}
    				}
				}
			if(accSet.size() > 0){	
    			list<Account> accChg = new list<Account>();
    			accChg.addAll(accUpd);
    			update accChg;
				}
    		}
    	catch(exception e){
    		system.debug('Line: ' + e.getLineNumber());
            system.debug('Message: ' + e.getMessage());
            system.debug('Not triggered by an Event or Task on an Account');
    		}		
     	}
    
    public static void updateAccountsTask(map<ID, Task> accLst){
    	list<ID> ids = new List<ID>();
    	list<Account> accUpd = new list <Account>();
    	set<Account> accSet = new set<Account>();
    	try{
    		for(Id i : accLst.keySet()){
    			ids.add(i);
    			}
            system.debug('IDs: ' + ids);
    		accUpd = [SELECT ID, PF_Last_Activity_Date__c, RecordTypeID FROM Account WHERE ID IN: ids];
    		for(Id recordId : accLst.keySet()){
    			Task e = accLst.get(recordId);
    			for(Account a : accUpd){
    				if(a.ID == recordID){
    					a.PF_Last_Activity_Date__c = e.ActivityDate;
    					a.Last_Activity_Type__c = e.Type;
    					accSet.add(a);
    					}
    				}
				}
			if(accSet.size() > 0){	
    			list<Account> accChg = new list<Account>();
    			accChg.addAll(accUpd);
    			update accChg;
				}
    		}
    	catch(exception e){
    		system.debug('Line: ' + e.getLineNumber());
            system.debug('Message: ' + e.getMessage());
            system.debug('Not triggered by an Event or Task on an Account');
    		}		
     	} 	
    
}