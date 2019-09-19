({
	doInit : function(component, event, helper) {
		
        helper.findProfileType(component).then(
            $A.getCallback(function(result){
                console.log('Getting Profile');
            })
        )
        .then(
            $A.getCallback(function(result){
                console.log('Populating Item');
                return helper.populateItem(component, event, helper);      
            })
            )
        .then(
            $A.getCallback(function(result){
                console.log('Getting State filter');
                return helper.getStateList(component, event, helper);
            })
        )
        .then(
            $A.getCallback(function(result){
                console.log('Getting Business Unit Comparison');
                return helper.evalBusUnits(component, event, helper);
            })
        )
        .catch(
            $A.getCallback(function(error){
                // Something went wrong
                alert('An error occurred : ' + error.message);
            })
        );
    	},
    
    onCheck : function(component, event, helper){
        var str = event.getSource().get("v.text");
        var id = event.getSource().get("v.text").substring(0, 18);
        var n = str.lastIndexOf(':');
        var rType = event.getSource().get("v.text").substring(18, str.length);
        console.log('ID: ' + id);
        console.log('Type: ' + rType);
        if(event.getSource().get("v.value")){
    		// Checkbox is checked - add id to checkedItems
    		if(component.get("v.checkedItems").indexOf(id) < 0){
      			component.get("v.checkedItems").push(id);
                component.get("v.checkedTypes").push(rType);
                if(component.get("v.item2ID") === undefined){
                    component.set("v.item2ID", id);
                	}
            	}
  			} 
        else{
    		// Checkbox is unchecked - remove id from checkedItems
    		var index = component.get("v.checkedItems").indexOf(id);
    		if(index > -1){
      			component.get("v.checkedItems").splice(index, 1);
                component.get("v.checkedTypes").splice(index, 1);
                if(component.get("v.item2ID") === id){
                    component.set("v.item2ID", undefined);
                	}
            	}
  			}
        var btnChk = component.get("v.checkedItems.length");
        var inputBtn = component.find("submitButton");
        if(btnChk > 0){
            inputBtn.set("v.disabled", false); 
            }
        else{
            inputBtn.set("v.disabled", true); 
        	}
        var arr = component.get("v.checkedTypes");
        let types = new Set();
        for(var i = 0; i < arr.length ; i++){
            console.log('Item: ' + arr[i]);
            types.add(arr[i]);
            console.log('length: ' + types.size);	
        	}
        if(types.size > 1){
            alert('Please review selections.  All records chosen for the merge must share the same record type.');
        	}
        },
    
    setSte : function(component, event, helper){
        component.set("v.steFilter" , component.find("InputSelectState").get("v.value"));
    },
    
    searchRecords : function(component, event, helper){
        helper.searchRecords(component);
    	},
    
    submitRequest : function(component, event, helper){
        helper.submitRequest(component);
    	},
    
    next : function(component, event, helper){
     	helper.next(component, event, helper);
 		},
    
    previous : function(component, event, helper){
     	helper.previous(component, event, helper);
 		},
    
    sortName: function(component, event, helper) {
        helper.sortBy(component, "name");
    	},
    
    sortNPI : function(component, event, helper){
        helper.sortBy(component, "npi");
    	},
    
    sortCMS : function(component, event, helper){
        helper.sortBy(component, "cms");
    	},
    
    sortSFID : function(component, event, helper){
        helper.sortBy(component, "itemID");
    	},
    
    sortAddress : function(component, event, helper){
        helper.sortBy(component, "shippingStreet");
    	},
    
    sortCity : function(component, event, helper){
        helper.sortBy(component, "shippingCity");
    	},
    
    sortState : function(component, event, helper){
        helper.sortBy(component, "shippingState");
    	},
    
    sortZip : function(component, event, helper){
        helper.sortBy(component, "shippingPostalCode");
    	},
    
    sortHMS : function(component, event, helper){
        helper.sortBy(component, "hms");
    	},
    
    sortHorizon : function(component, event, helper){
        helper.sortBy(component, "horizon");
    	},
    
    sortHPAS : function(component, event, helper){
        helper.sortBy(component, "hpas");
    	},
    
    sortUnity : function(component, event, helper){
        helper.sortBy(component, "unity");
    	},
    
    sortMeditech : function(component, event, helper){
        helper.sortBy(component, "meditech");
    	},
    
    sortPhone : function(component, event, helper){
        helper.sortBy(component, "phone");
    	},
    
    sortEmail : function(component, event, helper){
        helper.sortBy(component, "email");
    	},
    
    showSpinner: function(component, event, helper) {
       component.set("v.Spinner", true); 
   	   },
    
 
  	hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
       },
    
})