({
	getAfterHoursID : function(component, event, helper){
        var action = component.get("c.getAfter");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            	}
            else{
                var repList = response;
                component.set("v.afterHours", repList);
            	}
        	});
        $A.enqueueAction(action);
    	},

})