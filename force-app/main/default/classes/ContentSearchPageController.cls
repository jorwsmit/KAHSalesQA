public with sharing class ContentSearchPageController {
    public String messge{get;set;}
    set<id> documentIDList = new set<id>();
    public string searchString{get;set;}
    public string searchCenter{get;set;}
    public string searchDocumnet{get;set;}
    public string searchProgram{get;set;}
    public list<innerClass> documentwrapperList{get;set;}
    public list<Content_Link__c> contentLinkListtoshow{get;set;}
    public list<Account> centerList {get;set;}
    public list<linkinnerClass> lineInnerClassList{get;set;}
    public boolean step3 {get;set;}
    public string selectedCenter{get;set;}
    private list<id> documentID = new list<id>();
    public Integer serialnumber{get;set;}
    public SelectOption[] selectedDocuments { get; set; }
    public SelectOption[] allDocuments { get; set; }
    public SelectOption[] selectedCenters { get; set; }    
    public SelectOption[] allCenters { get; set; }
    public SelectOption[] selectedPrograms { get; set; }    
    public SelectOption[] allPrograms { get; set; }
    public SelectOption[] availablecenters{get;set;}
    private RecordType centerRecordType = new RecordType();
    private list<Content_Link__c> contentLinkListtoinsert = new list<Content_Link__c>();
    public boolean searchbyCenter {get;set;}
    public boolean doassociate{get;set;}
    //Constructor
    public ContentSearchPageController(){
        doassociate = false;
        searchbyCenter = false;
        selectedCenters = new List<SelectOption>();
        selectedPrograms = new List<SelectOption>();
        selectedDocuments = new List<SelectOption>();
        availablecenters = new List<SelectOption>();
        messge = 'Documents have been linked';
        selectedCenter = '';
        searchCenter = '';
        searchProgram = '';
        searchDocumnet= '';
        documentwrapperList = new list<innerClass>();
        centerRecordType = [Select id, Name From RecordType Where Name =:'Center' Limit 1];
        List<Account> centers = [SELECT id,Name FROM Account WHERE RecordTypeID = :centerRecordType.id LIMIT 1000];
        List<Program__c> programs = [SELECT id,Name FROM Program__c LIMIT 1000];
        allCenters = new List<SelectOption>();
        allPrograms = new List<SelectOption>();
        for(Account c : centers){            
            allCenters.add(new SelectOption(c.Id, c.Name));        
        	}
        for(Program__c c : programs){            
            allPrograms.add(new SelectOption(c.Id, c.Name));        
        	}
        
        step3 = false;
        contentLinkListtoshow = new list<Content_Link__c>();
        lineInnerClassList = new list<linkinnerClass>();
    	}
    
    public pageReference searchByDocumentTitle(){
        return dosearch('Title');
    	}
    
    public pageReference searchByDocumentCenter(){
        searchbyCenter = true;
        centerList = new list<Account>();
        
        availablecenters = new List<SelectOption>();
        centerList = [SELECT id, Name FROM Account WHERE name like :('%'+Searchstring+'%') LIMIT 1000];
        for(Account acc : centerList){
            availablecenters.add(new SelectOption(acc.Id, acc.Name));
        	}
        return null;
        //return dosearch('Center__r.Name');
    	}
    
    public pageReference onReset(){
        documentID = new list<id>();            
        searchString = '';
        availablecenters = new List<SelectOption>();
        List<Account> centers = [SELECT id,Name FROM Account WHERE RecordTypeID = :centerRecordType.id LIMIT 1000];
        List<Program__c> programs = [SELECT id,Name FROM Program__c LIMIT 1000];
        contentLinkListtoshow = new list<Content_Link__c>();
        documentwrapperList = new list<innerClass>();
        selectedCenters = new List<SelectOption>();
        selectedPrograms = new List<SelectOption>();
        allCenters = new List<SelectOption>();
        selectedDocuments = new List<SelectOption>();
        allDocuments = new List<SelectOption>();
        allPrograms = new List<SelectOption>();
        doassociate = false;
        lineInnerClassList = new List<linkinnerClass>();
        searchbyCenter = false;
        step3 = false;
        for(Account c : centers){            
            allCenters.add(new SelectOption(c.Id, c.Name));        
        	}
        for(Program__c c : programs){            
            allPrograms.add(new SelectOption(c.Id, c.Name));        
        	}
        searchCenter = '';
        searchProgram = '';
        searchDocumnet= '';
        selectedCenter = '';
        return null;
    	}
    
    public pageReference dosearch(String searchType){
        
        documentwrapperList = new list<innerClass>();
        list<ContentVersion> documentList = new list<ContentVersion>();
        
        String soql = 'SELECT id,ContentDocumentID ,Title,Center__c,Audience_Tag__c,LOB__c,FileExtension, isLatest, ContentDocument.ParentId FROM ContentVersion WHERE ' +searchType+ ' like '+'\''+'%'+String.escapeSingleQuotes(searchString)+'%'+'\' and isLatest = true and ContentDocument.ParentId =\''+ System.Label.NCD_Mobile_Id + '\' order by lastmodifieddate desc LIMIT 1000';
        system.debug('this is query===>'+soql);
        documentList = Database.query(soql);
        if(documentList.size() == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Document to display with name ' + searchString));
            doassociate = true;
        	}
        else{
            for(ContentVersion cv : documentList){
                documentwrapperList.add(new innerClass(cv)); 
            	}
        	}
        return null;
    	}
    
    //Wrapper Class
    public class innerClass{
        public contentVersion con {get;set;}
        public boolean selected {get;set;}
        //Constructor
        public innerClass(contentVersion c){
            con = c;
            selected = false;
        	}
    	}
    
    //Wrapper Class
    public class linkinnerClass{
        public Content_Link__c cl {get;set;}
        public boolean isexisted {get;set;}
        public boolean selected {get;set;}
        
        public Integer serialNumber{get;set;}
        //Constructor
        public linkinnerClass(Content_Link__c c){
            cl = c;
            selected = false;
        	}
    	}
    /*
    public pagereference test(){
        system.debug('this is selected center===>'+selectedCenter);
        return null;
    }*/
    
    
    public pagereference checkAssociation(){
        try{
        if(searchbyCenter == false){
        lineInnerClassList = new list<linkinnerClass>();
        
        for(innerClass ic :documentwrapperList){
            if(ic.selected == true){
                documentID.add(ic.con.ContentDocumentID);
            	}
        	}
            contentLinkListtoshow = [SELECT id,Account__c,Program__c,Document_Name__c,Document_Id__c FROM Content_Link__c WHERE Document_Id__c in:documentID LIMIT 1000 ];
        	}
        else{
            step3 = true;
            //documentwrapperList = new list<innerClass>();
            //contentLinkListtoshow = new list<Content_Link__c>();
            //system.debug('this is selected center===>'+selectedCenter);
            lineInnerClassList = new list<linkinnerClass>();
            contentLinkListtoshow = [SELECT id,Account__c,Program__c,Document_Name__c,Document_Id__c FROM Content_Link__c WHERE Account__c =:selectedCenter LIMIT 1000 ];
            reviewavailableDocuments();
        	}
        
        system.debug(documentwrapperList.size()+'===on load='+contentLinkListtoshow.size());
        system.debug(documentID.size()+'====lineInnerClassList===='+lineInnerClassList.size());
        
        if(contentLinkListtoshow.size() == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No content links founds for document '+Searchstring));
            if(searchbyCenter == false){
                doassociate = true;
            	}
            else{
                doassociate = false;
                searchbyCenter=true;
            	}
            //searchbyCenter=false;
            return null;
        	}
        
        Integer i = 1;
        if(lineInnerClassList.size()>0){
            i = lineInnerClassList.size()+1;
        	}
        for(Content_Link__c ic :contentLinkListtoshow ){
            linkinnerClass newLink = new linkinnerClass(ic);
            newLink.serialNumber = i;
            newLink.isexisted = true;
            i++;
            lineInnerClassList.add(newLink);        
        	}
        return null;
        }
        catch(Exception e){
            system.debug('inside catch'+e.getMessage()+e.getLineNumber());
            return null;
        	}
    	}
    
    public pagereference onConfirm(){
        if(searchbyCenter == false){
        for(innerClass ic :documentwrapperList){
            if(ic.selected == true){
                for(SelectOption co : selectedCenters){
                    boolean isExistWithoutProgram = false;
                    for(SelectOption po : selectedPrograms){
                        Boolean isExist = false;
                        for(Content_Link__c cl : contentLinkListtoshow){
                        system.debug('this is check====>'+(co.getValue() == cl.Account__c 
                               && po.getValue() == cl.Program__c 
                               && cl.Document_Id__c == ic.con.ContentDocumentID));
                            if(co.getValue() == cl.Account__c 
                               && po.getValue() == cl.Program__c 
                               && cl.Document_Id__c == ic.con.ContentDocumentID){
                                   isExist = true;    
                               	}
                        	}
                        if(isExist == false){
                            Content_Link__c newLink = new Content_Link__c(Account__c = co.getValue() 
                                                            ,Program__c = po.getValue() 
                                                            ,Document_Name__c = ic.con.Title
                                                            ,Document_Id__c = ic.con.ContentDocumentID);
                            contentLinkListtoinsert.add(newLink);
                        	}
                    	}
                    if(selectedPrograms.size() == 0){
                        for(Content_Link__c cl : contentLinkListtoshow){
                            if(co.getValue() == cl.Account__c 
                               && cl.Document_Id__c == ic.con.ContentDocumentID){
                                   isExistWithoutProgram = true;    
                               }
                        	}
                        if(isExistWithoutProgram == false){
                            Content_Link__c newLink = new Content_Link__c(Account__c = co.getValue() 
                                                            ,Document_Name__c = ic.con.Title
                                                            ,Document_Id__c = ic.con.ContentDocumentID);
                            contentLinkListtoinsert.add(newLink);
                        	}
                    	}
                	}
            	}
        	}
        	}
        	/*********************************************/
        else{
            	/*for(linkinnerClass lc:lineInnerClassList){
                	if(lc.selected == true){
                    	for(SelectOption co : selectedCenters){
                        	Boolean isExist = false;
                        	for(SelectOption po : selectedPrograms){
                            	for(Content_Link__c cl : contentLinkListtoshow){
                                	if(co.getValue() == cl.Account__c 
                               			&& po.getValue() == cl.Program__c 
                               			&& cl.Document_Id__c == lc.cl.Document_Id__c){
                                   		isExist = true;    
                               			}
                                	}
                            if(isExist == false){
                            	Content_Link__c newLink = new Content_Link__c(Account__c = co.getValue() 
                                	                            ,Program__c = po.getValue() 
                                    	                        ,Document_Name__c = lc.cl.Document_Name__c
                                        	                    ,Document_Id__c = lc.cl.Document_Id__c);
                            	contentLinkListtoinsert.add(newLink);
                        		}    
                        		}
                    		}
                		}
            		}*/
            //ID centerID = contentLinkListtoshow[0].Account__c;
            for(SelectOption d : selectedDocuments){
                    Content_Link__c newLink = new Content_Link__c(Account__c = selectedCenter  
                                                            ,Document_Name__c = d.getlabel()
                                                            ,Document_Id__c = d.getvalue());
                contentLinkListtoinsert.add(newLink);
            	}
            }
        if(contentLinkListtoinsert.size() == 0){
            messge = 'No content link to insert';
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Document to display with name '+searchString));
        	}
        else{
            insert contentLinkListtoinsert;
        	}
        Pagereference pageRef = new PageReference('/apex/ContentSearchPage');
        pageRef.setRedirect(true);
        return pageRef;
    	}
    //Method to show data
    /*public pagereference generateLinkTable(){
        contentLinkListtoshow = new list<Content_Link__c>();
        List<Content_Link__c> existingContentLink = new list<Content_Link__c>();
        set<id> centeridset = new set<id>();
        set<id> Programidset = new set<id>();
        for ( SelectOption co : selectedCenters ) {
            centeridset.add(co.getValue());
        }
        for ( SelectOption po : selectedPrograms ) {
            Programidset.add(po.getValue());
        }
        for(innerClass ic :documentwrapperList){
            if(ic.selected == true){
                documentID.add(ic.con.ContentDocumentID);
            }
            
        }
        
       // contentLinkListtoshow = [SELECT id,Account__c,Program__c,Document_Name__c,Document_Id__c FROM Content_Link__c WHERE Account__c in :centeridset AND Document_Id__c IN :documentID AND Program__c in :Programidset];
        existingContentLink =  [SELECT id,Account__c,Program__c,Document_Name__c,Document_Id__c FROM Content_Link__c WHERE Account__c in :centeridset AND Document_Id__c IN :documentID AND Program__c in :Programidset];
        Integer i =1;
        if(lineInnerClassList.size()>0){
            i= lineInnerClassList.size()+1;
        }
        for(innerClass ic :documentwrapperList){
            if(ic.selected == true){
                for ( SelectOption co : selectedCenters ) {
                    for ( SelectOption po : selectedPrograms ){
                        Boolean isExist = false;
                        for(Content_Link__c cl : existingContentLink){
                            if(co.getValue() == cl.Account__c 
                               && po.getValue() == cl.Program__c 
                               && cl.Document_Id__c == ic.con.ContentDocumentID){
                                   linkinnerClass newLink = new linkinnerClass(cl);
                                   newLink.serialNumber = i;
                                   newLink.isexisted = true;
                                   i++;
                                   isExist = true;
                                   lineInnerClassList.add(newLink);
                               }
                            
                        }
                        system.debug('this is outside===>'+isExist);
                            if(isExist== false){
                                 linkinnerClass newLink = new linkinnerClass(new Content_Link__c(Account__c = co.getValue() 
                                                            ,Program__c = po.getValue() 
                                                            ,Document_Name__c = ic.con.Title
                                                            ,Document_Id__c = ic.con.ContentDocumentID));
                                newLink.serialNumber = i;
                                newLink.isexisted = false;
                                i++;
                                lineInnerClassList.add(newLink);
                            }
                    }
                }
                
                //documentID.add(ic.con.ContentDocumentID);
            }
            ic.selected = false;
        }
        
       */ 
       /* for(Content_Link__c cl : contentLinkListtoshow ){
            linkinnerClass newLink = new linkinnerClass(cl);
            newLink.serialNumber = i;
            i++;
            lineInnerClassList.add(newLink);
        }*/
        /*documentID = new list<id>();
        return null;
    }
    */
    public pagereference inertContentLinkData(){
        for(linkinnerClass C : lineInnerClassList){
            contentLinkListtoshow.add(C.cl);
        	}
        
        if(contentLinkListtoshow.size() > 0){
            upsert contentLinkListtoshow;
        	}
        
        searchString = '';
        contentLinkListtoshow = new list<Content_Link__c>();
        documentwrapperList = new list<innerClass>();
        return null;
    	}
    
    public void delRow(){
        serialnumber = Integer.valueOf(apexpages.currentpage().getparameters().get('serialnumber'));
        Content_Link__c contentlinktoDelete = (lineInnerClassList.get(serialnumber-1)).cl;
        Delete contentlinktoDelete ;
        lineInnerClassList.remove(serialnumber-1);
        Integer i =1;
        for(linkinnerClass cl : lineInnerClassList){
            cl.serialNumber = i;
            i++;
        	}
        }
    
    public void reviewavailableDocuments(){
        allDocuments = new List<SelectOption>();
        for(Content_Link__c cl:contentLinkListtoshow){
            documentIDList.add(cl.Document_Id__c);
        	}
        list<ContentVersion> notAssociatedDocument = [SELECT id,ContentDocumentID, ContentDocument.ParentId ,Title,Center__c, isLatest FROM ContentVersion WHERE ContentDocumentID NOT IN :documentIDList and isLatest = true and ContentDocument.ParentId =: System.Label.NCD_Mobile_Id ORDER by Title LIMIT 1000 ];
        for(ContentVersion cv:notAssociatedDocument){
            allDocuments.add(new SelectOption(cv.ContentDocumentID , cv.Title));
        	}
    	}
    
    public void updateAvailableList(){
        if(searchCenter <> null){
            //searchCenter = searchCenter+'%';
            set<id> selectedCenterID  = new set<id>();
            for(SelectOption co : selectedCenters){
                selectedCenterID.add(co.getvalue()); 
            	}
            List<Account> centers = [SELECT id,Name FROM Account WHERE RecordTypeID = :centerRecordType.id AND Name like :('%'+searchCenter+'%') AND id NOT IN :selectedCenterID LIMIT 1000];
            allCenters = new List<SelectOption>();
            for(Account c : centers) {            
            allCenters.add(new SelectOption(c.Id, c.Name));        
            }
        	}
        if(searchProgram <> null){
        	set<id> selectedProgramID  = new set<id>();
        	for(SelectOption co : selectedPrograms){
                selectedProgramID.add(co.getvalue()); 
            	}
        List<Program__c> programs = [SELECT id,Name FROM Program__c WHERE Name like :('%'+searchProgram+'%') AND id NOT IN :selectedProgramID LIMIT 1000];
        allPrograms = new List<SelectOption>();
        for(Program__c c : programs){            
            allPrograms.add(new SelectOption(c.Id, c.Name));        
        	}
        	}
        if(searchDocumnet <> null){
            set<id> selectedDocumentID  = new set<id>();
            for(SelectOption co : selectedDocuments){
                selectedDocumentID.add(co.getvalue()); 
            	}
            list<ContentVersion> contentVersionList= [SELECT id,ContentDocumentID ,Title,Center__c, ContentDocument.ParentId FROM ContentVersion WHERE ContentDocumentID NOT IN :documentIDList AND Title like :('%'+searchDocumnet+'%') AND ContentDocumentID NOT IN :selectedDocumentID AND isLatest =true AND ContentDocument.ParentId =: System.Label.NCD_Mobile_Id ORDER by lastmodifieddate desc LIMIT 1000];
            allDocuments = new List<SelectOption>();
            for(ContentVersion c : contentVersionList){            
            	allDocuments.add(new SelectOption(c.ContentDocumentID , c.Title));        
            	}  
        	}
    	}
    	
}