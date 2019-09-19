trigger TBN_LiveChatTranscript on LiveChatTranscript (after update) {
    
    TBN_LiveChatTranscriptHandler objHandler = new TBN_LiveChatTranscriptHandler();
    
    if( trigger.isafter && trigger.isUpdate ) {
        
        if( RecusrionHelper.runOnce() ) {

            objHandler.onAfterUpdate(trigger.new);
        }
    }

}