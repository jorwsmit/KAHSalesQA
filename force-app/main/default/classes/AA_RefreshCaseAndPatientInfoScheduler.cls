global class AA_RefreshCaseAndPatientInfoScheduler implements schedulable{
    
    global void execute(SchedulableContext sc){  
        	AA_RefreshCaseAndPatientInfo.updateItems();
    		}
    
}