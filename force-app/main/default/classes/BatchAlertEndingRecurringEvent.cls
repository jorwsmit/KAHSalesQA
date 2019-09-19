global class BatchAlertEndingRecurringEvent implements Database.Batchable<sObject> {
    //execute this batch job in an execute anonymous window
    //set the query to include certain profiles instead of all users because the default will most likely fail
    //an example execution is below
    
    /*
     BatchAlertEndingRecurringEvent b = new BatchAlertEndingRecurringEvent();
     String query = 'select Id, OwnerId, Owner.Email from event where (Owner.Profile.Name = \'KAH Sales Associate\' or Owner.Profile.Name = \'KAH Manager\')and IsRecurrence = TRUE and RecurrenceEndDateOnly = NEXT_N_DAYS:7';
     b.query = query;
     Database.executeBatch(b);
    */
    
    //global string query;
    global string query = 'select Id, OwnerId, Owner.Email from event IsRecurrence = TRUE and RecurrenceEndDateOnly = NEXT_N_DAYS:7 Limit 10000';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }//end QueryLocator    
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        for(sObject s : scope){
            Event e = (Event)s;
            EmailTemplate emailTemplate = [select Id, Body  from EmailTemplate where Name = 'RecurringEventsAlert'];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {e.Owner.Email});
            email.setSaveAsActivity(false);
            email.setTargetObjectId(e.OwnerId);
            email.setTemplateId(emailTemplate.Id);
            email.setWhatId(e.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }//end for events
    }//end execute
    
    global void finish(Database.BatchableContext bc) {
        
    }//end finish
    
}//end BatchAlertEndingRecurringEvent