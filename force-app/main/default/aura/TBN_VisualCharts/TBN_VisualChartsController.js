({
    handleComponentEvent : function(component, event, helper){
        console.log("Event: " + event.getParam("selReport"));
        if(event.getParam("selReport") == 'Accounts Without Activity' || event.getParam("selReport") == 'Accounts without Activity'){
        	helper.reportData(component, event);
        	helper.getTotalCount(component, event);
        	}
        else{
            component.set("v.showTotal", false);
            helper.reportData(component, event);
            }
    	},
    
    showDetail : function(component, event, helper){
        helper.reportTable(component, event, helper);
    	},
    
    // Load data from Apex Data Provider and draw chart.
    createChart1 : function(component, event, helper){
        var action = component.get("c.getReportVals");
		action.setParams({
            "selRole" : 'National',
            "selReport" : 'Accounts Without Activity',
            "selRoleName" : ''
        	}); 
        
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            if(response == null || response == "" || response == "[]" || response == "{}"){
                //Show toast Error
                return;
            	} 
            else{
                var repList = JSON.parse(response);
				component.set("v.chartlstData", repList);
                component.set("v.chartTitle", repList[0].label);
                component.set("v.chartData", repList[0].lstSNFRatio);
            	}
        	});
        $A.enqueueAction(action);
    	},
    
    sortAccountName : function(component, event, helper){
        helper.accountName(component, event, helper);
    	},
    
    sortOwner : function(component, event, helper){
        helper.owner(component, event, helper);
    	},
    
    sortActivity : function(component, event, helper){
        helper.activity(component, event, helper);
    	},
    
    sortRisk : function(component, event, helper){
        helper.risk(component, event, helper);
    	},
    
    sortRiskDate : function(component, event, helper){
        helper.riskDate(component, event, helper);
    	},
    
    sortTier : function(component, event, helper){
        helper.tier(component, event, helper);
    	},
    
    next : function(component, event, helper){
     	helper.next(component, event, helper);
 		},
    previous : function(component, event, helper){
     	helper.previous(component, event, helper);
 		},
    
    downloadCsv : function(component,event,helper){
        
        // get the Records list from 'tableData' attribute 
        var stockData = component.get("v.tableData");
        console.log('tableData: ' + component.get("v.tableData", "v.value"));
        var levelType = component.get("v.role");
        var reportType = component.get("v.report");
        console.log("Report Type: " + reportType);
        // call the helper function which "return" the CSV data as a String   
        if(levelType === 'National' || reportType === 'QBR Tracking' || reportType === 'Risk Account (SNF Only)' || reportType === 'Facility Reporting'){
        	var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        	}
        else{
            var csv = helper.convertArrayOfObjectsToCSV2(component,stockData);   
        	}
         if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = 'ExportData.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
        }, 
    
})