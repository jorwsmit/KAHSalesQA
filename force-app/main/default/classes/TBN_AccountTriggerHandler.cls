public with sharing class TBN_AccountTriggerHandler {
    
    TBN_EmailNotificationonRecordMerge handler = new TBN_EmailNotificationonRecordMerge();
    
    ID kahAcc = AA_UtilityClass.getKAHAccountID;
    
    //Constructor
    public TBN_AccountTriggerHandler(){
        
    }
    
    public class CustomException extends Exception {}
    
    /**
    @MethodName : onBeforeDelete
    @Param      : map<id,Account>MapOldAccounts
    @Description: Method is called on before delete of Account record, which will delete the account metric records in case of merge.
    **/
    public void onBeforeDelete(map<id,Account>MapOldAccounts){
        
        checkDeletePermissions(MapOldAccounts);
        delete[select id from Sales_Account_Metrics__c where Account__c IN: MapOldAccounts.keyset()];
    }
    
    /**
    @MethodName : checkDeletePermissions
    @Param      : map<id,Account> MapOldAccounts
    @Description: Method is called on before delete of Account record, which will check if the user has can delete that record, if not it will throw an error message.
    **/
    public void checkDeletePermissions(map<id,Account> MapOldAccounts){
        
        Set<String> setRestrictDeletionNames = new Set<String>();
        Set<String> setRestrictedRecordTypes = new Set<String>();
        
        for(Restrict_Deletion__c objRestrictDel : Restrict_Deletion__c.getAll().values()){
            
            setRestrictDeletionNames.add( objRestrictDel.Name.substring(0, 14) );
            if(objRestrictDel.Account_RT__c.contains(';')){
                    
                for( String accRt : objRestrictDel.Account_RT__c.split(';') ) 
                    setRestrictedRecordTypes.add( accRt.trim().substring(0, 14) );
            }
            else 
                setRestrictedRecordTypes.add( objRestrictDel.Account_RT__c.substring(0, 14) );
            
        }
        if(setRestrictDeletionNames.contains(((String)userinfo.getProfileId()).substring(0, 14))){
            
            for(Account objAccount : MapOldAccounts.values()){
                
                if(objAccount.Deletion_Restriction_Flag__c == TRUE  && setRestrictedRecordTypes.contains(((String)objAccount.RecordTypeId).substring(0, 14))){
                    
                    objAccount.addError(new CustomException('This record is currently not available for deletion. Please contact your Salesforce.com Administrator for more information.'), false);
                }
            }
        }
    }
    /** 
    @MethodName : onAfterDelete
    @Param      : map<id,Account>MapOldAccounts
    @Description: Method is called on delete of Account record, which will create custom object 'Deleted_Record__c' record.
    **/
    public void onAfterDelete(map<id,Account>MapOldAccounts){
        
        try{
            list<Account> accToUpdate = new list<Account>();
            set<ID> ids = new set<ID>();
            map<id, Account> mapAccounts = new map<id, Account>(); 
            list<Deleted_Record__c>lstDeletedRecords = new list<Deleted_Record__c>();
            
            // Iterates over the deleted Accounts to store Account Id and MasterRecordId in a map.
            for(Account objAccount : [select id, MasterRecordId, OwnerId
                                        from Account 
                                        where id IN: MapOldAccounts.keyset() AND MasterRecordId != null ALL ROWS]){
                ids.add(objAccount.MasterRecordID);
                mapAccounts.put(objAccount.Id, objAccount );
            }
            
            // Creates Deleted_Record__c for the deleted Account with status as new. If the Account is merged then will update Merged_Record_Id__c of Deleted_Record__c with MasterId of deleted Account.
            for(Id objAccountId :MapOldAccounts.keyset()){
                if(MapOldAccounts.get(objAccountId).RecordTypeId == kahAcc){
                	
                Deleted_Record__c objDeletedRecord = new Deleted_Record__c(Deleted_Record_Id__c = objAccountId, Time_of_Deletion__c = system.now(),Type_of_Records__c = 'Account',
                                                                            Status__c = 'New');
                system.debug('Deleted Record Created: ' + objDeletedRecord);
                if(mapAccounts.containsKey(objAccountId))
                    objDeletedRecord.Merged_Record_Id__c = mapAccounts.get(objAccountId).MasterRecordId;
                
                lstDeletedRecords.add(objDeletedRecord);
                }
                else{
                	system.debug('No Deleted Record Created record type is: ' + MapOldAccounts.get(objAccountId).RecordTypeId);
                	}    
            }
            
            if(!lstDeletedRecords.isEmpty())
                insert lstDeletedRecords; 
            
            //Calls the method to send Email notification       
            handler.sendEmailNotification(mapAccounts, 'Account');
            if(ids.size() > 0){
            	for(Account a: [SELECT ID, Merge_Master__c, Merge_Approved__c FROM Account WHERE ID IN: ids AND Merge_Master__c = true]){
            		a.Merge_Master__c = false;
            		a.Merge_Approved__c = false;
            		accToUpdate.add(a);
            		}
            		update accToUpdate;
            	}
        }
        catch(Exception e){
            
            system.debug('--------line----'+e.getLineNumber());
        } 
    }
    
}