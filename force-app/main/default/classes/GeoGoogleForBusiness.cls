public class GeoGoogleForBusiness {
	static public HttpRequest GeocodeRequest (String mailingAddress) {
        // url encode the address, sanitizing the address for use within a url  
        String address = EncodingUtil.urlEncode(mailingAddress, 'UTF-8');  
          
        // set up url portions
        String domain = 'https://maps.googleapis.com';  
        String url = '/maps/api/geocode/json?address='+address+'&client=gme-kindredhealthcare';
        
        // convert private key to standard base64 from url-modified base64, this is the Google Maps for Business private key
        String privateKey = 'e-isrZFSV3YJSZCl0OKJfUgeRa4=';
        privateKey = privateKey.replace('-', '+');
        privateKey = privateKey.replace('_', '/');
        
        // generate binary of signature  
        Blob privateKeyBlob = EncodingUtil.base64Decode(privateKey);
        Blob urlBlob = Blob.valueOf(url);
        Blob signatureBlob = Crypto.generateMac('hmacSHA1', urlBlob, privateKeyBlob);

        // encode signature as url-modified base64 for transmission in url 
        String signature = EncodingUtil.base64Encode(signatureBlob);
        signature = signature.replace('+', '-');
        signature = signature.replace('/', '_');
       
        // build entire url to callout  
        String endpoint = domain + url + '&signature=' + signature;
          
        // build callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(60000);
        req.setHeader('Referer', 'http://kindredhealthcare.com');
        
        return req;
	}
	
	static public Map<String, Double> ExtractLatLong (String googleJsonResponse) {
		JSONParser parser = JSON.createParser(googleJsonResponse);
			
		double lat = null;
        double lon = null;
            
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
	               while (parser.nextToken() != JSONToken.END_OBJECT) {
	                   String txt = parser.getText();
	                   parser.nextToken();
	                   if (txt == 'lat')
	                       lat = parser.getDoubleValue();
	                   else if (txt == 'lng')
	                       lon = parser.getDoubleValue();
	               }
            }
        }
        
        //Must have good coords in both or we'll return nulls in both
        if(lat == null || lon == null) {
        	return new Map<String, Double> {'Latitude' => null, 'Longitude' => null};
        }
        else {
        	return new Map<String, Double> {'Latitude' => lat, 'Longitude' => lon};
        }
	}
	
	static public string ExtractLatLongAlt (String googleJsonResponse) {
		JSONParser parser = JSON.createParser(googleJsonResponse);
			string latLon = '';
		double lat = null;
        double lon = null;
            
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
	               while (parser.nextToken() != JSONToken.END_OBJECT) {
	                   String txt = parser.getText();
	                   parser.nextToken();
	                   if (txt == 'lat')
	                       lat = parser.getDoubleValue();
	                   else if (txt == 'lng')
	                       lon = parser.getDoubleValue();
	               }
            }
        }
        
        //Must have good coords in both or we'll return nulls in both
        if(lat == null || lon == null) {
        	return latLon;
        }
        else {
        	latLon = lat + ',' + lon;
        	return latLon;
        }
	}
	
	static public String AddressString (String street, String city, String state, String postalCode, String country) {
		String address = '';
        
        if (street != null)
            address += street +', ';
        if (city != null)
            address += city +', ';
        if (state != null)
            address += state +' ';
        if (postalCode != null)
            address += postalCode +', ';
        if (country != null)
            address += country;
            
        return address;
	}

}