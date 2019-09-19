({
	getStageHistory : function(component, event, helper){
		var action = component.get("c.getStageHistory");
        var id = component.get("v.recordId");
        console.log('ID: ' + id);
        action.setParams({
            "id" : component.get("v.recordId")
        	});                	
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Populate',state);
            if(component.isValid() && state === "SUCCESS"){
                var stringItem = response.getReturnValue();
                component.set("v.stageList", stringItem);
            	}            	
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}        	
        	});
        $A.enqueueAction(action);
		}
})