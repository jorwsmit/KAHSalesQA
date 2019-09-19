({
    doInit : function(component, event, helper){
        helper.getOptions(component);
        helper.getStates(component);
    	},
    
    submitAccount : function(component, event, helper){
        var sel = component.find("InputSelectType").get("v.value");
        if(sel === '--None Selected--'){
            alert('You must select an account type.');
        	}
        else{
        	helper.submitAccount(component);
        	}
    	},
})