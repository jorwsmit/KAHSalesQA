({
	ContractFiles : function(component, helper, event) {
		var action = component.get("c.getContractFileList");
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
				var repList = a.getReturnValue();
                component.set("v.contractFileList", repList);
                }
			});
        $A.enqueueAction(action);
		},
    
    getWhitePageFiles : function(component, helper, event) {
		var action = component.get("c.getWhitePageFileList");
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
				var repList = a.getReturnValue();
                component.set("v.whitePageFileList", repList);
            	}
			});
        $A.enqueueAction(action);
		},
    
    getToolkitFiles : function(component, helper, event) {
		var action = component.get("c.getToolkitFileList");
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
				var repList = a.getReturnValue();
                component.set("v.toolkitFileList", repList);
            	}
			});
        $A.enqueueAction(action);
		},
    
    getCollateralFiles : function(component, helper, event) {
		var action = component.get("c.getCollateralFileList");
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
				var repList = a.getReturnValue();
                component.set("v.collateralFileList", repList);
            	}
			});
        $A.enqueueAction(action);
		},
    
    getHowToFiles : function(component, helper, event) {
		var action = component.get("c.getHowToFileList");
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
				var repList = a.getReturnValue();
                component.set("v.howToFileList", repList);
            	}
			});
        $A.enqueueAction(action);
		},
    
})