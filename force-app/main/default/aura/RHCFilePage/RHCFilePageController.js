({
	getList : function(component, event, helper){
		helper.ContractFiles(component);
        helper.getWhitePageFiles(component);
        helper.getCollateralFiles(component);
        helper.getToolkitFiles(component);
        helper.getHowToFiles(component);
		component.set("v.showContracts", false);
        component.set("v.showWhite", false);
        component.set("v.showCollateral", false);
        component.set("v.showToolkit", false);
        component.set("v.showHowTo", false);
    },
    
    toggleCollapse : function(component, event, helper){
    	var getWhichBtn = event.getSource().get("v.label");
        console.log('button: ' + getWhichBtn);
        
        var conShow = component.get("v.showContracts");
        var whiteShow = component.get("v.showWhite");
        var collatShow = component.get("v.showCollateral");
        var toolkitShow = component.get("v.showToolkit");
        var howShow = component.get("v.showHowTo");
        if(getWhichBtn === "Contract Files"){
            if(conShow === false){
                component.set("v.showContracts",true);
            	}
            else{
  				component.set("v.showContracts",false);
            	}
            }
        else if(getWhichBtn === "White Paper Files"){
            if(whiteShow === false){
                component.set("v.showWhite",true);
            	}
            else{
  				component.set("v.showWhite",false);
            	}
        	}
        else if(getWhichBtn === "Best Practice Sales Toolkit"){
            if(toolkitShow === false){
                component.set("v.showToolkit",true);
            	}
            else{
  				component.set("v.showToolkit",false);
            	}
        	}
        else if(getWhichBtn === "Collateral"){
            if(collatShow === false){
                component.set("v.showCollateral",true);
            	}
            else{
  				component.set("v.showCollateral",false);
            	}
        	}
        else if(getWhichBtn === "SF How To"){
            if(howShow === false){
                component.set("v.showHowTo",true);
            	}
            else{
  				component.set("v.showHowTo",false);
            	}
        	}
		},
    
    showSpinner: function(component, event, helper) {
       component.set("v.Spinner", true); 
   	   },
    
  	hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
       },
})