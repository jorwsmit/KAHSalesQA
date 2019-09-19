public with sharing class SalesHD_SalesTrainingController {

	private static Id currentUserId = UserInfo.getUserId();

	@RemoteAction public static String loadPowerpoint(){
		return '{"user": {"id": "'+currentUserId+'", "photoUrl" : "'+getUserPhotoUrl()+'"}, "powerpoint" : '+getPowerpoint()+'}';
	}

	private static String getUserPhotoUrl(){
		return [SELECT SmallPhotoUrl FROM User WHERE User.ID = :currentUserId LIMIT 1].SmallPhotoUrl;
	}

	private static String getPowerpoint(){
        try{
        	Id workspaceId = [select Id from ContentWorkspace where Name = 'Sales Training Documents' LIMIT 1].Id;
			Map<Id, ContentVersion> data = new Map<Id, ContentVersion>();
			for(ContentVersion cv : [select Title, Id, Description from ContentVersion where IsLatest=true and ContentDocument.ParentId=:workspaceId]){
				data.put(cv.Id, cv);
				}
			return JSON.serializePretty(data);
        	}
        	catch(exception e){
            	system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            	return null; 
            	}
		}
}