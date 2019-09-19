@RestResource(urlMapping='/AccountSync/*')
global with sharing class iPathAccountSyncController {

	private static final ID centerID = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Center'].ID;
	private static final ID hdID = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'HD_Accounts'].ID;
	private static final ID hdLegacyID = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Sales_HD_Account'].ID;
	
	private static final boolean hdConverted = AA_UtilityClass.getHDiPathSwitch;
	
    @HttpPatch
    global static List<Account> doSync(List<Id> clientStarredIds) {
        Set<Id> preferredIds = new Set<Id>();
        boolean userHDConverted = [SELECT HD_CONVERTED__c FROM User WHERE ID =: UserInfo.getUserId()].HD_CONVERTED__c;
        //Get current server state of ids of starred accounts
        List<StarredAccount__c> serverStarred = [SELECT Account__r.Id FROM StarredAccount__c WHERE CreatedById = :UserInfo.getUserId() FOR UPDATE];
        
        if(clientStarredIds == null) {
            //This is the case where we just want to return the current server state (e.g. device wiped situation)
            for(StarredAccount__c starredAccount:serverStarred) {
                preferredIds.add(starredAccount.Account__r.Id);
            }
        }
        else {
            //If we've not been passed null, the client side list will take precedence
            preferredIds = new Set<Id>(clientStarredIds);
        }
       
        //Replace the ids of any merge losers with the ids of the respective merge winners
        preferredIds = iPathMergeAnalysis.ConvertToWinnerIds(preferredIds);
        List<Account> serverMatches = new list<Account>();
        //Find the intersection of our preferred list of ids with those that are actually valid
        if(hdConverted == true || userHDConverted == true){
        	serverMatches = [
            SELECT Id,Name,Parent.Name,NPI__c,Owner.Name,ShippingStreet,ShippingCity,ShippingState,
                     ShippingPostalCode,Website,Phone,Alternate_Phone__c,Fax,Type,Status__c,Latitude__c,Longitude__c,
                     Market__c,Market__r.Name,Account_Name__c,Legal_Entity_Name__c,Phone_Mirrored_Field_Update__c,
                     Screening_Instructions__c,Call_on_Days__c,CreatedBy.Name,CreatedDate,LastModifiedBy.Name,LastModifiedDate,
                     Meditech_ID__c,RecordType.Name,HPAS_ID__c,Facility_Number__c,Region__c,
                     QL_Amenities__c,QL_ScheduleTour__c,QL_Services__c,QL_SuccessStories__c
            FROM Account
            WHERE 
            (Id In :preferredIds AND Status__c != 'Inactive' AND (RecordTypeID =: hdID OR RecordTypeID =: centerID)) 
            ];
        	}
        else{
        	serverMatches = [
            SELECT Id,Name,Parent.Name,NPI__c,Owner.Name,ShippingStreet,ShippingCity,ShippingState,
                     ShippingPostalCode,Website,Phone,Alternate_Phone__c,Fax,Type,Status__c,Latitude__c,Longitude__c,
                     Market__c,Market__r.Name,Account_Name__c,Legal_Entity_Name__c,Phone_Mirrored_Field_Update__c,
                     Screening_Instructions__c,Call_on_Days__c,CreatedBy.Name,CreatedDate,LastModifiedBy.Name,LastModifiedDate,
                     Meditech_ID__c,RecordType.Name,HPAS_ID__c,Facility_Number__c,Region__c,
                     QL_Amenities__c,QL_ScheduleTour__c,QL_Services__c,QL_SuccessStories__c
            FROM Account
            WHERE 
            (Id In :preferredIds AND Status__c != 'Inactive' 
            AND (RecordTypeID =: hdID OR RecordTypeID =: centerID OR RecordTypeID =: hdLegacyID)
            )
            ];
        	}	
        //Update the server state to reflect our intersection
        delete serverStarred;
        
        List<StarredAccount__c> newServerStarred = new List<StarredAccount__c>();
           
        for(Account a: serverMatches) {
            newServerStarred.add(new StarredAccount__c(Account__c = a.Id));
        }     
        
        insert newServerStarred;
       
        //Return new list of accounts for complete replacement on the client    
        return serverMatches;    
    }
    
}