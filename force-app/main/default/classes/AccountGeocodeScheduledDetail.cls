global class AccountGeocodeScheduledDetail {
	static public void doGeocoding() {
		//Set the number of records to send in each call to the @future method, and the total geocodable by this execution
		Integer recordsToGeocodeEachFuture = 1000;
		Integer maxFutureCalls = 1000;
		Integer totalGeocodable = maxFutureCalls * recordsToGeocodeEachFuture;
		
		//Set the max number of times the randomization loop will repeat in its attempt to get new geocodable items
		Integer loopCountSanityCheck = 99999;
		
		//Get some items that appear to be geocodable and yet do not have a valid geocode
		List<Account> accounts = [SELECT Id FROM Account WHERE (Shipping_Geolocation__Latitude__s = null OR Shipping_Geolocation__Longitude__s = null) AND ShippingCity !=null AND ShippingState !=null ORDER BY LastModifiedDate DESC LIMIT 50000];
		
		//We will populate this object with the ids of the items to be geocoded
		Set<Id> idsToGeocode = new Set<Id>();
		
		//Variable to ensure sanity check on repeats of the randomization loop
		Integer loopCount = 0;
		
		//Get a batch of Ids to geocode
		while (idsToGeocode.size() < totalGeocodable && idsToGeoCode.size() < accounts.size() && loopCount < loopCountSanityCheck) {
			//Choose a selection space that will weight towards the low index (most recently modified) records
			Integer selectionSpace = Math.floor(Math.random() * accounts.size()).intValue() + 1;
			
			//Choose a random item from that space
			Integer itemIndex = Math.floor(Math.random() * selectionSpace).intValue();
			
			//Add to the set without duplicates
			idsToGeocode.Add(accounts[itemIndex].Id);
			
			//Increment loop count for sanity check
			loopCount++;
		}

		List<Id> chunk = new List<Id>();
		
		//Send in chunks based on limits for @future methods and web service callouts
		for(Id accountId : idsToGeocode) {
			chunk.Add(accountId);
			
			if(chunk.size() == recordsToGeocodeEachFuture) {
				AccountGeocodeCallout.doGeocodeRecords(chunk);
				chunk = new List<Id>();
			}
		}
		
		//Process any remainder
		if(chunk.size() > 0) {
			AccountGeocodeCallout.doGeocodeRecords(chunk);
		}
	}
	
}