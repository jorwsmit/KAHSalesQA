({
	getValueFromEvent : function(component, event, helper){
    	var ShowResultValue = event.getParam("caseID");
        var recordId = component.get("v.recordId", "v.value");
        if(recordId === '' || recordId === null || recordId === undefined){
			console.log('ID present? ' + ShowResultValue);
        	component.set("v.recordId", ShowResultValue);
        	}
		},
    
    doInit : function(component, event, helper){
        helper.getAfterHoursID(component);
        var ShowResultValue = event.getParam("caseID");
        var recordId = component.get("v.recordId", "v.value");
        console.log('ID Present1: ' + recordId);
        if(recordId === '' || recordId === null || recordId === undefined){
			console.log('ID present2? ' + ShowResultValue);
        	component.set("v.recordId", ShowResultValue);
        	}
        component.set("v.pageURL", window.location.pathname);
        var urlState = component.get("v.pageURL", "v.value");
        console.log('urlState: ' + urlState);
        if(urlState.includes("view")){
            var focusedTabId;
            var workspaceAPI = component.find("workspace");
             workspaceAPI.getFocusedTabInfo().then(function(response) {
            				focusedTabId = response.tabId;
                 })
                        .catch(function(error) {
            			console.log(error);
        				});
                workspaceAPI.openTab({
            url: '/lightning/r/Case/' + recordId + '/view',
            label: 'After Hours Case'
        }).then(function(response) {
            workspaceAPI.focusTab({tabId : response});
       })
        .catch(function(error) {
            console.log(error);
        });
        	}
        },
    
    onCancel : function(component, event, helper){
        var focusedTabId;
            var workspaceAPI = component.find("workspace");
             workspaceAPI.getFocusedTabInfo().then(function(response) {
            				focusedTabId = response.tabId;
                 })
                        .catch(function(error) {
            			console.log(error);
        				});
                workspaceAPI.openTab({
            url: '/lightning/o/Case/list?filterName=Recent',
            label: 'Cases'
        }).then(function(response) {
            workspaceAPI.focusTab({tabId : response});
            workspaceAPI.closeTab({tabId: focusedTabId});
       })
        .catch(function(error) {
            console.log(error);
        });
    	},
})