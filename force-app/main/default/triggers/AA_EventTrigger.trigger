trigger AA_EventTrigger on Event (before insert, before update, after delete, after insert, after update, before delete) {
    
    map<ID, Event> accLst = new map<ID, Event>();
    
    List<ID> noDelete = AA_UtilityClass.getKRSNoDeleteProfiles;
    
    ID salesKAHAssociate = AA_UtilityClass.getKAHAssociateID;
    ID salesKAHMarketManager = AA_UtilityClass.getKAHMarketManagerID;
    ID salesHDAssociate = AA_UtilityClass.getHDAssociateID;
    ID salesNCDAssociate = AA_UtilityClass.getNCDAssociateID;
    ID systemAdministrator = AA_UtilityClass.getSysAdminID;
    ID krsSRSSupportAdmin = AA_UtilityClass.getKRSSRSSupportID;
    ID krsSRSAdmin = AA_UtilityClass.getKRSSRSAdminID;
    ID hrsEvent = AA_UtilityClass.getkrsEvent;
    
    list<String> typeList = new list<String>();    
    typeList.Add('F2F - QBR');
    typeList.Add('F2F - PD Monthly Meeting');
    typeList.Add('F2F');
    typeList.Add('CPS Live Client Engagement - CPS Use Only');
    typeList.Add('CPS Live Rehab Engagement - CPS Use Only');
    typeList.Add('CPS Remote Client Engagement - CPS Use Only');
    typeList.Add('CPS Remote Rehab Engagement - CPS Use Only');
    typeList.Add('Phone Call');
    typeList.Add('Email');
    
    if(trigger.isAfter && trigger.isInsert || trigger.isUpdate){
    	list<ID> processList = new list<ID>();
    	for(Event e: trigger.new){
    		if(e.RecordTypeID == hrsEvent){
    			if(e.WhatID != null){
    				processList.add(e.WhatID);
    				}
    			else{
    				processList.add(e.WhoID);
    				}	
    			}
    		}
    	if(processList.size() > 0){
    		AA_HRSTaskandEventHelper.processItems(processList);
    		}
    	}
    
    if(!System.isBatch()){
        if(Trigger.isBefore){  
            if(Trigger.isInsert || Trigger.isUpdate){
                Map<String, Event> salesPerfIdsToEvents = new Map<String, Event>();
                Set<String> spIds = new Set<String>();
                Set<Id> ownerIds = new Set<Id>();
                Map<Id, ID> ownerIdsToProfileNames= new Map<Id, ID>();
                
                for(Event e : Trigger.new){
                	if(e.Historic_ID__c == null){
                		e.Historic_ID__c = e.ID;
                		}
                    if(!ownerIds.contains(e.ownerId)){
                        ownerIds.add(e.ownerId);
                        }
                    }
                
                for(User u : [select Id, Profile.ID from user where id in :ownerIds]){
                    ownerIdsToProfileNames.put(u.Id, u.Profile.ID);
                    }
                Integer i = 0;
                for(Event e : Trigger.new){
                                                                                    //Sales: KAH Associate                                      //KAH Market Manager                                            Sales: HD Associate                                         Sales: NCD Associate
                    if(e.Type != 'PTO' && (ownerIdsToProfileNames.get(e.ownerId) == salesKAHAssociate || ownerIdsToProfileNames.get(e.ownerId) == salesKAHMarketManager || ownerIdsToProfileNames.get(e.ownerId) == salesHDAssociate || ownerIdsToProfileNames.get(e.ownerId) == salesNCDAssociate)){
                        try{
                        	salesPerfIdsToEvents.put(e.OwnerId + mmyyyy(e.ActivityDateTime) + String.valueOf(i), e);
                        	i++;
                        	if(!spIds.contains(e.OwnerId + mmyyyy(e.ActivityDateTime))){
                            	spIds.add(e.OwnerId + mmyyyy(e.ActivityDateTime));
                            	}
                        	}
                        catch(Exception err){
                        	e.addError('You must select and Date and Time for your activity to proceed.');
                        	}
                        }
                    else{
                        e.Sales_Performance_ID__c = null;    
                        }
                    }//end for loop updated and inserted events
                List<Sales_Performance__c> salesPerfs = [select Id, Sales_Performance_ID__c, Sales_Calls__c from Sales_Performance__c
                                                         where Sales_Performance_ID__c in :spIds];
                Map<String, Id> invalidSpIdsToSpIds = new Map<String, Id>();
                for(String invalidSpId : salesPerfIdsToEvents.keySet()){
                    for(Sales_Performance__c sp : salesPerfs){
                        if (sp.Sales_Performance_ID__c == invalidSpId.substring(0,24)){
                            invalidSpIdsToSpIds.put(invalidSpId, sp.Id);
                            }
                        }
                    }
                
                for(String invalidSpId : salesPerfIdsToEvents.keySet()){
                    Event e = salesPerfIdsToEvents.get(invalidSpId);
                    e.Sales_Performance_ID__c = invalidSpIdsToSpIds.get(invalidSpId);
                    }
                //The update below causes LengthOfRelatedActivitiesToSalesCalls to be triggered
                //LengthOfRelatedActivitiesToSalesCalls sets the Sales_Calls__c field 
                //to the number of tasks and events related to that Sales_Performance__c object
                update salesPerfs;
                }
                if(trigger.isDelete){
                	for(Event e: trigger.old){
                		system.debug('User Profile ID: ' + UserInfo.getProfileId() + ' Subject: ' + e.Subject);
    													//System Admin										//KRS: SRS Support Admin						//KRS: SRS Admin
    					if(((UserInfo.getProfileId() != systemAdministrator && UserInfo.getProfileId() != krsSRSSupportAdmin && UserInfo.getProfileId() != krsSRSAdmin) && e.Subject == 'MARKETO: Follow-up')){
    						e.addError('You are not permitted to delete a Marketo Follow-up event without administrative permissions.  If you need this item deleted, please contact one of your admins.');
    						}
    					if(noDelete.contains(UserInfo.getProfileId())  && UserInfo.getUserId() != e.OwnerId){
							e.addError('You do not have permission to delete events you did not create, only administrators are allowed, please contact an admin user if you need assistance.');
							}		
    					}
                	}
                }//End if isBefore
            else{
                if(Trigger.isDelete){
                //list of Sales_Performance_c IDs based on deleted events related Sales_Performance__c
                List<String> spIds = new List<String>();
                List<String> spIdsFromRecurrence = new List<String>();
                for(Event e : Trigger.old){
                    if(e.IsRecurrence && e.RecurrenceStartDateTime.date().monthsBetween(e.RecurrenceEndDateOnly) >= 1){
                        Integer mb = e.RecurrenceStartDateTime.date().monthsBetween(e.RecurrenceEndDateOnly);
                        for(Integer i=0; i<mb; i++){
                            spIdsFromRecurrence.add(e.OwnerId + mmyyyy(e.RecurrenceStartDateTime.addMonths(i)));
                            }
                        }
                    spIds.add(e.Sales_Performance_ID__c);
                    }//end for loop old deleted events
                //Query the Sales_Performance__c's from the list of Sales_Performance_c IDs
                List<Sales_Performance__c> salesPerfs = [select Id from Sales_Performance__c
                                                         where (Id in :spIds or Sales_Performance_ID__c in :spIdsFromRecurrence)];
                //The update below causes LengthOfRelatedActivitiesToSalesCalls to be triggered
                //LengthOfRelatedActivitiesToSalesCalls sets the Sales_Calls__c field 
                //to the number of tasks and events related to that Sales_Performance__c object
                update salesPerfs;
                }//End if isDelete
             else if(Trigger.isInsert){
                List<String> spIds = new List<String>();
                for(Event e : Trigger.new){
                    if(e.Type != 'PTO' && e.Sales_Performance_ID__c != null){    
                        spIds.add(e.Sales_Performance_ID__c);
                        }
                    for(String s : typeList){
                        system.debug('Check: ' + s);
                        system.debug('Check Against: ' + e.Type);
                        if(s == e.Type){
                            accLst.put(e.WhatID, e);
                            }
                        }   
                    }
                List<Sales_Performance__c> newSalesPerfs = [select Id from Sales_Performance__c
                                                            where Id in :spIds];
                update newSalesPerfs;
                for(Event evt: trigger.new){
                    system.debug('profileID:' + userInfo.getProfileId());
                    if(evt.isRecurrence == true && (system.today().daysBetween(evt.RecurrenceEndDateOnly) > 365)){
                        evt.addError('Event Series may only be scheduled 1 year out from the current date.  If you need to schedule an event out further, please consider other means, such as your Outlook calendar.');
                        }
                    }
                }//end if isInsert
             else if(Trigger.isUpdate){
                //System.debug('Number of events after update: '+Trigger.old.size()+Trigger.new.size());
                List<String> spIds = new List<String>();
                for(Event e : Trigger.old){
                    if(e.Type != 'PTO'){    
                        spIds.add(e.Sales_Performance_ID__c);
                        }
                   }
                for(Event e : Trigger.new){
                    if(e.Type != 'PTO'){    
                        spIds.add(e.Sales_Performance_ID__c);
                        }
                    }
                List<Sales_Performance__c> newSalesPerfs = [select Id from Sales_Performance__c
                                                            where Id in :spIds];
                update newSalesPerfs;
                }//end if Trigger is insert/update or delete/after update
            }
    }
    
    public static string mmyyyy(Datetime d){
        String mmyyyy;
        if(String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
            }
         else{
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
            }
        return mmyyyy;
        }//end mmyyyy

    if(accLst.size() > 0){
        AA_TaskAndEventHelper.updateAccountsEvent(accLst);
        }

}