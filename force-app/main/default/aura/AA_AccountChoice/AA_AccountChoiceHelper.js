({
	getChoiceList : function(component, event, helper) {
		var action = component.get("c.getAccountChoices");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                console.log('Choice List Fail');
                return;
            	}
            else{
                var repList = response;
                console.log('Choice List Success: ' + repList);
                component.set("v.choiceList", repList);
                var listSize = component.get("v.choiceList").length;
                console.log("choice size: " + listSize);
                if(listSize === 1){
                    var list = component.get("v.choiceList", "v.value");
                    console.log('List Value: ' + list);
                    console.log('List Value: ' + list[0].Id);
                    component.set("v.recordtypeId", list[0].Id);
        			component.set("v.showList", false);
        			component.set("v.showForm", true);
                    }
            	}
        	});
        $A.enqueueAction(action);
		},
    
    findUserExperience : function(component, event, helper){
    	var action = component.get("c.getViewState");
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            var state = a.getState();
            if(component.isValid() && state !== "SUCCESS"){
                console.log('Experience Fail');
                return;
            	}
            else{
                var repList = response;
                console.log('Choice List Success: ' + repList);
                if(repList !== 'Theme4d' && repList !== 'Theme4u' && repList !== 'Theme4t'){
                	component.set("v.isLEX", false);
                	}
                else{
                    component.set("v.isLEX", true);
                	}
            	}
        	});
        $A.enqueueAction(action);
		},
})