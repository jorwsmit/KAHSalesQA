({
    doInit : function(component, event, helper){
        helper.getAndDisplayForm(component);
    	},
    
    saveAndPrintForm : function(component, event, helper){
    	var formFields = [];
        formFields.push('preferredFacilityName:' + component.get("v.preferredFacilityName","v.value") + ',');
        formFields.push('contactName:' + component.get("v.contactName","v.value") + ',');
        formFields.push('patientName:' + component.get("v.patientName","v.value") + ','); 
        formFields.push('formCallEndTime:' + component.get("v.formCallEndTime", "v.value") + ',');
        formFields.push('contactRelationship:' + component.get("v.contactRelationship", "v.value") + ',');
    	formFields.push('contactPhone:' + component.get("v.activeContact.Phone", "v.value") + ',');
        formFields.push('contactEmail:' + component.get("v.activeContact.Email", "v.value") + ',');
    	formFields.push('patientAge:' + component.get("v.patientAge", "v.value") + ',');
        formFields.push('patientDOB:' + component.get("v.activePatient.Date_of_Birth__c", "v.value") + ',');
    	formFields.push('patientCity:' + component.get("v.activePatient.City__c", "v.value") + ',');
    	formFields.push('patientState:' + component.get("v.activePatient.State__c", "v.value") + ',');
    	formFields.push('patientZip:' + component.get("v.activePatient.Postal_Code__c", "v.value") + ',');
    	formFields.push('patientPhone:' + component.get("v.activePatient.Phone__c", "v.value") + ',');
    	formFields.push('formSSN:' + component.get("v.formSSN", "v.value") + ',');
    	formFields.push('assessmentPayor:' + component.get("v.activeAssessment.Payor__c", "v.value") + ',');
    	formFields.push('assessmentMemberID:' + component.get("v.activeAssessment.Member_ID__c", "v.value") + ',');
    	formFields.push('assessmentSubscriberName:' + component.get("v.activeAssessment.Subscriber_Name__c", "v.value") + ',');
    	formFields.push('assessmentSecondaryPayor:' + component.get("v.activeAssessment.Secondary_Payor__c", "v.value") + ',');
    	formFields.push('assessmentSecondaryMemberID:' + component.get("v.activeAssessment.Secondary_Member_ID__c", "v.value") + ',');
    	formFields.push('assessmentSecondarySubscriberName:' + component.get("v.activeAssessment.Secondary_Subscriber_Name__c", "v.value") + ',');
    	formFields.push('formDXHX:' + component.get("v.formDXHX", "v.value") + ',');
    	formFields.push('formSituationConcerns:' + component.get("v.formSituationConcerns", "v.value") + ',');
    	formFields.push('formLocationAndDate:' + component.get("v.formLocationAndDate", "v.value") + ',');
    	formFields.push('preferredFacilityNameAddressPhone:' + component.get("v.preferredFacilityNameAddressPhone", "v.value") + ',');
    	formFields.push('formPhysicianSpecialtyPhone:' + component.get("v.formPhysicianSpecialtyPhone", "v.value") + ',');
    	formFields.push('formUserName:' + component.get("v.formUserName", "v.value") + ',');
    	formFields.push('formUserPhone:' + component.get("v.formUserPhone", "v.value") + ',');
        formFields.push('formUrgentNeed:' + component.get("v.formUrgentNeed", "v.value") + ',');
        formFields.push('formKindredLink:' + component.get("v.formKindredLink", "v.value") + ',');
        formFields.push('formSpecifySN:' + component.get("v.formSpecifySN", "v.value") + ',');
        formFields.push('preferredFacilityNameAddressPhone:' + component.get("v.preferredFacilityNameAddressPhone", "v.value") + ',');
        formFields.push('formLastPhysicianDate:' + component.get("v.formLastPhysicianDate", "v.value") + ',');
        formFields.push('formPhysicianConsent:' + component.get("v.formPhysicianConsent", "v.value") + ',');
        formFields.push('formPhysicianF2F:' + component.get("v.formPhysicianF2F", "v.value") + ',');
        formFields.push('formHomeboundStatus:' + component.get("v.formHomeboundStatus", "v.value") + ',');
        formFields.push('formCurrentHospiceProvider:' + component.get("v.formCurrentHospiceProvider", "v.value") + ',');
        formFields.push('formPatientDestination:' + component.get("v.formPatientDestination", "v.value") + ',');
        formFields.push('formPlannedTravelDates:' + component.get("v.formPlannedTravelDates", "v.value"));
        
        var id = component.get("v.caseID", "v.value");
        var showLTACHForm = component.get("v.showLTACHForm", "v.value"); 
        var showHHForm = component.get("v.showHHForm", "v.value"); 
        var showHPForm = component.get("v.showHPForm", "v.value");  
        var showPHCAForm = component.get("v.showPHCAForm", "v.value");
        
        var url = '/apex/AA_ReferraLFormPDF?formFields=' + formFields + '?showLTACHForm=' + showLTACHForm + '?showHHForm=' + showHHForm + '?showHPForm=' + showHPForm + '?showPHCAForm=' + showPHCAForm;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
        	    "url": url
        	});
        urlEvent.fire();
        },
    
    
})