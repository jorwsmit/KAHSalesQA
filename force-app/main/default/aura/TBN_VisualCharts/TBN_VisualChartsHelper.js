({
    // Draw chart using chart.js.
    // If chart instance already exists, it will be destroyed and re-created.
    
    reportData : function(component, event){
        component.set("v.showChart", false);
        component.set("v.chartData", null);
        var action = component.get("c.getReportVals");
        component.set("v.report", event.getParam("selReport"));
        component.set("v.person", event.getParam("selIndividual"));
        component.set("v.role", event.getParam("selRole"));
        component.set("v.roleName", event.getParam("selRoleName"));
        component.set("v.dteFrom", event.getParam("selDteFrom"));
        component.set("v.dteTo", event.getParam("selDteTo"));
		action.setParams({
            "selRole" : event.getParam("selRole"),
            "selReport" : event.getParam("selReport"),
            "selRoleName" : event.getParam("selRoleName"),
            "selIndividual" : event.getParam("selIndividual"),
            "SelDteFrom" : event.getParam("selDteFrom"),
            "SelDteTo" : event.getParam("selDteTo")
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
				var arr = [];
				var repList = JSON.parse(response);
                component.set("v.chartlstCount", repList.length);
				for(var i = 0; i < repList.length; i++){ 
					//this.drawChart(component, JSON.parse(response));
                   var lstRep = repList[i].lstSNFRatio; 
					component.set("v.chartTitle", repList[i].label);
                	component.set("v.chartData", lstRep);
                    arr.push(repList[i]);
                component.set("v.showButton", true);   
                }
				component.set("v.chartlstData", arr);
            	}
			});
        $A.enqueueAction(action);
        },
    
    getTotalCount : function(component, event){
        console.log('Start Total ');
        var action = component.get("c.getTotalAccounts");
        action.setParams({
            "selRole" : component.get("v.role", "v.value"),
            "selRoleName" : component.get("v.roleName", "v.value"),
            "selIndividual" : component.get("v.person", "v.value")
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
				var repList = JSON.parse(response);
                component.set("v.totalAccounts", repList);
                console.log("total:" + component.get("v.totalAccounts"));
                component.set("v.showTotal", true);
                }
			});
        	$A.enqueueAction(action);
        },
    
    reportTable : function(component, event, helper){
        var action = component.get("c.getReportTable");
        var pageSize = component.get("v.pageSize");
        component.set("v.paginationList", null);
        component.set('v.tableData', null);
        component.set("v.showChart", true);
		action.setParams({
            "selRole" : component.get("v.role", "v.value"),
            "selReport" : component.get("v.report", "v.value"),
            "selRoleName" : component.get("v.roleName", "v.value"),
            "selIndividual" : component.get("v.person", "v.value"),
            "SelDteFrom" : component.get("v.dteFrom", "v.value"),
            "SelDteTo" : component.get("v.dteTo", "v.value")
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
                if(component.get("v.report", "v.value") != 'ADO Activities'){
					var repList = JSON.parse(response);
                	console.log('===repList====',repList);
               		component.set("v.tableTitle", component.get("v.report", "v.value"));
                	component.set('v.tableData', repList);
                	component.set("v.totalSize", component.get("v.tableData").length);
                	component.set("v.start",0);
                	component.set("v.end",pageSize-1);
                	component.set("v.tableData", repList);
            		var paginationList = [];
                	for(var i=0; i< pageSize; i++){
                    	paginationList.push(response[i]);    
                    	}
                	component.set('v.paginationList', paginationList);
                    component.set('v.showStandardReport', true);
                    component.set('v.showADOReport', false);
            		helper.next(component, event, helper);
        			helper.previous(component, event, helper);
                	}
                else{
                    var repList = JSON.parse(response);
                	console.log('===repList====',repList);
                	component.set("v.tableTitle", component.get("v.report", "v.value"));
                	component.set('v.tableData', repList);
                	component.set("v.totalSize", component.get("v.tableData").length);
                	component.set("v.start",0);
                	component.set("v.end",pageSize-1);
                	component.set("v.tableData", repList);
            		var paginationList = [];
                	for(var i=0; i< pageSize; i++){
                    	paginationList.push(response[i]);    
                    	}
               	 	component.set('v.paginationList', paginationList);
                    component.set('v.showStandardReport', false);
                    component.set('v.showADOReport', true);
            		helper.next(component, event, helper);
        			helper.previous(component, event, helper);
                	} 
                }
            });
        $A.enqueueAction(action);
        },
    
    onSort : function(component, event, sortField, helper) {
      	//call apex class method
      	var action = component.get('c.sortTable');
 		var pageSize = component.get("v.pageSize");
        component.set("v.paginationList", null);
      	component.set('v.tableData', null);
        // pass the apex method parameters to action 
      	action.setParams({
      	   	'sortField': sortField,
    	    'isAsc': component.get("v.isAsc"),
            "selRole" : component.get("v.role", "v.value"),
            "selReport" : component.get("v.report", "v.value"),
            "selRoleName" : component.get("v.roleName", "v.value"),
            "selIndividual" : component.get("v.person", "v.value"),
            "SelDteFrom" : component.get("v.dteFrom", "v.value"),
            "SelDteTo" : component.get("v.dteTo", "v.value")
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
				var repList = JSON.parse(response);
                component.set("v.tableTitle", component.get("v.report", "v.value"));
                component.set('v.tableData', repList);
                component.set("v.totalSize", component.get("v.tableData").length);
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                component.set("v.tableData", repList);
            	var paginationList = [];
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set('v.paginationList', paginationList);
            	helper.next(component, event, helper);
        		helper.previous(component, event, helper);
            	}
            });
        $A.enqueueAction(action);
      	},
    
    sortHelper : function(component, event, sortFieldName, helper){
        var currentDir = component.get("v.arrowDirection");
      	if(currentDir == 'arrowdown'){
         	// set the arrowDirection attribute for conditionally rendred arrow sign  
         	component.set("v.arrowDirection", 'arrowup');
         	// set the isAsc flag to true for sort in Assending order.  
         	component.set("v.isAsc", true);
      		}
       else{
       		component.set("v.arrowDirection", 'arrowdown');
        	component.set("v.isAsc", false);
      		}
      	this.onSort(component, event, sortFieldName, helper);
    	},
       
   accountName : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.     
       	component.set("v.selectedTabsoft", 'accountName');
       	// call the helper function with pass sortField Name   
       	helper.sortHelper(component, event, 'accountName', helper);
    	},
 
    owner : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.    
       	component.set("v.selectedTabsoft", 'ownerName');
       	// call the helper function with pass sortField Name  
       	helper.sortHelper(component, event, 'ownerName', helper);
    	},
 
    city : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.        
       	component.set("v.selectedTabsoft", 'city');
       	// call the helper function with pass sortField Name      
       	helper.sortHelper(component, event, 'city', helper);
    	},
        
    state : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.        
       	component.set("v.selectedTabsoft", 'state');
       	// call the helper function with pass sortField Name      
       	helper.sortHelper(component, event, 'state', helper);
    	},
        
    activity : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.        
       	component.set("v.selectedTabsoft", 'activity');
       	// call the helper function with pass sortField Name      
       	helper.sortHelper(component, event, 'activity', helper);
    	},
        
    risk : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.        
       	component.set("v.selectedTabsoft", 'risk');
       	// call the helper function with pass sortField Name      
       	helper.sortHelper(component, event, 'risk', helper);
    	},
    
    riskDate : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.        
       	component.set("v.selectedTabsoft", 'riskDate');
       	// call the helper function with pass sortField Name      
       	helper.sortHelper(component, event, 'riskDate', helper);
    	},
        
    tier : function(component, event, helper) {
       	// set current selected header field on selectedTabsoft attribute.        
       	component.set("v.selectedTabsoft", 'tier');
       	// call the helper function with pass sortField Name      
       	helper.sortHelper(component, event, 'tier', helper);
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

	convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;

        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['Name','Owner','LastActivityDate','PF_Reason_for_Risk__c','PF_Risk_Date_Stamp__c', 'PF_Tier__c'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;

             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  

              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }
                 
                 if(skey == 'Owner'){
                     if(objectRecords[i][skey] != undefined){  
                         csvStringResult += '"'+ objectRecords[i][skey].Name+'"';
                     	 }
                     else{
                         csvStringResult += '"'+ ' ' +'"';
                     	 }
                 } 
                 else{
                     if(objectRecords[i][skey] != undefined){  
                        csvStringResult += '"'+ objectRecords[i][skey]+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
               counter++;
 
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },

	convertArrayOfObjectsToCSV2 : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
		
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
        keys = ['Account.Name','Account.Owner','Account.LastActivityDate','Account.PF_Reason_for_Risk__c','Account.PF_Risk_Date_Stamp__c', 'Account.PF_Tier__c'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;

             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  

              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Account.Name'){
                     if(objectRecords[i].Account.Name != undefined){  
                        csvStringResult += '"'+ objectRecords[i].Account.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';	
                     	}
                     
                 }
                 else if(skey == 'Account.Owner'){
                     if(objectRecords[i].Account.Owner.Name == undefined){  
                        csvStringResult += '"'+ objectRecords[i].Account.Owner.Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account.LastActivityDate'){
                     
                     if(objectRecords[i].Account.LastActivityDate != undefined){  
                        csvStringResult += '"'+ objectRecords[i].Account.LastActivityDate+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                 else if(skey == 'Account.PF_Reason_for_Risk__c'){
                     if(objectRecords[i].Account.PF_Reason_for_Risk__c != undefined){  
                        csvStringResult += '"'+ objectRecords[i].Account.PF_Reason_for_Risk__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'Account.PF_Risk_Date_Stamp__c'){
                     if(objectRecords[i].Account.PF_Risk_Date_Stamp__c != undefined){  
                        csvStringResult += '"'+ objectRecords[i].Account.PF_Risk_Date_Stamp__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                 else if(skey == 'Account.PF_Tier__c'){
                     if(objectRecords[i].Account.PF_Tier__c != undefined){  
                        csvStringResult += '"'+ objectRecords[i].Account.PF_Tier__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
               
               counter++;
 
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },    
 
})