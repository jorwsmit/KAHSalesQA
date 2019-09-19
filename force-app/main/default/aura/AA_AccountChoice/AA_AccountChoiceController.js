({
	doInit : function(component, event, helper){
        helper.getChoiceList(component);
        helper.findUserExperience(component);
        },
    
    openPage : function(component, event, helper){
        var id = event.getSource().get("v.title");
        component.set("v.recordtypeId", id);
        
        component.set("v.showList", false);
        component.set("v.showForm", true);
        
    	},
    
    onCancel : function(component, event, helper){
        console.log('Cancel Initiated');
        window.location.href =  '/001/o';
        },
    
    handleSuccess : function(component, event, helper){
        var payload = JSON.parse(JSON.stringify(event.getParams())); 
        console.log('Result: ' + payload);
        console.log('Result ID: ' + payload.id);
		var ltng = component.get("v.isLEX", "v.value");
        if(ltng === true){
            var focusedTabId;
            console.log('Lightning Nav');
            var redUrl ='/lightning/r/Account/' + payload.id + '/view';
        	window.location.href = redUrl;
            }
        else{
            window.location.href = "/"+payload.id;
        	}
    	},
})