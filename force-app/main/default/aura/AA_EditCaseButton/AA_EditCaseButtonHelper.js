({
	openCase : function(component, event, helper) {
		var action = component.get("c.getCaseAndNavigate");
        action.setParams({
            "recordID" : component.get("v.recordId", "v.value")
        	});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                return;
            	}
            else{
                var repList = response;
                component.set("v.caseID", repList);
                
                var navService = component.find("navService");
        				var pageReference = {
            			type: 'standard__recordPage',
            				attributes: {
                						actionName: 'edit',
                						objectApiName: 'Case',
                						recordId : component.get("v.caseID", "v.value") 
            							},
        					};
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
            				var focusedTabId = response.tabId;
            				component.set("v.pageReference", pageReference);
        					navService.navigate(pageReference);
                            })
                        .catch(function(error) {
            			console.log(error);
        				});
            	}
        	});
        $A.enqueueAction(action);
		}
})