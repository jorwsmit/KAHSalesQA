trigger ContentDocumentTrigger on ContentDocument (after update, before update, before delete) {
    
    if(trigger.isafter && trigger.isupdate){
        list<string> titlelist = new list<String>();
        list<Content_Link__c> contentLinkList = new list<Content_Link__c>();
        for(ContentDocument cd : trigger.new){
            if(cd.PublishStatus == 'P' && cd.FileType != 'SNOTE'){
            	titlelist.add(cd.title);
            	}
        }
        list<ContentVersion> versionList = new list<ContentVersion>();
        set<ContentVersion> cleanList = new set<ContentVersion>();
        versionList = [SELECT id
                                ,ContentDocumentID
                                ,Title
                                ,Center__c
                                ,Program__c
                       FROM ContentVersion
                       WHERE Title in :titlelist
                       AND (Center__c != null
                       OR Program__c != null)];
        
        cleanList.addAll(versionList);
        for(ContentVersion cv : cleanList){
            contentLinkList.add(new Content_Link__c(
                                                        Document_Id__c = cv.ContentDocumentID
                                                        ,Document_Name__c=cv.Title
                                                        ,Account__c= cv.Center__c
                                                        ,Program__c = cv.Program__c));
        }
        insert contentLinkList;               
    }
    
}