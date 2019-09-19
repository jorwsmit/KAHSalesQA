public with sharing class AA_NotesAndAttachmentViewer {
    
    @AuraEnabled
    public static list<attachWrapper> getAttachmentList(ID id){
        list<attachWrapper> attWrap = new list<attachWrapper>();
        
        list<Attachment> attachList = new list<Attachment>();
        list<Note> notes = new list<Note>();
        
        for(Attachment att: [SELECT ID, Name, ContentType, CreatedBy.Name, CreatedDate FROM Attachment WHERE ParentID =: id]){
            attWrap.add(new attachWrapper(att));
            }
        
        for(Note nte: [SELECT ID, Title, Body, OwnerID, ParentID FROM Note WHERE ParentID =: id]){
            attWrap.add(new attachWrapper(nte));
            }
        
        return attWrap;
        }
    
    public class attachWrapper{
        @AuraEnabled
        public ID itemID    {get;set;}
        @AuraEnabled
        public string itemName  {get;set;}
        @AuraEnabled
        public string itemBody  {get;set;}
        @AuraEnabled
        public string itemType  {get;set;} 
        
        public attachWrapper(Attachment att){
            this.itemID = att.Id;
            this.itemName = att.Name;
            this.itemType = 'Attachment';
            }
            
        public attachWrapper(Note nte){
            this.itemID = nte.ID;
            this.itemName = nte.Title;
            this.itemType = 'Note';
            }   
        
        }
    
}