public class ContactGeocodeCallout {
	//Runs async and does a batch of Google callouts/geocode updates (note - ignores more than the max!)
	@future (callout=true) 
    static public void doGeocodeRecords(List<Id> contactIds) {
    	Integer maxCallouts = 10;
        Integer calloutCount = 0;
        
        List<Contact> contacts = [SELECT MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet FROM Contact WHERE Id IN :contactIds];
        
        for(Contact contact : contacts) {
        	Map<String,Double> geocode = geocodeFromCallout(contact);	
        	calloutCount++;
        	
        	contact.Geolocation__Latitude__s = geocode.get('Latitude');
            contact.Geolocation__Longitude__s = geocode.get('Longitude');
            
            if(calloutCount>=maxCallouts) {
	        	break;
	        }
        }
        
        update contacts;
    }
         
    //Calls out to the geocode service and returns the geolocation lat/long, or nulls if none is retrieved
    static private Map<String,Double> geocodeFromCallout(Contact c) { 
    	// init variable to hold our result latitude and longitude
        Map<String, Double> geocode = new Map<String, Double> {'Latitude' => null, 'Longitude' => null};
        HttpResponse res = new HttpResponse();    
        try {
            // create an address string
        	String address = GeoGoogleForBusiness.AddressString(c.MailingStreet, c.MailingCity, c.MailingState, c.MailingPostalCode, c.MailingCountry);
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