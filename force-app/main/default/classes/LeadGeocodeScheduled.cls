global class LeadGeocodeScheduled implements Schedulable {
	global void execute(SchedulableContext SC) {
		LeadGeocodeScheduledDetail.doGeocoding();
	}
	
}