public with sharing class AA_AccountChoiceController{
	
	@AuraEnabled(cacheable=true)
	public static list<RecordType> getAccountChoices(){
		list<RecordType> accTypes = new list<RecordType>();
		list<ID> hdProfileIDs = AA_UtilityClass.getAllHDProfileIDs;
		list<ID> kahProfileIDs = AA_UtilityClass.getAllSTDKAHProfileIDs;
		list<ID> kahBDProfileIDs = AA_UtilityClass.getAllBDKAHProfileIDs;
		list<ID> rhcProfileIDs = AA_UtilityClass.getAllRHCProfileIDs;
		list<ID> lacProfileIDs = AA_UtilityClass.getAllLacunaProfileIDs;
		list<ID> krsProfileIDs = AA_UtilityClass.getAllKRSProfileIDs;
		ID sysAdmin = AA_UtilityClass.getSysAdminID;
		
		system.debug('UserProfileId: ' + userInfo.getProfileId());
		system.debug('HD Profiles: ' + hdProfileIDs);
		system.debug('KAH Profiles: ' + kahProfileIDs);
		system.debug('KAH BD Profiles: ' + kahBDProfileIDs);
		system.debug('RHC Profiles: ' + rhcProfileIDs);
		system.debug('LAC Profiles: ' + lacProfileIDs);
		system.debug('KRS Profiles: ' + krsProfileIDs);
		
		if(userInfo.getProfileId() == sysAdmin){
			accTypes = [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account'];	
			}
		if(hdProfileIDs.contains(userInfo.getProfileId())){
			accTypes = AA_UtilityClass.getHDAccountTypes;
			}
		if(kahProfileIDs.contains(userInfo.getProfileId())){
			accTypes = AA_UtilityClass.getKAHAccountTypes;
			}
		if(kahBDProfileIDs.contains(userInfo.getProfileId())){
			accTypes = AA_UtilityClass.getKAHBDAccountTypes;
			}	
		if(rhcProfileIDs.contains(userInfo.getProfileId())){
			accTypes = AA_UtilityClass.getRHCAccountTypes;
			}
		if(lacProfileIDs.contains(userInfo.getProfileId())){
			accTypes = AA_UtilityClass.getLACAccountTypes;
			}
		if(krsProfileIDs.contains(userInfo.getProfileId())){
			accTypes = AA_UtilityClass.getKRSAccountTypes;
			}			 
		system.debug('accTypes: ' + accTypes);
		return accTypes;
		}
		
	@AuraEnabled
	public static string getViewState(){
		string experience =	UserInfo.getUiThemeDisplayed();
		return experience;
		}	
		
}