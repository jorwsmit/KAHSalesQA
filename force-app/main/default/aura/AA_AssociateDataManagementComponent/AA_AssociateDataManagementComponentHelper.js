({
	
    filterUserList : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.filterUserList");
        return new Promise(function(resolve, reject){
            action.setParams({
                			"nameListFilter" : component.get("v.nameListFilter", "v.value")
            				});
        	action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                var newList2 = [];
                newList2.push(' ');
                var strng2 = 'No match found';
                    newList2.push(strng2);
                	
                component.set("v.selectList", newList2);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.userList", repList);
                var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].LastName + ', ' + stockData[i].FirstName + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Line_of_Business__c != undefined){
                        strng += stockData[i].Line_of_Business__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].PERNER__c != undefined){
                        strng += stockData[i].PERNER__c;
                    	}
                    newList.push(strng);
                	}
                component.set("v.selectList", newList);
                component.set("v.Spinner", false);
            	resolve("Resolved");
            	}
            });
    		$A.enqueueAction(action);
        	});
    	},
    
    filterUserList2 : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.filterUserList2");
        return new Promise(function(resolve, reject){
            action.setParams({
                			"nameListFilter2" : component.get("v.nameListFilter2", "v.value")
            				});
        	action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                var newList2 = [];
                newList2.push(' ');
                var strng2 = 'No match found';
                    newList2.push(strng2);
                	
                component.set("v.selectList2", newList2);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.userList2", repList);
                var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].LastName + ', ' + stockData[i].FirstName + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Line_of_Business__c != undefined){
                        strng += stockData[i].Line_of_Business__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].PERNER__c != undefined){
                        strng += stockData[i].PERNER__c;
                    	}
                    newList.push(strng);
                	}
                component.set("v.selectList2", newList);
                component.set("v.Spinner", false);
            	resolve("Resolved");
            	}
            });
    		$A.enqueueAction(action);
        	});
    	},
    
    filterAccountList : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.filterAccountList");
        return new Promise(function(resolve, reject){
            action.setParams({
                			"facilityListFilter" : component.get("v.facilityListFilter", "v.value")
            				});
        	action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                var newList2 = [];
                newList2.push(' ');
                var strng2 = 'No match found';
                    newList2.push(strng2);
                	
                component.set("v.accSelectList", newList2);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.accountList", repList);
            	var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].Name + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Facility_Number__c != undefined){
                        strng += stockData[i].Facility_Number__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].Type != undefined){
                        strng += stockData[i].Type + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    strng += stockData[i].Id;
                    newList.push(strng);
                	}
                component.set("v.accSelectList", newList);
                component.set("v.Spinner", false);
            	}
            });
    		$A.enqueueAction(action);
        	});
    	},
    
	getUsersList : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getUsersList");
        return new Promise(function(resolve, reject){
        	action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	var msgID = component.find("uiMessageid");
                $A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.userList", repList);
                var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].LastName + ', ' + stockData[i].FirstName + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Line_of_Business__c != undefined){
                        strng += stockData[i].Line_of_Business__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].PERNER__c != undefined){
                        strng += stockData[i].PERNER__c;
                    	}
                    newList.push(strng);
                	}
                component.set("v.selectList", newList);
                component.set("v.Spinner", false);
            	resolve("Resolved");
            	}
            });
    		$A.enqueueAction(action);
        	});
        },
    
    getUsersList2 : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getUsersList2");
        return new Promise(function(resolve, reject){
        	action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	var msgID = component.find("uiMessageid");
                $A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.userList2", repList);
                var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].LastName + ', ' + stockData[i].FirstName + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Line_of_Business__c != undefined){
                        strng += stockData[i].Line_of_Business__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].PERNER__c != undefined){
                        strng += stockData[i].PERNER__c;
                    	}
                    newList.push(strng);
                	}
                component.set("v.selectList2", newList);
                component.set("v.Spinner", false);
            	resolve("Resolved");
            	}
            });
    		$A.enqueueAction(action);
        	});
        },
    
    removeUserAssignments : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.removeAllUserAssignments");
        action.setParams({
            			  "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value")
        				  }); 
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response !== 0){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                console.log("Remove Source Error.");
                return;
            	} 
            else{
				var repList = response;
                console.log('Resetting Referral List');
                component.set("v.tableData", null);
        		component.set("v.paginationList", null);
                component.set("v.totalAssignments", 0);
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
			});
        $A.enqueueAction(action);
        });
    	},
    
    getBusinessList : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getBusinessList");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	var msgID = component.find("uiMessageid");
                $A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                return;
        		}
        	else{
                var repList = response;
                component.set("v.businessList", repList);
                component.set("v.Spinner", false);
            	}
    		});
    	$A.enqueueAction(action);
        },
    
    getAccountList : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getAccountList");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	var msgID = component.find("uiMessageid");
                $A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                return;
        		}
        	else{
                var repList = response;
                component.set("v.accountList", repList);
            	var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].Name + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Facility_Number__c != undefined){
                        strng += stockData[i].Facility_Number__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].Type != undefined){
                        strng += stockData[i].Type + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    strng += stockData[i].Id;
                    newList.push(strng);
                	}
                component.set("v.accSelectList", newList);
                component.set("v.Spinner", false);
            	}
    		});
    	$A.enqueueAction(action);
        },
    
    getTypeList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.typeSelectList", null);
        var action = component.get("c.getTypeList");
        return new Promise(function(resolve, reject){
        	action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	console.log("Type Response: " + response);
            if(response == null || response == "" || response == "[]" || response == "{}"){
            	var msgID = component.find("uiMessageid");
                $A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.typeSelectList", repList);
                component.set("v.Spinner", false);
            	resolve("Resolved");
            	}
    		});
    	$A.enqueueAction(action);
        	});
        },
    
    getSourceList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.srcSelectList", null);
		var action = component.get("c.getSourceList");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
                var repList = response;
                component.set("v.srcSelectList", repList);
                component.set("v.Spinner", false);
                resolve("Resolved");
				}
			});
        $A.enqueueAction(action);
        });
		},
    
    getDistanceList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.distSelectList", null);
		var action = component.get("c.getDistanceList");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                //Show toast Error
                return;
            	} 
            else{
                var repList = response;
                component.set("v.distSelectList", repList);
                component.set("v.Spinner", false);
                resolve("Resolved");
				}
			});
        $A.enqueueAction(action);
        });
		},
    
    getStatusList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.statusSelectList", null);
		var action = component.get("c.getStatusList");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                //Show toast Error
                return;
            	} 
            else{
                var repList = response;
                component.set("v.statusSelectList", repList);
                component.set("v.Spinner", false);
                resolve("Resolved");
				}
			});
        $A.enqueueAction(action);
        });
		},
    
    getStateList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.stateSelectList", null);
		var action = component.get("c.getStateList");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                //Show toast Error
                return;
            	} 
            else{
                var repList = response;
                component.set("v.stateSelectList", repList);
                component.set("v.Spinner", false);
                resolve("Resolved");
				}
			});
        $A.enqueueAction(action);
        });
		},
    
    setUser : function(component, event, helper){
        var action = component.get("c.getSelectedUser");
        var more = this;
        component.set("v.accSelectList", '');
        component.set("v.businessList", '');
        more.getAccountList(component);
        more.getBusinessList(component);
        action.setParams({
            "selectedUser" : component.find("inputSelectUser").get("v.value"),
            "isSalesRep" : component.get("v.customPermissions.isSalesRep", "v.value")
        	});
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.selectedUser", repList);
                component.get("v.businessList").unshift(component.get("v.selectedUser.lineOfBusiness", "v.value"));
                if(component.get("v.selectedUser.accName", "v.value") === undefined){
                	component.get("v.accSelectList").unshift('None Assigned');
                	}
                else{
                    component.get("v.accSelectList").unshift(component.get("v.selectedUser.accName", "v.value") + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0' + component.get("v.selectedUser.facilityNumber", "v.value") + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0' + component.get("v.selectedUser.accType", "v.value") + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0' + component.get("v.selectedUser.accId", "v.value"));
                	}
                component.set("v.showSelectedUser", true);
                component.set("v.strSelectedUser", component.get("v.selectedUser.firstName") + " " + component.get("v.selectedUser.lastName"));
            	component.set("v.selectedUserRole", component.get("v.selectedUser.roleName", "v.value"));
                component.set("v.selectedUserRoleID", component.get("v.selectedUser.roleID", "v.value"));
            	component.set("v.selectedUserLocation", component.get("v.selectedUser.location", "v.value"));
                component.set("v.selectedUser.phone", component.get("v.selectedUser.phone", "v.value"));
                console.log("Location: " + component.get("v.selectedUser.location", "v.value"));
                resolve("Resolved");
            	}
			});
        	$A.enqueueAction(action);
        	});
       	},
    
    setFromUser : function(component, event, helper){
        var action = component.get("c.getSelectedUser");
        action.setParams({
            "selectedUser" : component.find("inputSelectUser2").get("v.value"),
        	"isSalesRep" : component.get("v.customPermissions.isSalesRep", "v.value")
        	});
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.selectedFromUser", repList);
                resolve("Resolved");
            	}
			});
        	$A.enqueueAction(action);
        	});
    	},
    
    getUserInfo : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getUpdatedInfo");
        action.setParams({
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value"),
        	"selectedAccount" : component.find("inputSelectAccount").get("v.value"),
            "lineOfBusiness" : component.find("inputSelectBusiness").get("v.value"),
            "title": component.find("inputTitle").get("v.value"),
            "phone": component.find("inputPhone").get("v.value")
        	});
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state == 'SUCCESS'){
                var response = a.getReturnValue();
                console.log("Update Success");
				var repList = response;
                component.set("v.selectedUser", repList);
                component.get("v.businessList").unshift(component.get("v.selectedUser.lineOfBusiness", "v.value"));
                component.get("v.accSelectList").unshift(component.get("v.selectedUser.accName", "v.value") + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0' + component.get("v.selectedUser.facilityNumber", "v.value") + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0' + component.get("v.selectedUser.accType", "v.value") + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0' + component.get("v.selectedUser.accId", "v.value"));
				component.set("v.Spinner", false);
                } 
            else{
				var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                console.log("Update Error: " + state);
                component.set("v.Spinner", false);
                return;
            	}
			});
        	$A.enqueueAction(action);
        },
    
    getReassignmentsLists : function(component, event, helper){
        helper.getReassignmentCount(component, event, helper);
        helper.getReassignmentList(component, event, helper);
    	},
    
    getReferralSourceCount : function(component, event, helper){
        var action = component.get("c.getReferralSourceCount");
        action.setParams({
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value")
        	}); 
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            console.log("Source Count Response: " + response);
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.totalAssignments", repList);
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
			});
        $A.enqueueAction(action);
        	});
    	},
    
    setSelectedFromUser : function(component, event, helper){
        component.set("v.Spinner", true);
    	var action = component.get("c.getSelectedUser");
        action.setParams({
            "selectedUser" : component.find("inputSelectUser2").get("v.value")
        	}); 
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.selectedFromUser", repList);
                component.set("v.selectedFromUserLatitude", component.get("v.selectedUser.Account__r.Latitude__c", "v.value"));
                component.set("v.selectedFromUserLongitude", component.get("v.selectedUser.Account__r.Longitude__c", "v.value"));
                console.log("selectedFromUser: " + component.get("v.selectedFromUser.selectedUser", "v.value"));
            	component.set("v.Spinner", false);
            	}
			});
        $A.enqueueAction(action);
		},
    
    getReassignmentSourceCount : function(component, event, helper){
        var action = component.get("c.getReferralSourceCount");
        action.setParams({
            "selectedUser" : component.get("v.selectedFromUser.selectedUser", "v.value")
        	}); 
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.totalReassignments", repList);
                }
			});
        $A.enqueueAction(action);
    	},
    
    getReferralList : function(component, event, helper){
        var more = this;
        component.set("v.Spinner", true);
        component.set("v.tableData", null);
        component.set("v.paginationList", null);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getReferralList");
        var type;
        try{
        	type = component.find("InputSelectType").get("v.value");
        	}
        catch(error){
            	type = "All";
        		}
        var defaultOrder = "asc";
        
        var filters = [];
        filters.push('sourceFilter:' + component.get("v.srcFilter","v.value"));
        filters.push('activeFilter:' + component.get("v.statFilter","v.value"));
        filters.push('stateFilter:' + component.get("v.steFilter","v.value")); 
        filters.push('nameFilter:' + component.get("v.nameFilter", "v.value"));
        filters.push('npiFilter:' + component.get("v.npiFilter", "v.value"));
    	filters.push('hmsFilter:' + component.get("v.hmsFilter", "v.value"));
    	filters.push('sfIDFilter:' + component.get("v.sfIDFilter", "v.value"));
        filters.push('addressFilter:' + component.get("v.addressFilter", "v.value"));
    	filters.push('cityFilter:' + component.get("v.cityFilter", "v.value"));
    	filters.push('stFilter:' + component.get("v.stFilter", "v.value"));
    	filters.push('zipFilter:' + component.get("v.zipFilter", "v.value"));
    	filters.push('specialtyFilter:' + component.get("v.specialtyFilter", "v.value"));
    	filters.push('hhYTDAdmitFilter:' + component.get("v.hhYTDAdmitFilter", "v.value"));
    	filters.push('hhPYAdmitFilter:' + component.get("v.hhPYAdmitFilter", "v.value"));
    	filters.push('hpYTDAdmitFilter:' + component.get("v.hpYTDAdmitFilter", "v.value"));
    	filters.push('hpPYAdmitFilter:' + component.get("v.hpPYAdmitFilter", "v.value"));
    	filters.push('hdYTDAdmitFilter:' + component.get("v.hdYTDAdmitFilter", "v.value"));
    	filters.push('hdPYAdmitFilter:' + component.get("v.hdPYAdmitFilter", "v.value"));
    	filters.push('hhPPSYTDAdmitFilter:' + component.get("v.hhPPSYTDAdmitFilter", "v.value"));
    	filters.push('hhPPSPYAdmitFilter:' + component.get("v.hhPPSPYAdmitFilter", "v.value"));
    	filters.push('hhYTDReferralFilter:' + component.get("v.hhYTDReferralFilter", "v.value"));
    	filters.push('hhDiscQualAdmitYTDFilter:' + component.get("v.hhDisQualAdmitYTDFilter", "v.value"));
    	filters.push('hpQualifiedYTDAdmitFilter:' + component.get("v.hpQualifiedYTDAdmitFilter", "v.value"));
    	filters.push('hpQualifiedPYAdmitFilter:' + component.get("v.hpQualifiedPYAdmitFilter", "v.value"));
    	filters.push('hpYTDReferralFilter:' + component.get("v.hpYTDReferralFilter", "v.value"));
    	filters.push('hpLengthFilter:' + component.get("v.hpLengthFilter", "v.value"));
    	
        action.setParams({
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value"),
            "distanceFilter" : component.get("v.distFilter","v.value"),
            "sortField" : component.get("v.sortField", "v.value"),
            "typeFilter" : type,
            "filters" : filters,
            "isAsc" : defaultOrder,
            "location" : component.get("v.selecedUserLocation", "v.value"),
            "reqType" : "Referral"
            }); 
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
            if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                var checkList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationList", paginationList);
                component.set("v.tableData", response);
                component.set("v.totalSize", component.get("v.tableData").length);
                more.getReferralSourceCount(component);
                component.set("v.Spinner", false);
            	resolve("Resolved");
            	}
			});
        $A.enqueueAction(action);
        	});
    	},
    
    getReferralListReset : function(component, event, helper){
        var more = this;
        component.set("v.Spinner", true);
        component.set("v.tableData", null);
        component.set("v.paginationList", null);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getReferralList");
        var type = "All";
        var defaultOrder = "asc";
        
        var filters = [];
        
        action.setParams({
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value"),
            "distanceFilter" : component.get("v.distFilter","v.value"),
            "sortField" : component.get("v.sortField", "v.value"),
            "typeFilter" : type,
            "filters" : filters,
            "isAsc" : defaultOrder,
            "location" : component.get("v.selecedUserLocation", "v.value"),
            "reqType" : "Referral"
            }); 
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
            if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                var checkList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationList", paginationList);
                component.set("v.tableData", response);
                component.set("v.Spinner", false);
                more.getReferralSourceCount(component);
                resolve("Resolved");
            	}
			});
        $A.enqueueAction(action);
        	});
    	},
    
    getReassignmentList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.tableData2", null);
        component.set("v.paginationList2", null);
        component.set("v.transferButton", true);
        component.set("v.massTransferButton", true);
        var pageSize = component.get("v.pageSize2");
        var action = component.get("c.getReferralList");
        var type;
        try{
        	type = component.find("InputSelectType2").get("v.value");
        	}
        catch(error){
            	type = "All";
        		}
        var defaultOrder = "asc";
        
        var filters = [];
        filters.push('nameFilter:' + component.get("v.nameFilter2", "v.value"));
        filters.push('npiFilter:' + component.get("v.npiFilter2", "v.value"));
    	filters.push('hmsFilter:' + component.get("v.hmsFilter2", "v.value"));
    	filters.push('sfIDFilter:' + component.get("v.sfIDFilter2", "v.value"));
        filters.push('addressFilter:' + component.get("v.addressFilter2", "v.value"));
    	filters.push('cityFilter:' + component.get("v.cityFilter2", "v.value"));
    	filters.push('stFilter:' + component.get("v.stFilter2", "v.value"));
    	filters.push('zipFilter:' + component.get("v.zipFilter2", "v.value"));
    	filters.push('specialtyFilter:' + component.get("v.specialtyFilter2", "v.value"));
    	filters.push('hhYTDAdmitFilter:' + component.get("v.hhYTDAdmitFilter2", "v.value"));
    	filters.push('hhPYAdmitFilter:' + component.get("v.hhPYAdmitFilter2", "v.value"));
    	filters.push('hpYTDAdmitFilter:' + component.get("v.hpYTDAdmitFilter2", "v.value"));
    	filters.push('hpPYAdmitFilter:' + component.get("v.hpPYAdmitFilter2", "v.value"));
    	filters.push('hdYTDAdmitFilter:' + component.get("v.hdYTDAdmitFilter2", "v.value"));
    	filters.push('hdPYAdmitFilter:' + component.get("v.hdPYAdmitFilter2", "v.value"));
    	filters.push('hhPPSYTDAdmitFilter:' + component.get("v.hhPPSYTDAdmitFilter2", "v.value"));
    	filters.push('hhPPSPYAdmitFilter:' + component.get("v.hhPPSPYAdmitFilter2", "v.value"));
    	filters.push('hhYTDReferralFilter:' + component.get("v.hhYTDReferralFilter2", "v.value"));
    	filters.push('hhDisQualAdmitYTDFilter:' + component.get("v.hhDisQualAdmitYTDFilter2", "v.value"));
    	filters.push('hpQualifiedYTDAdmitFilter:' + component.get("v.hpQualifiedYTDAdmitFilter2", "v.value"));
    	filters.push('hpQualifiedPYAdmitFilter:' + component.get("v.hpQualifiedPYAdmitFilter2", "v.value"));
    	filters.push('hpYTDReferralFilter:' + component.get("v.hpYTDReferralFilter2", "v.value"));
    	filters.push('hpLengthFilter:' + component.get("v.hpLengthFilter2", "v.value"));
    	action.setParams({
            "selectedUser" : component.get("v.selectedFromUser.selectedUser", "v.value"),
            "sortField" : component.get("v.sortField2", "v.value"),
            "typeFilter" : type,
            "filters" : filters,
            "isAsc" : defaultOrder,
            "reqType" : "Reassignment"
            }); 
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start2",0);
                component.set("v.end2",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationList2", paginationList);
                component.set("v.tableData2", response);
                component.set("v.totalSize2", component.get("v.tableData2").length);
            	component.set("v.transferButton", false);
        		component.set("v.massTransferButton", false);
                component.set("v.Spinner", false);
            	}
			});
        $A.enqueueAction(action);
        },
    
    processAssign : function (component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        var action = component.get("c.getProcessAssignReferralSources");
        action.setParams({
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value"),
            "idList" : component.get("v.checked1")
        	}); 
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.totalAssignments", response);
                //component.set("v.checkedItems", null);
                component.set("v.Spinner", false);
                resolve("Resolved");
            	//more.getReferralList(component);
                }
			});
        $A.enqueueAction(action);
        });
        },
    
    processReassign : function (component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
        var checkedItems2 = [];
        checkedItems2.push(component.get("v.checked2"));
        var action = component.get("c.getProcessReassignReferralSources");
        console.log('selectedFromUser: ' + component.get("v.selectedFromUser.selectedUser", "v.value"));
        action.setParams({
            "selectedFromUser" : component.get("v.selectedFromUser.selectedUser", "v.value"),
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value"),
            "idList" : checkedItems2
        	});
        return new Promise(function(resolve, reject) {
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.totalReassignments", response);
                more.getReferralList(component);
                component.set("v.Spinner", false);
                more.getReassignmentList(component);
                more.getReassignmentSourceCount(component);
                resolve("Resolved");
            	}
            });
        $A.enqueueAction(action);
        });
    },
    
    massTransfer : function(component, event, helper){
        component.set("v.Spinner", true);
        var more = this;
    	var action = component.get("c.getProcessReassignReferralSources");
        var checkedItems2 = [];
        var tableData2 = component.get("v.tableData2");
        for(var i=0; i< tableData2.length; i++){
                 	checkedItems2.push(tableData2[i].itemID);    
    				}
        console.log('checkedItems2: ' + checkedItems2.length);
        action.setParams({
            "selectedFromUser" : component.get("v.selectedFromUser.selectedUser", "v.value"),
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value"),
            "idList" : checkedItems2
        	});
        return new Promise(function(resolve, reject) {
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                component.set("v.Spinner", false);
                //Show toast Error
                return;
            	} 
            else{
				var repList = response;
                component.set("v.totalReassignments", response);
                more.getReferralList(component);
                alert('Referral Source Changes Complete');
                component.set("v.checkedItems2", null);
                component.set("v.Spinner", false);
                component.set("v.paginationList2", null);
                component.set("v.tableData2", null);
                resolve("Resolved");
            	}
            });
        $A.enqueueAction(action);
        });
		},
    
    getLoggedInUser : function(component, event, helper){
        component.set("v.Spinner", true);
		var action = component.get("c.getLoggedInUser");
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
                var repList = response;
                component.set("v.loggedInUser", repList);
                component.set("v.loggedInUserStr", component.get("v.loggedInUser.LastName", "v.value") + ', ' + component.get("v.loggedInUser.FirstName", "v.value") + ' - ' + component.get("v.loggedInUser.Line_of_Business__c", "v.value") + ' - ' + component.get("v.loggedInUser.PERNER__c", "v.value"));
                console.log("loggedInUserStr: " + component.get("v.loggedInUserStr"));
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
			});
        	$A.enqueueAction(action);
            });
		},
    
    getPermissions : function(component, event, helper){
        component.set("v.Spinner", true);
		console.log("Start Permission Promise");
        var action = component.get("c.getPermissions");
        var self = this;
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            console.log("Permission Promise Response: " + response);
            if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
                var repList = response;
                component.set("v.customPermissions", repList);
                console.log("Is Sales Rep: " + component.get("v.customPermissions.isSalesRep", "v.value"));
				if(component.get("v.customPermissions.isSalesRep", "v.value") === true){
        			component.set("v.salesRepName", component.get("v.loggedInUserStr", "v.value"));
                    component.find("inputSelectUser").set("v.value", component.get("v.loggedInUserStr", "v.value"));
                    self.setUser(component).then(
            $A.getCallback(function(result){
            })
        )
        .then(
            $A.getCallback(function(result){
                if(component.get("v.customPermissions.isSalesRep", "v.value") === true){
                	component.set("v.showUserList", false);
                    }
                return self.getReferralSourceCount(component, event, helper);
            })
        )
        .then(
            $A.getCallback(function(result){
                return self.getReferralList(component, event, helper);      
            })
        )
        .then(
            $A.getCallback(function(result){
                return self.fetchParentRoles(component, event, helper);      
            })
        )
        .catch(
            $A.getCallback(function(error){
                // Something went wrong
                alert('An error occurred : ' + error.message);
            })
        );
                 	}
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
			});
        	$A.enqueueAction(action);
        	});
        },
    
    checkSelectLists: function(component, event, helper){
        var inputSelOption = component.find("InputSelectState");
        var inputSelOption2 = component.find("InputSelectStatus");
        if(component.find("InputSelectDistance").get("v.value") != 'All'){
     		inputSelOption.set("v.disabled", true); 
            inputSelOption.set("v.value", "None");
            component.set("v.steFilter","None");
            component.set("v.showWarning", false);
        	}
        else{
            inputSelOption.set("v.disabled",false);
            component.set("v.showWarning", true);
        	}
        if(component.find("InputSelectDistance").get("v.value") == 'Currently Assigned'){
            inputSelOption2.set("v.disabled", true); 
        	}
        else{
            inputSelOption2.set("v.disabled",false);
            }
        },
    
    checkSelectLists2: function(component, event, helper){
        var inputSelOption = component.find("InputSelectState2");
        var inputSelOption2 = component.find("InputSelectStatus2");
        if(component.find("InputSelectDistance2").get("v.value") != 'All'){
     		inputSelOption.set("v.disabled", true); 
            }
        else{
            inputSelOption.set("v.disabled",false);
            }
        if(component.find("InputSelectDistance2").get("v.value") == 'Currently Assigned'){
            inputSelOption2.set("v.disabled", true); 
        	}
        else{
            inputSelOption2.set("v.disabled",false);
            }
        },
    
    sortBy: function(component, field){
        pageSize = component.get("v.pageSize");	
        var sortAsc = component.get("v.sortAsc"),
        sortField = component.get("v.sortField"),
        records = component.get("v.tableData");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.tableData", records);
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
         
        var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(records[i]);    
    				}
                component.set("v.paginationList", paginationList);
                component.set("v.tableData", records);
    	},
    
    sortBy2: function(component, field){
        pageSize = component.get("v.pageSize2");	
        var sortAsc = component.get("v.sortAsc2"),
        sortField = component.get("v.sortField2"),
        records = component.get("v.tableData2");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAsc2", sortAsc);
        component.set("v.sortField2", field);
        component.set("v.tableData2", records);
        var end = component.get("v.end2");
        var start = component.get("v.start2");
        var pageSize = component.get("v.pageSize2");
        var paginationList = [];
         
        var paginationList = [];
                component.set("v.start2",0);
                component.set("v.end2",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(records[i]);    
    				}
                component.set("v.paginationList2", paginationList);
                component.set("v.tableData2", records);
    	},
    
    next : function(component, event, helper){
     	var accountList = component.get("v.tableData");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
                
        for(var i=end+1; i<end+pageSize+1; i++){
        	if(accountList.length > end){
          		paginationList.push(accountList[i]);
                counter ++ ;
         		}
        	}
        start = start + counter;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        
        component.set('v.paginationList', paginationList);
        },
    
    previous : function(component, event, helper){
     	var accountList = component.get("v.tableData");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
         
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
        	if(i > -1){
            	paginationList.push(accountList[i]);
                counter ++;
         		}
            else{
                start++;
            	}
        	}
        start = start - counter;
        end = end - counter;
        
        component.set("v.start",start);
        component.set("v.end",end);
        
        component.set('v.paginationList', paginationList);
 		},
    
    next2 : function(component, event, helper){
     	var accountList = component.get("v.tableData2");
        var end = component.get("v.end2");
        var start = component.get("v.start2");
        var pageSize = component.get("v.pageSize");
        var paginationList2 = [];
        var counter = 0;
                
        for(var i=end+1; i<end+pageSize+1; i++){
        	if(accountList.length > end){
          		paginationList2.push(accountList[i]);
                counter ++ ;
         		}
        	}
        start = start + counter;
        end = end + counter;
        
        component.set("v.start2",start);
        component.set("v.end2",end);
        
        component.set('v.paginationList2', paginationList2);
        },
    
    previous2 : function(component, event, helper){
     	var accountList = component.get("v.tableData2");
        var end = component.get("v.end2");
        var start = component.get("v.start2");
        var pageSize = component.get("v.pageSize");
        var paginationList2 = [];
         
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
        	if(i > -1){
            	paginationList2.push(accountList[i]);
                counter ++;
         		}
            else{
                start++;
            	}
        	}
        start = start - counter;
        end = end - counter;
        
        component.set("v.start2",start);
        component.set("v.end2",end);
        
        component.set('v.paginationList2', paginationList2);
 		},
    
    onTabChange : function(component, event, helper){
        var a = event.getSource();
		var id = a.getLocalId();
        console.log('localID: ' + id);
        if(id == 'reassignTab'){
            component.set("v.showFromSelection", true);
        	}
        else if(id != 'reassignTab'){
            component.set("v.showFromSelection", false);
        	}
        console.log('showFromSelection: ' + component.get("v.showFromSelection"));
    	},
    
    getTeamAssigned : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getTeamAssigned");
        action.setParams({
            "itemID" : component.get("v.selectedItemID", "v.value")
        	});
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
                var repList = response;
                component.set("v.modalList", repList);
				component.set("v.Spinner", false);
                resolve("Resolved");
            	}
			});
        	$A.enqueueAction(action);
        	});
    	},
    
    showModal : function(component, event, helper) {
    	 component.set("v.showModal", true);
    	},
    
    hideModal : function(component,event, helper){
    	component.set("v.showModal", false);
   		},
            
    fetchParentRoles : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.userRoleList", null);
        var action = component.get("c.fetchParentRoles");
        action.setParams({
            "strSelectedUser" : component.get("v.strSelectedUser", "v.value"),
            "strSelectedUserRole" : component.get("v.selectedUserRoleID", "v.value")
        	});
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
                component.set("v.userRoleList", response);
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
			});
        	$A.enqueueAction(action);
        	});
    	},
     
     fetchNewRoles : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.userRoleList", null);
        var action = component.get("c.fetchNewRoles");
        action.setParams({
            "strSelectedUser" : component.get("v.strSelectedUser", "v.value"),
            "strSelectedUserRole" : component.get("v.newRole", "v.value")
        	});
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
                component.set("v.userRoleList", response);
                var stockData = response;
                var newList = [];
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].roles[0];
                    newList.push(strng);
                	}
                var lstSize = newList.length;
                component.set("v.newSelectRole", newList[lstSize - 1]);
                console.log('New select role: ' + component.get("v.newSelectRole", "v.value"));
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
			});
        	$A.enqueueAction(action);
        	});
    	},
    
    setNewRole : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.setNewRole");
        var self = this;
        action.setParams({
            "newSelectedRole" : component.get("v.newSelectRole", "v.value"),
            "selectedUser" : component.get("v.selectedUser.selectedUser", "v.value")
        	});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
                var newRole = response;
                self.setUser(component).then(
            $A.getCallback(function(result){
            })
        )
        .then(
            $A.getCallback(function(result){
                return self.getReferralSourceCount(component, event, helper);
            })
        )
        .then(
            $A.getCallback(function(result){
                return self.fetchParentRoles(component, event, helper);      
            })
        )
        .catch(
            $A.getCallback(function(error){
                // Something went wrong
                alert('An error occurred : ' + error.message);
            })
        );
                alert("New role: " + newRole + " assigned to user.");
            	}
			});
        	$A.enqueueAction(action);
    	},
    
})