({
   	searchNearAccounts : function(component, event, helper){		
        component.set("v.locationDetails", null);		
        var streetAddr;		
        var cityAddr;		
        var stateAddr;		
        var zipAddr;		
        var geolocation;		
        var accType = component.get("v.facilityType", "v.value");		
        console.log('Chosen facility type: ' + accType);		
        var initialProcess = component.get("v.callingObject", "v.value");		
        console.log("callingObject for Markers: " + initialProcess);		
        if(initialProcess === 'contact'){		
            streetAddr = component.find("conStreet").get("v.value");		
            cityAddr = component.find("conCity").get("v.value");		
            stateAddr = component.find("conState").get("v.value");		
            zipAddr = component.find("conZip").get("v.value");		
            geolocation = component.get("v.contactGeo", "v.value");		
        	}		
        else if(initialProcess === 'patient'){		
            streetAddr = component.find("ptStreet").get("v.value");		
            cityAddr = component.find("ptCity").get("v.value");		
            stateAddr = component.find("ptState").get("v.value");		
            zipAddr = component.find("ptZip").get("v.value");		
            geolocation = component.get("v.patientGeo", "v.value");		
        	}		
            else{		
                console.log('Other uh-oh');    		
            	}		
        		
        console.log('streetAddr: ' + streetAddr);		
        console.log('cityAddr: ' + cityAddr);		
        console.log('stateAddr: ' + stateAddr);		
        console.log('zipAddr: ' + zipAddr);		
        console.log('geolocation: ' + geolocation);		
        if(geolocation !== undefined){		
            var action = component.get("c.getNearByAccounts");		
            return new Promise(function(resolve, reject){		
                action.setParams({		
                    "city" : cityAddr,		
                    "state" : stateAddr,		
                    "zipCode" : zipAddr,		
                    "loc" : geolocation,		
                    "accType" : accType		
                });		
                action.setCallback(this, function(a){		
                    var response = a.getReturnValue();		
                    var state = a.getState();		
                    console.log('Populate Account Markers',state);		
                    if(component.isValid() && state !== "SUCCESS"){		
                        console.log("Error in fetching Account Markers.");		
                        return;		
                    }		
                    else{		
                        try{		
                        var repList = response;		
                            if(response !== null && response !== undefined){		
                        component.set("v.locationDetails", repList);		
                        var mapComponent = component.find('mapComponent');		
                        if(mapComponent && mapContainer !== undefined){		
                            mapComponent.destroy();		
                        	}		
                        var mapContainer = component.find('mapContainer');		
                        if(mapContainer){		
                            mapContainer.set("v.body", "");		
                        }		
                        var mapBody = mapContainer.get("v.body");		
                        		
                            var center;		
                            if(cityAddr !== undefined && zipAddr !== undefined && stateAddr !== undefined && stateAddr.length === 2){		
                                if(streetAddr === undefined){		
                                    streetAddr = '123 St';		
                                	}
                                console.log('Center with address');
                                center = {		
                            		location:		
                            				{		
                                			City: cityAddr,		
                                			Country: 'USA',		
                                			PostalCode: zipAddr,		
                                			State: stateAddr,		
                                			Street: streetAddr		
                            				}		
                                		};		
                            	}		
                            else{
                                console.log('Center from geolocation');
                                console.log('lat: ' + parseFloat(geolocation.split(",")[0]));		
                                console.log('lng: ' + parseFloat(geolocation.split(",")[1]));		
                                center = 		
                                    	{
                                    	'lat': parseFloat(geolocation.split(",")[0]), 
                                    	'lng': parseFloat(geolocation.split(",")[1])
                                		}	
                            	}		
                                console.log('Map center: Lat:' + center.lat + ' Lng:' + center.lng);		
                            if(center != null && center != undefined){    		
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
                        component.set("v.facilitySelectLocked", false);		
                        		
                        var listTemp = [];		
                        listTemp.push('--Make a Selection--');		
                                		
                        for(var i = 0; i < response.length; i++){		
                            if(response[i].contentCount > 0){		
                                listTemp.push(response[i].title + ' - ' + response[i].accId);		
                            	}		
                        	}		
                        component.set("v.selAccounts", listTemp);		
                        if(listTemp.length > 0){		
                            component.set("v.allowContentSearch", true);		
                        	}		
                        else{		
                            component.set("v.allowContentSearch", false);		
                        	}		
                        }		
                        }		
                        }		
                        catch(err){		
                            return;		
                        }		
                        resolve("Resolved");		
                    }		
                });		
                $A.enqueueAction(action);		
            });		
        }		
    },
    
    startInit : function(component, event, helper){
        return new Promise(function(resolve, reject){
            console.log("Start initialization");
            resolve("Resolved");
        });
    },
    
    getPhone : function(component, event, helper){
        try{
        	var phone =  component.get("v.activeContact.Phone", "v.value");
        	component.set("v.currentPhone", phone);	
        	}
        catch(errPhone){
            
        	}
        },
    
    getLacunaLibrary : function(component, event, helper){
        var action = component.get("c.getLacunaFileList");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            	}
            else{
                var repList = response;
                component.set("v.lacunaFileList", repList);
            	}
        	});
        $A.enqueueAction(action);
    	},
    
    findEStatusList : function(component, event, helper){
        var action = component.get("c.getEmailStatusList");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            	}
            else{
                var repList = response;
                component.set("v.eStatusList", repList);
            	}
        	});
        $A.enqueueAction(action);
   		},
    
    findLOCList : function(component, event, helper){
        var action = component.get("c.getLOCList");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            	}
            else{
                var repList = response;
                component.set("v.locList", repList);
            	}
        	});
        $A.enqueueAction(action);
    	},
    
    getFacilityList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.facilityList", null);
    	var action = component.get("c.searchFacilities");
    	action.setParams({
            "searchString" : component.get("v.chosenFacility", "v.value")
        	});
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Case',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching facility list.");
                    }
                else{
                    var repList = response;
                    component.set("v.facilityList", repList);
                    component.set("v.showAccounts", true);
                    component.set("v.Spinner", false);
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
		},
    
    getFacilityList2 : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.facilityList2", null);
    	var action = component.get("c.searchFacilities");
    	action.setParams({
            "searchString" : component.get("v.preferredFacilityName", "v.value")
        	});
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Case Facilities',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching facility list.");
                    }
                else{
                    var repList = response;
                    component.set("v.facilityList2", repList);
                    component.set("v.showFacilityList2", true);
                    component.set("v.Spinner", false);
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
		},
    
    setFocusedTabLabel : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var caseNum = component.get("v.activeCase.CaseNumber", "v.value");
        var label = "Edit " + caseNum
        return new Promise(function(resolve, reject){
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: label
            });
             resolve("Resolved");
        })
        .catch(function(error) {
            console.log(error);
        });
            });
    },
    
    phoneTypeList : function(component, event, helper){
        var action = component.get("c.getPhoneTypeList");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            }
            else{
                var repList = response;
                component.set("v.phoneOptions", repList);
            }
        });
        $A.enqueueAction(action);
    },
    
    facilityTypeList : function(component, event, helper){
        var action = component.get("c.getFacilityTypeList");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            }
            else{
                var repList = response;
                component.set("v.facilityTypeList", repList);
            }
        });
        $A.enqueueAction(action);
    },
    
    getNewCase : function(component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        var action = component.get("c.getNewServerCase");
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Case',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching/creating case.");
                    more.getNewCase(component);
                    //action.setCallback(this, function(action){                
           			//		$A.get('e.force:refreshView').fire(); 
        			//	}); 
        			$A.enqueueAction(action);
                    }
                else{
                    var repList = response;
                    component.set("v.activeCase", repList);
                    component.set("v.activeCase.LastName", " ");
                    console.log('activeCase: ' + component.get("v.activeCase"));
                    component.set("v.attachParentId", component.get("v.activeCase.Id", "v.value"));
                    console.log('attachParent ID: ' + component.get("v.attachParentId", "v.value"));
                    component.set("v.Spinner", false);
                    resolve("Resolved");
                	}
            	});
            	$A.enqueueAction(action);
        	});
    	},
    
    getCase : function(component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        var action = component.get("c.getExistingCase");
        action.setParams({
            "recordId" : component.get("v.recordId", "v.value")
        });
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Case',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching case.");
                    more.getCase(component);
                    }
                else{
                    var repList = response;
                    component.set("v.activeCase", repList);
                    console.log('activeCase: ' + component.get("v.activeCase"));
                    component.set("v.attachParentId", component.get("v.activeCase.Id", "v.value"));
                    try{
                    	var loc = component.get("v.activeCase.Level_Of_Care__c", "v.value");
                    	if(loc !== undefined && loc !== null){
                        	component.find("accType").set("v.value",loc);
                    		}
                    	}
                    catch(errLoc){
                        
                    	}
                    
                    try{
                        var desc = component.get("v.activeCase.Description", "v.value");
                        if (desc !== undefined && desc !== null){
                            component.find("caseDescription").set("v.value", desc);
                            component.set("v.activeCase.Case_Notes__c", desc);
                        	}
                    	}
                    catch(errDesc){
                        
                    	}
                    
                    console.log('attachParent ID: ' + component.get("v.attachParentId", "v.value"));
                    component.set("v.Spinner", false);
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    getNewContact : function(component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        var action = component.get("c.getNewServerContact");
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Contact',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in creating Contact.");
                    more.getNewContact(component);
                	}
                else{
                    var repList = response;
                    component.set("v.activeContact", repList);
                    console.log('activeContact: ' + component.get("v.activeContact"));
                    if(component.get("v.activeContact") === undefined || component.get("v.activeContact") === null){
                        more.getNewContact(component);
                    	}
                    else{
                        var street = component.get("v.activeContact.MailingStreet", "v.value");
                        var city = component.get("v.activeContact.MailingCity", "v.value");
                    	var state = component.get("v.activeContact.MailingState", "v.value");
                    	var phone = component.get("v.activeContact.Phone", "v.value");
                    	var email = component.get("v.activeContact.Email", "v.value");
                    	var zip = component.get("v.activeContact.MailingPostalCode", "v.value");
                    	var firstName = component.get("v.activeContact.FirstName", "v.value");
                    	var lastName = component.get("v.activeContact.LastName", "v.value");
                    	console.log('firstNameContactNew: ' + firstName);
                    	console.log('lastNameContactNew: ' + lastName);    
                    
                        var streetCase = component.get("v.activeCase.Web_Street_Address__c", "v.value");
                    	var cityCase = component.get("v.activeCase.Web_City__c", "v.value");
                    	var stateCase = component.get("v.activeCase.Web_State__c", "v.value");
                    	var phoneCase = component.get("v.activeCase.SuppliedPhone", "v.value");
                    	var emailCase = component.get("v.activeCase.SuppliedEmail", "v.value");
                    	var zipCase = component.get("v.activeCase.Web_Zip_Code__c", "v.value");
                    	var firstNameCase = component.get("v.activeCase.Web_First_Name__c", "v.value");
                    	var lastNameCase = component.get("v.activeCase.Web_Last_Name__c", "v.value");
                    	console.log('firstNameCaseNew: ' + firstNameCase);
                    	console.log('lastNameCaseNew: ' + lastNameCase);
                    
                    if((street === undefined || street === null) && (streetCase !== undefined && streetCase !== null)){
                        component.set("v.activeContact.MailingStreet", streetCase);
                    	}
                    if((city === undefined || city === null) && (cityCase !== undefined && cityCase !== null)){
                        component.set("v.activeContact.MailingCity", cityCase);
                    	}
                    if((state === undefined || state === null) && (stateCase !== undefined && stateCase !== null)){
                        component.set("v.activeContact.MailingState", stateCase);
                    	}
                    if((phone === undefined || phone === null) && (phoneCase !== undefined  && phoneCase !== null)){
                        component.set("v.activeContact.Phone", phoneCase);
                        component.set("v.currentPhone", phoneCase);
                    	}
                    if((email === undefined || email === null) && (emailCase !== undefined && emailCase !== null)){
                        component.set("v.activeContact.Email", emailCase);
                    	}
                    if((zip === undefined || zip === null) && (zipCase !== undefined && zipCase !== null)){
                        component.set("v.activeContact.MailingPostalCode", zipCase);
                    	}
                    if((firstName === undefined || firstName === null) && (firstNameCase !== undefined && firstNameCase !== null)){
                        component.set("v.activeContact.FirstName", firstNameCase);
                    	}
                    if((lastName === undefined || lastName === null || lastName === 'Last Name') && (lastNameCase !== undefined && lastNameCase !== null)){
                        component.set("v.activeContact.LastName", lastNameCase);
                    	}
                    	component.set("v.activeCase.ContactId", component.get("v.activeContact.Id", "v.value"));
                    	component.set("v.Spinner", false);
                    	resolve("Resolved");
                    	}
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    getContact : function(component, event, helper){
        component.set("v.Spinner", true);
        console.log('case contactID: ' + component.get("v.activeCase.ContactId","v.value"));
        var more = this;
        var action = component.get("c.getExistingContact");
        return new Promise(function(resolve, reject){
            action.setParams({
                "activeCase" : component.get("v.activeCase")
            });
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Contact',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching Contact.");
                    return;
                	}
                else{
                    var repList = response;
                    component.set("v.activeContact", repList);
                     if(component.get("v.activeContact") === undefined || component.get("v.activeContact") === null){
                        more.getNewContact(component);
                    	}
                    else{
                        if(component.get("v.activeContact", "v.value") !== null && component.get("v.activeContact") !== undefined){
                    		var street = component.get("v.activeContact.MailingStreet", "v.value");
                            var city = component.get("v.activeContact.MailingCity", "v.value");
                    		var state = component.get("v.activeContact.MailingState", "v.value");
                    var phone = component.get("v.activeContact.Phone", "v.value");
                            console.log('Contact Phone: ' + phone);
                    var email = component.get("v.activeContact.Email", "v.value");
                    var zip = component.get("v.activeContact.MailingPostalCode", "v.value");
                    var firstName = component.get("v.activeContact.FirstName", "v.value");
                    var lastName = component.get("v.activeContact.LastName", "v.value");
                        console.log('firstNameContactExisting: ' + firstName);
                        console.log('lastNameContactExisting: ' + lastName);    
                    
                    var facility = component.get("v.activeContact.Facility__r.Name", "v.value");        
                    
                            if(facility !== undefined && facility !== null){
                                component.set("v.chosenFacility", facility);
                            	}        
                    
                    var streetCase = component.get("v.activeCase.Web_Street_Address__c", "v.value");
                    var cityCase = component.get("v.activeCase.Web_City__c", "v.value");
                    var stateCase = component.get("v.activeCase.Web_State__c", "v.value");
                    var phoneCase = component.get("v.activeCase.SuppliedPhone", "v.value");
                    var emailCase = component.get("v.activeCase.SuppliedEmail", "v.value");
                    var zipCase = component.get("v.activeCase.Web_Zip_Code__c", "v.value");
                    var firstNameCase = component.get("v.activeCase.Web_First_Name__c", "v.value");
                    var lastNameCase = component.get("v.activeCase.Web_Last_Name__c", "v.value");
                        console.log('firstNameCaseExisting: ' + firstNameCase);
                        console.log('lastNameCaseExisting: ' + lastNameCase);
                    try{
                        var eStatus = component.get("v.activeContact.Email_Status__c","v.value");
            			if(eStatus !== undefined && eStatus !== null){
            				component.find("inputEmailStatus").set("v.value", eStatus);    
                			}
                			}
        			catch(err){
                                
                   				}
                    
                    if((street === undefined || street === null) && (streetCase !== undefined && streetCase !== null)){
                        component.set("v.activeContact.MailingStreet", streetCase);
                    	}
                    if((city === undefined || city === null) && (cityCase !== undefined && cityCase !== null)){
                        component.set("v.activeContact.MailingCity", cityCase);
                    	}
                    if((state === undefined || state === null) && (stateCase !== undefined && stateCase !== null)){
                        component.set("v.activeContact.MailingState", stateCase);
                    	}
                    if((phone === undefined || phone === null) && (phoneCase !== undefined  && phoneCase !== null)){
                        component.set("v.activeContact.Phone", phoneCase);
                        component.set("v.currentPhone", phoneCase);
                    	}
                    if((email === undefined || email === null) && (emailCase !== undefined && emailCase !== null)){
                        component.set("v.activeContact.Email", emailCase);
                    	}
                    if((zip === undefined || zip === null) && (zipCase !== undefined && zipCase !== null)){
                        component.set("v.activeContact.MailingPostalCode", zipCase);
                    	}
                    if((firstName === undefined || firstName === null) && (firstNameCase !== undefined && firstNameCase !== null)){
                        component.set("v.activeContact.FirstName", firstNameCase);
                    	}
                    if((lastName === undefined || lastName === null || lastName === 'Last Name') && (lastNameCase !== undefined && lastNameCase !== null && lastNameCase !== 'Last Name')){
                        component.set("v.activeContact.LastName", lastNameCase);
                    	}    
                    	}
                    	component.set("v.activeCase.ContactId", component.get("v.activeContact.Id", "v.value"));
                        more.evalEmailStatus(component);
                    	component.set("v.Spinner", false);
                    	resolve("Resolved");
                    	}
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    getNewAccount : function(component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        var action = component.get("c.getNewServerAccount");
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Account',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in creating Account.");
                    more.getNewAccount(component);
                }
                else{
                    var repList = response;
                    component.set("v.activeAccount", repList);
                    if(component.get("v.activeAccount") === undefined || component.get("v.activeAccount") === null){
                        more.getNewAccount(component);
                    	}
                    else{
                    	console.log("New Account: " + component.get("v.activeAccount"));
                    	component.set("v.activeCase.AccountId", component.get("v.activeAccount.Id", "v.value"));
                    	component.set("v.Spinner", false);
                    	resolve("Resolved");
                    	}
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    getAccount : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getExistingAccount");
        return new Promise(function(resolve, reject){
            action.setParams({
                "activeCase" : component.get("v.activeCase"),
                "activeContact" : component.get("v.activeContact")
            });
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Account',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching Account.");
                    return;
                }
                else{
                    var repList = response;
                    component.set("v.activeAccount", repList);
                    console.log('activeAccount: ' + component.get("v.activeAccount"));
                    component.set("v.activeCase.AccountId", component.get("v.activeAccount.Id", "v.value"));
                    component.set("v.Spinner", false);
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    getNewPatient : function(component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        var action = component.get("c.getNewServerPatient");
        return new Promise(function(resolve, reject){
            action.setParams({
                "activeContact" : component.get("v.activeContact")
            });
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Patient',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching/creating Patient.");
                    more.getNewPatient(component);
                }
                else{
                    var repList = response;
                    component.set("v.activePatient", repList);
                    if(component.get("v.activePatient") === undefined || component.get("v.activePatient") === null){
                        more.getNewPatient(component);
                    	}
                    else{
                    	console.log('activePatient: ' + component.get("v.activePatient.Id", "v.value"));
                    	component.set("v.showPatientInfo", false);
                    	component.set("v.activePatient.Status__c", "--None--");
                    	component.set("v.activePatient.Status_Detail__c", "--None--");
                    	component.set("v.Spinner", false);
                    	resolve("Resolved");
                    	}
                	}
            	});
            $A.enqueueAction(action);
        });
    },
    
    getPatient : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getServerPatient");
        return new Promise(function(resolve, reject){
            action.setParams({
                "activeCase" : component.get("v.activeCase")
            });
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Patient',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching/creating Patient.");
                    return;
                }
                else{
                    var repList = response;
                    component.set("v.activePatient", repList);
                    console.log('activePatient: ' + component.get("v.activePatient.Id", "v.value"));
                    component.set("v.showPatientInfo", true);
                    var lastName = component.get("v.activePatient.Last_Name__c","v.value");
        			var firstName = component.get("v.activePatient.First_Name__c","v.value");
        			var street = component.get("v.activePatient.Street__c","v.value");
        			var city = component.get("v.activePatient.City__c","v.value");
        			var state = component.get("v.activePatient.State__c","v.value");
        			var zip = component.get("v.activePatient.Postal_Code__c","v.value");
        			var email = component.get("v.activePatient.E_mail__c","v.value");
        			var phone = component.get("v.activePatient.Phone__c","v.value");
                    var age = component.get("v.activePatient.Age__c","v.value");
                    console.log('Patient Age: ' + age);
                    var edit = component.get("v.isEdit", "v.value");
                    
                    if(edit === true){            
        				if(lastName !== undefined && lastName !== 'temp'){
            				component.find("plNameEdit").set("v.value", lastName);
        					}
                    	}
        if(lastName === 'temp'){
            component.set("v.showPatientInfo", false);
            }            
        if(firstName !== undefined){
        	component.find("pfName").set("v.value", firstName);
            }
        if(street !== undefined){
            component.find("ptStreet").set("v.value", street);
	        }
        if(city !== undefined){
            component.find("ptCity").set("v.value", city);
        	}
        if(state !== undefined){
            component.find("ptState").set("v.value", state);
            }
        if(zip !== undefined){
            component.find("ptZip").set("v.value", zip);
            }
        if(email !== undefined){
            component.find("pEmail").set("v.value", email);
            }
        if(phone !== undefined){
            component.find("pPhone").set("v.value", phone);
            }
        if(age !== undefined){
            component.set("v.patientAge", age);
            }
                    component.set("v.Spinner", false);
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    getNewAssessment : function(component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        console.log('activePatient for Assessment: ' + component.get("v.activePatient.Id"));
        var action = component.get("c.getNewServerAssessment");
        return new Promise(function(resolve, reject){
            action.setParams({
                "activePatient" : component.get("v.activePatient")
            });
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Assessment',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching/creating Assessment.");
                    more.getNewAssessment(component);
                }
                else{
                    var repList = response;
                    component.set("v.activeAssessment", repList);
                    if(component.get("v.activeAssessment") === undefined){
                        more.getNewAssessment(component);
                    	}
                    else{
                    	console.log('activeAssessment create: ' + component.get("v.activeAssessment.Id", "v.value"));
                    	component.set("v.showPayorInfo", false);
                    	component.set("v.Spinner", false);
                    	resolve("Resolved");
                    	}
                	}
            });
            $A.enqueueAction(action);
        });
    },
    
    getAssessment : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getExistingAssessment");
        return new Promise(function(resolve, reject){
            action.setParams({
                "activePatient" : component.get("v.activePatient")
            });
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Assessment',state);
                if(component.isValid() && state !== "SUCCESS"){
                    component.set("v.Spinner", false);
                    console.log("Error in fetching/creating Assessment.");
                    return;
                	}
                else{
                    var repList = response;
                    component.set("v.activeAssessment", repList);
                    console.log('activeAssessment get: ' + component.get("v.activeAssessment.Id", "v.value"));
                    try{
                    	var payorName = component.get("v.activeAssessment.Payor__c", "v.value");
                        
                        if(payorName !== undefined && payorName.length > 1){
                        	component.set("v.showPayorInfo", true);
                            }
                    	else{
                    		component.set("v.showPayorInfo", false);
                    		}
                    	}
                    catch(errStart){
                        component.set("v.showPayorInfo", false);
                    	}
                    try{
                    	var prefFac = component.get("v.activeAssessment.Preferred_Facility__c","v.value");
                    	}
                    catch(err){
                        
                        }
                    if(prefFac !== null && prefFac !== undefined){
                        component.set("v.preferredFacilityName", component.get("v.activeAssessment.Preferred_Facility__r.Name","v.value"));
                    	}
                    try{
                      	var payName = component.get("v.activeAssessment.Payor__c", "v.value");  
                    	}
                    catch(err2){
                        
                    }
                    try{
                       var memID = component.get("v.activeAssessment.Member_ID__c", "v.value"); 
                    }
                    catch(err3){
                        var subName = component.get("v.activeAssessment.Subscriber_Name__c", "v.value");
                    	}
                    try{
                        var payName2 = component.get("v.activeAssessment.Secondary_Payor__c", "v.value");
                    }
                    catch(err4){
                        
                    }
                    try{
                        var memID2 = component.get("v.activeAssessment.Secondary_Member_ID__c", "v.value");
                    }
                    catch(err5){
                      var subName2 = component.get("v.activeAssessment.Secondary_Subscriber_Name__c", "v.value");  
                    }
                    
                    component.set("v.Spinner", false);
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    findNoteHistory : function(component, event, helper){
        var action = component.get("c.getNoteHistory");
        return new Promise(function(resolve, reject){
            action.setParams({
                "id" : component.get("v.activeCase.Id")
            });
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Case History',state);
                if(component.isValid() && state !== "SUCCESS"){
                    console.log("Error in fetching case history.");
                    return;
                	}
                else{
                    var repList = response;
                    component.set("v.caseHistory", repList);
                    console.log('caseHistory: ' + component.get("v.caseHistory"));
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    getGeolocation : function(component, event, helper){
        var streetAddr;
        var cityAddr;
        var stateAddr;
        var zipAddr;
        
        var initialProcess = component.get("v.callingObject");
        
        if(initialProcess === 'contact'){
            streetAddr = component.find("conStreet").get("v.value");
            cityAddr = component.find("conCity").get("v.value");
            stateAddr = component.find("conState").get("v.value");
            zipAddr = component.find("conZip").get("v.value");
        	}
        else if(initialProcess === 'patient'){
            streetAddr = component.find("ptStreet").get("v.value");
            cityAddr = component.find("ptCity").get("v.value");
            stateAddr = component.find("ptState").get("v.value");
            zipAddr = component.find("ptZip").get("v.value");
        	}
        else{
            console.log('Whu-oh');    
            }
        
        console.log('streetAddr: ' + streetAddr);
        console.log('cityAddr: ' + cityAddr);
        console.log('stateAddr: ' + stateAddr);
        console.log('zipAddr: ' + zipAddr);
        
            var action = component.get("c.getGeocode");
            return new Promise(function(resolve, reject){
                action.setParams({
                    "streetAddr" : streetAddr,
                    "cityAddr" : cityAddr,
                    "stateAddr" : stateAddr,
                    "zipAddr" : zipAddr
                });
                action.setCallback(this, function(a){
                    var response = a.getReturnValue();
                    var state = a.getState();
                    console.log('Populate Geocode',state);
                    if(component.isValid() && state !== "SUCCESS"){
                        console.log("Error in fetching Geocode.");
                        return;
                    }
                    else{
                        var repList = response;
                        if(initialProcess === 'contact'){
                            component.set("v.contactGeo", repList);
                            console.log('contactGeo: ' + component.get("v.contactGeo", "v.value"));
                        }
                        else if(initialProcess === 'patient'){
                            component.set("v.patientGeo", repList);
                            console.log('patientGeo: ' + component.get("v.patientGeo", "v.value"));
                        }
                            else{
                                console.log('Uh-oh');
                            }
                        resolve("Resolved");
                    }
                });
                $A.enqueueAction(action);
            });
    	},
    
    calcAge : function(component, event, helper){
    	var action = component.get("c.getServerAge");
        return new Promise(function(resolve, reject){
            action.setParams({
                "birthDate" : component.get("v.activePatient.Date_of_Birth__c","v.value")
            	});
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Populate Assessment History',state);
                if(component.isValid() && state !== "SUCCESS"){
                    console.log("Error in fetching Assessment history.");
                    return;
                	}
                else{
                    var repList = response;
                    component.set("v.patientAge", repList);
                    resolve("Resolved");
                }
            });
            $A.enqueueAction(action);
        });
		},
    
    getSelectedContent : function(component, event, helper){
        component.set("v.fileList", null);
        console.log('contentAccount2: ' + component.find("inputSelectAccount").get("v.value"));
        var action = component.get("c.retreiveFacilityContent");
        action.setParams({
            "selectedAccount" : component.find("inputSelectAccount").get("v.value")
        	});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            console.log('Populate Account Content',state);
            if(component.isValid() && state !== "SUCCESS"){
                console.log("Error in fetching Account Content.");
                return;
            	}
            else{
                var repList = response;
                component.set("v.fileList", repList);
                component.set("v.showContentModal", true);
            	}
        });
        $A.enqueueAction(action);
    	},
    
    cancelTheCase : function(component, event, helper){
        var action = component.get("c.processCancelCase");
        component.set("v.Spinner", true);
        action.setParams({
            "activeCase" : component.get("v.activeCase"),
            "activeContact" : component.get("v.activeContact"),
            "activeAccount" : component.get("v.activeAccount"),
            "activePatient" : component.get("v.activePatient"),
            "activeAssessment" : component.get("v.activeAssessment"),
        	});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            console.log('Cancel Case',state);
            if(component.isValid() && state !== "SUCCESS"){
                console.log("Error in Cancelling Case.");
                component.set("v.Spinner", false);
                return;
            	}
            else{
                var repList = response;
                if(repList === 'Success'){
                    component.set("v.Spinner", false);
                    var ltng = component.get("v.isLEX", "v.value");
                    if(ltng === true){
                	var navService = component.find("navService");
        			// Sets the route to /lightning/o/Case/home
        			var pageReference = {
            		type: 'standard__objectPage',
            		attributes: {
                				objectApiName: 'Case',
                				actionName: 'home'
            					}
        				};
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
            				var focusedTabId = response.tabId;
            				component.set("v.pageReference", pageReference);
        					navService.navigate(pageReference);
                            workspaceAPI.closeTab({tabId: focusedTabId});
        					})
                        .catch(function(error) {
            			console.log(error);
        				});
                        }
                    else{
                        window.location.href =  '/lightning/o/Case/list?filterName=Recent&0.source=alohaHeader';
                    	} 
                    }
                else{
                    alert("There was an issue in the process.  Please let the administrator know: " + repList);
                	}
            	}
        });
        $A.enqueueAction(action);
    	},
    
    cancelAndReturn : function(component, event, helper){
        component.set("v.Spinner", true);
    	var action = component.get("c.cancelReturn");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            console.log('Cancel Case',state);
            if(component.isValid() && state !== "SUCCESS"){
                console.log("Error in Cancelling items.");
                component.set("v.Spinner", false);
                return;
            }
            else{
                var repList = response;
                if(repList === 'Success'){	
                    component.set("v.Spinner", false);
        		var ltng = component.get("v.isLEX", "v.value");
                    if(ltng === true){
                        var navService = component.find("navService");
        				var pageReference = {
            			type: 'standard__recordPage',
            				attributes: {
                						actionName: 'view',
                						objectApiName: 'Case',
                						recordId : component.get("v.activeCase.Id", "v.value") 
            							},
        					};
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
            				var focusedTabId = response.tabId;
            				component.set("v.pageReference", pageReference);
        					navService.navigate(pageReference);
                            workspaceAPI.closeTab({tabId: focusedTabId});
        					})
                        .catch(function(error) {
            			console.log(error);
        				});
                        }
                    else{
                        var recId = component.get("v.activeCase.Id", "v.value");
                        window.location.href =  '/'+ recId ;
                    	}
                	}
            	}
                });
        $A.enqueueAction(action);
		},
    
    submitItemsForSave : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.processSaveItems");
        action.setParams({
            "activeCase" : component.get("v.activeCase"),
            "activeContact" : component.get("v.activeContact"),
            "activeAccount" : component.get("v.activeAccount"),
            "activePatient" : component.get("v.activePatient"),
            "activeAssessment" : component.get("v.activeAssessment"),
        	});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            console.log('Save Case',state);
            if(component.isValid() && state !== "SUCCESS"){
                console.log("Error in Saving items.");
                component.set("v.Spinner", false);
                var repList = response;
                alert("Unspecified error, check entry fields and try again.");
                return;
            }
            else{
                var repList = response;
                var recordId = component.get("v.activeCase.Id", "v.value");
                var focusedTabId;
                if(repList === 'Success'){
                    component.set("v.Spinner", false);
                	var ltng = component.get("v.isLEX", "v.value");
                    if(ltng === true){
                    	var navService = component.find("navService");
        				var pageReference = {
            			type: 'standard__recordPage',
            				attributes: {
                						actionName: 'view',
                						objectApiName: 'Case',
                						recordId : component.get("v.activeCase.Id", "v.value") 
            							},
        					};
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
            				focusedTabId = response.tabId;
            				})
                        workspaceAPI.openTab({
            				url: '/lightning/r/Case/' + recordId + '/view',
            				label: 'View Case'
        					}).then(function(response){
            				workspaceAPI.focusTab({tabId : response});
                            workspaceAPI.closeTab({tabId: focusedTabId});
       						})
                        .catch(function(error) {
            			console.log(error);
        				});
                        }
                    else{
                        var recId = component.get("v.activeCase.Id", "v.value");
                        window.location.href =  '/'+ recId ;
                    	}
                    }
                else{
                    alert("There was an issue in the process.  Please let the administrator know: " + repList);
                	}
            	}
        });
        $A.enqueueAction(action);
    	},
    
    findArticles : function(component, event, helper){
        component.set("v.articleList", null);
        console.log('Finding Articles');
        var action = component.get("c.filterKnowledgeArticles");
        action.setParams({
            "articleSearchString" : component.get("v.articleSearchString","v.value"), 
            "articleTypeFilter" : component.get("v.articleTypeFilter", "v.value") 
            });
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                console.log("Error in fetching Article List.");
                return;
            	}
            else{
                var repList = response;
                console.log("Success in fetching Article List.");
                component.set("v.articleList", repList);
                resolve("Resolved");
                }
        });
        $A.enqueueAction(action);
        });
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
    
    showAttachList : function(component, event, helper){
        component.set("v.attachmentItems", null);
        var action = component.get("c.getAttachments");
        return new Promise(function(resolve, reject){
            action.setParams({
                "parentId" : component.get("v.activeCase.Id", "v.value"),
            	});
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Finding Attachment list: ',state);
                if(component.isValid() && state !== "SUCCESS"){
                    console.log("Error in fetching file list.");
                    return;
                	}
                else{
                    var repList = response;
                    console.log("Success in fetching file list.");
                	component.set("v.attachmentItems", repList);
                    resolve("Resolved");
            		}
            	});
            $A.enqueueAction(action);
        	});
    	},
    
    openArticleItem : function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        var tabID;
        console.log('Starting Navigation');
            var id = event.getSource().get("v.title");
            var navService = component.find("navService");
            var pageReference = {
            			type: 'standard__recordPage',
            				attributes: {
                						actionName: 'view',
                						objectApiName: 'Contact_Center_kav',
                						recordId : id 
            							},
        					};
            workspaceAPI.getFocusedTabInfo().then(function(response) {
            				var focusedTabId = response.tabId;
            				component.set("v.pageReference", pageReference);
        					navService.navigate(pageReference);
                            })
             .catch(function(error) {
            			console.log(error);
        				});
        },
    
    openLibraryItem : function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        var tabID;
        console.log('Starting Navigation');
            var id = event.getSource().get("v.title");
            var navService = component.find("navService");
            var pageReference = {
            			type: 'standard__recordPage',
            				attributes: {
                						actionName: 'view',
                						objectApiName: 'Contact_Center_kav',
                						recordId : id 
            							},
        					};
            workspaceAPI.getFocusedTabInfo().then(function(response) {
            				var focusedTabId = response.tabId;
            				component.set("v.pageReference", pageReference);
        					navService.navigate(pageReference);
                            })
             .catch(function(error) {
            			console.log(error);
        				});
        },
    
    checkServerItems : function(component, event, helper){
    	return new Promise(function(resolve, reject){
        	var more = this;
        	var accPatient = component.get("v.activePatient.Id", "v.value");
        	var accAssessment = component.get("v.activeAssessment.Id", "v.value");
        
        	if(accPatient === undefined){
            	more.getNewPatient(component);
        		}
        
        	if(accAssessment === undefined){
	            more.getNewAssessment(component);
    	    	}
        	  resolve("Resolved");  
        	});
		},
    
})