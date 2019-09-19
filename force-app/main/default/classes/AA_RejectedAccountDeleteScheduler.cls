global class AA_RejectedAccountDeleteScheduler implements schedulable{
	
	global void execute(SchedulableContext sc){
    	AA_RejectedAccountDelete.deleteAccounts();
    	}
    
}