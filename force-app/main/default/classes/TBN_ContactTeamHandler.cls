/**
@ClassName    : TBN_ContactTeamHandler
@CreatedOn    : 13/12/2015
@ModifiedBy   : Rashmi
@Description  : This is the controller for TBN_ContactTeam trigger,which will check for Contact Team with same Contact__c + User__c 
                  combination on insert and update. If present it will delete old one and insert new. Also, It will create ContactShare record on 
                  insert and update of Contact_Team__c and delete ContactShare record on Contact_Team__c delete.
**/
public without sharing class TBN_ContactTeamHandler {

    //constructor
    public TBN_ContactTeamHandler() {
    
        //do nothing
    }
    
    /**
    @MethodName : onBeforeInsert
    @Param      : map<id, Contact_Team__c> mapNewContactTeam
    @Description: Method is called on insert of new Contact_Team__c which will insert a new ContactShare record for the Contact_Team__c inserted.
    **/
    public void onBeforeInsert(list<Contact_Team__c> lstNewContactTeam){
        
        try{
            //list to store ContactShare to be inserted on insert of Contact_Team__c record.
            List<ContactShare> lstContactSharetoCreate = new List<ContactShare>();
            map<string, ContactShare> mapStringtoContactShare = new map<string, ContactShare>();
            //set to store contact id from Contact_Team
            set<id> setContactId = new set<Id>();
            //set to store User id from Contact_Team
            set<id> setUserIdId = new set<Id>();
            
            //Iterates over contact team to get contact and user id and store it in the set
            for(Contact_Team__c objContactTeam : lstNewContactTeam){
                
                setContactId.add(objContactTeam.Contact__c);
                setUserIdId.add(objContactTeam.User__c);
            }
            
            //Iterates over Contact share and if the record is found with contact and user id in set, the share record is added into the map
            for(ContactShare objContactShare : [Select Id,ContactAccessLevel, UserOrGroupId,ContactId
                                                From ContactShare
                                                where ContactId IN:setContactId AND UserOrGroupId IN: setUserIdId]){
                                                    
                if(objContactShare.ContactAccessLevel == 'Edit'  || objContactShare.ContactAccessLevel == 'All'){
                    
                    String strContactUser = objContactShare.ContactId + '_' + objContactShare.UserOrGroupId;
                    mapStringtoContactShare.put(strContactUser, objContactShare); 
                }
            }
            //Iterates over mapNewContactTeam and creates ContactShare record with contact access level as edit
            for(Contact_Team__c objContactTeam : lstNewContactTeam){
                
                String strContactUser = objContactTeam.Contact__c + '_' + objContactTeam.User__c;
                if(!mapStringtoContactShare.ContainsKey(strContactUser)){
                    
                    // create the new share for contact
                    ContactShare objContactShare = new ContactShare();
                    objContactShare.ContactAccessLevel = 'Edit';
                    objContactShare.ContactId = objContactTeam.Contact__c;
                    if(objContactTeam.User__c != null)
                        objContactShare.UserOrGroupId =  objContactTeam.User__c;
                    lstContactSharetoCreate.add(objContactShare);
                }
            }
            //inserts the list of ContactShare if list is not empty.
            if(!lstContactSharetoCreate.isEmpty())
                insert lstContactSharetoCreate; 
        }
        catch(Exception Ex){
            
            system.debug('--------line----'+Ex.getLineNumber());
        }
    }
    
    /**
    @MethodName : onAfterInsert
    @Param      : map<id, Contact_Team__c> mapNewContactTeam
    @Description: Method is called on insert of Contact_Team__c record, which will check for Contact Team with same Contact__c + User__c 
                  combination. If present it will delete old one and insert new. Also, it will insert a new ContactShare record for the Contact_Team__c inserted.
    **/
    public void onAfterInsert(map<id, Contact_Team__c> mapNewContactTeam){
        
        onInsertAndUpdateContactTeam(mapNewContactTeam); 
        
    } 
    
    /**
    @MethodName : onAfterUpdate
    @Param      : map<id, Contact_Team__c> mapNewContactTeam
    @Description: Method is called on update of Contact_Team__c record, which will check for Contact Team with same Contact__c + User__c 
                  combination. If present it will delete old one and insert new.
    **/
    public void onAfterUpdate(map<id, Contact_Team__c> mapNewContactTeam){
        
        onInsertAndUpdateContactTeam(mapNewContactTeam);
          
    }
    
    /**
    @MethodName : onBeforeUpdate
    @Param      : map<id, Contact_Team__c> mapNewContactTeam, map<id, Contact_Team__c> mapOldContactTeam
    @Description: Method is called on before update of Contact_Team__c record. If the user is updated, it will delete ContactShare corresponding to old user 
                    and inserts new contact share record for the updated user.
    **/
    public void onBeforeUpdate(map<id, Contact_Team__c> mapNewContactTeam, map<id, Contact_Team__c> mapOldContactTeam){
        
        try{ 
            set<Id> setUserId = new set<Id>();
            List<ContactShare> lstContactSharetoCreate = new List<ContactShare>();
            List<ContactShare> lstContactSharetoDelete = new List<ContactShare>();
            map<string,ContactShare> mapStringtoContactShare = new map<string,ContactShare>();
            
            set<id> setContactId = new set<Id>();
            //iterates over the map of old contact team to get old user id's
            for(Contact_Team__c objContactTeam : mapOldContactTeam.values()){
                setContactId.add(objContactTeam.Contact__c);   
                setUserId.add(objContactTeam.User__c);
            }
            
            //iterates over the ContactShare to check to get the ContactShare into the map.
            for(ContactShare objContactShare : [select id, UserOrGroupId, ContactId 
                                                    from ContactShare 
                                                    where UserOrGroupId IN: setUserId
                                                    AND ContactId IN:setContactId]){
                
                string str = objContactShare.UserOrGroupId+'-'+objContactShare.ContactId;
                mapStringtoContactShare.put(str, objContactShare);
            }
            //iterates over the map of new contact team if the user is updates, it will delete the ContactShare assiciated with old user and inserts one for the new user.
            for(Contact_Team__c objContactTeam : mapNewContactTeam.values()){
                
                if(objContactTeam.User__c != mapOldContactTeam.get(objContactTeam.Id).User__c){
                    
                    string str = mapOldContactTeam.get(objContactTeam.Id).User__c +'-'+objContactTeam.Contact__c;
                    ContactShare objContactSharetoDelete = mapStringtoContactShare.get(str);
                    lstContactSharetoDelete.add(objContactSharetoDelete);
                    
                    // create the new share for contact
                    ContactShare objContactSharetoInsert = new ContactShare();
                    objContactSharetoInsert.ContactAccessLevel = 'Edit';
                    objContactSharetoInsert.ContactId = objContactTeam.Contact__c;
                    objContactSharetoInsert.UserOrGroupId =  objContactTeam.User__c;
                    lstContactSharetoCreate.add(objContactSharetoInsert);
                } 
            }
            //deletes the list of ContactShare if list is not empty.
            if(!lstContactSharetoDelete.isEmpty())
                delete lstContactSharetoDelete;
              
            //inserts the list of ContactShare if list is not empty.    
            if(!lstContactSharetoCreate.isEmpty())
                insert lstContactSharetoCreate;  
        }
        catch(Exception Ex){
            
            system.debug('--------line----'+Ex.getLineNumber());
        }
    }
    /**
    @MethodName : onInsertAndUpdateContactTeam
    @Param      : map<id, Contact_Team__c> mapNewContactTeam
    @Description: Method is called from onAfterInsert and onAfterUpdate methods
    **/
    public void onInsertAndUpdateContactTeam(map<id, Contact_Team__c> mapNewContactTeam){
        
        try{
            //set to store string which has concatinated value of contact and user id
            set<string>setstrContactUser = new set<string>();
            //set to store contact and user id
            set<Id>setsObjectId = new set<Id>();
            //list to store duplicate contact team records that has to be deleted
            list<Contact_Team__c>lstContactTeamtoDelete = new list<Contact_Team__c>();
            
            //Iterates over Contact_Team to create set of its corresponding Contact__c+User__c
            for(Contact_Team__c objContactTeam : [select id, Contact__c, User__c 
                                                    from Contact_Team__c
                                                    where id IN: mapNewContactTeam.keyset()]){
                                                        
                setsObjectId.add(objContactTeam.Contact__c);     
                setsObjectId.add(objContactTeam.User__c);  
                string strContactUser = objContactTeam.Contact__c +''+ objContactTeam.User__c;
                setstrContactUser.add(strContactUser);
            }
            
            //Iterates over Contact_Team to check if there are any Contact_Team with same Contact__c+User__c combination, if it is present, it will delete existing one.
            for(Contact_Team__c objContactTeam: [select id, Contact__c, User__c 
                                                    from Contact_Team__c
                                                    where Contact__c IN: setsObjectId AND User__c IN: setsObjectId AND Id NOT IN: mapNewContactTeam.keyset()]){
                                                        
                string strContactUser = objContactTeam.Contact__c +''+ objContactTeam.User__c;
                
                if(setstrContactUser.contains(strContactUser)){
                    lstContactTeamtoDelete.add(objContactTeam);
                }
            }
            
            //deletes the list of ContactShare if list is not empty.
            if(!lstContactTeamtoDelete.isEmpty())
                delete lstContactTeamtoDelete;
        }
        catch(Exception Ex){
            
            system.debug('--------line----'+Ex.getLineNumber());
        }
    }
    
    /**
    @MethodName : onBeforeDelete
    @Param      : map<id, Contact_Team__c> mapOldContactTeam
    @Description: Method is called from onBeforeDelete method. If the contact team deleted is an account team of some account, 
                    contactShare record will not be deleted. else it will be deleted.
    **/
    public void onBeforeDelete(map<id, Contact_Team__c> mapOldContactTeam){
        
        try{
            set<Id> setUserId = new set<Id>();
            set<Id> setContactId = new set<Id>();
            set<id>setUserIdfromATM = new set<Id>();
            List<ContactShare> lstContactSharetoDelete = new List<ContactShare>();
            map<string,ContactShare> mapStringtoContactShare = new map<string,ContactShare>();
            
            //iterates over the map of old contact team to get old user id's
            for(Contact_Team__c objContactTeam : mapOldContactTeam.values()){
                setContactId.add(objContactTeam.Contact__c);
                setUserId.add(objContactTeam.User__c);
            }
            
            //iterates over the ContactShare to check to get the ContactShare into the map.
            for(ContactShare objContactShare : [select id, UserOrGroupId, ContactId 
                                                from ContactShare 
                                                where UserOrGroupId IN: setUserId
                                                AND ContactID IN: setContactId 
                                                AND RowCause != 'Owner']){
            
                string str = objContactShare.UserOrGroupId+'-'+objContactShare.ContactId;
                mapStringtoContactShare.put(str, objContactShare);
            }
            
            //iterates over Contact_Team__c and will delete ContactShare if there are no accountteam member for that user
            for(Contact_Team__c objContactTeam : mapOldContactTeam.values()){
            
                string str = objContactTeam.User__c +'-'+objContactTeam.Contact__c;
                ContactShare objContactSharetoDelete = mapStringtoContactShare.get(str);
                lstContactSharetoDelete.add(objContactSharetoDelete);
            }
            
            //deletes the list of ContactShare if list is not empty.
            if(!lstContactSharetoDelete.isEmpty())
                delete lstContactSharetoDelete; 
        }
        catch(Exception Ex){
            
            system.debug('--------line----'+Ex.getLineNumber());
        }
    }
}