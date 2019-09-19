@RestResource(urlMapping='/ContactSync/*')
global with sharing class iPathContactSyncController {

	private static final ID physicianID = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'HD_Physicians'].ID;
	private static final ID legacySalesID = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Sales_HD_Contact'].ID;
	private static final ID hdID = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'HD_Contacts'].ID;
	
	private static final boolean hdConverted = AA_UtilityClass.getHDiPathSwitch;
	
    @HttpPatch
    global static List<Contact> doSync(List<Id> clientStarredIds) {
        Set<Id> preferredIds = new Set<Id>();
        boolean userHDConverted = [SELECT HD_CONVERTED__c FROM User WHERE ID =: UserInfo.getUserId()].HD_CONVERTED__c;
        //Get current server state of ids of starred contacts
        List<StarredContact__c> serverStarred = [SELECT Contact__r.Id FROM StarredContact__c WHERE CreatedById = :UserInfo.getUserId() FOR UPDATE];
        
        if(clientStarredIds == null) {
            //This is the case where we just want to return the current server state (e.g. device wiped situation)
            for(StarredContact__c starredContact:serverStarred) {
                preferredIds.add(starredContact.Contact__r.Id);
            }
        }
        else {
            //If we've not been passed null, the client side list will take precedence
            preferredIds = new Set<Id>(clientStarredIds);
        }
        
        //Replace the ids of any merge losers with the ids of the respective merge winners
        preferredIds = iPathMergeAnalysis.ConvertToWinnerIds(preferredIds);
        List<Contact> serverMatches = new list<Contact>();
        //Find the intersection of our preferred list of ids with those that are actually valid
        if(hdConverted == true || userHDConverted == true){
        	serverMatches = [
            SELECT Id, Salutation, FirstName, LastName, Primary_Specialty__c, Title, Other_Specialty__c, Account.Name,
                Contact_Days__c, Status__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, Phone, Fax,
                AssistantName, AssistantPhone, Email, HasOptedOutOfEmail,Owner.Name,RecordType.Name,CreatedBy.Name,
                CreatedDate,HPAS_Contact_ID__c,LastModifiedBy.Name,LastModifiedDate, Meditech_Contact_ID__c,
                LeadSource,NPI__c,mkto_si__Relative_Score_value__c,Marketo_Status__c, Marketo_Campaign__c, Title__c
            FROM Contact
            WHERE Id In :preferredIds AND (RecordTypeID =: physicianID OR RecordTypeID =: hdID)];
        	}
        else{
        	serverMatches = [
            SELECT Id, Salutation, FirstName, LastName, Primary_Specialty__c, Title, Other_Specialty__c, Account.Name,
                Contact_Days__c, Status__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, Phone, Fax,
                AssistantName, AssistantPhone, Email, HasOptedOutOfEmail,Owner.Name,RecordType.Name,CreatedBy.Name,
                CreatedDate,HPAS_Contact_ID__c,LastModifiedBy.Name,LastModifiedDate, Meditech_Contact_ID__c,
                LeadSource,NPI__c,mkto_si__Relative_Score_value__c,Marketo_Status__c, Marketo_Campaign__c, Title__c
            FROM Contact
            WHERE Id In :preferredIds AND (RecordTypeID =: physicianID OR RecordTypeID =: hdID OR RecordTypeID =:legacySalesID)];
        	}	
        //Update the server state to reflect our intersection
        delete serverStarred;
           
        List<StarredContact__c> newServerStarred = new List<StarredContact__c>();

        for (Contact c: serverMatches) {
            newServerStarred.add(new StarredContact__c(Contact__c = c.Id));
        }

        insert newServerStarred;   
       
        //Return new list of contacts for complete replacement on the client    
        return serverMatches;    
    }
    
}