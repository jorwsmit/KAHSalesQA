({
	doInit : function(component, event, helper) {
		
	},
    
    waiting: function(component, event, helper) {
        
        var spinner = component.find('xi-spinner');
    	$A.util.removeClass(spinner, "xc-hidden");
        //document.getElementById("Accspinner").style.display = "block";
    },
 
    doneWaiting: function(component, event, helper) {
        
        var spinner = component.find('xi-spinner');
    	$A.util.addClass(spinner, "xc-hidden");
       //document.getElementById("Accspinner").style.display = "none";
       //helper.drawChart(component);
    },
    
    createChart : function(component, event, helper){
      
       console.log('as1111111111111111');
        helper.drawChart(component);
    }
})