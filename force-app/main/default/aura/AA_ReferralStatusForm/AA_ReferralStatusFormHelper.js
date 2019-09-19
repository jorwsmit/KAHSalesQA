({
	getAndDisplayForm : function(component, event, helper){
		var action = component.get("c.getFormDisplay");
        action.setParams({
            				"recordId" : component.get("v.recordId", "v.value")
        				});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            	}
            else{
                var repList = response;
                component.set("v.formDisplay", repList);
                var facType = component.get("v.formDisplay.facilityType", "v.value");
        		if(facType != undefined && facType !== null){
            		if(facType === 'HH'){
        				component.set("v.showHHForm", true);
            			}
            		else if(facType === 'HP'){
        				component.set("v.showHPForm", true);
            			}
            		else if(facType === 'PHCA' || facType === 'CC'){
        				component.set("v.showPHCAForm", true);
            			}
            		else if(facType === 'TCH' || facType === 'IRF' || facType === 'SAU'){
        				component.set("v.showLTACHForm", true);
            			}
            		else if(facType === 'IHPC'){
        				component.set("v.showIHPCForm", true);
            			}
            		}
        		}
        	});
        $A.enqueueAction(action);
		}
})