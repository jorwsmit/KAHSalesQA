public with sharing class AA_RHC_FileList {

	@AuraEnabled
    public static list<ContentVersion> getContractFileList(){
        list<ContentVersion> contractFileList = new list<ContentVersion>();
        
        for(ContentVersion cv: [SELECT ID, ContentDocumentID, TagCsv, IsLatest, FileType, ContentSize, Title FROM ContentVersion ORDER BY Title]){
            if(cv.TagCsv != null){
                if(cv.TagCsv.contains('contract') || cv.TagCsv.contains('Contract')){
                	contractFileList.add(cv);
                	}
                }
        	}
        return contractFileList;
    	}
    
    @AuraEnabled
    public static list<ContentVersion> getWhitePageFileList(){
        list<ContentVersion> whitePageFileList = new list<ContentVersion>();
        
        for(ContentVersion cv: [SELECT ID, ContentDocumentID, TagCsv, IsLatest, FileType, ContentSize, Title FROM ContentVersion ORDER BY Title]){
            if(cv.TagCsv != null){
                if(cv.TagCsv.contains('white') || cv.TagCsv.contains('White')){
                	whitePageFileList.add(cv);
                	}
                }
        	}
        return whitePageFileList;
    	}
    	
    @AuraEnabled
    public static list<ContentVersion> getToolkitFileList(){
        list<ContentVersion> toolkitFileList = new list<ContentVersion>();
        
        for(ContentVersion cv: [SELECT ID, ContentDocumentID, TagCsv, IsLatest, FileType, ContentSize, Title FROM ContentVersion ORDER BY Title]){
            if(cv.TagCsv != null){
                if(cv.TagCsv.contains('Toolkit') || cv.TagCsv.contains('toolkit')){
                	toolkitFileList.add(cv);
                	}
                }
        	}
        system.debug('toolkitSize: ' + toolkitFileList.size());	
        return toolkitFileList;
    	}
    	
    @AuraEnabled
    public static list<ContentVersion> getCollateralFileList(){
        list<ContentVersion> collateralFileList = new list<ContentVersion>();
        
        for(ContentVersion cv: [SELECT ID, ContentDocumentID, TagCsv, IsLatest, FileType, ContentSize, Title FROM ContentVersion ORDER BY Title]){
            if(cv.TagCsv != null){
                if(cv.TagCsv.contains('Collateral') || cv.TagCsv.contains('collateral')){
                	collateralFileList.add(cv);
                	}
                }
        	}
        system.debug('collateralFileListSize: ' + collateralFileList.size());
        return collateralFileList;
    	}
    	
    @AuraEnabled
    public static list<ContentVersion> getHowToFileList(){
        list<ContentVersion> howToFileList = new list<ContentVersion>();
        
        for(ContentVersion cv: [SELECT ID, ContentDocumentID, TagCsv, IsLatest, FileType, ContentSize, Title FROM ContentVersion ORDER BY Title]){
            if(cv.TagCsv != null){
                if(cv.TagCsv.contains('Instructional') || cv.TagCsv.contains('instructional')){
                	howToFileList.add(cv);
                	}
                }
        	}
        system.debug('howToFileListSize: ' + howToFileList.size());
        return howToFileList;
    	}			
    
}