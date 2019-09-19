global class Sales_AssignmentSnapshot implements Database.Batchable<sObject>{
	final static ID assocID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
	final static ID manaID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Market Manager'].ID;
    global string query = 'select Id from user where isActive=true and (profile.ID=:assocID or profile.ID=:manaID)';
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }//end start
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        
        List<Id> userIds = new List<Id>();
        for(sObject s : scope){
            User u = (User)s;
            userIds.add(u.Id);
        }
        
        Map<String, Referral_Source_Audit__c> yesterdayAssignmentATM = new Map<String, Referral_Source_Audit__c>();
        for(Referral_Source_Audit__c rsa : [select account__c, user__c, status__c from Referral_Source_Audit__c where request_date__c = yesterday and user__c in :userIds and account__c!=null]){
            yesterdayAssignmentATM.put(String.valueOf(rsa.user__c) + String.valueOf(rsa.account__c), rsa);
        }
        
        List<Referral_Source_Audit__c> assignmentsToInsert = new List<Referral_Source_Audit__c>();
        List<Referral_Source_Audit__c> assignmentsToRemove = new List<Referral_Source_Audit__c>();
        for(AccountTeamMember atm : [select accountId, userId from accountTeamMember where userId in :userIds]){
            if(yesterdayAssignmentATM.containsKey(String.valueOf(atm.userId) + String.valueOf(atm.accountId))){
                Referral_Source_Audit__c rsa = yesterdayAssignmentATM.remove(String.valueOf(atm.userId) + String.valueOf(atm.accountId));
                
                if(rsa.Status__c == 'Added'){
                    assignmentsToInsert.add(new Referral_Source_Audit__c(account__c = rsa.Account__c, user__c = rsa.User__c, status__c = 'Remaining',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
                } else if(rsa.Status__c == 'Remaining'){
                    assignmentsToRemove.add(rsa);
                    assignmentsToInsert.add(new Referral_Source_Audit__c(account__c = rsa.Account__c, user__c = rsa.User__c, status__c = 'Remaining',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
                } else if(rsa.Status__c == 'Deleted'){
                    assignmentsToInsert.add(new Referral_Source_Audit__c(account__c = rsa.Account__c, user__c = rsa.User__c, status__c = 'Added',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
                }
            } else {
                assignmentsToInsert.add(new Referral_Source_Audit__c(account__c = atm.AccountId, user__c = atm.UserId, status__c = 'Added',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
            }
        }
        
        Map<String, Referral_Source_Audit__c> yesterdayAssignmentCT = new Map<String, Referral_Source_Audit__c>();
        for(Referral_Source_Audit__c rsa : [select contact__c, user__c, status__c from Referral_Source_Audit__c where request_date__c = yesterday and user__c in :userIds and contact__c!=null]){
            yesterdayAssignmentCT.put(String.valueOf(rsa.user__c) + String.valueOf(rsa.contact__c), rsa);
        }
        
        for(Contact_Team__c ct : [select contact__c, user__c from Contact_Team__c where user__c in :userIds]){
            if(yesterdayAssignmentCT.containsKey(String.valueOf(ct.user__c) + String.valueOf(ct.contact__c))){
                Referral_Source_Audit__c rsa = yesterdayAssignmentCT.remove(String.valueOf(ct.user__c) + String.valueOf(ct.contact__c));
                
                if(rsa.Status__c == 'Added'){
                    assignmentsToInsert.add(new Referral_Source_Audit__c(contact__c = rsa.contact__c, user__c = rsa.user__c, status__c = 'Remaining',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
                } else if(rsa.Status__c == 'Remaining'){
                    assignmentsToRemove.add(rsa);
                    assignmentsToInsert.add(new Referral_Source_Audit__c(contact__c = rsa.contact__c, user__c = rsa.user__c, status__c = 'Remaining',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
                } else if(rsa.Status__c == 'Deleted'){
                    assignmentsToInsert.add(new Referral_Source_Audit__c(contact__c = rsa.contact__c, user__c = rsa.User__c, status__c = 'Added',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
                }
            } else {
                assignmentsToInsert.add(new Referral_Source_Audit__c(contact__c = ct.contact__c, user__c = ct.user__c, status__c = 'Added',
                                                                           request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day())));
            }
        }
        
        List<Referral_Source_Audit__c> DeletedAssignmentsToUpdate = new List<Referral_Source_Audit__c>();
        for(Referral_Source_Audit__c rsa : yesterdayAssignmentATM.values()){
            if(rsa.Status__c != 'Deleted'){
                rsa.Status__c = 'Deleted';
                rsa.request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day());
                DeletedAssignmentsToUpdate.add(rsa);
            }
        }
        
        for(Referral_Source_Audit__c rsa : yesterdayAssignmentCT.values()){
            if(rsa.Status__c != 'Deleted'){
                rsa.Status__c = 'Deleted';
                rsa.request_date__c = Date.newInstance(System.today().year(), System.today().month(), System.today().day());
                DeletedAssignmentsToUpdate.add(rsa);
            }
        }
       
        insert assignmentsToInsert;
        update DeletedAssignmentsToUpdate;
        if(assignmentsToRemove.size() <= 8999){
        	delete assignmentsToRemove;
        	}
        else{
        	list<Referral_Source_Audit__c> overflowList = new list<Referral_Source_Audit__c>();
        	for(integer i = 9000; i < assignmentsToRemove.size(); i++){
        		overFlowList.add(assignmentsToRemove[i]);
        		assignmentsToRemove.remove(i);
        		}
        		delete assignmentsToRemove;
        		delete overFlowList;
        	}	
    }//end exectue
    
    global void finish(Database.BatchableContext bc) {
        
    }//end finish
    
}