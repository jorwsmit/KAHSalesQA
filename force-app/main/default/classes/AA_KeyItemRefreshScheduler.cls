global class AA_KeyItemRefreshScheduler implements schedulable{
    
    global void execute(schedulableContext SC){
    	AA_KeyItemRefresh.refreshItems();
    	}
    
}