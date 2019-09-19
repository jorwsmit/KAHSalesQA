trigger AA_ContactTrigger on Contact (after delete, after insert, after update, before delete, before insert, before update) {

  TBN_ContactTriggerHandler handler = new TBN_ContactTriggerHandler();
  TBN_UpdateDMAOnAccountAndContactHandler handleDMA = new TBN_UpdateDMAOnAccountAndContactHandler();
  
  list<ID> krsProfiles = AA_UtilityClass.getKRSProfiles;
  list<ID> krsNonAdmins = AA_UtilityClass.getNonKRSAdmins;
  
  ID krsContact = AA_UtilityClass.getkrsContact;
  ID indvCtc = AA_UtilityClass.getindvCtc;
  ID krsEvent = AA_UtilityClass.getkrsEvent;
  ID houseAcc = AA_UtilityClass.gethouseAcc;
  ID tempContact = AA_UtilityClass.gettempContact;
  ID hdPhysicianContact = AA_UtilityClass.getHDPhysicianID;
  ID sysAdminID = AA_UtilityClass.getSysAdminID;
  ID hdAdminID = AA_UtilityClass.getHDAdminProfileID;
    
  list<ID> krsUsers = AA_UtilityClass.getKRSUSers;
  
  if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
  	for(Contact c: trigger.new){
  		if(c.Historic_ID__c == null){
  			c.Historic_ID__c = c.ID;
  			}
  		}
  	}
  
  if(!System.isBatch() && !System.isFuture() && trigger.isInsert || trigger.isUpdate && krsProfiles.contains(userInfo.getProfileId())){
  	try{
  	list<Event> events = new list<Event>();
  	
    DateTime dt = DateTime.newInstance(system.today().year(), system.today().month(), (system.today().day() + 1), 13, 0, 0);	
    
    list<ID> accountIDs = new list<ID>();
    list<Account> accounts = new list<Account>();	
    map<ID, ID> accountAndUsers = new map<ID, ID>();
  
  	for(Contact c: trigger.new){
  		if(c.RecordTypeID == krsContact){
    		accountIDs.add(c.AccountId);
  			}
    		}
    	system.debug('accountIDs size: ' + accountIDs.size());	
    	if(accountIDs.size() > 0){
    		accounts = [SELECT ID, KRS_SRS_BDO_Territory3__c FROM Account WHERE ID IN: accountIDs];
    		for(Account a: accounts){
    			accountAndUsers.put(a.ID, a.KRS_SRS_BDO_Territory3__c);
    			}	
    	system.debug('Accounts: ' + accounts);
    	system.debug('AccountAndUsers: ' + accountAndUsers);		
        for(Contact c : trigger.new){
    		if(c.KRS_Marketo_Process__c == true && c.KRS_Marketo_Processed__c == false){
    			system.debug('Parent Account BDO: ' + accountAndUsers.get(c.AccountId));
    			Event e = new Event(OwnerID = accountAndUsers.get(c.AccountId),
    								StartDateTime = dt,
    								DurationInMinutes = 10,
    								Type = 'Call-Follow Up',
    								Subject = 'MARKETO: Follow-up',
    								WhoID = c.ID,
    								RecordTypeID = krsEvent
    								);
    			events.add(e);					
    			c.KRS_Marketo_Processed__c = true;
    			}
    		}
    	system.debug('Events Contact:' + events);	
    	try{	
    		insert events;
    		}
    	catch(Exception E){
    		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    		}	
    	}
    }
    catch(exception e){
    	system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
    }
  }
  List<Merge__c> newMergeRows = new List<Merge__c>();
  list<ID> ids = new list<ID>();  
  Integer maxRecordsToGeocode = 10;
    //geocode Contacts
    //Future methods cannot be called from a future or batch method
    if(trigger.isAfter && !System.isBatch() && !System.isFuture() && (trigger.isInsert || trigger.isUpdate)){
        List<Id> idsToGeocode = new List<Id>();
        //Get ids for some records to geocode, up to max
        //(note due to callout and future limits this trigger may not attempt to geocode all records passed in)
          for(Contact c : Trigger.new) {
              if(Trigger.isInsert) {
                  //Want to geocode any newly created record, regardless
                  idsToGeocode.Add(c.Id);
                  if(c.RecordTypeID == indvCtc || c.Account.RecordTypeID == houseAcc){
                  	ids.add(c.ID);
                  	} 
                }
              else if(Trigger.isUpdate){
                  if(c.RecordTypeID == indvCtc || c.Account.RecordTypeID == houseAcc){
                  	ids.add(c.ID);
                  	}
                  //Only geocode an updated record if an address field has changed
                  Contact old = Trigger.oldMap.get(c.Id);
            
                  if(old.MailingStreet != c.MailingStreet || 
                      old.MailingCity != c.MailingCity ||
                      old.MailingState != c.MailingState ||
                      old.MailingPostalCode != c.MailingPostalCode ||
                      old.MailingCountry != c.MailingCountry){
                          idsToGeocode.Add(c.Id); 
                        }
                }
              //Ensure we're within our predetermined limit
              if(idsToGeocode.size()>=maxRecordsToGeocode){
                  break;
                }
            }
        ContactGeocodeCallout.doGeocodeRecords(idsToGeocode);
        AA_ContactTriggerHandler.updateTranscript(ids);
        }
  
  //Before deleting the Contact
  if(Trigger.isBefore && Trigger.isDelete){
  	for(Contact c: trigger.old){
  		if(c.RecordTypeID == krsContact && krsNonAdmins.contains(userInfo.getProfileId())){
  			if(!krsUsers.contains(userInfo.getUserId()) && c.OwnerID != userInfo.getUserId()){
  				c.addError('You are only permitted to delete Contact records that you created.  If you need this record removed please contact one of your admins.');
  				}
  			}
  		if(c.RecordTypeID == hdPhysicianContact && (userInfo.getProfileID() != hdAdminID && userInfo.getProfileID() != sysAdminID)){
  			c.addError('You are not permitted to delete HD Physician Contact records.  If there is a valid reason this record should be removed please contact one of your admins.');
  			}	
  		}
  	handler.onBeforeDelete(Trigger.oldMap);
    }
  
  //After deleting the Contact
  if(Trigger.isAfter){
    if(Trigger.isInsert){
      handleDMA.onAfterInsert(trigger.new);
        }
      
      if(Trigger.isUpdate){
        handleDMA.onAfterUpdate(trigger.oldMap, trigger.newMap);
        }
      
      if(Trigger.isDelete){
      	handler.onAfterDelete(Trigger.oldMap);
        //After deleting the Contact during a merge operation
        for(Contact contact : trigger.old) {
            if(String.isNotBlank(contact.MasterRecordId)) { 
                newMergeRows.add(new Merge__c(LoserId__c = contact.Id, WinnerId__c = contact.MasterRecordId));  
              }         
          }
        if(newMergeRows.size() > 0) {
            insert newMergeRows;
          }
      }
    }
 
}