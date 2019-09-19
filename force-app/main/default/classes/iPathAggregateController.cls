@RestResource(urlMapping='/Aggregate/*')
global with sharing class iPathAggregateController {

    @HttpGet
    global static Aggregate doGet() {
        RestRequest req = RestContext.request;
        string userid = req.params.get('UserId');
        
        try {
            User user = [SELECT FirstName, LastName, Title, Email, Phone, MobilePhone,
             Street, City, State, PostalCode, Country, LevelOfCare__c, Username, PERNER__c
             FROM User WHERE Id = :userid];
             
            List<Market__c> markets = [SELECT Id, Name FROM Market__c];
             
            List<wrapPickListEntry> audiences = getAudiences();
            
            List<wrapPickListEntry> linesOfBusiness = getLinesOfBusiness();
            
            return new Aggregate(user, markets, audiences, linesOfBusiness);         
        }
        catch (exception e) {
            return null;
        }
    }
    
    global class Aggregate {
        public User user {get; set;}
        public List<wrapMarket> markets {get; set;}
        public List<wrapPickListEntry> audiences {get; set;}
        public List<wrapPicklistEntry> linesOfBusiness {get; set;}
        
        public Aggregate(User u, List<Market__c> ms, List<wrapPickListEntry> a, List<wrapPickListEntry> lobs) {
            user = u;
            
            markets = new List<wrapMarket>();
            
            for (Market__c m:ms) {
                markets.add(new wrapMarket(m));
            }
        
			audiences = a;        
			linesOfBusiness = lobs;
        }
    }
    
    private static List<wrapPickListEntry> getAudiences() {
    	List<wrapPickListEntry> result = new List<wrapPickListEntry>();
        
  	    Schema.DescribeFieldResult fieldResult = ContentVersion.Audience_Tag__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
		for(Schema.PicklistEntry f : ple) {
			result.add(new wrapPickListEntry(f));
		}       
   		
   		return result;
    }
    
    private static List<wrapPickListEntry> getLinesOfBusiness() {
    	List<wrapPickListEntry> result = new List<wrapPickListEntry>();
        
  	    Schema.DescribeFieldResult fieldResult = ContentVersion.LOB__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
		for(Schema.PicklistEntry f : ple) {
			result.add(new wrapPickListEntry(f));
		}       
   		
   		return result;
    }
    
    //Wrapping the data removes the 'attributes' field from the JSON response, saving bandwidth
    public class wrapMarket {
        public Id Id;
        public String Name;
        
        public wrapMarket(Market__c m) {
            this.Id = m.Id;
            this.Name = m.Name;
        }
    }
    
    public class wrapPickListEntry {
    	public String Id;
    	public String Name;
    	
    	public wrapPickListEntry(Schema.PicklistEntry ple) {
            this.Id = ple.getValue();
            this.Name = ple.getLabel();
        }
    }
  
}