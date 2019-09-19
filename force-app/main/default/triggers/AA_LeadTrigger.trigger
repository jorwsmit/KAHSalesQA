trigger AA_LeadTrigger on Lead (after delete, after insert, after update, before insert, before update) {
   	
   	
   	ID hrsDefaultUser = AA_UtilityClass.getHRSDefault;
   	ID srsDefaultUser = AA_UtilityClass.getSRSDefault;
   	ID srsLead = AA_UtilityClass.getSRSLead;
   	ID hrsLead = AA_UtilityClass.getHRSLead;
   	ID uIDRon = AA_UtilityClass.getRon;
  	ID uIDErika = AA_UtilityClass.getErika;
   	
   	List<Merge__c> newMergeRows = new List<Merge__c>();
    
    Integer maxRecordsToGeocode = 10;
    
    list<HRS_BDO_Territory__c> hBDOs = AA_UtilityClass.getHRSBDO;
  	list<SRS_BDO_Territory__c> sBDOs = AA_UtilityClass.getSRSBDO;
    
    //Lead geoCoding
    //Future methods cannot be called from a future or batch method
    
    public set<ID> leadComment = new set<ID>();
    if(trigger.isUpdate){
  	for(ID leadId : trigger.newMap.keySet()){
  		if(Trigger.oldMap.get(leadId).Status_Comments__c != Trigger.newMap.get(leadId).Status_Comments__c){
        	leadComment.add(leadId);
        	}
    }
  
  	if(leadComment.size() > 0){
  		AA_StatusAndCommentsHelper.updateLeads(leadComment);
  	}
    }
    if(trigger.isAfter && !System.isBatch() && !System.isFuture() &&(trigger.isInsert || trigger.isUpdate)) {
    	List<Id> idsToGeocode = new List<Id>();
    	//Get ids for some records to geocode, up to max
    	//(note due to callout and future limits this trigger may not attempt to geocode all records passed in)
    	for(Lead x : Trigger.new){
    		if(Trigger.isInsert && !x.IsConverted) {
    			//Want to geocode any newly created record, regardless
    			idsToGeocode.Add(x.Id);	
    		}
    		else if(Trigger.isUpdate && !x.IsConverted) {
    			//Only geocode an updated record if an address field has changed
            	Lead old = Trigger.oldMap.get(x.Id);
	        
	            if(old.Street != x.Street || 
	                old.City != x.City ||
	                old.State != x.State ||
	                old.PostalCode != x.PostalCode ||
	                old.Country != x.Country){
	                    idsToGeocode.Add(x.Id);	
	                	}
    			}
    		//Ensure we're within our predetermined limit
    		if(idsToGeocode.size()>=maxRecordsToGeocode){
    			break;
    			}
    		}
    	LeadGeocodeCallout.doGeocodeRecords(idsToGeocode);
    	}
    
    //After Delete during a merge operation
    if(trigger.isAfter && trigger.isDelete){
    	for(Lead x : trigger.old) {
        	if(String.isNotBlank(x.MasterRecordId)) { 
    	        newMergeRows.add(new Merge__c(LoserId__c = x.Id, WinnerId__c = x.MasterRecordId));  
        		}         
    		}
    	if(newMergeRows.size() > 0) {
        	insert newMergeRows;
    		}
    	}
    	
    	if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
    		for(Lead x : Trigger.new){
    			if(x.Historic_ID__c == null){
    				x.Historic_ID__c = x.ID;
    				}
    		
    			if(trigger.isInsert){
    					if(x.Status_Comments__c != null){
            				x.Status_Comments_Last_Updated__c = system.now();
            				}
            		}
    		
    		
    		if(x.HRS_BDO_Territory_Override__c == false){
    			if(x.State == null && x.recordTypeId == hrsLead){
    				x.KHRS_BD_Territory__c = hrsDefaultUser;
    				x.OwnerID = hrsDefaultUser;
    				x.Status = 'Unassigned';
    				}
    			if(x.State != null && x.recordTypeId == hrsLead && x.HRS_BDO_Territory_Override__c == false){
    				map<ID, list<string>> hBDOMap = new map<ID, list<string>>();
    				for(HRS_BDO_Territory__c hbt: hBDOs){
          				list<string> us = new list<string>();
          				list<string> nonUS = new list<string>();
          				list<string> allTerr = new list<string>();
          				string usTemp = '';
          				string outTemp = '';
          				usTemp = hbt.US_Territories__c;
          				outTemp = hbt.Outside_US_Territories__c;
          				system.debug('usTemp: ' + usTemp);
          				system.debug('outTemp: ' + outTemp);
          				if(!string.isBlank(usTemp)){
	          				us = usTemp.split(';');
          					}
          				if(!string.isBlank(outTemp)){	
          					nonUS = outTemp.split(';');
          					}
          				system.debug('us: ' + us);
          				system.debug('nonUS: ' + nonUS);	
          				allTerr.addAll(us);
          				allTerr.addAll(nonUS);          			
          				hBDOMap.put(hbt.HRS_BDO__c, allTerr);
          				for(ID key : hBDOMap.keySet()){
          					system.debug(hBDOMap.get(key));
          					if(hBDOMap.get(key).contains(x.State)){
          						x.KHRS_BD_Territory__c = key;
          						x.OwnerId = key;
          						if(x.Status != 'Inactive' && x.Status != 'Non-hospital' && x.Status != 'Competitor' && x.Status != 'Incomplete'){
          							x.Status = 'Assigned';
          							}
          						}
          					}
          				}
    			}
    		}
    		if(x.State == null && x.recordTypeId == srsLead){
    				x.KRS_SRS_BDO_Territory3__c = srsDefaultUser;
    				x.OwnerID = srsDefaultUser;
    				x.Status = 'Unassigned';
    				}
    		if(x.State != null && x.PostalCode != null && x.recordTypeId == srsLead && x.HRS_BDO_Territory_Override__c == false){
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
                        	if(sBDOMap.get(key).contains(x.State)){
                            	x.KRS_SRS_BDO_Territory3__c = key;
                            	x.OwnerId = key;
                            	x.Status = 'Assigned';
                            	}
                        }
                     }
    			}
    		}
    	}

}