@RestResource(urlMapping='/PatientAssessmentSynced/*')
global with sharing class iPathAssessmentSyncedController {
    
    @HttpGet
    global static List <List<String>> assessment() {
        // Get app version
        RestRequest req = RestContext.request;  
        Integer app_version;
        if (req.params.containsKey('meta_app_version')) {
            app_version = Integer.valueOf(req.params.get('meta_app_version'));
        }  
    
        List<Assessment_TCC__c> tccAssessments = [SELECT Meta_ChainUUID__c, Meta_Document_Version__c, Meta_Filename__c, Meta_Submitted_Date__c, Meta_Creation_Date__c FROM Assessment_TCC__c WHERE Meta_ChainUUID__c != null AND Meta_Owner__c = :UserInfo.getUserId()];
        List<Assessment_TCH__c> tchAssessments = [SELECT Meta_ChainUUID__c, Meta_Document_Version__c, Meta_Filename__c, Meta_Submitted_Date__c, Meta_Creation_Date__c FROM Assessment_TCH__c WHERE Meta_ChainUUID__c != null AND Meta_Owner__c = :UserInfo.getUserId()];
        
        Set<String> chainsToSync = new Set<String>();
        
        // We want to sync a chain if and only if that chain has a submitted assessment with submission date within 6 months or an unsubmitted assessment with creation date within 2 days
        // (this applies to app_version >= 126 only, otherwise sync all chains for backward compatibility with older clients)
        DateTime creationDateLimit = DateTime.now().addDays(-2);
        DateTime submissionDateLimit = DateTime.now().addMonths(-6);
             
        for (Assessment_TCC__c tccAssessment : tccAssessments) {
            if(app_version == null ||
                app_version < 126 ||
                (tccAssessment.Meta_Submitted_Date__c == null && tccAssessment.Meta_Creation_Date__c > creationDateLimit) ||
                (tccAssessment.Meta_Submitted_Date__c != null && tccAssessment.Meta_Submitted_Date__c > submissionDateLimit)) {
                chainsToSync.add(tccAssessment.Meta_ChainUUID__c);
            }
        }
        
        for (Assessment_TCH__c tchAssessment : tchAssessments) {
            if(app_version == null ||
                app_version < 126 ||
                (tchAssessment.Meta_Submitted_Date__c == null && tchAssessment.Meta_Creation_Date__c > creationDateLimit) ||
                (tchAssessment.Meta_Submitted_Date__c != null && tchAssessment.Meta_Submitted_Date__c > submissionDateLimit)) {
                chainsToSync.add(tchAssessment.Meta_ChainUUID__c);
            }
        }
       
        List<List<String>> assessments = new List<List<String>>();

        for (Assessment_TCC__c tccAssessment : tccAssessments) {
            if (chainsToSync.contains(tccAssessment.Meta_ChainUUID__c)) {
                List<String> assessment = new List<String>();
                assessment.add(tccAssessment.Meta_ChainUUID__c);
                assessment.add(tccAssessment.Meta_Document_Version__c);
                assessment.add(tccAssessment.Meta_Filename__c);
                assessments.add(assessment);
            }
        }
        
        for (Assessment_TCH__c tchAssessment : tchAssessments) {
            if (chainsToSync.contains(tchAssessment.Meta_ChainUUID__c)) {
                List<String> assessment = new List<String>();
                assessment.add(tchAssessment.Meta_ChainUUID__c);
                assessment.add(tchAssessment.Meta_Document_Version__c);
                assessment.add(tchAssessment.Meta_Filename__c);
                assessments.add(assessment);
            }
        }
        
        return assessments;
    }
    
}