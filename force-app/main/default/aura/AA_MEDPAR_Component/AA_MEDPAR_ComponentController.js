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
    
    handleSuccess : function(component, event, helper){
        alert('Your changes have been saved.');
    	},
    
    handleNewSuccess : function(component, event, helper){
        alert('Your record has been added.');
        component.set("v.newEntry", false);
        helper.populateItem(component);
        },
    
    submitNewRecord : function(component, event, helper){
    	event.preventDefault();
        var d = new Date();
  		var n = d.getFullYear();
        var mth = d.getMonth();
        var quarter = '';
        if(mth < 3){
            quarter = '1';
        	}
        else if(mth >= 3 && mth < 6){
            quarter = '2';
        	}
        else if(mth >= 6 && mth < 9){
            quarter = '3';
        	}
        else if(mth >= 9 && mth < 11){
            quarter = '4';
        	}
        var date = n.toString();
        var eventFields = event.getParam("fields");
    	eventFields["Account__c"] = component.get("v.recordId", "v.value");
        eventFields["Year__c"] = date;
        eventFields["Quarter__c"] = quarter;
    	component.find('myform').submit(eventFields);
		},
})