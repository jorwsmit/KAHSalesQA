({
	doInit : function(component, event, helper) {
		helper.getInitialRoleNames(component);
		component.set("v.selRoles2", null);
        component.set("v.selRoles3", null);
        component.set("v.selRoles4", null);
        component.set("v.selRoles5", null);
        component.set("v.selRoles6", null);
    	component.set("v.tableData", null);
        component.set("v.roleName", null);
        component.set("v.selectedUser", null);
        helper.getFirstUsersList(component);
    	},
    
    resetUserList : function(component, event, helper){
        component.set("v.selectList", null);
        component.set("v.searchString", "null");
        helper.getFirstUsersList(component);
    	},
    
    getSubRoles : function(component, event, helper){
        var id = event.getSource().getLocalId();
        component.set("v.currentList", id);
        var roleName = component.find(event.getSource().getLocalId()).get("v.value");
        component.set("v.roleName", roleName);
        component.set("v.btnDisabled", false);
        helper.getSubRoleNames(component);
    	},
    
    runReport : function(component, event, helper){
    	helper.getReport(component);
		},
    
    showSpinner : function(component, event, helper) {
        component.set("v.Spinner", true); 
    	},
    
    hideSpinner : function(component,event, helper){
        component.set("v.Spinner", false);
    	},
    
    onSet : function(component, event, helper){
        console.log("Selected User: " + component.find("inputSelectUser").get("v.value"));
        var setUser = component.find("inputSelectUser").get("v.value");
        component.set("v.selectedListUser", setUser);
        component.set("v.btnDisabled", false);
    	},
    
    sortName: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Name");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortEffective: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Effective_Date__c");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortEST: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "EST__c");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortAccount: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Account__r.Name");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortAccountId: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Account__r.Id");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortContact: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Contact__r.Name");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortContactId: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Contact__r.Id");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortHorizon: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Horizon_ID__c");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    sortUnity: function(component, event, helper) {
        var sortDir = component.get("v.isAsc");
        component.set("v.sortField", "Unity_ID__c");
        console.log('sortField: ' + component.get("v.sortField"));
        helper.getReport(component);
        if(sortDir === true){
            component.set("v.isAsc", false);
        	}
        else{
            component.set("v.isAsc", true);
        	}
    	},
    
    downloadCsv : function(component,event,helper){
        // get the Records list from 'tableData' attribute 
        var stockData = component.get("v.tableData");
        console.log('tableData: ' + component.get("v.tableData", "v.value"));
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        if(csv == null){
            return;
        	} 
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = 'ReferralData.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
        },
    
    onTabChange : function(component, event, helper){
        var a = event.getSource();
        var id = a.getLocalId();
        console.log('localID: ' + id);
        if(id === 'roleTab'){
            component.set("v.selectedListUser", null);
    		component.set("v.btnDisabled", true);
        	}
        else if(id === 'userTab'){
            component.set("v.roleName", null);
            component.set("v.btnDisabled", true);
        	}
    	},
    
    searchUsers : function(component, event, helper){
        var filter = component.get("v.searchString", "v.value");
        if(filter.length === 0){
        	helper.getFirstUsersList(component);	
        	}
        else{
            helper.getUsersList(component);
        	}
        },
    
})