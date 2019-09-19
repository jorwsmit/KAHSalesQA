({
    
    doInit : function(component, event, helper){
        helper.getChoiceList(component);
        helper.getAfterHoursID(component);
        helper.getGeneralID(component);
        },
    
    openPage : function(component, event, helper){
        var id = event.getSource().get("v.title");
        var afterH = component.get("v.afterHours", "v.value");
        var generalC = component.get("v.generalCase", "v.value");
        if(id === afterH){
            component.set("v.showChoice", false);
            component.set("v.storeID", afterH);
            component.set("v.showAfterH", true);
            component.set("v.showGeneral", false);
            }
        else if(id === generalC){
            component.set("v.showChoice", false);
            component.set("v.showAfterH", false);
            component.set("v.showGeneral", true);
            }
        },
})