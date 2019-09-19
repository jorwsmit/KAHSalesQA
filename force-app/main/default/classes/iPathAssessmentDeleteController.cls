@RestResource(urlMapping='/PatientAssessmentDelete/*')
global class iPathAssessmentDeleteController { 

    // Custom Exception
    public class AssessmentException extends Exception{}
    
    public class assessment {
        String meta_filename;
    }
    
    @HttpPost
    global static Map<String,String> deleteAssessment() {
        RestRequest req = RestContext.request;

        try {
          assessment deletedFile = (assessment)System.JSON.deserialize(req.requestBody.toString(), assessment.class);

          List<Assessment_TCC__c> assessmentsTCC = [SELECT Id FROM Assessment_TCC__c WHERE Meta_Filename__c = :deletedFile.meta_filename AND Meta_Document_Status__c = '1' FOR UPDATE];
          List<Assessment_TCH__c> assessmentsTCH = [SELECT Id FROM Assessment_TCH__c WHERE Meta_Filename__c = :deletedFile.meta_filename AND Meta_Document_Status__c = '1' FOR UPDATE];

          if (assessmentsTCH.size() > 0) {
               delete assessmentsTCH;
          } else if (assessmentsTCC.size() > 0) {
               delete assessmentsTCC;
          }
            
          return new Map<String,String> {'Delete Assessment' => 'Success', 'Filename' => deletedFile.meta_filename};
          
        } catch (Exception mainError) {
             return new Map<String,String> {'Delete Assessment' => 'Failed', 'Error' => mainError.getMessage()};
        }
    } 
}