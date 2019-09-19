public class AccountGeocodeCallout {
	//Runs async and does a batch of Google callouts/geocode updates (note - ignores more than the max!)
	@future (callout=true) 
    static public void doGeocodeRecords(List<Id> accountIds) {
    	Integer maxCallouts = 10;
        Integer calloutCount = 0;
        
        List<Account> accounts = [SELECT ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet FROM Account WHERE Id IN :accountIds];
        
        for(Account account : accounts) {
        	Map<String,Double> geocode = geocodeFromCallout(account);	
        	calloutCount++;
        	
        	account.Shipping_Geolocation__Latitude__s = geocode.get('Latitude');
            account.Shipping_Geolocation__Longitude__s = geocode.get('Longitude');
            
            if(calloutCount>=maxCallouts) {
	        	break;
	        }
        }
        
        update accounts;
    }
         
    //Calls out to the geocode service and returns the geolocation lat/long, or nulls if none is retrieved
    static private Map<String,Double> geocodeFromCallout(Account a) { 
    	// init variable to hold our result latitude and longitude
        Map<String, Double> geocode = new Map<String, Double> {'Latitude' => null, 'Longitude' => null};
        HttpResponse res = new HttpResponse();    
        try {
            // create an address string
        	String address = GeoGoogleForBusiness.AddressString(a.ShippingStreet, a.ShippingCity, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry);
            // callout to get geocode from Google service
            	HttpRequest req = GeoGoogleForBusiness.GeocodeRequest(address);
                Http h = new Http();
            // allow follow on lines to proceed for code coverage if this is a test
            if(Test.isRunningTest()) {
            	//Arbitrary test code (to dodge callout if testing), should ideally be mocked in a test class
            	Test.setMock(HttpCalloutMock.class, new AA_AccountGeocodeCalloutMock());
            	res = AA_CalloutClass.getInfoFromExternalService();     
            	}
            else{	
            	res = h.send(req);
            	}
            	String jsonResult = res.getBody();
            	System.Debug(jsonResult);
            	geocode = GeoGoogleForBusiness.ExtractLatLong(jsonResult);
        }
        catch (Exception e) {
        	System.debug(e.getMessage());
        }
        
        return geocode;
    }
    
}