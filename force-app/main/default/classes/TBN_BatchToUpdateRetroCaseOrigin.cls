public with sharing class TBN_BatchToUpdateRetroCaseOrigin implements Database.batchable<sObject> {
    
    /* BATCH CALL - TBN_BatchToUpdateRetroCaseOrigin objBatchInstance = new TBN_BatchToUpdateRetroCaseOrigin(   'Select ContactId, Origin ' + 
                                                                                                                'From Case ' + 
                                                                                                                'Where Origin != null AND ' +
                                                                                                                       'ContactId != null ' + 
                                                                                                                       'Order By ContactId, LastModifiedDate');
                    Database.executeBatch(objBatchInstance, 2000);
    */
    
    
    private String strQuery;
    
    /**
        @MethodName : TBN_BatchToRollupInitialMetrics
        @param      : None
        @Description: Constructor for batch
    */
    public TBN_BatchToUpdateRetroCaseOrigin( String strQuery ) {
        
        this.strQuery = strQuery;
    }
   
    /**
        @MethodName : start
        @param      : Database.batchableContext batchableContext
        @Description: This method is called first time during batch execution, in this method we are retrieving records and passes it to execute method for further processing.
    */
    public Database.QueryLocator start(Database.batchableContext batchableContext) {
       
       	return Database.getQueryLocator( this.strQuery );
    }
   
    /**
        @MethodName : execute
        @param1      : Database.BatchableContext batchableContext
        @param2      : List<sObject> scope
        @Description: This method is called after start and perform the activity on the records coming from start.
    */
    public void execute(Database.BatchableContext batchableContext, List<Case> scope)  {
        /*
        Set<Id> setUniqueContacts = new Set<Id>();
        List<Contact> lstContactsToUpdate = new List<Contact>();
        
        // Iterating through Case records to identify cases with Origin specified and update that value in related contact record
	   	for(Case objCase : scope) {
	   	    
	   	    // If the contact has not already been added to be updated, update the most recent modified record
	   	    if( !setUniqueContacts.contains(objCase.ContactId) ) {
    	   	 
    	   	    Contact objContact = new Contact(Id = objCase.ContactId, Case_Origin__c = objCase.Origin);
                lstContactsToUpdate.add(objContact);
                
                setUniqueContacts.add(objCase.ContactId);
	   	    }
	   	}
	   	
	   	// Update Related Contacts
        if(!lstContactsToUpdate.isEmpty()) {
            
            update lstContactsToUpdate;
        }*/
    }
    
    /**
        @MethodName : finish
        @param      : Database.BatchableContext batchableContext
        @Description: This method is called at the last of batch execution.
    */
    public void finish(Database.BatchableContext batchableContext) {
        
    }
}