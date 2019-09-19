public with sharing class AA_TranscriptCleaner {
    
    public static void getList(){
    	list<LiveChatTranscript> toUpdate = new list<LiveChatTranscript>();
    	toUpdate = [SELECT ID, Status, Body FROM LiveChatTranscript WHERE Status =: 'Completed' AND CreatedDate = LAST_N_DAYS:7];
    	for(LiveChatTranscript lct : toUpdate){
    		lct.Body = null;
    		}
    	
    	list<LiveChatTranscript> toCheck = new list<LiveChatTranscript>();
    	toCheck = [SELECT ID, Status, Body, Case.ID FROM LiveChatTranscript WHERE Status =: 'Missed' AND Case.Type = null AND CreatedDate < TODAY];
    	list<ID> ids = new list<ID>();
    	for(LiveChatTranscript ltc2: toCheck){
    		ids.add(ltc2.Case.ID);
    		}
    	list<Case> toDelete = new list<Case>();
    	toDelete = [SELECT ID FROM Case WHERE ID IN: ids];
    	delete toDelete;
    			
    	update toUpdate;
    	
    	
    	}
    
}