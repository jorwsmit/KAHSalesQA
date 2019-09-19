({
	doInit : function(component, event, helper) {
		helper.getApprovals(component);
		},
    
    next : function(component, event, helper){
     	helper.next(component, event, helper);
 		},
    
    previous : function(component, event, helper){
     	helper.previous(component, event, helper);
 		},
    
    sortName: function(component, event, helper) {
        helper.sortBy(component, "itemName");
    	},
    
    sortAssignName: function(component, event, helper) {
        helper.sortBy(component, "assignedTo");
    	},
    
    sortDays: function(component, event, helper) {
        helper.sortBy(component, "requestedDate");
    	},
    
    sortMaster: function(component, event, helper) {
        helper.sortBy(component, "requestedMergeWith");
    	},
})