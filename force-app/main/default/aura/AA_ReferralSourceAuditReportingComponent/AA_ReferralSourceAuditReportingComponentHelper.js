({
	getInitialRoleNames : function(component, event, helper){
		var action = component.get("c.getFirstRoles");
        action.setCallback(this, function(response) {
		    var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var stringItems = response.getReturnValue();
                component.set("v.selRoles", stringItems); 
				}
            else if (state === "ERROR") {
                console.log("===>>>===", response.getError());
            	}
        	});
        $A.enqueueAction(action);
		},
    
    getFirstUsersList : function(component, event, helper){
        component.set("v.Spinner", true);
        var action = component.get("c.getFirstUsersList");
        return new Promise(function(resolve, reject){
            action.setStorable();
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                var newList2 = [];
                newList2.push(' ');
                var strng2 = 'No match found';
                    newList2.push({value: strng2, label: strng2});
                	
                component.set("v.selectList", newList2);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.userList", repList);
                component.set("v.userList2", repList);
                var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].LastName + ', ' + stockData[i].FirstName + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Line_of_Business__c != undefined){
                        strng += stockData[i].Line_of_Business__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].PERNER__c != undefined){
                        strng += stockData[i].PERNER__c;
                    	}
                    newList.push({value: strng, label: strng});
                	}
                component.set("v.selectList", newList);
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
            });
    		$A.enqueueAction(action);
        	});
    	},
    
    getSubRoleNames : function(component, event, helper){
        console.log('Role Name: ' + component.get("v.roleName"));
        console.log('List Name: ' + component.get("v.currentList"));
        var list = component.get("v.currentList");
        var action = component.get("c.getSubRoleNames");
        action.setParams({ 
            			 "roleName" : component.get("v.roleName") 
        				});
        action.setCallback(this, function(response) {
		    var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var stringItems = response.getReturnValue();
                if(list === 'InputSelectRole'){
                	component.set("v.selRoles2", stringItems);
                    component.set("v.selRoles3", null);
                    component.set("v.selRoles4", null);
                    component.set("v.selRoles5", null);
                    component.set("v.selRoles6", null);
                	}
                else if(list === 'InputSelectRole2'){
                	component.set("v.selRoles3", stringItems); 
                	component.set("v.selRoles4", null);
                	component.set("v.selRoles5", null);
                    component.set("v.selRoles6", null);
                	
                	}
                else if(list === 'InputSelectRole3'){
                	component.set("v.selRoles4", stringItems); 
                	component.set("v.selRoles5", null);
                	component.set("v.selRoles6", null);
                	}
                else if(list === 'InputSelectRole4'){
                	component.set("v.selRoles5", stringItems);
                    component.set("v.selRoles6", null);
                	}
                else if(list === 'InputSelectRole5'){
                	component.set("v.selRoles6", stringItems); 
                	}
                }
            else if (state === "ERROR") {
                console.log("===>>>===", response.getError());
            	}
        	});
        $A.enqueueAction(action);
        },
    
    getReport : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.btn2Disabled", true);
        var action = component.get("c.getReport");
        component.set("v.tableData", null);
        action.setParams({ 
            			 "roleName" : component.get("v.roleName", "v.value"),
                         "selectedUser" : component.get("v.selectedListUser", "v.value"),
             			 "selDteFrom" : component.find("InputDteFrom").get("v.value"),
             			 "selDteTo" : component.find("InputDteTo").get("v.value"),
            			 "accountFilter" : component.get("v.accountFilter", "v.value"),
            			 "contactFilter" : component.get("v.contactFilter", "v.value"),
            			 "unityFilter" : component.get("v.unityFilter", "v.value"),
            			 "horizonFilter" : component.get("v.horizonFilter", "v.value"),
            			 "sfIDFilter" : component.get("v.sfIDFilter", "v.value"),
            		     "sortField" : component.get("v.sortField"),
            			 "isAsc" : component.get("v.isAsc")
        				});
        action.setStorable();
        action.setCallback(this, function(response) {
		    var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var stringItems = response.getReturnValue();
                component.set("v.tableData", stringItems);
                component.set("v.btn2Disabled", false);
                component.set("v.Spinner", false);
                }
            else if (state === "ERROR") {
                console.log("===>>>===", response.getError());
            	}
        	});
        $A.enqueueAction(action);
    	},
    
    getUsersList : function(component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.selectList", null);
        var action = component.get("c.getUsersList");
        return new Promise(function(resolve, reject){
            action.setParams({
                			"searchString" : component.get("v.searchString", "v.value")
            				});
        	action.setStorable();
            action.setCallback(this, function(a){
            var response = a.getReturnValue();
        	if(response == null || response == "" || response == "[]" || response == "{}"){
            	component.set("v.Spinner", false);
                var newList2 = [];
                newList2.push(' ');
                var strng2 = 'No match found';
                    newList2.push({value: strng2, label: strng2});
                	
                component.set("v.selectList", newList2);
                return;
        		}
        	else{
            	var repList = response;
                component.set("v.userList", repList);
                component.set("v.userList2", repList);
                var stockData = repList;
                var newList = [];
                newList.push(' ');
                for(var i = 0; i < stockData.length; i++){
                    var strng = stockData[i].LastName + ', ' + stockData[i].FirstName + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    if(stockData[i].Line_of_Business__c != undefined){
                        strng += stockData[i].Line_of_Business__c + '\xa0\xa0\xa0-\xa0\xa0\xa0\xa0';
                    	}
                    if(stockData[i].PERNER__c != undefined){
                        strng += stockData[i].PERNER__c;
                    	}
                    newList.push({value: strng, label: strng});
                	}
                component.set("v.selectList", newList);
                component.set("v.Spinner", false);
                resolve("Resolved");
            	}
            });
    		$A.enqueueAction(action);
        	});
        },
    
    convertArrayOfObjectsToCSV : function(component,objectRecords){
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
        keys = ['Effective Date','EST','Name','Account Name','Account Id','Contact Name','Contact Id', 'Horizon ID', 'Unity ID', 'User Name','Status'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 		for(var i=0; i < objectRecords.length; i++){
            counter = 0;
            console.log('addLength: ' + objectRecords[i].addLst.length);
            console.log('delLength: ' + objectRecords[i].delLst.length);
            for(var a = 0; a < objectRecords[i].addLst.length; a++){
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Effective Date'){
                     if(objectRecords[i].addLst[a].Effective_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].addLst[a].Effective_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'EST'){
                     if(objectRecords[i].addLst[a].EST__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].addLst[a].EST__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Name'){
                     if(objectRecords[i].addLst[a].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].addLst[a].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                else if(skey == 'Account Name'){
                    try{ 
                    	csvStringResult += '"'+ objectRecords[i].addLst[a].Account__r.Name+'"';
                    	} 
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                 else if(skey == 'Account Id'){
                    try{ 
                    	csvStringResult += '"'+ objectRecords[i].addLst[a].Account__r.Id+'"';
                    	} 
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                    
                else if(skey == 'Contact Name'){
                    try{
                        csvStringResult += '"'+ objectRecords[i].addLst[a].Contact__r.Name+'"';
                     	}
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                    
                 else if(skey == 'Contact Id'){
                    try{
                        csvStringResult += '"'+ objectRecords[i].addLst[a].Contact__r.Id+'"';
                     	}
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }   
                 
                 else if(skey == 'Horizon ID'){
                     if(objectRecords[i].addLst[a].Horizon_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].addLst[a].Horizon_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                 else if(skey == 'Unity ID'){
                     if(objectRecords[i].addLst[a].Unity_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].addLst[a].Unity_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'User Name'){
                     	if(objectRecords[i].user.Name !== undefined){  
                        	csvStringResult += '"'+ objectRecords[i].user.Name+'"';
							}
                    	else{
                        	csvStringResult += '"'+ ' ' +'"';	
                     		}
                     	}
                 else if(skey == 'Status'){
                     if(objectRecords[i].addLst[a].Status__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].addLst[a].Status__c+'"';
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
            for(var b = 0; b < objectRecords[i].delLst.length; b++){
                for(var sTempkey in keys){
                var skey = keys[sTempkey] ;  
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }  
                 if(skey == 'Effective Date'){
                     if(objectRecords[i].delLst[b].Effective_Date__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].delLst[b].Effective_Date__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 else if(skey == 'EST'){
                     if(objectRecords[i].delLst[b].EST__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].delLst[b].EST__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 	}
                 
                 else if(skey == 'Name'){
                     if(objectRecords[i].delLst[b].Name !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].delLst[b].Name+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                else if(skey == 'Account Name'){
                    try{ 
                    	csvStringResult += '"'+ objectRecords[i].delLst[b].Account__r.Name+'"';
                    	} 
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                    
                else if(skey == 'Account Id'){
                    try{ 
                    	csvStringResult += '"'+ objectRecords[i].delLst[b].Account__r.Id+'"';
                    	} 
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                }    
                 
                else if(skey == 'Contact Name'){
                    try{
                        csvStringResult += '"'+ objectRecords[i].delLst[b].Contact__r.Name+'"';
                     	}
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                 else if(skey == 'Contact Id'){
                    try{
                        csvStringResult += '"'+ objectRecords[i].delLst[b].Contact__r.Id+'"';
                     	}
                     catch(err){
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }    
                    
                 else if(skey == 'Horizon ID'){
                     if(objectRecords[i].delLst[b].Horizon_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].delLst[b].Horizon_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 
                 else if(skey == 'Unity ID'){
                     if(objectRecords[i].delLst[b].Unity_ID__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].delLst[b].Unity_ID__c+'"';
                     	}
                     else{
                        csvStringResult += '"'+ ' ' +'"';
                     	}
                 }
                 else if(skey == 'User Name'){
                     	if(objectRecords[i].user.Name !== undefined){  
                        	csvStringResult += '"'+ objectRecords[i].user.Name+'"';
							}
                    	else{
                        	csvStringResult += '"'+ ' ' +'"';	
                     		}
                     	}
                 else if(skey == 'Status'){
                     if(objectRecords[i].delLst[b].Status__c !== undefined){  
                        csvStringResult += '"'+ objectRecords[i].delLst[b].Status__c+'"';
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
            
          }// outer main for loop close 
       // return the CSV formate String 
        return csvStringResult;        
    },
    
})