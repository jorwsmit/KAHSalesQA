@RestResource(urlMapping='/Versions/*')
global with sharing class iPathVersionsController {

    @HttpPatch
    global static void patchVersions(String iOSVersion, String iPathVersion) {
        // Get the existing version numbers from User record
        User user = [SELECT iOS_Version__c, iPath_Version__c FROM User WHERE Id = :UserInfo.getUserId()];
        
        // Use a single NOW value throughout this method
        DateTime now = System.Now();
        
        // Update iOS version if that has changed
        if(iOSVersion != user.iOS_Version__c) {
            user.iOS_Version__c = iOSVersion;
            user.iOS_Version_Last_Updated__c = now;
        }
        
        // Update iPath version if that has changed
        if(iPathVersion != user.iPath_Version__c) {
            user.iPath_Version__c = iPathVersion;
            user.iPath_Version_Last_Updated__c = now;
        }
        
        // Record the sync date and time
        user.iPath_Last_Sync__c = now;
        
        // Update the record
        update user;
    }
    
}