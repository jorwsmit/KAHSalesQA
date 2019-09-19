@RestResource(urlMapping='/LeadSync/*')
global with sharing class iPathLeadSyncController {

    @HttpPatch
    global static List<Lead> doSync(List<Id> clientStarredIds) {
        Set<Id> preferredIds = new Set<Id>();
        
        //Get current server state of ids of starred leads
        List<StarredLead__c> serverStarred = [SELECT Lead__r.Id FROM StarredLead__c WHERE CreatedById = :UserInfo.getUserId() FOR UPDATE];
        
        if(clientStarredIds == null) {
            //This is the case where we just want to return the current server state (e.g. device wiped situation)
            for(StarredLead__c starredLead:serverStarred) {
                preferredIds.add(starredLead.Lead__r.Id);
            }
        }
        else {
            //If we've not been passed null, the client side list will take precedence
            preferredIds = new Set<Id>(clientStarredIds);
        }
        
        //Replace the ids of any merge losers with the ids of the respective merge winners
        preferredIds = iPathMergeAnalysis.ConvertToWinnerIds(preferredIds);
       
        //Find the intersection of our preferred list of ids with those that are actually valid
        List<Lead> serverMatches = [
            SELECT Id, Salutation, FirstName, LastName, Primary_Specialty__c, Full_Name__c, Status, Title, Company,
              Gender__c, Street, City, State, PostalCode, Phone, Fax__c, Email, HasOptedOutOfEmail, Owner.Name, NPI__c,
              CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate, LeadSource, mkto_si__Relative_Score_value__c,
              Marketo_Status__c, Marketo_Campaign__c, Audience__c
            FROM Lead
            WHERE IsConverted = false
            AND Id In :preferredIds];
   
        //Update the server state to reflect our intersection
        delete serverStarred;
           
        List<StarredLead__c> newServerStarred = new List<StarredLead__c>();
           
        for(Lead lead: serverMatches) {
            newServerStarred.add(new StarredLead__c(Lead__c = lead.Id));
        }     
       
        insert newServerStarred;       
       
        //Return new list of leads for complete replacement on the client    
        return serverMatches;    
    }
    
}