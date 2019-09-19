({
    doInit : function(component, event, helper){
        helper.getAfterHoursID(component);
        helper.getGeneralID(component);
        
        helper.getAfterHoursID(component).then(
            $A.getCallback(function(result){
                console.log('Finding General Type');
                return helper.getGeneralID(component); 
            })
        	)
        .then(
            $A.getCallback(function(result){
                console.log('Finding Case Type');
                return helper.getCaseType(component);      
            })
        	)
        .then(
            $A.getCallback(function(result){
                console.log('Setting Case ID');
                return helper.setCaseID(component);      
            })
        	)
        .then(
            $A.getCallback(function(result){
                console.log('Routing Case');
                return helper.getCaseRoute(component);      
            })
        	)
        .catch(
            $A.getCallback(function(error){
                // Something went wrong
                alert('An error occurred : ' + error.message);
            })
        );
        
    }
})