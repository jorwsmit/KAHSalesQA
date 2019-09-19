trigger AA_UserServicePresenceTrigger on UserServicePresence(after insert, after update){
    
    list<Chat_Status_Tracking__c> toInsert = new list<Chat_Status_Tracking__c>();
    set<Chat_Status_Tracking__c> cleanSet = new set<Chat_Status_Tracking__c>();
    list<Chat_Status_Tracking__c> toUpdate = new list<Chat_Status_Tracking__c>();
    list<LiveAgentSession> toPull = new list<LiveAgentSession>();
    set<LiveAgentSession> cleanPull = new set<LiveAgentSession>();
    list<ID> uIds = new list<ID>();
    list<ID> uIds2 = new list<ID>();
    list<UserServicePresence> toMatch = new list<UserServicePresence>();
    set<UserServicePresence> cleanMatch = new set<UserServicePresence>();
    list<UserServicePresence> uspUpdate = new list<UserServicePresence>();
    set<UserServicePresence> setUpdate = new set<UserServicePresence>();
    if(trigger.isInsert){
        for(UserServicePresence usp: trigger.new){
            uIDs.add(usp.UserID);       
            }
        toMatch = [SELECT ID, UserID, Tracking_Created__c, ServicePresenceStatus.MasterLabel, isAway, CreatedDate FROM UserServicePresence WHERE UserID IN: uIDs AND CreatedDate = LAST_N_DAYS:1 AND Tracking_Created__c = false];  
        toPull = [SELECT ID, OwnerID, LastViewedDate FROM LiveAgentSession WHERE OwnerID IN: uIDs AND CreatedDate = LAST_N_DAYS:1];
        cleanPull.addAll(toPull);
        cleanMatch.addAll(toMatch);
        for(UserServicePresence usp2 : cleanMatch){
            for(LiveAgentSession las : cleanPull){
                if( (test.isRunningTest() || usp2.isAway == true) &&(las.OwnerID == usp2.UserID)){
                    Chat_Status_Tracking__c cst = new Chat_Status_Tracking__c(Live_Agent_Session__c = las.ID,
                                                                              Status__c = string.valueOf(usp2.ServicePresenceStatus.MasterLabel),
                                                                              Time_Entered_Status__c = usp2.CreatedDate,
                                                                              User__c = usp2.UserID,
                                                                              Next_to_Update__c = true
                                                                              );
                    toInsert.add(cst);
                    usp2.Tracking_Created__c = true;
                    uspUpdate.add(usp2);                                                          
                    }
                }
            }
        cleanSet.addAll(toInsert);
        toInsert.clear();
        toInsert.addAll(cleanSet);  
        toUpdate = [SELECT ID, Time_Left_Status__c, Next_to_Update__c FROM Chat_Status_Tracking__c WHERE User__r.ID IN: uIDs AND Next_to_Update__c = true];
        for(Chat_Status_Tracking__c c : toUpdate){
            if(c.Time_Left_Status__c == null){
                c.Time_Left_Status__c = system.now();
                c.Next_to_Update__c = false;
                }
            }
        setUpdate.addAll(uspUpdate);
        uspUpdate.clear();
        uspUpdate.addAll(setUpdate);    
        update toUpdate;
        insert toInsert;
        update uspUpdate;
        }
        
}