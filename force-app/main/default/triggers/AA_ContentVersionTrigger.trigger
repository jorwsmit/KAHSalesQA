trigger AA_ContentVersionTrigger on ContentVersion (before insert, before update) {
  
  if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
            for(ContentVersion cv : trigger.new){
                system.debug('cv: ' + cv);
                system.debug('Library: ' + cv.FirstPublishLocationID);
                system.debug('Tag: ' + cv.Lightning_Tag__c);
                if(cv.TagCsv == null && cv.Lightning_Tag__c != null){
                    cv.TagCsv = cv.Lightning_Tag__c;
                    }
                }
            
        }
    
}