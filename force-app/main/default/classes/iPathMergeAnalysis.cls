public class iPathMergeAnalysis {
    
    static public Set<Id> ConvertToWinnerIds (Set<Id> challengeSet) {
        // The parameter passed in contains ids of accounts, contacts and/or leads any of which may point to a merge winner or loser
        // This method replaces every loser id in the parameter with the ultimate merge winner id (only replaces ids that have ever been merge losers)
        // This enables iPath sync controllers to replace merge loser ids with the respective winner ids in order to auto-update the app
        // Note: sanity check in this method or unforeseen errors in try-catch could cause this method to return "no change" or intermediate resultset
        
        if(challengeSet == null || challengeSet.size() == 0) {
            // Handle case where we've been passed invalid data, in which case just return empty set
            return new Set<Id>();
        }
        else {    
            List<String> oldList = idSetToStringList(challengeSet);
            Boolean finished = false;
            Integer sanityCheck_MaxIterations = 20;
            Integer iteration = 0;
            
            try {
	            // Repeatedly check for higher order winners until no change in the result (i.e. we've found them all)
	            while(!finished && iteration < sanityCheck_MaxIterations) {
	                List<String> newList = GetWinnerIdsWithSinglePass(oldList);
	                
	                if(newList.equals(oldList)) {
	                    finished = true;
	                }
	                else {
	                    oldList = new List<String>(newList);
	                }
	                
	                iteration++;
	            }
            }
            catch (Exception e) {
            	System.debug('Exception in ConvertToWinnerIds: ' + e.getMessage());
            	
            	// In the event of any error, we'll just make sure we pass back to the caller whatever was passed in
            	// Note this will not catch breaches in governor limits, those cannot be handled
            	oldList = idSetToStringList(challengeSet);
            }
             
            return stringListToIdSet(oldList);
        }
    }
    
    static private Set<Id> stringListToIdSet (List<String> inputList) {
    	// Converts a list of string values of Ids to a set of those Ids (duplicates removed)
    	
    	if(inputList == null || inputList.size() == 0) {
            // Handle case where we've been passed invalid data, in which case just return empty set
            return new Set<Id>();
        }
        else {
        	Set<Id> result = new Set<Id>();
            
            for(String someString : inputList) {
            	result.add(Id.valueOf(someString));
            }
            
            return result;
        }
    }
    
    static private List<String> idSetToStringList (Set<Id> inputSet) {
    	// Converts a set of Ids to a list of string values of those Ids
    	
    	if(inputSet == null || inputSet.size() == 0) {
            // Handle case where we've been passed invalid data, in which case just return empty list
            return new List<String>();
        }
        else {
        	List<String> result = new List<String>();
            
            for(Id someId : inputSet) {
            	result.add(someId);
            }
            
            return result;
        }
    }
    
    static private List<String> GetWinnerIdsWithSinglePass (List<String> oldIds) {
        // Updates any loser ids in the parameter to their respective first-merge winners
        // Note any first-merge winner can also be a loser to a subsequent winner, those are handled in further passes through this method
        
        if(oldIds == null || oldIds.size() == 0) {
        	// Handle case where we've been passed invalid data, in which case just return empty list
        	return new List<String>();
        }
        else {
            // Find all the ids that need updating and what they should be updated to 
            Map<String, String> loserWinnerMap = new Map<String, String>();
		    
		    for (Merge__c m : [SELECT LoserId__c, WinnerId__c FROM Merge__c WHERE LoserId__c IN :oldIds]) {
		        loserWinnerMap.put(m.LoserId__c, m.WinnerId__c);
		    }
		    
		    List<String> resultIds = new List<String>();
		    
		    // Iterate through the parameter, replacing any loser with its respective winner, leaves non-losers alone
		    System.debug(oldIds);
		    
		    for (String someId : oldIds) {
		    	String winnerId = loserWinnerMap.get(someId);
		    	
		    	if(winnerId == null) {
		    		resultIds.add(someId);
		    	}
		    	else {
		    		resultIds.add(winnerId);
		    	}
		    }
		    
		    return resultIds;
        }
    }
    
}