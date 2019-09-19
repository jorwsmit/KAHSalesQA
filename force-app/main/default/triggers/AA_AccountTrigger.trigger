trigger AA_AccountTrigger on Account (after delete, after insert, after update, before delete, before insert, before update){

  TBN_AccountTriggerHandler handler = new TBN_AccountTriggerHandler();
  TBN_UpdateDMAOnAccountAndContactHandler handleDMA = new TBN_UpdateDMAOnAccountAndContactHandler();
  List<Merge__c> newMergeRows = new List<Merge__c>();
  id newHDAccount = AA_UtilityClass.getNewHDID;
  id srsAccount = AA_UtilityClass.getKRSStandardID;
  id centerAccount = AA_UtilityClass.getCenterID;
  id uIDRon = AA_UtilityClass.getRon;
  id uIDErika = AA_UtilityClass.getErika;
  ID krsTask = AA_UtilityClass.getKRSTask;
  list<ID> rchAddIds = AA_UtilityClass.getRHCAccIDs;
  
  Integer maxRecordsToGeocode = 10; 
  
  List<String> HospitalCoLOB = new List<String>();
  Schema.DescribeFieldResult fieldResult = IPathConfig__c.HospitalCoLOB__c.getDescribe();
  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
  for(Schema.PicklistEntry pickListVal : ple){
  	HospitalCoLOB.add(pickListVal.getLabel());
    }
    
  if(trigger.isBefore && trigger.isDelete){
  	handler.onBeforeDelete(Trigger.oldMap);
    }
   
  public list<Unit__c> activeUnits = AA_UtilityClass.getUnitList;
   
  map<String, ID> info = AA_UtilityClass.getSRSInfo;
  	
  public list<ID> accountIDs = new list<ID>();
    
  private static list<HRS_BDO_Territory__c> hBDOs = AA_UtilityClass.getHRSBDO;
  private static list<SRS_BDO_Territory__c> sBDOs = AA_UtilityClass.getSRSBDO;
    
  public list<Account> accounts = new list<Account>();
   
  public set<ID> accountComment = new set<ID>();
  if(trigger.isUpdate){
  for(ID accountId : trigger.newMap.keySet()){
  		if(Trigger.oldMap.get(accountId).Status_Comments__c != Trigger.newMap.get(accountId).Status_Comments__c){
        	accountComment.add(accountId);
        	}
   		}
  
  if(accountComment.size() > 0){
  	AA_StatusAndCommentsHelper.updateAccounts(accountComment);
  	}
  }
  
  if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
  	for(Account a : Trigger.new){
        if(a.Historic_ID__c == null){
            a.Historic_ID__c = a.ID;
            }
        if(HospitalCoLOB.contains(a.Type) && a.RecordTypeID == centerAccount){
            a.HospitalCoLOB__c = true;
            }
        else{
            a.HospitalCoLOB__c = false;
            }  
        if(a.RecordTypeID == srsAccount){
            accountIDs.add(a.Id);
            }
            if(trigger.isInsert){
            	if(a.Status_Comments__c != null){
            		a.Status_Comments_Last_Updated__c = system.now();
            		}
            	}
        }
        //KRS Assignations
          for(Account a: trigger.new){
          	if(a.BillingState != null && a.RecordTypeID == srsAccount){
            	if(a.KRS_RHB_Business_Unit__c == 'HRS' && a.HRS_BDO_Territory_Override__c == false){
                    map<ID, list<string>> hBDOMap = new map<ID, list<string>>();
                    for(HRS_BDO_Territory__c hbt: hBDOs){
                        list<string> us = new list<string>();
                        list<string> nonUS = new list<string>();
                        list<string> allTerr = new list<string>();
                        string usTemp = '';
                        string outTemp = '';
                        usTemp = hbt.US_Territories__c;
                        outTemp = hbt.Outside_US_Territories__c;
                        if(!string.isBlank(usTemp)){
                            us = usTemp.split(';');
                            }
                        if(!string.isBlank(outTemp)){   
                            nonUS = outTemp.split(';');
                            }
                        allTerr.addAll(us);
                        allTerr.addAll(nonUS);                      
                        hBDOMap.put(hbt.HRS_BDO__c, allTerr);
                        for(ID key : hBDOMap.keySet()){
                            if(hBDOMap.get(key).contains(a.BillingState)){
                                a.KHRS_BD_Territory__c = key;
                                a.OwnerId = key;
                                }
                            }
                        }
                	}
                list<Task> tasks = new list<Task>();
                Date dt = Date.newInstance(system.today().year(), system.today().month(), (system.today().day() + 60)); 
                
        	map<ID, ID> accountAndUsers = new map<ID, ID>();
        
        	for(Account a3: [SELECT ID, KRS_SRS_BDO_Territory3__r.Name FROM Account WHERE ID IN: accountIDs]){
            	if(info.get(a3.KRS_SRS_BDO_Territory3__r.Name) != null){
                	accountAndUsers.put(a3.ID, info.get(a3.KRS_SRS_BDO_Territory3__r.Name));
                	}
            	}
        	for(Account a4 : trigger.new){
        		
            	if(a4.KRS_New_Construction__c == true && a4.KRS_New_Construction_Processed__c == false && a4.KRS_SRS_BDO_Territory3__c != null){
                	Task t = new Task(OwnerID = accountAndUsers.get(a4.Id),
                    	                ActivityDate = dt,
                        	            Type = 'Call-Follow Up',
                            	        Subject = 'Find CMS Provider ID and Enter on Record',
                                	    WhatID = a.ID,
                                    	RecordTypeID = krsTask
                                   	 	);
                	if(test.isRunningTest() && t.OwnerID == null){
                		t.ownerID = userInfo.getUserID();
                		}                    
                	tasks.add(t);                   
                	a4.KRS_New_Construction_Processed__c = true;
                	}
            	}
            	insert tasks;
          	// Find the correct territory based on BillingState and PostalCode
          	if(a.KRS_RHB_Business_Unit__c == 'SRS' && a.HRS_BDO_Territory_Override__c == false){
          		Set<Id> ids = new Set<Id>();
      			for(Account a8 : Trigger.new){
      				if(a8.recordTypeID == srsAccount){
        				ids.add(a8.Id);
      					}
        			}
    			    	map<ID, list<string>> sBDOMap = new map<ID, list<string>>();
    			    	for(SRS_BDO_Territory__c sbt: sBDOs){
                        	list<string> us = new list<string>();
                        	list<string> allTerr = new list<string>();
                        	string usTemp = '';
                        	usTemp = sbt.States__c;
                        	if(!string.isBlank(usTemp)){
                            	us = usTemp.split(';');
                            	}
                        	allTerr.addAll(us);
                        	sBDOMap.put(sbt.SRS_BDO__c, allTerr);
                        	for(ID key : sBDOMap.keySet()){
                        		if(sBDOMap.get(key).contains(a.BillingState)){
                            		a.KRS_SRS_BDO_Territory3__c = key;
                            		a.OwnerId = key;
                            		}
                        		}
                     	}
                	}
    			}
   			}
  	}     
   
  if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
    
    if(trigger.isInsert){
        list<Account_Unit__c> newAccUnits = new list<Account_Unit__c>();
        for(Account ac: trigger.new){
            list<ID> accIDs = new list<ID>(); 
            if(ac.RecordTypeID == newHDAccount){
                accIDs.add(ac.ID);
                }
            for(ID i: accIDs){
                for(Unit__c u: activeUnits){
                    Account_Unit__c au = new Account_Unit__c();
                    au.Account__c = i;
                    au.Unit__c = u.Id;
                    if(u.Name == 'Administrative'){
                        au.Active__c = true;
                        }
                    else{
                        au.Active__c = false;
                        }
                    newAccUnits.add(au);
                    }
                }
            }
            if(newAccUnits.size() > 0){
                insert newAccUnits;
                }
        }
        
        if(trigger.isUpdate || trigger.isInsert){
        	try{
        	list<ID> accList = new list<ID>();
        	list<Account> srsAccounts = new list<Account>();
        	list<ID> rhcAccounts = new list<ID>();
        	for(Account a : trigger.new){
        		system.debug('AccountBusiness: ' + a.KRS_RHB_Business_Unit__c + ' Account RT: ' + a.RecordTypeID);
        		if(a.KRS_RHB_Business_Unit__c == 'SRS' && a.RecordTypeID == srsAccount && a.KRS_RHB_Business_Unit__c != null){
        			accList.add(a.ID);
        			srsAccounts.add(a);
        			}
        		if(rchAddIds.contains(a.RecordTypeID)){
        			rhcAccounts.add(a.ID);
        			}	
        		}	
        		AA_SRSAccountTeamHelper.processItems(srsAccounts, accList);
        		if(!System.isFuture()){
        			AA_RHCAccountTeamHelper.processAccounts(rhcAccounts);
        			}
        	}
        catch(Exception E){
        	system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
        	}	
        }
  }
     
   //Geocode Accounts
   //Future methods cannot be called from a future or batch method
   if(trigger.isAfter && !System.isBatch() && !System.isFuture() && (trigger.isInsert || trigger.isUpdate)){
       List<Id> idsToGeocode = new List<Id>();
      //Get ids for some records to geocode, up to max
      //(note due to callout and future limits this trigger may not attempt to geocode all records passed in)
      for(Account a : Trigger.new) {
        if(Trigger.isInsert) {
          //Want to geocode any newly created record, regardless
          idsToGeocode.Add(a.Id);  
          }
        if(Trigger.isUpdate) {
          //Only geocode an updated record if an address field has changed
              Account old = Trigger.oldMap.get(a.Id);
          
              if(old.ShippingStreet != a.ShippingStreet || 
                  old.ShippingCity != a.ShippingCity ||
                  old.ShippingState != a.ShippingState ||
                  old.ShippingPostalCode != a.ShippingPostalCode ||
                  old.ShippingCountry != a.ShippingCountry){
                      idsToGeocode.Add(a.Id);  
                   }
          }
        
        //Ensure we're within our predetermined limit
        if(idsToGeocode.size()>=maxRecordsToGeocode){
          break;
          }
        }
      AccountGeocodeCallout.doGeocodeRecords(idsToGeocode);
      }
    if(trigger.isAfter && trigger.isUpdate){
      handleDMA.onAfterUpdate(trigger.oldMap, trigger.newMap);
      }
    if(trigger.isAfter && trigger.isInsert){
      handleDMA.onAfterInsert(trigger.new);
      }
    //After delete of an Account during a merge operation
    if(trigger.isAfter && trigger.isDelete){
      handler.onAfterDelete(Trigger.oldMap);
      for(Account acct : trigger.old) {
          if(String.isNotBlank(acct.MasterRecordId)) { 
              newMergeRows.add(new Merge__c(LoserId__c = acct.Id, WinnerId__c = acct.MasterRecordId));  
            }         
        }
      if(newMergeRows.size() > 0) {
          insert newMergeRows;
        }
    }
}