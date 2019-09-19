({
	getChoiceList : function(component, event, helper) {
		var action = component.get("c.getChoices");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                console.log('Choice List Fail');
                return;
            	}
            else{
                var repList = response;
                console.log('Choice List Success: ' + repList);
                component.set("v.choiceList", repList);
            	}
        	});
        $A.enqueueAction(action);
		},
    
    getAfterHoursID : function(component, event, helper){
        var action = component.get("c.getAfter");
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
            	}
        	});
        $A.enqueueAction(action);
    	},
    
    getGeneralID : function(component, event, helper){
        var action = component.get("c.getGeneral");
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
                }
        	});
        $A.enqueueAction(action);
    	},
})