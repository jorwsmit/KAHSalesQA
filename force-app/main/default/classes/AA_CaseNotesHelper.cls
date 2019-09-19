public with sharing class AA_CaseNotesHelper{
	
	public static void processNotes(list<ID> caseIDs){
		
		set<Case> casesToProcess = new set<Case>();
		list<Case> casesToUpdate = new list<Case>();
		list<Case> caseSearch = new list<Case>();
		set<Case> cleanCasestoUpdate = new set<Case>();
		
		caseSearch = [SELECT ID, Case_Notes__c, Description FROM Case WHERE ID IN: caseIDs];
		system.debug('caseSearch: ' + caseSearch.size());
		casesToProcess.addAll(caseSearch);
		system.debug('casesToProcess: ' + casesToProcess.size());
		for(Case c: casesToProcess){
			list<ContentNote> history = new list<ContentNote>();
			list<ContentDocumentLink> linkList = new list<ContentDocumentLink>();
    		list<ID> linkIDs = new list<ID>();
    		linkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: c.id];
    		for(ContentDocumentLink cdl : linkList){
    			linkIDs.add(cdl.ContentDocumentId);
    			}	
    		history = [SELECT ID, Title, TextPreview, CreatedDate, OwnerID, LastModifiedDate FROM ContentNote WHERE ID IN: linkIDs];
			string noteBody = c.Case_Notes__c;
			if(history.size() <= 0){
				if(noteBody != null){
					try{
						ContentNote n = new ContentNote(Title = 'Note on: ' + string.valueof(system.today()), Content = blob.valueOf(noteBody));
						insert n;
						ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityID = c.ID, ContentDocumentId = n.Id, ShareType = 'V');
						insert cdl;
        				c.Case_Notes__c = '';
           				c.Description = '';
           				casesToUpdate.add(c);
						}
					catch(Exception e){
						system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
						}
				}
				}
			else{
				set<ContentNote> noteSet = new set<ContentNote>();
				for(ContentNote cn: history){
					if(noteBody != null && noteBody != cn.TextPreview){
						try{
							ContentNote n = new ContentNote(Title = 'Note on: ' + string.valueof(system.today()), Content = blob.valueOf(noteBody));
							noteSet.add(n);
							c.Case_Notes__c = '';
           					c.Description = '';
           					casesToUpdate.add(c);
							}
						catch(Exception e){
							system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
							}	
						}
					}
					if(noteSet.size() > 0){
						list<ContentNote> noteInsert = new list<ContentNote>();
						noteInsert.addAll(noteSet);
						insert noteInsert;
							for(ContentNote cnn : noteInsert){
								ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityID = c.ID, ContentDocumentId = cnn.Id, ShareType = 'V');
								insert cdl;
								}
						}	
				}
			} 
			cleanCasestoUpdate.addAll(casesToUpdate);
			casesToUpdate.clear();
			casesToUpdate.addAll(cleanCasestoUpdate);
        	update casesToUpdate;			
		}
    
}