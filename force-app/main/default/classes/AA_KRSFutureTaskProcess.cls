public with sharing class AA_KRSFutureTaskProcess{

    public static ID pfID = AA_UtilityClass.getkrsEvent;

    public static void processTasks(){
        list<String> stages = new list<String>();
        
        stages.add('Closed Won');
        stages.add('Closed-RHB Declined');
        stages.add('Closed Lost');
        
        try{
        Date dt = Date.newInstance(system.today().year(), system.today().month()-21, (system.today().day() + 1));
        system.debug('Date check: ' + dt);
        list<Event> events = new list<Event>();
        list<Opportunity> opps = new list<Opportunity>();
        opps = [SELECT ID, CloseDate, Account.ID, StageName, KRS_Future_Task__c, KRS_Future_Task_Assigned__c FROM Opportunity WHERE KRS_Future_Task__c = true AND CloseDate <=: dt and StageName IN: stages AND KRS_Future_Task_Assigned__c = false];
        
        if(opps.size() > 0){
            list<Opportunity> toUpdate = new list<Opportunity>();
            map<String, ID> info = AA_UtilityClass.getSRSInfo;
        
            
    		list<ID> accountIDs = new list<ID>();
    		list<Account> accounts = new list<Account>();   
    		map<ID, ID> accountAndUsers = new map<ID, ID>();
        
        	for(Opportunity o : opps){
            	accountIDs.add(o.Account.ID);
            	}
        
    	accounts = [SELECT ID, KRS_SRS_BDO_Territory3__c FROM Account WHERE ID IN: accountIDs];
        system.debug('Accounts: ' + accounts);
        system.debug('Info: ' + info);
        for(Account a: accounts){
            if(info.get(a.KRS_SRS_BDO_Territory3__c) != null){
                accountAndUsers.put(a.ID, info.get(a.KRS_SRS_BDO_Territory3__c));
                }
            }
        Time myTime = Time.newInstance(13, 0, 0, 0);
        DateTime dt2 = DateTime.newInstance(system.today(), myTime);    
        for(Opportunity o : opps){
                Event e = new Event(OwnerID = accountAndUsers.get(o.Account.Id),
                                    StartDateTime = dt2,
                                    Type = 'Prepare Presentation',
                                    WhatID = o.Account.ID,
                                    RecordTypeID = pfID
                                    );
            
            if(o.StageName == 'Closed-RHB Declined' || o.StageName == 'Closed Lost'){
                    e.Subject = 'Re-try previously lost business';
                    e.Description = 'There was a previous attempt at this location to sign them for business, but two years have now passed, please review the account and, if appropriate, attempt to re-establish contact in the event their needs have changed.';
                    }
                else{
                    e.Subject = 'Retain or enhance business relationship';
                    e.Description = 'It has been close to two years since we entered into an agreement with this facility.  Please follow up with them is not done recently and see if there\'s anything they need in regards to renewal or adding new services.';
                    }
                                    
                events.add(e);
                o.KRS_Future_Task_Assigned__c = true;
                toUpdate.add(o);                    
            }   
            }
            
        if(events.size() > 0){
            insert events;
            }
        }
        catch(Exception E){
        system.debug('This');
        }
        }   
         
    
}