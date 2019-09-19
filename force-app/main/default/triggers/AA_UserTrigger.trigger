trigger AA_UserTrigger on User (after insert, before update){
    
    final static list<Profile> pList = [SELECT ID, Name FROM Profile];
    
    map<ID, String> profileMap = AA_UtilityClass.getProfileMap;
    map<ID, String> roleMap = AA_UtilityClass.getRoleMap;
    
    id SALES_KAH_ASSOCIATE = AA_UtilityClass.getKAHAssociateID;
    id SALES_KAH_Market_Manager = AA_UtilityClass.getKAHMarketManagerID;
    id SALES_HD_Associate = AA_UtilityClass.getHDAssociateID;
    id SALES_NCD_Associate = AA_UtilityClass.getNCDAssociateID;
    id INACTIVE_PROFILE = AA_UtilityClass.getInactiveID;
    
    id INACTIVE_ROLE = AA_UtilityClass.getInactiveRoleID;
    
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
    	for(User u : trigger.new){
    		if(u.Historic_ID__c == null){
    			u.Historic_ID__c = u.ID;
    			}
    		}
    	}
    
    if(trigger.isBefore && trigger.isUpdate){
    	for(integer i = 0; i < trigger.new.size(); i++){
    		if((trigger.new[i].isActive == false || trigger.new[i].UserRoleId == INACTIVE_ROLE || trigger.new[i].profileId == INACTIVE_PROFILE) && trigger.new[i].Previous_Role__c == null && trigger.new[i].Previous_Profile__c == null){
    			if(!profileMap.get(trigger.old[i].profileId).contains('KAH')){
    				trigger.new[i].isActive = false;
    				trigger.new[i].UserRoleId = INACTIVE_ROLE;
    				trigger.new[i].profileId = INACTIVE_PROFILE;
    				trigger.new[i].Previous_Role__c = roleMap.get(trigger.old[i].UserRoleId);
    				trigger.new[i].Previous_Profile__c = profileMap.get(trigger.old[i].profileId);
    				}
    			}
    		}
    	}
    
    if(trigger.isAfter && trigger.isInsert){
    	Map<String, String> SPIdToRecordTypeId = new Map<String, String>();
    	String KAHrecTypeId = AA_UtilityClass.getKAHSalesPerfID; 
    	String LegacyrecTypeId = AA_UtilityClass.getLegacySalesPerfID;
    	
    	for(User u : [select id, profile.ID, perner__c from user where id in :Trigger.new]){
        	if(u.PERNER__c != null && (u.Profile.ID == SALES_KAH_ASSOCIATE || u.Profile.ID == SALES_KAH_Market_Manager || u.Profile.ID == SALES_HD_Associate || u.Profile.ID == SALES_NCD_Associate)){
            	for(Integer i=1; i<=12; i++){
                	String SPId = u.Id + mmyyyy(date.newinstance(System.now().year(), i, 1));
                	String RecTypeId;
                	if(u.Profile.ID == SALES_KAH_ASSOCIATE || u.Profile.ID == SALES_KAH_Market_Manager) RecTypeId = KAHrecTypeId;
                	else RecTypeId = LegacyrecTypeId;
                	SPIdToRecordTypeId.put(SPId, RecTypeId);
            		}  
        		}
    		}
    
    	for(Sales_Performance__c sp : [select Sales_Performance_Id__c from Sales_Performance__c where Sales_Performance_Id__c in :SPIdToRecordTypeId.keySet()]){
        	SPIdToRecordTypeId.remove(sp.Sales_Performance_Id__c);
    		}
    
    	if(SPIdToRecordTypeId.size() > 0){
        	Database.executeBatch(new Create12SalesPerf4NewUserBatch(SPIdToRecordTypeId));
    		}
    	}
    
    public static string mmyyyy(Date d){
        String mmyyyy;
        if (String.valueOf(d.month()).length() == 1){
            mmyyyy = '0'+String.valueOf(d.month())+String.valueOf(d.year());
        } else {
            mmyyyy = String.valueOf(d.month())+String.valueOf(d.year());
        }
        return mmyyyy;
    }
    
}