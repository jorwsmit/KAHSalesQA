global class AA_KRSFutureTaskProcessScheduler implements schedulable{
    
    global void execute(SchedulableContext sc){
    	AA_KRSFutureTaskProcess.processTasks();
    	}
    
}