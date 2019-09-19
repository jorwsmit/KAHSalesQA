global class LeadGeocodeScheduledDetail {
	static public void doGeocoding() {
		//Set the number of records to send in each call to the @future method, and the total geocodable by this execution
		Integer recordsToGeocodeEachFuture = 10;
		Integer maxFutureCalls = 1;
		Integer totalGeocodable = maxFutureCalls * recordsToGeocodeEachFuture;
		
		//Set the max number of times the randomization loop will repeat in its attempt to get new geocodable items
		Integer loopCountSanityCheck = 99999;
		
		//Get some items that appear to be geocodable and yet do not have a valid geocode
		List<Lead> leads = [SELECT Id FROM Lead WHERE (Geolocation__Latitude__s = null OR Geolocation__Longitude__s = null) AND City !=null AND State !=null AND IsConverted = false ORDER BY LastModifiedDate DESC LIMIT 50000];
		
		//We will populate this object with the ids of the items to be geocoded
		Set<Id> idsToGeocode = new Set<Id>();
		
		//Variable to ensure sanity check on repeats of the randomization loop
		Integer loopCount = 0;
		
		//Get a batch of Ids to geocode
		while (idsToGeocode.size() < totalGeocodable && idsToGeoCode.size() < leads.size() && loopCount < loopCountSanityCheck) {
			//Choose a selection space that will weight towards the low index (most recently modified) records
			Integer selectionSpace = Math.floor(Math.random() * leads.size()).intValue() + 1;
			
			//Choose a random item from that space
			Integer itemIndex = Math.floor(Math.random() * selectionSpace).intValue();
			
			//Add to the set without duplicates
			idsToGeocode.Add(leads[itemIndex].Id);
			
			//Increment loop count for sanity check
			loopCount++;
		}

		List<Id> chunk = new List<Id>();
		
		//Send in chunks based on limits for @future methods and web service callouts
		for(Id leadId : idsToGeocode) {
			chunk.Add(leadId);
			
			if(chunk.size() == recordsToGeocodeEachFuture) {
				LeadGeocodeCallout.doGeocodeRecords(chunk);
				chunk = new List<Id>();
			}
		}
		
		//Process any remainder
		if(chunk.size() > 0) {
			LeadGeocodeCallout.doGeocodeRecords(chunk);
		}
	}
	
}