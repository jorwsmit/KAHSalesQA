({
	getRole : function(component) {
        
		var action = component.get("c.getRoleNames");
        action.setCallback(this, function(response) {

            var state = response.getState();
            console.log('=====state======',state);
            if (component.isValid() && state === "SUCCESS") {
                
                var stringItems = response.getReturnValue();
                component.set("v.selRoles", stringItems); 
				component.set("v.selRoleList", '--None Selected--'); 
            }
            else if (state === "ERROR") {
                
                console.log("===>>>=== ", response.getError());
            }
        });
        $A.enqueueAction(action);
		},
    
    getRoleAlt : function(component){
        var action = component.get("c.getRoleAlt");
        action.setCallback(this, function(response){
		    var state = response.getState();
            console.log('=====state======',state);
            if(component.isValid() && state === "SUCCESS"){
                var stringItems = response.getReturnValue();
                component.set("v.selRoles", stringItems); 
				component.set("v.selRoleList", '--None Selected--'); 
            	}
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}
        	});
        $A.enqueueAction(action);
		},
    
    getRoleAlt2 : function(component, helper){
        var action = component.get("c.getRoleAlt2");
        action.setCallback(this, function(response){
		    var state = response.getState();
            console.log('=====state======',state);
            if(component.isValid() && state === "SUCCESS"){
                var stringItems = response.getReturnValue();
                component.set("v.selRoles", stringItems); 
				component.set("v.selRoleList", '--None Selected--'); 
            	}
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}
        	});
        $A.enqueueAction(action);
        },
    
    getReport : function(component){
        
        var action1 = component.get("c.getReportNames");
        action1.setCallback(this, function(response) {

            var state = response.getState();
            console.log('=====state====1==',state);
            if (component.isValid() && state === "SUCCESS") {
                
                var stringItems = response.getReturnValue();
                component.set("v.selReports", stringItems); 

            }
            else if (state === "ERROR") {
                
                console.log("===>>>=== ", response.getError());
            }
        });
        $A.enqueueAction(action1);
    },
    
    getRoleNamePicklist : function(component){
        
        var action = component.get("c.getRoles");
        var InputSelectRole = component.find("InputSelectRole").get("v.value");
        
        action.setParams({
            "selRole" : component.find("InputSelectRole").get("v.value")
        }); 
        
        action.setCallback(this, function(response) {

            var state = response.getState();
            console.log('=====state======',state);
            if (component.isValid() && state === "SUCCESS") {
                
                var stringItems = response.getReturnValue();
                component.set("v.selRoleList", stringItems); 
				
                var selRole =component.find("InputSelectRoleHierarchy");
      			selRole.set("v.value", "--None Selected--");

            }
            else if (state === "ERROR") {
                
                console.log("===>>>=== ", response.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    
    disableSelectRole : function(component){
        var inputSelReport = component.find("InputSelectReport");
        var inputSel = component.find("InputSelectRoleHierarchy");
        var searchbutton = component.find("searchButton");
        if(component.find("InputSelectRole").get("v.value") == 'National'){
     		inputSel.set("v.disabled", true); 
            setTimeout(function(){ inputSelReport.focus();  }, 20);
        }
        else{
            inputSel.set("v.disabled",false);
            setTimeout(function(){ inputSel.focus();  }, 20);
        }
		},
    
    disableSelectIndividual : function(component){
        var inputSelReport = component.find("InputSelectReport");
        var inputIndv = component.find("InputSelectIndividual");
        console.log('report: ' + inputSelReport);
        console.log('Individual: ' + inputIndv);
        console.log('Selected Hierarchy: ' + component.find("InputSelectRoleHierarchy").get("v.value"));
        
        if(component.find("InputSelectRoleHierarchy").get("v.value") === '--None Selected--'){
     		inputIndv.set("v.disabled", true);
            component.find("InputSelectIndividual").set("v.value", '--None Selected--');
        	component.set("v.selIndLst", null);	
        	}
        else{
            var action = component.get("c.getIndividuals");
        	var InputSelectRole = component.find("InputSelectRole").get("v.value");
        	action.setParams({
            	"selRole" : component.find("InputSelectRole").get("v.value")
        		}); 
        
        	action.setCallback(this, function(response) {

            	var state = response.getState();
            		console.log('=====state======',state);
            	if(component.isValid() && state === "SUCCESS") {
                	inputIndv.set("v.disabled", false);
                	var stringItems = response.getReturnValue();
                	component.set("v.selIndLst", stringItems); 
				}
            else if (state === "ERROR") {
                
                console.log("===>>>=== ", response.getError());
            }
        });
        $A.enqueueAction(action);
            inputIndv.set("v.disabled",false);
            setTimeout(function(){ inputIndv.focus();  }, 20);
        }
	},
})