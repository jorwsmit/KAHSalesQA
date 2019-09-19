@RestResource(urlMapping='/CollateralSubset/*')
global with sharing class iPathCollateralSearchController {

    private class searchFilters {
        String searchString;
        List<String> linesOfBusiness;
        List<String> audiences;
        Boolean isFacilitySpecific;
    }
    
    @HttpGet
    global static List<ContentVersion> doGet() {
        // Get search filters from request
        RestRequest req = RestContext.request;
        searchFilters filters = (searchFilters)System.JSON.deserialize(req.params.get('filters'), searchFilters.class);
        
        // Initialize base conditions
        String query = 'SELECT Id, Title, Audience_Tag__c, LOB__c, FileType, ContentDocumentId, IsLatest, ContentSize FROM ContentVersion WHERE IsLatest = true And Origin = \'C\' And FileType In (\'MP4\',\'PDF\')';
        
        // Add searchString filter if required 
        if(String.isNotBlank(filters.searchString)) {
            query = query + ' And Title LIKE \'%' + String.escapeSingleQuotes(filters.searchString) + '%\'';
        }
        
        // Add linesOfBusiness filter if required
        List<String> lobArray = new List<String>();
        for (String lob : filters.linesOfBusiness) {
            lobArray.add('\'' + String.escapeSingleQuotes(lob) + '\'');
        }
        if(!lobArray.isEmpty()) {
            query = query + ' And LOB__c Includes (' + String.join(lobArray,',') + ')';
        }
        
        // Add audiences filter if required
        List<String> audArray = new List<String>();
        for (String aud : filters.audiences) {
            audArray.add('\'' + String.escapeSingleQuotes(aud) + '\'');
        }
        if(!audArray.isEmpty()) {
            query = query + ' And Audience_Tag__c Includes (' + String.join(audArray,',') + ')';
        }
        
        // Get the ContentDocumentId's of all facility-specific documents
        Set<String> facilitySpecific = new Set<String>();
        for (AggregateResult aggregateResultRow : [SELECT Document_Id__c FROM Content_Link__c GROUP BY Document_Id__c HAVING Count(Account__c) > 0]) {
            facilitySpecific.Add(String.valueOf(aggregateResultRow.get('Document_Id__c')));
        }
              
        // Apply sort
        query = query + ' ORDER BY Title';
        
        // Get all the ContentVersion rows, intially without regard to isFacilitySpecific
        List<ContentVersion> allResults = Database.query(query);
        
        // Filter down according to the value of isFacilitySpecific
        List<ContentVersion> filteredResults = new List<ContentVersion>();
        for (ContentVersion result : allResults) {
            if(facilitySpecific.contains(string.ValueOf(result.ContentDocumentId)) == filters.isFacilitySpecific) {
                filteredResults.add(result);
            }
        }
        
        // Return filtered set to caller
        return filteredResults;
    }
    
}