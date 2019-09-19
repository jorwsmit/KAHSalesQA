global class ContactGeocodeScheduledDetail {
	static public void doGeocoding() {
		//Set the number of records to send in each call to the @future method, and the total geocodable by this execution
		Integer recordsToGeocodeEachFuture = 1000;
		Integer maxFutureCalls = 1000;
		Integer totalGeocodable = maxFutureCalls * recordsToGeocodeEachFuture;
		
		//Set the max number of times the randomization loop will repeat in its attempt to get new geocodable items
		Integer loopCountSanityCheck = 99999;
		
		//Get some items that appear to be geocodable and yet do not have a valid geocode
		List<Contact> contacts = [SELECT Id FROM Contact WHERE (Geolocation__Latitude__s = null OR Geolocation__Longitude__s = null) AND MailingCity !=null AND MailingState !=null AND (RecordTypeID = '012c000000025bw' OR RecordTypeID = '012c000000025by' OR RecordTypeID = '012c000000025bx') ORDER BY LastModifiedDate DESC LIMIT 50000];
		
		//We will populate this object with the ids of the items to be geocoded
		Set<Id> idsToGeocode = new Set<Id>();
		
		//Variable to ensure sanity check on repeats of the randomization loop
		Integer loopCount = 0;
		
		//Get a batch of Ids to geocode
		while (idsToGeocode.size() < totalGeocodable && idsToGeoCode.size() < contacts.size() && loopCount < loopCountSanityCheck) {
			//Choose a selection space that will weight towards the low index (most recently modified) records
			Integer selectionSpace = Math.floor(Math.random() * contacts.size()).intValue() + 1;
			
			//Choose a random item from that space
			Integer itemIndex = Math.floor(Math.random() * selectionSpace).intValue();
			
			//Add to the set without duplicates
			idsToGeocode.Add(contacts[itemIndex].Id);
			
			//Increment loop count for sanity check
			loopCount++;
		}

		List<Id> chunk = new List<Id>();
		
		//Send in chunks based on limits for @future methods and web service callouts
		for(Id contactId : idsToGeocode) {
			chunk.Add(contactId);
			
			if(chunk.size() == recordsToGeocodeEachFuture) {
				ContactGeocodeCallout.doGeocodeRecords(chunk);
				chunk = new List<Id>();
			}
		}
		
		//Process any remainder
		if(chunk.size() > 0) {
			ContactGeocodeCallout.doGeocodeRecords(chunk);
		}
	}
	
}