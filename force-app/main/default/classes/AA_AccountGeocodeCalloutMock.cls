@isTest 
global class AA_AccountGeocodeCalloutMock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"location" : {"lat" : 37.42291810, "lng" : -122.08542120}}]');
        res.setStatusCode(200);
        return res;
        
    }
}