({
	getApprovals : function(component, event, helper) {
		var action = component.get("c.getApprovals"); 
        var pageSize = component.get("v.pageSize");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
		    if (response == null || response == "" || response == "[]" || response == "{}"){
                var msgId = component.find("uiMessageid");
				$A.util.addClass(msgId, 'toggle');
                //Show toast Error
                return;
            	} 
            else{
				component.set('v.objectLst', response);
                component.set("v.totalSize", component.get("v.objectLst").length);
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                var paginationList = [];
                for(var i=0; i< pageSize; i++){
                 	paginationList.push(response[i]);    
    				}
                component.set('v.paginationList', paginationList);
            	}
            });
        $A.enqueueAction(action);
		},
    
    sortBy: function(component, field){
        pageSize = component.get("v.pageSize");	
        var sortAsc = component.get("v.sortAsc"),
        sortField = component.get("v.sortField"),
        records = component.get("v.tableData");
        	sortAsc = sortField != field || !sortAsc;
        	records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        	});
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
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
})