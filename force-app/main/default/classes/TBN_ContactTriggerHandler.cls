public with sharing class TBN_ContactTriggerHandler {
    
    TBN_EmailNotificationonRecordMerge handler = new TBN_EmailNotificationonRecordMerge();
    
    ID kahCtc = AA_UtilityClass.getKAHContactID;
    
    //Constructor
    public TBN_ContactTriggerHandler()
    { 
        
    }
    
    public class CustomException extends Exception {}
    
    /**
    @MethodName : onBeforeDelete
    @Param      : map<id,Account>MapOldAccounts
    @Description: Method is called on before delete of Contact record, which will delete the Contact metric records in case of merge. And Updates the Previous_ContactId__c
                  field in Contact_Team__c whose Contact is deleted.
    **/
    public void onBeforeDelete(map<id,Contact>MapOldContacts){
        
        try{
            checkDeletePermissions(MapOldContacts);
            delete [select id from Sales_Contact_Metrics__c where Contact__c IN: MapOldContacts.keyset()];
            list<Contact_Team__c>lstContactTeamToUpdate = new list<Contact_Team__c>();
            
            //Iterates over the Contact Team whose Contact is delete.
            for(Contact_Team__c objContactTeam : [select id, Contact__c, Previous_ContactId__c from Contact_Team__c where Contact__c IN: MapOldContacts.keyset()]){
                
                objContactTeam.Previous_ContactId__c = objContactTeam.Contact__c;
                lstContactTeamToUpdate.add(objContactTeam);
            }
            if(!lstContactTeamToUpdate.isEmpty())
                update lstContactTeamToUpdate;
        }
        
        catch (Exception Ex){
            system.debug('--------line----'+Ex.getLineNumber());
        }
    }
    
    /**
    @MethodName : checkDeletePermissions
    @Param      : map<id,Contact>MapOldContacts
    @Description: Method is called on before delete of Contact record, which will check if the user has can delete that record, if not it will throw an error message.
    **/
    public void checkDeletePermissions(map<id,Contact>MapOldContacts){
        
        Set<String> setRestrictDeletionNames = new Set<String>();
        Set<String> setRestrictedRecordTypes = new Set<String>();
        
        for(Restrict_Deletion__c objRestrictDel : Restrict_Deletion__c.getAll().values()){
            
            setRestrictDeletionNames.add(objRestrictDel.Name.substring(0, 14));
            
            if(objRestrictDel.Contact_RT__c.contains(';')) {
                
                for( String conRt : objRestrictDel.Contact_RT__c.split(';') )
                    setRestrictedRecordTypes.add( conRt.trim().substring(0, 14) );
            }
            else 
                setRestrictedRecordTypes.add( objRestrictDel.Contact_RT__c.substring(0, 14) );
        }
        
        if(setRestrictDeletionNames.contains(((String)userinfo.getProfileId()).substring(0, 14))) {
            
            for(Contact objContact : MapOldContacts.values()) {
            
                if(objContact.Deletion_Restriction_Flag__c && setRestrictedRecordTypes.contains(((String)objContact.RecordTypeId).substring(0, 14))){
                    
                    objContact.addError(new CustomException('This record is currently not available for deletion. Please contact your Salesforce.com Administrator for more information.'), false);
                }
            }
        }
    }
    
    /**
    @MethodName : onAfterDelete
    @Param      : map<id,Contact>MapOldContacts
    @Description: Method is called on delete of Contact record, which will create custom object 'Deleted_Record__c' record.
    **/
    public void onAfterDelete(map<id,Contact>MapOldContacts){
        
        try{
            set<ID> ids = new set<ID>();
            //set to store string which has concatinated value of contact and user id
            set<string> setStrContactUser = new set<string>();
            set<id> setContactId = new set<Id>();
            map<id, Contact> mapContacts = new map<id, Contact>(); 
            list<Deleted_Record__c> lstDeletedRecords = new list<Deleted_Record__c>();
            //list to store duplicate contact team records that has to be deleted
            list<Contact_Team__c> lstContactTeamtoDelete = new list<Contact_Team__c>();
            
            //Iterates over the deleted Contacts to store Contact Id and MasterRecordId in a map.
            for(Contact objContact : [  select id, MasterRecordId, OwnerId
                                        from Contact 
                                        where id IN: MapOldContacts.keyset() AND 
                                                MasterRecordId != null ALL ROWS]){
                mapContacts.put(objContact.Id, objContact );
                setContactId.add(objContact.MasterRecordId);
                ids.add(objContact.MasterRecordID);
            }
            
            //Creates Deleted_Record__c for the deleted Contact with status as new. If the contact is merged then will update Merged_Record_Id__c of Deleted_Record__c with MasterId of deleted contact.
            for(Id objContactId :MapOldContacts.keyset()){
                if(MapOldContacts.get(objContactId).RecordTypeId == kahCtc){
                	Deleted_Record__c objDeletedRecord = new Deleted_Record__c( Deleted_Record_Id__c = objContactId, 
                    	                                                        Time_of_Deletion__c = system.now(),
                        	                                                    Type_of_Records__c = 'Contact',
                            	                                                Status__c = 'New');
                	system.debug('Contract Deleted Record Created: ' + objDeletedRecord);                                                       
                if(mapContacts.containsKey(objContactId)) {
                
                    objDeletedRecord.Merged_Record_Id__c = mapContacts.get(objContactId).MasterRecordId;
                }
                
                lstDeletedRecords.add(objDeletedRecord);
                }
            else{
                system.debug('No Deleted Record Created record type is: ' + MapOldContacts.get(objContactId).RecordTypeId);	
                }    
            }
            
            //Iterates over Contact_Team to create set of its corresponding Contact__c+User__c
            for(Contact_Team__c objContactTeam : [select id, Previous_ContactId__c, Contact__c, User__c 
                                                    from Contact_Team__c
                                                    where Contact__c IN: setContactId AND Previous_ContactId__c NOT IN: MapOldContacts.keyset()]){
                
                string strContactUser = objContactTeam.Contact__c +''+ objContactTeam.User__c;
                setStrContactUser.add(strContactUser);                                        
            } 
            
            //Iterates over Contact_Team to check if there are any Contact_Team with same Contact__c+User__c combination, if it is present, it will delete existing one.
            for(Contact_Team__c objContactTeam : [select id, Previous_ContactId__c, Contact__c, User__c 
                                                    from Contact_Team__c
                                                    where Previous_ContactId__c IN:MapOldContacts.keyset()]){
                                                         
                string strContactUser = objContactTeam.Contact__c +''+ objContactTeam.User__c;
                if(setStrContactUser.contains(strContactUser)){
                    
                    lstContactTeamtoDelete.add(objContactTeam);
                }
                else{
                    setStrContactUser.add(strContactUser);
                }
                
            }
            
            if(!lstDeletedRecords.isEmpty()){
                insert lstDeletedRecords;
            	}
            	
            if(!lstContactTeamtoDelete.isEmpty()){
                delete lstContactTeamtoDelete;
            	}
            //Calls the method to send Email notification   
            handler.sendEmailNotification(mapContacts, 'Contact'); 
            if(ids.size() > 0){
            	AA_ContactTriggerHelper.processContacts(ids);
            	}  
        }
        catch(Exception Ex){
            
            system.debug('--------line----'+Ex.getLineNumber());
        }   
    }
}