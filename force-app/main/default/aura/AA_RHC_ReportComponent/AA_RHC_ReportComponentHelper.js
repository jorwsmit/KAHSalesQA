({
	getReports : function(component, event, helper) {
        component.set("v.Spinner", true);
		var action = component.get("c.getReportNames");
        action.setCallback(this, function(response){
			var state = response.getState();
            console.log('=====state======',state);
            if(component.isValid() && state === "SUCCESS") {
                	var stringItems = response.getReturnValue();
                	component.set("v.selReports", stringItems); 
                component.set("v.Spinner", false);
					}
            else if(state === "ERROR"){
                component.set("v.Spinner", false);
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	}
        	});
        $A.enqueueAction(action);
		},
    
    getAccounts : function(component, event, helper) {
        component.set("v.Spinner", true);
		var action = component.get("c.getAccounts");
        action.setCallback(this, function(response){
			var state = response.getState();
            console.log('=====state======',state);
            if(component.isValid() && state === "SUCCESS") {
                	var stringItems = response.getReturnValue();
                	component.set("v.selAccounts", stringItems); 
                component.set("v.Spinner", false);
					}
            else if(state === "ERROR"){
                component.set("v.Spinner", false);
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	}
        	});
        $A.enqueueAction(action);
		},
    
    getDVPTeams : function(component, event, helper){
        component.set("v.dvpList", null);
        component.set("v.paginationListDVP", null);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getDVPTeams");
        action.setParams({
            "accName" : component.find("InputSelectAccount").get("v.value")
        	});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationListDVP", paginationList);
                component.set("v.dvpList", response);
            	}
			});
        $A.enqueueAction(action);
        },
    
    getDVPActivities : function(component, event, helper){
        component.set("v.dvpListAct", null);
        component.set("v.paginationListDVPAct", null);
        var pageSize = component.get("v.pageSize2");
        var action = component.get("c.getDVPActivities");
        action.setParams({
            "accName" : component.find("InputSelectAccount").get("v.value")
        	});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationListDVPAct", paginationList);
                component.set("v.dvpListAct", response);
            	}
			});
        $A.enqueueAction(action);
        },
    
    getRVPTeams : function(component, event, helper){
        component.set("v.rvpList", null);
        component.set("v.paginationListRVP", null);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getRVPTeams");
        action.setParams({
            "accName" : component.find("InputSelectAccount").get("v.value")
        	});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationListRVP", paginationList);
                component.set("v.rvpList", response);
            	}
			});
        $A.enqueueAction(action);
    	},
    
    getRVPActivities : function(component, event, helper){
        component.set("v.rvpListAct", null);
        component.set("v.paginationListRVPAct", null);
        var pageSize = component.get("v.pageSize2");
        var action = component.get("c.getRVPActivities");
        action.setParams({
            "accName" : component.find("InputSelectAccount").get("v.value")
        	});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationListRVPAct", paginationList);
                component.set("v.rvpListAct", response);
            	}
			});
        $A.enqueueAction(action);
    	},
    
    getADOTeams : function(component, event, helper){
        component.set("v.adoList", null);
        component.set("v.paginationListADO", null);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getADOTeams");
        action.setParams({
            "accName" : component.find("InputSelectAccount").get("v.value")
        	});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationListADO", paginationList);
                component.set("v.adoList", response);
            	}
			});
        $A.enqueueAction(action);
    	},
    
    getADOActivities : function(component, event, helper){
        component.set("v.adoListAct", null);
        component.set("v.paginationListADOAct", null);
        var pageSize = component.get("v.pageSize2");
        var action = component.get("c.getADOActivities");
        action.setParams({
            "accName" : component.find("InputSelectAccount").get("v.value")
        	});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationListADOAct", paginationList);
                component.set("v.adoListAct", response);
            	}
			});
        $A.enqueueAction(action);
    	},
    
    getFacility : function(component, event, helper){
    	var action = component.get("c.getFacility");
        action.setParams({
            			"accName" : component.find("InputSelectAccount").get("v.value")
            			}); 
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
                var repList = response;
                component.set("v.facility", repList);
                }
            });
        $A.enqueueAction(action);
		},
    
    disableSelectAccount : function(component){
        var inputSelReport = component.find("InputSelectReport");
        var inputAcc = component.find("InputSelectAccount");
        if(component.find("InputSelectReport").get("v.value") == 'Contacts Reporting' || component.find("InputSelectReport").get("v.value") == 'Activity Reporting'){
     		inputAcc.set("v.disabled", false); 
            }
        else{
            inputAcc.set("v.disabled", true);
            }
		},
    
    runReport : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.tableData", null);
        component.set("v.paginationList", null);
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.getReportTable");
        action.setParams({
            "selReport" : component.find("InputSelectReport").get("v.value"),
            "accName" : component.find("InputSelectAccount").get("v.value")
        	});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set("v.paginationList", paginationList);
                component.set("v.tableData", response);
                component.set("v.Spinner", false);
            	}
			});
        $A.enqueueAction(action);
    	},
    
    next : function(component, event, helper){
     	var accountList = component.get("v.tableData");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
         if(accountList.length > end){
         	paginationList.push(accountList[i]);
            counter ++ ;
         	}
        	}
        start = start + counter;
        end = end + counter;
        
        component.set("v.start",start);
        component.set("v.end",end);
        
        component.set('v.paginationList', paginationList);
 		},
    
    previous : function(component, event, helper){
     	var accountList = component.get("v.tableData");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
         
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
        	if(i > -1){
            	paginationList.push(accountList[i]);
                counter ++;
         		}
            else{
                start++;
            	}
        	}
        start = start - counter;
        end = end - counter;
        
        component.set("v.start",start);
        component.set("v.end",end);
        
        component.set('v.paginationList', paginationList);
 		},
    
    sortByContact: function(component, field){
        pageSize = component.get("v.pageSize");	
        var sortAsc = component.get("v.sortAscContact"),
        sortField = component.get("v.sortFieldContact"),
        records = component.get("v.tableData");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAscContact", sortAsc);
        component.set("v.sortFieldContact", field);
        component.set("v.tableData", records);
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
         
        var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(records[i]);    
    				}
                component.set("v.paginationList", paginationList);
                component.set("v.tableData", records);
    	},
    
    sortByDVP: function(component, field){
        pageSize = component.get("v.pageSize");	
        var sortAsc = component.get("v.sortAscDVP"),
        sortField = component.get("v.sortField"),
        records = component.get("v.dvpListAct");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAscDVP", sortAsc);
        component.set("v.sortFieldDVP", field);
        component.set("v.dvpListAct", records);
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize2");
        var paginationList = [];
         
        var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(records[i]);    
    				}
                component.set("v.paginationListDVPAct", paginationList);
                component.set("v.dvpListAct", records);
    	},
    
    sortByRVP: function(component, field){
        pageSize = component.get("v.pageSize2");	
        var sortAsc = component.get("v.sortAscRVP"),
        sortField = component.get("v.sortFieldRVP"),
        records = component.get("v.rvpListAct");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAscRVP", sortAsc);
        component.set("v.sortFieldRVP", field);
        component.set("v.rvpListAct", records);
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize2");
        var paginationList = [];
         
        var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(records[i]);    
    				}
                component.set("v.paginationListRVPAct", paginationList);
                component.set("v.rvpListAct", records);
    	},
    
    sortByADO: function(component, field){
        pageSize = component.get("v.pageSize2");	
        var sortAsc = component.get("v.sortAscADO"),
        sortField = component.get("v.sortFieldADO"),
        records = component.get("v.adoListAct");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAscADO", sortAsc);
        component.set("v.sortFieldADO", field);
        component.set("v.adoListAct", records);
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize2");
        var paginationList = [];
         
        var paginationList = [];
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(records[i]);    
    				}
                component.set("v.paginationListADOAct", paginationList);
                component.set("v.adoListAct", records);
    	},
    
    getAllRHBActive : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.accountTeamAndADO", null);
        var action = component.get("c.getAllRHBActive");
        action.setParams({
                			"letterStart" : component.get("v.letterStart", "v.value"),
            				"letterEnd" : component.get("v.letterEnd", "v.value"),
            				"ADO_Filter" : component.get("v.selectedADO", "v.value"),
            				"RVP_Filter" : component.get("v.selectedRVP", "v.value"),
            				"DVP_Filter" : component.get("v.selectedDVP", "v.value")
            				});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.accountTeamAndADO", response);
                component.set("v.Spinner", false);
            	}
			});
        $A.enqueueAction(action);
    	},
    
    getAllNPSPDPMActive : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.NPSActivityList", null);
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'NPS Activity Report'){
        	var action = component.get("c.getNPSTasks");
        	}
        else if(report.includes("PDPM")){
            var action = component.get("c.getPDPMTasks");
        	}
        action.setParams({
                			"letterStart" : component.get("v.letterStart", "v.value"),
            				"letterEnd" : component.get("v.letterEnd", "v.value"),
            				"ADO_Filter" : component.get("v.selectedADO", "v.value"),
            				"RVP_Filter" : component.get("v.selectedRVP", "v.value"),
            				"DVP_Filter" : component.get("v.selectedDVP", "v.value"),
            				"reportName" : report
            				});
        action.setStorable();
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                component.set("v.Spinner", false);
                return;
            	} 
            else{
				var repList = response;
                component.set("v.NPSActivityList", response);
                component.set("v.Spinner", false);
            	}
			});
        $A.enqueueAction(action);
    	},
    
    convertArrayOfObjectsToCSVAllAccount : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        console.log('objectRecords Processing: ' + objectRecords);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length){
            console.log('Why is this broken?');
            return null;
         	}
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['Name','Title','Email', 'Account', 'Product Type', 'Start Date', 'Last Date of Service', 'SAP', 'SMART'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 		for(var i=0; i < objectRecords.length; i++){
            counter = 0;
            if(objectRecords[i].ados !== undefined){
            for(var x = 0; x < objectRecords[i].ados.length; x++){
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].ados[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].ados[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].ados[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].ados[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].ados[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].ados[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
        		}
            }
            if(objectRecords[i].dvps !== undefined){
            for(var x = 0; x < objectRecords[i].dvps.length; x++){
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].dvps[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].dvps[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].dvps[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].dvps[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].dvps[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].dvps[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
        		}
            }
            if(objectRecords[i].rvps !== undefined){
            for(var x = 0; x < objectRecords[i].rvps.length; x++){
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].rvps[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].rvps[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].rvps[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].rvps[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].rvps[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].rvps[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
        		}
            }
            if(objectRecords[i].cTeam !== undefined){
            for(var x = 0; x < objectRecords[i].cTeam.length; x++){
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].cTeam[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].cTeam[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].cTeam[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].cTeam[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].cTeam[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].cTeam[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
            	}
        		}
            if(objectRecords[i].cons !== undefined){
            for(var x = 0; x < objectRecords[i].cons.length; x++){
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].cons[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].cons[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].cons[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].cons[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].cons[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].cons[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
            	}
        		}
           }// outer main for loop close 
       	// return the CSV formate String 
        return csvStringResult;        
    	},
    
    getADOList : function(component, event, helper){
    	var action = component.get("c.getADOs");
        action.setCallback(this, function(response){
			var state = response.getState();
            console.log('=====state======',state);
            if(component.isValid() && state === "SUCCESS") {
                	var stringItems = response.getReturnValue();
                
                var options = [];
                for(var i = 0; i < stringItems.length; i++){ 
                    options.push({ value: stringItems[i], label: stringItems[i]});
                }
                component.set("v.adoListChoose", options); 
					}
            else if(state === "ERROR"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	}
        	});
        $A.enqueueAction(action);
		},
            
    getRVPList : function(component, event, helper){
    	var action = component.get("c.getRVPs");
        action.setCallback(this, function(response){
			var state = response.getState();
            console.log('=====state======',state);
            if(component.isValid() && state === "SUCCESS") {
                	var stringItems = response.getReturnValue();
                var options = [];
                for(var i = 0; i < stringItems.length; i++){ 
                    options.push({ value: stringItems[i], label: stringItems[i]});
                }
                	component.set("v.rvpListChoose", options); 
					}
            else if(state === "ERROR"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	}
        	});
        $A.enqueueAction(action);
		},
    
    getDVPList : function(component, event, helper){
    	var action = component.get("c.getDVPs");
        action.setCallback(this, function(response){
			var state = response.getState();
            console.log('=====state======',state);
            if(component.isValid() && state === "SUCCESS") {
                	var stringItems = response.getReturnValue();
                var options = [];
                for(var i = 0; i < stringItems.length; i++){ 
                    options.push({ value: stringItems[i], label: stringItems[i]});
                }
                	component.set("v.dvpListChoose", options); 
					}
            else if(state === "ERROR"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	}
        	});
        $A.enqueueAction(action);
		},
    
    getAllRHBRows : function(component, startLetter){
        var start;
        var end;
        if(startLetter === 'A'){
            console.log('A');
            component.set("v.processingFinished", false);
            start = 'a';
            end = 'b';
            component.set("v.aList", null);
        	}
        else if(startLetter === 'B'){
            console.log('B');
            start = 'b';
            end = 'c';
            component.set("v.bList", null);
        	}
        else if(startLetter === 'C'){
            console.log('C');
            start = 'c';
            end = 'd';
            component.set("v.cList", null);
        	}
        else if(startLetter === 'D'){
            console.log('D');
            start = 'd';
            end = 'e';
            component.set("v.dList", null);
        	}
        else if(startLetter === 'E'){
            console.log('E');
            start = 'e';
            end = 'f';
            component.set("v.eList", null);
        	}
        else if(startLetter === 'F'){
            console.log('F');
            start = 'f';
            end = 'g';
            component.set("v.fList", null);
        	}
        else if(startLetter === 'G'){
            console.log('G');
            start = 'g';
            end = 'h';
            component.set("v.gList", null);
        	}
        else if(startLetter === 'H'){
            console.log('H');
            start = 'h';
            end = 'i';
            component.set("v.hList", null);
        	}
        else if(startLetter === 'I'){
            console.log('I');
            start = 'i';
            end = 'j';
            component.set("v.iList", null);
        	}
        else if(startLetter === 'J'){
            console.log('J');
            start = 'j';
            end = 'k';
            component.set("v.jList", null);
        	}
        else if(startLetter === 'K'){
            console.log('K');
            start = 'k';
            end = 'l';
            component.set("v.kList", null);
        	}
        else if(startLetter === 'L'){
            console.log('L');
            start = 'l';
            end = 'm';
            component.set("v.lList", null);
        	}
        else if(startLetter === 'M'){
            console.log('M');
            start = 'm';
            end = 'n';
            component.set("v.mList", null);
            }
        else if(startLetter === 'N'){
            console.log('N');
            start = 'n';
            end = 'o';
            component.set("v.nList", null);
        	}
        else if(startLetter === 'O'){
            console.log('O');
            start = 'o';
            end = 'p';
            component.set("v.oList", null);
        	}
        else if(startLetter === 'P'){
            console.log('P');
            start = 'p';
            end = 'q';
            component.set("v.pList", null);
        	}
        else if(startLetter === 'Q'){
            console.log('Q');
            start = 'q';
            end = 'r';
            component.set("v.qList", null);
        	}
        else if(startLetter === 'R'){
            console.log('R');
            start = 'r';
            end = 's';
            component.set("v.rList", null);
        	}
        else if(startLetter === 'S'){
            console.log('S');
            start = 's';
            end = 't';
            component.set("v.sList", null);
        	}
        else if(startLetter === 'T'){
            console.log('T');
            start = 't';
            end = 'u';
            component.set("v.tList", null);
        	}
        else if(startLetter === 'U'){
            console.log('U');
            start = 'u';
            end = 'v';
            component.set("v.uList", null);
        	}
        else if(startLetter === 'V'){
            console.log('V');
            start = 'v';
            end = 'w';
            component.set("v.vList", null);
        	}
        else if(startLetter === 'W'){
            console.log('W');
            start = 'w';
            end = 'zz';
            component.set("v.wList", null);
        	}
        /*else if(startLetter === 'X'){
            console.log('X');
            start = 'x';
            end = 'y';
            component.set("v.xList", null);
        	}
        else if(startLetter === 'Y'){
            console.log('Y');
            start = 'y';
            end = 'z';
            component.set("v.yList", null);
        	}
        else if(startLetter === 'Z'){
            console.log('Z');
            start = 'z';
            end = 'zz';
            component.set("v.zList", null);
        	}*/
        var action = component.get("c.getAllRHBActive");
        action.setParams({
                			"letterStart" : start,
            				"letterEnd" : end,
            				"ADO_Filter" : component.get("v.selectedADO", "v.value"),
            				"RVP_Filter" : component.get("v.selectedRVP", "v.value"),
            				"DVP_Filter" : component.get("v.selectedDVP", "v.value")
            				});
        return new Promise(function (resolve, reject) {
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    
				var repList = response;
                if(startLetter === 'A'){
            component.set("v.aList", repList);
        	}
        else if(startLetter === 'B'){
            component.set("v.bList", repList);
        	}
        else if(startLetter === 'C'){
            component.set("v.cList", repList);
        	}
        else if(startLetter === 'D'){
            component.set("v.dList", repList);
        	}
        else if(startLetter === 'E'){
            component.set("v.eList", repList);
        	}
        else if(startLetter === 'F'){
            component.set("v.fList", repList);
        	}
        else if(startLetter === 'G'){
            component.set("v.gList", repList);
        	}
        else if(startLetter === 'H'){
            component.set("v.hList", repList);
        	}
        else if(startLetter === 'I'){
            component.set("v.iList", repList);
        	}
        else if(startLetter === 'J'){
            component.set("v.jList", repList);
        	}
        else if(startLetter === 'K'){
            component.set("v.kList", repList);
        	}
        else if(startLetter === 'L'){
            component.set("v.lList", repList);
        	}
        else if(startLetter === 'M'){
            component.set("v.mList", repList);
        	}
        else if(startLetter === 'N'){
            component.set("v.nList", repList);
        	}
        else if(startLetter === 'O'){
            component.set("v.oList", repList);
        	}
        else if(startLetter === 'P'){
            component.set("v.pList", repList);
        	}
        else if(startLetter === 'Q'){
            component.set("v.qList", repList);
        	}
        else if(startLetter === 'R'){
            component.set("v.rList", repList);
        	}
        else if(startLetter === 'S'){
            component.set("v.sList", repList);
        	}
        else if(startLetter === 'T'){
            component.set("v.tList", repList);
        	}
        else if(startLetter === 'U'){
            component.set("v.uList", repList);
        	}
        else if(startLetter === 'V'){
            component.set("v.vList", repList);
        	}
        else if(startLetter === 'W'){
            component.set("v.wList", repList);
            component.set("v.processingFinished", true);
            console.log("Processing Done");
        	}/*
        else if(startLetter === 'X'){
            component.set("v.xList", repList);
        	}
        else if(startLetter === 'Y'){
            component.set("v.yList", repList);
        	}
        else if(startLetter === 'Z'){
            component.set("v.processingFinished", true);
            console.log("Processing Done");
            component.set("v.zList", repList);
        	}*/
                resolve("Resolved");
                
			});
        $A.enqueueAction(action);
            });
    	},
    
    getAllNPSPDPMRows : function(component, startLetter){
        var start;
        var end;
        var selectedReport = component.find("InputSelectReport").get("v.value");
        if(startLetter === 'A'){
            console.log('A');
            component.set("v.processingFinished", false);
            start = 'a';
            end = 'b';
            component.set("v.aList", null);
        	}
        else if(startLetter === 'B'){
            console.log('B');
            start = 'b';
            end = 'c';
            component.set("v.bList", null);
        	}
        else if(startLetter === 'C'){
            console.log('C');
            start = 'c';
            end = 'd';
            component.set("v.cList", null);
        	}
        else if(startLetter === 'D'){
            console.log('D');
            start = 'd';
            end = 'e';
            component.set("v.dList", null);
        	}
        else if(startLetter === 'E'){
            console.log('E');
            start = 'e';
            end = 'f';
            component.set("v.eList", null);
        	}
        else if(startLetter === 'F'){
            console.log('F');
            start = 'f';
            end = 'g';
            component.set("v.fList", null);
        	}
        else if(startLetter === 'G'){
            console.log('G');
            start = 'g';
            end = 'h';
            component.set("v.gList", null);
        	}
        else if(startLetter === 'H'){
            console.log('H');
            start = 'h';
            end = 'i';
            component.set("v.hList", null);
        	}
        else if(startLetter === 'I'){
            console.log('I');
            start = 'i';
            end = 'j';
            component.set("v.iList", null);
        	}
        else if(startLetter === 'J'){
            console.log('J');
            start = 'j';
            end = 'k';
            component.set("v.jList", null);
        	}
        else if(startLetter === 'K'){
            console.log('K');
            start = 'k';
            end = 'l';
            component.set("v.kList", null);
        	}
        else if(startLetter === 'L'){
            console.log('L');
            start = 'l';
            end = 'm';
            component.set("v.lList", null);
        	}
        else if(startLetter === 'M'){
            console.log('M');
            start = 'm';
            end = 'n';
            component.set("v.mList", null);
            }
        else if(startLetter === 'N'){
            console.log('N');
            start = 'n';
            end = 'o';
            component.set("v.nList", null);
        	}
        else if(startLetter === 'O'){
            console.log('O');
            start = 'o';
            end = 'p';
            component.set("v.oList", null);
        	}
        else if(startLetter === 'P'){
            console.log('P');
            start = 'p';
            end = 'q';
            component.set("v.pList", null);
        	}
        else if(startLetter === 'Q'){
            console.log('Q');
            start = 'q';
            end = 'r';
            component.set("v.qList", null);
        	}
        else if(startLetter === 'R'){
            console.log('R');
            start = 'r';
            end = 's';
            component.set("v.rList", null);
        	}
        else if(startLetter === 'S'){
            console.log('S');
            start = 's';
            end = 't';
            component.set("v.sList", null);
        	}
        else if(startLetter === 'T'){
            console.log('T');
            start = 't';
            end = 'u';
            component.set("v.tList", null);
        	}
        else if(startLetter === 'U'){
            console.log('U');
            start = 'u';
            end = 'v';
            component.set("v.uList", null);
        	}
        else if(startLetter === 'V'){
            console.log('V');
            start = 'v';
            end = 'w';
            component.set("v.vList", null);
        	}
        else if(startLetter === 'W'){
            console.log('W');
            start = 'w';
            end = 'zz';
            component.set("v.wList", null);
        	}
        /*else if(startLetter === 'X'){
            console.log('X');
            start = 'x';
            end = 'y';
            component.set("v.xList", null);
        	}
        else if(startLetter === 'Y'){
            console.log('Y');
            start = 'y';
            end = 'z';
            component.set("v.yList", null);
        	}
        else if(startLetter === 'Z'){
            console.log('Z');
            start = 'z';
            end = 'zz';
            component.set("v.zList", null);
        	}*/
        if(selectedReport.includes("PDPM")){
        	var action = component.get("c.getPDPMTasks");
        	}
        else{
            var action = component.get("c.getNPSTasks");
        	}
        action.setParams({
                			"letterStart" : start,
            				"letterEnd" : end,
            				"ADO_Filter" : component.get("v.selectedADO", "v.value"),
            				"RVP_Filter" : component.get("v.selectedRVP", "v.value"),
            				"DVP_Filter" : component.get("v.selectedDVP", "v.value"),
            				"reportName" : selectedReport
            				});
        return new Promise(function (resolve, reject) {
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    
				var repList = response;
                if(startLetter === 'A'){
            component.set("v.aList", repList);
        	}
        else if(startLetter === 'B'){
            component.set("v.bList", repList);
        	}
        else if(startLetter === 'C'){
            component.set("v.cList", repList);
        	}
        else if(startLetter === 'D'){
            component.set("v.dList", repList);
        	}
        else if(startLetter === 'E'){
            component.set("v.eList", repList);
        	}
        else if(startLetter === 'F'){
            component.set("v.fList", repList);
        	}
        else if(startLetter === 'G'){
            component.set("v.gList", repList);
        	}
        else if(startLetter === 'H'){
            component.set("v.hList", repList);
        	}
        else if(startLetter === 'I'){
            component.set("v.iList", repList);
        	}
        else if(startLetter === 'J'){
            component.set("v.jList", repList);
        	}
        else if(startLetter === 'K'){
            component.set("v.kList", repList);
        	}
        else if(startLetter === 'L'){
            component.set("v.lList", repList);
        	}
        else if(startLetter === 'M'){
            component.set("v.mList", repList);
        	}
        else if(startLetter === 'N'){
            component.set("v.nList", repList);
        	}
        else if(startLetter === 'O'){
            component.set("v.oList", repList);
        	}
        else if(startLetter === 'P'){
            component.set("v.pList", repList);
        	}
        else if(startLetter === 'Q'){
            component.set("v.qList", repList);
        	}
        else if(startLetter === 'R'){
            component.set("v.rList", repList);
        	}
        else if(startLetter === 'S'){
            component.set("v.sList", repList);
        	}
        else if(startLetter === 'T'){
            component.set("v.tList", repList);
        	}
        else if(startLetter === 'U'){
            component.set("v.uList", repList);
        	}
        else if(startLetter === 'V'){
            component.set("v.vList", repList);
        	}
        else if(startLetter === 'W'){
            component.set("v.wList", repList);
            component.set("v.processingFinished", true);
            console.log("Processing Done");
        	}/*
        else if(startLetter === 'X'){
            component.set("v.xList", repList);
        	}
        else if(startLetter === 'Y'){
            component.set("v.yList", repList);
        	}
        else if(startLetter === 'Z'){
            component.set("v.processingFinished", true);
            console.log("Processing Done");
            component.set("v.zList", repList);
        	}*/
                resolve("Resolved");
                
			});
        $A.enqueueAction(action);
            });
    	},
    
    convertArrayOfObjectsToCSVNPS : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        console.log('objectRecords Processing PDPM: ' + objectRecords);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length){
            return null;
         	}
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['Name','Title','Email', 'Account', 'Product Type', 'Start Date', 'Last Date of Service', 'SAP', 'SMART', 'Assigned', 'Subject', 'NPS Score', 'Date', 'Priority', 'Status', 'Full Comments', 'Last Modified Date', 'Company/Account', 'Contact'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 		for(var i=0; i < objectRecords.length; i++){
            counter = 0;
            if(objectRecords[i].ados !== undefined){
            for(var x = 0; x < objectRecords[i].ados.length; x++){
                console.log('Ado List start');
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].ados[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].ados[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].ados[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].ados[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].ados[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].ados[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
        		}
            }
            if(objectRecords[i].dvps !== undefined){
            for(var x = 0; x < objectRecords[i].dvps.length; x++){
                console.log('DVP List start');
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].dvps[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].dvps[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].dvps[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].dvps[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].dvps[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].dvps[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
        		}
            }
            if(objectRecords[i].rvps !== undefined){
            for(var x = 0; x < objectRecords[i].rvps.length; x++){
                console.log('RVP List start');
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Name'){
                     if(objectRecords[i].rvps[x].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].rvps[x].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Title'){
                     if(objectRecords[i].rvps[x].Title !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].rvps[x].Title+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Email'){
                     if(objectRecords[i].rvps[x].Email !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].rvps[x].Email+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account'){
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
        		}
            }
            if(objectRecords[i].tasks !== undefined){
            for(var x = 0; x < objectRecords[i].tasks.length; x++){
                console.log('Task List start');
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }
                 if(skey == 'Assigned'){
                     console.log('Task Owner Name');
                     if(objectRecords[i].tasks[x].Owner.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].Owner.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'Subject'){
                     if(objectRecords[i].tasks[x].Subject !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].Subject+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'NPS Score'){
                     if(objectRecords[i].tasks[x].PF_NPS_Score__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].PF_NPS_Score__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Date'){
                     if(objectRecords[i].tasks[x].ActivityDate !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].ActivityDate+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                 else if(skey == 'Priority'){
                     if(objectRecords[i].tasks[x].Priority !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].Priority+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Status'){
                     if(objectRecords[i].tasks[x].Status !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].Status+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                 else if(skey == 'Full Comments'){
                     if(objectRecords[i].tasks[x].Description !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].Description+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 } 
                 else if(skey == 'Last Modified Date'){
                     if(objectRecords[i].tasks[x].LastModifiedDate !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].LastModifiedDate+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Modified Date'){
                     if(objectRecords[i].tasks[x].LastModifiedDate !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].LastModifiedDate+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                 else if(skey == 'Account'){
                     console.log('Task Account Name1');
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                    else if(skey == 'Company/Account'){
                        console.log('Task Account Name2');
                     if(objectRecords[i].a.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Contact'){
                     console.log('Task Contact Name');
                     console.log(objectRecords[i].tasks[x]);
                     if(objectRecords[i].tasks[x].Who !== undefined){
                     if(objectRecords[i].tasks[x].Who.Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].tasks[x].Who.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                     }
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                 else if(skey == 'Product Type'){
                     if(objectRecords[i].a.PF_Product_Type__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Product_Type__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Start Date'){
                     if(objectRecords[i].a.PF_Start_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Start_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Last Date of Service'){
                     if(objectRecords[i].a.PF_Last_Date_of_Service__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Last_Date_of_Service__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SAP'){
                     if(objectRecords[i].a.PF_SAP_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_SAP_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'SMART'){
                     if(objectRecords[i].a.PF_Smart_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].a.PF_Smart_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                 counter++; 
               	}
                counter = 0;
                csvStringResult += lineDivider;
            	}
        		}
           }// outer main for loop close 
       	// return the CSV formate String 
        return csvStringResult;        
    	},
    
})