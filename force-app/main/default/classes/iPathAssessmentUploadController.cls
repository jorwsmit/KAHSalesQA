@RestResource(urlMapping='/PatientAssessmentUpload/*')
global class iPathAssessmentUploadController { 

    // Custom Exception
    public class AssessmentException extends Exception{}
    
    public class assessment_error {
        String meta_filename;
    }
    
    public class form_metadata {
        DateTime meta_creation_date;
        DateTime meta_reassessment_date;
        DateTime meta_submitted_date;

        Decimal meta_bookmark;
        Decimal meta_form_type;
        Decimal meta_manual_bookmark;
        
        String meta_chainuuid;
        String meta_document_version;
        String meta_document_status;
        String meta_filename;
    }

    public class consulting_mds_group_item {
        String consulting_mds_name;
        String consulting_mds_sfid;
    }
    
    public class primary_physician_group_item {
        String primary_physician_name;
        Id primary_physician_sfid;
    }

    public class primary_care_physician_group_item {
        String primary_care_physician_name;
        Id primary_care_physician_sfid;
    }
    
    public class referral_contact_group_item {
        String referral_contact_name;
        Id referral_contact_sfid;
    }
    
    public class referring_contact_group_item {
        String referring_contact_name;
        Id referring_contact_sfid;
    }
    
    public class referral_location_group_item {
        String referral_location_name;
        Id referral_location_sfid;
    }

    public class referring_location_group_item {
        String referring_location_name;
        Id referring_location_sfid;
    }
    
    public class referral_physician_group_item {
        String referral_physician_name;
        Id referral_physician_sfid;
    }

    public class referring_physician_group_item {
        String referring_physician_name;
        Id referring_physician_sfid;
    }

    public class kindred_attending_physician_group_item {
        String kindred_attending_md_name;
        Id kindred_attending_md_sfid;       
    }
    
    public class refer_to_tch_group_item {
        String refer_to_name; 
        Id refer_to_sfid;
    }

    public class patient_demographics_refer_to_tch_group_item {
       String patient_demographics_refer_to_name;
       Id patient_demographics_refer_to_sfid;
    }
    
    public class refer_to_tcc_group_item {
        String refer_to_name;
        Id refer_to_sfid;
    }

    public class variable_contact_group_item {
        String app_timestamp;
        String contact_address;
        String contact_first_name;
        String contact_relationship;
        String contact_last_name;
        String contact_type;
        String contact_state;
        String contact_city;
        String contact_primary_phone;
        String contact_postal_code;
        String contact_cell_phone;
        String contact_alternate_phone;
        String contact_email_address;

        String patient_contact_first_name;
        String patient_contact_last_name;
        String patient_contact_phone;
    }
    
    public class culture_history_mutable_group_item {
        Date culture_date;
        Date culture_start_date;
        Date culture_stop_date;

        String app_timestamp;
        String culture_iv_antibiotic;
        String culture_organism;
        String culture_site;
    }
    
    public class integumentary_mutable_tch_group_item {
        String app_timestamp;
        String integ_skin_item_comments;
        String skin_item_site;
        String skin_item_stage;
        String skin_item_stage_size;
    }
    
    public class integumentary_mutable_tcc_group_item {
        String app_timestamp;
        String skin_item_treatment;
        String skin_item_site;
        String skin_item_stage;
        String skin_item_stage_size;
    }
    
    public class multiple_line_group_item {
        Date line_insertion_date;

        String app_timestamp;
        String line_cl_type;
        String line_location;
    }
    
    public class multiple_medications_group_item {
        String app_timestamp;
        String medication_dosage;
        String medication_frequency;
        String medication_name;
        String medication_route;
    }
    
    public class TCH {
        List <consulting_mds_group_item> consulting_mds; 
        List <primary_physician_group_item> primary_physician;
        List <primary_care_physician_group_item> primary_care_physician;
        List <referral_contact_group_item> referral_contact;
        List <referring_contact_group_item> referring_contact;
        List <referral_location_group_item> referral_location;
        List <referring_location_group_item> referring_location;
        List <referral_physician_group_item> referral_physician;
        List <referring_physician_group_item> referring_physician;
        List <patient_demographics_refer_to_tch_group_item> patient_demographics_refer_to;
        List <refer_to_tch_group_item> refer_to;
        List <variable_contact_group_item> variable_contact_group;
        List <kindred_attending_physician_group_item> kindred_attending_md;
        List <culture_history_mutable_group_item> culture_history_mutable_group;
        List <integumentary_mutable_tch_group_item> itegumentary_mutable_group;
        List <multiple_line_group_item> multiple_line_group;
        List <multiple_medications_group_item> multiple_medications_group;
        
        String actively_managed_comorbidities;
        String additional_referring_facility_course_summary;
        String information_current_new_problems;
        String information_identify;
        String information_kindred_diagnostics;
        String information_new_consultants;
        String information_new_surgery;
        Date information_reassessment_date;
        Date patient_demographics_admit_date;
        Date patient_demographics_referral_date;
        Date patient_demographics_referral_time;
        String patient_first_name;
        String patient_middle_name_initial;
        String patient_last_name;
        String patient_name_suffix;
        String patient_address;
        String patient_city;
        String patient_state;
        String patient_postal_code;
        String patient_social_security_number;
        Date patient_date_of_birth;
        String patient_age;
        String patient_cell_phone;
        String patient_primary_phone;
        String patient_alternate_phone;
        String patient_email_address;
        String patient_gender;
        String patient_ethnicity;
        String tribal_affiliations;
        String patient_language;
        String patient_religion;
        String patient_marital_status;
        String patient_living_will;
        String advance_directives;
        String patient_able_to_sign_consent;
        String consent_signed_by;
        String code_status;
        String referral_source_type;
        String referral_location_phone;
        String referral_address;
        String referral_city;
        String referral_state;
        String referral_postal_code;
        String referral_contact_phone;
        String referring_contact_phone;
        String referral_alt_phone;
        String referral_contact_alternate_phone;
        String referral_physician_phone_number;
        String primary_physician_phone;
        String primary_care_physician_phone;
        String patient_physically_seen;
        String family_contacted;
        String kindred_plan_of_discharge_discussed;
        String extraordinary_needs_info_about_patient;
        String nursing_unit_type;
        String nursing_unit_name;
        String nursing_unit_number;
        String present_nursing_unit_room_number;
        Date current_admission_date;
        Date current_admit_date;
        String nursing_unit_phone;
        String icu_dates_required;
        Date icu_date1;
        Date icu_date2;
        Date icu_date3;
        Date icu_date4;
        String ccu_dates_required;
        Date ccu_date1;
        Date ccu_date2;
        Date ccu_date3;
        Date ccu_date4;
        String step_down_dates_required;
        Date stepdown_date1;
        Date stepdown_date2;
        Date stepdown_date3;
        Date stepdown_date4;
        String financial_approval_per_cfo_designee;
        String primary_payer_source;
        String primary_insurance_id;
        String pre_cert_needed_primary;
        String primary_insurance_copy;
        String primary_insurance_name;
        String primary_hic;
        String secondary_payer_source;
        String secondary_insurance_id;
        String pre_cert_needed_secondary;
        String secondary_insurance_copy;
        String secondary_insurance_name;
        String secondary_hic;
        String employer_name;
        String employer_group_name;
        String employer_phone_number;
        String employment_status;
        Date prior_hospitalization_start;
        Date prior_hospitalization_end;
        Date prior_snf_start;
        Date prior_snf_end;
        String snf_days_remaining;
        String ip_days_remaining;
        Date medicaid_start;
        String medicaid_member_id;
        String medicaid_authorization_number;
        String medicaid_contact_name;
        String medicaid_contact_phone;
        String mgmt_group_name;
        String mgmt_group_phone;
        String third_party_admin_name;
        String third_party_admin_phone;
        Date physiological_date;
        String physiological_temp;
        String physiological_sbp;
        String physiological_dbp;
        String physiological_hr;
        String physiological_rr;
        String physiological_state;
        String prior_living_arrangements;
        String prior_living_arrangements_addition_details;
        String lives_with;
        String lives_with_additional_details;
        String plan_to_return;
        String plan_of_discharge;
        String plan_of_discharge_additional_details;
        String family_dynamics_coping;
        String psychosis;
        String psychosis_additional_details;
        String personality_disorder;
        String personality_disorder_additional_details;
        String psych_retardation;
        String psych_retardation_additional_details;
        String psych_social_behavior;
        String psych_social_meds;
        String other_psychoactive_meds_details;
        String risk_of_injury;
        String risk_of_injury_additional_details;
        String history_of_incarceration;
        String history_of_incarceration_additional_details;
        String risk_of_elopement;
        String risk_of_elopement_additional_details;
        String history_of_restraints;
        String restraints;
        String current_restraints;
        String restraints_type;
        String restraints_type_additional_details;
        String additional_psych_social_details;
        Date neurological_info_date;
        String gcs_eyes_open;
        String motor_response;
        String verbal_response;
        String gc_meds;
        String additional_neurological_details;
        String dialysis_not_applicable;
        String dialysis;
        String dialysis_information_type;
        String dialysis_modality;
        String dialysis_started_at_stac;
        String dialysis_location_of_initial;
        Date dialysis_hepb_panel_date;
        Date dialysis_date_of_initial;
        String dialysis_hepb_core_antibody;
        String dialysis_hepb_surface_antigen;
        String dialysis_hepb_surface_antibody;
        String dialysis_information_schedule;
        String dialysis_schedule;
        String dialysis_information_schedule_specify;
        String dialysis_information_access;
        String dialysis_access;
        String fistula_comment;
        Date wbc_date;
        String wbc_value;
        Date rbc_date;
        String rbc_value;
        Date hemoglobin_date;
        String hemoglobin_value;
        Date hematocrit_date;
        String hematocrit_value;
        Date platelets_date;
        String platelets_value;
        Date sodium_date;
        String sodium_value;
        Date potassium_date;
        String potassium_value;
        Date chloride_date;
        String chloride_value;
        Date co2_date;
        String co2_value;
        Date bun_date;
        String bun_value;
        Date creatinine_date;
        String creatinine_value;
        Date glucose_date;
        String glucose_value_low;
        String glucose_value_high;
        Date magnesium_date;
        String magnesium_value;
        Date albumin_date;
        String albumin_value;
        Date prealb_date;
        String prealb_value;
        Date bilrubin_date;
        String bilrubin_value;
        Date pt_date;
        String pt_value;
        Date ptt_date;
        String ptt_value;
        Date inr_date;
        String inr_value;
        String other_1_name;
        Date other_1_date;
        String other_1_value;
        String other_2_name;
        Date other_2_date;
        String other_2_value;
        String blood_product_given;
        String blood_product_type;
        Date blood_product_last_date;
        String current_precautions;
        String infectious_disease_history;
        String organism_history_tb;
        String organism_history_tb_status;
        String organism_history_cdiff;
        String organism_history_cdiff_status;
        String organism_history_mrsa;
        String organism_history_mrsa_status;
        String organism_history_vre;
        String organism_history_vre_status;
        String organism_history_cre;
        String organism_history_cre_status;
        String organism_history_acinetobacteria;
        String organism_history_acinetobacteria_status;
        String organism_history_esbl;
        String organism_history_esbl_status;
        String organism_history_mdro;
        String organism_history_mdro_specify;
        String organism_history_mdro_status;
        String organism_history_other;
        String organism_history_other_specify;
        String organism_history_other_status;
        String organism_history_comments;
        Date culture_date;
        String culture_site;
        String culture_organism;
        String culture_iv_antibiotic;
        Date culture_start_date;
        Date culture_stop_date;
        Date cardiovascular_date;
        String cardiovascular_rhythm;
        String cardiovascular_rhythm_type;
        String cardiovascular_rhythm_location;
        String echocardiogram;
        String ejection_fraction;
        String respiratory_o2_lpm;
        String lmin;
        String o2_flow_mode;
        String respiratory_o2_delivery;
        String o2delivery;
        String respiratory_treatments;
        String o2treatments;
        String respiration_frequency;
        String o2_sats;
        String o2_sats_other;
        String respiratory_trach_type;
        String trach_type;
        String respiratory_trach_size;
        String trach_size;
        Date trach_date;
        String respiratory_chest_tube;
        String respiratory_tube_location;
        String respiratory_cpap;
        String respiratory_bipap;
        String respiratory_not_applicable;
        String o2;
        String respiratory_vent_mode;
        String vent_mode;
        String respiratory_rate;
        String vent_rate;
        String respiratory_fi02;
        String vent_fio2;
        String respiratory_tv;
        String vent_tv;
        String respiratory_ps;
        String vent_ps;
        String respiratory_peep;
        String vent_peep;
        String respiratory_weaning;
        String vent_weaning;
        String respiratory_weaning_attempts;
        String respiratory_not_tolerated;
        String respiratory_not_tolerated_specify;
        String respiratory_weaning_mode;
        String respiratory_et_tube;
        String respiratory_tube_size;
        String abg_not_applicable;
        String bg_type;
        Date abg_date;
        String abg_fi02;
        String abg_fio2;
        String abg_pao2;
        String abg_paco2;
        String abg_ph;
        String abg_bicarb;
        String abg_be;
        String cxr_not_applicable;
        String cxr;
        Date cxr_date;
        String results_selection;
        String cxr_results_specify;
        String cxr_results;
        String additional_respiratory_details;
        Date gi_gu_date_taken;
        String gi_bleeds;
        String gi_gu_height;
        String height;
        String gi_gu_height_units;
        String gi_gu_weight;
        String weight;
        String gi_gu_weight_units;
        String gi_gu_diet_order;
        String diet_type;
        String gi_gu_texture;
        String gi_gu_liquid_consistency;
        String gi_gu_supplement_schedule;
        String gi_gu_tube_type;
        String feeding_tube_type;
        String gi_gu_formula_name;
        String gi_gu_recent_asperation_rate;
        String gi_gu_recent_aspiration;
        String gi_gu_parenteral_nutrition;
        Date gi_gu_initiation_date;
        String gi_gu_date_initation_rate;
        String feeding_tube_rate;
        String io_in;
        String io_out;
        String urine_describe;
        String recent_weight_change;
        String foley;
        Date foley_date;
        String rectal_tube;
        Date rectal_date;
        String last_bm;
        String urostomy;
        Date urostomy_date;
        String colostomy;
        Date colostomy_date;
        String ileostomy;
        Date ileostomy_date;
        String musculoskeletal_limits;
        String musculoskeletal_orthotics;
        String musculoskeletal_casts_splints;
        String musculoskeletal_ted_hose;
        String musculoskeletal_scd;
        String prior_functional_status;
        String musculoskeletal_contractures;
        String musculoskeletal_contractures_specify;
        String contractures_weight_bearing;
        String contractures_reason;
        String musculoskeletal_activity_level;
        String mus_assistive_devices;
        String musculoskeletal_traction;
        String traction_type;
        String traction_weight;
        String musculoskeletal_recent_falls;
        String rehab_type;
        String rehab_ambulate;
        String rehab_transfer;
        String activities_of_daily_living;
        String rehab_anticipated;
        String rehab_additional_details;
        String medication_mars;
        String medication_mars_pages;
        String medication_allergies;
        String medication_drips;
        String iv_meds;
        String medication_drips_specify;
        String medication_iv_access;
        String iv_access;
        String medication_iv_access_picc_specify;
        String medication_iv_access_specify;
        String medication_name;
        String medication_dosage;
        String medication_frequency;
        String medication_route;
        String line_cl_type;
        String line_location;
        Date line_insertion_date;
        String integumentary_summary;
        String integumentary_bed_type;
        String skin_item_site;
        String skin_item_stage_size;
        String skin_item_stage;
        String integ_skin_item_comments;
        String skin_item_comments;
        String recalcitrant_wounds;
        String state_name;
        String rogers_orders;
        String physicians_orders;
        String air_embolism;
        String pressure_ulcers;
        String catheter_associated_urinary_tract_infection;
        String vascular_catheter_associated_infection;
        String manifestations_of_poor_glycemic_control;
        String falls_or_trauma_with_injuries;
        String surgical_site_infection;
        String dvt_post_knee;
        String admission_type;
        String number_days_out;
        String type_of_assessment;
        String bed_needs;
        String specify_bed_needs;
        String kindred_hospital;
        String historical_info_narrative;
        String primary_ltac_admission_reason;
        String historical_info_precautions;
        String icd9;
        String additional_notes_overall;
        String medicare_days_1;
        String medicare_days_2;
        String medicare_days_3;
        String summary_secondary;
        String summary_non_government;
        String lower_level_care_failure;
        String failure_reasons;
        String medical_surgery_history;
        String hospital_referring_facility_course_summary;
        String pneumoccal_vaccination_not_applicable;
        String pneumoccal_vaccination_date;
        String flu_vacc_not_applicable;
        Date influenza_vaccination_date;
        String influenza_reason;
        String continued_stay_criteria;
        String mc_clinical_status_label;
        String mc_medical_complex;
        String mc_renal_insufficiency_details;
        String mc_malignant_endstage_disease_details;
        String mc_gastrointestinal_condition_details;
        String mc_bone_marrow_details;
        String mc_cardiac_details;
        String mc_infection_details;
        String mc_pneumonia;
        String mc_pyelonephritis;
        String mc_systemic_organ;
        String mc_surgical_wound;
        String mc_active_comorbid_conditions;
        String mc_treatments_to_consider;
        String mc_clinical_status_includes_all;
        String rs_clinical_status_label;
        String rs_respiratory_complex;
        String rs_failed_at_lloc;
        String rs_hypoxia;
        String rs_post_event;
        String rs_active_comorbid_conditions;
        String rs_treatments_to_consider;
        String rs_clinical_status_includes_all;
        String ventilator_group_weaning_potential_label1;
        String vn_vent_dependence;
        String vn_no_prior_weaning;
        String vn_treatments_to_consider;
        String vn_weaning_includes;
        String wc_clinical_status_label;
        String wc_wound_skin_condition;
        String wc_large_wound;
        String wc_lower_extremity_conditions;
        String wc_lower_extremity_risk_factors;
        String wc_infection;
        String wc_active_comorbid_conditions;
        String wc_treatments_to_consider;
        String wc_clinical_status_includes_all;
        String prior_device_use;
        String prior_functioning_activity_level;
        String admitted_to_stac_on_vent;
        String chronic_vent;
        Date date_initiated_vent;
    }

    public class TCC {
        List <primary_care_physician_group_item> primary_care_physician;
        List <refer_to_tcc_group_item> refer_to;
        List <referring_location_group_item> referring_location;
        List <referring_contact_group_item> referring_contact;
        List <referring_physician_group_item> referring_physician;
        List <culture_history_mutable_group_item> culture_history_mutable_group;
        List <integumentary_mutable_tcc_group_item> itegumentary_mutable_group;
        List <multiple_line_group_item> multiple_line_group;
        List <multiple_medications_group_item> multiple_medications_group;

        String patient_first_name;
        String patient_middle_name_initial;
        String patient_last_name;
        String patient_name_suffix;
        Date patient_date_of_birth;
        String patient_social_security_number;
        String patient_address;
        String patient_city;
        String patient_state;
        String patient_postal_code;
        String patient_primary_phone;
        String patient_alternate_phone;
        String patient_email_address;
        String patient_gender;
        String patient_ethnicity;
        String patient_citizenship;
        String patient_language;
        String primary_payer_source;
        String primary_insurance_name;
        String primary_insurance_id;
        String secondary_payer_source;
        String secondary_insurance_name;
        String secondary_insurance_id;
        String medicare_days_remaining;
        Date date_of_last_billing;
        String qualifying_hospital_stay;
        Date qualifying_hospital_stay_from_date;
        Date qualifying_hospital_stay_to_date;
        String aco;
        String X3_day_waiver;
        Date referral_date;
        Date anticipated_admit_date;
        Date current_admit_date;
        String referral_source_type;
        String primary_care_physician_phone;
        String bedside_visit_made;
        String virtual_tour_given;
        String facility_tour_offered;
        String bed_hold;
        String patient_contact_first_name;
        String patient_contact_middle_name_initial;
        String patient_contact_last_name;
        String patient_contact_name_suffix;
        String contact_type;
        String contact_relationship;
        String patient_contact_phone;
        String referral_address;
        String referral_city;
        String referral_state;
        String referral_postal_code;
        String referral_contact_alternate_phone;
        String prior_living_arrangements;
        String social_history;
        String reason_for_admission_at_kindred_facility;
        String clinical_summary;
        String bed_offer_made;
        String reason_area_concern;
        String skilled_needs;
        String assistive_devices_specialty_equipment;
        String assistive_devices_specialty_equipment_details;
        String high_cost_meds;
        String highly_skilled_needs;
        String foley;
        String ostomy;
        String incontinence;
        String internal_bleeding;
        String wounds;
        String wound_type;
        String special_equipment;
        String wounds_group;
        String main_wounds_group;
        String reason_for_reassessment;
        String clof_adl;
        String clof_bed_mobility;
        String clof_transfers;
        String clof_ambulation;
        String plof_adl;
        String plof_bed_mobility;
        String plof_transfers;
        String plof_ambulation;
        String describe_prior_level_of_function;
        String current_mental_status_behavior;
        String restraints;
        String restraints_type;
        String psych_diagnosis;
        String psych_diagnosis_details;
        String dementia;
        String level_2_or_30_day_exclusion_required;
        String dialysis;
        String dialysis_type;
        String dialysis_schedule;
        String dialysis_access;
        String dialysis_transportation;
        String special_diet;
        String diet_type;
        String height;
        String weight;
        String tpn;
        String order_faxed;
        String feeding_tube;
        String feeding_tube_type;
        String feeding_tube_formula;
        String feeding_tube_rate;
        String feeding_tube_group;
        String main_feeding_tube_group;
        String infection;
        String infection_type;
        String infection_location;
        String o2;
        String lmin;
        String o2delivery;
        String o2treatments;
        String vent;
        String vent_mode;
        String vent_rate;
        String vent_fio2;
        String vent_tv;
        String vent_ps;
        String vent_peep;
        String vent_chronic;
        Date vent_date_initiated;
        String vent_weaning;
        String trach;
        String trach_size;
        String trach_type;
        Date trach_last_changed_date;
        String cxr;
        Date cxr_date;
        String cxr_results;
        String smoker;
        String discussed_smoking_policy;
        String needs_patch_at_snf;
        String iv_meds;
        String iv_access;
        String allergies;
        String chemo_radiation;
        String chemo_radiation_treatment;
        String form_cxr;
        String form_mar;
        String form_facesheet;
        String form_hp;
        String form_labs;
        String form_mrtn;
        String form_mrpn;
        String form_dc;
        String form_ivsd;
        String form_passar;
        String form_scripts;
    }
    
    private static String convertEmailToNullIfInvalid (String email) {
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
    
        if(String.isNotBlank(email) && Pattern.matches(emailRegex, email)) {
            return email;
        }
        else {
            return null;
        }
    }
    
    @HttpPost
    global static Map<String,String> createNewAssessment() {
        RestRequest req = RestContext.request;
          
        try {
            //Determine FormType
            form_metadata metadata = (form_metadata)System.JSON.deserialize(req.requestBody.toString(), form_metadata.class);
            if (metadata.meta_form_type == 61 || metadata.meta_form_type == 62 || metadata.meta_form_type == 73 || metadata.meta_form_type == 74) {      
                
                if(metadata.meta_document_status != '1' && metadata.meta_document_status != '2') {
                    return new Map<String,String> {'Result' => 'Invalid Status', 'Filename' => metadata.meta_filename};
                }
                
                //If somehow we're trying to re-save an already saved submitted document, then feign "Success" so the client can delete the doc from its upload queue
                if(metadata.meta_document_status == '2') {
                    List<Assessment_TCC__c> submitted = [SELECT Id, Meta_Owner__c FROM Assessment_TCC__c WHERE Meta_Filename__c = :metadata.meta_filename AND Meta_Document_Status__c = '2' FOR UPDATE];
                    
                    if(!submitted.isEmpty()) {
                         if (submitted[0].Meta_Owner__c == null) {
                              submitted[0].Meta_Owner__c = UserInfo.getUserId();
                              update submitted[0];
                         }
                         return new Map<String,String> {'Result' => 'SuccessOnPreviousCall', 'Filename' => metadata.meta_filename, 'ObjectID' => submitted[0].Id};
                    }
                }
                
                //Deserialize Appropriately
                TCC deserializeResults = (TCC)System.JSON.deserialize(req.requestBody.toString(), TCC.class);

                //Delete older unsubmitted versions
                if (metadata.meta_chainuuid != null) {
                    List<Assessment_TCC__c> oldAssessments = [SELECT Id FROM Assessment_TCC__c WHERE Meta_ChainUUID__c = :metadata.meta_chainuuid AND Meta_Document_Status__c != '2' FOR UPDATE];
                    delete oldAssessments;
                }

                //Version Hardening
                if (metadata.meta_chainuuid != null) {
                     List<Assessment_TCC__c> oldAssessments = [SELECT Id, Meta_Document_Version__c, Meta_ChainUUID__c FROM Assessment_TCC__c WHERE Meta_ChainUUID__c = :metadata.meta_chainuuid ORDER BY CreatedDate ASC];
                     if (!oldAssessments.isEmpty()) {
                          if (oldAssessments.size() > 1) {
                               for (Integer i = 0; i < oldAssessments.size() - 1; i++) {
                                  Assessment_TCC__c firstAssessment = oldAssessments[i];
                                  Assessment_TCC__c secondAssessment = oldAssessments[i+1];
                                  if (Decimal.ValueOf(firstAssessment.Meta_Document_Version__c) + 1 != Decimal.ValueOf(secondAssessment.Meta_Document_Version__c)) {
                                       throw new AssessmentException('Chain is out of sequence (first=' + firstAssessment.Meta_Document_Version__c + ', second=' + secondAssessment.Meta_Document_Version__c + '); ');
                                  }
                              } 
                          }
                          
                          Assessment_TCC__c mostRecentServerSideAssessment = oldAssessments[oldAssessments.size()-1];
                          if (Decimal.ValueOf(mostRecentServerSideAssessment.Meta_Document_Version__c) + 1 != Decimal.ValueOf(metadata.meta_document_version)) {
                               throw new AssessmentException('Uploaded document is out of sequence (mostRecent=' + mostRecentServerSideAssessment.Meta_Document_Version__c + ', uploaded=' + metadata.meta_document_version + '); ');
                          }
                     } else {
                          if (metadata.meta_document_version != '0') {
                               throw new AssessmentException('First document in chain should have version 0 (uploaded=' + metadata.meta_document_version + '); ');
                          }
                     }
                }

                //Insert Patient
                Assessment_Patient__c patient = new Assessment_Patient__c();

                patient.Address__c = deserializeResults.patient_address;
                patient.Citizenship__c = deserializeResults.patient_citizenship;
                patient.City__c = deserializeResults.patient_city;
                patient.Date_Of_Birth__c = deserializeResults.patient_date_of_birth;
                patient.Email__c = convertEmailToNullIfInvalid(deserializeResults.patient_email_address);
                patient.Ethnicity__c = deserializeResults.patient_ethnicity;
                patient.First_Name__c = deserializeResults.patient_first_name;
                patient.Gender__c = deserializeResults.patient_gender;
                patient.Languages__c = deserializeResults.patient_language;
                patient.Last_Name__c = deserializeResults.patient_last_name;
                patient.Middle_Initial__c = deserializeResults.patient_middle_name_initial;
                patient.Phone_1__c = deserializeResults.patient_primary_phone;
                patient.Phone_2__c = deserializeResults.patient_alternate_phone;
                patient.Postal_Code__c = deserializeResults.patient_postal_code;
                patient.Primary_Insurance_ID__c = deserializeResults.primary_insurance_id;
                patient.Primary_Insurance_Name__c = deserializeResults.primary_insurance_name;
                patient.Primary_Payer_Source__c = deserializeResults.primary_payer_source;
                if (deserializeResults.primary_care_physician != null && deserializeResults.primary_care_physician.size() > 0) {
                    for (primary_care_physician_group_item physician: deserializeResults.primary_care_physician) {
                        if (physician.primary_care_physician_sfid != null) {
                            if (physician.primary_care_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                patient.Primary_Physician_As_Contact__c = physician.primary_care_physician_sfid;
                            } else if(physician.primary_care_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                patient.Primary_Physician_As_Lead__c = physician.primary_care_physician_sfid; 
                            }
                        }
                    }
                }
                patient.Secondary_Insurance_ID__c = deserializeResults.secondary_insurance_id;
                patient.Secondary_Insurance_Name__c = deserializeResults.secondary_insurance_name;
                patient.Secondary_Payer_Source__c = deserializeResults.secondary_payer_source;
                patient.Social_Security_Number__c = deserializeResults.patient_social_security_number;
                patient.State__c = deserializeResults.patient_state;
                patient.Suffix__c = deserializeResults.patient_name_suffix;
                insert patient;

                //Insert Assessment
                Assessment_TCC__c assessmentTCC = new Assessment_TCC__c();

                assessmentTCC.Meta_ChainUUID__c = metadata.meta_chainuuid;
                assessmentTCC.Meta_Document_Version__c = metadata.meta_document_version;
                assessmentTCC.Meta_Bookmark__c = metadata.meta_bookmark;
                assessmentTCC.Meta_Creation_Date__c = metadata.meta_creation_date;
                assessmentTCC.Meta_Document_Status__c = metadata.meta_document_status;
                assessmentTCC.Meta_Filename__c = metadata.meta_filename;
                assessmentTCC.Meta_Form_Type__c = metadata.meta_form_type;          
                assessmentTCC.Meta_Manual_Bookmark__c = metadata.meta_manual_bookmark;
                assessmentTCC.Meta_Reassessment_Date__c = metadata.meta_reassessment_date;          
                assessmentTCC.Meta_Submitted_Date__c = metadata.meta_submitted_date;
                
                assessmentTCC.Meta_Owner__c = UserInfo.getUserId();

                assessmentTCC.X3_Day_Waiver__c = deserializeResults.X3_day_waiver;
                assessmentTCC.ACO__c = deserializeResults.aco;
                assessmentTCC.Allergies__c = deserializeResults.allergies;
                assessmentTCC.Anticipated_Admit_Date__c = deserializeResults.anticipated_admit_date;
                assessmentTCC.Assessment_Patient__c = patient.id;
                assessmentTCC.Assistive_Devices_Specialty_Equipment__c = deserializeResults.assistive_devices_specialty_equipment;
                assessmentTCC.Assistive_Devices_Specialty_Equipment_De__c = deserializeResults.assistive_devices_specialty_equipment_details;
                assessmentTCC.Bed_Hold__c = deserializeResults.bed_hold;
                assessmentTCC.Bed_Offer_Made__c = deserializeResults.bed_offer_made;
                assessmentTCC.Bedside_Visit_Made__c = deserializeResults.bedside_visit_made;
                assessmentTCC.Chemo_Radiation__c = deserializeResults.chemo_radiation;
                assessmentTCC.Chemo_Radiation_Treatment__c = deserializeResults.chemo_radiation_treatment;
                assessmentTCC.Clinical_Summary__c = deserializeResults.clinical_summary;
                assessmentTCC.CLOF_ADL__c = deserializeResults.clof_adl;
                assessmentTCC.CLOF_Ambulation__c = deserializeResults.clof_ambulation;
                assessmentTCC.CLOF_Bed_Mobility__c = deserializeResults.clof_bed_mobility;
                assessmentTCC.CLOF_Transfers__c = deserializeResults.clof_transfers;
                assessmentTCC.Contact_Relationship__c = deserializeResults.contact_relationship;
                assessmentTCC.Contact_Type__c = deserializeResults.contact_type;
                assessmentTCC.Current_Admit_Date__c = deserializeResults.current_admit_date;            
                assessmentTCC.Current_Mental_Status_Behavior__c = deserializeResults.current_mental_status_behavior;
                assessmentTCC.CXR__c = deserializeResults.cxr;
                assessmentTCC.CXR_Date__c = deserializeResults.cxr_date;
                assessmentTCC.CXR_Results__c = deserializeResults.cxr_results;
                assessmentTCC.Date_Of_Last_Billing__c = deserializeResults.date_of_last_billing;
                assessmentTCC.Dementia__c = deserializeResults.dementia;
                assessmentTCC.Describe_Prior_Level_Of_Function__c = deserializeResults.describe_prior_level_of_function;
                assessmentTCC.Dialysis__c = deserializeResults.dialysis;            
                assessmentTCC.Dialysis_Access__c = deserializeResults.dialysis_access;
                assessmentTCC.Dialysis_Schedule__c = deserializeResults.dialysis_schedule;
                assessmentTCC.Dialysis_Transportation__c = deserializeResults.dialysis_transportation;
                assessmentTCC.Dialysis_Type__c = deserializeResults.dialysis_type;
                assessmentTCC.Diet_Type__c = deserializeResults.diet_type;
                assessmentTCC.Discussed_Smoking_Policy__c = deserializeResults.discussed_smoking_policy;
                assessmentTCC.Facility_Tour_Offered__c = deserializeResults.facility_tour_offered;
                assessmentTCC.Feeding_Tube__c = deserializeResults.feeding_tube;
                assessmentTCC.Feeding_Tube_Formula__c = deserializeResults.feeding_tube_formula;
                assessmentTCC.Feeding_Tube_Rate__c = deserializeResults.feeding_tube_rate;
                assessmentTCC.Feeding_Tube_Type__c = deserializeResults.feeding_tube_type;
                assessmentTCC.Foley__c = deserializeResults.foley;
                assessmentTCC.Form_CXR__c = deserializeResults.form_cxr;
                assessmentTCC.Form_DC__c = deserializeResults.form_dc;
                assessmentTCC.Form_Facesheet__c = deserializeResults.form_facesheet;
                assessmentTCC.Form_HP__c = deserializeResults.form_hp;
                assessmentTCC.Form_IVSD__c = deserializeResults.form_ivsd;
                assessmentTCC.Form_Labs__c = deserializeResults.form_labs;
                assessmentTCC.Form_MAR__c = deserializeResults.form_mar;
                assessmentTCC.Form_MRPN__c = deserializeResults.form_mrpn;
                assessmentTCC.Form_MRTN__c = deserializeResults.form_mrtn;
                assessmentTCC.Form_PASSAR__c = deserializeResults.form_passar;
                assessmentTCC.Form_Scripts__c = deserializeResults.form_scripts;
                assessmentTCC.Height__c = deserializeResults.height;
                assessmentTCC.High_Cost_Meds__c = deserializeResults.high_cost_meds;
                assessmentTCC.Highly_Skilled_Needs__c = deserializeResults.highly_skilled_needs;
                assessmentTCC.Incontinence__c = deserializeResults.incontinence;
                assessmentTCC.Infection__c = deserializeResults.infection;
                assessmentTCC.Infection_Location__c = deserializeResults.infection_location;
                assessmentTCC.Infection_Type__c = deserializeResults.infection_type;
                assessmentTCC.Internal_Bleeding__c = deserializeResults.internal_bleeding;
                assessmentTCC.IV_Access__c = deserializeResults.iv_access;
                assessmentTCC.IV_Meds__c = deserializeResults.iv_meds;          
                assessmentTCC.Level_2_or_30_Day_Exclusion_Required__c = deserializeResults.level_2_or_30_day_exclusion_required;
                assessmentTCC.Lmin__c = deserializeResults.lmin;
                assessmentTCC.Medicare_Days_Remaining__c = deserializeResults.medicare_days_remaining;
                assessmentTCC.Needs_Patch_At_SNF__c = deserializeResults.needs_patch_at_snf;
                assessmentTCC.O2__c = deserializeResults.o2;
                assessmentTCC.O2_Delivery__c = deserializeResults.o2delivery;           
                assessmentTCC.O2_Treatments__c = deserializeResults.o2treatments;
                assessmentTCC.Order_Faxed__c = deserializeResults.order_faxed;
                assessmentTCC.Ostomy__c = deserializeResults.ostomy;
                assessmentTCC.Patient_Address__c = deserializeResults.patient_address;
                assessmentTCC.Patient_Alternate_Phone__c = deserializeResults.patient_alternate_phone;
                assessmentTCC.Patient_Citizenship__c = deserializeResults.patient_citizenship;
                assessmentTCC.Patient_City__c = deserializeResults.patient_city;
                assessmentTCC.Patient_Contact_First_Name__c = deserializeResults.patient_contact_first_name;
                assessmentTCC.Patient_Contact_Last_Name__c = deserializeResults.patient_contact_last_name;          
                assessmentTCC.Patient_Contact_Middle_Name_Initial__c = deserializeResults.patient_contact_middle_name_initial;
                assessmentTCC.Patient_Contact_Name_Suffix__c = deserializeResults.patient_contact_name_suffix;
                assessmentTCC.Patient_Contact_Phone__c = deserializeResults.patient_contact_phone;
                assessmentTCC.Patient_Date_Of_Birth__c = deserializeResults.patient_date_of_birth;
                assessmentTCC.Patient_Email_Address__c = convertEmailToNullIfInvalid(deserializeResults.patient_email_address);
                assessmentTCC.Patient_Ethnicity__c = deserializeResults.patient_ethnicity;
                assessmentTCC.Patient_First_Name__c = deserializeResults.patient_first_name;
                assessmentTCC.Patient_Gender__c = deserializeResults.patient_gender;
                assessmentTCC.Patient_Language__c = deserializeResults.patient_language;
                assessmentTCC.Patient_Last_Name__c = deserializeResults.patient_last_name;
                assessmentTCC.Patient_Middle_Name_Initial__c = deserializeResults.patient_middle_name_initial;
                assessmentTCC.Patient_Name_Suffix__c = deserializeResults.patient_name_suffix;
                assessmentTCC.Patient_Postal_Code__c = deserializeResults.patient_postal_code;
                assessmentTCC.Patient_Primary_Phone__c = deserializeResults.patient_primary_phone;
                assessmentTCC.Patient_Social_Security_Number__c = deserializeResults.patient_social_security_number;
                assessmentTCC.Patient_State__c = deserializeResults.patient_state;
                assessmentTCC.PLOF_ADL__c = deserializeResults.plof_adl;
                assessmentTCC.PLOF_Ambulation__c = deserializeResults.plof_ambulation;
                assessmentTCC.PLOF_Bed_Mobility__c = deserializeResults.plof_bed_mobility;
                assessmentTCC.PLOF_Transfers__c = deserializeResults.plof_transfers;
                if (deserializeResults.primary_care_physician != null && deserializeResults.primary_care_physician.size() > 0) {
                    for (primary_care_physician_group_item physician: deserializeResults.primary_care_physician) {
                        assessmentTCC.Primary_Care_Physician__c = physician.primary_care_physician_name;
                        if (physician.primary_care_physician_sfid != null) {
                            if (physician.primary_care_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                assessmentTCC.Primary_Care_Physician_As_Contact__c = physician.primary_care_physician_sfid;
                            } else if (physician.primary_care_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                assessmentTCC.Primary_Care_Physician_As_Lead__c = physician.primary_care_physician_sfid; 
                            }
                        }
                    }   
                }
                assessmentTCC.Primary_Care_Physician_Phone__c = deserializeResults.primary_care_physician_phone;
                assessmentTCC.Primary_Insurance_Id__c = deserializeResults.primary_insurance_id;
                assessmentTCC.Primary_Insurance_Name__c = deserializeResults.primary_insurance_name;
                assessmentTCC.Primary_Payer_Source__c = deserializeResults.primary_payer_source;
                assessmentTCC.Prior_Living_Arrangements__c = deserializeResults.prior_living_arrangements;
                assessmentTCC.Psych_Diagnosis__c = deserializeResults.psych_diagnosis;
                assessmentTCC.Psych_Diagnosis_Details__c = deserializeResults.psych_diagnosis_details;
                assessmentTCC.Qualifying_Hospital_Stay__c = deserializeResults.qualifying_hospital_stay;
                assessmentTCC.Qualifying_Hospital_Stay_From_Date__c = deserializeResults.qualifying_hospital_stay_from_date;
                assessmentTCC.Qualifying_Hospital_Stay_To_Date__c = deserializeResults.qualifying_hospital_stay_to_date;
                assessmentTCC.Reason_Area_Concern__c = deserializeResults.reason_area_concern;
                assessmentTCC.Reason_For_Admission_At_Kindred_Facility__c = deserializeResults.reason_for_admission_at_kindred_facility;
                assessmentTCC.Reason_For_Reassessment__c = deserializeResults.reason_for_reassessment;
                assessmentTCC.Referral_Address__c = deserializeResults.referral_address;
                assessmentTCC.Referral_City__c = deserializeResults.referral_city;
                assessmentTCC.Referral_Contact_Alternate_Phone__c = deserializeResults.referral_contact_alternate_phone;
                assessmentTCC.Referral_Date__c = deserializeResults.referral_date;
                if (deserializeResults.referring_location != null && deserializeResults.referring_location.size() > 0) {
                    for (referring_location_group_item location: deserializeResults.referring_location) {
                        assessmentTCC.Referring_Location__c = location.referring_location_name;
                        if (location.referring_location_sfid != null) {
                            if (location.referring_location_sfid.getSObjectType() == Account.sObjectType &&
                            [select Id from Account where Id = :location.referring_location_sfid].size() > 0) {
                                assessmentTCC.Referring_Location_Account__c = location.referring_location_sfid;
                            }               
                        }
                    }
                }
                assessmentTCC.Referral_Postal_Code__c = deserializeResults.referral_postal_code;
                assessmentTCC.Referral_Source_Type__c = deserializeResults.referral_source_type;
                assessmentTCC.Referral_State__c = deserializeResults.referral_state;
                if (deserializeResults.referring_contact != null && deserializeResults.referring_contact.size() > 0) {
                    for (referring_contact_group_item refcontact: deserializeResults.referring_contact) {
                        assessmentTCC.Referring_Contact__c = refcontact.referring_contact_name;
                        if (refcontact.referring_contact_sfid != null) {
                            if (refcontact.referring_contact_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :refcontact.referring_contact_sfid].size() > 0) {
                                assessmentTCC.Referring_Contact_As_Contact__c = refcontact.referring_contact_sfid;
                            } else if ([select Id from Lead where Id = :refcontact.referring_contact_sfid].size() > 0){
                                assessmentTCC.Referring_Contact_As_Lead__c = refcontact.referring_contact_sfid; 
                            }   
                        }
                    }
                }
                if (deserializeResults.referring_physician != null && deserializeResults.referring_physician.size() > 0) {
                    for (referring_physician_group_item refphysician: deserializeResults.referring_physician) {
                        assessmentTCC.Referring_Physician__c = refphysician.referring_physician_name;
                        if (refphysician.referring_physician_sfid != null) {
                            if (refphysician.referring_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :refphysician.referring_physician_sfid].size() > 0) {
                                assessmentTCC.Referring_Physician_As_Contact__c = refphysician.referring_physician_sfid;
                            } else if (refphysician.referring_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :refphysician.referring_physician_sfid].size() > 0) {
                                assessmentTCC.Referring_Physician_As_Lead__c = refphysician.referring_physician_sfid; 
                            }
                        }
                    }
                }
                if (deserializeResults.refer_to != null && deserializeResults.refer_to.size() > 0) {
                    for (refer_to_tcc_group_item refer_to: deserializeResults.refer_to){
                        assessmentTCC.Refer_To__c = refer_to.refer_to_name;
                        if (refer_to.refer_to_sfid != null) {
                            if (refer_to.refer_to_sfid.getSObjectType() == Account.sObjectType &&
                            [select Id from Account where Id = :refer_to.refer_to_sfid].size() > 0) {
                                assessmentTCC.Refer_To_Account__c = refer_to.refer_to_sfid;
                            }   
                        }
                    }
                }
                assessmentTCC.Restraints__c = deserializeResults.restraints;
                assessmentTCC.Restraints_Type__c = deserializeResults.restraints_type;
                assessmentTCC.Secondary_Insurance_Id__c = deserializeResults.secondary_insurance_id;
                assessmentTCC.Secondary_Insurance_Name__c = deserializeResults.secondary_insurance_name;
                assessmentTCC.Secondary_Payer_Source__c = deserializeResults.secondary_payer_source;
                assessmentTCC.Skilled_Needs__c = deserializeResults.skilled_needs;
                assessmentTCC.Smoker__c = deserializeResults.smoker;
                assessmentTCC.Social_History__c = deserializeResults.social_history;
                assessmentTCC.Special_Diet__c = deserializeResults.special_diet;
                assessmentTCC.Special_Equipment__c = deserializeResults.special_equipment;
                assessmentTCC.TPN__c = deserializeResults.tpn;
                assessmentTCC.Trach__c = deserializeResults.trach;
                assessmentTCC.Trach_Last_Changed_Date__c = deserializeResults.trach_last_changed_date;
                assessmentTCC.Trach_Size__c = deserializeResults.trach_size;
                assessmentTCC.Trach_Type__c = deserializeResults.trach_type;
                assessmentTCC.Vent__c = deserializeResults.vent;
                assessmentTCC.Vent_Chronic__c = deserializeResults.vent_chronic;
                assessmentTCC.Vent_Date_Initiated__c = deserializeResults.vent_date_initiated;
                assessmentTCC.Vent_FIO2__c = deserializeResults.vent_fio2;          
                assessmentTCC.Vent_Mode__c = deserializeResults.vent_mode;
                assessmentTCC.Vent_PEEP__c = deserializeResults.vent_peep;
                assessmentTCC.Vent_PS__c = deserializeResults.vent_ps;
                assessmentTCC.Vent_Rate__c = deserializeResults.vent_rate;
                assessmentTCC.Vent_TV__c = deserializeResults.vent_tv;
                assessmentTCC.Vent_Weaning__c = deserializeResults.vent_weaning;
                assessmentTCC.Virtual_Tour_Given__c = deserializeResults.virtual_tour_given;
                assessmentTCC.Weight__c = deserializeResults.weight;
                assessmentTCC.Wounds__c = deserializeResults.wounds;
                assessmentTCC.Wound_Type__c = deserializeResults.wound_type;
                insert assessmentTCC;
                
                //Insert Medication Lines
                if (deserializeResults.multiple_line_group != null && deserializeResults.multiple_line_group.size() > 0) {
                    for (multiple_line_group_item line: deserializeResults.multiple_line_group) {
                        Medication_Line_TCC__c tccMedicationLine = new Medication_Line_TCC__c();
                        tccMedicationLine.Assessment_TCC__c = assessmentTCC.id;
                        tccMedicationLine.App_Timestamp__c = line.app_timestamp;
                        tccMedicationLine.Line_CL_Type__c = line.line_cl_type;
                        tccMedicationLine.Line_Insertion_Date__c = line.line_insertion_date;
                        tccMedicationLine.Line_Location__c = line.line_location;
                        insert tccMedicationLine;
                    }   
                }
                
                //Insert Medications
                if (deserializeResults.multiple_medications_group != null && deserializeResults.multiple_medications_group.size() > 0) {
                    for (multiple_medications_group_item medication: deserializeResults.multiple_medications_group) {
                        Medication_TCC__c tccMedication = new Medication_TCC__c();
                        tccMedication.Assessment_TCC__c = assessmentTCC.id;
                        tccMedication.App_Timestamp__c = medication.app_timestamp;
                        tccMedication.Medication_Dosage__c = medication.medication_dosage;
                        tccMedication.Medication_Frequency__c = medication.medication_frequency;                
                        tccMedication.Medication_Name__c = medication.medication_name;
                        tccMedication.Medication_Route__c = medication.medication_route;
                        insert tccMedication;
                    }
                }

                //Insert Wounds
                if (deserializeResults.itegumentary_mutable_group != null && deserializeResults.itegumentary_mutable_group.size() > 0) {
                    for (integumentary_mutable_tcc_group_item integumentary: deserializeResults.itegumentary_mutable_group) {
                        Integumentary_TCC__c tccIntegumentaryItem = new Integumentary_TCC__c();
                        tccIntegumentaryItem.Assessment_TCC__c = assessmentTCC.id;
                        tccIntegumentaryItem.App_Timestamp__c = integumentary.app_timestamp;
                        tccIntegumentaryItem.Skin_Item_Treatment__c = integumentary.skin_item_treatment;
                        tccIntegumentaryItem.Skin_Item_Site__c = integumentary.skin_item_site; 
                        tccIntegumentaryItem.Skin_Item_Stage__c = integumentary.skin_item_stage;
                        tccIntegumentaryItem.Skin_Item_Stage_Size__c = integumentary.skin_item_stage_size;
                        insert tccIntegumentaryItem;
                    }
                }

                //Insert Cultures
                if (deserializeResults.culture_history_mutable_group != null && deserializeResults.culture_history_mutable_group.size() > 0) {
                    for (culture_history_mutable_group_item culture: deserializeResults.culture_history_mutable_group) {
                        Culture_TCC__c tccCulture = new Culture_TCC__c();
                        tccCulture.Assessment_TCC__c = assessmentTCC.id;
                        tccCulture.App_Timestamp__c = culture.app_timestamp;
                        tccCulture.Culture_Date__c = culture.culture_date;
                        tccCulture.Culture_IV_Antibiotic__c = culture.culture_iv_antibiotic;
                        tccCulture.Culture_Organism__c = culture.culture_organism;
                        tccCulture.Culture_Site__c = culture.culture_site;
                        tccCulture.Culture_Start_Date__c = culture.culture_start_date;
                        tccCulture.Culture_Stop_Date__c = culture.culture_stop_date;
                        insert tccCulture;
                    }   
                }
                
                //Success!
                return new Map<String,String> {'Result' => 'Success', 'Filename' => metadata.meta_filename, 'ObjectID' => assessmentTCC.id};
            } else if (metadata.meta_form_type == 65 || metadata.meta_form_type == 66 || metadata.meta_form_type == 69 || metadata.meta_form_type == 70 || metadata.meta_form_type == 77 || metadata.meta_form_type == 78) {
        
                if(metadata.meta_document_status != '1' && metadata.meta_document_status != '2') {
                    return new Map<String,String> {'Result' => 'Invalid Status', 'Filename' => metadata.meta_filename};
                }
                        
                //If somehow we're trying to re-save an already saved submitted document, then feign "Success" so the client can delete the doc from its upload queue
                if(metadata.meta_document_status == '2') {
                    List<Assessment_TCH__c> submitted = [SELECT Id, Meta_Owner__c FROM Assessment_TCH__c WHERE Meta_Filename__c = :metadata.meta_filename AND Meta_Document_Status__c = '2' FOR UPDATE];
                    
                    if(!submitted.isEmpty()) {
                         if (submitted[0].Meta_Owner__c == null) {
                              submitted[0].Meta_Owner__c = UserInfo.getUserId();
                              update submitted[0];
                         }
                         return new Map<String,String> {'Result' => 'SuccessOnPreviousCall', 'Filename' => metadata.meta_filename, 'ObjectID' => submitted[0].Id};
                    }
                }
        
                //Deserialize Appropriately
                TCH deserializeResults = (TCH)System.JSON.deserialize(req.requestBody.toString(), TCH.class);

                //Delete older unsubmitted versions
                if (metadata.meta_chainuuid != null) {
                    List<Assessment_TCH__c> oldAssessments = [SELECT Id FROM Assessment_TCH__c WHERE Meta_ChainUUID__c = :metadata.meta_chainuuid AND Meta_Document_Status__c != '2' FOR UPDATE];
                    delete oldAssessments;
                }

                //Version Hardening
                if (metadata.meta_chainuuid != null) {
                     List<Assessment_TCH__c> oldAssessments = [SELECT Id, Meta_Document_Version__c, Meta_ChainUUID__c FROM Assessment_TCH__c WHERE Meta_ChainUUID__c = :metadata.meta_chainuuid ORDER BY CreatedDate ASC];
                     if (!oldAssessments.isEmpty()) {
                          if (oldAssessments.size() > 1) {
                               for (Integer i = 0; i < oldAssessments.size() - 1; i++) {
                                  Assessment_TCH__c firstAssessment = oldAssessments[i];
                                  Assessment_TCH__c secondAssessment = oldAssessments[i+1];
                                  if (Decimal.ValueOf(firstAssessment.Meta_Document_Version__c) + 1 != Decimal.ValueOf(secondAssessment.Meta_Document_Version__c)) {
                                       throw new AssessmentException('Chain is out of sequence (first=' + firstAssessment.Meta_Document_Version__c + ', second=' + secondAssessment.Meta_Document_Version__c + '); ');
                                  }
                              } 
                          }
                          
                          Assessment_TCH__c mostRecentServerSideAssessment = oldAssessments[oldAssessments.size()-1];
                          if (Decimal.ValueOf(mostRecentServerSideAssessment.Meta_Document_Version__c) + 1 != Decimal.ValueOf(metadata.meta_document_version)) {
                               throw new AssessmentException('Uploaded document is out of sequence (mostRecent=' + mostRecentServerSideAssessment.Meta_Document_Version__c + ', uploaded=' + metadata.meta_document_version + '); ');
                          }
                     } else {
                          if (metadata.meta_document_version != '0') {
                               throw new AssessmentException('First document in chain should have version 0 (uploaded=' + metadata.meta_document_version + '); ');
                          }
                     }
                }
                
                //Insert Patient
                Assessment_Patient__c patient = new Assessment_Patient__c();
                patient.Address__c = deserializeResults.patient_address;
                patient.City__c = deserializeResults.patient_city;
                patient.Date_Of_Birth__c = deserializeResults.patient_date_of_birth;
                patient.Email__c = convertEmailToNullIfInvalid(deserializeResults.patient_email_address);
                patient.Employer_Group__c = deserializeResults.employer_group_name;
                patient.Employer_Name__c = deserializeResults.employer_name;
                patient.Employer_Phone__c = deserializeResults.employer_phone_number;
                patient.Employment_Status__c = deserializeResults.employment_status;
                patient.Ethnicity__c = deserializeResults.patient_ethnicity;
                patient.First_Name__c = deserializeResults.patient_first_name;
                patient.Gender__c = deserializeResults.patient_gender;
                patient.Languages__c = deserializeResults.patient_language;
                patient.Last_Name__c = deserializeResults.patient_last_name;
                patient.Marital_Status__c = deserializeResults.patient_marital_status;
                patient.Middle_Initial__c = deserializeResults.patient_middle_name_initial;
                patient.Phone__c = deserializeResults.patient_primary_phone;
                patient.Phone_1__c = deserializeResults.patient_cell_phone;
                patient.Phone_2__c = deserializeResults.patient_alternate_phone;
                patient.Postal_Code__c = deserializeResults.patient_postal_code;
                patient.Primary_HIC__c = deserializeResults.primary_hic;
                patient.Primary_Insurance_ID__c = deserializeResults.primary_insurance_id;
                patient.Primary_Insurance_Name__c = deserializeResults.primary_insurance_name;
                patient.Primary_Payer_Source__c = deserializeResults.primary_payer_source;
                if (deserializeResults.primary_care_physician != null && deserializeResults.primary_care_physician.size() > 0) {
                    for (primary_care_physician_group_item physician: deserializeResults.primary_care_physician) {
                        if (physician.primary_care_physician_sfid != null) {
                            if (physician.primary_care_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                patient.Primary_Physician_As_Contact__c = physician.primary_care_physician_sfid;
                            } else if(physician.primary_care_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                patient.Primary_Physician_As_Lead__c = physician.primary_care_physician_sfid; 
                            }
                        }
                    }
                }
                if (deserializeResults.primary_physician != null && deserializeResults.primary_physician.size() > 0) {
                    for (primary_physician_group_item physician: deserializeResults.primary_physician) {
                        if (physician.primary_physician_sfid != null) {
                            if (physician.primary_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.primary_physician_sfid].size() > 0) {
                                patient.Primary_Physician_As_Contact__c = physician.primary_physician_sfid;
                            } else if(physician.primary_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.primary_physician_sfid].size() > 0) {
                                patient.Primary_Physician_As_Lead__c = physician.primary_physician_sfid; 
                            }
                        }
                    }
                }
                patient.Religion__c = deserializeResults.patient_religion;
                patient.Secondary_HIC__c = deserializeResults.secondary_hic;
                patient.Secondary_Insurance_ID__c = deserializeResults.secondary_insurance_id;
                patient.Secondary_Insurance_Name__c = deserializeResults.secondary_insurance_name;
                patient.Secondary_Payer_Source__c = deserializeResults.secondary_payer_source;
                patient.Social_Security_Number__c = deserializeResults.patient_social_security_number;
                patient.State__c = deserializeResults.patient_state;
                patient.Suffix__c = deserializeResults.patient_name_suffix;
                insert patient;
                
                //Insert Assessment
                Assessment_TCH__c assessmentTCH = new Assessment_TCH__c();

                assessmentTCH.Meta_ChainUUID__c = metadata.meta_chainuuid;
                assessmentTCH.Meta_Document_Version__c = metadata.meta_document_version;
                assessmentTCH.Meta_Bookmark__c = metadata.meta_bookmark;
                assessmentTCH.Meta_Creation_Date__c = metadata.meta_creation_date;
                assessmentTCH.Meta_Document_Status__c = metadata.meta_document_status;
                assessmentTCH.Meta_Filename__c = metadata.meta_filename;
                assessmentTCH.Meta_Form_Type__c = metadata.meta_form_type;
                assessmentTCH.Meta_Manual_Bookmark__c = metadata.meta_manual_bookmark;
                assessmentTCH.Meta_Reassessment_Date__c = metadata.meta_reassessment_date;
                assessmentTCH.Meta_Submitted_Date__c = metadata.meta_submitted_date;
                
                assessmentTCH.Meta_Owner__c = UserInfo.getUserId();

                assessmentTCH.BG__c = deserializeResults.abg_not_applicable;
                assessmentTCH.BG_Type__c = deserializeResults.bg_type;
                assessmentTCH.BG_BE__c = deserializeResults.abg_be;
                assessmentTCH.BG_Bicarb__c = deserializeResults.abg_bicarb;
                assessmentTCH.BG_Date__c = deserializeResults.abg_date;
                if (deserializeResults.abg_fi02 != null) assessmentTCH.BG_FIO2__c = deserializeResults.abg_fi02;
                if (deserializeResults.abg_fio2 != null) assessmentTCH.BG_FIO2__c = deserializeResults.abg_fio2;                
                assessmentTCH.BG_PaCO2__c = deserializeResults.abg_paco2;
                assessmentTCH.BG_PaO2__c = deserializeResults.abg_pao2;
                assessmentTCH.BG_pH__c = deserializeResults.abg_ph;
                assessmentTCH.Actively_Managed_Comorbidities__c = deserializeResults.actively_managed_comorbidities;
                assessmentTCH.Activities_Of_Daily_Living__c = deserializeResults.activities_of_daily_living;
                assessmentTCH.Additional_Integumentary_Details__c = deserializeResults.skin_item_comments;
                assessmentTCH.Additional_Neurological_Details__c = deserializeResults.additional_neurological_details;
                assessmentTCH.Additional_Notes_Overall__c = deserializeResults.additional_notes_overall;
                assessmentTCH.Additional_Psych_Social_Details__c = deserializeResults.additional_psych_social_details;
                assessmentTCH.Additional_Respiratory_Details__c = deserializeResults.additional_respiratory_details;
                assessmentTCH.Addl_Referring_Facility_Course_Summary__c = deserializeResults.additional_referring_facility_course_summary;
                assessmentTCH.Admission_Type__c = deserializeResults.admission_type;
                assessmentTCH.Advance_Directives__c = deserializeResults.advance_directives;
                assessmentTCH.Air_Embolism__c = deserializeResults.air_embolism;
                assessmentTCH.Albumin_Date__c = deserializeResults.albumin_date;
                assessmentTCH.Albumin_Value__c = deserializeResults.albumin_value;
                assessmentTCH.Patient_Demographics_Admit_Date__c = deserializeResults.patient_demographics_admit_date;
                assessmentTCH.Assessment_Patient__c = patient.id;
                assessmentTCH.Assistive_Devices__c = deserializeResults.mus_assistive_devices;
                assessmentTCH.Bed_Needs__c = deserializeResults.bed_needs;
                assessmentTCH.Bed_Needs_Specify__c = deserializeResults.specify_bed_needs;
                assessmentTCH.Bilirubin_Date__c = deserializeResults.bilrubin_date;
                assessmentTCH.Bilirubin_Value__c = deserializeResults.bilrubin_value;
                assessmentTCH.Blood_Product_Given__c = deserializeResults.blood_product_given;
                assessmentTCH.Blood_Product_Last_Date__c = deserializeResults.blood_product_last_date;
                assessmentTCH.Blood_Product_Type__c = deserializeResults.blood_product_type;
                assessmentTCH.BUN_Date__c = deserializeResults.bun_date;
                assessmentTCH.BUN_Value__c = deserializeResults.bun_value;
                assessmentTCH.Cardiovascular_Date__c = deserializeResults.cardiovascular_date;
                assessmentTCH.Cardiovascular_Rhythm__c = deserializeResults.cardiovascular_rhythm;
                assessmentTCH.Cardiovascular_Rhythm_Location__c = deserializeResults.cardiovascular_rhythm_location;
                assessmentTCH.Cardiovascular_Rhythm_Type__c = deserializeResults.cardiovascular_rhythm_type;
                assessmentTCH.Extraordinary_Needs_Info_About_Patient__c = deserializeResults.extraordinary_needs_info_about_patient;
                assessmentTCH.Catheter_Associated_UTI__c = deserializeResults.catheter_associated_urinary_tract_infection;
                assessmentTCH.CCU_Date1__c = deserializeResults.ccu_date1;
                assessmentTCH.CCU_Date2__c = deserializeResults.ccu_date2;
                assessmentTCH.CCU_Date3__c = deserializeResults.ccu_date3;
                assessmentTCH.CCU_Date4__c = deserializeResults.ccu_date4;
                assessmentTCH.CCU_Dates_Required__c = deserializeResults.ccu_dates_required;
                assessmentTCH.Chloride_Date__c = deserializeResults.chloride_date;
                assessmentTCH.Chloride_Value__c = deserializeResults.chloride_value;
                assessmentTCH.Clinical_Appropriateness__c = deserializeResults.historical_info_narrative;
                assessmentTCH.CO2_Date__c = deserializeResults.co2_date;
                assessmentTCH.CO2_Value__c = deserializeResults.co2_value;
                assessmentTCH.Colostomy__c = deserializeResults.colostomy;
                assessmentTCH.Colostomy_Date__c = deserializeResults.colostomy_date;
                assessmentTCH.Consent_Signed_By__c = deserializeResults.consent_signed_by;
                assessmentTCH.Continued_Stay_Criteria__c = deserializeResults.continued_stay_criteria;
                assessmentTCH.Contractures_Reason__c = deserializeResults.contractures_reason;
                assessmentTCH.Contractures_Weight_Bearing__c = deserializeResults.contractures_weight_bearing;
                assessmentTCH.Creatinine_Date__c = deserializeResults.creatinine_date;
                assessmentTCH.Creatinine_Value__c = deserializeResults.creatinine_value;
                if (deserializeResults.current_admission_date != null) assessmentTCH.Current_Admission_Date__c = deserializeResults.current_admission_date;
                if (deserializeResults.current_admit_date != null) assessmentTCH.Current_Admission_Date__c = deserializeResults.current_admit_date;
                assessmentTCH.Code_Status__c = deserializeResults.code_status;
                assessmentTCH.Current_Or_New_Problems__c = deserializeResults.information_current_new_problems;
                assessmentTCH.Current_Precautions__c = deserializeResults.current_precautions;
                assessmentTCH.Current_Restraints__c = deserializeResults.current_restraints;
                if (deserializeResults.cxr_not_applicable != null) assessmentTCH.CXR__c = deserializeResults.cxr_not_applicable;
                if (deserializeResults.cxr != null) assessmentTCH.CXR__c = deserializeResults.cxr;
                assessmentTCH.CXR_Date__c = deserializeResults.cxr_date;
                assessmentTCH.CXR_Results__c = deserializeResults.results_selection;
                if (deserializeResults.cxr_results_specify != null) assessmentTCH.CXR_Results_Specify__c = deserializeResults.cxr_results_specify;
                if (deserializeResults.cxr_results != null) assessmentTCH.CXR_Results_Specify__c = deserializeResults.cxr_results;
                if (deserializeResults.dialysis_not_applicable != null) assessmentTCH.Dialysis__c = deserializeResults.dialysis_not_applicable;
                if (deserializeResults.dialysis != null) assessmentTCH.Dialysis__c = deserializeResults.dialysis;
                assessmentTCH.Dialysis_Comment__c = deserializeResults.fistula_comment;
                assessmentTCH.Dialysis_Date_Of_Initial__c = deserializeResults.dialysis_date_of_initial;
                assessmentTCH.Dialysis_Hep_B_Core_Antibody__c = deserializeResults.dialysis_hepb_core_antibody;
                assessmentTCH.Dialysis_Hep_B_Panel_Date__c = deserializeResults.dialysis_hepb_panel_date;
                assessmentTCH.Dialysis_Hep_B_Surface_Antibody__c = deserializeResults.dialysis_hepb_surface_antibody;
                assessmentTCH.Dialysis_Hep_B_Surface_Antigen__c = deserializeResults.dialysis_hepb_surface_antigen;
                if (deserializeResults.dialysis_information_access != null) assessmentTCH.Dialysis_Information_Access__c = deserializeResults.dialysis_information_access;
                if (deserializeResults.dialysis_access != null) assessmentTCH.Dialysis_Information_Access__c = deserializeResults.dialysis_access;
                if (deserializeResults.dialysis_information_schedule != null) assessmentTCH.Dialysis_Information_Schedule__c = deserializeResults.dialysis_information_schedule;
                if (deserializeResults.dialysis_schedule != null) assessmentTCH.Dialysis_Information_Schedule__c = deserializeResults.dialysis_schedule;
                assessmentTCH.Dialysis_Information_Schedule_Specify__c = deserializeResults.dialysis_information_schedule_specify;
                assessmentTCH.Dialysis_Information_Type__c = deserializeResults.dialysis_information_type;
                assessmentTCH.Dialysis_Location_Of_Initial__c = deserializeResults.dialysis_location_of_initial;
                assessmentTCH.Dialysis_Modality__c = deserializeResults.dialysis_modality;
                assessmentTCH.Dialysis_Started_At_STAC__c = deserializeResults.dialysis_started_at_STAC;
                assessmentTCH.DVT_Post_Knee__c = deserializeResults.dvt_post_knee;
                assessmentTCH.Echocardiogram__c = deserializeResults.echocardiogram;
                assessmentTCH.Ejection_Fraction__c = deserializeResults.ejection_fraction;
                assessmentTCH.Employer_Group__c = deserializeResults.employer_group_name;
                assessmentTCH.Employer_Name__c = deserializeResults.employer_name;
                assessmentTCH.Employer_Phone__c = deserializeResults.employer_phone_number;
                assessmentTCH.Employment_Status__c = deserializeResults.employment_status;
                assessmentTCH.Falls_Or_Trauma_With_Injuries__c = deserializeResults.falls_or_trauma_with_injuries;
                assessmentTCH.Family_Contacted__c = deserializeResults.family_contacted;
                assessmentTCH.Family_Dynamics_Coping__c = deserializeResults.family_dynamics_coping;
                assessmentTCH.Financial_Approval_Per_CFO_Designee__c = deserializeResults.financial_approval_per_cfo_designee;
                assessmentTCH.Flu_Vaccination__c = deserializeResults.flu_vacc_not_applicable;
                assessmentTCH.Flu_Vaccination_Date__c = deserializeResults.influenza_vaccination_date;
                assessmentTCH.Flu_Vaccination_Reason__c = deserializeResults.influenza_reason;
                assessmentTCH.Foley__c = deserializeResults.foley;
                assessmentTCH.Foley_Date__c = deserializeResults.foley_date;
                assessmentTCH.GC_Meds__c = deserializeResults.gc_meds;
                assessmentTCH.GCS_Eyes_Open__c = deserializeResults.gcs_eyes_open;
                assessmentTCH.GCS_Motor_Response__c = deserializeResults.motor_response;
                assessmentTCH.GCS_Verbal_Response__c = deserializeResults.verbal_response;
                assessmentTCH.GI_GU_Date_Taken__c = deserializeResults.gi_gu_date_taken;
                if (deserializeResults.gi_gu_diet_order != null) assessmentTCH.GI_GU_Diet_Order__c = deserializeResults.gi_gu_diet_order;
                if (deserializeResults.diet_type != null) assessmentTCH.GI_GU_Diet_Order__c = deserializeResults.diet_type;
                assessmentTCH.GI_GU_Formula_Name__c = deserializeResults.gi_gu_formula_name;
                if (deserializeResults.gi_gu_height != null) assessmentTCH.GI_GU_Height__c = deserializeResults.gi_gu_height;
                if (deserializeResults.height != null) assessmentTCH.GI_GU_Height__c = deserializeResults.height;
                if (deserializeResults.gi_bleeds != null) assessmentTCH.GI_Bleeds__c = deserializeResults.gi_bleeds;
                assessmentTCH.GI_GU_Height_Units__c = deserializeResults.gi_gu_height_units;
                assessmentTCH.GI_GU_Initiation_Date__c = deserializeResults.gi_gu_initiation_date;
                if (deserializeResults.gi_gu_date_initation_rate != null) assessmentTCH.GI_GU_Initiation_Rate__c = deserializeResults.gi_gu_date_initation_rate;
                if (deserializeResults.feeding_tube_rate != null) assessmentTCH.GI_GU_Initiation_Rate__c = deserializeResults.feeding_tube_rate;
                assessmentTCH.GI_GU_Liquid_Consistency__c = deserializeResults.gi_gu_liquid_consistency;
                assessmentTCH.GI_GU_Parenteral_Nutrition__c = deserializeResults.gi_gu_parenteral_nutrition;
                assessmentTCH.GI_GU_Recent_Aspiration__c = deserializeResults.gi_gu_recent_aspiration;
                assessmentTCH.GI_GU_Recent_Aspiration_Rate__c = deserializeResults.gi_gu_recent_asperation_rate;
                assessmentTCH.GI_GU_Supplement_Schedule__c = deserializeResults.gi_gu_supplement_schedule;
                assessmentTCH.GI_GU_Texture__c = deserializeResults.gi_gu_texture;
                if (deserializeResults.gi_gu_tube_type != null) assessmentTCH.GI_GU_Tube_Type__c = deserializeResults.gi_gu_tube_type;
                if (deserializeResults.feeding_tube_type != null) assessmentTCH.GI_GU_Tube_Type__c = deserializeResults.feeding_tube_type;
                if (deserializeResults.gi_gu_weight != null) assessmentTCH.GI_GU_Weight__c = deserializeResults.gi_gu_weight;
                if (deserializeResults.weight != null) assessmentTCH.GI_GU_Weight__c = deserializeResults.weight;
                assessmentTCH.GI_GU_Weight_Units__c = deserializeResults.gi_gu_weight_units;
                assessmentTCH.Glucose_Date__c = deserializeResults.glucose_date;
                assessmentTCH.Glucose_Value_High__c = deserializeResults.glucose_value_high;
                assessmentTCH.Glucose_Value_Low__c = deserializeResults.glucose_value_low;
                assessmentTCH.Hematocrit_Date__c = deserializeResults.hematocrit_date;
                assessmentTCH.Hematocrit_Value__c = deserializeResults.hematocrit_value;
                assessmentTCH.Hemoglobin_Date__c = deserializeResults.hemoglobin_date;
                assessmentTCH.Hemoglobin_Value__c = deserializeResults.hemoglobin_value;
                assessmentTCH.History_Of_Incarceration__c = deserializeResults.history_of_incarceration;
                assessmentTCH.History_Of_Incarceration_Details__c = deserializeResults.history_of_incarceration_additional_details;
                if (deserializeResults.history_of_restraints != null) assessmentTCH.History_Of_Restraints__c = deserializeResults.history_of_restraints;
                if (deserializeResults.restraints != null) assessmentTCH.History_Of_Restraints__c = deserializeResults.restraints;
                assessmentTCH.Hospital_Course_Summary__c = deserializeResults.hospital_referring_facility_course_summary;
                assessmentTCH.ICD__c = deserializeResults.icd9;
                assessmentTCH.ICU_Date1__c = deserializeResults.icu_date1;
                assessmentTCH.ICU_Date2__c = deserializeResults.icu_date2;
                assessmentTCH.ICU_Date3__c = deserializeResults.icu_date3;
                assessmentTCH.ICU_Date4__c = deserializeResults.icu_date4;
                assessmentTCH.ICU_Dates_Required__c = deserializeResults.icu_dates_required;
                assessmentTCH.Ileostomy__c = deserializeResults.ileostomy;
                assessmentTCH.Ileostomy_Date__c = deserializeResults.ileostomy_date;
                assessmentTCH.Infectious_Disease_History__c = deserializeResults.infectious_disease_history;
                assessmentTCH.INR_Date__c = deserializeResults.inr_date;
                assessmentTCH.INR_Value__c = deserializeResults.inr_value;
                assessmentTCH.Integumentary_Bed_Type__c = deserializeResults.integumentary_bed_type;
                assessmentTCH.Integumentary_Summary__c = deserializeResults.integumentary_summary;
                assessmentTCH.IO_In__c = deserializeResults.io_in;
                assessmentTCH.IO_Out__c = deserializeResults.io_out;
                assessmentTCH.IP_Days_Remaining__c = deserializeResults.ip_days_remaining;
                if (deserializeResults.kindred_attending_md != null && deserializeResults.kindred_attending_md.size() > 0) {
                    for (kindred_attending_physician_group_item physician: deserializeResults.kindred_attending_md) {
                        assessmentTCH.Kindred_Attending_Physician__c = physician.kindred_attending_md_name;
                        if (physician.kindred_attending_md_sfid != null) {
                            if (physician.kindred_attending_md_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.kindred_attending_md_sfid].size() > 0) {
                                assessmentTCH.Kindred_Attending_Physician_As_Contact__c = physician.kindred_attending_md_sfid;
                            } else if (physician.kindred_attending_md_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.kindred_attending_md_sfid].size() > 0) {
                                assessmentTCH.Kindred_Attending_Physician_As_Lead__c = physician.kindred_attending_md_sfid; 
                            }
                        }           
                    }
                }
                assessmentTCH.Kindred_Initial_Diagnosis__c = deserializeResults.information_kindred_diagnostics;
                assessmentTCH.Kindred_Plan_Of_Discharge_Discussed__c = deserializeResults.kindred_plan_of_discharge_discussed;
                assessmentTCH.Last_BM__c = deserializeResults.last_bm;
                assessmentTCH.Lives_With__c = deserializeResults.lives_with;
                assessmentTCH.Lives_With_Additional_Details__c = deserializeResults.lives_with_additional_details;
                assessmentTCH.Lower_Level_Care_Failure__c = deserializeResults.lower_level_care_failure;
                assessmentTCH.Lower_Level_Care_Failure_Reasons__c = deserializeResults.failure_reasons;
                assessmentTCH.Magnesium_Date__c = deserializeResults.magnesium_date;
                assessmentTCH.Magnesium_Value__c = deserializeResults.magnesium_value;
                assessmentTCH.Manifestations_Of_Poor_Glycemic_Control__c = deserializeResults.manifestations_of_poor_glycemic_control;
                assessmentTCH.MC_Active_Comorbid_Conditions__c = deserializeResults.mc_active_comorbid_conditions;
                assessmentTCH.MC_Bone_Marrow__c = deserializeResults.mc_bone_marrow_details;
                assessmentTCH.MC_Cardiac__c = deserializeResults.mc_cardiac_details;
                assessmentTCH.MC_Clinical_Status_Criteria__c = deserializeResults.mc_clinical_status_label;
                assessmentTCH.MC_Clinical_Status_Includes_All__c = deserializeResults.mc_clinical_status_includes_all;
                assessmentTCH.MC_Gastrointestinal__c = deserializeResults.mc_gastrointestinal_condition_details;
                assessmentTCH.MC_Hematologic__c = deserializeResults.mc_malignant_endstage_disease_details;
                assessmentTCH.MC_Infection__c = deserializeResults.mc_infection_details;
                assessmentTCH.MC_Pneumonia__c = deserializeResults.mc_pneumonia;
                assessmentTCH.MC_Primary_Conditions__c = deserializeResults.mc_medical_complex;
                assessmentTCH.MC_Pyelonephritis__c = deserializeResults.mc_pyelonephritis;
                assessmentTCH.MC_Renal__c = deserializeResults.mc_renal_insufficiency_details;
                assessmentTCH.MC_Surgical_Or_Wound_Infection__c = deserializeResults.mc_surgical_wound;
                assessmentTCH.MC_Systemic_Or_Organ_Infection__c = deserializeResults.mc_systemic_organ;
                assessmentTCH.MC_Treatments_To_Consider__c = deserializeResults.mc_treatments_to_consider;
                assessmentTCH.Medicaid_Start__c = deserializeResults.medicaid_start;
                assessmentTCH.Medicaid_Authorization_Number__c = deserializeResults.medicaid_authorization_number;
                assessmentTCH.Medicaid_Contact_Name__c = deserializeResults.medicaid_contact_name;
                assessmentTCH.Medicaid_Contact_Phone__c = deserializeResults.medicaid_contact_phone;
                assessmentTCH.Medicaid_Member_Id__c = deserializeResults.medicaid_member_id;
                assessmentTCH.Medical_Or_Surgical_History__c = deserializeResults.medical_surgery_history;
                assessmentTCH.Medicare_Days_Coinsurance__c = deserializeResults.medicare_days_2;
                assessmentTCH.Medicare_Days_Full__c = deserializeResults.medicare_days_1;
                assessmentTCH.Medicare_Days_LTR__c = deserializeResults.medicare_days_3;
                assessmentTCH.Medication_Allergies__c = deserializeResults.medication_allergies;
                if (deserializeResults.medication_drips != null) assessmentTCH.Medication_Drips__c = deserializeResults.medication_drips;
                if (deserializeResults.iv_meds != null) assessmentTCH.Medication_Drips__c = deserializeResults.iv_meds;
                assessmentTCH.Medication_Drips_Specify__c = deserializeResults.medication_drips_specify;
                if (deserializeResults.medication_iv_access != null) assessmentTCH.Medication_IV_Access__c = deserializeResults.medication_iv_access;
                if (deserializeResults.iv_access != null) assessmentTCH.Medication_IV_Access__c = deserializeResults.iv_access;
                assessmentTCH.Medication_IV_Access_PICC_Specify__c = deserializeResults.medication_iv_access_picc_specify;
                assessmentTCH.Medication_IV_Access_Specify__c = deserializeResults.medication_iv_access_specify;
                assessmentTCH.Medication_MARs__c = deserializeResults.medication_MARs;
                assessmentTCH.Medication_MARs_Pages__c = deserializeResults.medication_MARs_pages;
                assessmentTCH.Mgmt_Group_Name__c = deserializeResults.mgmt_group_name;
                assessmentTCH.Mgmt_Group_Phone__c = deserializeResults.mgmt_group_phone;
                assessmentTCH.Musculoskeletal_Activity_Level__c = deserializeResults.musculoskeletal_activity_level;
                assessmentTCH.Musculoskeletal_Casts_Splints__c = deserializeResults.musculoskeletal_casts_splints;
                assessmentTCH.Musculoskeletal_Contractures__c = deserializeResults.musculoskeletal_contractures;
                assessmentTCH.Musculoskeletal_Contractures_Specify__c = deserializeResults.musculoskeletal_contractures_specify;
                assessmentTCH.Musculoskeletal_Orthotics__c = deserializeResults.musculoskeletal_orthotics;
                assessmentTCH.Musculoskeletal_Recent_Falls__c = deserializeResults.musculoskeletal_recent_falls;
                assessmentTCH.Musculoskeletal_SCD__c = deserializeResults.musculoskeletal_scd;
                assessmentTCH.Musculoskeletal_TED_Hose__c = deserializeResults.musculoskeletal_ted_hose;
                assessmentTCH.Musculoskeletal_Traction__c = deserializeResults.musculoskeletal_traction;
                assessmentTCH.Musculoskeletal_Type__c = deserializeResults.musculoskeletal_limits;
                assessmentTCH.Neurological_Info_Date__c = deserializeResults.neurological_info_date;
                assessmentTCH.New_Consults__c = deserializeResults.information_new_consultants;
                assessmentTCH.New_Surgery_Or_Intervention__c = deserializeResults.information_new_surgery;
                assessmentTCH.New_Surgery_Or_Intervention_Identify__c = deserializeResults.information_identify;
                assessmentTCH.Number_Days_Out__c = deserializeResults.number_days_out;
                assessmentTCH.Nursing_Unit_Name__c = deserializeResults.nursing_unit_name;
                assessmentTCH.Nursing_Unit_Number__c = deserializeResults.nursing_unit_number;
                assessmentTCH.Nursing_Unit_Phone__c = deserializeResults.nursing_unit_phone;
                assessmentTCH.Present_Nursing_Unit_Room_Number__c = deserializeResults.present_nursing_unit_room_number;
                assessmentTCH.Nursing_Unit_Type__c = deserializeResults.nursing_unit_type;
                assessmentTCH.O2_Flow_Mode__c = deserializeResults.o2_flow_mode;
                
                try {
                    assessmentTCH.O2_Sats__c = Decimal.valueOf(deserializeResults.o2_sats);
                }
                catch (Exception e) {
                    assessmentTCH.O2_Sats__c = null;
                }
                
                assessmentTCH.O2_Sats_Other__c = deserializeResults.o2_sats_other;
                assessmentTCH.Organism_History_Acenitobacter__c = deserializeResults.organism_history_acinetobacteria;
                assessmentTCH.Organism_History_Acenitobacter_Status__c = deserializeResults.organism_history_acinetobacteria_status;
                assessmentTCH.Organism_History_CDiff__c = deserializeResults.organism_history_cdiff;
                assessmentTCH.Organism_History_CDiff_Status__c = deserializeResults.organism_history_cdiff_status;
                assessmentTCH.Organism_History_Comments__c = deserializeResults.organism_history_comments;
                assessmentTCH.Organism_History_CRE__c = deserializeResults.organism_history_cre;
                assessmentTCH.Organism_History_CRE_Status__c = deserializeResults.organism_history_cre_status;
                assessmentTCH.Organism_History_ESBL__c = deserializeResults.organism_history_esbl;
                assessmentTCH.Organism_History_ESBL_Status__c = deserializeResults.organism_history_esbl_status;
                assessmentTCH.Organism_History_MDRO__c = deserializeResults.organism_history_mdro;
                assessmentTCH.Organism_History_MDRO_Specify__c = deserializeResults.organism_history_mdro_specify;
                assessmentTCH.Organism_History_MDRO_Status__c = deserializeResults.organism_history_mdro_status;
                assessmentTCH.Organism_History_MRSA__c = deserializeResults.organism_history_mrsa;
                assessmentTCH.Organism_History_MRSA_Status__c = deserializeResults.organism_history_mrsa_status;
                assessmentTCH.Organism_History_Other__c = deserializeResults.organism_history_other;
                assessmentTCH.Organism_History_Other_Specify__c = deserializeResults.organism_history_other_specify;
                assessmentTCH.Organism_History_Other_Status__c = deserializeResults.organism_history_other_status;
                assessmentTCH.Organism_History_TB__c = deserializeResults.organism_history_tb;
                assessmentTCH.Organism_History_TB_Status__c = deserializeResults.organism_history_tb_status;
                assessmentTCH.Organism_History_VRE__c = deserializeResults.organism_history_vre;
                assessmentTCH.Organism_History_VRE_Status__c = deserializeResults.organism_history_vre_status;
                assessmentTCH.Other_Lab_1_Date__c = deserializeResults.other_1_date;
                assessmentTCH.Other_Lab_1_Name__c = deserializeResults.other_1_name;
                assessmentTCH.Other_Lab_1_Value__c = deserializeResults.other_1_value;
                assessmentTCH.Other_Lab_2_Date__c = deserializeResults.other_2_date;
                assessmentTCH.Other_Lab_2_Name__c = deserializeResults.other_2_name;
                assessmentTCH.Other_Lab_2_Value__c = deserializeResults.other_2_value;
                assessmentTCH.Other_Psychoactive_Meds_Details__c = deserializeResults.other_psychoactive_meds_details;
                assessmentTCH.Patient_Able_To_Sign_Consent__c = deserializeResults.patient_able_to_sign_consent;
                assessmentTCH.Patient_Address__c = deserializeResults.patient_address;
                assessmentTCH.Patient_City__c = deserializeResults.patient_city;
                assessmentTCH.Patient_Date_Of_Birth__c = deserializeResults.patient_date_of_birth;
                assessmentTCH.Patient_Email__c = convertEmailToNullIfInvalid(deserializeResults.patient_email_address);
                assessmentTCH.Patient_Ethnicity__c = deserializeResults.patient_ethnicity;
                assessmentTCH.Patient_First_Name__c = deserializeResults.patient_first_name;
                assessmentTCH.Patient_Gender__c = deserializeResults.patient_gender;
                assessmentTCH.Patient_Language__c = deserializeResults.patient_language;
                assessmentTCH.Patient_Last_Name__c = deserializeResults.patient_last_name;
                assessmentTCH.Patient_Living_Will__c = deserializeResults.patient_living_will;
                assessmentTCH.Patient_Marital_Status__c = deserializeResults.patient_marital_status;
                assessmentTCH.Patient_Middle_Name_Initial__c = deserializeResults.patient_middle_name_initial;
                assessmentTCH.Patient_Name_Suffix__c = deserializeResults.patient_name_suffix;
                assessmentTCH.Patient_Primary_Phone__c = deserializeResults.patient_primary_phone;
                assessmentTCH.Patient_Alternate_Phone__c = deserializeResults.patient_alternate_phone;
                assessmentTCH.Patient_Cell_Phone__c = deserializeResults.patient_cell_phone;
                assessmentTCH.Patient_Physically_Seen__c = deserializeResults.patient_physically_seen;
                assessmentTCH.Patient_Religion__c = deserializeResults.patient_religion;
                assessmentTCH.Patient_Social_Security_Number__c = deserializeResults.patient_social_security_number;
                assessmentTCH.Patient_State__c = deserializeResults.patient_state;
                assessmentTCH.Patient_Postal_Code__c = deserializeResults.patient_postal_code;
                assessmentTCH.Personality_Disorder__c = deserializeResults.personality_disorder;
                assessmentTCH.Personality_Disorder_Additional_Details__c = deserializeResults.personality_disorder_additional_details;
                assessmentTCH.Physicians_Orders__c = deserializeResults.physicians_orders;
                assessmentTCH.Physiological_Date__c = deserializeResults.physiological_date;
                assessmentTCH.Physiological_DBP__c = deserializeResults.physiological_dbp;
                assessmentTCH.Physiological_HR__c = deserializeResults.physiological_hr;
                assessmentTCH.Physiological_RR__c = deserializeResults.physiological_rr;
                assessmentTCH.Physiological_SBP__c = deserializeResults.physiological_sbp;
                assessmentTCH.Physiological_State__c = deserializeResults.physiological_state;
                assessmentTCH.Physiological_Temp__c = deserializeResults.physiological_temp;
                assessmentTCH.Plan_Of_Discharge__c = deserializeResults.plan_of_discharge;
                assessmentTCH.Plan_Of_Discharge_Additional_Details__c = deserializeResults.plan_of_discharge_additional_details;
                assessmentTCH.Plan_To_Return__c = deserializeResults.plan_to_return;
                assessmentTCH.Platelets_Date__c = deserializeResults.platelets_date;
                assessmentTCH.Platelets_Value__c = deserializeResults.platelets_value;
                assessmentTCH.Pneumococcal__c = deserializeResults.pneumoccal_vaccination_not_applicable;
                assessmentTCH.Pneumococcal_Year__c = deserializeResults.pneumoccal_vaccination_date;
                assessmentTCH.Potassium_Date__c = deserializeResults.potassium_date;
                assessmentTCH.Potassium_Value__c = deserializeResults.potassium_value;
                assessmentTCH.PreAlb_Date__c = deserializeResults.prealb_date;
                assessmentTCH.PreAlb_Value__c = deserializeResults.prealb_value;
                assessmentTCH.Precautions__c = deserializeResults.historical_info_precautions;
                assessmentTCH.Pressure_Ulcers__c = deserializeResults.pressure_ulcers;
                assessmentTCH.Primary_HIC__c = deserializeResults.primary_hic;
                assessmentTCH.Primary_Insurance_Copy__c = deserializeResults.primary_insurance_copy;
                assessmentTCH.Primary_Insurance_Id__c = deserializeResults.primary_insurance_id;
                assessmentTCH.Primary_Insurance_Name__c = deserializeResults.primary_insurance_name;
                assessmentTCH.Primary_Payer_Source__c = deserializeResults.primary_payer_source;
                if (deserializeResults.primary_physician != null && deserializeResults.primary_physician.size() > 0) {
                    for (primary_physician_group_item physician: deserializeResults.primary_physician) {
                        assessmentTCH.Primary_Physician__c = physician.primary_physician_name;
                        if (physician.primary_physician_sfid != null) {
                            if (physician.primary_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.primary_physician_sfid].size() > 0) {
                                assessmentTCH.Primary_Physician_As_Contact__c = physician.primary_physician_sfid;
                            } else if (physician.primary_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.primary_physician_sfid].size() > 0) {
                                assessmentTCH.Primary_Physician_As_Lead__c = physician.primary_physician_sfid; 
                            }   
                        }
                    }   
                }
                if (deserializeResults.primary_care_physician != null && deserializeResults.primary_care_physician.size() > 0) {
                    for (primary_care_physician_group_item physician: deserializeResults.primary_care_physician) {
                        assessmentTCH.Primary_Physician__c = physician.primary_care_physician_name;
                        if (physician.primary_care_physician_sfid != null) {
                            if (physician.primary_care_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                assessmentTCH.Primary_Physician_As_Contact__c = physician.primary_care_physician_sfid;
                            } else if(physician.primary_care_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.primary_care_physician_sfid].size() > 0) {
                                assessmentTCH.Primary_Physician_As_Lead__c = physician.primary_care_physician_sfid; 
                            }
                        }
                    }
                }
                if (deserializeResults.primary_physician_phone != null) assessmentTCH.Primary_Physician_Phone__c = deserializeResults.primary_physician_phone;
                if (deserializeResults.primary_care_physician_phone != null) assessmentTCH.Primary_Physician_Phone__c = deserializeResults.primary_care_physician_phone;
                assessmentTCH.Pre_Cert_Needed_Primary__c = deserializeResults.pre_cert_needed_primary;
                assessmentTCH.Primary_Reason_For_LTAC_Admission__c = deserializeResults.primary_ltac_admission_reason;
                assessmentTCH.Prior_Functional_Status__c = deserializeResults.prior_functional_status;
                assessmentTCH.Prior_Hospitalization_End__c = deserializeResults.prior_hospitalization_end;
                assessmentTCH.Prior_Hospitalization_Start__c = deserializeResults.prior_hospitalization_start;
                assessmentTCH.Prior_Living_Arrangements__c = deserializeResults.prior_living_arrangements;
                assessmentTCH.Prior_Living_Additional_Details__c = deserializeResults.prior_living_arrangements_addition_details;
                assessmentTCH.Prior_SNF_End__c = deserializeResults.prior_snf_end;
                assessmentTCH.Prior_SNF_Start__c = deserializeResults.prior_snf_start;
                assessmentTCH.Psychosis__c = deserializeResults.psychosis;
                assessmentTCH.Psychosis_Additional_Details__c = deserializeResults.psychosis_additional_details;
                assessmentTCH.Psych_Retardation__c = deserializeResults.psych_retardation;
                assessmentTCH.Psych_Retardation_Additional_Details__c = deserializeResults.psych_retardation_additional_details;
                assessmentTCH.Psych_Social_Behavior__c = deserializeResults.psych_social_behavior;
                assessmentTCH.Psych_Social_Meds__c = deserializeResults.psych_social_meds;
                assessmentTCH.PT_Date__c = deserializeResults.pt_date;
                assessmentTCH.PTT_Date__c = deserializeResults.ptt_date;
                assessmentTCH.PTT_Value__c = deserializeResults.ptt_value;
                assessmentTCH.PT_Value__c = deserializeResults.pt_value;
                assessmentTCH.RBC_Date__c = deserializeResults.rbc_date;
                assessmentTCH.RBC_Value__c = deserializeResults.rbc_value;
                assessmentTCH.RC_Active_Comorbid_Conditions__c = deserializeResults.rs_active_comorbid_conditions;
                assessmentTCH.RC_Clinical_Status_Criteria__c = deserializeResults.rs_clinical_status_label;
                assessmentTCH.RC_Clinical_Status_Includes_All__c = deserializeResults.rs_clinical_status_includes_all;
                assessmentTCH.RC_Failed_At_LLOC__c = deserializeResults.rs_failed_at_lloc;
                assessmentTCH.RC_Hypoxia__c = deserializeResults.rs_hypoxia;
                assessmentTCH.RC_Post_Event__c = deserializeResults.rs_post_event;
                assessmentTCH.RC_Primary_Conditions__c = deserializeResults.rs_respiratory_complex;
                assessmentTCH.RC_Treatments_To_Consider__c = deserializeResults.rs_treatments_to_consider;
                assessmentTCH.Reassessment_Date__c = deserializeResults.information_reassessment_date;
                assessmentTCH.Recalcitrant_Wounds__c = deserializeResults.recalcitrant_wounds;
                assessmentTCH.Recent_Weight_Change__c = deserializeResults.recent_weight_change;
                assessmentTCH.Rectal_Date__c = deserializeResults.rectal_date;
                assessmentTCH.Rectal_Tube__c = deserializeResults.rectal_tube;
                assessmentTCH.Referral_Address__c = deserializeResults.referral_address;
                assessmentTCH.Referral_City__c = deserializeResults.referral_city;
                if (deserializeResults.referral_contact != null && deserializeResults.referral_contact.size() > 0) {
                    for (referral_contact_group_item refcontact: deserializeResults.referral_contact) {
                        assessmentTCH.Referral_Contact__c = refcontact.referral_contact_name;
                        if (refcontact.referral_contact_sfid != null) {
                            if (refcontact.referral_contact_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :refcontact.referral_contact_sfid].size() > 0) {
                                assessmentTCH.Referral_Contact_As_Contact__c = refcontact.referral_contact_sfid;
                            } else if (refcontact.referral_contact_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :refcontact.referral_contact_sfid].size() > 0) {
                                assessmentTCH.Referral_Contact_As_Lead__c = refcontact.referral_contact_sfid; 
                            }
                        }
                    }   
                }
                if (deserializeResults.referring_contact != null && deserializeResults.referring_contact.size() > 0) {
                    for (referring_contact_group_item refcontact: deserializeResults.referring_contact) {
                        assessmentTCH.Referral_Contact__c = refcontact.referring_contact_name;
                        if (refcontact.referring_contact_sfid != null) {
                            if (refcontact.referring_contact_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :refcontact.referring_contact_sfid].size() > 0) {
                                assessmentTCH.Referral_Contact_As_Contact__c = refcontact.referring_contact_sfid;
                            } else if (refcontact.referring_contact_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :refcontact.referring_contact_sfid].size() > 0) {
                                assessmentTCH.Referral_Contact_As_Lead__c = refcontact.referring_contact_sfid; 
                            }
                        }
                    }   
                }
                if (deserializeResults.referral_contact_phone != null) assessmentTCH.Referral_Contact_Phone__c = deserializeResults.referral_contact_phone;                
                if (deserializeResults.referring_contact_phone != null) assessmentTCH.Referral_Contact_Phone__c = deserializeResults.referring_contact_phone;
                if (deserializeResults.referral_alt_phone != null) assessmentTCH.Referral_Alt_Phone__c = deserializeResults.referral_alt_phone;
                if (deserializeResults.referral_contact_alternate_phone != null) assessmentTCH.Referral_Alt_Phone__c = deserializeResults.referral_contact_alternate_phone;
                assessmentTCH.Patient_Demographics_Referral_Date__c = deserializeResults.patient_demographics_referral_date;
                if (deserializeResults.referral_location != null && deserializeResults.referral_location.size() > 0) {
                    for (referral_location_group_item location: deserializeResults.referral_location) {
                        assessmentTCH.Referral_Location__c = location.referral_location_name;
                        if (location.referral_location_sfid != null) {
                            if (location.referral_location_sfid.getSObjectType() == Account.sObjectType &&
                            [select Id from Account where Id = :location.referral_location_sfid].size() > 0) {
                                assessmentTCH.Referral_Location_Account__c = location.referral_location_sfid;
                            }
                        }
                    }   
                } 
                if (deserializeResults.referring_location != null && deserializeResults.referring_location.size() > 0) {
                    for (referring_location_group_item location: deserializeResults.referring_location) {
                        assessmentTCH.Referral_Location__c = location.referring_location_name;
                        if (location.referring_location_sfid != null) {
                            if (location.referring_location_sfid.getSObjectType() == Account.sObjectType &&
                            [select Id from Account where Id = :location.referring_location_sfid].size() > 0) {
                                assessmentTCH.Referral_Location_Account__c = location.referring_location_sfid;
                            }
                        }
                    }   
                } 
               assessmentTCH.Referral_Location_Phone__c = deserializeResults.referral_location_phone;
               if (deserializeResults.referral_physician != null && deserializeResults.referral_physician.size() > 0) {
                    for (referral_physician_group_item physician: deserializeResults.referral_physician) {
                        assessmentTCH.Referral_Physician__c = physician.referral_physician_name;
                        if (physician.referral_physician_sfid != null) {
                            if (physician.referral_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.referral_physician_sfid].size() > 0) {
                                assessmentTCH.Referral_Physician_As_Contact__c = physician.referral_physician_sfid;
                            } else if(physician.referral_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.referral_physician_sfid].size() > 0) {
                                assessmentTCH.Referral_Physician_As_Lead__c = physician.referral_physician_sfid; 
                            }
                        }
                    }   
               }
               if (deserializeResults.referring_physician != null && deserializeResults.referring_physician.size() > 0) {
                    for (referring_physician_group_item physician: deserializeResults.referring_physician) {
                        assessmentTCH.Referral_Physician__c = physician.referring_physician_name;
                        if (physician.referring_physician_sfid != null) {
                            if (physician.referring_physician_sfid.getSObjectType() == Contact.sObjectType &&
                            [select Id from Contact where Id = :physician.referring_physician_sfid].size() > 0) {
                                assessmentTCH.Referral_Physician_As_Contact__c = physician.referring_physician_sfid;
                            } else if(physician.referring_physician_sfid.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physician.referring_physician_sfid].size() > 0) {
                                assessmentTCH.Referral_Physician_As_Lead__c = physician.referring_physician_sfid; 
                            }
                        }
                    }   
               }
               assessmentTCH.Referral_Physician_Phone__c = deserializeResults.referral_physician_phone_number;
               assessmentTCH.Referral_Postal_Code__c = deserializeResults.referral_postal_code;
               assessmentTCH.Referral_Source_Type__c = deserializeResults.referral_source_type;
               assessmentTCH.Referral_State__c = deserializeResults.referral_state;
               if (deserializeResults.patient_demographics_refer_to != null && deserializeResults.patient_demographics_refer_to.size() > 0) {
                    for (patient_demographics_refer_to_tch_group_item refer_to: deserializeResults.patient_demographics_refer_to){
                        assessmentTCH.Patient_Demographics_Refer_To__c = refer_to.patient_demographics_refer_to_name;
                        if (refer_to.patient_demographics_refer_to_sfid != null) {
                            if (refer_to.patient_demographics_refer_to_sfid.getSObjectType() == Account.sObjectType &&
                            [select Id from Account where Id = :refer_to.patient_demographics_refer_to_sfid].size() > 0) {
                                assessmentTCH.Refer_To_Account__c = refer_to.patient_demographics_refer_to_sfid;
                            }
                        }
                    }   
               }
               if (deserializeResults.refer_to != null && deserializeResults.refer_to.size() > 0) {
                    for (refer_to_tch_group_item refer_to: deserializeResults.refer_to){
                        assessmentTCH.Patient_Demographics_Refer_To__c = refer_to.refer_to_name;
                        if (refer_to.refer_to_sfid != null) {
                            if (refer_to.refer_to_sfid.getSObjectType() == Account.sObjectType &&
                            [select Id from Account where Id = :refer_to.refer_to_sfid].size() > 0) {
                                assessmentTCH.Refer_To_Account__c = refer_to.refer_to_sfid;
                            }
                        }
                    }   
               }
               assessmentTCH.Rehab_Additional_Details__c = deserializeResults.rehab_additional_details;
               assessmentTCH.Rehab_Ambulate__c = deserializeResults.rehab_ambulate;
               assessmentTCH.Rehab_Anticipated__c = deserializeResults.rehab_anticipated;
               assessmentTCH.Rehab_Transfer__c = deserializeResults.rehab_transfer;
               assessmentTCH.Rehab_Type__c = deserializeResults.rehab_type;
               assessmentTCH.Respiration_Frequency__c = deserializeResults.respiration_frequency;
               assessmentTCH.Respiratory_BIPAP__c = deserializeResults.respiratory_bipap;
               assessmentTCH.Respiratory_Chest_Tube__c = deserializeResults.respiratory_chest_tube;
               assessmentTCH.Respiratory_CPAP__c = deserializeResults.respiratory_cpap;
               assessmentTCH.Respiratory_ET_Tube__c = deserializeResults.respiratory_et_tube;
               if (deserializeResults.respiratory_fi02 != null) assessmentTCH.Respiratory_FIO2__c = deserializeResults.respiratory_fi02;
               if (deserializeResults.vent_fio2 != null) assessmentTCH.Respiratory_FIO2__c = deserializeResults.vent_fio2;
               assessmentTCH.Respiratory_Not_Tolerated__c = deserializeResults.respiratory_not_tolerated;
               assessmentTCH.Respiratory_Not_Tolerated_Specify__c = deserializeResults.respiratory_not_tolerated_specify;
               if (deserializeResults.respiratory_o2_delivery != null) assessmentTCH.Respiratory_O2_Delivery__c = deserializeResults.respiratory_o2_delivery;
               if (deserializeResults.o2delivery != null) assessmentTCH.Respiratory_O2_Delivery__c = deserializeResults.o2delivery;
               if (deserializeResults.respiratory_o2_lpm != null) assessmentTCH.Respiratory_O2_LPM__c = deserializeResults.respiratory_o2_lpm;
               if (deserializeResults.lmin != null) assessmentTCH.Respiratory_O2_LPM__c = deserializeResults.lmin;
               if (deserializeResults.respiratory_peep != null) assessmentTCH.Respiratory_PEEP__c = deserializeResults.respiratory_peep;
               if (deserializeResults.vent_peep != null) assessmentTCH.Respiratory_PEEP__c = deserializeResults.vent_peep;
               if (deserializeResults.respiratory_ps != null) assessmentTCH.Respiratory_PS__c = deserializeResults.respiratory_ps;
               if (deserializeResults.vent_ps != null) assessmentTCH.Respiratory_PS__c = deserializeResults.vent_ps;
               if (deserializeResults.respiratory_rate != null) assessmentTCH.Respiratory_Rate__c = deserializeResults.respiratory_rate;
               if (deserializeResults.vent_rate != null) assessmentTCH.Respiratory_Rate__c = deserializeResults.vent_rate;
               if (deserializeResults.respiratory_trach_size != null) assessmentTCH.Respiratory_Trach_Size__c = deserializeResults.respiratory_trach_size;
               if (deserializeResults.trach_size != null) assessmentTCH.Respiratory_Trach_Size__c = deserializeResults.trach_size;
               if (deserializeResults.respiratory_trach_type != null) assessmentTCH.Respiratory_Trach_Type__c = deserializeResults.respiratory_trach_type;
               if (deserializeResults.trach_type != null) assessmentTCH.Respiratory_Trach_Type__c = deserializeResults.trach_type;
               if (deserializeResults.respiratory_treatments != null) assessmentTCH.Respiratory_Treatments__c = deserializeResults.respiratory_treatments;
               if (deserializeResults.o2treatments != null) assessmentTCH.Respiratory_Treatments__c = deserializeResults.o2treatments;
               assessmentTCH.Respiratory_Tube_Location__c = deserializeResults.respiratory_tube_location;
               assessmentTCH.Respiratory_Tube_Size__c = deserializeResults.respiratory_tube_size;
               if (deserializeResults.respiratory_tv != null) assessmentTCH.Respiratory_TV__c = deserializeResults.respiratory_tv;
               if (deserializeResults.vent_tv != null) assessmentTCH.Respiratory_TV__c = deserializeResults.vent_tv;
               if (deserializeResults.respiratory_vent_mode != null) assessmentTCH.Respiratory_Vent_Mode__c = deserializeResults.respiratory_vent_mode;
               if (deserializeResults.vent_mode != null) assessmentTCH.Respiratory_Vent_Mode__c = deserializeResults.vent_mode;
               if (deserializeResults.respiratory_weaning != null) assessmentTCH.Respiratory_Weaning__c = deserializeResults.respiratory_weaning;
               if (deserializeResults.vent_weaning != null) assessmentTCH.Respiratory_Weaning__c = deserializeResults.vent_weaning;
               assessmentTCH.Respiratory_Weaning_Attempts__c = deserializeResults.respiratory_weaning_attempts;
               assessmentTCH.Respiratory_Weaning_Mode__c = deserializeResults.respiratory_weaning_mode;
               assessmentTCH.Restraints_Type__c = deserializeResults.restraints_type;
               assessmentTCH.Restraints_Type_Additional_Details__c = deserializeResults.restraints_type_additional_details;
               assessmentTCH.Risk_Of_Elopement__c = deserializeResults.risk_of_elopement;
               assessmentTCH.Risk_Of_Elopement_Additional_Details__c = deserializeResults.risk_of_elopement_additional_details;
               assessmentTCH.Risk_Of_Injury__c = deserializeResults.risk_of_injury;
               assessmentTCH.Risk_Of_Injury_Additional_Details__c = deserializeResults.risk_of_injury_additional_details;
               assessmentTCH.Rogers_Orders__c = deserializeResults.rogers_orders;
               assessmentTCH.Secondary_HIC__c = deserializeResults.secondary_hic;
               assessmentTCH.Secondary_Insurance_Copy__c = deserializeResults.secondary_insurance_copy;
               assessmentTCH.Secondary_Insurance_Id__c = deserializeResults.secondary_insurance_id;
               assessmentTCH.Secondary_Insurance_Name__c = deserializeResults.secondary_insurance_name;
               assessmentTCH.Secondary_Payer_Source__c = deserializeResults.secondary_payer_source;
               assessmentTCH.Pre_Cert_Needed_Secondary__c = deserializeResults.pre_cert_needed_secondary;
               assessmentTCH.SNF_Days_Remaining__c = deserializeResults.snf_days_remaining;
               assessmentTCH.Sodium_Date__c = deserializeResults.sodium_date;
               assessmentTCH.Sodium_Value__c = deserializeResults.sodium_value;
               assessmentTCH.State_Name__c = deserializeResults.state_name;
               assessmentTCH.Stepdown_Date1__c = deserializeResults.stepdown_date1;
               assessmentTCH.Stepdown_Date2__c = deserializeResults.stepdown_date2;
               assessmentTCH.Stepdown_Date3__c = deserializeResults.stepdown_date3;
               assessmentTCH.Stepdown_Date4__c = deserializeResults.stepdown_date4;
               assessmentTCH.Step_Down_Dates_Required__c = deserializeResults.step_down_dates_required;
               assessmentTCH.Summary_Non_Government__c = deserializeResults.summary_non_government;
               assessmentTCH.Summary_Secondary__c = deserializeResults.summary_secondary;
               assessmentTCH.Surgical_Site_Infection__c = deserializeResults.surgical_site_infection;
               assessmentTCH.Third_Party_Admin_Name__c = deserializeResults.third_party_admin_name;
               assessmentTCH.Third_Party_Admin_Phone__c = deserializeResults.third_party_admin_phone;
               assessmentTCH.Trach_Date__c = deserializeResults.trach_date;
               assessmentTCH.Traction_Type__c = deserializeResults.traction_type;
               assessmentTCH.Traction_Weight__c = deserializeResults.traction_weight;
               assessmentTCH.Tribal_Affiliations__c = deserializeResults.tribal_affiliations;
               assessmentTCH.Type_Of_Assessment__c = deserializeResults.type_of_assessment;
               assessmentTCH.Urine_Describe__c = deserializeResults.urine_describe;
               assessmentTCH.Urostomy__c = deserializeResults.urostomy;
               assessmentTCH.Urostomy_Date__c = deserializeResults.urostomy_date;
               assessmentTCH.Vascular_Catheter_Associated_Infection__c = deserializeResults.vascular_catheter_associated_infection;
               if (deserializeResults.respiratory_not_applicable != null) assessmentTCH.Vent__c = deserializeResults.respiratory_not_applicable;
               if (deserializeResults.o2 != null) assessmentTCH.Vent__c = deserializeResults.o2;
               assessmentTCH.VN_No_Weaning_Reason__c = deserializeResults.vn_no_prior_weaning;
               assessmentTCH.VN_Primary_Condition__c = deserializeResults.vn_vent_dependence;
               assessmentTCH.VN_Treatments_To_Consider__c = deserializeResults.vn_treatments_to_consider;
               assessmentTCH.VN_Weaning_Criteria__c = deserializeResults.ventilator_group_weaning_potential_label1;
               assessmentTCH.VN_Weaning_Includes_All__c = deserializeResults.vn_weaning_includes;
               assessmentTCH.WBC_Date__c = deserializeResults.wbc_date;
               assessmentTCH.WBC_Value__c = deserializeResults.wbc_value;
               assessmentTCH.WC_Active_Comorbid_Conditions__c = deserializeResults.wc_active_comorbid_conditions;
               assessmentTCH.WC_Clinical_Status_Criteria__c = deserializeResults.wc_clinical_status_label;
               assessmentTCH.WC_Clinical_Status_Includes_All__c = deserializeResults.wc_clinical_status_includes_all;
               assessmentTCH.WC_Infection__c = deserializeResults.wc_infection;
               assessmentTCH.WC_Large_Wound__c = deserializeResults.wc_large_wound;
               assessmentTCH.WC_Lower_Extremity__c = deserializeResults.wc_lower_extremity_conditions;
               assessmentTCH.WC_Lower_Extremity_Risk_Factors__c = deserializeResults.wc_lower_extremity_risk_factors;
               assessmentTCH.WC_Primary_Conditions__c = deserializeResults.wc_wound_skin_condition;
               assessmentTCH.WC_Treatments_To_Consider__c = deserializeResults.wc_treatments_to_consider;
               assessmentTCH.Prior_Device_Use__c = deserializeResults.prior_device_use;
               assessmentTCH.Prior_Functioning_Activity_Level__c = deserializeResults.prior_functioning_activity_level;
               assessmentTCH.Admitted_To_STAC_On_Vent__c = deserializeResults.admitted_to_stac_on_vent;
               assessmentTCH.Chronic_Vent__c = deserializeResults.chronic_vent;
               assessmentTCH.Date_Initiated_Vent__c = deserializeResults.date_initiated_vent;

               insert assessmentTCH;

               //Insert Consulting MDs
               if (deserializeResults.consulting_mds != null && deserializeResults.consulting_mds.size() > 0) {
                    for (consulting_mds_group_item md: deserializeResults.consulting_mds) {
                        Consulting_Physician_TCH__c tchMD = new Consulting_Physician_TCH__c();
                        tchMD.Assessment_TCH__c = assessmentTCH.id;
                        tchMD.Consulting_Physician__c = md.consulting_mds_name;
                        
                        Id physicianId;
                        
                        try {
                            //If we can't put the passed in Id into an Id type, then we'll just not insert it
                            physicianId = Id.valueOf(md.consulting_mds_sfid);
                        }
                        catch (Exception ex) {
                            physicianId = null;
                        }
                        
                        if (physicianId != null) {
                            if (physicianId.getSObjectType() == Contact.sObjectType && [select Id from Contact where Id = :physicianId].size() > 0) {
                                tchMD.Consulting_Physician_As_Contact__c = physicianId;
                            } else if (physicianId.getSObjectType() == Lead.sObjectType && [select Id from Lead where Id = :physicianId].size() > 0) {
                                tchMD.Consulting_Physician_As_Lead__c = physicianId; 
                            }
                        }
                        
                        insert tchMD;
                    }
               }

               //Insert Contacts
               if (deserializeResults.variable_contact_group != null && deserializeResults.variable_contact_group.size() > 0) {
                    for (variable_contact_group_item contact: deserializeResults.variable_contact_group) {
                        Contact_TCH__c tchContact = new Contact_TCH__c();
                        tchContact.Assessment_TCH__c = assessmentTCH.id;
                        tchContact.App_Timestamp__c = contact.app_timestamp;
                        tchContact.Contact_Address__c = contact.contact_address;
                        tchContact.Contact_Alternative_Phone__c = contact.contact_alternate_phone;
                        tchContact.Contact_Cell_Phone__c = contact.contact_cell_phone;
                        tchContact.Contact_City__c = contact.contact_city;
                        tchContact.Contact_Email_Address__c = convertEmailToNullIfInvalid(contact.contact_email_address);
                        if(contact.contact_first_name != null) tchContact.Contact_First_Name__c = contact.contact_first_name;
                        if(contact.patient_contact_first_name != null) tchContact.Contact_First_Name__c = contact.patient_contact_first_name;
                        if(contact.contact_last_name != null) tchContact.Contact_Last_Name__c = contact.contact_last_name;
                        if(contact.patient_contact_last_name != null) tchContact.Contact_Last_Name__c = contact.patient_contact_last_name;
                        tchContact.Contact_Postal_Code__c = contact.contact_postal_code;
                        if(contact.contact_primary_phone != null) tchContact.Contact_Primary_Phone__c = contact.contact_primary_phone;
                        if(contact.patient_contact_phone != null) tchContact.Contact_Primary_Phone__c = contact.patient_contact_phone;
                        tchContact.Contact_Relationship__c = contact.contact_relationship;
                        tchContact.Contact_State__c = contact.contact_state;
                        tchContact.Contact_Type__c = contact.contact_type;
                        insert tchContact;
                    }
               }
                           
               //Insert Medication Lines
               if (deserializeResults.multiple_line_group != null && deserializeResults.multiple_line_group.size() > 0) {
                    for (multiple_line_group_item line: deserializeResults.multiple_line_group) {
                        Medication_Line_TCH__c tchMedicationLine = new Medication_Line_TCH__c();
                        tchMedicationLine.Assessment_TCH__c = assessmentTCH.id;
                        tchMedicationLine.App_Timestamp__c = line.app_timestamp;
                        tchMedicationLine.Line_CL_Type__c = line.line_cl_type;
                        tchMedicationLine.Line_Insertion_Date__c = line.line_insertion_date;
                        tchMedicationLine.Line_Location__c = line.line_location;
                        insert tchMedicationLine;
                    }
               }

               //Insert Medications
               if (deserializeResults.multiple_medications_group != null && deserializeResults.multiple_medications_group.size() > 0) {
                    for (multiple_medications_group_item medication: deserializeResults.multiple_medications_group) {
                        Medication_TCH__c tchMedication = new Medication_TCH__c();
                        tchMedication.Assessment_TCH__c = assessmentTCH.id;
                        tchMedication.App_Timestamp__c = medication.app_timestamp;
                        tchMedication.Medication_Dosage__c = medication.medication_dosage;
                        tchMedication.Medication_Frequency__c = medication.medication_frequency;                
                        tchMedication.Medication_Name__c = medication.medication_name;
                        tchMedication.Medication_Route__c = medication.medication_route;
                        insert tchMedication;
                    }   
               }

               //Insert Wounds
               if (deserializeResults.itegumentary_mutable_group != null && deserializeResults.itegumentary_mutable_group.size() > 0) {
                    for (integumentary_mutable_tch_group_item integumentary: deserializeResults.itegumentary_mutable_group) {
                        Integumentary_TCH__c tchIntegumentaryItem = new Integumentary_TCH__c();
                        tchIntegumentaryItem.Assessment_TCH__c = assessmentTCH.id;
                        tchIntegumentaryItem.App_Timestamp__c = integumentary.app_timestamp;
                        tchIntegumentaryItem.Skin_Item_Comments__c = integumentary.integ_skin_item_comments;
                        tchIntegumentaryItem.Skin_Item_Site__c = integumentary.skin_item_site; 
                        tchIntegumentaryItem.Skin_Item_Stage__c = integumentary.skin_item_stage;
                        tchIntegumentaryItem.Skin_Item_Stage_Size__c = integumentary.skin_item_stage_size;
                        insert tchIntegumentaryItem;
                    }   
               }

               //Insert Cultures
               if (deserializeResults.culture_history_mutable_group != null && deserializeResults.culture_history_mutable_group.size() > 0) {
                    for (culture_history_mutable_group_item culture: deserializeResults.culture_history_mutable_group) {
                        Culture_TCH__c tchCulture = new Culture_TCH__c();
                        tchCulture.Assessment_TCH__c = assessmentTCH.id;
                        tchCulture.App_Timestamp__c = culture.app_timestamp;
                        tchCulture.Culture_Date__c = culture.culture_date;
                        tchCulture.Culture_IV_Antibiotic__c = culture.culture_iv_antibiotic;
                        tchCulture.Culture_Organism__c = culture.culture_organism;
                        tchCulture.Culture_Site__c = culture.culture_site;
                        tchCulture.Culture_Start_Date__c = culture.culture_start_date;
                        tchCulture.Culture_Stop_Date__c = culture.culture_stop_date;
                        insert tchCulture;
                    }   
               }

               //Success!         
               return new Map<String,String> {'Result' => 'Success', 'Filename' => metadata.meta_filename, 'ObjectID' => assessmentTCH.id};
            } else {
                return new Map<String,String> {'Unknown FormType' => String.valueOf(metadata.meta_form_type)};            
            }   
        } catch (Exception mainError) {
            try {
                assessment_error payloadError = (assessment_error)System.JSON.deserialize(req.requestBody.toString(), assessment_error.class);

                Assessment_Error__c assessmentError = new Assessment_Error__c();
                assessmentError.JSON_Object__c = req.requestBody.toString();
                assessmentError.Meta_Filename__c = payloadError.meta_filename;
                assessmentError.Error_Description__c = mainError.getTypeName() + '\n' + mainError.getMessage() + '\n' + mainError.getLineNumber() + '\n' + mainError.getStackTraceString();
                
                insert assessmentError;

                return new Map<String,String> {'Result' => 'Failed', 'Error' => mainError.getMessage()};
            } catch (Exception errorError) {
                throw new AssessmentException(errorError.getMessage().abbreviate(253) + '; ');
            }
        }
    } 
}