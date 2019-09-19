global class AccountGeocodeScheduled implements Schedulable {
	global void execute(SchedulableContext SC) {
    	AccountGeocodeScheduledDetail.doGeocoding();
	}
	
}