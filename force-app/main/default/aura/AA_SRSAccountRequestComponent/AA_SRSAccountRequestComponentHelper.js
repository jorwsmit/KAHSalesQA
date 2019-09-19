({
    getOptions : function (component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getTypes");
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.accType", repList);
                component.set("v.Spinner", false);
            	}
            });
    		$A.enqueueAction(action);
    	},
    
    getStates : function (component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getStateList");
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.accState", repList);
                component.set("v.Spinner", false);
            	}
            });
    		$A.enqueueAction(action);
    	},
    
    submitAccount : function(component, event, helper){
    	component.set("v.Spinner", true);
        var action = component.get("c.processAccount");
        action.setParams({
                			"accName" : component.get("v.accName", "v.value"),
            				"accType" : component.find("InputSelectType").get("v.value"),
            				"accStreet" : component.get("v.accStreet", "v.value"),
            				"accCity" : component.get("v.accCity", "v.value"),
            				"accState" : component.find("InputSelectState").get("v.value"),
            				"accZip" : component.get("v.accZip", "v.value"),
            				"accPhone" : component.get("v.accPhone", "v.value"),
            				"accDefID" : component.get("v.accDefID", "v.value"),
            				"accNewConst" : component.get("v.accNewConst", "v.value")
            				});
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.response", repList);
                component.set("v.Spinner", false);
            	}
            });
    		$A.enqueueAction(action);
        },
    
    
})