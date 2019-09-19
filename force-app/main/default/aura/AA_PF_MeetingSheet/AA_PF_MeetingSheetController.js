({
	doInit : function(component, event, helper){
		helper.populateAcc(component);
        helper.getInfo(component);
        component.set("v.reportPresented",false);
        component.set("v.cliCon",false);
        component.set("v.nonImed",false);
    	},
    
    searchAccounts : function(component, event, helper){
		helper.getAccounts(component);
        },
    
    /*populateAcc : function(component, event, helper){
		helper.populateAcc(component);
        },*/
    
    onRadio : function(component,event,helper){
        var getWhichBtn = event.getSource().get("v.label");
        if(getWhichBtn === "Yes"){
  			component.set("v.reportPresented",true);           
        	}
        else{
            component.set("v.reportPresented",false);
        	}   
      },
    
    onRadio2 : function(component,event,helper){
        var getWhichBtn = event.getSource().get("v.label");
        if(getWhichBtn === "Yes"){
  			component.set("v.cliCon",true);           
        	}
        else{
            component.set("v.cliCon",false);
        	}
    	},
    
    onRadio3 : function(component,event,helper){
        var getWhichBtn = event.getSource().get("v.label");
        if(getWhichBtn === "Yes"){
  			component.set("v.nonImed",true);           
        	}
        else{
            component.set("v.nonImed",false);
        	}
    	},
    
    listChange : function (component, event, helper){
        helper.buttonEnable(component);
    	},
    
    echo : function(component){
        // Save the record and execute necessary actions server-side
        var inputCmp = component.find("cliConSpec");
        var inputCmp2 = component.find("specif2");
        var inputCmp3 = component.find("dueD1");
        var inputCmp4 = component.find("dueD2");
        var inputCmp5 = component.find("dueD3");
        var inputCmp6 = component.find("submitButton");
        inputCmp.set("v.errors", null);
        inputCmp2.set("v.errors", null);
        inputCmp3.set("v.errors", null);
        inputCmp4.set("v.errors", null);
        inputCmp5.set("v.errors", null);
        
        inputCmp6.set("v.errors", null);
        
        if(component.get("v.cliCon") === true && component.find("cliConSpec").get("v.value") === undefined){
            inputCmp6.set("v.errors", [{message:"Please address the errors above before proceeding."}]);
            inputCmp.set("v.errors", [{message:"If Client Concerns were raised, please provide the specifics."}]);
        	}
        else if(component.get("v.nonImed") === true && component.find("specif2").get("v.value") === undefined){
            inputCmp6.set("v.errors", [{message:"Please address the errors above before proceeding."}]);
            inputCmp2.set("v.errors", [{message:"If Non Immediate Concerns were raised, please provide the specifics."}]);
        	}
        else if(component.find("action1").get("v.value") !== undefined && component.find("dueD1").get("v.value") === undefined){
            inputCmp6.set("v.errors", [{message:"Please address the errors above before proceeding."}]);
            inputCmp3.set("v.errors", [{message:"Please provide a due date for the Action/Follow-Up"}]);
            }
        else if(component.find("action2").get("v.value") !== undefined && component.find("dueD2").get("v.value") === undefined){
            inputCmp6.set("v.errors", [{message:"Please address the errors above before proceeding."}]);
            inputCmp4.set("v.errors", [{message:"Please provide a due date for the Action/Follow-Up"}]);
            }
        else if(component.find("action3").get("v.value") !== undefined && component.find("dueD3").get("v.value") === undefined){
            inputCmp6.set("v.errors", [{message:"Please address the errors above before proceeding."}]);
            inputCmp5.set("v.errors", [{message:"Please provide a due date for the Action/Follow-Up"}]);
            }
        else{
        var action = component.get("c.saveForm");
        action.setParams({ 
            	"repNameTitle" : component.find("repNameTitle").get("v.value"),
         		"facID" : component.get("v.facID"),
           		"facName" : component.get("v.accName"),
           		"cAttendees" : component.find("cAttendees").get("v.value"),
           		"rhbAttendees" : component.find("rhbAttendees").get("v.value"),
           		"reportPresented" : component.get("v.reportPresented"),
           		"meetDate" : component.find("meetDate").get("v.value"),
           		"mClReport" : component.find("mClReport").get("v.value"),
           		"disc1" : component.find("disc1").get("v.value"),
           		"concl1" : component.find("concl1").get("v.value"),
            	"action1" : component.find("action1").get("v.value"),
            	"dueD1" : component.find("dueD1").get("v.value"),
            	"disc2" : component.find("disc2").get("v.value"),
            	"concl2" : component.find("concl2").get("v.value"),
            	"action2" : component.find("action2").get("v.value"),
          		"dueD2" : component.find("dueD2").get("v.value"),
            	"disc3" : component.find("disc3").get("v.value"),
            	"concl3" : component.find("concl3").get("v.value"),
            	"action3" : component.find("action3").get("v.value"),
            	"dueD3" : component.find("dueD3").get("v.value"),
           		"cliCon" : component.get("v.cliCon"),
            	"cliConSpec" : component.find("cliConSpec").get("v.value"),
           		"nonImed" : component.get("v.nonImed"),
           		"specif2" : component.find("specif2").get("v.value"),
           		"specificGJ" : component.find("specificGJ").get("v.value"),
           		"comments" : component.find("comments").get("v.value")
                         });
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                alert("From server: " + response.getReturnValue());

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
		$A.enqueueAction(action);
    	}
		}    
})