({
	
    evalBusUnits : function(component){
        var action = component.get("c.evalBusUnits");
        var fieldVar;
        var objType = component.get("v.objType");
        console.log("isKHRS?: " + component.get("v.isKHRS", "v.value"));
        if(objType === 'account'){
            fieldVar = component.get("v.acc.KRS_RHB_Business_Unit__c");
        	}
        else if(objType === 'contact'){
            fieldVar = component.get("v.ctc.Account.KRS_RHB_Business_Unit__c");
        	}
        else if(objType === 'lead'){
            fieldVar = 'HRS';
        	}
        
        return new Promise(function(resolve, reject){        
        action.setParams({
            	"isKRS" : component.get("v.isKHRS", "v.value"),
            	"busUnit" : fieldVar
        		});
        
        	action.setCallback(this, function(response){
		    	var state = response.getState();
            		console.log('Populate',state);
            	if(component.isValid() && state === "SUCCESS"){
                	var stringItems = response.getReturnValue();
                    component.set("v.rightBusUnit", stringItems);
                    console.log('Response: ' + stringItems);
                    resolve("Resolved");
                    }
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}
        });
        $A.enqueueAction(action);
        });
    	},
    
    populateItem : function(component){
		var action; 
        var account = false;
        var contact = false;
        var lead = false;
        var id = component.get("v.recordId");
        var objType = component.get("v.objType");
        console.log('ID: ' + id);
        if(objType === 'account'){
            action = component.get("c.getAccount");
        	contact = false;
            account = true;
            lead = false;
        	}
        else if(objType === 'contact'){
            action = component.get("c.getContact");
        	account = false;
            contact = true;
            lead = false;
        	}
        else if(objType === 'lead'){
            action = component.get("c.getLead");
        	account = false;
            contact = false;
            lead = true;
        	}
        console.log('action: ' + action);
		return new Promise(function(resolve, reject){        
        action.setParams({
            	"id" : component.get("v.recordId")
        		});
        
        	action.setCallback(this, function(response){
		    	var state = response.getState();
            		console.log('Populate',state);
            	if(component.isValid() && state === "SUCCESS"){
                	var stringItems = response.getReturnValue();
                    if(account === true){
                    	component.set("v.acc", stringItems); 
						component.set("v.accID", component.get("v.acc.Id", "v.value")); 
                    	}
                    else if(contact === true){
                        component.set("v.ctc", stringItems); 
						component.set("v.ctcID", component.get("v.ctc.Id", "v.value")); 
                    	}
                    else if(lead === true){
                        component.set("v.lead", stringItems); 
						component.set("v.leadID", component.get("v.lead.Id", "v.value")); 
                    	}
                    resolve("Resolved");
                    }
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}
        });
        $A.enqueueAction(action);
        });
		},
    
    findProfileType : function(component, event, helper){
        var action = component.get("c.assignProfileType");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Populate',state);
            if(component.isValid() && state === "SUCCESS"){
                component.set("v.isKHRS", response.getReturnValue());
                console.log("isKHRS?: " + component.get("v.isKHRS", "v.value"));
                resolve("Resolved");
            	}
            else if(state === "ERROR"){
                alert("Something went wrong, please try again, if error persists forward steps taken to an administrator.  This error may also occur if one of the selected records has an existing pending merge request as each record is only allowed one active request at a time.");
            }
        });
        $A.enqueueAction(action);
        });
    },
    
    sortBy: function(component, field){
        pageSize = component.get("v.pageSize");	
        var sortAsc = component.get("v.sortAsc"),
        sortField = component.get("v.sortField"),
        records = component.get("v.objectLst");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.objectLst", records);
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
                component.set("v.objectLst", records);
    	},
    
    searchRecords : function(component, event, helper){
    	var action; 
        var pageSize = component.get("v.pageSize");
        var id = component.get("v.recordId"); 
        var objType = component.get("v.objType");
        var account = false;
        var contact = false;
        var lead = false;
        component.set('v.accList', null);
        component.set('v.ctcList', null);
        component.set('v.leadList', null);
        component.set('v.paginationList', null);
        
        console.log('ID: ' + id);
        if(objType === 'account'){
            action = component.get("c.getAccountItems");
        	account = true;
            contact = false;
            lead = false;
        	}
        else if(objType === 'contact'){
            action = component.get("c.getContactItems");
        	account = false;
            contact = true;
        	lead = false;
        	}
        else if(objType === 'lead'){
            action = component.get("c.getLeadItems");
        	account = false;
            contact = false;
            lead = true;
        	}
        console.log('action: ' + action);        
        action.setParams({
            	"id" : component.get("v.recordId"),
            	"searchStr" : component.find("searchText").get("v.value"),
            	"cityFilter" : component.get("v.cityFilter"),
            	"stateFilter" : component.get("v.steFilter")
        		});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				component.set('v.objectLst', response);
                component.set("v.totalSize", component.get("v.objectLst").length);
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                var paginationList = [];
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set('v.paginationList', paginationList);
            	}
            });
        $A.enqueueAction(action);
		},
    
    next : function(component, event, helper){
     	var countList = component.get("v.objectLst");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++)
        {
         if(countList.length > end)
            {
          paginationList.push(countList[i]);
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
     	var countList = component.get("v.objectLst");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
         
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++)
        {
         if(i > -1)
            {
             paginationList.push(countList[i]);
                counter ++;
         }
            else
            {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        
        component.set("v.start",start);
        component.set("v.end",end);
        
        component.set('v.paginationList', paginationList);
 		},
    
    submitRequest : function(component){
        var action = component.get("c.getRequestMergeResult");
        var id = component.get("v.recordId"); 
        var arr = component.get("v.checkedTypes");
        let types = new Set();
        for(var i = 0; i < arr.length ; i++){
            console.log('Item: ' + arr[i]);
            types.add(arr[i]);
            console.log('length: ' + types.size);	
        	}
        if(types.size > 1){
            alert('Please review selections.  All records chosen for the merge must share the same record type.');
        	}
        else{ 
        action.setParams({
            	"objType" : component.get("v.objType"),
            	"accID" : component.get("v.recordId"),
        		"ctcID" : component.get("v.recordId"),
            	"leadId" : component.get("v.recordId"),
        		"checkedItems" : component.get("v.checkedItems"),
            	"additionalInstruct" : component.find("instructions").get("v.value")
            	});
        
        	action.setCallback(this, function(response){
		    	var state = response.getState();
            		console.log('Populate',state);
            	if(component.isValid() && state === "SUCCESS"){
                    alert("Complete: " + response.getReturnValue());
                    window.close();
                    }
            else if(state === "ERROR"){
                alert("Something went wrong, please try again, if error persists forward steps taken to an administrator.  This error may also occur if one of the selected records has an existing pending merge request as each record is only allowed one active request at a time.");
            	}
        });
        $A.enqueueAction(action);
        }
        },
    
    getStateList : function(component, event, helper) {
		var action = component.get("c.getStateList");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
                var repList = response;
                component.set("v.stateSelectList", repList);
                resolve("Resolved");
				}
			});
        $A.enqueueAction(action);
        });
		},
    
})