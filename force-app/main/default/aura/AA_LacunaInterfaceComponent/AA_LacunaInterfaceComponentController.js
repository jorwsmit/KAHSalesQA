({
    
    doInit : function(component, event, helper){
        helper.phoneTypeList(component);
        helper.facilityTypeList(component);
        helper.findLOCList(component);
        helper.findEStatusList(component);
        helper.getLacunaLibrary(component);
        var idCheck = component.get("v.recordId", "v.value");
        console.log('idCheck value: ' + idCheck);
        if(idCheck === '' || idCheck === null || idCheck === undefined){
            console.log('Blank ID');
            helper.startInit(component).then(
                $A.getCallback(function(result){
                    console.log('Creating Case');
                    component.set("v.isEdit", false);
                    return helper.getNewCase(component); 
                })
            )
            .then(
                $A.getCallback(function(result){
                    console.log('Creating new Contact');
                    return helper.getNewContact(component);      
                })
            )
            .then(
                $A.getCallback(function(result){
                    console.log('Creating new Account');
                    return helper.getNewAccount(component);
                })
            )
            .then(
                $A.getCallback(function(result){
            	console.log('Creating new Patient');
            		return helper.getNewPatient(component);
                })
            )
            .then(
            $A.getCallback(function(result){
                    console.log('Creating new Assessment');
                    return helper.getNewAssessment(component, event, helper);
            		})
            	)
            .then(
            $A.getCallback(function(result){
                    console.log('Checking all items are present');
                    return helper.checkServerItems(component, event, helper);
            		})
            	)
            .then(
            $A.getCallback(function(result){
                    console.log('Load default articles');
                	component.set("v.formReady", true);    
                	return helper.findArticles(component, event, helper);
            		})
            	)
            .catch(
                $A.getCallback(function(error){
                    // Something went wrong
                    alert('An error occurred : ' + error.message);
                })
            );
        }
        else{
            console.log('Load existing Case');
            
            helper.startInit(component).then(
                $A.getCallback(function(result){
                    console.log('Fetching Case');
                    component.set("v.isEdit", true);
                    return helper.getCase(component); 
                })
            )
            .then(
                $A.getCallback(function(result){
                    console.log('Checking for Case History');
                    return helper.findNoteHistory(component);      
                })
            )
            .then(
                $A.getCallback(function(result){
                    console.log('Getting Contact');
                    return helper.getContact(component);      
                })
            )
            .then(
                $A.getCallback(function(result){
                    console.log('Checking for Account');
                    return helper.getAccount(component);
                })
            )
            .then(
                $A.getCallback(function(result){
            	console.log('Checking for Patient');
            		return helper.getPatient(component);
                })
            )
            .then(
            $A.getCallback(function(result){
                    console.log('Checking for Assessment');
                    return helper.getAssessment(component, event, helper);
            		})
            	)
            .then(
            $A.getCallback(function(result){
                	console.log('Setting focused label');
                	return helper.setFocusedTabLabel(component, event, helper);
            		})
            	)
            .then(
            $A.getCallback(function(result){
                    console.log('Load default articles');
                    return helper.findArticles(component, event, helper);
            		})
            	)
            .then(
                $A.getCallback(function(result){
                    component.set("v.formReady", true);
                    console.log('Getting any previous phone');
                    return helper.getPhone(component);
            	})
            	)
            .then(
            $A.getCallback(function(result){
                    console.log('Load previous attachments');
                    return helper.showAttachList(component, event, helper);
            		})
            	)
            .then(
            $A.getCallback(function(result){
                    console.log('Refresh Map');
                	var checkPt = component.get("v.activePatient.Postal_Code__c", "v.value");
                	if(checkPt !== null && checkPt !== undefined){
                    	component.set("v.callingObject", "patient");
                		}
                	else{
                    	component.set("v.callingObject", "contact");
                		}
                    return helper.getGeolocation(component, event, helper);
            		})
            	)
            .then(
            $A.getCallback(function(result){
                	return helper.searchNearAccounts(component, event, helper);
            		})
            	)
            .catch(
                $A.getCallback(function(error){
                    console.log('Something went wrong');
                })
            );
        }
    },
    
    hideFormModal : function(component, event, helper){
        component.set("v.showForm", false);
    	},
    
    showLegend : function(component, event, helper){
    	component.set("v.displayLegend", true);
		},
    
    hideLegend : function(component, event, helper){
    	component.set("v.displayLegend", false);
		},
    
    getPhones : function(component, event, helper){
        var proceed = component.get("v.formReady", "v.value");
        if(proceed === true){
        var phoneType = component.find("inputSelectPhoneType").get("v.value");
        console.log('phoneType: ' + phoneType);
        component.set("v.currentPhone", "");
            if(phoneType === 'Phone'){
        		component.set("v.currentPhone", component.get("v.activeContact.Phone","v.value"));        
            	component.set("v.disableExtension", false);
            	}
            else if(phoneType === 'Home Phone'){
        		component.set("v.currentPhone", component.get("v.activeContact.HomePhone","v.value"));        
            	component.set("v.disableExtension", true);
            	}
            else if(phoneType === 'Mobile'){
        		component.set("v.currentPhone", component.get("v.activeContact.MobilePhone","v.value"));        
            	component.set("v.disableExtension", true);
            	}
            else if(phoneType === 'Other'){
        		component.set("v.currentPhone", component.get("v.activeContact.OtherPhone","v.value"));                
            	component.set("v.disableExtension", true);
            	}
        	}
    	},
    
    updatePhones : function(component, event, helper){
        try{
        var phoneType = component.find("inputSelectPhoneType").get("v.value");
        console.log('phoneType: ' + phoneType);
        var phoneNumberString = component.find("cPhone").get("v.value");
        var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
        var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
        if(match !== null){
        	match = '(' + match[1] + ') ' + match[2] + '-' + match[3];
        	}   
        	if(phoneType === 'Phone'){
                component.set("v.activeContact.Phone", match);
            	component.find("cPhone").set("v.value", match);	
            	console.log('Phone: ' + component.get("v.activeContact.Phone", "v.value"));	
            	}
            else if(phoneType === 'Home Phone'){
                component.set("v.activeContact.HomePhone", match);        
            	component.find("cPhone").set("v.value", match);
                console.log('HomePhone: ' + component.get("v.activeContact.HomePhone", "v.value"));
            	}
            else if(phoneType === 'Mobile'){
        		component.set("v.activeContact.MobilePhone", match);
                component.find("cPhone").set("v.value", match);
                console.log('MobilePhone: ' + component.get("v.activeContact.MobilePhone", "v.value"));
            	}
            else if(phoneType === 'Other'){
                component.set("v.activeContact.OtherPhone", match);                
            	component.find("cPhone").set("v.value", match);
                console.log('OtherPhone: ' + component.get("v.activeContact.OtherPhone", "v.value"));
            	}
        }
        catch(err){
            
        }
    	},
    
    hideContentModal : function(component, event, helper){
        component.set("v.showContentModal", false);
    	},
    
    
    hideAccountModal : function(component, event, helper){
        component.set("v.showAccounts", false);
    	},
    
    hideAccountModal2 : function(component, event, helper){
        component.set("v.showFacilityList2", false);
    	},
    
    setFacility : function(component, event, helper){
        var id = event.getSource().get("v.text");
        console.log("id: " + id);
        var name = event.getSource().get("v.name");
        console.log('name: ' + name);
        component.set("v.activeContact.Facility__c", id);
        console.log('Contact Facility: ' + component.get("v.activeContact.Facility__c", "v.value"));
        component.set("v.chosenFacility", name);
        component.set("v.showAccounts", false);
    	},
    
    setFacility2 : function(component, event, helper){
        var id = event.getSource().get("v.text");
        console.log("id: " + id);
        var name = event.getSource().get("v.name");
        console.log('name: ' + name);
        component.set("v.activeAssessment.Preferred_Facility__c", id);
        console.log('Assessment Facility: ' + component.get("v.activeAssessment.Preferred_Facility__c", "v.value"));
        component.set("v.preferredFacilityName", name);
        component.set("v.showFacilityList2", false);
    	},
    
    onFacilityChange : function(component, event, helper){
        var fac = component.find("inputSelectFacility").get("v.value");
        if(fac === '--None--'){
            component.set("v.facilityType", null);
            helper.searchNearAccounts(component);
        	}
        else{
            component.set("v.facilityType", fac);
        	helper.searchNearAccounts(component);
        	}
    	},
    
    readAddressContact : function(component, event, helper){
        var conStreet;
        var conCity;
        var conState;
        var conZip;
        
            try{
                conStreet = component.find("conStreet").get("v.value");
        		component.set("v.activeContact.MailingStreet", conStreet);    
            	}
            catch(errSt){
                
            	}
        	        
            try{
            	conCity = component.find("conCity").get("v.value");
                component.set("v.activeContact.MailingCity", conCity);
            	}
            catch(errCty){
                
            	}
                
            try{
                conState = component.find("conState").get("v.value");
        		component.set("v.activeContact.MailingState", conState);    
            	}
            catch(errSt){
                
            	}
        	        
            try{
            	conZip = component.find("conZip").get("v.value");
                component.set("v.activeContact.MailingPostalCode", conZip);
            	}
            catch(errZip){
                
            	}
            
        console.log('conStreet: ' + conStreet);
        console.log('conCity: ' + conCity);
        console.log('conState: ' + conState);
        console.log('conZip: ' + conZip);
        component.set("v.callingObject", "contact");
        if(conCity !== undefined || conState !== undefined || conZip !== undefined){
        	helper.getGeolocation(component).then(
                	$A.getCallback(function(result){
                    	console.log('Fetching Accounts near Contact');
                    	return helper.searchNearAccounts(component); 
                	})
            		)
            	.catch(
                	$A.getCallback(function(error){
                    	// Something went wrong
                    	alert('An error occurred : ' + error.message);
                	})
            	);
            }
    	},
    
    readAddressPatient : function(component, event, helper){
        var ptStreet;
        var ptCity;
        var ptState;
        var ptZip;
        
            try{
                ptStreet = component.find("ptStreet").get("v.value");
        		component.set("v.activePatient.Street__c", ptStreet);    
            	}
            catch(errSt){
                
            	}
        
            try{
                ptCity = component.find("ptCity").get("v.value");
            	component.set("v.activePatient.City__c", ptCity);
            	}
            catch(errCty){
                
            	}
        
            try{
        		ptState = component.find("ptState").get("v.value");
                component.set("v.activePatient.State__c", ptState);    
            	}
            catch(errSt){
                
            	}
        
            try{
            	ptZip = component.find("ptZip").get("v.value");
                component.set("v.activePatient.Postal_Code__c", ptZip);
            	}
            catch(errZip){
                
            	}
        
        
        console.log('ptStreet: ' + ptStreet);
        console.log('ptCity: ' + ptCity);
        console.log('ptState: ' + ptState);
        console.log('ptZip: ' + ptZip);
        
        if(ptState.length == 2 || ptZip !== undefined){
        	component.set("v.callingObject", "patient");
            helper.getGeolocation(component).then(
                $A.getCallback(function(result){
                    console.log('Fetching Accounts near Patient');
                    return helper.searchNearAccounts(component); 
                })
            	)
            .catch(
                $A.getCallback(function(error){
                    // Something went wrong
                    alert('An error occurred : ' + error.message);
                })
            	);
            }
    	},
    
    readSelection : function (component, event, helper){
        var proceed = component.get("v.formReady", "v.value");
        if(proceed === true){
        var a = event.getSource();
        var id = a.getLocalId();
        var subj = component.find("inputSelectType").get("v.value") + ' - ' + component.find("inputSelectSubType").get("v.value");
        component.set("v.activeCase.Subject", subj);
        var typeSel = component.find("inputSelectSubType").get("v.value");
        console.log('SubType Selection: ' + typeSel);
        	if(typeSel === 'Service Recommendation' || typeSel === 'Service Recommendation w/ Orders'){
            	component.set("v.showPatientInfo", true);
                component.set("v.showPayorInfo", true);
        		}
            else if(typeSel === 'Lead'){
                component.set("v.showPatientInfo", true);
            	}
            else{
            	component.set("v.showPatientInfo", false);
                component.set("v.showPayorInfo", false);
        		}
        	}
        },
    
    evalEmailStatus : function(component, event, helper){
        var eStatus = component.find("inputEmailStatus").get("v.value");
        component.set("v.activeContact.Email_Status__c", eStatus);
        var inputEmail = component.find("inputEmail");
        if(eStatus === 'Valid'){
            inputEmail.set("v.disabled", false);
        }
        else{
            inputEmail.set("v.disabled", true);
        }
    },
    
    showHideWeb : function(component, event, helper){
        var state = component.get("v.showWebInfo");
        if(state === false){
            component.set("v.showWebInfo", true);
        	}
        else{
            component.set("v.showWebInfo", false);
        	}
    	},
    
    copyContactToPatient : function(component, event, helper){
        var lastName = component.find("lName").get("v.value");
        var firstName = component.find("fName").get("v.value");
        var street = component.find("conStreet").get("v.value");
        var city = component.find("conCity").get("v.value");
        var state = component.find("conState").get("v.value");
        var zip = component.find("conZip").get("v.value");
        var email = component.find("inputEmail").get("v.value");
        var phone = component.find("cPhone").get("v.value");
        
        if(lastName !== undefined){
            var edit = component.get("v.isEdit", "v.value");
            if(edit === true){
                component.find("plNameEdit").set("v.value", lastName);
            	}
            else{
            	component.find("plName").set("v.value", lastName);
            	}
            console.log('Copy to Patient LName: ' + lastName);
            component.set("v.patientLastName", lastName);
        	}
        if(firstName !== undefined){
        	component.find("pfName").set("v.value", firstName);
            component.set("v.activePatient.First_Name__c", firstName);    
        	}
        if(street !== undefined){
            component.find("ptStreet").set("v.value", street);
	        component.set("v.activePatient.Street__c", street);
    	    }
        if(city !== undefined){
            component.find("ptCity").set("v.value", city);
        	component.set("v.activePatient.City__c", city);
        	}
        if(state !== undefined){
            component.find("ptState").set("v.value", state);
            component.set("v.activePatient.State__c", state);
        	}
        if(zip !== undefined){
            component.find("ptZip").set("v.value", zip);
            component.set("v.activePatient.Postal_Code__c", zip);
        	}
        if(email !== undefined){
            component.find("pEmail").set("v.value", email);
            component.set("v.activePatient.E_mail__c", email);
        	}
        if(phone !== undefined){
            component.find("pPhone").set("v.value", phone);
            component.set("v.activePatient.Phone__c", phone);
        	}
        
        component.set("v.showPatientInfo", false);
        component.set("v.showPatientInfo", true);
        },
    
    showHidePatient : function(component, event, helper){
        var patient = component.get("v.activePatient.Id", "v.value");
        console.log("patientID present?: " + patient);
        var isEdit = component.get("v.isEdit","v.value");
        
        if((patient === undefined || patient === null) && isEdit === false){
            helper.getNewPatient(component);
        	}
        var state = component.get("v.showPatientInfo");
        if(state === false){
            component.set("v.showPatientInfo", true);
        	}
        else{
            component.set("v.showPatientInfo", false);
        }
    },
    
    showHidePayor : function(component, event, helper){
        var assessment = component.get("v.activeAssessment.Id", "v.value");
        var isEdit = component.get("v.isEdit","v.value");
        console.log("assessmentID present?: " + assessment);
        if((assessment === undefined || assessment === null) && isEdit === false){
            helper.getNewAssessment(component);
        	}
        var state = component.get("v.showPayorInfo");
        if(state === false){
            component.set("v.showPayorInfo", true);
        }
        else{
            component.set("v.showPayorInfo", false);
        }
    },
    
    getAgeCalc : function(component, event, helper){
        helper.calcAge(component);
    	},
    
    writeToPatient : function(component, event, helper){
        try{
        	var fName = component.find("pfName").get("v.value");
        	}
        catch(errFName){
            var fName = component.get("v.activePatient.First_Name__c","v.value");
        	}
        component.set("v.activePatient.First_Name__c", fName);
        
        try{
            var mName = component.find("pfMidName").get("v.value");
        	}
        catch(errMName){
            var mName = component.get("v.activePatient.Middle_Initial__c", "v.value");
        	}
        component.set("v.activePatient.Middle_Initial__c", mName);
        
        try{
            var edit = component.get("v.isEdit", "v.value");
            console.log('Edit?: ' + edit);
            if(edit === true){
                var nameTemp = component.find("plNameEdit").get("v.value");
                console.log('Getting from edit field: ' + nameTemp);    
                }
            else{
        		var nameTemp = component.get("v.patientLastName","v.value");
                console.log('Getting from non-edit field: ' + nameTemp);
            	}
        	}
        catch(errLName){
            var nameTemp = component.get("v.activePatient.Last_Name__c","v.value");
            console.log('Getting from Patient Record: ' + nameTemp);
        	}
        console.log('Name for ptLast: ' + nameTemp);
        if(nameTemp !== 'temp' && nameTemp !== ''){
            component.set("v.activePatient.Last_Name__c", nameTemp);
            component.set("v.patientLastName", nameTemp);
        	}
        
        try{
        	var suff = component.find("pfSufName").get("v.value");
        	}
        catch(errSuff){
            var suff = component.get("v.activePatient.Suffix__c","v.value");
        	}
       		component.set("v.activePatient.Suffix__c", suff);
        
        try{
            var dob = component.find("InputDOB").get("v.value");
            console.log('1st dob check: ' + dob);
            if(dob !== undefined){
                var pattern =/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/;
                var pattern2 =/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})$/;
                  if (dob == null || dob == "" || (!pattern.test(dob) && !pattern2.test(dob))) {
                      console.log('DOB: ' + dob);
                      console.log('Pattern result: ' + pattern.test(dob));
                      alert("Invalid date of birth.  Check entry and retry.  Format should be in: mm/dd/yyyy");
        			}
    			}
        	}
        catch(errDte){
            var dob = component.get("v.activePatient.Date_of_Birth__c", "v.value");
        	console.log('2nd dob check: ' + dob);
            if(dob !== undefined){
                var pattern =/^([0-9]{1,2})\/([0-9]{2})\/([0-9]{4})$/;
                var pattern2 =/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})$/;
                  if (dob == null || dob == "" || (!pattern.test(dob) && !pattern2.test(dob))) {
                      console.log('DOB: ' + dob);
                      console.log('Pattern result: ' + pattern.test(dob));
                      alert("Invalid date of birth.  Check entry and retry.  Format should be in: mm/dd/yyyy");
        			}
    			}
        	}
        
        try{
            var dob = component.find("InputDOB").get("v.value");
        	}
        catch(errAge){
            var dob = component.get("v.activePatient.Date_of_Birth__c", "v.value");
        	}
        
        try{
            var pSex = component.find("pSex").get("v.value");
        	}
        catch(errSex){
            var pSex = component.get("v.activePatient.Sex__c","v.value");
        	}
		component.set("v.activePatient.Sex__c", pSex);
        
        try{
        	var pEmail = component.find("pEmail").get("v.value");
            }
        catch(errEmail){
            var pEmail = component.get("v.activePatient.E_mail__c","v.value");
        	}
		component.set("v.activePatient.E_mail__c", pEmail);
        
        try{
        	var phoneNumberString = component.find("pPhone").get("v.value");
        	}
        catch(errpPhone){
            var phoneNumberString = component.get("v.activePatient.Phone__c","v.value");
        	}
  		var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
  		var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
        if(match != null){
  			match = '(' + match[1] + ') ' + match[2] + '-' + match[3];
        	}
        
		component.set("v.activePatient.Phone__c", match);
        
        try{
           var pSt = component.find("ptStreet").get("v.value");
        	}
        catch(errPSt){
            var pSt = component.get("v.activePatient.Street__c","v.value");
        	}
		component.set("v.activePatient.Street__c", pSt);
		
        try{
            var pCity = component.find("ptCity").get("v.value");
        	}
        catch(errPCity){
            var pCity = component.get("v.activePatient.City__c","v.value");
        	}
        component.set("v.activePatient.City__c", pCity);
		
        try{
            var pState = component.find("ptState").get("v.value");
        	}
        catch(errPState){
            var pState = component.get("v.activePatient.State__c","v.value");
        	}
        component.set("v.activePatient.State__c", pState);
		
        try{
            var pZip = component.find("ptZip").get("v.value");
        	}
        catch(errPZip){
            var pZip = component.get("v.activePatient.Postal_Code__c", "v.value");
        	}
        component.set("v.activePatient.Postal_Code__c", pZip);
		
        try{
            var pStat = component.find("inputPtStatus").get("v.value");
        	}
        catch(errPStat){
            var pStat = component.get("v.activePatient.Status__c","v.value");
        	}
        component.set("v.activePatient.Status__c", pStat);
        
        try{
            var pStatD = component.find("inputPtStatusDetail").get("v.value");
        	}
        catch(errPstatD){
            var pStatD = component.get("v.activePatient.Status_Detail__c","v.value");
        	}
        component.set("v.activePatient.Status_Detail__c", pStatD);
		
        try{
            var ptCon = component.find("inputPtConsent").get("v.value");
        	}
        catch(errPTCon){
            var ptCon = component.get("v.activePatient.Consent_for_Callback__c","v.value");
        	}
        component.set("v.activePatient.Consent_for_Callback__c", ptCon);
		
        try{
            var ptNextC = component.find("pNextCall").get("v.value");
        	}
        catch(errPtNextC){
            var ptNextC = component.get("v.activePatient.Next_Call_Date__c","v.value");
        	}
        component.set("v.activePatient.Next_Call_Date__c", ptNextC);
		
        try{
            var ptLeadD = component.find("pLeadLost").get("v.value");
        	}
        catch(errPtLeadD){
            var ptLeadD = component.get("v.activePatient.Lead_Lost_Date__c", "v.value");
        	}
        component.set("v.activePatient.Lead_Lost_Date__c", ptLeadD);
    	},
    
    searchFacilties: function(component, even, helper){
        helper.getFacilityList(component);
    	},
    
    searchFacilties2: function(component, even, helper){
        helper.getFacilityList2(component);
    	},
    
    writeToAssessment : function(component, event, helper){
            var prefFac = component.get("v.activeAssessment.Preferred_Facility__c"," v.value");
        	
        	component.set("v.activeAssessment.Preferred_Facility__c", prefFac);
        try{
        	var payor = component.get("v.activeAssessment.Payor__c", "v.value");
        	}
        catch(err3){
            var payor = component.get("v.activeAssessment.Payor__c", "v.value");
        	}
		
        if(payor !== undefined){
            try{
        		component.set("v.activeAssessment.Payor__c", component.find("payorName").get("v.value"));
            	}
            catch(err4){
                
            }
            try{
				component.set("v.activeAssessment.Member_ID__c", component.find("payorMemberId").get("v.value"));
            	}
            catch(err5){
                
            }
            try{
            component.set("v.activeAssessment.Subscriber_Name__c", component.find("payorSubscriberName").get("v.value"));    
            }
            catch(err6){
                
            }
            try{
				component.set("v.activeAssessment.Secondary_Payor__c", component.find("payorName2").get("v.value"));
            	}
            catch(err7){
                
            	}
            try{
				component.set("v.activeAssessment.Secondary_Member_ID__c", component.find("payorMemberId2").get("v.value"));
            	}
            catch(err8){
                
            }
            try{
				component.set("v.activeAssessment.Secondary_Subscriber_Name__c", component.find("payorSubscriberName2").get("v.value"));
            	}
            catch(err9){
                
            	}
        	}
		},
    
    setPreferredFac : function(component, event, helper){
        var facID = event.getSource().get("v.text");
        var state = event.getSource().get("v.value");
        var name = event.getSource().get("v.name");
        if(state === true){
        	component.set("v.activeAssessment.Preferred_Facility__c", facID);
            component.set("v.preferredFacilityName", name);
        	}
        else{
            component.set("v.activeAssessment.Preferred_Facility__c", null);
            component.set("v.preferredFacilityName", "");
        	}
    	},
    
    recenterMap : function(component, event, helper){
        var proceed = component.get("v.formReady", "v.value");
        if(proceed === true){
        var map = component.find("mapComponent");
        var loc = event.getSource().get("v.title");
        
        var cityAddr = loc.City;
        var zipAddr = loc.PostalCode;
        var stateAddr = loc.State;
        var streetAddr = loc.Street;
            
        var repList = component.get("v.locationDetails", "v.value");    
        console.log('Resetting Map');
        var mapComponent = component.find('mapComponent');
                        if(mapComponent && mapContainer !== undefined){
                            mapComponent.destroy();
                        	}
                        var mapContainer = component.find('mapContainer');
                        if(mapContainer){
                            mapContainer.set("v.body", "");
                        	}
                        var mapBody = mapContainer.get("v.body");
                        
                        var center = {
                            location:
                            {
                                City: cityAddr,
                                Country: 'USA',
                                PostalCode: zipAddr,
                                State: stateAddr,
                                Street: streetAddr
                            }
                        };
            	
        		if(center !== undefined && repList !== undefined){
                        $A.createComponent(
                            "lightning:map",
                            {
                                "aura:id" : 'mapComponent',
                                "mapMarkers" : repList,
                                "zoomLevel" : 8,
                                "center" : center,
                                "markersTitle" : "Kindred Accounts"
                            },
                            function(lightningMap){
                                mapBody.push(lightningMap);
                                mapContainer.set("v.body", mapBody);
                            }
                        );
        			}
        	}
    	},
    
    saveRecords : function(component,event,helper){
        var proceed = true;
        component.set("v.Spinner", true);
        
        var locListCheck = component.find("accType").get("v.value");
        if(locListCheck.length === 0 || locListCheck === undefined || locListCheck === null || locListCheck === '--None--'){
            proceed = false;
            alert('A level of care must be provided to proceed.  If the case does not directly apply to a service, please select Not Applicable.');
        	}
        
        try{
            var dob = component.find("InputDOB").get("v.value");
            console.log('1st dob check: ' + dob);
            if(dob !== undefined){
                var pattern =/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/;
                var pattern2 =/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})$/;
                  if (dob == null || dob == "" || (!pattern.test(dob) && !pattern2.test(dob))) {
                      console.log('DOB: ' + dob);
                      console.log('Pattern result: ' + pattern.test(dob));
                      alert("Invalid date of birth.  Check entry and retry.  Format should be in: mm/dd/yyyy");
        			proceed = false;
                  	}
    			}
        	}
        catch(errDte){
            var dob = component.get("v.activePatient.Date_of_Birth__c", "v.value");
        	console.log('2nd dob check: ' + dob);
            if(dob !== undefined){
                var pattern =/^([0-9]{1,2})\/([0-9]{2})\/([0-9]{4})$/;
                var pattern2 =/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})$/;
                  if (dob == null || dob == "" || (!pattern.test(dob) && !pattern2.test(dob))) {
                      console.log('DOB: ' + dob);
                      console.log('Pattern result: ' + pattern.test(dob));
                      alert("Invalid date of birth.  Check entry and retry.  Format should be in: mm/dd/yyyy");
        			proceed = false;	
                  }
    			}
        	}
        
        var caseCurrentStatus = component.get("v.activeCase.Status","v.value");
        var editing = component.get("v.isEdit", "v.value");
        
        var cType = component.find('inputSelectType').get("v.value");
        console.log('cType: ' + cType);
        	if(cType.length === 0 || cType === undefined || cType === null || cType === '--None--'){
            	proceed = false;
                alert('Case Type must be provided.');
        		}
        if(editing === true && caseCurrentStatus !== 'Closed'){
        	if(cType === 'Billing' || cType === 'Referral' || cType === 'Complaint' || cType === 'Education'){
            	proceed = false;
                alert('The current Case Type has been retired and a new one must be chosen, please select an option that is not Billing, Referral, Complaint, or Education before proceeding.');
        		}
        	}
        
        var cSType = component.find('inputSelectSubType').get("v.value");
        console.log('cSType: ' + cSType);
        	if(cSType.length === 0 || cSType === undefined || cSType === null || cSType === '--None--'){
            	proceed = false;
                alert('Case Subtype must be provided.');
        		}
        	if(editing === true && caseCurrentStatus !== 'Closed'){
        		if(cSType === 'Clinical' || cSType === 'Non-Clinical'){
            		proceed = false;
                	alert('The current Case Type has been retired and a new one must be chosen, please select an option that is not Clinical or Non-Clinical before proceeding.');
        			}
            	}
        
        var cCType = component.find('inputSelectCallType').get("v.value");
        console.log('cCType: ' + cCType);
        	if(cCType.length === 0 || cCType === undefined || cCType === null || cCType === '--None--'){
            	proceed = false;
                alert('Case Call Type must be provided.');
        		}
        
        var cLastName = component.find('lName').get("v.value");
        console.log('cLastName: ' + cLastName);
        	if(cLastName.length === 0 || cLastName === undefined || cLastName === 'temp' || cLastName === null || cLastName === 'Last Name'){
            	proceed = false;
                alert('Contact Last Name must be provided.');
        		}
        
        var eStatus = component.find("inputEmailStatus").get("v.value");
        var conEmail = component.find("inputEmail").get("v.value");
        if(eStatus === undefined){
            console.log('eStatus Required 1');
            proceed = false;
            alert("Email Status must be selected.");
        	}
        else if(eStatus === '--None--' || eStatus === null || eStatus.length === 0){
            console.log('eStatus Required 2');
            proceed = false;
            alert("Email Status must be selected.");
        	}
        else if(eStatus === 'Valid'){
            if(conEmail === undefined){
                console.log('eStatus Required 3');
                proceed = false;
            	alert("Email must be provided if status is Valid.");
            	}
            else if(conEmail.length === 0 || conEmail === null){
                console.log('eStatus Required 4');
                proceed = false;
                alert("Email must be provided if status is Valid.");
            	}
            }
    	
        
        var typeSel = component.find("inputSelectSubType").get("v.value");
        console.log('Checking Patient Required: ' + typeSel);
        	if(typeSel === 'Service Recommendation' || typeSel === 'Service Recommendation w/ Orders' || typeSel === 'Lead'){
                console.log('Patient Required 1.');
                console.log('LName.');
                try{
            		var lastName = component.find("plName").get("v.value");
                	}
                catch(err){
                    var lastName = component.get("v.activePatient.Last_Name__c","v.value");
                	}
                console.log('Status');
                var ptStatus = component.get("v.activePatient.Status__c","v.value");
                console.log('StatusD');
                var ptStatusD = component.get("v.activePatient.Status_Detail__c","v.value");
                console.log('ptStatus: ' + ptStatus);
                console.log('ptStatusD: ' + ptStatusD);
                if(lastName.length === 0 || lastName === null || lastName === undefined || lastName === 'temp'){
                    proceed = false;
                    	console.log('Patient LName');
                        alert('Patient Last Name must be filled in to proceed when case Subtype is Service Recommendation or Lead.  Check entries.');
                	}
                if(ptStatus.length === 0 || ptStatus === null || ptStatus === undefined || ptStatus === '--None--'){
                    proceed = false;
                    	console.log('Patient Status');	
                        alert('Patient Status must be filled in to proceed when case Subtype is Service Recommendation or Lead.  Check entries.');
                	}
                if(ptStatusD.length === 0 || ptStatusD === null || ptStatusD === undefined || ptStatusD === '--None--'){
                    proceed = false;
                    console.log('Patient Status Detail');	
                        alert('Patient Status Detail must be filled in to proceed when case Subtype is Service Recommendation or Lead.  Check entries.');
                	}
                if(editing === true && caseCurrentStatus !== 'Closed'){
                	if(ptStatusD === 'Deceased' || ptStatusD === 'Active with Competitor' || ptStatusD === 'No Kindred Service in Area'){
                    	proceed = false;
                    	console.log('Patient Status Detail Alt');	
                        alert('The current Patient Status Detail has been retired, please select a new Status Detail that is not Deceased, Active with Competitor, or No Kindred Service in Area before proceeding.');
                		}
                	}
                }
        
        	console.log('Checking Payor Required: ' + typeSel);
        if(typeSel === 'Service Recommendation' || typeSel === 'Service Recommendation w/ Orders'){
                console.log('Payor Required');
            try{
            	var pyName = component.find("payorName").get("v.value");
            	}
            catch(err){
                var pyName = component.get("v.activeAssessment.Payor__c", "v.value");
            	}
            try{
                var pyMember = component.find("payorMemberId").get("v.value");
            	}
            catch(errPyMember){
                var pyMember = component.get("v.activeAssessment.Member_ID__c","v.value");
            	}
            try{
                var pySub = component.find("payorSubscriberName").get("v.value");
            	}
            catch(errPySub){
                var pySub = component.get("v.activeAssessment.Subscriber_Name__c","v.value");
            	}    
            	console.log('Payor Name: ' + pyName);
            	console.log('Payor Member: ' + pyMember);
            	console.log('Payor Subscriber: ' + pySub);
            
            	if(pyName === undefined || pyName === '--None--' || pyName === '' || pyName === null){
                	proceed = false;
                	alert('Payor Name must be filled in to proceed when case Subtype is Service Recommendation.');
                	}
            	else{
                	if(pyMember === undefined && pyName !== 'Non-funded / Uninsured'){
                    	proceed = false;
                    	alert('Member ID must be filled in to proceed when case Subtype is Service Recommendation unless chosen payor is Non-funded / Uninsured.');
                		}
               		else{
                    	component.set("v.activeAssessment.Member_ID__c", pyMember);
                    	}
                if(pySub === undefined && pyName !== 'Non-funded / Uninsured'){
                    proceed = false;
                	alert('Subscriber Name must be filled in to proceed when case Subtype is Service Recommendation unless chosen payor is Non-funded / Uninsured.');
                	}
            		}
                }
        	
        	var consentRequired = component.get("v.activePatient.Status__c", "v.value");
        	console.log('Checking Consent Required: ' + consentRequired);
        
        	if((consentRequired === 'Lead' || consentRequired === 'Pending')){
                console.log('Consent Required');
            	var callback = component.get("v.activePatient.Consent_for_Callback__c","v.value");
                if(callback === undefined){
                    proceed = false;
                    alert('Consent for Callback must be selected if Patient Status is Lead or Pending.');
                	}
                else{
                	if(callback.length === 0 || callback === null || callback === '--None--'){
                    	proceed = false;
                        alert('Consent for Callback must be selected if Patient Status is Lead or Pending.');
                    	}
                	}
                }
        
        console.log('Proceed to save? ' + proceed);
        if(proceed === true){
        component.set("v.Spinner", true);
            try{
            	var pt = component.find("plName").get("v.value");
            	}
            catch(err){
            	var pt = component.get("v.activePatient.Last_Name__c", "v.value");
            	}
            
        var assess = component.get("v.activeAssessment.Payor__c", "v.value");
        
        //Case
        console.log('Submitting Case Set');
        component.set("v.activeCase.Type", component.find("inputSelectType").get("v.value"));
		component.set("v.activeCase.Subtype__c", component.find("inputSelectSubType").get("v.value"));
		component.set("v.activeCase.Call_Type__c", component.find("inputSelectCallType").get("v.value"));
		var subj = component.find("inputSelectType").get("v.value") + ' - ' + component.find("inputSelectSubType").get("v.value");
        component.set("v.activeCase.Subject", subj);
            if(component.get("v.isEdit","v.value") === false){
        		component.set("v.activeCase.Status", 'New');
            	}
            else{
                try{
                	var caseStat = component.find("caseStatus").get("v.value");
                	}
                catch(errCaseStat){
                    var caseStat = component.get("v.activeCase.Status","v.value");
                	}
                	component.set("v.activeCase.Status", caseStat);
            	}
		component.set("v.activeCase.Case_Source__c", component.find("caseSource").get("v.value"));
		component.set("v.activeCase.Origin", component.find("caseOrigin").get("v.value"));
		component.set("v.activeCase.Case_Notes__c", component.find("caseDescription").get("v.value"));
        component.set("v.activeCase.Account", component.get("v.activeAccount.Id", "v.value"));
        component.set("v.activeCase.Contact", component.get("v.activeContact.Id", "v.value"));
        var loc = component.find("accType").get("v.value");
        if(loc !== '--None--'){    
        	component.set("v.activeCase.Level_Of_Care__c", loc);
            component.set("v.activeContact.Level_of_Care__c", loc);
        	}
        if(assess !== null && assess !== undefined){
            if(assess.length > 1){
        		component.set("v.activeCase.Assessment__c", component.get("v.activeAssessment.Id", "v.value"));
            	}
        	}
        if(pt !== null && pt !== undefined && pt !== 'temp'){
        	component.set("v.activeCase.Patient_New__c", component.get("v.activePatient.Id", "v.value"));
            component.set("v.activePatient.Last_Name__c", pt);
            try{
            	var fname = component.find("pfName").get("v.value");
                }
            catch(err){
                var fname = component.get("v.activePatient.First_Name__c","v.value");    
                }    
            }
        
        //Contact
        console.log('Submitting Contact Set');
        component.set("v.activeContact.FirstName", component.find("fName").get("v.value"));
		component.set("v.activeContact.LastName", component.find("lName").get("v.value"));
        var phoneType = component.find("inputSelectPhoneType").get("v.value");	
            if(phoneType === 'Phone'){
        		component.set("v.activeContact.Phone", component.find("cPhone").get("v.value"));        
            	}
            else if(phoneType === 'Home Phone'){
        		component.set("v.activeContact.HomePhone", component.find("cPhone").get("v.value"));        
            	}
            else if(phoneType === 'Mobile'){
        		component.set("v.activeContact.MobilePhone", component.find("cPhone").get("v.value"));        
            	}
            else if(phoneType === 'Other'){
        		component.set("v.activeContact.OtherPhone", component.find("cPhone").get("v.value"));        
            	}
        component.set("v.activeContact.Extension__c", component.find("phoneExt").get("v.value"));
        component.set("v.activeContact.MailingStreet", component.find("conStreet").get("v.value"));
		component.set("v.activeContact.MailingCity", component.find("conCity").get("v.value"));
		component.set("v.activeContact.MailingState", component.find("conState").get("v.value"));
		component.set("v.activeContact.MailingPostalCode", component.find("conZip").get("v.value"));
		component.set("v.activeContact.Email_Status__c", component.find("inputEmailStatus").get("v.value"));
		component.set("v.activeContact.Email", component.find("inputEmail").get("v.value"));
            
        component.set("v.activeContact.Account", component.get("v.activeAccount.Id", "v.value"));
        
        //Account
        console.log('Submitting Account Set');
        component.set("v.activeAccount.Type", component.find("accType").get("v.value"));
        
        console.log("pt and assess: " + pt + ", " + assess);
        if(pt !== null && pt !== undefined && pt !== 'temp'){
            //Patient
            console.log('Submitting Patient Set');
            try{
                var edit = component.get("v.isEdit", "v.value");
                if(edit === true){
                	var lastName = component.find("plNameEdit").get("v.value");    
                	}
                else{
            		var lastName = component.find("plName").get("v.value");
                	}
                }
            catch(err){
                var lastName = component.get("v.activePatient.Last_Name__c","v.value");
            	}
            try{
        		var firstName = component.find("pfName").get("v.value");
            	}
            catch(err2){
                var firstName = component.get("v.activePatient.First_Name__c","v.value");
            	}
            try{
        		var street = component.find("ptStreet").get("v.value");
            	}
            catch(err3){
                var street = component.get("v.activePatient.Street__c","v.value");
            	}
            try{
        		var city = component.find("ptCity").get("v.value");
            	}
            catch(err4){
                var city = component.get("v.activePatient.City__c","v.value");
            	}
            try{
        		var state = component.find("ptState").get("v.value");
            	}
            catch(err5){
                var state = component.get("v.activePatient.State__c","v.value");
            	}
            try{
        		var zip = component.find("ptZip").get("v.value");
            	}
            catch(err6){
                var zip = component.get("v.activePatient.Postal_Code__c","v.value");
            	}
            try{
        		var email = component.find("pEmail").get("v.value");
            	}
            catch(err7){
                var email = component.get("v.activePatient.E_mail__c","v.value");
            	}
            try{
        		var phone = component.find("pPhone").get("v.value");
                var cleaned = ('' + phone).replace(/\D/g, '');
  				var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
                if(match !== null){
					match = '(' + match[1] + ') ' + match[2] + '-' + match[3];
                	component.set("v.activePatient.Phone__c", match);
                	}
            	}
            catch(err8){
                var phone = component.get("v.activePatient.Phone__c","v.value");
                var cleaned = ('' + phone).replace(/\D/g, '');
  				var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
                if(match != null){
					match = '(' + match[1] + ') ' + match[2] + '-' + match[3];
                	component.set("v.activePatient.Phone__c",match);
                	}
                }
            try{
        		var age = component.get("v.patientAge","v.value");
            	}
            catch(err9){
                console.log('Age Problem');
            	var age = component.get("v.activePatient.Age__c","v.value");
            	}
            component.set("v.activePatient.Age__c",age);
            try{
                var status = component.find("inputPtStatus").get("v.value");
            	}
            catch(err10){
                var status = component.get('v.activePatient.Status__c');
            	}
            try{
                var statusD = component.find("inputPtStatusDetail").get("v.value");
            	}
            catch(err11){
                var statusD = component.get('v.activePatient.Status_Detail__c');
            	}
            
            console.log('ptFNamepro: ' + firstName);
            console.log('ptlNamepro: ' + lastName);
            	
        if(lastName !== undefined){
        	component.set("v.activePatient.Last_Name__c", lastName);    
        	}
        if(firstName !== undefined){
            component.set("v.activePatient.First_Name__c", firstName);    
        	}
        if(street !== undefined){
	        component.set("v.activePatient.Street__c", street);
    	    }
        if(city !== undefined){
        	component.set("v.activePatient.City__c", city);
        	}
        if(state !== undefined){
            component.set("v.activePatient.State__c", state);
        	}
        if(zip !== undefined){
            component.set("v.activePatient.Postal_Code__c", zip);
        	}
        if(email !== undefined){
            component.set("v.activePatient.E_mail__c", email);
        	}
        if(phone !== undefined){
            component.set("v.activePatient.Phone__c", phone);
        	}
        if(age !== undefined){
            component.set("v.activePatient.Age__c", age);
        	}    
        if(status === '--None--'){
                component.set("v.activePatient.Status__c", null);
            }
        if(statusD === '--None--'){
                component.set("v.activePatient.Status_Detail__c", null);
            }    
            
            
            if(firstName === undefined || firstName === null){
                	firstName = "";
            		component.set("v.activeAccount.Name", "The Household of " + lastName);	
            		}
            	else{
            		component.set("v.activeAccount.Name", "The Household of " + firstName + ' ' + lastName);
            		}
            }
        else{
           	var lNameC = component.get("v.activeContact.LastName", "v.value");
           	var fNameC = component.get("v.activeContact.FirstName", "v.value");
           	if(fNameC === undefined || fNameC === null){
               	fNameC = "";
           		component.set("v.activeAccount.Name", "The Household of " + lNameC);	
           		}
           	else{
           		component.set("v.activeAccount.Name", "The Household of " + fNameC + ' ' + lNameC);
           		}
        	}
        if(assess !== null && assess !== undefined){
            if(assess.length > 1){
            console.log('Submitting Assessment Set');
            component.set("v.activeAssessment.Patient__c", component.get("v.activePatient.Id", "v.value"));
            
            var prefFac = component.get("v.activeAssessment.Preferred_Facility__c", "v.value");
            component.set("v.activeAssessment.Preferred_Facility__c", prefFac);
            
            try{
        		var payor = component.get("v.activeAssessment.Payor__c", "v.value");
        		}
        	catch(err3){
            	var payor = component.get("v.activeAssessment.Payor__c", "v.value");
        		}
		
        	if(payor !== undefined){
            	component.set("v.activeAssessment.Payor__c", payor);
            	
            	try{
					var memID = component.find("payorMemberId").get("v.value");
            		}
            	catch(err5){
                	var memID = component.get("v.activeAssessment.Member_ID__c","v.value");
            		}
                component.set("v.activeAssessment.Member_ID__c", memID);
                
            	try{
            		var subName = component.find("payorSubscriberName").get("v.value");
                    }
            	catch(err6){
	                var subName = component.get("v.activeAssessment.Subscriber_Name__c", "v.value");
    	        	}
        			component.set("v.activeAssessment.Subscriber_Name__c", subName);
                
            	try{
                    var payor2 = component.find("payorName2").get("v.value");
					}
            	catch(err7){
                	var payor2 = component.get("v.activeAssessment.Secondary_Payor__c","v.value");
            		}
                component.set("v.activeAssessment.Secondary_Payor__c", payor2);
                
            	try{
					var memID2 = component.find("payorMemberId2").get("v.value");
                	}
            	catch(err8){
                	var memID2 = component.get("v.activeAssessment.Secondary_Member_ID__c","v.value");
            		}
                component.set("v.activeAssessment.Secondary_Member_ID__c", memID2);
                              
            	try{
                    var sub2 = component.find("payorSubscriberName2").get("v.value");
					}
            	catch(err9){
                	var sub2 = component.get("v.activeAssessment.Secondary_Subscriber_Name__c","v.value");
            		}
                	component.set("v.activeAssessment.Secondary_Subscriber_Name__c", sub2);
        		}
            	}
            }
        	helper.submitItemsForSave(component);
    		}
        else{
            component.set("v.Spinner", false);
        	}
        },
    
    saveClose : function(component,event,helper) {
        var proceed = true;
        component.set("v.Spinner", true);
        
        var locListCheck = component.find("accType").get("v.value");
        if(locListCheck.length === 0 || locListCheck === undefined || locListCheck === null || locListCheck === '--None--'){
            proceed = false;
            alert('A level of care must be provided to proceed.  If the case does not directly apply to a service, please select Not Applicable.');
        	}
        
        try{
            var dob = component.find("InputDOB").get("v.value");
            console.log('1st dob check: ' + dob);
            if(dob !== undefined){
                var pattern =/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/;
                var pattern2 =/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})$/;
                  if (dob == null || dob == "" || (!pattern.test(dob) && !pattern2.test(dob))) {
                      console.log('DOB: ' + dob);
                      console.log('Pattern result: ' + pattern.test(dob));
                      alert("Invalid date of birth.  Check entry and retry.  Format should be in: mm/dd/yyyy");
        			proceed = false;
                  	}
    			}
        	}
        catch(errDte){
            var dob = component.get("v.activePatient.Date_of_Birth__c", "v.value");
        	console.log('2nd dob check: ' + dob);
            if(dob !== undefined){
                var pattern =/^([0-9]{1,2})\/([0-9]{2})\/([0-9]{4})$/;
                var pattern2 =/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})$/;
                  if (dob == null || dob == "" || (!pattern.test(dob) && !pattern2.test(dob))) {
                      console.log('DOB: ' + dob);
                      console.log('Pattern result: ' + pattern.test(dob));
                      alert("Invalid date of birth.  Check entry and retry.  Format should be in: mm/dd/yyyy");
        			proceed = false;	
                  }
    			}
        	}
        
        var caseCurrentStatus = component.get("v.activeCase.Status","v.value");
        var editing = component.get("v.isEdit", "v.value");
        
        var cType = component.find('inputSelectType').get("v.value");
        console.log('cType: ' + cType);
        	if(cType.length === 0 || cType === undefined || cType === null || cType === '--None--'){
            	proceed = false;
                alert('Case Type must be provided.');
        		}
        if(editing === true && caseCurrentStatus !== 'Closed'){
        	if(cType === 'Billing' || cType === 'Referral' || cType === 'Complaint' || cType === 'Education'){
            	proceed = false;
                alert('The current Case Type has been retired and a new one must be chosen, please select an option that is not Billing, Referral, Complaint, or Education before proceeding.');
        		}
        	}
        
        var cSType = component.find('inputSelectSubType').get("v.value");
        console.log('cSType: ' + cSType);
        	if(cSType.length === 0 || cSType === undefined || cSType === null || cSType === '--None--'){
            	proceed = false;
                alert('Case Subtype must be provided.');
        		}
        	if(editing === true && caseCurrentStatus !== 'Closed'){
        		if(cSType === 'Clinical' || cSType === 'Non-Clinical'){
            		proceed = false;
                	alert('The current Case Type has been retired and a new one must be chosen, please select an option that is not Clinical or Non-Clinical before proceeding.');
        			}
            	}
        
        var cCType = component.find('inputSelectCallType').get("v.value");
        console.log('cCType: ' + cCType);
        	if(cCType.length === 0 || cCType === undefined || cCType === null || cCType === '--None--'){
            	proceed = false;
                alert('Case Call Type must be provided.');
        		}
        
        var cLastName = component.find('lName').get("v.value");
        console.log('cLastName: ' + cLastName);
        	if(cLastName.length === 0 || cLastName === undefined || cLastName === 'temp' || cLastName === null || cLastName === 'Last Name'){
            	proceed = false;
                alert('Contact Last Name must be provided.');
        		}
        
        var eStatus = component.find("inputEmailStatus").get("v.value");
        var conEmail = component.find("inputEmail").get("v.value");
        if(eStatus === undefined){
            console.log('eStatus Required 1');
            proceed = false;
            alert("Email Status must be selected.");
        	}
        else if(eStatus === '--None--' || eStatus === null || eStatus.length === 0){
            console.log('eStatus Required 2');
            proceed = false;
            alert("Email Status must be selected.");
        	}
        else if(eStatus === 'Valid'){
            if(conEmail === undefined){
                console.log('eStatus Required 3');
                proceed = false;
            	alert("Email must be provided if status is Valid.");
            	}
            else if(conEmail.length === 0 || conEmail === null){
                console.log('eStatus Required 4');
                proceed = false;
                alert("Email must be provided if status is Valid.");
            	}
            }
    	
        
        var typeSel = component.find("inputSelectSubType").get("v.value");
        console.log('Checking Patient Required: ' + typeSel);
        	if(typeSel === 'Service Recommendation' || typeSel === 'Service Recommendation w/ Orders' || typeSel === 'Lead'){
                console.log('Patient Required 1.');
                console.log('LName.');
                try{
            		var lastName = component.find("plName").get("v.value");
                	}
                catch(err){
                    var lastName = component.get("v.activePatient.Last_Name__c","v.value");
                	}
                console.log('Status');
                var ptStatus = component.get("v.activePatient.Status__c","v.value");
                console.log('StatusD');
                var ptStatusD = component.get("v.activePatient.Status_Detail__c","v.value");
                console.log('ptStatus: ' + ptStatus);
                console.log('ptStatusD: ' + ptStatusD);
                if(lastName.length === 0 || lastName === null || lastName === undefined || lastName === 'temp'){
                    proceed = false;
                    	console.log('Patient LName');
                        alert('Patient Last Name must be filled in to proceed when case Subtype is Service Recommendation or Lead.  Check entries.');
                	}
                if(ptStatus.length === 0 || ptStatus === null || ptStatus === undefined || ptStatus === '--None--'){
                    proceed = false;
                    	console.log('Patient Status');	
                        alert('Patient Status must be filled in to proceed when case Subtype is Service Recommendation or Lead.  Check entries.');
                	}
                if(ptStatusD.length === 0 || ptStatusD === null || ptStatusD === undefined || ptStatusD === '--None--'){
                    proceed = false;
                    console.log('Patient Status Detail');	
                        alert('Patient Status Detail must be filled in to proceed when case Subtype is Service Recommendation  or Lead.  Check entries.');
                	}
                if(editing === true && caseCurrentStatus !== 'Closed'){
                	if(ptStatusD === 'Deceased' || ptStatusD === 'Active with Competitor' || ptStatusD === 'No Kindred Service in Area'){
                    	proceed = false;
                    	console.log('Patient Status Detail Alt');	
                        alert('The current Patient Status Detail has been retired, please select a new Status Detail that is not Deceased, Active with Competitor, or No Kindred Service in Area before proceeding.');
                		}
                	}
                }
        
        	console.log('Checking Payor Required: ' + typeSel);
        if(typeSel === 'Service Recommendation' || typeSel === 'Service Recommendation w/ Orders'){
                console.log('Payor Required');
            try{
            	var pyName = component.find("payorName").get("v.value");
            	}
            catch(err){
                var pyName = component.get("v.activeAssessment.Payor__c", "v.value");
            	}
            try{
                var pyMember = component.find("payorMemberId").get("v.value");
            	}
            catch(errPyMember){
                var pyMember = component.get("v.activeAssessment.Member_ID__c","v.value");
            	}
            try{
                var pySub = component.find("payorSubscriberName").get("v.value");
            	}
            catch(errPySub){
                var pySub = component.get("v.activeAssessment.Subscriber_Name__c","v.value");
            	}    
            	console.log('Payor Name: ' + pyName);
            	console.log('Payor Member: ' + pyMember);
            	console.log('Payor Subscriber: ' + pySub);
            
            	if(pyName === undefined || pyName === '--None--' || pyName === '' || pyName === null){
                	proceed = false;
                	alert('Payor Name must be filled in to proceed when case Subtype is Service Recommendation.');
                	}
            	else{
                	if(pyMember === undefined && pyName !== 'Non-funded / Uninsured'){
                    	proceed = false;
                    	alert('Member ID must be filled in to proceed when case Subtype is Service Recommendation unless chosen payor is Non-funded / Uninsured.');
                		}
               		else{
                    	component.set("v.activeAssessment.Member_ID__c", pyMember);
                    	}
                if(pySub === undefined && pyName !== 'Non-funded / Uninsured'){
                    proceed = false;
                	alert('Subscriber Name must be filled in to proceed when case Subtype is Service Recommendation unless chosen payor is Non-funded / Uninsured.');
                	}
            		}
                }
        	
        	var consentRequired = component.get("v.activePatient.Status__c", "v.value");
        	console.log('Checking Consent Required: ' + consentRequired);
        
        	if((consentRequired === 'Lead' || consentRequired === 'Pending')){
                console.log('Consent Required');
            	var callback = component.get("v.activePatient.Consent_for_Callback__c","v.value");
                if(callback === undefined){
                    proceed = false;
                    alert('Consent for Callback must be selected if Patient Status is Lead or Pending.');
                	}
                else{
                	if(callback.length === 0 || callback === null || callback === '--None--'){
                    	proceed = false;
                        alert('Consent for Callback must be selected if Patient Status is Lead or Pending.');
                    	}
                	}
                }
        
        console.log('Proceed to save? ' + proceed);
        if(proceed === true){
        
            try{
            	var pt = component.find("plName").get("v.value");
            	}
            catch(err){
            	var pt = component.get("v.activePatient.Last_Name__c", "v.value");
            	}
            
        var assess = component.get("v.activeAssessment.Payor__c", "v.value");
        
        //Case
        console.log('Submitting Case Set');
        component.set("v.activeCase.Type", component.find("inputSelectType").get("v.value"));
		component.set("v.activeCase.Subtype__c", component.find("inputSelectSubType").get("v.value"));
		component.set("v.activeCase.Call_Type__c", component.find("inputSelectCallType").get("v.value"));
		var subj = component.find("inputSelectType").get("v.value") + ' - ' + component.find("inputSelectSubType").get("v.value");
        component.set("v.activeCase.Subject", subj);
        component.set("v.activeCase.Status", 'Closed');
        component.set("v.activeCase.Case_Source__c", component.find("caseSource").get("v.value"));
		component.set("v.activeCase.Origin", component.find("caseOrigin").get("v.value"));
		component.set("v.activeCase.Case_Notes__c", component.find("caseDescription").get("v.value"));
        component.set("v.activeCase.Account", component.get("v.activeAccount.Id", "v.value"));
        component.set("v.activeCase.Contact", component.get("v.activeContact.Id", "v.value"));
        var loc = component.find("accType").get("v.value");
        if(loc !== '--None--'){    
        	component.set("v.activeCase.Level_Of_Care__c", loc);
            component.set("v.activeContact.Level_of_Care__c", loc);
        	}
        if(assess !== null && assess !== undefined){
        	if(assess.length > 1){
        		component.set("v.activeCase.Assessment__c", component.get("v.activeAssessment.Id", "v.value"));
            	}
        	}
        if(pt !== null && pt !== undefined && pt !== 'temp'){
        	component.set("v.activeCase.Patient_New__c", component.get("v.activePatient.Id", "v.value"));
            component.set("v.activePatient.Last_Name__c", pt);
            try{
            	var fname = component.find("pfName").get("v.value");
                }
            catch(err){
                var fname = component.get("v.activePatient.First_Name__c","v.value");    
                }    
            }
        
        //Contact
        console.log('Submitting Contact Set');
        component.set("v.activeContact.FirstName", component.find("fName").get("v.value"));
		component.set("v.activeContact.LastName", component.find("lName").get("v.value"));
        var phoneType = component.find("inputSelectPhoneType").get("v.value");	
            if(phoneType === 'Phone'){
        		component.set("v.activeContact.Phone", component.find("cPhone").get("v.value"));        
            	}
            else if(phoneType === 'Home Phone'){
        		component.set("v.activeContact.HomePhone", component.find("cPhone").get("v.value"));        
            	}
            else if(phoneType === 'Mobile'){
        		component.set("v.activeContact.MobilePhone", component.find("cPhone").get("v.value"));        
            	}
            else if(phoneType === 'Other'){
        		component.set("v.activeContact.OtherPhone", component.find("cPhone").get("v.value"));        
            	}
        component.set("v.activeContact.Extension__c", component.find("phoneExt").get("v.value"));
        component.set("v.activeContact.MailingStreet", component.find("conStreet").get("v.value"));
		component.set("v.activeContact.MailingCity", component.find("conCity").get("v.value"));
		component.set("v.activeContact.MailingState", component.find("conState").get("v.value"));
		component.set("v.activeContact.MailingPostalCode", component.find("conZip").get("v.value"));
		component.set("v.activeContact.Email_Status__c", component.find("inputEmailStatus").get("v.value"));
		component.set("v.activeContact.Email", component.find("inputEmail").get("v.value"));
            
        component.set("v.activeContact.Account", component.get("v.activeAccount.Id", "v.value"));
        
        //Account
        console.log('Submitting Account Set');
        component.set("v.activeAccount.Type", component.find("accType").get("v.value"));
        
        console.log("pt and assess: " + pt + ", " + assess);
        if(pt !== null && pt !== undefined && pt !== 'temp'){
            //Patient
            console.log('Submitting Patient Set');
            try{
            	var edit = component.get("v.isEdit", "v.value");
                if(edit === true){
                	var lastName = component.find("plNameEdit").get("v.value");    
                	}
                else{
            		var lastName = component.find("plName").get("v.value");
                	}
                }
            catch(err){
                var lastName = component.get("v.activePatient.Last_Name__c","v.value");
            	}
            try{
        		var firstName = component.find("pfName").get("v.value");
            	}
            catch(err2){
                var firstName = component.get("v.activePatient.First_Name__c","v.value");
            	}
            try{
        		var street = component.find("ptStreet").get("v.value");
            	}
            catch(err3){
                var street = component.get("v.activePatient.Street__c","v.value");
            	}
            try{
        		var city = component.find("ptCity").get("v.value");
            	}
            catch(err4){
                var city = component.get("v.activePatient.City__c","v.value");
            	}
            try{
        		var state = component.find("ptState").get("v.value");
            	}
            catch(err5){
                var state = component.get("v.activePatient.State__c","v.value");
            	}
            try{
        		var zip = component.find("ptZip").get("v.value");
            	}
            catch(err6){
                var zip = component.get("v.activePatient.Postal_Code__c","v.value");
            	}
            try{
        		var email = component.find("pEmail").get("v.value");
            	}
            catch(err7){
                var email = component.get("v.activePatient.E_mail__c","v.value");
            	}
            try{
        		var phone = component.find("pPhone").get("v.value");
                var cleaned = ('' + phone).replace(/\D/g, '');
  				var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
                if(match !== null){
					match = '(' + match[1] + ') ' + match[2] + '-' + match[3];
                	component.set("v.activePatient.Phone__c", match);
                	}
            	}
            catch(err8){
                var phone = component.get("v.activePatient.Phone__c","v.value");
                var cleaned = ('' + phone).replace(/\D/g, '');
  				var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
                if(match != null){
					match = '(' + match[1] + ') ' + match[2] + '-' + match[3];
                	component.set("v.activePatient.Phone__c",match);
                	}
                }
            try{
        		var age = component.get("v.patientAge","v.value");
            	}
            catch(err9){
                console.log('Age Problem');
            	var age = component.get("v.activePatient.Age__c","v.value");
            	}
            component.set("v.activePatient.Age__c",age);
            try{
                var status = component.find("inputPtStatus").get("v.value");
            	}
            catch(err10){
                var status = component.get('v.activePatient.Status__c');
            	}
            try{
                var statusD = component.find("inputPtStatusDetail").get("v.value");
            	}
            catch(err11){
                var statusD = component.get('v.activePatient.Status_Detail__c');
            	}
            
            console.log('ptFNamepro: ' + firstName);
            console.log('ptlNamepro: ' + lastName);
            	
        if(lastName !== undefined){
        	component.set("v.activePatient.Last_Name__c", lastName);    
        	}
        if(firstName !== undefined){
            component.set("v.activePatient.First_Name__c", firstName);    
        	}
        if(street !== undefined){
	        component.set("v.activePatient.Street__c", street);
    	    }
        if(city !== undefined){
        	component.set("v.activePatient.City__c", city);
        	}
        if(state !== undefined){
            component.set("v.activePatient.State__c", state);
        	}
        if(zip !== undefined){
            component.set("v.activePatient.Postal_Code__c", zip);
        	}
        if(email !== undefined){
            component.set("v.activePatient.E_mail__c", email);
        	}
        if(phone !== undefined){
            component.set("v.activePatient.Phone__c", phone);
        	}
        if(age !== undefined){
            component.set("v.activePatient.Age__c", age);
        	}    
        if(status === '--None--'){
                component.set("v.activePatient.Status__c", null);
            }
        if(statusD === '--None--'){
                component.set("v.activePatient.Status_Detail__c", null);
            }    
            
            
            if(firstName === undefined || firstName === null){
                	firstName = "";
            		component.set("v.activeAccount.Name", "The Household of " + lastName);	
            		}
            	else{
            		component.set("v.activeAccount.Name", "The Household of " + firstName + ' ' + lastName);
            		}
            }
        else{
           	var lNameC = component.get("v.activeContact.LastName", "v.value");
           	var fNameC = component.get("v.activeContact.FirstName", "v.value");
           	if(fNameC === undefined || fNameC === null){
               	fNameC = "";
           		component.set("v.activeAccount.Name", "The Household of " + lNameC);	
           		}
           	else{
           		component.set("v.activeAccount.Name", "The Household of " + fNameC + ' ' + lNameC);
           		}
        	}
        if(assess !== null && assess !== undefined){
            if(assess.length > 1){
            console.log('Submitting Assessment Set');
            component.set("v.activeAssessment.Patient__c", component.get("v.activePatient.Id", "v.value"));
            
            var prefFac = component.get("v.activeAssessment.Preferred_Facility__c", "v.value");
            component.set("v.activeAssessment.Preferred_Facility__c", prefFac);
            
            try{
        		var payor = component.get("v.activeAssessment.Payor__c", "v.value");
        		}
        	catch(err3){
            	var payor = component.get("v.activeAssessment.Payor__c", "v.value");
        		}
		
        	if(payor !== undefined){
            	component.set("v.activeAssessment.Payor__c", payor);
            	
            	try{
					var memID = component.find("payorMemberId").get("v.value");
            		}
            	catch(err5){
                	var memID = component.get("v.activeAssessment.Member_ID__c","v.value");
            		}
                component.set("v.activeAssessment.Member_ID__c", memID);
                
            	try{
            		var subName = component.find("payorSubscriberName").get("v.value");
                    }
            	catch(err6){
	                var subName = component.get("v.activeAssessment.Subscriber_Name__c", "v.value");
    	        	}
        			component.set("v.activeAssessment.Subscriber_Name__c", subName);
                
            	try{
                    var payor2 = component.find("payorName2").get("v.value");
					}
            	catch(err7){
                	var payor2 = component.get("v.activeAssessment.Secondary_Payor__c","v.value");
            		}
                component.set("v.activeAssessment.Secondary_Payor__c", payor2);
                
            	try{
					var memID2 = component.find("payorMemberId2").get("v.value");
                	}
            	catch(err8){
                	var memID2 = component.get("v.activeAssessment.Secondary_Member_ID__c","v.value");
            		}
                component.set("v.activeAssessment.Secondary_Member_ID__c", memID2);
                              
            	try{
                    var sub2 = component.find("payorSubscriberName2").get("v.value");
					}
            	catch(err9){
                	var sub2 = component.get("v.activeAssessment.Secondary_Subscriber_Name__c","v.value");
            		}
                	component.set("v.activeAssessment.Secondary_Subscriber_Name__c", sub2);
        		}
            	}
            }
        	helper.submitItemsForSave(component);
    		}
        else{
            component.set("v.Spinner", false);
        	}
        },
    
    writeToAccount : function (component, event, helper){
        var loc = component.find("accType").get("v.value");
        if(loc !== '--None--'){
        	component.set('v.activeAccount.Type', loc);
        	component.set('v.activeCase.Level_Of_Care__c', loc);
            }
    	},
    
    cancelCase : function(component, event, helper){
        component.set("v.Spinner", true);
        var caseType = component.get("v.activeCase.RecordTypeId", "v.value");
        console.log("case recordType: " + caseType);
        if(caseType === '012c0000000253IAAQ' || caseType === '012c0000000253I' || caseType === '0121B000001RZAJQA4' || caseType === '0121B000001RZAJ'){
           	helper.cancelTheCase(component);
        	}
        else{
        	helper.cancelAndReturn(component);
        	}
        component.set("v.Spinner", false);
    	},
    
    getContent : function(component, event, helper){
        component.set("v.showModalSearch", true);
        helper.getSelectedContent(component);
        },
    
    filterArticles : function(component, event, helper){
    	var arType = event.getSource().get("v.name");
        if(arType === 'Kindred'){
            component.find("allKnowledgeBase").set("v.value", false);
            component.find("gentivaKnowledgeBase").set("v.value", false);
        	}
        else if(arType === 'Gentiva'){
            component.find("allKnowledgeBase").set("v.value", false);
            component.find("kindredKnowledgeBase").set("v.value", false);
        	}
        else if(arType === 'All'){
            component.find("gentivaKnowledgeBase").set("v.value", false);
            component.find("kindredKnowledgeBase").set("v.value", false);
        	}
        console.log('Radio Value: ' + arType);
        component.set("v.articleTypeFilter", arType);
		helper.findArticles(component);
    	},
    
    searchArticles : function(component, event, helper){
    	helper.findArticles(component);
		},
    
    handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        helper.showAttachList(component);
        alert("Files uploaded");
    	},
    
    openKnowledge : function(component, event, helper){
        helper.openArticleItem(component, event, helper);
    	},
    
    openLibrary : function(component, event, helper){
        helper.openLibraryItem(component, event, helper);
    	},
})