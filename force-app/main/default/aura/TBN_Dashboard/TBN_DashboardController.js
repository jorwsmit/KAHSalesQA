({
	doInit : function(component, event, helper){
		helper.getRole(component);
        helper.getReport(component);
        component.find("InputSelectRole").set("v.value", 'National'),
        component.find("InputSelectReport").set("v.value", 'Accounts Without Activity'),
        component.find("InputSelectRoleHierarchy").set("v.value", '--None Selected--')
		},
    
    
    showChart : function(component, event, helper){
        var inputCmp = component.find("InputSelectRoleHierarchy");
        // regular expression to match required date format
        if(component.find("InputSelectRole").get("v.value") != 'National' && (component.find("InputSelectRoleHierarchy").get("v.value") == '--None Selected--' || component.find("InputSelectRoleHierarchy").get("v.value") == null)){
            console.log('>>>>>>>');
            inputCmp.set("v.errors", [{message:"Please select picklist value "}]);
        	}
        else{
            inputCmp.set("v.errors", null);
	        console.log('=======here----1---');
            var appEvent = $A.get("e.c:DashboardEvent");
			appEvent.setParams({
                "selRole" : component.find("InputSelectRole").get("v.value"),
                "selReport" : component.find("InputSelectReport").get("v.value"),
                "selRoleName" : component.find("InputSelectRoleHierarchy").get("v.value"),
                "selIndividual" : component.find("InputSelectIndividual").get("v.value"),
                "selDteFrom" : component.find("InputDteFrom").get("v.value"),
                "selDteTo" : component.find("InputDteTo").get("v.value")
            });  
    		appEvent.fire();    
        	}
		},
    
    onRoleChange : function(component, event, helper) {
      	helper.disableSelectIndividual(component);
        helper.disableSelectRole(component);
        helper.getRoleNamePicklist(component);
    	},
    
    onRoleHierarchyChange : function(component, event, helper){
    	helper.disableSelectIndividual(component);
		},
    
    onReportChange : function(component, event, helper){
        helper.disableSelectRole(component);
        var searchbutton = component.find("searchButton");
        setTimeout(function(){ searchbutton.focus();  }, 20);
        if(component.find("InputSelectReport").get("v.value") == 'Facility Reporting'){
            helper.getRoleAlt(component, event, helper);
        	}
        else if(component.find("InputSelectReport").get("v.value") == 'ADO Activities'){
            helper.getRoleAlt2(component, event, helper);
        	}
        else{
            helper.getRole(component);
        	}
        helper.disableSelectIndividual(component);
        helper.getRoleNamePicklist(component);
    	}

})