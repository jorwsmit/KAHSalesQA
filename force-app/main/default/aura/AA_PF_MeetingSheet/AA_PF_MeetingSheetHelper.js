({
	/*getAccounts : function(component, helper){
        //Get a list of available accounts for the user's to choose from to record this report to.
        //Will also filter an existing list if accSearchTxt variable is not null
        component.set("v.selOptionsLst", null); 
        var action = component.get("c.getAccounts");
        		
        	action.setParams({
            	"accSearch" : component.find("accSearchTxt").get("v.value")
        		});
        
        	action.setCallback(this, function(response) {
		    	var state = response.getState();
            		console.log('Accounts',state);
            	if(component.isValid() && state === "SUCCESS"){
                	var stringItems = response.getReturnValue();
                	component.set("v.selOptionsLst", stringItems); 
					}
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}
        });
        $A.enqueueAction(action);
		},*/
    
    getInfo : function(component) {
        //Get the user's name/title and display it on the entry screen
        var action = component.get("c.getInfo");
        action.setCallback(this, function(response) {
		    var state = response.getState();
            console.log('Info',state);
            if(component.isValid() && state === "SUCCESS"){
                var stringItems = response.getReturnValue();
                component.set("v.repNameTitle", stringItems); 
				}
            else if (state === "ERROR") {
                console.log("===>>>===", response.getError());
            	}
        	});
        $A.enqueueAction(action);
		},
    	
     buttonEnable : function(component){
        var inputSel = component.find("inputButton");
        if(component.find("InputSelectAccount").get("v.value") === '--None--'){
     		inputSel.set("v.disabled", true); 
            }
        else{
            inputSel.set("v.disabled",false);
            }
    	},
     
     populateAcc : function(component){
         //When an account has been chosen, display its information to the user on the entry screen
         var action = component.get("c.populateAccount");
         console.log("accID: " + component.get("v.recordId"));
         action.setParams({
            	"accID" : component.get("v.recordId")
        		});
        
        	action.setCallback(this, function(response) {
		    	var state = response.getState();
            		console.log('Populate',state);
            	if(component.isValid() && state === "SUCCESS"){
                	var stringItems = response.getReturnValue();
                	component.set("v.acc", stringItems); 
					component.set("v.facID", component.get("v.acc.Id", "v.value")); 
                	}
            else if(state === "ERROR"){
                console.log("===>>>=== ", response.getError());
            	}
        });
        $A.enqueueAction(action);
		},
    
})