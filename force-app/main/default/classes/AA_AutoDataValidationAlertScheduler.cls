global class AA_AutoDataValidationAlertScheduler implements schedulable{

	global void execute(schedulableContext SC){
		AA_AutoDataValidationAlert.searchRecords();
		}
    
}