({	
    populateItem : function(component){
        var action = component.get("c.getCMSData");
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
                component.set("v.cmsData", stringItem);
                component.set("v.cmsID", component.get("v.cmsData.Id"));
            	var year = component.get("v.cmsData.LastModifiedDate");
                if(year !== undefined){
                	var l = year.length;
                	year = year.substring(0, 4);
                    
                	component.set("v.dateVal", year);
                	}
            	}            	
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}        	
        	});
        $A.enqueueAction(action);
	    },
    
})