global class ContactGeocodeScheduled implements Schedulable {
	global void execute(SchedulableContext SC) {
    	ContactGeocodeScheduledDetail.doGeocoding();
	}
	
}