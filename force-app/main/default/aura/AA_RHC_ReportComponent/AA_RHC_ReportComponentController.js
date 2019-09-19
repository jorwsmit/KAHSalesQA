({
	doInit : function(component, event, helper){
		helper.getReports(component);
        helper.getAccounts(component);
        helper.getADOList(component);
        helper.getRVPList(component);
        helper.getDVPList(component);
        },
    
    handleADOChange : function (component, event, helper){
        var selectedOptionsList = event.getParam("value");
        console.log(selectedOptionsList);
        component.set("v.selectedADO", selectedOptionsList);
    	},
    
    handleRVPChange : function (component, event, helper){
        var selectedOptionsList = event.getParam("value");
        console.log(selectedOptionsList);
        component.set("v.selectedRVP", selectedOptionsList);
    	},
    
    handleDVPChange : function (component, event, helper){
        var selectedOptionsList = event.getParam("value");
        console.log(selectedOptionsList);
        component.set("v.selectedDVP", selectedOptionsList);
    	},
    
    onReportChange : function(component, event, helper){
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'Contacts Reporting'){
            component.set("v.showAlpha", false);
            component.set("v.report1", true);
            component.set("v.report2", false);
        	component.set("v.report3", false);
            component.set("v.report4", false);
            component.set("v.showExtraFilters", false);
        	}
        else if(report === 'Activity Reporting'){
            component.set("v.showAlpha", false);
            component.set("v.report1", false);
            component.set("v.report2", true);
            component.set("v.report3", false);
            component.set("v.report4", false);
            component.set("v.showExtraFilters", false);
        	}
        else if(report === 'NPS Activity Report'){
            component.set("v.showExtraFilters", true);
            component.set("v.showAlpha", false);
            component.set("v.showAlpha", true);
            component.set("v.report1", false);
            component.set("v.report2", false);
            component.set("v.report3", false);
            component.set("v.report4", true);
            helper.getAllNPSPDPMActive(component);
            var startLetter = 'A';
            helper.getAllNPSPDPMRows(component, startLetter).then(
            $A.getCallback(function(result){
                
            })
        		)
            .then(
            $A.getCallback(function(result){
                var startLetter = 'B';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'C';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'D';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'E';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'F';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'G';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'H';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'I';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'J';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'K';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'L';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'M';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'N';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'O';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'P';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Q';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'R';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'S';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'T';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'U';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'V';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'W';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )/*
            .then(
            $A.getCallback(function(result){
                var startLetter = 'X';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Y';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Z';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )*/
            .catch(
                    $A.getCallback(function(error){
                        // Something went wrong
                        alert('An error occurred : ' + error.message);
                    })
                );
            
        	}
        else if(report.includes("PDPM")){
            component.set("v.showAlpha", false);
            component.set("v.showAlpha", true);
            component.set("v.report1", false);
            component.set("v.report2", false);
            component.set("v.report3", false);
            component.set("v.report4", true);
            helper.getAllNPSPDPMActive(component);
            component.set("v.showExtraFilters", true);
        	
            var startLetter = 'A';
            helper.getAllNPSPDPMRows(component, startLetter).then(
            $A.getCallback(function(result){
                
            })
        		)
            .then(
            $A.getCallback(function(result){
                var startLetter = 'B';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'C';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'D';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'E';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'F';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'G';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'H';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'I';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'J';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'K';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'L';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'M';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'N';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'O';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'P';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Q';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'R';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'S';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'T';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'U';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'V';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'W';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )/*
            .then(
            $A.getCallback(function(result){
                var startLetter = 'X';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Y';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Z';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )*/
            .catch(
                    $A.getCallback(function(error){
                        // Something went wrong
                        alert('An error occurred : ' + error.message);
                    })
                );
        	}
        else if(report === 'All Accounts Reporting'){
            component.set("v.showAlpha", false);
            component.set("v.showAlpha", true);
            component.set("v.report1", false);
            component.set("v.report2", false);
        	component.set("v.report3", true);
            component.set("v.report4", false);
            component.set("v.showExtraFilters", true);
            
            var startLetter = 'A';
            helper.getAllRHBRows(component, startLetter).then(
            $A.getCallback(function(result){
                
            })
        		)
            .then(
            $A.getCallback(function(result){
                var startLetter = 'B';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'C';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'D';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'E';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'F';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'G';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'H';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'I';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'J';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'K';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'L';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'M';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'N';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'O';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'P';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Q';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'R';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'S';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'T';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'U';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'V';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'W';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )/*
            .then(
            $A.getCallback(function(result){
                var startLetter = 'X';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Y';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Z';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )*/
            .catch(
                    $A.getCallback(function(error){
                        // Something went wrong
                        alert('An error occurred : ' + error.message);
                    })
                );
            
        	}   
        helper.disableSelectAccount(component);
    	},
    
    runReport : function(component, event, helper){
        
        var report = component.find("InputSelectReport").get("v.value");
        
        if(report === 'Contacts Reporting'){
            component.set("v.showAlpha", false);
            helper.getFacility(component);
            helper.getDVPTeams(component);
        	helper.getRVPTeams(component);
        	helper.getADOTeams(component);
            helper.runReport(component);
            component.set("v.report1", true);
            component.set("v.report2", false);
        	component.set("v.report3", false);
        	component.set("v.report4", false);
        	}
        else if(report === 'Activity Reporting'){
            component.set("v.showAlpha", false);
            helper.getFacility(component);
            component.set("v.report1", false);
            component.set("v.report2", true);
            component.set("v.report3", false);
            component.set("v.report4", false);
        	helper.getDVPActivities(component);
            helper.getRVPActivities(component);
            helper.getADOActivities(component);
        	}
        else if(report === 'NPS Activity Report'){
            component.set("v.showAlpha", false);
            component.set("v.showAlpha", true);
            component.set("v.report1", false);
            component.set("v.report2", false);
            component.set("v.report3", false);
            component.set("v.report4", true);
            component.set("v.showExtraFilters", true);
            helper.getAllNPSPDPMActive(component);
            
            var startLetter = 'A';
            helper.getAllNPSPDPMRows(component, startLetter).then(
            $A.getCallback(function(result){
                
            })
        		)
            .then(
            $A.getCallback(function(result){
                var startLetter = 'B';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'C';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'D';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'E';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'F';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'G';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'H';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'I';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'J';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'K';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'L';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'M';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'N';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'O';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'P';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Q';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'R';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'S';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'T';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'U';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'V';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'W';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )/*
            .then(
            $A.getCallback(function(result){
                var startLetter = 'X';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Y';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Z';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )*/
            .catch(
                    $A.getCallback(function(error){
                        // Something went wrong
                        alert('An error occurred : ' + error.message);
                    })
                );
            
        	}
        else if(report.includes("PDPM")){
            component.set("v.showAlpha", false);
            component.set("v.showAlpha", true);
            component.set("v.report1", false);
            component.set("v.report2", false);
            component.set("v.report3", false);
            component.set("v.report4", true);
            helper.getAllNPSPDPMActive(component);
            component.set("v.showExtraFilters", true);
        	
            var startLetter = 'A';
            helper.getAllNPSPDPMRows(component, startLetter).then(
            $A.getCallback(function(result){
                
            })
        		)
            .then(
            $A.getCallback(function(result){
                var startLetter = 'B';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'C';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'D';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'E';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'F';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'G';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'H';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'I';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'J';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'K';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'L';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'M';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'N';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'O';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'P';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Q';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'R';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'S';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'T';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'U';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'V';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'W';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )/*
            .then(
            $A.getCallback(function(result){
                var startLetter = 'X';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Y';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Z';
                return helper.getAllNPSPDPMRows(component, startLetter);      
            })
            )*/
            .catch(
                    $A.getCallback(function(error){
                        // Something went wrong
                        alert('An error occurred : ' + error.message);
                    })
                );
        	}
        else if(report === 'All Accounts Reporting'){
            component.set("v.showAlpha", false);
            component.set("v.showAlpha", true);
            component.set("v.report1", false);
            component.set("v.report2", false);
        	component.set("v.report3", true);
            component.set("v.report4", false);
            helper.getAllRHBActive(component);
        	
            var startLetter = 'A';
            helper.getAllRHBRows(component, startLetter).then(
            $A.getCallback(function(result){
                
            })
        		)
            .then(
            $A.getCallback(function(result){
                var startLetter = 'B';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'C';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'D';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'E';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'F';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'G';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'H';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'I';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'J';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'K';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'L';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'M';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'N';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'O';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'P';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Q';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'R';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'S';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'T';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'U';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'V';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'W';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )/*
            .then(
            $A.getCallback(function(result){
                var startLetter = 'X';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Y';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )
            .then(
            $A.getCallback(function(result){
                var startLetter = 'Z';
                return helper.getAllRHBRows(component, startLetter);      
            })
            )*/
            .catch(
                    $A.getCallback(function(error){
                        // Something went wrong
                        alert('An error occurred : ' + error.message);
                    })
                );
        
        	}
        },
    
    next : function(component, event, helper){
     	helper.next(component, event, helper);
 		},
    previous : function(component, event, helper){
     	helper.previous(component, event, helper);
 		},
    
    sortName: function(component, event, helper) {
        helper.sortByContact(component, "Name");
    	},
    
    sortTitle : function(component, event, helper){
        helper.sortByContact(component, "Title");
    	},
    
    sortAddress : function(component, event, helper){
        helper.sortByContact(component, "MailingStreet");
    	},
    
    sortCity : function(component, event, helper){
        helper.sortByContact(component, "MailingCity");
    	},
    
    sortState : function(component, event, helper){
        helper.sortByContact(component, "MailingState");
    	},
    
    sortZip : function(component, event, helper){
        helper.sortByContact(component, "MailingPostalCode");
    	},
    
    sortPhone : function(component, event, helper){
        helper.sortByContact(component, "Phone");
    	},
    
    sortDVPName: function(component, event, helper) {
        helper.sortByDVP(component, "Owner.Name");
    	},
    
    sortDVPType : function(component, event, helper){
        helper.sortByDVP(component, "Type");
    	},
    
    sortDVPDate : function(component, event, helper){
        helper.sortByDVP(component, "StartDateTime");
    	},
    
    sortDVPDescription : function(component, event, helper){
        helper.sortByDVP(component, "Description");
    	},
    
    sortRVPName: function(component, event, helper) {
        helper.sortByRVP(component, "Owner.Name");
    	},
    
    sortRVPType : function(component, event, helper){
        helper.sortByRVP(component, "Type");
    	},
    
    sortRVPDate : function(component, event, helper){
        helper.sortByRVP(component, "StartDateTime");
    	},
    
    sortRVPDescription : function(component, event, helper){
        helper.sortByRVP(component, "Description");
    	},
    
    sortADOName: function(component, event, helper) {
        helper.sortByADO(component, "Owner.Name");
    	},
    
    sortADOType : function(component, event, helper){
        helper.sortByADO(component, "Type");
    	},
    
    sortADODate : function(component, event, helper){
        helper.sortByADO(component, "StartDateTime");
    	},
    
    sortADODescription : function(component, event, helper){
        helper.sortByADO(component, "Description");
    	},
    
    onTabChangeA : function(component, event, helper){
        component.set("v.letterStart", "a");
        component.set("v.letterEnd", "b");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}
        },
    
    onTabChangeB : function(component, event, helper){
        component.set("v.letterStart", "b");
        component.set("v.letterEnd", "c");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeC : function(component, event, helper){
        component.set("v.letterStart", "c");
        component.set("v.letterEnd", "d");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeD : function(component, event, helper){
        component.set("v.letterStart", "d");
        component.set("v.letterEnd", "e");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeE : function(component, event, helper){
        component.set("v.letterStart", "e");
        component.set("v.letterEnd", "f");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeF : function(component, event, helper){
        component.set("v.letterStart", "f");
        component.set("v.letterEnd", "g");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeG : function(component, event, helper){
        component.set("v.letterStart", "g");
        component.set("v.letterEnd", "h");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeH : function(component, event, helper){
        component.set("v.letterStart", "h");
        component.set("v.letterEnd", "i");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeI : function(component, event, helper){
        component.set("v.letterStart", "i");
        component.set("v.letterEnd", "j");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeJ : function(component, event, helper){
        component.set("v.letterStart", "j");
        component.set("v.letterEnd", "k");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeK : function(component, event, helper){
        component.set("v.letterStart", "k");
        component.set("v.letterEnd", "l");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeL : function(component, event, helper){
        component.set("v.letterStart", "l");
        component.set("v.letterEnd", "m");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeM : function(component, event, helper){
        component.set("v.letterStart", "m");
        component.set("v.letterEnd", "n");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeN : function(component, event, helper){
        component.set("v.letterStart", "n");
        component.set("v.letterEnd", "o");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeO : function(component, event, helper){
        component.set("v.letterStart", "o");
        component.set("v.letterEnd", "p");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}           
    	},
    
    onTabChangeP : function(component, event, helper){
        component.set("v.letterStart", "p");
        component.set("v.letterEnd", "q");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeQ : function(component, event, helper){
        component.set("v.letterStart", "q");
        component.set("v.letterEnd", "r");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeR : function(component, event, helper){
        component.set("v.letterStart", "r");
        component.set("v.letterEnd", "s");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeS : function(component, event, helper){
        component.set("v.letterStart", "s");
        component.set("v.letterEnd", "t");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeT : function(component, event, helper){
        component.set("v.letterStart", "t");
        component.set("v.letterEnd", "u");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeU : function(component, event, helper){
        component.set("v.letterStart", "u");
        component.set("v.letterEnd", "v");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeV : function(component, event, helper){
        component.set("v.letterStart", "v");
        component.set("v.letterEnd", "w");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeW : function(component, event, helper){
        component.set("v.letterStart", "w");
        component.set("v.letterEnd", "x");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeX : function(component, event, helper){
        component.set("v.letterStart", "x");
        component.set("v.letterEnd", "y");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeY : function(component, event, helper){
        component.set("v.letterStart", "y");
        component.set("v.letterEnd", "z");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    onTabChangeZ : function(component, event, helper){
        component.set("v.letterStart", "z");
        component.set("v.letterEnd", "zz");
        var report = component.find("InputSelectReport").get("v.value");
        if(report === 'All Accounts Reporting'){
        	helper.getAllRHBActive(component);                
        	}
        else if(report === 'NPS Activity Report' || report.includes("PDPM")){
            helper.getAllNPSPDPMActive(component);
        	}            
    	},
    
    downloadCsvAllAccount : function(component,event,helper){
            var stockData = [];
            var ready = component.get("v.processingFinished");
            if(ready === true){
                component.set("v.Spinner", true);
            var a = component.get("v.aList");
            var b = component.get("v.bList");
            var c = component.get("v.cList");
            var d = component.get("v.dList");
            var e = component.get("v.eList");
            var f = component.get("v.fList");
            var g = component.get("v.gList");
            var h = component.get("v.hList");
            var i = component.get("v.iList");
            var j = component.get("v.jList");
            var k = component.get("v.kList");
            var l = component.get("v.lList");
            var m = component.get("v.mList");
            var n = component.get("v.nList");
            var o = component.get("v.oList");
            var p = component.get("v.pList");
            var q = component.get("v.qList");
            var r = component.get("v.rList");
            var s = component.get("v.sList");
            var t = component.get("v.tList");
            var u = component.get("v.uList");
            var v = component.get("v.vList");
            var w = component.get("v.wList");
            var x = component.get("v.xList");
            var y = component.get("v.yList");
            var z = component.get("v.zList");
            
                if(a != null){
            for(var aa=0; aa< a.length; aa++){
                 	stockData.push(a[aa]);    
    				}
                }
                if(b != null){
            for(var bb=0; bb< b.length; bb++){
                 	stockData.push(b[bb]);    
    				}
                }
                if(c != null){
                for(var cc=0; cc< c.length; cc++){
                 	stockData.push(c[cc]);    
    				}
                }
                if(d != null){
                for(var dd=0; dd< d.length; dd++){
                 	stockData.push(d[dd]);    
    				}
                }
                if(e != null){
                for(var ee=0; ee< e.length; ee++){
                 	stockData.push(e[ee]);    
    				}
                }
                if(f != null){
                for(var ff=0; ff< f.length; ff++){
                 	stockData.push(f[ff]);    
    				}
                }
                if(g != null){
                for(var gg=0; gg< g.length; gg++){
                 	stockData.push(g[gg]);    
    				}
                }
                if(h != null){
                for(var hh=0; hh< h.length; hh++){
                 	stockData.push(h[hh]);    
    				}
                }
                if(i != null){
                for(var ii=0; ii< i.length; ii++){
                 	stockData.push(i[ii]);    
    				}
                }
                if(j != null){
                for(var jj=0; jj< j.length; jj++){
                 	stockData.push(j[jj]);    
    				}
                }
                if(k != null){
                for(var kk=0; kk< k.length; kk++){
                 	stockData.push(k[kk]);    
    				}
                }
                if(l != null){
                for(var ll=0; ll< l.length; ll++){
                 	stockData.push(l[ll]);    
    				}
                }
                if(m != null){
                for(var mm=0; mm< m.length; mm++){
                 	stockData.push(m[mm]);    
    				}
                }
                if(n != null){
                for(var nn=0; nn< n.length; nn++){
                 	stockData.push(n[nn]);    
    				}
                }
                if(o != null){
                for(var oo=0; oo< o.length; oo++){
                 	stockData.push(o[oo]);    
    				}
                }
                if(p != null){
                for(var pp=0; pp< p.length; pp++){
                 	stockData.push(p[pp]);    
    				}
                }
                if(q != null){
                for(var qq=0; qq< q.length; qq++){
                 	stockData.push(q[qq]);    
    				}
                }
                if(r != null){
                for(var rr=0; rr< r.length; rr++){
                 	stockData.push(r[rr]);    
    				}
                }
                if(s != null){
                for(var ss=0; ss< s.length; ss++){
                 	stockData.push(s[ss]);    
    				}
                }
                if(t != null){
                for(var tt=0; tt< t.length; tt++){
                 	stockData.push(t[tt]);    
    				}
                }
                if(u != null){
                for(var uu=0; uu< u.length; uu++){
                 	stockData.push(u[uu]);    
    				}
                }
                if(v != null){
                for(var vv=0; vv< v.length; vv++){
                 	stockData.push(v[vv]);    
    				}
                }
                if(w != null){
                for(var ww=0; ww< w.length; ww++){
                 	stockData.push(w[ww]);    
    				}
                }
                if(x != null){
                for(var xx=0; xx< x.length; xx++){
                 	stockData.push(x[xx]);    
    				}
                }
                if(y != null){
                for(var yy=0; yy< y.length; yy++){
                 	stockData.push(y[yy]);    
    				}
                }
                if(z != null){
                for(var zz=0; zz< z.length; zz++){
                 	stockData.push(z[zz]);    
    				}
                }
                var report = component.find("InputSelectReport").get("v.value");
        		
                if(report === 'All Accounts Reporting'){
        			var csv = helper.convertArrayOfObjectsToCSVAllAccount(component,stockData);
                    }
                else if(report === 'NPS Activity Report' || report.includes("PDPM")){
                	var csv = helper.convertArrayOfObjectsToCSVNPS(component,stockData);
                	}
        	if(csv == null){
            	return;
        		}
        	else{
                if(navigator.msSaveBlob){ // IE 10+ 
				   navigator.msSaveBlob(new Blob([csv], { type: 'text/csv;charset=utf-8;' }), "AccountTeamData.csv"); 
                   }
                else{
        			var hiddenElement = document.createElement('a');
          			hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
         			hiddenElement.target = '_self'; // 
          			hiddenElement.download = 'AccountTeamData.csv';
          			document.body.appendChild(hiddenElement);
    	  			hiddenElement.click();
                	}
                component.set("v.Spinner", false);
        		}
            }
            else{
                component.set("v.Spinner", false);
            	alert("Data Compliation of the report is not yet complete.  Please wait a few moments and then try your request again.");
        		}
        },
    
})