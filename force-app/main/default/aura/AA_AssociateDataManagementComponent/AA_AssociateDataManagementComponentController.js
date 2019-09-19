({
    doInit : function(component, event, helper){
        component.set("v.totalAssignments", 0);
        component.set("v.isAllReassignReferrals",false);
        component.set("v.strSelectedDistance", "Currently Assigned");
        component.set("v.strSubReferralSearch", "All");
        component.set("v.strSalesRepName", "");
        component.set("v.strSelectedUser", "");
        component.set("v.selectedUserId", "");
        component.set("v.homeFacilityfield", "");
        component.set("v.strCustomError", "");
        component.set("v.sortField", "name");
        
        helper.getLoggedInUser(component);
        helper.getPermissions(component);
        helper.getUsersList(component);
        helper.getUsersList2(component);
        
        helper.getDistanceList(component);
        helper.getSourceList(component);
        helper.getStatusList(component);
        helper.getStateList(component);
        helper.getTypeList(component);
    	},
    
    showWarning : function(component, event, helper){
        component.set("v.showRemoveWarning", true);
    	},
    
    showUserWarning3 : function(component, event, helper){
        component.set("v.showRemoveWarning3", true);
    	},
    
    hideWarning3 : function(component, event, helper){
        component.set("v.showRemoveWarning3", false);
    	},
    
    hideWarning : function(component, event, helper){
        component.set("v.showRemoveWarning", false);
    	},
    
    removeUserAssignments : function(component, event, helper){
        helper.removeUserAssignments(component);
        component.set("v.showRemoveWarning", false);
    	},
    
    searchUsers : function(component, event, helper){
    	var filter = component.get("v.nameListFilter", "v.value");
        console.log("filter: " + filter);
        if(filter !== undefined){
        	helper.filterUserList(component);
        	}
        else{
            helper.getUsersList(component);
        	}
		},
    
    searchUsers2 : function(component, event, helper){
    	var filter = component.get("v.nameListFilter2", "v.value");
        console.log("filter: " + filter);
        if(filter !== undefined){
        	helper.filterUserList2(component);
        	}
        else{
            helper.getUsersList2(component);
        	}
        },
    
    searchAccounts : function(component, event, helper){
        var filter = component.get("v.facilityListFilter", "v.value");
        if(filter !== undefined){
        	helper.filterAccountList(component);
        	}
        else{
            helper.getAccountList(component);
        	}
    	},
    
    resetUserList : function(component, event, helper){
       	component.set("v.nameListFilter", null);
        helper.getUsersList(component);
    	},
    
    resetUserList2 : function(component, event, helper){
       	component.set("v.nameListFilter2", null);
        helper.getUsersList2(component);
    	},
    
    resetAccountList : function(component, event, helper){
       	component.set("v.facilityListFilter", null);
        helper.getAccountList(component);
    	},
    
    getTeam : function(component, event, helper){
        var itemID = event.getSource().get("v.alternativeText");
        console.log(itemID);
        component.set("v.selectedItemID", itemID);
        helper.getTeamAssigned(component);
        helper.showModal(component, event, helper);
    	},
    
    onSet : function(component, event, helper){
        component.set("v.Spinner", true);
        console.log("Selected User: " + component.find("inputSelectUser").get("v.value"));
        component.set("v.paginationList", null);
        component.set("v.tableData", null);
        component.set("v.totalAssignments", 0);
        var setUser = component.find("inputSelectUser").get("v.value");
        component.set("v.selectedListUser", setUser);
        helper.setUser(component).then(
            $A.getCallback(function(result){
                console.log('Setting User');
            })
        )
        .then(
            $A.getCallback(function(result){
                console.log('Getting Role Structure');
                return helper.fetchParentRoles(component, event, helper);      
            })
            )
        .then(
            $A.getCallback(function(result){
                console.log('Getting User Source Count');
                return helper.getReferralSourceCount(component, event, helper);
            })
        )
        .then(
            $A.getCallback(function(result){
            console.log('Getting Referral List');
                var totals = component.get("v.totalAssignments");
        		console.log('Totals: ' + totals);
                if(totals < 1500){
                    return helper.getReferralList(component, event, helper);      
                	}
                    else{
                        component.set("v.tableData", null);
        				component.set("v.paginationList", null);
                    	}    
                })
        )
        .catch(
            $A.getCallback(function(error){
                // Something went wrong
                alert('An error occurred : ' + error.message);
            })
        );
    },
    
    onSet2 : function(component, event, helper){
        component.set("v.Spinner", true);
        var toUser = component.get("v.selectedListUser", "v.value");
        var fromUser = component.find("inputSelectUser2").get("v.value");
        if(fromUser === toUser){
            return null;
        }
        else{
            helper.getTypeList(component, event, helper);
            var setUser = component.find("inputSelectUser2").get("v.value");
            helper.setFromUser(component).then(
                $A.getCallback(function(result){
                    return helper.setFromUser(component);
                })
            )
            .then(
                $A.getCallback(function(result){
                    return helper.getReassignmentSourceCount(component, event, helper);
                })
            )
            .then(
                $A.getCallback(function(result){
                    return helper.getReassignmentList(component, event, helper);      
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
    
    massTransfer : function(component, event, helper){
        helper.massTransfer(component);
    },
    
    getChangedInfo : function(component, event, helper){
        component.set("v.showRemoveWarning3", false);
        helper.getUserInfo(component);
    },
    
    setDist : function(component, event, helper){
        component.set("v.distFilter", component.find("InputSelectDistance").get("v.value"));
        helper.checkSelectLists(component);
    },
    
    setSrc : function(component, event, helper){
        component.set("v.srcFilter" , component.find("InputSelectSource").get("v.value"));
    },
    
    setStat : function(component, event, helper){
        component.set("v.statFilter" , component.find("InputSelectStatus").get("v.value"));
        helper.checkSelectLists(component);
    },
    
    setSte : function(component, event, helper){
        component.set("v.steFilter" , component.find("InputSelectState").get("v.value"));
    },
    
    checkOptions : function(component, event, helper){
        helper.checkSelectLists(component);
        helper.onTabChange(component, event, helper);
    },
    
    getReferrals : function(component, event, helper){
        var view = component.find("InputSelectDistance").get("v.value");
        var state = component.find("InputSelectState").get("v.value");
        var SFID = component.get("v.sfIDFilter", "v.value");
        var NPI = component.get("v.npiFilter", "v.value");
        if(view === 'All' && state === 'None' && SFID.length === 0 && NPI.length === 0){
            alert('Unless searching by a System ID value, please select a state to narrow the results before proceeding.');
        }
        else{
            helper.getReferralList(component, event, helper);
        }
    },
    
    formPress: function(component, event, helper){
        if(event.keyCode === 13){
			var view = component.find("InputSelectDistance").get("v.value");
        	var state = component.find("InputSelectState").get("v.value");
        	if(view === 'All' && state === 'None'){
            	alert('Please select a state to narrow the results before proceeding.');
        		}
        	else{
                helper.getReferralList(component, event, helper);
        		}
        	}
    	},
    
    getReassignments : function(component, event, helper){
        var toUser = component.get("v.selectedListUser", "v.value");
        var fromUser = component.find("inputSelectUser2").get("v.value");
        if(fromUser === toUser){
            alert("You cannot transfer referral sources from a user you have already selected to receive them."); 
        }
        else{
            helper.getReassignmentList(component, event, helper);
        }
    },
    
    formPress2: function(component, event, helper){
        	var toUser = component.get("v.selectedListUser", "v.value");
        	var fromUser = component.find("inputSelectUser2").get("v.value");
        		if(fromUser === toUser){
            		alert("You cannot transfer referral sources from a user you have already selected to receive them."); 
        			}
        		else{
                    helper.getReassignmentList(component, event, helper);
        			}
        	},
    
    resetFilters : function(component, event, helper){
        ///Add all text filters
        helper.getDistanceList(component);
        helper.getStateList(component);
        helper.getTypeList(component);
        component.set("v.distFilter", "Currently Assigned");
        component.set("v.strSubReferralSearch", "All");
        component.set("v.InputSelectType", "All");
        component.set("v.sortField", "name");
        component.set("v.sourceFilter", "All");
        component.set("v.activeFilter", "All");
        component.set("v.StateFilter","None");
        component.set("v.steFilter", null);
        component.set("v.nameFilter", null);
        component.set("v.npiFilter", null);
        component.set("v.hmsFilter", null);
        component.set("v.sfIDFilter", null);
        component.set("v.addressFilter", null);
        component.set("v.cityFilter", null);
        component.set("v.stFilter", null);
        component.set("v.zipFilter", null);
        component.set("v.typeFilter", null);
        component.set("v.specialtyFilter", null);
        component.set("v.hhYTDAdmitFilter", null);
        component.set("v.hhPYAdmitFilter", null);
        component.set("v.hpYTDAdmitFilter", null);
        component.set("v.hpPYAdmitFilter", null);
        component.set("v.hdYTDAdmitFilter", null);
        component.set("v.hdPYAdmitFilter", null);
        component.set("v.hhPPSYTDAdmitFilter", null);
        component.set("v.hhPPSPYAdmitFilter", null);
        component.set("v.hhYTDReferralFilter", null);
        component.set("v.hhDiscQualAdmitYTDFilter", null);
        component.set("v.hpQualifiedYTDAdmitFilter", null);
        component.set("v.hpQualifiedPYAdmitFilter", null);
        component.set("v.hpYTDReferralFilter", null);
        component.set("v.hpLengthFilter", null);
        var inputSelOption = component.find("InputSelectState");
        var inputSelOption2 = component.find("InputSelectStatus");
        inputSelOption.set("v.disabled", true); 
        component.set("v.showWarning", false);
        inputSelOption2.set("v.disabled", true);
        helper.getReferralListReset(component, event, helper);
        helper.getReferralSourceCount(component);
    	},
    
    resetFilters2 : function(component, event, helper){
        component.set("v.InputSelectType2", "All");
        component.set("v.sortField2", "name");
        component.set("v.sourceFilter2", "All");
        component.set("v.activeFilter2", "All");
        component.set("v.StateFilter2","None");
        component.set("v.nameFilter2", null);
        component.set("v.npiFilter2", null);
        component.set("v.hmsFilter2", null);
        component.set("v.sfIDFilter2", null);
        component.set("v.addressFilter2", null);
        component.set("v.cityFilter2", null);
        component.set("v.stFilter2", null);
        component.set("v.zipFilter2", null);
        component.set("v.typeFilter2", null);
        component.set("v.specialtyFilter2", null);
        component.set("v.hhYTDAdmitFilter2", null);
        component.set("v.hhPYAdmitFilter2", null);
        component.set("v.hpYTDAdmitFilter2", null);
        component.set("v.hpPYAdmitFilter2", null);
        component.set("v.hdYTDAdmitFilter2", null);
        component.set("v.hdPYAdmitFilter2", null);
        component.set("v.hhPPSYTDAdmitFilter2", null);
        component.set("v.hhPPSPYAdmitFilter2", null);
        component.set("v.hhYTDReferralFilter2", null);
        component.set("v.hhDiscQualAdmitYTDFilter2", null);
        component.set("v.hpQualifiedYTDAdmitFilter2", null);
        component.set("v.hpQualifiedPYAdmitFilter2", null);
        component.set("v.hpYTDReferralFilter2", null);
        component.set("v.hpLengthFilter2", null);
        ///Add all text filters
        helper.getReassignmentList(component, event, helper);
    },
    
    getRoleList : function(component, event, helper){
        //helper.getRoleList(component, event, helper);
        helper.onTabChange(component, event, helper);
    },
    
    next : function(component, event, helper){
        helper.next(component, event, helper);
    },
    
    previous : function(component, event, helper){
        helper.previous(component, event, helper);
    },
    
    next2 : function(component, event, helper){
        helper.next2(component, event, helper);
    },
    
    previous2 : function(component, event, helper){
        helper.previous2(component, event, helper);
    },
    
    selectAll : function(component, event, helper){
        var lst = component.get("v.paginationList");
        for(var s in lst){
            // Checkbox is checked - add id to checkedItems
            if(component.get("v.checkedItems").indexOf(s) < 0){
                component.get("v.checkedItems").push(s);
                s.selected = true;
            }
            // Checkbox is unchecked - remove id from checkedItems
            if(component.get("v.checkedItems").indexOf(s) > -1){
                var index = component.get("v.checkedItems").indexOf(id);
                component.get("v.checkedItems").splice(index, 1);
                s.selected = false;
            }
        }
    },
    
    selectAll2 : function(component, event, helper){
        var checkboxes = component.find("rebox");
        var maincheck=component.find("checkbox2").get("v.value");
        var ln=checkboxes.length;
        if(maincheck==true ){
            if(ln == 1){
                checkboxes.set("v.value",true);
            }else{
                for (var i = 0; i<ln; i++){
                    checkboxes[i].set("v.value",true);
                }
            }
        }
        else if(maincheck==false){
            for (var i = 0; i <ln; i++){
                checkboxes[i].set("v.value",false);
            }
        }
    },
    
    onCheck : function(component, event, helper){
        var id = event.getSource().get("v.text");
        var state = event.getSource().get("v.value");
        var label = event.getSource().get("v.name");
        console.log("state: " + state);
        console.log("label: " + label);
        if(state === true){
        	component.set("v.checked1", id);
        	helper.processAssign(component).then(
            	$A.getCallback(function(result){
                console.log("processing assign");
            	})
        	)
        	.then(
            	$A.getCallback(function(result){
                    component.set("v.recentActivity", "Added " + label + " to referral sources.");
                    return helper.getReferralSourceCount(component, event, helper);
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
            component.set("v.removeName", label);
            component.set("v.showRemoveWarning2", true);
            console.log("setting placehold ID: " + id);
            component.set("v.placeholdID", id);
        	}
        },
    
    removeAssignmentConfirm : function(component, event, helper){
        var label = component.get("v.removeName");
        var id = component.get("v.placeholdID", "v.value");
        console.log("remove ID: " + id);
        component.set("v.checked1", id);
        helper.processAssign(component).then(
            	$A.getCallback(function(result){
                console.log("processing unassign");
            	})
        	)
        	.then(
            	$A.getCallback(function(result){
                    component.set("v.recentActivity", "Removed " + label + " from referral sources.");
                    return helper.getReferralSourceCount(component, event, helper);
            	})
        	).catch(
            	$A.getCallback(function(error){
                	// Something went wrong
                	alert('An error occurred : ' + error.message);
            	})
        	);
        component.set("v.showRemoveWarning2", false);
        },
    
    hideWarning2 : function(component, event, helper){
        helper.getReferralList(component, event, helper);
        component.set("v.showRemoveWarning2", false);
        component.set("v.placeholdID", null);
        component.set("v.removeName", null);
        },
            
    onCheck2 : function(component, event, helper){
        var id = event.getSource().get("v.text");
        component.set("v.checked2", id);
        helper.processReassign(component).then(
            $A.getCallback(function(result){
            })
        )
        .then(
            $A.getCallback(function(result){
                return helper.getReassignmentSourceCount(component, event, helper);
            })
        ).catch(
            $A.getCallback(function(error){
                // Something went wrong
                alert('An error occurred : ' + error.message);
            })
        );
        },        
    
    /*
    onCheck : function(component, event, helper){
        var id = event.getSource().get("v.text");
        // Checkbox is checked - add id to checkedItems
        if(component.get("v.checkedItems").indexOf(id) < 0){
            component.get("v.checkedItems").push(id);
        }
        else if(component.get("v.checkedItems").indexOf(id) > -1){
            var index = component.get("v.checkedItems").indexOf(id);
            component.get("v.checkedItems").splice(index, 1);
        }
    },
    
    onCheck2 : function(component, event, helper){
        var id = event.getSource().get("v.text");
        // Checkbox is checked - add id to checkedItems
        if(component.get("v.checkedItems2").indexOf(id) < 0){
            component.get("v.checkedItems2").push(id);
        }
        else if(component.get("v.checkedItems2").indexOf(id) > -1){
            var index = component.get("v.checkedItems2").indexOf(id);
            component.get("v.checkedItems2").splice(index, 1);
        }
    },
    */
    
    sortName: function(component, event, helper){
        helper.sortBy(component, "name");
    },
    
    sortNPI : function(component, event, helper){
        helper.sortBy(component, "npi");
    },
    
    sortAddress : function(component, event, helper){
        helper.sortBy(component, "shippingStreet");
    },
    
    sortCity : function(component, event, helper){
        helper.sortBy(component, "shippingCity");
    },
    
    sortState : function(component, event, helper){
        helper.sortBy(component, "shippingState");
    },
    
    sortZip : function(component, event, helper){
        helper.sortBy(component, "shippingPostalCode");
    },
    
    sortType : function(component, event, helper){
        helper.sortBy(component, "accType");
    },
    
    sortSpecialty : function(component, event, helper){
        helper.sortBy(component, "specialty");
    },
    
    sortHHYTDAdmits : function(component, event, helper){
        helper.sortBy(component, "hhYTDAdmit");
    },
    
    sortHHPYAdmits : function(component, event, helper){
        helper.sortBy(component, "hhPYAdmit");
    },
    
    sortHPYTDAdmits : function(component, event, helper){
        helper.sortBy(component, "hpYTDAdmit");
    },
    
    sortHPPYAdmits : function(component, event, helper){
        helper.sortBy(component, "hpPYAdmit");
    },
    
    sortHDYTDAdmits : function(component, event, helper){
        helper.sortBy(component, "hdYTDAdmit");
    },
    
    sortHDPYAdmits : function(component, event, helper){
        helper.sortBy(component, "hdPYAdmit");
    },
    
    sortPPSYTDAdmitsHH : function(component, event, helper){
        helper.sortBy(component, "hhYTDPPSAdmit");
    },
    
    sortPPSPYHH : function(component, event, helper){
        helper.sortBy(component, "hhPYPPSAdmit");
    },
    
    sortYTDReferralsHH : function(component, event, helper){
        helper.sortBy(component, "hhYTDRefer");
    },
    
    sortDiscQualYTDAdmitsHH : function(component, event, helper){
        helper.sortBy(component, "hhDiscQualYTDAdmit");
    },
    
    sortDiscQualPYAdmitsHH : function(component, event, helper){
        helper.sortBy(component, "hhDiscQualPYAdmit");
    },
    
    sortQualYTDAdmitsHP : function(component, event, helper){
        helper.sortBy(component, "hpQualYTDAdmit");
    },
    
    sortQualPYAdmitsHP : function(component, event, helper){
        helper.sortBy(component, "hpQualPYAdmit");
    },
    
    sortYTDReferHP : function(component, event, helper){
        helper.sortBy(component, "hpYTDRefer");
    },
    
    sortYTDAdmitsHP : function(component, event, helper){
        helper.sortBy(component, "hpYTDAdmit");
    },
    
    sortStayLengthHP : function(component, event, helper){
        helper.sortBy(component, "lengthOfStay");
    },
    
    sortSFIDs : function(component, event, helper){
        helper.sortBy(component, "itemID");
    },
    
    sortNPIIDs : function(component, event, helper){
        helper.sortBy(component, "npi");
    },
    
    sortHCHBHHID : function(component, event, helper){
        helper.sortBy(component, "hchbhh");
    },
    
    sortHCHBHPID : function(component, event, helper){
        helper.sortBy(component, "hchbhp");
    },
    
    sortHMSIDs : function(component, event, helper){
        helper.sortBy(component, "hms");
    },
    
    sortAssignedTime : function(component, event, helper){
        helper.sortBy(component, "assignedTime");
    },
    
    sortHorizonIDs : function(component, event, helper){
        helper.sortBy(component, "horizon");
    },
    
    sortMeditechIDs : function(component, event, helper){
        helper.sortBy(component, "meditech");
    },
    
    sortUnityIDs : function(component, event, helper){
        helper.sortBy(component, "unity");
    },
    
    sortName2 : function(component, event, helper) {
        helper.sortBy2(component, "name");
    },
    
    sortNPI2 : function(component, event, helper){
        helper.sortBy2(component, "npi");
    },
    
    sortAddress2 : function(component, event, helper){
        helper.sortBy2(component, "shippingStreet");
    },
    
    sortCity2 : function(component, event, helper){
        helper.sortBy2(component, "shippingCity");
    },
    
    sortState2 : function(component, event, helper){
        helper.sortBy2(component, "shippingState");
    },
    
    sortZip2 : function(component, event, helper){
        helper.sortBy2(component, "shippingPostalCode");
    },
    
    sortType2 : function(component, event, helper){
        helper.sortBy2(component, "accType");
    },
    
    sortSpecialty2 : function(component, event, helper){
        helper.sortBy2(component, "specialty");
    },
    
    sortHHYTDAdmits2 : function(component, event, helper){
        helper.sortBy2(component, "hhYTDAdmit");
    },
    
    sortHHPYAdmits2 : function(component, event, helper){
        helper.sortBy2(component, "hhPYAdmit");
    },
    
    sortHPYTDAdmits2 : function(component, event, helper){
        helper.sortBy2(component, "hpYTDAdmit");
    },
    
    sortHPPYAdmits2 : function(component, event, helper){
        helper.sortBy2(component, "hpPYAdmit");
    },
    
    sortHDYTDAdmits2 : function(component, event, helper){
        helper.sortBy2(component, "hdYTDAdmit");
    },
    
    sortHDPYAdmits2 : function(component, event, helper){
        helper.sortBy2(component, "hdPYAdmit");
    },
    
    sortPPSYTDAdmitsHH2 : function(component, event, helper){
        helper.sortBy2(component, "hhYTDPPSAdmit");
    },
    
    sortPPSPYHH2 : function(component, event, helper){
        helper.sortBy2(component, "hhPYPPSAdmit");
    },
    
    sortYTDReferralsHH2 : function(component, event, helper){
        helper.sortBy2(component, "hhYTDRefer");
    },
    
    sortDiscQualYTDAdmitsHH2 : function(component, event, helper){
        helper.sortBy2(component, "hhDiscQualYTDAdmit");
    },
    
    sortDiscQualPYAdmitsHH2 : function(component, event, helper){
        helper.sortBy2(component, "hhDiscQualPYAdmit");
    },
    
    sortQualYTDAdmitsHP2 : function(component, event, helper){
        helper.sortBy2(component, "hpQualYTDAdmit");
    },
    
    sortQualPYAdmitsHP2 : function(component, event, helper){
        helper.sortBy2(component, "hpQualPYAdmit");
    },
    
    sortYTDReferHP2 : function(component, event, helper){
        helper.sortBy2(component, "hpYTDRefer");
    },
    
    sortYTDAdmitsHP2 : function(component, event, helper){
        helper.sortBy2(component, "hpYTDAdmit");
    },
    
    sortStayLengthHP2 : function(component, event, helper){
        helper.sortBy2(component, "lengthOfStay");
    },
    
    sortSFIDs2 : function(component, event, helper){
        helper.sortBy2(component, "itemID");
    },
    
    sortNPIIDs2 : function(component, event, helper){
        helper.sortBy2(component, "npi");
    },
    
    sortHCHBHHID2 : function(component, event, helper){
        helper.sortBy2(component, "hchbhh");
    },
    
    sortHCHBHPID2 : function(component, event, helper){
        helper.sortBy2(component, "hchbhp");
    },
    
    sortHMSIDs2 : function(component, event, helper){
        helper.sortBy2(component, "hms");
    },
    
    sortHorizonIDs2 : function(component, event, helper){
        helper.sortBy2(component, "horizon");
    },
    
    sortMeditechIDs2 : function(component, event, helper){
        helper.sortBy2(component, "meditech");
    },
    
    sortUnityIDs2 : function(component, event, helper){
        helper.sortBy2(component, "unity");
    },
    
    onTabChange : function(component, event, helper){
        var a = event.getSource();
        var id = a.getLocalId();
        console.log('localID: ' + id);
        if(id == 'reassignTab'){
            component.set("v.showFromSelection", true);
            component.set("v.showNameFilter", false);
        }
        else if(id != 'reassignTab'){
            component.set("v.showFromSelection", false);
            component.set("v.showNameFilter", true);
        	}
        console.log('showFromSelection: ' + component.get("v.showFromSelection"));
    },
    
    hideModal : function(component, event, helper){
        helper.hideModal(component);
    },
    
    fetchDependentRoles : function(component, event, helper){
        var role = event.getSource().get("v.value");
        console.log('New Role: ' + role);
        component.set("v.newRole", role);
        helper.fetchNewRoles(component);
    },
    
    changeRole : function(component, event, helper){
        helper.setNewRole(component, event, helper);
    },
    
})