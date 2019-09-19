@RestResource(urlMapping='/OfferingSync/*')
global with sharing class iPathOfferingSyncController {

    @HttpPatch
    global static List<ContentVersion> doSync(List<Id> clientStarredIds) {
        Set<Id> preferredIds = new Set<Id>();
        
        //Get current server state of ids of starred items
        List<StarredOffering__c> serverStarred = [SELECT ContentVersionId__c FROM StarredOffering__c WHERE CreatedById = :UserInfo.getUserId() FOR UPDATE];
        
        if(clientStarredIds == null) {
            //This is the case where we just want to return the current server state (e.g. device wiped situation)
            for(StarredOffering__c starredOffering:serverStarred) {
                preferredIds.add(Id.valueOf(starredOffering.ContentVersionId__c));
            }
        }
        else {
            //If we've not been passed null, the client side list will take precedence
            
            //First create a map of ContentDocumentIds to LatestPublishedVersionIds
            Map<Id, Id> docToVersionMap = new Map<Id, Id>();
            
            List<ContentDocument> docs = [SELECT LatestPublishedVersionId FROM ContentDocument Where Id in :clientStarredIds];
            
            for(ContentDocument cd : docs) {
                if(cd.LatestPublishedVersionId != null) {
                    docToVersionMap.put(cd.Id, cd.LatestPublishedVersionId);
                }
            }
            
            //Fill our preferredIds set with ContentVersionIds only
            for(Id docOrVersionId: clientStarredIds) {
                String objectAPIName = docOrVersionId.getSObjectType().getDescribe().getName();
                
                if(objectAPIName == 'ContentVersion') {
                    preferredIds.add(docOrVersionId);
                }
                else if(objectAPIName == 'ContentDocument') {
                    Id versionId = docToVersionMap.get(docOrVersionId);
                    
                    if(versionId != null) {
                        preferredIds.add(versionId);
                    }
                }
            }
        }
       
        //Find the intersection of our preferred list of ids with those that are actually valid
        List<ContentVersion> serverMatches = [
            SELECT Id, Title, Audience_Tag__c, LOB__c, FileType, ContentDocumentId, IsLatest, ContentSize
            FROM ContentVersion
            WHERE Id In :preferredIds];
   
        //Update the server state to reflect our intersection
        delete serverStarred;
           
        List<StarredOffering__c> newServerStarred = new List<StarredOffering__c>();   
           
        for(ContentVersion cv: serverMatches) {
            newServerStarred.add(new StarredOffering__c(ContentVersionId__c = String.valueOf(cv.Id)));
        }     
        
        insert newServerStarred;
       
        //Return new list of accounts for complete replacement on the client    
        return serverMatches;    
    }
    
}