@isTest
public class AA_RHC_FileListTest {

    private static testMethod void method1(){
        
        list<ContentVersion> toInsert = new list<ContentVersion>();
        ContentVersion doc = new ContentVersion();
        doc.Title = 'Any title';
        doc.PathOnClient = 'Any path';
        doc.VersionData = Blob.valueOf('Any text');
        doc.TagCsv = 'Contract';
        toInsert.add(doc);
        
        ContentVersion doc2 = new ContentVersion();
        doc2.Title = 'Any title';
        doc2.PathOnClient = 'Any path';
        doc2.VersionData = Blob.valueOf('Any text');
        doc2.TagCsv = 'white';
        toInsert.add(doc2);
        
        ContentVersion doc3 = new ContentVersion();
        doc3.Title = 'Any title';
        doc3.PathOnClient = 'Any path';
        doc3.VersionData = Blob.valueOf('Any text');
        doc3.TagCsv = 'Toolkit';
        toInsert.add(doc3);
        
        ContentVersion doc4 = new ContentVersion();
        doc4.Title = 'Any title';
        doc4.PathOnClient = 'Any path';
        doc4.VersionData = Blob.valueOf('Any text');
        doc4.TagCsv = 'Collateral';
        toInsert.add(doc4);
        
        ContentVersion doc5 = new ContentVersion();
        doc5.Title = 'Any title';
        doc5.PathOnClient = 'Any path';
        doc5.VersionData = Blob.valueOf('Any text');
        doc5.TagCsv = 'Instructional';
        toInsert.add(doc5);
        
        insert toInsert;
        
        AA_RHC_FileList.getContractFileList();
        AA_RHC_FileList.getWhitePageFileList();
        AA_RHC_FileList.getToolkitFileList();
        AA_RHC_FileList.getCollateralFileList();
        AA_RHC_FileList.getHowToFileList();
    	}
    
}