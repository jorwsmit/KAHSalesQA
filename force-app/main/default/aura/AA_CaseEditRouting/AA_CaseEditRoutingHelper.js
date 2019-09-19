({
	getAfterHoursID : function(component, event, helper){
        var action = component.get("c.getAfter");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                console.log('AfterHours ID Fail');
                return;
            	}
            else{
                var repList = response;
                console.log('AfterHours ID Success: ' + repList);
                component.set("v.afterHours", repList);
            	resolve("Resolved");
            	}
        	});
        $A.enqueueAction(action);
        });
    	},
    
    getGeneralID : function(component, event, helper){
        var action = component.get("c.getGeneral");
        return new Promise(function(resolve, reject){
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                console.log('General ID Fail');
                return;
            	}
            else{
                var repList = response;
                console.log('General ID Success: ' + repList);
                component.set("v.generalCase", repList);
            	resolve("Resolved");
            	}
        	});
        $A.enqueueAction(action);
        });
    	},
    
    getCaseType : function(component, event, helper){
		var action = component.get("c.getCaseRecordType");
        return new Promise(function(resolve, reject){
            action.setParams({
                "recordId" : component.get("v.recordId", "v.value")
            	});
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                var state = a.getState();
                console.log('Find record type',state);
                if(component.isValid() && state !== "SUCCESS"){
                    console.log("Error in fetching Case Type.");
                    return;
                }
                else{
                    var repList = response;
                    component.set("v.recordType", repList);
                    console.log('recordType: ' + component.get("v.recordType", "v.value"));
                    resolve("Resolved");
                	}
            	});
            $A.enqueueAction(action);
        	});
		},
    
    setCaseID : function(component, event, helper){
		return new Promise(function(resolve, reject){
            var id = component.get("v.recordId", "v.value");
            var evt = $A.get("e.c:AA_LacunaCaseID");
            console.log('Setting Event value: ' + id);
			evt.setParams({"caseID": id});
			evt.fire();
            console.log('Event value after set: ' + evt.getParam("caseID"));
            component.set("v.storeID", id);
            resolve("Resolved");
            });
		},
    
    getCaseRoute : function(component, event, helper){
        return new Promise(function(resolve, reject){
        	var id = component.get("v.recordId", "v.value");
        	var type = component.get("v.recordType", "v.value");
        	var generalC = component.get("v.generalCase", "v.value");
            var afterH = component.get("v.afterHours", "v.value");
        if(type === afterH){
            console.log('After Hours');
            component.set("v.showGeneral", false);
            component.set("v.showAfterH", true);
            }
        else{
            console.log('General Case');
            component.set("v.showGeneral", true);
            component.set("v.showAfterH", false);
            }
            resolve("Resolved");
            });
    	},
})