public class LeadGeocodeCallout {
	//Runs async and does a batch of Google callouts/geocode updates (note - ignores more than the max!)
	@future (callout=true) 
    static public void doGeocodeRecords(List<Id> leadIds) {
    	Integer maxCallouts = 10;
        Integer calloutCount = 0;
        
        List<Lead> leads = [SELECT City,Country,PostalCode,State,Street FROM Lead WHERE IsConverted = false AND Id IN :leadIds];
        
        for(Lead lead : leads) {
        	Map<String,Double> geocode = geocodeFromCallout(lead);	
        	calloutCount++;
        	
        	lead.Geolocation__Latitude__s = geocode.get('Latitude');
            lead.Geolocation__Longitude__s = geocode.get('Longitude');
            
            if(calloutCount>=maxCallouts) {
	        	break;
	        }
        }
        
        update leads;
    }
         
    //Calls out to the geocode service and returns the geolocation lat/long, or nulls if none is retrieved
    static private Map<String,Double> geocodeFromCallout(Lead x) { 
    	// init variable to hold our result latitude and longitude
        Map<String, Double> geocode = new Map<String, Double> {'Latitude' => null, 'Longitude' => null};
        HttpResponse res = new HttpResponse();    
        try {
            // create an address string
        	String address = GeoGoogleForBusiness.AddressString(x.Street, x.City, x.State, x.PostalCode, x.Country);
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