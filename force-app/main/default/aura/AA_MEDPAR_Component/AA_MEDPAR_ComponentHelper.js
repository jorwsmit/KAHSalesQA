({	
    populateItem : function(component){
        var action = component.get("c.getMEDPARData");
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
                component.set("v.mData", stringItem);
                var medpar = component.get("v.mData","v.value");
                var medparID = component.get("v.mData.Id");
                console.log('Medpar: ' + medparID);
                if(medparID === undefined){
                    component.set("v.newEntry", true);
                	}
                }            	
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}        	
        	});
        $A.enqueueAction(action);
	    },
    
})