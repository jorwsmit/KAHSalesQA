/**
@ClassName    : TBN_LiveChatTranscriptHandler
@CreatedOn    : 20/12/2016
@ModifiedBy   : Rashmi, Ritika
@Description  : Trigger for LiveChatTranscript object which 
                i. Deletes the Case record at the end of the Chat if no attachments are there
                ii. Deletes the Case record when attachment is there after remapping the attachment to the newly created case
                
                
**/
public class TBN_LiveChatTranscriptHandler {
    
    //constructor
    public TBN_LiveChatTranscriptHandler(){
        
        //do nothing
    }
    
    /**
    @MethodName : onAfterUpdate
    @Param      : list<LiveChatTranscript> lstChatTranscripts
    @Description: 
    **/
    public void onAfterUpdate(list<LiveChatTranscript> lstChatTranscripts) {
        
        //Set<Id> setChatOwners = new Set<Id>();
        set<id> setCasesCreatedOnChat = new set<Id>();
        list<LiveChatTranscript> lstMissedChats = new list<LiveChatTranscript>();   // Lists being declined by Agent manually or due to unavailability
        
        for(LiveChatTranscript objLiveChatTranscript : lstChatTranscripts) {
            system.debug('>>>>>>>>>>>>>>>>>>>>>> ' + objLiveChatTranscript);
            if(objLiveChatTranscript.CaseId != null && objLiveChatTranscript.status == 'Completed') {
                
                setCasesCreatedOnChat.add(objLiveChatTranscript.CaseId);
            }
        }

        if(!setCasesCreatedOnChat.isEmpty())
            processTranscripts(setCasesCreatedOnChat);
    }
    
    /**
    @MethodName : processTranscripts
    @Param      : set<id> setCasesCreatedOnChat - Set of Cases created with Chat Transcript
    @Description: 
    **/
    public void processTranscripts(set<id> setCasesCreatedOnChat) {
        
        list<Case> lstCasestoDelete = new list<Case>();                                         // List of Cases to be deleted based on attachments
        list<Attachment> lstAttachmentToInsert = new list<Attachment>();                        // List of Attachments with updated Parent mapping
        list<LiveChatTranscript> lstCompletedChatsToUpdate = new list<LiveChatTranscript>();    // List of Chat records with updated CaseId field
        map<id,list<Attachment>> mapOldCaseToAttachments = new map<id,list<Attachment>>();      // Maps to attachments to create new attachments based on criteria
        
        // Query Old Cases for Chat Transcript and maintain the attachments for it in a map
        for(Attachment objAttachment : [select id, Name, Body, ContentType, ParentId
                                        from Attachment 
                                        where ParentId in :setCasesCreatedOnChat]) {
            
            if(mapOldCaseToAttachments.containsKey(objAttachment.ParentId))
                mapOldCaseToAttachments.get(objAttachment.ParentId).add(objAttachment);
            else 
                mapOldCaseToAttachments.put(objAttachment.ParentId, new List<Attachment>{objAttachment});
        }
        
        // Iterate through the live chat transcript records    
            // Query needed on existing records as we cannot update on record being inserted directly
        for(LiveChatTranscript objChatRecord : [select id, New_Case_Id__c, CaseId
                                                    from LiveChatTranscript 
                                                    where LiveChatTranscript.Case.Status != 'Closed' AND LiveChatTranscript.Case.Type = null AND LiveChatTranscript.CaseId in: setCasesCreatedOnChat]) {
            
            // Delete the old cases when no attachments are there on old cases
                // Or attachment exists along with the new Case Created/Updated from Case Entry/IVR page
            if(!mapOldCaseToAttachments.containsKey(objChatRecord.CaseId) || 
                    (mapOldCaseToAttachments.containsKey(objChatRecord.CaseId) && mapOldCaseToAttachments.get(objChatRecord.CaseId).isEmpty()) || 
                    (mapOldCaseToAttachments.containsKey(objChatRecord.CaseId) && !mapOldCaseToAttachments.get(objChatRecord.CaseId).isEmpty() && objChatRecord.New_Case_Id__c == null)) {
                    
                lstCasestoDelete.add(new Case(Id = objChatRecord.CaseId)); 
                
                objChatRecord.CaseId = objChatRecord.New_Case_Id__c;
                lstCompletedChatsToUpdate.add(objChatRecord);
            }
            
            // If a new Case has been Created/Updated for this transcript, remap the attachments to new case 
                // And update the Chat Transcript record
            else if(objChatRecord.New_Case_Id__c != null && mapOldCaseToAttachments.containsKey(objChatRecord.CaseId)) {
                
                lstCasestoDelete.add(new Case(Id = objChatRecord.CaseId));
                
                // Create new records for attachments - As old records are deleted when old Case is deleted due to default behavior of Salesforce  
                for(Attachment objAttachOld : mapOldCaseToAttachments.get(objChatRecord.CaseId)) { 
                    
                    lstAttachmentToInsert.add( new Attachment(  Name = objAttachOld.Name,
                                                                Body = objAttachOld.Body,
                                                                ContentType = objAttachOld.ContentType,
                                                                Parentid = objChatRecord.New_Case_Id__c));
                }
                
                objChatRecord.CaseId = objChatRecord.New_Case_Id__c;
                lstCompletedChatsToUpdate.add(objChatRecord);
            }
        }
        
        if(!lstAttachmentToInsert.isEmpty())
            insert lstAttachmentToInsert;
            
        if(!lstCompletedChatsToUpdate.isEmpty())
            update lstCompletedChatsToUpdate;
            
        if(!lstCasestoDelete.isEmpty())
            delete lstCasestoDelete;
    }
}