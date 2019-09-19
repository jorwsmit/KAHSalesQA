@RestResource(urlMapping='/PatientAssessmentDownload/*')
global with sharing class iPathAssessmentDownloadController {
    
    public class form_metadata {
        String meta_filename;
        String meta_app_version;
    }
    
    @HttpGet
    global static Map<String,String> downloadAssessment() {
        RestRequest req = RestContext.request;  
                
        String filename;
        Integer app_version;
        if (req.params.size() > 0) {
            filename = req.params.get('meta_filename');
            if (req.params.containsKey('meta_app_version')) {
                app_version = Integer.valueOf(req.params.get('meta_app_version'));
            }
        } else {
            form_metadata metadata = (form_metadata)JSON.deserialize(req.requestBody.toString(), form_metadata.class);
            filename = metadata.meta_filename;
            if (metadata.meta_app_version != null) {
                app_version = Integer.valueOf(metadata.meta_app_version);
            }
        }   
            
        List<String> tchFields = new List<String>(Assessment_TCH__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soqlTCH = '' + ' SELECT ' + String.join(tchFields, ',') + ' from Assessment_TCH__c' + ' where Meta_Filename__c = \'' + filename + '\'';

        List<String> tccFields = new List<String>(Assessment_TCC__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soqlTCC = '' + ' SELECT ' + String.join(tccFields, ',') + ' from Assessment_TCC__c' + ' where Meta_Filename__c = \'' + filename + '\'';

        Assessment_TCH__c[] assessmentsTCH = database.query(soqlTCH);
        Assessment_TCC__c[] assessmentsTCC = database.query(soqlTCC);

        if (assessmentsTCH.size() > 0) {
            Map<String, String> assessment = new Map<String, String>();
            Assessment_TCH__c assessmentTCH = assessmentsTCH[0];
            
            //TCH MetaData
            if (assessmentTCH.Meta_Bookmark__c != null) assessment.put('meta_bookmark', assessmentTCH.Meta_Bookmark__c.format());
            if (assessmentTCH.Meta_Form_Type__c != null) assessment.put('meta_form_type', assessmentTCH.Meta_Form_Type__c.format());
            if (assessmentTCH.Meta_Manual_Bookmark__c != null) assessment.put('meta_manual_bookmark', assessmentTCH.Meta_Manual_Bookmark__c.format());
            if (assessmentTCH.Meta_ChainUUID__c != null) assessment.put('meta_chainuuid', assessmentTCH.Meta_ChainUUID__c);
            if (assessmentTCH.Meta_Document_Version__c != null) assessment.put('meta_document_version', assessmentTCH.Meta_Document_Version__c);
            if (assessmentTCH.Meta_Document_Status__c != null) assessment.put('meta_document_status', assessmentTCH.Meta_Document_Status__c);
            if (assessmentTCH.Meta_Filename__c != null) assessment.put('meta_filename', assessmentTCH.Meta_Filename__c);

            if (app_version > 120) {
                 if (assessmentTCH.Meta_Reassessment_Date__c != null) assessment.put('meta_reassessment_date', assessmentTCH.Meta_Reassessment_Date__c.format('yyyy-MM-dd HH:mm:ss', 'UTC'));
                 if (assessmentTCH.Meta_Creation_Date__c != null) assessment.put('meta_creation_date', assessmentTCH.Meta_Creation_Date__c.format('yyyy-MM-dd HH:mm:ss', 'UTC'));
                 if (assessmentTCH.Meta_Submitted_Date__c != null) assessment.put('meta_submitted_date', assessmentTCH.Meta_Submitted_Date__c.format('yyyy-MM-dd HH:mm:ss', 'UTC'));
            } else {
                 if (assessmentTCH.Meta_Reassessment_Date__c != null) assessment.put('meta_reassessment_date', assessmentTCH.Meta_Reassessment_Date__c.format());
                 if (assessmentTCH.Meta_Creation_Date__c != null) assessment.put('meta_creation_date', assessmentTCH.Meta_Creation_Date__c.format());
                 if (assessmentTCH.Meta_Submitted_Date__c != null) assessment.put('meta_submitted_date', assessmentTCH.Meta_Submitted_Date__c.format());
            }
                     
            //Kindred Attending MD
            if (assessmentTCH.Kindred_Attending_Physician__c != null) assessment.put('kindred_attending_md_name', assessmentTCH.Kindred_Attending_Physician__c);
            if (assessmentTCH.Kindred_Attending_Physician_As_Contact__c != null) assessment.put('kindred_attending_md_sfid', assessmentTCH.Kindred_Attending_Physician_As_Contact__c);            
            if (assessmentTCH.Kindred_Attending_Physician_As_Lead__c != null) assessment.put('kindred_attending_md_sfid', assessmentTCH.Kindred_Attending_Physician_As_Lead__c);            

            //Referral Physician
            if (assessmentTCH.Referral_Physician__c != null) assessment.put('referring_physician_name', assessmentTCH.Referral_Physician__c);
            if (assessmentTCH.Referral_Physician_As_Contact__c != null) assessment.put('referring_physician_sfid', assessmentTCH.Referral_Physician_As_Contact__c);            
            if (assessmentTCH.Referral_Physician_As_Lead__c  != null) assessment.put('referring_physician_sfid', assessmentTCH.Referral_Physician_As_Lead__c );            

            //Referral Location
            if (assessmentTCH.Referral_Location__c != null) assessment.put('referring_location_name', assessmentTCH.Referral_Location__c);
            if (assessmentTCH.Referral_Location_Account__c != null) assessment.put('referring_location_sfid', assessmentTCH.Referral_Location_Account__c);            

            //Primary Physician
            if (assessmentTCH.Primary_Physician__c != null) assessment.put('primary_care_physician_name', assessmentTCH.Primary_Physician__c);
            if (assessmentTCH.Primary_Physician_As_Contact__c != null) assessment.put('primary_care_physician_sfid', assessmentTCH.Primary_Physician_As_Contact__c);            
            if (assessmentTCH.Primary_Physician_As_Lead__c != null) assessment.put('primary_care_physician_sfid', assessmentTCH.Primary_Physician_As_Lead__c);            
            if (assessmentTCH.Primary_Physician_Phone__c != null) assessment.put('primary_care_physician_phone', assessmentTCH.Primary_Physician_Phone__c);

            //Referral Contact
            if (assessmentTCH.Referral_Contact__c != null) assessment.put('referring_contact_name', assessmentTCH.Referral_Contact__c);
            if (assessmentTCH.Referral_Contact_As_Contact__c != null) assessment.put('referring_contact_sfid', assessmentTCH.Referral_Contact_As_Contact__c);            
            if (assessmentTCH.Referral_Contact_As_Lead__c != null) assessment.put('referring_contact_sfid', assessmentTCH.Referral_Contact_As_Lead__c);            

            //Patient Demographics Refer To
            if (assessmentTCH.Patient_Demographics_Refer_To__c != null) assessment.put('refer_to_name', assessmentTCH.Patient_Demographics_Refer_To__c);
            if (assessmentTCH.Refer_To_Account__c != null) assessment.put('refer_to_sfid', assessmentTCH.Refer_To_Account__c);

            //Consulting Physicians TCH
            List<String> tchConsultingPhysicianFields = new List<String>(Consulting_Physician_TCH__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlConsultingPhysicianTCH = '' + ' SELECT ' + String.join(tchConsultingPhysicianFields, ',') + ' from Consulting_Physician_TCH__c' + ' where Assessment_TCH__c = \'' + assessmentTCH.Id + '\'';
            List<Map<String,String>> consultingPhysicians = new List<Map<String,String>>();
            Consulting_Physician_TCH__c[] consulting_mds = database.query(soqlConsultingPhysicianTCH);
            if (consulting_mds.size() > 0) {
              for (Consulting_Physician_TCH__c consultingPhysicianItem : consulting_mds) {
                Map<String,String> consultingPhysician = new Map<String,String>();
                if (consultingPhysicianItem.Consulting_Physician__c != null) consultingPhysician.put('consulting_mds_name',consultingPhysicianItem.Consulting_Physician__c);
                if (consultingPhysicianItem.Consulting_Physician_As_Contact__c != null) consultingPhysician.put('consulting_mds_sfid',consultingPhysicianItem.Consulting_Physician_As_Contact__c);
                if (consultingPhysicianItem.Consulting_Physician_As_Lead__c != null) consultingPhysician.put('consulting_mds_sfid',consultingPhysicianItem.Consulting_Physician_As_Lead__c);
                consultingPhysicians.add(consultingPhysician);
              }
              assessment.put('consulting_mds',JSON.serialize(consultingPhysicians));
            }

            //Medications TCH
            List<String> tchMedicationFields = new List<String>(Medication_TCH__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlMedicationTCH = '' + ' SELECT ' + String.join(tchMedicationFields, ',') + ' from Medication_TCH__c' + ' where Assessment_TCH__c = \'' + assessmentTCH.Id + '\'';
            List<Map<String,String>> medicationItems = new List<Map<String,String>>();
            Medication_TCH__c[] multiple_medications_group = database.query(soqlMedicationTCH);
            if (multiple_medications_group.size() > 0) {
              for (Medication_TCH__c medicationItem : multiple_medications_group) {
                Map<String,String> medication = new Map<String,String>();
                if (medicationItem.App_Timestamp__c != null) medication.put('app_timestamp',medicationItem.App_Timestamp__c);
                if (medicationItem.Medication_Dosage__c != null) medication.put('medication_dosage',medicationItem.Medication_Dosage__c);
                if (medicationItem.Medication_Frequency__c != null) medication.put('medication_frequency',medicationItem.Medication_Frequency__c);
                if (medicationItem.Medication_Name__c != null) medication.put('medication_name',medicationItem.Medication_Name__c);
                if (medicationItem.Medication_Route__c != null) medication.put('medication_route',medicationItem.Medication_Route__c);
                medicationItems.add(medication);
              }
              assessment.put('multiple_medications_group',JSON.serialize(medicationItems));
            }

            //Medicine Line TCH
            List<String> tchMedicationLineFields = new List<String>(Medication_Line_TCH__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlMedicationLineTCH = '' + ' SELECT ' + String.join(tchMedicationLineFields, ',') + ' from Medication_Line_TCH__c' + ' where Assessment_TCH__c = \'' + assessmentTCH.Id + '\'';
            List<Map<String,String>> medicationLineItems = new List<Map<String,String>>();
            Medication_Line_TCH__c[] multiple_line_group = database.query(soqlMedicationLineTCH);
            if (multiple_line_group.size() > 0) {
              for (Medication_Line_TCH__c medicationLineItem : multiple_line_group) {
                Map<String,String> medicationLine = new Map<String,String>();
                if (medicationLineItem.App_Timestamp__c != null) medicationLine.put('app_timestamp',medicationLineItem.App_Timestamp__c);
                if (medicationLineItem.Line_Insertion_Date__c != null) medicationLine.put('line_insertion_date',medicationLineItem.Line_Insertion_Date__c.format());
                if (medicationLineItem.Line_CL_Type__c != null) medicationLine.put('line_cl_type',medicationLineItem.Line_CL_Type__c);
                if (medicationLineItem.Line_Location__c != null) medicationLine.put('line_location',medicationLineItem.Line_Location__c);
                medicationLineItems.add(medicationLine);
              }
              assessment.put('multiple_line_group',JSON.serialize(medicationLineItems));
            }
            
            //Integumentary TCH
            List<String> tchIntegumentaryFields = new List<String>(Integumentary_TCH__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlIntegumentaryTCH = '' + ' SELECT ' + String.join(tchIntegumentaryFields, ',') + ' from Integumentary_TCH__c' + ' where Assessment_TCH__c = \'' + assessmentTCH.Id + '\'';
            List<Map<String,String>> integumentaryItems = new List<Map<String,String>>();
            Integumentary_TCH__c[] itegumentary_mutable_group = database.query(soqlIntegumentaryTCH);
            if (itegumentary_mutable_group.size() > 0) {
              for (Integumentary_TCH__c integumentaryItem : itegumentary_mutable_group) {
                Map<String,String> integumentary = new Map<String,String>();
                if (integumentaryItem.App_Timestamp__c != null) integumentary.put('app_timestamp',integumentaryItem.App_Timestamp__c);
                if (integumentaryItem.Skin_Item_Comments__c != null) integumentary.put('integ_skin_item_comments',integumentaryItem.Skin_Item_Comments__c);
                if (integumentaryItem.Skin_Item_Site__c != null) integumentary.put('skin_item_site',integumentaryItem.Skin_Item_Site__c);
                if (integumentaryItem.Skin_Item_Stage__c != null) integumentary.put('skin_item_stage',integumentaryItem.Skin_Item_Stage__c);
                if (integumentaryItem.Skin_Item_Stage_Size__c != null) integumentary.put('skin_item_stage_size',integumentaryItem.Skin_Item_Stage_Size__c);             
                integumentaryItems.add(integumentary);
              }
              assessment.put('itegumentary_mutable_group',JSON.serialize(integumentaryItems));
            }
            
            //Contacts TCH
            List<String> tchContactFields = new List<String>(Contact_TCH__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlContactTCH = '' + ' SELECT ' + String.join(tchContactFields, ',') + ' from Contact_TCH__c' + ' where Assessment_TCH__c = \'' + assessmentTCH.Id + '\'';
            List<Map<String,String>> contacts = new List<Map<String,String>>();
            Contact_TCH__c[] variable_contact_group = database.query(soqlContactTCH);
            if (variable_contact_group.size() > 0) {
              for (Contact_TCH__c contactItem : variable_contact_group) {
                Map<String,String> contact = new Map<String,String>();
                if (contactItem.App_Timestamp__c != null) contact.put('app_timestamp',contactItem.App_Timestamp__c);
                if (contactItem.Contact_Address__c != null) contact.put('contact_address',contactItem.Contact_Address__c);
                if (contactItem.Contact_First_Name__c != null) contact.put('patient_contact_first_name',contactItem.Contact_First_Name__c);
                if (contactItem.Contact_Relationship__c != null) contact.put('contact_relationship',contactItem.Contact_Relationship__c);
                if (contactItem.Contact_Last_Name__c != null) contact.put('patient_contact_last_name',contactItem.Contact_Last_Name__c);
                if (contactItem.Contact_Type__c != null) contact.put('contact_type',contactItem.Contact_Type__c);
                if (contactItem.Contact_State__c != null) contact.put('contact_state',contactItem.Contact_State__c);
                if (contactItem.Contact_City__c != null) contact.put('contact_city',contactItem.Contact_City__c);
                if (contactItem.Contact_Primary_Phone__c != null) contact.put('patient_contact_phone',contactItem.Contact_Primary_Phone__c);
                if (contactItem.Contact_Postal_Code__c != null) contact.put('contact_postal_code',contactItem.Contact_Postal_Code__c);
                if (contactItem.Contact_Cell_Phone__c != null) contact.put('contact_cell_phone',contactItem.Contact_Cell_Phone__c);
                if (contactItem.Contact_Alternative_Phone__c != null) contact.put('contact_alternate_phone',contactItem.Contact_Alternative_Phone__c);
                if (contactItem.Contact_Email_Address__c != null) contact.put('contact_email_address',contactItem.Contact_Email_Address__c);                
                contacts.add(contact);
              }
              assessment.put('variable_contact_group',JSON.serialize(contacts));
            }

            //Cultures TCH
            List<String> tchCultureFields = new List<String>(Culture_TCH__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlCultureTCH = '' + ' SELECT ' + String.join(tchCultureFields, ',') + ' from Culture_TCH__c' + ' where Assessment_TCH__c = \'' + assessmentTCH.Id + '\'';
            List<Map<String,String>> cultures = new List<Map<String,String>>();
            Culture_TCH__c[] culture_history_mutable_group = database.query(soqlCultureTCH);
            if (culture_history_mutable_group.size() > 0) {
              for (Culture_TCH__c cultureItem : culture_history_mutable_group) {
                Map<String,String> culture = new Map<String,String>();
                if (cultureItem.App_Timestamp__c != null) culture.put('app_timestamp',cultureItem.App_Timestamp__c);
                if (cultureItem.Culture_Date__c != null) culture.put('culture_date',cultureItem.Culture_Date__c.format());
                if (cultureItem.Culture_IV_Antibiotic__c != null) culture.put('culture_iv_antibiotic',cultureItem.Culture_IV_Antibiotic__c);
                if (cultureItem.Culture_Organism__c != null) culture.put('culture_organism',cultureItem.Culture_Organism__c);
                if (cultureItem.Culture_Site__c != null) culture.put('culture_site',cultureItem.Culture_Site__c);
                if (cultureItem.Culture_Start_Date__c != null) culture.put('culture_start_date',cultureItem.Culture_Start_Date__c.format());
                if (cultureItem.Culture_Stop_Date__c != null) culture.put('culture_stop_date',cultureItem.Culture_Stop_Date__c.format());
                cultures.add(culture);
              }
              assessment.put('culture_history_mutable_group',JSON.serialize(cultures));
            }
            
            //TCH Fields
            if (assessmentTCH.Actively_Managed_Comorbidities__c != null) assessment.put('actively_managed_comorbidities', assessmentTCH.Actively_Managed_Comorbidities__c);
            if (assessmentTCH.Additional_Integumentary_Details__c != null) assessment.put('skin_item_comments', assessmentTCH.Additional_Integumentary_Details__c);            
            if (assessmentTCH.Addl_Referring_Facility_Course_Summary__c != null) assessment.put('additional_referring_facility_course_summary', assessmentTCH.Addl_Referring_Facility_Course_Summary__c);
            if (assessmentTCH.Current_Or_New_Problems__c != null) assessment.put('information_current_new_problems', assessmentTCH.Current_Or_New_Problems__c);
            if (assessmentTCH.New_Surgery_Or_Intervention_Identify__c != null) assessment.put('information_identify', assessmentTCH.New_Surgery_Or_Intervention_Identify__c);
            if (assessmentTCH.Kindred_Initial_Diagnosis__c != null) assessment.put('information_kindred_diagnostics', assessmentTCH.Kindred_Initial_Diagnosis__c);
            if (assessmentTCH.New_Consults__c != null) assessment.put('information_new_consultants', assessmentTCH.New_Consults__c);
            if (assessmentTCH.New_Surgery_Or_Intervention__c != null) assessment.put('information_new_surgery', assessmentTCH.New_Surgery_Or_Intervention__c);
            if (assessmentTCH.Reassessment_Date__c != null) assessment.put('information_reassessment_date', assessmentTCH.Reassessment_Date__c.format());
            if (assessmentTCH.Patient_Demographics_Admit_Date__c != null) assessment.put('patient_demographics_admit_date', assessmentTCH.Patient_Demographics_Admit_Date__c.format());
            if (assessmentTCH.Patient_Demographics_Referral_Date__c != null) assessment.put('patient_demographics_referral_date', assessmentTCH.Patient_Demographics_Referral_Date__c.format());
            if (assessmentTCH.Patient_First_Name__c != null) assessment.put('patient_first_name', assessmentTCH.Patient_First_Name__c);
            if (assessmentTCH.Patient_Middle_Name_Initial__c != null) assessment.put('patient_middle_name_initial', assessmentTCH.Patient_Middle_Name_Initial__c);
            if (assessmentTCH.Patient_Last_Name__c != null) assessment.put('patient_last_name', assessmentTCH.Patient_Last_Name__c);
            if (assessmentTCH.Patient_Name_Suffix__c != null) assessment.put('patient_name_suffix', assessmentTCH.Patient_Name_Suffix__c);
            if (assessmentTCH.Patient_Address__c != null) assessment.put('patient_address', assessmentTCH.Patient_Address__c);
            if (assessmentTCH.Patient_City__c != null) assessment.put('patient_city', assessmentTCH.Patient_City__c);
            if (assessmentTCH.Patient_State__c != null) assessment.put('patient_state', assessmentTCH.Patient_State__c);
            if (assessmentTCH.Patient_Postal_Code__c != null) assessment.put('patient_postal_code', assessmentTCH.Patient_Postal_Code__c);
            if (assessmentTCH.Patient_Social_Security_Number__c != null) assessment.put('patient_social_security_number', assessmentTCH.Patient_Social_Security_Number__c);
            if (assessmentTCH.Patient_Date_Of_Birth__c != null) assessment.put('patient_date_of_birth', assessmentTCH.Patient_Date_Of_Birth__c.format());
            if (assessmentTCH.Patient_Cell_Phone__c != null) assessment.put('patient_cell_phone', assessmentTCH.Patient_Cell_Phone__c);
            if (assessmentTCH.Patient_Primary_Phone__c != null) assessment.put('patient_primary_phone', assessmentTCH.Patient_Primary_Phone__c);
            if (assessmentTCH.Patient_Alternate_Phone__c != null) assessment.put('patient_alternate_phone', assessmentTCH.Patient_Alternate_Phone__c);
            if (assessmentTCH.Patient_Email__c != null) assessment.put('patient_email_address', assessmentTCH.Patient_Email__c);
            if (assessmentTCH.Patient_Gender__c != null) assessment.put('patient_gender', assessmentTCH.Patient_Gender__c);
            if (assessmentTCH.Patient_Ethnicity__c != null) assessment.put('patient_ethnicity', assessmentTCH.Patient_Ethnicity__c);
            if (assessmentTCH.Tribal_Affiliations__c != null) assessment.put('tribal_affiliations', assessmentTCH.Tribal_Affiliations__c);
            if (assessmentTCH.Patient_Language__c != null) assessment.put('patient_language', assessmentTCH.Patient_Language__c);
            if (assessmentTCH.Patient_Religion__c != null) assessment.put('patient_religion', assessmentTCH.Patient_Religion__c);
            if (assessmentTCH.Patient_Marital_Status__c != null) assessment.put('patient_marital_status', assessmentTCH.Patient_Marital_Status__c);
            if (assessmentTCH.Patient_Living_Will__c != null) assessment.put('patient_living_will', assessmentTCH.Patient_Living_Will__c);
            if (assessmentTCH.Advance_Directives__c != null) assessment.put('advance_directives', assessmentTCH.Advance_Directives__c);
            if (assessmentTCH.Patient_Able_To_Sign_Consent__c != null) assessment.put('patient_able_to_sign_consent', assessmentTCH.Patient_Able_To_Sign_Consent__c);
            if (assessmentTCH.Consent_Signed_By__c != null) assessment.put('consent_signed_by', assessmentTCH.Consent_Signed_By__c);
            if (assessmentTCH.Code_Status__c != null) assessment.put('code_status', assessmentTCH.Code_Status__c);
            if (assessmentTCH.Referral_Source_Type__c != null) assessment.put('referral_source_type', assessmentTCH.Referral_Source_Type__c);
            if (assessmentTCH.Referral_Location_Phone__c != null) assessment.put('referral_location_phone', assessmentTCH.Referral_Location_Phone__c);
            if (assessmentTCH.Referral_Address__c != null) assessment.put('referral_address', assessmentTCH.Referral_Address__c);
            if (assessmentTCH.Referral_City__c != null) assessment.put('referral_city', assessmentTCH.Referral_City__c);
            if (assessmentTCH.Referral_State__c != null) assessment.put('referral_state', assessmentTCH.Referral_State__c);
            if (assessmentTCH.Referral_Postal_Code__c != null) assessment.put('referral_postal_code', assessmentTCH.Referral_Postal_Code__c);
            if (assessmentTCH.Referral_Contact_Phone__c != null) assessment.put('referring_contact_phone', assessmentTCH.Referral_Contact_Phone__c);
            if (assessmentTCH.Referral_Alt_Phone__c != null) assessment.put('referral_contact_alternate_phone', assessmentTCH.Referral_Alt_Phone__c);
            if (assessmentTCH.Referral_Physician_Phone__c != null) assessment.put('referral_physician_phone_number', assessmentTCH.Referral_Physician_Phone__c);
            if (assessmentTCH.Patient_Physically_Seen__c != null) assessment.put('patient_physically_seen', assessmentTCH.Patient_Physically_Seen__c);
            if (assessmentTCH.Family_Contacted__c != null) assessment.put('family_contacted', assessmentTCH.Family_Contacted__c);
            if (assessmentTCH.Kindred_Plan_Of_Discharge_Discussed__c != null) assessment.put('kindred_plan_of_discharge_discussed', assessmentTCH.Kindred_Plan_Of_Discharge_Discussed__c);
            if (assessmentTCH.Extraordinary_Needs_Info_About_Patient__c != null) assessment.put('extraordinary_needs_info_about_patient', assessmentTCH.Extraordinary_Needs_Info_About_Patient__c);
            if (assessmentTCH.Nursing_Unit_Type__c != null) assessment.put('nursing_unit_type', assessmentTCH.Nursing_Unit_Type__c);
            if (assessmentTCH.Nursing_Unit_Name__c != null) assessment.put('nursing_unit_name', assessmentTCH.Nursing_Unit_Name__c);
            if (assessmentTCH.Nursing_Unit_Number__c != null) assessment.put('nursing_unit_number', assessmentTCH.Nursing_Unit_Number__c);
            if (assessmentTCH.Present_Nursing_Unit_Room_Number__c != null) assessment.put('present_nursing_unit_room_number', assessmentTCH.Present_Nursing_Unit_Room_Number__c);
            if (assessmentTCH.Current_Admission_Date__c != null) assessment.put('current_admit_date', assessmentTCH.Current_Admission_Date__c.format());
            if (assessmentTCH.Nursing_Unit_Phone__c != null) assessment.put('nursing_unit_phone', assessmentTCH.Nursing_Unit_Phone__c);
            if (assessmentTCH.ICU_Dates_Required__c != null) assessment.put('icu_dates_required', assessmentTCH.ICU_Dates_Required__c);
            if (assessmentTCH.ICU_Date1__c != null) assessment.put('icu_date1', assessmentTCH.ICU_Date1__c.format());
            if (assessmentTCH.ICU_Date2__c != null) assessment.put('icu_date2', assessmentTCH.ICU_Date2__c.format());
            if (assessmentTCH.ICU_Date3__c != null) assessment.put('icu_date3', assessmentTCH.ICU_Date3__c.format());
            if (assessmentTCH.ICU_Date4__c != null) assessment.put('icu_date4', assessmentTCH.ICU_Date4__c.format());
            if (assessmentTCH.CCU_Dates_Required__c != null) assessment.put('ccu_dates_required', assessmentTCH.CCU_Dates_Required__c);
            if (assessmentTCH.CCU_Date1__c != null) assessment.put('ccu_date1', assessmentTCH.CCU_Date1__c.format());
            if (assessmentTCH.CCU_Date2__c != null) assessment.put('ccu_date2', assessmentTCH.CCU_Date2__c.format());
            if (assessmentTCH.CCU_Date3__c != null) assessment.put('ccu_date3', assessmentTCH.CCU_Date3__c.format());
            if (assessmentTCH.CCU_Date4__c != null) assessment.put('ccu_date4', assessmentTCH.CCU_Date4__c.format());
            if (assessmentTCH.Step_Down_Dates_Required__c != null) assessment.put('step_down_dates_required', assessmentTCH.Step_Down_Dates_Required__c);
            if (assessmentTCH.Stepdown_Date1__c != null) assessment.put('stepdown_date1', assessmentTCH.Stepdown_Date1__c.format());
            if (assessmentTCH.Stepdown_Date2__c != null) assessment.put('stepdown_date2', assessmentTCH.Stepdown_Date2__c.format());
            if (assessmentTCH.Stepdown_Date3__c != null) assessment.put('stepdown_date3', assessmentTCH.Stepdown_Date3__c.format());
            if (assessmentTCH.Stepdown_Date4__c != null) assessment.put('stepdown_date4', assessmentTCH.Stepdown_Date4__c.format());
            if (assessmentTCH.Financial_Approval_Per_CFO_Designee__c != null) assessment.put('financial_approval_per_cfo_designee', assessmentTCH.Financial_Approval_Per_CFO_Designee__c);
            if (assessmentTCH.Primary_Payer_Source__c != null) assessment.put('primary_payer_source', assessmentTCH.Primary_Payer_Source__c);
            if (assessmentTCH.Primary_Insurance_Id__c != null) assessment.put('primary_insurance_id', assessmentTCH.Primary_Insurance_Id__c);
            if (assessmentTCH.Pre_Cert_Needed_Primary__c != null) assessment.put('pre_cert_needed_primary', assessmentTCH.Pre_Cert_Needed_Primary__c);
            if (assessmentTCH.Primary_Insurance_Copy__c != null) assessment.put('primary_insurance_copy', assessmentTCH.Primary_Insurance_Copy__c);
            if (assessmentTCH.Primary_Insurance_Name__c != null) assessment.put('primary_insurance_name', assessmentTCH.Primary_Insurance_Name__c);
            if (assessmentTCH.Primary_HIC__c != null) assessment.put('primary_hic', assessmentTCH.Primary_HIC__c);
            if (assessmentTCH.Secondary_Payer_Source__c != null) assessment.put('secondary_payer_source', assessmentTCH.Secondary_Payer_Source__c);
            if (assessmentTCH.Secondary_Insurance_Id__c != null) assessment.put('secondary_insurance_id', assessmentTCH.Secondary_Insurance_Id__c);
            if (assessmentTCH.Pre_Cert_Needed_Secondary__c != null) assessment.put('pre_cert_needed_secondary', assessmentTCH.Pre_Cert_Needed_Secondary__c);
            if (assessmentTCH.Secondary_Insurance_Copy__c != null) assessment.put('secondary_insurance_copy', assessmentTCH.Secondary_Insurance_Copy__c);
            if (assessmentTCH.Secondary_Insurance_Name__c != null) assessment.put('secondary_insurance_name', assessmentTCH.Secondary_Insurance_Name__c);
            if (assessmentTCH.Secondary_HIC__c != null) assessment.put('secondary_hic', assessmentTCH.Secondary_HIC__c);
            if (assessmentTCH.Employer_Name__c != null) assessment.put('employer_name', assessmentTCH.Employer_Name__c);
            if (assessmentTCH.Employer_Group__c != null) assessment.put('employer_group_name', assessmentTCH.Employer_Group__c);
            if (assessmentTCH.Employer_Phone__c != null) assessment.put('employer_phone_number', assessmentTCH.Employer_Phone__c);
            if (assessmentTCH.Employment_Status__c != null) assessment.put('employment_status', assessmentTCH.Employment_Status__c);
            if (assessmentTCH.Prior_Hospitalization_Start__c != null) assessment.put('prior_hospitalization_start', assessmentTCH.Prior_Hospitalization_Start__c.format());
            if (assessmentTCH.Prior_Hospitalization_End__c != null) assessment.put('prior_hospitalization_end', assessmentTCH.Prior_Hospitalization_End__c.format());
            if (assessmentTCH.Prior_SNF_Start__c != null) assessment.put('prior_snf_start', assessmentTCH.Prior_SNF_Start__c.format());
            if (assessmentTCH.Prior_SNF_End__c != null) assessment.put('prior_snf_end', assessmentTCH.Prior_SNF_End__c.format());
            if (assessmentTCH.SNF_Days_Remaining__c != null) assessment.put('snf_days_remaining', assessmentTCH.SNF_Days_Remaining__c);
            if (assessmentTCH.IP_Days_Remaining__c != null) assessment.put('ip_days_remaining', assessmentTCH.IP_Days_Remaining__c);
            if (assessmentTCH.Medicaid_Start__c != null) assessment.put('medicaid_start', assessmentTCH.Medicaid_Start__c.format());
            if (assessmentTCH.Medicaid_Member_Id__c != null) assessment.put('medicaid_member_id', assessmentTCH.Medicaid_Member_Id__c);
            if (assessmentTCH.Medicaid_Authorization_Number__c != null) assessment.put('medicaid_authorization_number', assessmentTCH.Medicaid_Authorization_Number__c);
            if (assessmentTCH.Medicaid_Contact_Name__c != null) assessment.put('medicaid_contact_name', assessmentTCH.Medicaid_Contact_Name__c);
            if (assessmentTCH.Medicaid_Contact_Phone__c != null) assessment.put('medicaid_contact_phone', assessmentTCH.Medicaid_Contact_Phone__c);
            if (assessmentTCH.Mgmt_Group_Name__c != null) assessment.put('mgmt_group_name', assessmentTCH.Mgmt_Group_Name__c);
            if (assessmentTCH.Mgmt_Group_Phone__c != null) assessment.put('mgmt_group_phone', assessmentTCH.Mgmt_Group_Phone__c);
            if (assessmentTCH.Third_Party_Admin_Name__c != null) assessment.put('third_party_admin_name', assessmentTCH.Third_Party_Admin_Name__c);
            if (assessmentTCH.Third_Party_Admin_Phone__c != null) assessment.put('third_party_admin_phone', assessmentTCH.Third_Party_Admin_Phone__c);
            if (assessmentTCH.Physiological_Date__c != null) assessment.put('physiological_date', assessmentTCH.Physiological_Date__c.format());
            if (assessmentTCH.Physiological_Temp__c != null) assessment.put('physiological_temp', assessmentTCH.Physiological_Temp__c);
            if (assessmentTCH.Physiological_SBP__c != null) assessment.put('physiological_sbp', assessmentTCH.Physiological_SBP__c);
            if (assessmentTCH.Physiological_DBP__c != null) assessment.put('physiological_dbp', assessmentTCH.Physiological_DBP__c);
            if (assessmentTCH.Physiological_HR__c != null) assessment.put('physiological_hr', assessmentTCH.Physiological_HR__c);
            if (assessmentTCH.Physiological_RR__c != null) assessment.put('physiological_rr', assessmentTCH.Physiological_RR__c);
            if (assessmentTCH.Physiological_State__c != null) assessment.put('physiological_state', assessmentTCH.Physiological_State__c);
            if (assessmentTCH.Prior_Living_Arrangements__c != null) assessment.put('prior_living_arrangements', assessmentTCH.Prior_Living_Arrangements__c);
            if (assessmentTCH.Prior_Living_Additional_Details__c != null) assessment.put('prior_living_arrangements_addition_details', assessmentTCH.Prior_Living_Additional_Details__c);
            if (assessmentTCH.Lives_With__c != null) assessment.put('lives_with', assessmentTCH.Lives_With__c);
            if (assessmentTCH.Lives_With_Additional_Details__c != null) assessment.put('lives_with_additional_details', assessmentTCH.Lives_With_Additional_Details__c);
            if (assessmentTCH.Plan_To_Return__c != null) assessment.put('plan_to_return', assessmentTCH.Plan_To_Return__c);
            if (assessmentTCH.Plan_Of_Discharge__c != null) assessment.put('plan_of_discharge', assessmentTCH.Plan_Of_Discharge__c);
            if (assessmentTCH.Plan_Of_Discharge_Additional_Details__c != null) assessment.put('plan_of_discharge_additional_details', assessmentTCH.Plan_Of_Discharge_Additional_Details__c);
            if (assessmentTCH.Family_Dynamics_Coping__c != null) assessment.put('family_dynamics_coping', assessmentTCH.Family_Dynamics_Coping__c);
            if (assessmentTCH.Psychosis__c != null) assessment.put('psychosis', assessmentTCH.Psychosis__c);
            if (assessmentTCH.Psychosis_Additional_Details__c != null) assessment.put('psychosis_additional_details', assessmentTCH.Psychosis_Additional_Details__c);
            if (assessmentTCH.Personality_Disorder__c != null) assessment.put('personality_disorder', assessmentTCH.Personality_Disorder__c);
            if (assessmentTCH.Personality_Disorder_Additional_Details__c != null) assessment.put('personality_disorder_additional_details', assessmentTCH.Personality_Disorder_Additional_Details__c);
            if (assessmentTCH.Psych_Retardation__c != null) assessment.put('psych_retardation', assessmentTCH.Psych_Retardation__c);
            if (assessmentTCH.Psych_Retardation_Additional_Details__c != null) assessment.put('psych_retardation_additional_details', assessmentTCH.Psych_Retardation_Additional_Details__c);
            if (assessmentTCH.Psych_Social_Behavior__c != null) assessment.put('psych_social_behavior', assessmentTCH.Psych_Social_Behavior__c);
            if (assessmentTCH.Psych_Social_Meds__c != null) assessment.put('psych_social_meds', assessmentTCH.Psych_Social_Meds__c);
            if (assessmentTCH.Other_Psychoactive_Meds_Details__c != null) assessment.put('other_psychoactive_meds_details', assessmentTCH.Other_Psychoactive_Meds_Details__c);
            if (assessmentTCH.Risk_Of_Injury__c != null) assessment.put('risk_of_injury', assessmentTCH.Risk_Of_Injury__c);
            if (assessmentTCH.Risk_Of_Injury_Additional_Details__c != null) assessment.put('risk_of_injury_additional_details', assessmentTCH.Risk_Of_Injury_Additional_Details__c);
            if (assessmentTCH.History_Of_Incarceration__c != null) assessment.put('history_of_incarceration', assessmentTCH.History_Of_Incarceration__c);
            if (assessmentTCH.History_Of_Incarceration_Details__c != null) assessment.put('history_of_incarceration_additional_details', assessmentTCH.History_Of_Incarceration_Details__c);
            if (assessmentTCH.Risk_Of_Elopement__c != null) assessment.put('risk_of_elopement', assessmentTCH.Risk_Of_Elopement__c);
            if (assessmentTCH.Risk_Of_Elopement_Additional_Details__c != null) assessment.put('risk_of_elopement_additional_details', assessmentTCH.Risk_Of_Elopement_Additional_Details__c);
            if (assessmentTCH.History_Of_Restraints__c != null) assessment.put('restraints', assessmentTCH.History_Of_Restraints__c);
            if (assessmentTCH.Current_Restraints__c != null) assessment.put('current_restraints', assessmentTCH.Current_Restraints__c);
            if (assessmentTCH.Restraints_Type__c != null) assessment.put('restraints_type', assessmentTCH.Restraints_Type__c);
            if (assessmentTCH.Restraints_Type_Additional_Details__c != null) assessment.put('restraints_type_additional_details', assessmentTCH.Restraints_Type_Additional_Details__c);
            if (assessmentTCH.Additional_Psych_Social_Details__c != null) assessment.put('additional_psych_social_details', assessmentTCH.Additional_Psych_Social_Details__c);
            if (assessmentTCH.GCS_Eyes_Open__c != null) assessment.put('gcs_eyes_open', assessmentTCH.GCS_Eyes_Open__c);
            if (assessmentTCH.GCS_Motor_Response__c != null) assessment.put('motor_response', assessmentTCH.GCS_Motor_Response__c);
            if (assessmentTCH.GCS_Verbal_Response__c != null) assessment.put('verbal_response', assessmentTCH.GCS_Verbal_Response__c);
            if (assessmentTCH.GC_Meds__c != null) assessment.put('gc_meds', assessmentTCH.GC_Meds__c);
            if (assessmentTCH.Additional_Neurological_Details__c != null) assessment.put('additional_neurological_details', assessmentTCH.Additional_Neurological_Details__c);
            if (assessmentTCH.Neurological_Info_Date__c != null) assessment.put('neurological_info_date', assessmentTCH.Neurological_Info_Date__c.format());
            if (assessmentTCH.Dialysis__c != null) assessment.put('dialysis', assessmentTCH.Dialysis__c);
            if (assessmentTCH.Dialysis_Information_Type__c != null) assessment.put('dialysis_information_type', assessmentTCH.Dialysis_Information_Type__c);
            if (assessmentTCH.Dialysis_Modality__c != null) assessment.put('dialysis_modality', assessmentTCH.Dialysis_Modality__c);
            if (assessmentTCH.Dialysis_Started_At_STAC__c != null) assessment.put('dialysis_started_at_stac', assessmentTCH.Dialysis_Started_At_STAC__c);
            if (assessmentTCH.Dialysis_Location_Of_Initial__c != null) assessment.put('dialysis_location_of_initial', assessmentTCH.Dialysis_Location_Of_Initial__c);
            if (assessmentTCH.Dialysis_Hep_B_Panel_Date__c != null) assessment.put('dialysis_hepb_panel_date', assessmentTCH.Dialysis_Hep_B_Panel_Date__c.format());
            if (assessmentTCH.Dialysis_Date_Of_Initial__c != null) assessment.put('dialysis_date_of_initial', assessmentTCH.Dialysis_Date_Of_Initial__c.format());
            if (assessmentTCH.Dialysis_Hep_B_Core_Antibody__c != null) assessment.put('dialysis_hepb_core_antibody', assessmentTCH.Dialysis_Hep_B_Core_Antibody__c);
            if (assessmentTCH.Dialysis_Hep_B_Surface_Antigen__c != null) assessment.put('dialysis_hepb_surface_antigen', assessmentTCH.Dialysis_Hep_B_Surface_Antigen__c);
            if (assessmentTCH.Dialysis_Hep_B_Surface_Antibody__c != null) assessment.put('dialysis_hepb_surface_antibody', assessmentTCH.Dialysis_Hep_B_Surface_Antibody__c);
            if (assessmentTCH.Dialysis_Information_Schedule__c != null) assessment.put('dialysis_schedule', assessmentTCH.Dialysis_Information_Schedule__c);
            if (assessmentTCH.Dialysis_Information_Schedule_Specify__c != null) assessment.put('dialysis_information_schedule_specify', assessmentTCH.Dialysis_Information_Schedule_Specify__c);
            if (assessmentTCH.Dialysis_Information_Access__c != null) assessment.put('dialysis_access', assessmentTCH.Dialysis_Information_Access__c);
            if (assessmentTCH.Dialysis_Comment__c != null) assessment.put('fistula_comment', assessmentTCH.Dialysis_Comment__c);
            if (assessmentTCH.WBC_Date__c != null) assessment.put('wbc_date', assessmentTCH.WBC_Date__c.format());
            if (assessmentTCH.WBC_Value__c != null) assessment.put('wbc_value', assessmentTCH.WBC_Value__c);
            if (assessmentTCH.RBC_Date__c != null) assessment.put('rbc_date', assessmentTCH.RBC_Date__c.format());
            if (assessmentTCH.RBC_Value__c != null) assessment.put('rbc_value', assessmentTCH.RBC_Value__c);
            if (assessmentTCH.Hemoglobin_Date__c != null) assessment.put('hemoglobin_date', assessmentTCH.Hemoglobin_Date__c.format());
            if (assessmentTCH.Hemoglobin_Value__c != null) assessment.put('hemoglobin_value', assessmentTCH.Hemoglobin_Value__c);
            if (assessmentTCH.Hematocrit_Date__c != null) assessment.put('hematocrit_date', assessmentTCH.Hematocrit_Date__c.format());
            if (assessmentTCH.Hematocrit_Value__c != null) assessment.put('hematocrit_value', assessmentTCH.Hematocrit_Value__c);
            if (assessmentTCH.Platelets_Date__c != null) assessment.put('platelets_date', assessmentTCH.Platelets_Date__c.format());
            if (assessmentTCH.Platelets_Value__c != null) assessment.put('platelets_value', assessmentTCH.Platelets_Value__c);
            if (assessmentTCH.Sodium_Date__c != null) assessment.put('sodium_date', assessmentTCH.Sodium_Date__c.format());
            if (assessmentTCH.Sodium_Value__c != null) assessment.put('sodium_value', assessmentTCH.Sodium_Value__c);
            if (assessmentTCH.Potassium_Date__c != null) assessment.put('potassium_date', assessmentTCH.Potassium_Date__c.format());
            if (assessmentTCH.Potassium_Value__c != null) assessment.put('potassium_value', assessmentTCH.Potassium_Value__c);
            if (assessmentTCH.Chloride_Date__c != null) assessment.put('chloride_date', assessmentTCH.Chloride_Date__c.format());
            if (assessmentTCH.Chloride_Value__c != null) assessment.put('chloride_value', assessmentTCH.Chloride_Value__c);
            if (assessmentTCH.CO2_Date__c != null) assessment.put('co2_date', assessmentTCH.CO2_Date__c.format());
            if (assessmentTCH.CO2_Value__c != null) assessment.put('co2_value', assessmentTCH.CO2_Value__c);
            if (assessmentTCH.BUN_Date__c != null) assessment.put('bun_date', assessmentTCH.BUN_Date__c.format());
            if (assessmentTCH.BUN_Value__c != null) assessment.put('bun_value', assessmentTCH.BUN_Value__c);
            if (assessmentTCH.Creatinine_Date__c != null) assessment.put('creatinine_date', assessmentTCH.Creatinine_Date__c.format());
            if (assessmentTCH.Creatinine_Value__c != null) assessment.put('creatinine_value', assessmentTCH.Creatinine_Value__c);
            if (assessmentTCH.Glucose_Date__c != null) assessment.put('glucose_date', assessmentTCH.Glucose_Date__c.format());
            if (assessmentTCH.Glucose_Value_Low__c != null) assessment.put('glucose_value_low', assessmentTCH.Glucose_Value_Low__c);
            if (assessmentTCH.Glucose_Value_High__c != null) assessment.put('glucose_value_high', assessmentTCH.Glucose_Value_High__c);
            if (assessmentTCH.Magnesium_Date__c != null) assessment.put('magnesium_date', assessmentTCH.Magnesium_Date__c.format());
            if (assessmentTCH.Magnesium_Value__c != null) assessment.put('magnesium_value', assessmentTCH.Magnesium_Value__c);
            if (assessmentTCH.Albumin_Date__c != null) assessment.put('albumin_date', assessmentTCH.Albumin_Date__c.format());
            if (assessmentTCH.Albumin_Value__c != null) assessment.put('albumin_value', assessmentTCH.Albumin_Value__c);
            if (assessmentTCH.PreAlb_Date__c != null) assessment.put('prealb_date', assessmentTCH.PreAlb_Date__c.format());
            if (assessmentTCH.PreAlb_Value__c != null) assessment.put('prealb_value', assessmentTCH.PreAlb_Value__c);
            if (assessmentTCH.Bilirubin_Date__c != null) assessment.put('bilrubin_date', assessmentTCH.Bilirubin_Date__c.format());
            if (assessmentTCH.Bilirubin_Value__c != null) assessment.put('bilrubin_value', assessmentTCH.Bilirubin_Value__c);
            if (assessmentTCH.PT_Date__c != null) assessment.put('pt_date', assessmentTCH.PT_Date__c.format());
            if (assessmentTCH.PT_Value__c != null) assessment.put('pt_value', assessmentTCH.PT_Value__c);
            if (assessmentTCH.PTT_Date__c != null) assessment.put('ptt_date', assessmentTCH.PTT_Date__c.format());
            if (assessmentTCH.PTT_Value__c != null) assessment.put('ptt_value', assessmentTCH.PTT_Value__c);
            if (assessmentTCH.INR_Date__c != null) assessment.put('inr_date', assessmentTCH.INR_Date__c.format());
            if (assessmentTCH.INR_Value__c != null) assessment.put('inr_value', assessmentTCH.INR_Value__c);
            if (assessmentTCH.Other_Lab_1_Name__c != null) assessment.put('other_1_name', assessmentTCH.Other_Lab_1_Name__c);
            if (assessmentTCH.Other_Lab_1_Date__c != null) assessment.put('other_1_date', assessmentTCH.Other_Lab_1_Date__c.format());
            if (assessmentTCH.Other_Lab_1_Value__c != null) assessment.put('other_1_value', assessmentTCH.Other_Lab_1_Value__c);
            if (assessmentTCH.Other_Lab_2_Name__c != null) assessment.put('other_2_name', assessmentTCH.Other_Lab_2_Name__c);
            if (assessmentTCH.Other_Lab_2_Date__c != null) assessment.put('other_2_date', assessmentTCH.Other_Lab_2_Date__c.format());
            if (assessmentTCH.Other_Lab_2_Value__c != null) assessment.put('other_2_value', assessmentTCH.Other_Lab_2_Value__c);
            if (assessmentTCH.Blood_Product_Given__c != null) assessment.put('blood_product_given', assessmentTCH.Blood_Product_Given__c);
            if (assessmentTCH.Blood_Product_Type__c != null) assessment.put('blood_product_type', assessmentTCH.Blood_Product_Type__c);
            if (assessmentTCH.Blood_Product_Last_Date__c != null) assessment.put('blood_product_last_date', assessmentTCH.Blood_Product_Last_Date__c.format());
            if (assessmentTCH.Current_Precautions__c != null) assessment.put('current_precautions', assessmentTCH.Current_Precautions__c);
            if (assessmentTCH.Infectious_Disease_History__c != null) assessment.put('infectious_disease_history', assessmentTCH.Infectious_Disease_History__c);
            if (assessmentTCH.Organism_History_TB__c != null) assessment.put('organism_history_tb', assessmentTCH.Organism_History_TB__c);
            if (assessmentTCH.Organism_History_TB_Status__c != null) assessment.put('organism_history_tb_status', assessmentTCH.Organism_History_TB_Status__c);
            if (assessmentTCH.Organism_History_CDiff__c != null) assessment.put('organism_history_cdiff', assessmentTCH.Organism_History_CDiff__c);
            if (assessmentTCH.Organism_History_CDiff_Status__c != null) assessment.put('organism_history_cdiff_status', assessmentTCH.Organism_History_CDiff_Status__c);
            if (assessmentTCH.Organism_History_MRSA__c != null) assessment.put('organism_history_mrsa', assessmentTCH.Organism_History_MRSA__c);
            if (assessmentTCH.Organism_History_MRSA_Status__c != null) assessment.put('organism_history_mrsa_status', assessmentTCH.Organism_History_MRSA_Status__c);
            if (assessmentTCH.Organism_History_VRE__c != null) assessment.put('organism_history_vre', assessmentTCH.Organism_History_VRE__c);
            if (assessmentTCH.Organism_History_VRE_Status__c != null) assessment.put('organism_history_vre_status', assessmentTCH.Organism_History_VRE_Status__c);
            if (assessmentTCH.Organism_History_CRE__c != null) assessment.put('organism_history_cre', assessmentTCH.Organism_History_CRE__c);
            if (assessmentTCH.Organism_History_CRE_Status__c != null) assessment.put('organism_history_cre_status', assessmentTCH.Organism_History_CRE_Status__c);
            if (assessmentTCH.Organism_History_Acenitobacter__c != null) assessment.put('organism_history_acinetobacteria', assessmentTCH.Organism_History_Acenitobacter__c);
            if (assessmentTCH.Organism_History_Acenitobacter_Status__c != null) assessment.put('organism_history_acinetobacteria_status', assessmentTCH.Organism_History_Acenitobacter_Status__c);
            if (assessmentTCH.Organism_History_ESBL__c != null) assessment.put('organism_history_esbl', assessmentTCH.Organism_History_ESBL__c);
            if (assessmentTCH.Organism_History_ESBL_Status__c != null) assessment.put('organism_history_esbl_status', assessmentTCH.Organism_History_ESBL_Status__c);
            if (assessmentTCH.Organism_History_MDRO__c != null) assessment.put('organism_history_mdro', assessmentTCH.Organism_History_MDRO__c);
            if (assessmentTCH.Organism_History_MDRO_Specify__c != null) assessment.put('organism_history_mdro_specify', assessmentTCH.Organism_History_MDRO_Specify__c);
            if (assessmentTCH.Organism_History_MDRO_Status__c != null) assessment.put('organism_history_mdro_status', assessmentTCH.Organism_History_MDRO_Status__c);
            if (assessmentTCH.Organism_History_Other__c != null) assessment.put('organism_history_other', assessmentTCH.Organism_History_Other__c);
            if (assessmentTCH.Organism_History_Other_Specify__c != null) assessment.put('organism_history_other_specify', assessmentTCH.Organism_History_Other_Specify__c);
            if (assessmentTCH.Organism_History_Other_Status__c != null) assessment.put('organism_history_other_status', assessmentTCH.Organism_History_Other_Status__c);
            if (assessmentTCH.Organism_History_Comments__c != null) assessment.put('organism_history_comments', assessmentTCH.Organism_History_Comments__c);
            if (assessmentTCH.Cardiovascular_Date__c != null) assessment.put('cardiovascular_date', assessmentTCH.Cardiovascular_Date__c.format());
            if (assessmentTCH.Cardiovascular_Rhythm__c != null) assessment.put('cardiovascular_rhythm', assessmentTCH.Cardiovascular_Rhythm__c);
            if (assessmentTCH.Cardiovascular_Rhythm_Type__c != null) assessment.put('cardiovascular_rhythm_type', assessmentTCH.Cardiovascular_Rhythm_Type__c);
            if (assessmentTCH.Cardiovascular_Rhythm_Location__c != null) assessment.put('cardiovascular_rhythm_location', assessmentTCH.Cardiovascular_Rhythm_Location__c);
            if (assessmentTCH.Echocardiogram__c != null) assessment.put('echocardiogram', assessmentTCH.Echocardiogram__c);
            if (assessmentTCH.Ejection_Fraction__c != null) assessment.put('ejection_fraction', assessmentTCH.Ejection_Fraction__c);
            if (assessmentTCH.Respiratory_O2_LPM__c != null) assessment.put('lmin', assessmentTCH.Respiratory_O2_LPM__c);
            if (assessmentTCH.O2_Flow_Mode__c != null) assessment.put('o2_flow_mode', assessmentTCH.O2_Flow_Mode__c);
            if (assessmentTCH.Respiratory_O2_Delivery__c != null) assessment.put('o2delivery', assessmentTCH.Respiratory_O2_Delivery__c);
            if (assessmentTCH.Respiratory_Treatments__c != null) assessment.put('o2treatments', assessmentTCH.Respiratory_Treatments__c);
            if (assessmentTCH.Respiration_Frequency__c != null) assessment.put('respiration_frequency', assessmentTCH.Respiration_Frequency__c);
            if (assessmentTCH.O2_Sats__c != null) assessment.put('o2_sats', assessmentTCH.O2_Sats__c.format());
            if (assessmentTCH.O2_Sats_Other__c != null) assessment.put('o2_sats_other', assessmentTCH.O2_Sats_Other__c);
            if (assessmentTCH.Respiratory_Trach_Type__c != null) assessment.put('trach_type', assessmentTCH.Respiratory_Trach_Type__c);
            if (assessmentTCH.Respiratory_Trach_Size__c != null) assessment.put('trach_size', assessmentTCH.Respiratory_Trach_Size__c);
            if (assessmentTCH.Trach_Date__c != null) assessment.put('trach_date', assessmentTCH.Trach_Date__c.format());
            if (assessmentTCH.Respiratory_Chest_Tube__c != null) assessment.put('respiratory_chest_tube', assessmentTCH.Respiratory_Chest_Tube__c);
            if (assessmentTCH.Respiratory_Tube_Location__c != null) assessment.put('respiratory_tube_location', assessmentTCH.Respiratory_Tube_Location__c);
            if (assessmentTCH.Respiratory_CPAP__c != null) assessment.put('respiratory_cpap', assessmentTCH.Respiratory_CPAP__c);
            if (assessmentTCH.Respiratory_BIPAP__c != null) assessment.put('respiratory_bipap', assessmentTCH.Respiratory_BIPAP__c);
            if (assessmentTCH.Vent__c != null) assessment.put('o2', assessmentTCH.Vent__c);
            if (assessmentTCH.Respiratory_Vent_Mode__c != null) assessment.put('vent_mode', assessmentTCH.Respiratory_Vent_Mode__c);
            if (assessmentTCH.Respiratory_Rate__c != null) assessment.put('vent_rate', assessmentTCH.Respiratory_Rate__c);
            if (assessmentTCH.Respiratory_FIO2__c != null) assessment.put('vent_fio2', assessmentTCH.Respiratory_FIO2__c);
            if (assessmentTCH.Respiratory_TV__c != null) assessment.put('vent_tv', assessmentTCH.Respiratory_TV__c);
            if (assessmentTCH.Respiratory_PS__c != null) assessment.put('vent_ps', assessmentTCH.Respiratory_PS__c);
            if (assessmentTCH.Respiratory_PEEP__c != null) assessment.put('vent_peep', assessmentTCH.Respiratory_PEEP__c);
            if (assessmentTCH.Respiratory_Weaning__c != null) assessment.put('vent_weaning', assessmentTCH.Respiratory_Weaning__c);
            if (assessmentTCH.Respiratory_Weaning_Attempts__c != null) assessment.put('respiratory_weaning_attempts', assessmentTCH.Respiratory_Weaning_Attempts__c);
            if (assessmentTCH.Respiratory_Not_Tolerated__c != null) assessment.put('respiratory_not_tolerated', assessmentTCH.Respiratory_Not_Tolerated__c);
            if (assessmentTCH.Respiratory_Not_Tolerated_Specify__c != null) assessment.put('respiratory_not_tolerated_specify', assessmentTCH.Respiratory_Not_Tolerated_Specify__c);
            if (assessmentTCH.Respiratory_Weaning_Mode__c != null) assessment.put('respiratory_weaning_mode', assessmentTCH.Respiratory_Weaning_Mode__c);
            if (assessmentTCH.Respiratory_ET_Tube__c != null) assessment.put('respiratory_et_tube', assessmentTCH.Respiratory_ET_Tube__c);
            if (assessmentTCH.Respiratory_Tube_Size__c != null) assessment.put('respiratory_tube_size', assessmentTCH.Respiratory_Tube_Size__c);
            if (assessmentTCH.BG__c != null) assessment.put('abg_not_applicable', assessmentTCH.BG__c);
            if (assessmentTCH.BG_Type__c != null) assessment.put('bg_type', assessmentTCH.BG_Type__c);
            if (assessmentTCH.BG_Date__c != null) assessment.put('abg_date', assessmentTCH.BG_Date__c.format());
            if (assessmentTCH.BG_FIO2__c != null) assessment.put('abg_fio2', assessmentTCH.BG_FIO2__c);
            if (assessmentTCH.BG_PaO2__c != null) assessment.put('abg_pao2', assessmentTCH.BG_PaO2__c);
            if (assessmentTCH.BG_PaCO2__c != null) assessment.put('abg_paco2', assessmentTCH.BG_PaCO2__c);
            if (assessmentTCH.BG_pH__c != null) assessment.put('abg_ph', assessmentTCH.BG_pH__c);
            if (assessmentTCH.BG_Bicarb__c != null) assessment.put('abg_bicarb', assessmentTCH.BG_Bicarb__c);
            if (assessmentTCH.BG_BE__c != null) assessment.put('abg_be', assessmentTCH.BG_BE__c);
            if (assessmentTCH.CXR__c != null) assessment.put('cxr', assessmentTCH.CXR__c);
            if (assessmentTCH.CXR_Date__c != null) assessment.put('cxr_date', assessmentTCH.CXR_Date__c.format());
            if (assessmentTCH.CXR_Results__c != null) assessment.put('results_selection', assessmentTCH.CXR_Results__c);
            if (assessmentTCH.CXR_Results_Specify__c != null) assessment.put('cxr_results', assessmentTCH.CXR_Results_Specify__c);
            if (assessmentTCH.GI_Bleeds__c != null) assessment.put('gi_bleeds', assessmentTCH.GI_Bleeds__c);
            if (assessmentTCH.Additional_Respiratory_Details__c != null) assessment.put('additional_respiratory_details', assessmentTCH.Additional_Respiratory_Details__c);
            if (assessmentTCH.GI_GU_Date_Taken__c != null) assessment.put('gi_gu_date_taken', assessmentTCH.GI_GU_Date_Taken__c.format());
            if (assessmentTCH.GI_GU_Height__c != null) assessment.put('height', assessmentTCH.GI_GU_Height__c);
            if (assessmentTCH.GI_GU_Height_Units__c != null) assessment.put('gi_gu_height_units', assessmentTCH.GI_GU_Height_Units__c);
            if (assessmentTCH.GI_GU_Weight__c != null) assessment.put('weight', assessmentTCH.GI_GU_Weight__c);
            if (assessmentTCH.GI_GU_Weight_Units__c != null) assessment.put('gi_gu_weight_units', assessmentTCH.GI_GU_Weight_Units__c);
            if (assessmentTCH.GI_GU_Diet_Order__c != null) assessment.put('diet_type', assessmentTCH.GI_GU_Diet_Order__c);
            if (assessmentTCH.GI_GU_Texture__c != null) assessment.put('gi_gu_texture', assessmentTCH.GI_GU_Texture__c);
            if (assessmentTCH.GI_GU_Liquid_Consistency__c != null) assessment.put('gi_gu_liquid_consistency', assessmentTCH.GI_GU_Liquid_Consistency__c);
            if (assessmentTCH.GI_GU_Supplement_Schedule__c != null) assessment.put('gi_gu_supplement_schedule', assessmentTCH.GI_GU_Supplement_Schedule__c);
            if (assessmentTCH.GI_GU_Tube_Type__c != null) assessment.put('feeding_tube_type', assessmentTCH.GI_GU_Tube_Type__c);
            if (assessmentTCH.GI_GU_Formula_Name__c != null) assessment.put('gi_gu_formula_name', assessmentTCH.GI_GU_Formula_Name__c);
            if (assessmentTCH.GI_GU_Recent_Aspiration_Rate__c != null) assessment.put('gi_gu_recent_asperation_rate', assessmentTCH.GI_GU_Recent_Aspiration_Rate__c);
            if (assessmentTCH.GI_GU_Recent_Aspiration__c != null) assessment.put('gi_gu_recent_aspiration', assessmentTCH.GI_GU_Recent_Aspiration__c);
            if (assessmentTCH.GI_GU_Parenteral_Nutrition__c != null) assessment.put('gi_gu_parenteral_nutrition', assessmentTCH.GI_GU_Parenteral_Nutrition__c);
            if (assessmentTCH.GI_GU_Initiation_Date__c != null) assessment.put('gi_gu_initiation_date', assessmentTCH.GI_GU_Initiation_Date__c.format());
            if (assessmentTCH.GI_GU_Initiation_Rate__c != null) assessment.put('feeding_tube_rate', assessmentTCH.GI_GU_Initiation_Rate__c);
            if (assessmentTCH.IO_In__c != null) assessment.put('io_in', assessmentTCH.IO_In__c);
            if (assessmentTCH.IO_Out__c != null) assessment.put('io_out', assessmentTCH.IO_Out__c);
            if (assessmentTCH.Urine_Describe__c != null) assessment.put('urine_describe', assessmentTCH.Urine_Describe__c);
            if (assessmentTCH.Recent_Weight_Change__c != null) assessment.put('recent_weight_change', assessmentTCH.Recent_Weight_Change__c);
            if (assessmentTCH.Foley__c != null) assessment.put('foley', assessmentTCH.Foley__c);
            if (assessmentTCH.Foley_Date__c != null) assessment.put('foley_date', assessmentTCH.Foley_Date__c.format());
            if (assessmentTCH.Rectal_Tube__c != null) assessment.put('rectal_tube', assessmentTCH.Rectal_Tube__c);
            if (assessmentTCH.Rectal_Date__c != null) assessment.put('rectal_date', assessmentTCH.Rectal_Date__c.format());
            if (assessmentTCH.Last_BM__c != null) assessment.put('last_bm', assessmentTCH.Last_BM__c);
            if (assessmentTCH.Urostomy__c != null) assessment.put('urostomy', assessmentTCH.Urostomy__c);
            if (assessmentTCH.Urostomy_Date__c != null) assessment.put('urostomy_date', assessmentTCH.Urostomy_Date__c.format());
            if (assessmentTCH.Colostomy__c != null) assessment.put('colostomy', assessmentTCH.Colostomy__c);
            if (assessmentTCH.Colostomy_Date__c != null) assessment.put('colostomy_date', assessmentTCH.Colostomy_Date__c.format());
            if (assessmentTCH.Ileostomy__c != null) assessment.put('ileostomy', assessmentTCH.Ileostomy__c);
            if (assessmentTCH.Ileostomy_Date__c != null) assessment.put('ileostomy_date', assessmentTCH.Ileostomy_Date__c.format());
            if (assessmentTCH.Musculoskeletal_Orthotics__c != null) assessment.put('musculoskeletal_orthotics', assessmentTCH.Musculoskeletal_Orthotics__c);
            if (assessmentTCH.Musculoskeletal_Casts_Splints__c != null) assessment.put('musculoskeletal_casts_splints', assessmentTCH.Musculoskeletal_Casts_Splints__c);
            if (assessmentTCH.Musculoskeletal_TED_Hose__c != null) assessment.put('musculoskeletal_ted_hose', assessmentTCH.Musculoskeletal_TED_Hose__c);
            if (assessmentTCH.Musculoskeletal_SCD__c != null) assessment.put('musculoskeletal_scd', assessmentTCH.Musculoskeletal_SCD__c);
            if (assessmentTCH.Musculoskeletal_Contractures__c != null) assessment.put('musculoskeletal_contractures', assessmentTCH.Musculoskeletal_Contractures__c);
            if (assessmentTCH.Musculoskeletal_Type__c != null) assessment.put('musculoskeletal_limits', assessmentTCH.Musculoskeletal_Type__c);
            if (assessmentTCH.Musculoskeletal_Contractures_Specify__c != null) assessment.put('musculoskeletal_contractures_specify', assessmentTCH.Musculoskeletal_Contractures_Specify__c);
            if (assessmentTCH.Contractures_Weight_Bearing__c != null) assessment.put('contractures_weight_bearing', assessmentTCH.Contractures_Weight_Bearing__c);
            if (assessmentTCH.Contractures_Reason__c != null) assessment.put('contractures_reason', assessmentTCH.Contractures_Reason__c);
            if (assessmentTCH.Musculoskeletal_Activity_Level__c != null) assessment.put('musculoskeletal_activity_level', assessmentTCH.Musculoskeletal_Activity_Level__c);
            if (assessmentTCH.Assistive_Devices__c != null) assessment.put('mus_assistive_devices', assessmentTCH.Assistive_Devices__c);
            if (assessmentTCH.Musculoskeletal_Traction__c != null) assessment.put('musculoskeletal_traction', assessmentTCH.Musculoskeletal_Traction__c);
            if (assessmentTCH.Traction_Type__c != null) assessment.put('traction_type', assessmentTCH.Traction_Type__c);
            if (assessmentTCH.Traction_Weight__c != null) assessment.put('traction_weight', assessmentTCH.Traction_Weight__c);
            if (assessmentTCH.Musculoskeletal_Recent_Falls__c != null) assessment.put('musculoskeletal_recent_falls', assessmentTCH.Musculoskeletal_Recent_Falls__c);
            if (assessmentTCH.Rehab_Type__c != null) assessment.put('rehab_type', assessmentTCH.Rehab_Type__c);
            if (assessmentTCH.Rehab_Ambulate__c != null) assessment.put('rehab_ambulate', assessmentTCH.Rehab_Ambulate__c);
            if (assessmentTCH.Rehab_Transfer__c != null) assessment.put('rehab_transfer', assessmentTCH.Rehab_Transfer__c);
            if (assessmentTCH.Activities_Of_Daily_Living__c != null) assessment.put('activities_of_daily_living', assessmentTCH.Activities_Of_Daily_Living__c);
            if (assessmentTCH.Rehab_Anticipated__c != null) assessment.put('rehab_anticipated', assessmentTCH.Rehab_Anticipated__c);
            if (assessmentTCH.Rehab_Additional_Details__c != null) assessment.put('rehab_additional_details', assessmentTCH.Rehab_Additional_Details__c);
            if (assessmentTCH.Medication_MARs__c != null) assessment.put('medication_mars', assessmentTCH.Medication_MARs__c);
            if (assessmentTCH.Medication_MARs_Pages__c != null) assessment.put('medication_mars_pages', assessmentTCH.Medication_MARs_Pages__c);
            if (assessmentTCH.Medication_Allergies__c != null) assessment.put('medication_allergies', assessmentTCH.Medication_Allergies__c);
            if (assessmentTCH.Medication_Drips__c != null) assessment.put('iv_meds', assessmentTCH.Medication_Drips__c);
            if (assessmentTCH.Medication_Drips_Specify__c != null) assessment.put('medication_drips_specify', assessmentTCH.Medication_Drips_Specify__c);
            if (assessmentTCH.Medication_IV_Access__c != null) assessment.put('iv_access', assessmentTCH.Medication_IV_Access__c);
            if (assessmentTCH.Medication_IV_Access_PICC_Specify__c != null) assessment.put('medication_iv_access_picc_specify', assessmentTCH.Medication_IV_Access_PICC_Specify__c);
            if (assessmentTCH.Medication_IV_Access_Specify__c != null) assessment.put('medication_iv_access_specify', assessmentTCH.Medication_IV_Access_Specify__c);
            if (assessmentTCH.Integumentary_Summary__c != null) assessment.put('integumentary_summary', assessmentTCH.Integumentary_Summary__c);
            if (assessmentTCH.Integumentary_Bed_Type__c != null) assessment.put('integumentary_bed_type', assessmentTCH.Integumentary_Bed_Type__c);
            if (assessmentTCH.Recalcitrant_Wounds__c != null) assessment.put('recalcitrant_wounds', assessmentTCH.Recalcitrant_Wounds__c);
            if (assessmentTCH.State_Name__c != null) assessment.put('state_name', assessmentTCH.State_Name__c);
            if (assessmentTCH.Rogers_Orders__c != null) assessment.put('rogers_orders', assessmentTCH.Rogers_Orders__c);
            if (assessmentTCH.Physicians_Orders__c != null) assessment.put('physicians_orders', assessmentTCH.Physicians_Orders__c);
            if (assessmentTCH.Air_Embolism__c != null) assessment.put('air_embolism', assessmentTCH.Air_Embolism__c);
            if (assessmentTCH.Pressure_Ulcers__c != null) assessment.put('pressure_ulcers', assessmentTCH.Pressure_Ulcers__c);
            if (assessmentTCH.Catheter_Associated_UTI__c != null) assessment.put('catheter_associated_urinary_tract_infection', assessmentTCH.Catheter_Associated_UTI__c);
            if (assessmentTCH.Vascular_Catheter_Associated_Infection__c != null) assessment.put('vascular_catheter_associated_infection', assessmentTCH.Vascular_Catheter_Associated_Infection__c);
            if (assessmentTCH.Manifestations_Of_Poor_Glycemic_Control__c != null) assessment.put('manifestations_of_poor_glycemic_control', assessmentTCH.Manifestations_Of_Poor_Glycemic_Control__c);
            if (assessmentTCH.Falls_Or_Trauma_With_Injuries__c != null) assessment.put('falls_or_trauma_with_injuries', assessmentTCH.Falls_Or_Trauma_With_Injuries__c);
            if (assessmentTCH.Surgical_Site_Infection__c != null) assessment.put('surgical_site_infection', assessmentTCH.Surgical_Site_Infection__c);
            if (assessmentTCH.DVT_Post_Knee__c != null) assessment.put('dvt_post_knee', assessmentTCH.DVT_Post_Knee__c);
            if (assessmentTCH.Admission_Type__c != null) assessment.put('admission_type', assessmentTCH.Admission_Type__c);
            if (assessmentTCH.Number_Days_Out__c != null) assessment.put('number_days_out', assessmentTCH.Number_Days_Out__c);
            if (assessmentTCH.Type_Of_Assessment__c != null) assessment.put('type_of_assessment', assessmentTCH.Type_Of_Assessment__c);
            if (assessmentTCH.Bed_Needs__c != null) assessment.put('bed_needs', assessmentTCH.Bed_Needs__c);
            if (assessmentTCH.Bed_Needs_Specify__c != null) assessment.put('specify_bed_needs', assessmentTCH.Bed_Needs_Specify__c);
            if (assessmentTCH.Clinical_Appropriateness__c != null) assessment.put('historical_info_narrative', assessmentTCH.Clinical_Appropriateness__c);
            if (assessmentTCH.Primary_Reason_For_LTAC_Admission__c != null) assessment.put('primary_ltac_admission_reason', assessmentTCH.Primary_Reason_For_LTAC_Admission__c);
            if (assessmentTCH.Precautions__c != null) assessment.put('historical_info_precautions', assessmentTCH.Precautions__c);
            if (assessmentTCH.ICD__c != null) assessment.put('icd9', assessmentTCH.ICD__c);
            if (assessmentTCH.Additional_Notes_Overall__c != null) assessment.put('additional_notes_overall', assessmentTCH.Additional_Notes_Overall__c);
            if (assessmentTCH.Medicare_Days_Full__c != null) assessment.put('medicare_days_1', assessmentTCH.Medicare_Days_Full__c);
            if (assessmentTCH.Medicare_Days_Coinsurance__c != null) assessment.put('medicare_days_2', assessmentTCH.Medicare_Days_Coinsurance__c);
            if (assessmentTCH.Medicare_Days_LTR__c != null) assessment.put('medicare_days_3', assessmentTCH.Medicare_Days_LTR__c);
            if (assessmentTCH.Summary_Secondary__c != null) assessment.put('summary_secondary', assessmentTCH.Summary_Secondary__c);
            if (assessmentTCH.Summary_Non_Government__c != null) assessment.put('summary_non_government', assessmentTCH.Summary_Non_Government__c);
            if (assessmentTCH.Lower_Level_Care_Failure__c != null) assessment.put('lower_level_care_failure', assessmentTCH.Lower_Level_Care_Failure__c);
            if (assessmentTCH.Lower_Level_Care_Failure_Reasons__c != null) assessment.put('failure_reasons', assessmentTCH.Lower_Level_Care_Failure_Reasons__c);
            if (assessmentTCH.Medical_Or_Surgical_History__c != null) assessment.put('medical_surgery_history', assessmentTCH.Medical_Or_Surgical_History__c);
            if (assessmentTCH.Hospital_Course_Summary__c != null) assessment.put('hospital_referring_facility_course_summary', assessmentTCH.Hospital_Course_Summary__c);
            if (assessmentTCH.Pneumococcal__c != null) assessment.put('pneumoccal_vaccination_not_applicable', assessmentTCH.Pneumococcal__c);
            if (assessmentTCH.Pneumococcal_Year__c != null) assessment.put('pneumoccal_vaccination_date', assessmentTCH.Pneumococcal_Year__c);
            if (assessmentTCH.Flu_Vaccination__c != null) assessment.put('flu_vacc_not_applicable', assessmentTCH.Flu_Vaccination__c);
            if (assessmentTCH.Flu_Vaccination_Date__c != null) assessment.put('influenza_vaccination_date', assessmentTCH.Flu_Vaccination_Date__c.format());
            if (assessmentTCH.Flu_Vaccination_Reason__c != null) assessment.put('influenza_reason', assessmentTCH.Flu_Vaccination_Reason__c);
            if (assessmentTCH.Continued_Stay_Criteria__c != null) assessment.put('continued_stay_criteria', assessmentTCH.Continued_Stay_Criteria__c);
            if (assessmentTCH.MC_Clinical_Status_Criteria__c != null) assessment.put('mc_clinical_status_label', assessmentTCH.MC_Clinical_Status_Criteria__c);
            if (assessmentTCH.MC_Primary_Conditions__c != null) assessment.put('mc_medical_complex', assessmentTCH.MC_Primary_Conditions__c);
            if (assessmentTCH.MC_Renal__c != null) assessment.put('mc_renal_insufficiency_details', assessmentTCH.MC_Renal__c);
            if (assessmentTCH.MC_Hematologic__c != null) assessment.put('mc_malignant_endstage_disease_details', assessmentTCH.MC_Hematologic__c);
            if (assessmentTCH.MC_Gastrointestinal__c != null) assessment.put('mc_gastrointestinal_condition_details', assessmentTCH.MC_Gastrointestinal__c);
            if (assessmentTCH.MC_Bone_Marrow__c != null) assessment.put('mc_bone_marrow_details', assessmentTCH.MC_Bone_Marrow__c);
            if (assessmentTCH.MC_Cardiac__c != null) assessment.put('mc_cardiac_details', assessmentTCH.MC_Cardiac__c);
            if (assessmentTCH.MC_Infection__c != null) assessment.put('mc_infection_details', assessmentTCH.MC_Infection__c);
            if (assessmentTCH.MC_Pneumonia__c != null) assessment.put('mc_pneumonia', assessmentTCH.MC_Pneumonia__c);
            if (assessmentTCH.MC_Pyelonephritis__c != null) assessment.put('mc_pyelonephritis', assessmentTCH.MC_Pyelonephritis__c);
            if (assessmentTCH.MC_Systemic_Or_Organ_Infection__c != null) assessment.put('mc_systemic_organ', assessmentTCH.MC_Systemic_Or_Organ_Infection__c);
            if (assessmentTCH.MC_Treatments_To_Consider__c != null) assessment.put('mc_treatments_to_consider', assessmentTCH.MC_Treatments_To_Consider__c);
            if (assessmentTCH.MC_Surgical_Or_Wound_Infection__c != null) assessment.put('mc_surgical_wound', assessmentTCH.MC_Surgical_Or_Wound_Infection__c);
            if (assessmentTCH.MC_Active_Comorbid_Conditions__c != null) assessment.put('mc_active_comorbid_conditions', assessmentTCH.MC_Active_Comorbid_Conditions__c);
            if (assessmentTCH.MC_Clinical_Status_Includes_All__c != null) assessment.put('mc_clinical_status_includes_all', assessmentTCH.MC_Clinical_Status_Includes_All__c);
            if (assessmentTCH.MC_Clinical_Status_Criteria__c != null) assessment.put('rs_clinical_status_label', assessmentTCH.MC_Clinical_Status_Criteria__c);
            if (assessmentTCH.RC_Primary_Conditions__c != null) assessment.put('rs_respiratory_complex', assessmentTCH.RC_Primary_Conditions__c);
            if (assessmentTCH.RC_Failed_At_LLOC__c != null) assessment.put('rs_failed_at_lloc', assessmentTCH.RC_Failed_At_LLOC__c);
            if (assessmentTCH.RC_Hypoxia__c != null) assessment.put('rs_hypoxia', assessmentTCH.RC_Hypoxia__c);
            if (assessmentTCH.RC_Post_Event__c != null) assessment.put('rs_post_event', assessmentTCH.RC_Post_Event__c);
            if (assessmentTCH.RC_Active_Comorbid_Conditions__c != null) assessment.put('rs_active_comorbid_conditions', assessmentTCH.RC_Active_Comorbid_Conditions__c);
            if (assessmentTCH.RC_Treatments_To_Consider__c != null) assessment.put('rs_treatments_to_consider', assessmentTCH.RC_Treatments_To_Consider__c);
            if (assessmentTCH.RC_Clinical_Status_Includes_All__c != null) assessment.put('rs_clinical_status_includes_all', assessmentTCH.RC_Clinical_Status_Includes_All__c);
            if (assessmentTCH.VN_Weaning_Criteria__c != null) assessment.put('ventilator_group_weaning_potential_label1', assessmentTCH.VN_Weaning_Criteria__c);
            if (assessmentTCH.VN_Primary_Condition__c != null) assessment.put('vn_vent_dependence', assessmentTCH.VN_Primary_Condition__c);
            if (assessmentTCH.VN_No_Weaning_Reason__c != null) assessment.put('vn_no_prior_weaning', assessmentTCH.VN_No_Weaning_Reason__c);
            if (assessmentTCH.VN_Treatments_To_Consider__c != null) assessment.put('vn_treatments_to_consider', assessmentTCH.VN_Treatments_To_Consider__c);
            if (assessmentTCH.VN_Weaning_Includes_All__c != null) assessment.put('vn_weaning_includes', assessmentTCH.VN_Weaning_Includes_All__c);
            if (assessmentTCH.WC_Clinical_Status_Criteria__c != null) assessment.put('wc_clinical_status_label', assessmentTCH.WC_Clinical_Status_Criteria__c);
            if (assessmentTCH.WC_Primary_Conditions__c != null) assessment.put('wc_wound_skin_condition', assessmentTCH.WC_Primary_Conditions__c);
            if (assessmentTCH.WC_Large_Wound__c != null) assessment.put('wc_large_wound', assessmentTCH.WC_Large_Wound__c);
            if (assessmentTCH.WC_Lower_Extremity__c != null) assessment.put('wc_lower_extremity_conditions', assessmentTCH.WC_Lower_Extremity__c);
            if (assessmentTCH.WC_Lower_Extremity_Risk_Factors__c != null) assessment.put('wc_lower_extremity_risk_factors', assessmentTCH.WC_Lower_Extremity_Risk_Factors__c);
            if (assessmentTCH.WC_Infection__c != null) assessment.put('wc_infection', assessmentTCH.WC_Infection__c);
            if (assessmentTCH.WC_Active_Comorbid_Conditions__c != null) assessment.put('wc_active_comorbid_conditions', assessmentTCH.WC_Active_Comorbid_Conditions__c);
            if (assessmentTCH.WC_Treatments_To_Consider__c != null) assessment.put('wc_treatments_to_consider', assessmentTCH.WC_Treatments_To_Consider__c);
            if (assessmentTCH.WC_Clinical_Status_Includes_All__c != null) assessment.put('wc_clinical_status_includes_all', assessmentTCH.WC_Clinical_Status_Includes_All__c);
            if (assessmentTCH.Prior_Device_Use__c != null) assessment.put('prior_device_use', assessmentTCH.Prior_Device_Use__c);
            if (assessmentTCH.Prior_Functioning_Activity_Level__c != null) assessment.put('prior_functioning_activity_level', assessmentTCH.Prior_Functioning_Activity_Level__c);
            if (assessmentTCH.Prior_Functional_Status__c != null) assessment.put('prior_functional_status', assessmentTCH.Prior_Functional_Status__c);
            if (assessmentTCH.Admitted_To_STAC_On_Vent__c != null) assessment.put('admitted_to_stac_on_vent', assessmentTCH.Admitted_To_STAC_On_Vent__c);
            if (assessmentTCH.Chronic_Vent__c != null) assessment.put('chronic_vent', assessmentTCH.Chronic_Vent__c);
            if (assessmentTCH.Date_Initiated_Vent__c != null) assessment.put('date_initiated_vent', assessmentTCH.Date_Initiated_Vent__c.format());
            
            JSON.serialize(assessment);
            return assessment;
        } else if (assessmentsTCC.size() > 0) {
            Map<String, String> assessment = new Map<String, String>();
            Assessment_TCC__c assessmentTCC = assessmentsTCC[0];
            
            //TCC MetaData
            if (assessmentTCC.Meta_Bookmark__c != null) assessment.put('meta_bookmark', assessmentTCC.Meta_Bookmark__c.format());
            if (assessmentTCC.Meta_Form_Type__c != null) assessment.put('meta_form_type', assessmentTCC.Meta_Form_Type__c.format());
            if (assessmentTCC.Meta_Manual_Bookmark__c != null) assessment.put('meta_manual_bookmark', assessmentTCC.Meta_Manual_Bookmark__c.format());
            if (assessmentTCC.Meta_ChainUUID__c != null) assessment.put('meta_chainuuid', assessmentTCC.Meta_ChainUUID__c);
            if (assessmentTCC.Meta_Document_Version__c != null) assessment.put('meta_document_version', assessmentTCC.Meta_Document_Version__c);
            if (assessmentTCC.Meta_Document_Status__c != null) assessment.put('meta_document_status', assessmentTCC.Meta_Document_Status__c);
            if (assessmentTCC.Meta_Filename__c != null) assessment.put('meta_filename', assessmentTCC.Meta_Filename__c);

            if (app_version > 120) {
                 if (assessmentTCC.Meta_Reassessment_Date__c != null) assessment.put('meta_reassessment_date', assessmentTCC.Meta_Reassessment_Date__c.format('yyyy-MM-dd HH:mm:ss', 'UTC'));
                 if (assessmentTCC.Meta_Creation_Date__c != null) assessment.put('meta_creation_date', assessmentTCC.Meta_Creation_Date__c.format('yyyy-MM-dd HH:mm:ss', 'UTC'));
                 if (assessmentTCC.Meta_Submitted_Date__c != null) assessment.put('meta_submitted_date', assessmentTCC.Meta_Submitted_Date__c.format('yyyy-MM-dd HH:mm:ss', 'UTC'));
            } else {
                 if (assessmentTCC.Meta_Reassessment_Date__c != null) assessment.put('meta_reassessment_date', assessmentTCC.Meta_Reassessment_Date__c.format());
                 if (assessmentTCC.Meta_Creation_Date__c != null) assessment.put('meta_creation_date', assessmentTCC.Meta_Creation_Date__c.format());
                 if (assessmentTCC.Meta_Submitted_Date__c != null) assessment.put('meta_submitted_date', assessmentTCC.Meta_Submitted_Date__c.format());
            }
            
            //Referring Physician
            if (assessmentTCC.Referring_Physician__c != null) assessment.put('referring_physician_name', assessmentTCC.Referring_Physician__c);
            if (assessmentTCC.Referring_Physician_As_Contact__c != null) assessment.put('referring_physician_sfid', assessmentTCC.Referring_Physician_As_Contact__c);
            if (assessmentTCC.Referring_Physician_As_Lead__c != null) assessment.put('referring_physician_sfid', assessmentTCC.Referring_Physician_As_Lead__c);

            //Refer To Account
            if (assessmentTCC.Refer_To__c != null) assessment.put('refer_to_name', assessmentTCC.Refer_To__c);
            if (assessmentTCC.Refer_To_Account__c != null) assessment.put('refer_to_sfid', assessmentTCC.Refer_To_Account__c);
            
            //Referring Contact
            if (assessmentTCC.Referring_Contact__c != null) assessment.put('referring_contact_name', assessmentTCC.Referring_Contact__c);
            if (assessmentTCC.Referring_Contact_As_Contact__c != null) assessment.put('referring_contact_sfid', assessmentTCC.Referring_Contact_As_Contact__c);
            if (assessmentTCC.Referring_Contact_As_Lead__c != null) assessment.put('referring_contact_sfid', assessmentTCC.Referring_Contact_As_Lead__c);

            //Referring Location
            if (assessmentTCC.Referring_Location__c != null) assessment.put('referring_location_name', assessmentTCC.Referring_Location__c);
            if (assessmentTCC.Referring_Location_Account__c != null) assessment.put('referring_location_sfid', assessmentTCC.Referring_Location_Account__c);
            
            //Primary Physician
            if (assessmentTCC.Primary_Care_Physician__c != null) assessment.put('primary_care_physician_name', assessmentTCC.Primary_Care_Physician__c);
            if (assessmentTCC.Primary_Care_Physician_As_Contact__c != null) assessment.put('primary_care_physician_sfid', assessmentTCC.Primary_Care_Physician_As_Contact__c);
            if (assessmentTCC.Primary_Care_Physician_As_Lead__c != null) assessment.put('primary_care_physician_sfid', assessmentTCC.Primary_Care_Physician_As_Lead__c);
            if (assessmentTCC.Primary_Care_Physician_Phone__c != null) assessment.put('primary_care_physician_phone', assessmentTCC.Primary_Care_Physician_Phone__c);

            //Medications TCC
            List<String> tccMedicationFields = new List<String>(Medication_TCC__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlMedicationTCC = '' + ' SELECT ' + String.join(tccMedicationFields, ',') + ' from Medication_TCC__c' + ' where Assessment_TCC__c = \'' + assessmentTCC.Id + '\'';
            List<Map<String,String>> medicationItems = new List<Map<String,String>>();
            Medication_TCC__c[] multiple_medications_group = database.query(soqlMedicationTCC);
            if (multiple_medications_group.size() > 0) {
              for (Medication_TCC__c medicationItem : multiple_medications_group) {
                Map<String,String> medication = new Map<String,String>();
                if (medicationItem.App_Timestamp__c != null) medication.put('app_timestamp',medicationItem.App_Timestamp__c);
                if (medicationItem.Medication_Dosage__c != null) medication.put('medication_dosage',medicationItem.Medication_Dosage__c);
                if (medicationItem.Medication_Frequency__c != null) medication.put('medication_frequency',medicationItem.Medication_Frequency__c);
                if (medicationItem.Medication_Name__c != null) medication.put('medication_name',medicationItem.Medication_Name__c);
                if (medicationItem.Medication_Route__c != null) medication.put('medication_route',medicationItem.Medication_Route__c);
                medicationItems.add(medication);
              }
              assessment.put('multiple_medications_group',JSON.serialize(medicationItems));
            }

            //Medicine Line TCC
            List<String> tccMedicationLineFields = new List<String>(Medication_Line_TCC__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlMedicationLineTCC = '' + ' SELECT ' + String.join(tccMedicationLineFields, ',') + ' from Medication_Line_TCC__c' + ' where Assessment_TCC__c = \'' + assessmentTCC.Id + '\'';
            List<Map<String,String>> medicationLineItems = new List<Map<String,String>>();
            Medication_Line_TCC__c[] multiple_line_group = database.query(soqlMedicationLineTCC);
            if (multiple_line_group.size() > 0) {
              for (Medication_Line_TCC__c medicationLineItem : multiple_line_group) {
                Map<String,String> medicationLine = new Map<String,String>();
                if (medicationLineItem.App_Timestamp__c != null) medicationLine.put('app_timestamp',medicationLineItem.App_Timestamp__c);
                if (medicationLineItem.Line_Insertion_Date__c != null) medicationLine.put('line_insertion_date',medicationLineItem.Line_Insertion_Date__c.format());
                if (medicationLineItem.Line_CL_Type__c != null) medicationLine.put('line_cl_type',medicationLineItem.Line_CL_Type__c);
                if (medicationLineItem.Line_Location__c != null) medicationLine.put('line_location',medicationLineItem.Line_Location__c);
                medicationLineItems.add(medicationLine);
              }
              assessment.put('multiple_line_group',JSON.serialize(medicationLineItems));
            }
            
            //Integumentary TCC
            List<String> tccIntegumentaryFields = new List<String>(Integumentary_TCC__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlIntegumentaryTCC = '' + ' SELECT ' + String.join(tccIntegumentaryFields, ',') + ' from Integumentary_TCC__c' + ' where Assessment_TCC__c = \'' + assessmentTCC.Id + '\'';
            List<Map<String,String>> integumentaryItems = new List<Map<String,String>>();
            Integumentary_TCC__c[] itegumentary_mutable_group = database.query(soqlIntegumentaryTCC);
            if (itegumentary_mutable_group.size() > 0) {
              for (Integumentary_TCC__c integumentaryItem : itegumentary_mutable_group) {
                Map<String,String> integumentary = new Map<String,String>();
                if (integumentaryItem.App_Timestamp__c != null) integumentary.put('app_timestamp',integumentaryItem.App_Timestamp__c);
                if (integumentaryItem.Skin_Item_Treatment__c != null) integumentary.put('skin_item_treatment',integumentaryItem.Skin_Item_Treatment__c);
                if (integumentaryItem.Skin_Item_Site__c != null) integumentary.put('skin_item_site',integumentaryItem.Skin_Item_Site__c);
                if (integumentaryItem.Skin_Item_Stage__c != null) integumentary.put('skin_item_stage',integumentaryItem.Skin_Item_Stage__c);
                if (integumentaryItem.Skin_Item_Stage_Size__c != null) integumentary.put('skin_item_stage_size',integumentaryItem.Skin_Item_Stage_Size__c);             
                integumentaryItems.add(integumentary);
              }
              assessment.put('itegumentary_mutable_group',JSON.serialize(integumentaryItems));
            }

            //Cultures TCC
            List<String> tccCultureFields = new List<String>(Culture_TCC__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlCultureTCC = '' + ' SELECT ' + String.join(tccCultureFields, ',') + ' from Culture_TCC__c' + ' where Assessment_TCC__c = \'' + assessmentTCC.Id + '\'';
            List<Map<String,String>> cultures = new List<Map<String,String>>();
            Culture_TCC__c[] culture_history_mutable_group = database.query(soqlCultureTCC);
            if (culture_history_mutable_group.size() > 0) {
              for (Culture_TCC__c cultureItem : culture_history_mutable_group) {
                Map<String,String> culture = new Map<String,String>();
                if (cultureItem.App_Timestamp__c != null) culture.put('app_timestamp',cultureItem.App_Timestamp__c);
                if (cultureItem.Culture_Date__c != null) culture.put('culture_date',cultureItem.Culture_Date__c.format());
                if (cultureItem.Culture_IV_Antibiotic__c != null) culture.put('culture_iv_antibiotic',cultureItem.Culture_IV_Antibiotic__c);
                if (cultureItem.Culture_Organism__c != null) culture.put('culture_organism',cultureItem.Culture_Organism__c);
                if (cultureItem.Culture_Site__c != null) culture.put('culture_site',cultureItem.Culture_Site__c);
                if (cultureItem.Culture_Start_Date__c != null) culture.put('culture_start_date',cultureItem.Culture_Start_Date__c.format());
                if (cultureItem.Culture_Stop_Date__c != null) culture.put('culture_stop_date',cultureItem.Culture_Stop_Date__c.format());
                cultures.add(culture);
              }
              assessment.put('culture_history_mutable_group',JSON.serialize(cultures));
            }
            
            //TCC Fields
            if (assessmentTCC.X3_Day_Waiver__c != null) assessment.put('3_day_waiver', assessmentTCC.X3_Day_Waiver__c);
            if (assessmentTCC.ACO__c != null) assessment.put('aco', assessmentTCC.ACO__c);
            if (assessmentTCC.Allergies__c != null) assessment.put('allergies', assessmentTCC.Allergies__c);
            if (assessmentTCC.Anticipated_Admit_Date__c != null) assessment.put('anticipated_admit_date', assessmentTCC.Anticipated_Admit_Date__c.format());
            if (assessmentTCC.Assistive_Devices_Specialty_Equipment__c != null) assessment.put('assistive_devices_specialty_equipment', assessmentTCC.Assistive_Devices_Specialty_Equipment__c);
            if (assessmentTCC.Assistive_Devices_Specialty_Equipment_De__c != null) assessment.put('assistive_devices_specialty_equipment_details', assessmentTCC.Assistive_Devices_Specialty_Equipment_De__c);
            if (assessmentTCC.Bed_Hold__c != null) assessment.put('bed_hold', assessmentTCC.Bed_Hold__c);
            if (assessmentTCC.Bed_Offer_Made__c != null) assessment.put('bed_offer_made', assessmentTCC.Bed_Offer_Made__c);
            if (assessmentTCC.Bedside_Visit_Made__c != null) assessment.put('bedside_visit_made', assessmentTCC.Bedside_Visit_Made__c);
            if (assessmentTCC.Chemo_Radiation__c != null) assessment.put('chemo_radiation', assessmentTCC.Chemo_Radiation__c);
            if (assessmentTCC.Chemo_Radiation_Treatment__c != null) assessment.put('chemo_radiation_treatment', assessmentTCC.Chemo_Radiation_Treatment__c);
            if (assessmentTCC.Clinical_Summary__c != null) assessment.put('clinical_summary', assessmentTCC.Clinical_Summary__c);
            if (assessmentTCC.CLOF_ADL__c != null) assessment.put('clof_adl', assessmentTCC.CLOF_ADL__c);
            if (assessmentTCC.CLOF_Ambulation__c != null) assessment.put('clof_ambulation', assessmentTCC.CLOF_Ambulation__c);
            if (assessmentTCC.CLOF_Bed_Mobility__c != null) assessment.put('clof_bed_mobility', assessmentTCC.CLOF_Bed_Mobility__c);
            if (assessmentTCC.CLOF_Transfers__c != null) assessment.put('clof_transfers', assessmentTCC.CLOF_Transfers__c);
            if (assessmentTCC.Contact_Relationship__c != null) assessment.put('contact_relationship', assessmentTCC.Contact_Relationship__c);
            if (assessmentTCC.Contact_Type__c != null) assessment.put('contact_type', assessmentTCC.Contact_Type__c);
            if (assessmentTCC.Current_Admit_Date__c != null) assessment.put('current_admit_date', assessmentTCC.Current_Admit_Date__c.format());
            if (assessmentTCC.Current_Mental_Status_Behavior__c != null) assessment.put('current_mental_status_behavior', assessmentTCC.Current_Mental_Status_Behavior__c);
            if (assessmentTCC.CXR__c != null) assessment.put('cxr', assessmentTCC.CXR__c);
            if (assessmentTCC.CXR_Date__c != null) assessment.put('cxr_date', assessmentTCC.CXR_Date__c.format());
            if (assessmentTCC.CXR_Results__c != null) assessment.put('cxr_results', assessmentTCC.CXR_Results__c);
            if (assessmentTCC.Date_Of_Last_Billing__c != null) assessment.put('date_of_last_billing', assessmentTCC.Date_Of_Last_Billing__c.format());
            if (assessmentTCC.Dementia__c != null) assessment.put('dementia', assessmentTCC.Dementia__c);
            if (assessmentTCC.Describe_Prior_Level_Of_Function__c != null) assessment.put('describe_prior_level_of_function', assessmentTCC.Describe_Prior_Level_Of_Function__c);
            if (assessmentTCC.Dialysis__c != null) assessment.put('dialysis', assessmentTCC.Dialysis__c);
            if (assessmentTCC.Dialysis_Access__c != null) assessment.put('dialysis_access', assessmentTCC.Dialysis_Access__c);
            if (assessmentTCC.Dialysis_Schedule__c != null) assessment.put('dialysis_schedule', assessmentTCC.Dialysis_Schedule__c);
            if (assessmentTCC.Dialysis_Transportation__c != null) assessment.put('dialysis_transportation', assessmentTCC.Dialysis_Transportation__c);
            if (assessmentTCC.Dialysis_Type__c != null) assessment.put('dialysis_type', assessmentTCC.Dialysis_Type__c);
            if (assessmentTCC.Diet_Type__c != null) assessment.put('diet_type', assessmentTCC.Diet_Type__c);
            if (assessmentTCC.Discussed_Smoking_Policy__c != null) assessment.put('discussed_smoking_policy', assessmentTCC.Discussed_Smoking_Policy__c);
            if (assessmentTCC.Facility_Tour_Offered__c != null) assessment.put('facility_tour_offered', assessmentTCC.Facility_Tour_Offered__c);
            if (assessmentTCC.Feeding_Tube__c != null) assessment.put('feeding_tube', assessmentTCC.Feeding_Tube__c);
            if (assessmentTCC.Feeding_Tube_Formula__c != null) assessment.put('feeding_tube_formula', assessmentTCC.Feeding_Tube_Formula__c);
            if (assessmentTCC.Feeding_Tube_Rate__c != null) assessment.put('feeding_tube_rate', assessmentTCC.Feeding_Tube_Rate__c);
            if (assessmentTCC.Feeding_Tube_Type__c != null) assessment.put('feeding_tube_type', assessmentTCC.Feeding_Tube_Type__c);
            if (assessmentTCC.Foley__c != null) assessment.put('foley', assessmentTCC.Foley__c);
            if (assessmentTCC.Form_CXR__c != null) assessment.put('form_cxr', assessmentTCC.Form_CXR__c);
            if (assessmentTCC.Form_DC__c != null) assessment.put('form_dc', assessmentTCC.Form_DC__c);
            if (assessmentTCC.Form_Facesheet__c != null) assessment.put('form_facesheet', assessmentTCC.Form_Facesheet__c);
            if (assessmentTCC.Form_HP__c != null) assessment.put('form_hp', assessmentTCC.Form_HP__c);
            if (assessmentTCC.Form_IVSD__c != null) assessment.put('form_ivsd', assessmentTCC.Form_IVSD__c);
            if (assessmentTCC.Form_Labs__c != null) assessment.put('form_labs', assessmentTCC.Form_Labs__c);
            if (assessmentTCC.Form_MAR__c != null) assessment.put('form_mar', assessmentTCC.Form_MAR__c);
            if (assessmentTCC.Form_MRPN__c != null) assessment.put('form_mrpn', assessmentTCC.Form_MRPN__c);
            if (assessmentTCC.Form_MRTN__c != null) assessment.put('form_mrtn', assessmentTCC.Form_MRTN__c);
            if (assessmentTCC.Form_PASSAR__c != null) assessment.put('form_passar', assessmentTCC.Form_PASSAR__c);
            if (assessmentTCC.Form_Scripts__c != null) assessment.put('form_scripts', assessmentTCC.Form_Scripts__c);
            if (assessmentTCC.Height__c != null) assessment.put('height', assessmentTCC.Height__c);
            if (assessmentTCC.High_Cost_Meds__c != null) assessment.put('high_cost_meds', assessmentTCC.High_Cost_Meds__c);
            if (assessmentTCC.Highly_Skilled_Needs__c != null) assessment.put('highly_skilled_needs', assessmentTCC.Highly_Skilled_Needs__c);
            if (assessmentTCC.Incontinence__c != null) assessment.put('incontinence', assessmentTCC.Incontinence__c);
            if (assessmentTCC.Infection__c != null) assessment.put('infection', assessmentTCC.Infection__c);
            if (assessmentTCC.Infection_Location__c != null) assessment.put('infection_location', assessmentTCC.Infection_Location__c);
            if (assessmentTCC.Infection_Type__c != null) assessment.put('infection_type', assessmentTCC.Infection_Type__c);
            if (assessmentTCC.Internal_Bleeding__c != null) assessment.put('internal_bleeding', assessmentTCC.Internal_Bleeding__c);
            if (assessmentTCC.IV_Access__c != null) assessment.put('iv_access', assessmentTCC.IV_Access__c);
            if (assessmentTCC.IV_Meds__c != null) assessment.put('iv_meds', assessmentTCC.IV_Meds__c);
            if (assessmentTCC.Level_2_or_30_Day_Exclusion_Required__c != null) assessment.put('level_2_or_30_day_exclusion_required', assessmentTCC.Level_2_or_30_Day_Exclusion_Required__c);
            if (assessmentTCC.Lmin__c != null) assessment.put('lmin', assessmentTCC.Lmin__c);
            if (assessmentTCC.Medicare_Days_Remaining__c != null) assessment.put('medicare_days_remaining', assessmentTCC.Medicare_Days_Remaining__c);
            if (assessmentTCC.Needs_Patch_At_SNF__c != null) assessment.put('needs_patch_at_snf', assessmentTCC.Needs_Patch_At_SNF__c);
            if (assessmentTCC.O2__c != null) assessment.put('o2', assessmentTCC.O2__c);
            if (assessmentTCC.O2_Delivery__c != null) assessment.put('o2delivery', assessmentTCC.O2_Delivery__c);
            if (assessmentTCC.O2_Treatments__c != null) assessment.put('o2treatments', assessmentTCC.O2_Treatments__c);
            if (assessmentTCC.Order_Faxed__c != null) assessment.put('order_faxed', assessmentTCC.Order_Faxed__c);
            if (assessmentTCC.Ostomy__c != null) assessment.put('ostomy', assessmentTCC.Ostomy__c);
            if (assessmentTCC.Patient_Address__c != null) assessment.put('patient_address', assessmentTCC.Patient_Address__c);
            if (assessmentTCC.Patient_Alternate_Phone__c != null) assessment.put('patient_alternate_phone', assessmentTCC.Patient_Alternate_Phone__c);
            if (assessmentTCC.Patient_Citizenship__c != null) assessment.put('patient_citizenship', assessmentTCC.Patient_Citizenship__c);
            if (assessmentTCC.Patient_City__c != null) assessment.put('patient_city', assessmentTCC.Patient_City__c);
            if (assessmentTCC.Patient_Contact_First_Name__c != null) assessment.put('patient_contact_first_name', assessmentTCC.Patient_Contact_First_Name__c);
            if (assessmentTCC.Patient_Contact_Last_Name__c != null) assessment.put('patient_contact_last_name', assessmentTCC.Patient_Contact_Last_Name__c);
            if (assessmentTCC.Patient_Contact_Middle_Name_Initial__c != null) assessment.put('patient_contact_middle_name_initial', assessmentTCC.Patient_Contact_Middle_Name_Initial__c);
            if (assessmentTCC.Patient_Contact_Name_Suffix__c != null) assessment.put('patient_contact_name_suffix', assessmentTCC.Patient_Contact_Name_Suffix__c);
            if (assessmentTCC.Patient_Contact_Phone__c != null) assessment.put('patient_contact_phone', assessmentTCC.Patient_Contact_Phone__c);
            if (assessmentTCC.Patient_Date_Of_Birth__c != null) assessment.put('patient_date_of_birth', assessmentTCC.Patient_Date_Of_Birth__c.format());
            if (assessmentTCC.Patient_Email_Address__c != null) assessment.put('patient_email_address', assessmentTCC.Patient_Email_Address__c);
            if (assessmentTCC.Patient_Ethnicity__c != null) assessment.put('patient_ethnicity', assessmentTCC.Patient_Ethnicity__c);
            if (assessmentTCC.Patient_First_Name__c != null) assessment.put('patient_first_name', assessmentTCC.Patient_First_Name__c);
            if (assessmentTCC.Patient_Gender__c != null) assessment.put('patient_gender', assessmentTCC.Patient_Gender__c);
            if (assessmentTCC.Patient_Language__c != null) assessment.put('patient_language', assessmentTCC.Patient_Language__c);
            if (assessmentTCC.Patient_Last_Name__c != null) assessment.put('patient_last_name', assessmentTCC.Patient_Last_Name__c);
            if (assessmentTCC.Patient_Middle_Name_Initial__c != null) assessment.put('patient_middle_name_initial', assessmentTCC.Patient_Middle_Name_Initial__c);
            if (assessmentTCC.Patient_Name_Suffix__c != null) assessment.put('patient_name_suffix', assessmentTCC.Patient_Name_Suffix__c);
            if (assessmentTCC.Patient_Postal_Code__c != null) assessment.put('patient_postal_code', assessmentTCC.Patient_Postal_Code__c);
            if (assessmentTCC.Patient_Primary_Phone__c != null) assessment.put('patient_primary_phone', assessmentTCC.Patient_Primary_Phone__c);
            if (assessmentTCC.Patient_Social_Security_Number__c != null) assessment.put('patient_social_security_number', assessmentTCC.Patient_Social_Security_Number__c);
            if (assessmentTCC.Patient_State__c != null) assessment.put('patient_state', assessmentTCC.Patient_State__c);
            if (assessmentTCC.PLOF_ADL__c != null) assessment.put('plof_adl', assessmentTCC.PLOF_ADL__c);
            if (assessmentTCC.PLOF_Ambulation__c != null) assessment.put('plof_ambulation', assessmentTCC.PLOF_Ambulation__c);
            if (assessmentTCC.PLOF_Bed_Mobility__c != null) assessment.put('plof_bed_mobility', assessmentTCC.PLOF_Bed_Mobility__c);
            if (assessmentTCC.PLOF_Transfers__c != null) assessment.put('plof_transfers', assessmentTCC.PLOF_Transfers__c);
            if (assessmentTCC.Primary_Insurance_Id__c != null) assessment.put('primary_insurance_id', assessmentTCC.Primary_Insurance_Id__c);
            if (assessmentTCC.Primary_Insurance_Name__c != null) assessment.put('primary_insurance_name', assessmentTCC.Primary_Insurance_Name__c);
            if (assessmentTCC.Primary_Payer_Source__c != null) assessment.put('primary_payer_source', assessmentTCC.Primary_Payer_Source__c);
            if (assessmentTCC.Prior_Living_Arrangements__c != null) assessment.put('prior_living_arrangements', assessmentTCC.Prior_Living_Arrangements__c);
            if (assessmentTCC.Psych_Diagnosis__c != null) assessment.put('psych_diagnosis', assessmentTCC.Psych_Diagnosis__c);
            if (assessmentTCC.Psych_Diagnosis_Details__c != null) assessment.put('psych_diagnosis_details', assessmentTCC.Psych_Diagnosis_Details__c);
            if (assessmentTCC.Qualifying_Hospital_Stay__c != null) assessment.put('qualifying_hospital_stay', assessmentTCC.Qualifying_Hospital_Stay__c);
            if (assessmentTCC.Qualifying_Hospital_Stay_From_Date__c != null) assessment.put('qualifying_hospital_stay_from_date', assessmentTCC.Qualifying_Hospital_Stay_From_Date__c.format());
            if (assessmentTCC.Qualifying_Hospital_Stay_To_Date__c != null) assessment.put('qualifying_hospital_stay_to_date', assessmentTCC.Qualifying_Hospital_Stay_To_Date__c.format());
            if (assessmentTCC.Reason_Area_Concern__c != null) assessment.put('reason_area_concern', assessmentTCC.Reason_Area_Concern__c);
            if (assessmentTCC.Reason_For_Admission_At_Kindred_Facility__c != null) assessment.put('reason_for_admission_at_kindred_facility', assessmentTCC.Reason_For_Admission_At_Kindred_Facility__c);
            if (assessmentTCC.Reason_For_Reassessment__c != null) assessment.put('reason_for_reassessment', assessmentTCC.Reason_For_Reassessment__c);
            if (assessmentTCC.Referral_Address__c != null) assessment.put('referral_address', assessmentTCC.Referral_Address__c);
            if (assessmentTCC.Referral_City__c != null) assessment.put('referral_city', assessmentTCC.Referral_City__c);
            if (assessmentTCC.Referral_Contact_Alternate_Phone__c != null) assessment.put('referral_contact_alternate_phone', assessmentTCC.Referral_Contact_Alternate_Phone__c);
            if (assessmentTCC.Referral_Date__c != null) assessment.put('referral_date', assessmentTCC.Referral_Date__c.format());
            if (assessmentTCC.Referral_Postal_Code__c != null) assessment.put('referral_postal_code', assessmentTCC.Referral_Postal_Code__c);
            if (assessmentTCC.Referral_Source_Type__c != null) assessment.put('referral_source_type', assessmentTCC.Referral_Source_Type__c);
            if (assessmentTCC.Referral_State__c != null) assessment.put('referral_state', assessmentTCC.Referral_State__c);
            if (assessmentTCC.Restraints__c != null) assessment.put('restraints', assessmentTCC.Restraints__c);
            if (assessmentTCC.Restraints_Type__c != null) assessment.put('restraints_type', assessmentTCC.Restraints_Type__c);
            if (assessmentTCC.Secondary_Insurance_Id__c != null) assessment.put('secondary_insurance_id', assessmentTCC.Secondary_Insurance_Id__c);
            if (assessmentTCC.Secondary_Insurance_Name__c != null) assessment.put('secondary_insurance_name', assessmentTCC.Secondary_Insurance_Name__c);
            if (assessmentTCC.Secondary_Payer_Source__c != null) assessment.put('secondary_payer_source', assessmentTCC.Secondary_Payer_Source__c);
            if (assessmentTCC.Skilled_Needs__c != null) assessment.put('skilled_needs', assessmentTCC.Skilled_Needs__c);
            if (assessmentTCC.Smoker__c != null) assessment.put('smoker', assessmentTCC.Smoker__c);
            if (assessmentTCC.Social_History__c != null) assessment.put('social_history', assessmentTCC.Social_History__c);
            if (assessmentTCC.Special_Diet__c != null) assessment.put('special_diet', assessmentTCC.Special_Diet__c);
            if (assessmentTCC.Special_Equipment__c != null) assessment.put('special_equipment', assessmentTCC.Special_Equipment__c);
            if (assessmentTCC.TPN__c != null) assessment.put('tpn', assessmentTCC.TPN__c);
            if (assessmentTCC.Trach__c != null) assessment.put('trach', assessmentTCC.Trach__c);
            if (assessmentTCC.Trach_Last_Changed_Date__c != null) assessment.put('trach_last_changed_date', assessmentTCC.Trach_Last_Changed_Date__c.format());
            if (assessmentTCC.Trach_Size__c != null) assessment.put('trach_size', assessmentTCC.Trach_Size__c);
            if (assessmentTCC.Trach_Type__c != null) assessment.put('trach_type', assessmentTCC.Trach_Type__c);
            if (assessmentTCC.Vent__c != null) assessment.put('vent', assessmentTCC.Vent__c);
            if (assessmentTCC.Vent_Chronic__c != null) assessment.put('vent_chronic', assessmentTCC.Vent_Chronic__c);
            if (assessmentTCC.Vent_Date_Initiated__c != null) assessment.put('vent_date_initiated', assessmentTCC.Vent_Date_Initiated__c.format());
            if (assessmentTCC.Vent_FIO2__c != null) assessment.put('vent_fio2', assessmentTCC.Vent_FIO2__c);
            if (assessmentTCC.Vent_Mode__c != null) assessment.put('vent_mode', assessmentTCC.Vent_Mode__c);
            if (assessmentTCC.Vent_PEEP__c != null) assessment.put('vent_peep', assessmentTCC.Vent_PEEP__c);
            if (assessmentTCC.Vent_PS__c != null) assessment.put('vent_ps', assessmentTCC.Vent_PS__c);
            if (assessmentTCC.Vent_Rate__c != null) assessment.put('vent_rate', assessmentTCC.Vent_Rate__c);
            if (assessmentTCC.Vent_TV__c != null) assessment.put('vent_tv', assessmentTCC.Vent_TV__c);
            if (assessmentTCC.Vent_Weaning__c != null) assessment.put('vent_weaning', assessmentTCC.Vent_Weaning__c);
            if (assessmentTCC.Virtual_Tour_Given__c != null) assessment.put('virtual_tour_given', assessmentTCC.Virtual_Tour_Given__c);
            if (assessmentTCC.Weight__c != null) assessment.put('weight', assessmentTCC.Weight__c);
            if (assessmentTCC.Wounds__c != null) assessment.put('wounds', assessmentTCC.Wounds__c);
            if (assessmentTCC.Wound_Type__c != null) assessment.put('wound_type', assessmentTCC.Wound_Type__c);
            
            JSON.serialize(assessment);
            return assessment;
        } else {
            return null;
        }
        //return null;
    }
    
}