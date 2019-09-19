global class Sales_ScheduleAssignedCountSP implements Schedulable {
	global void execute(SchedulableContext sc) {
		if(!Test.isRunningTest()) Database.executeBatch(new Sales_AssignedCountSP(), 200);
	}
}