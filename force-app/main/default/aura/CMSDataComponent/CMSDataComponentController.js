({	
    
    doInit : function(component, event, helper){
        helper.populateItem(component);
    	},
    
    displayDocument : function(component, event, helper){
		var recordId = component.get("v.cmsID");
        var url = '/apex/AA_CMSDataPDF?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
        	    "url": url
        	});
        urlEvent.fire();
        },
    
})