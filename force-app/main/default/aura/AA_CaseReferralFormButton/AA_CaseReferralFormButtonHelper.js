({
	openForm : function(component, event, helper){
		        var repList = response;
                var focusedTabId;
            	var workspaceAPI = component.find("workspace");
             	workspaceAPI.getFocusedTabInfo().then(function(response) {
            				focusedTabId = response.tabId;
                	 	})
                        .catch(function(error) {
            			console.log(error);
        				});
                workspaceAPI.openTab({
            url: '/lightning/n/Referral_Status_Form',
            label: 'Status Form'
        	}).then(function(response) {
            workspaceAPI.focusTab({tabId : response});
       		})
        .catch(function(error) {
            console.log(error);
        });
            	
		}
})