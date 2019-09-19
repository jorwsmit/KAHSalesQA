@isTest
public class AA_ContentVersionTriggerTest {

    private static testMethod void test1(){
        
        ContentVersion doc = new ContentVersion();
        doc.Title = 'Any title';
        doc.PathOnClient = 'Any path';
        doc.VersionData = Blob.valueOf('Any text');
        doc.Lightning_Tag__c = 'Contract';
        insert doc;
    
        }
    
}