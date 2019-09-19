@isTest
private class AA_NotesAndAttachmentViewerTest {

    static testMethod void myUnitTest() {
        
        List<RecordType> lstRecTypesAcc = [Select Name, Id From RecordType where sObjectType='Account' AND isActive = true];
        
        
        Account objAccount = new Account(Name='TestAccount', RecordTypeId = lstRecTypesAcc[0].Id, NPI__c = '12');
        insert objAccount;
        
            Note nte = new Note(Title = 'Test Note',
                                Body = 'Test Body', 
                                ParentID = objAccount.ID);
            insert nte;
            
            Attachment att = new Attachment(Name = 'Test Attach',
                                            Body = blob.valueOf('test'),
                                            ParentId = objAccount.ID);
                                            insert att;
            
            AA_NotesAndAttachmentViewer.getAttachmentList(objAccount.Id);                   
        }
}