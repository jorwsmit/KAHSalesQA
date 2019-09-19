global class AA_UserLocationCleanupScheduler implements schedulable{
	
	global void execute(SchedulableContext sc){
		AA_UserLocationCleanup.fetchRecords();
		}
    
}