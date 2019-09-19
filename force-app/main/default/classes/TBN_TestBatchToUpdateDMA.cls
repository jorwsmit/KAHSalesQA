@isTest
private class TBN_TestBatchToUpdateDMA {

    private static testMethod void TBN_BatchToUpdateDMAonAccountAndContact() {
       
       /** creating the test data */    
       Account objAccount = new Account(Name = 'Test Account', ShippingPostalCode = '12345');
       insert objAccount;
       
       Contact objContact = new Contact(LastName ='Test Contact', AccountId= objAccount.id, MailingPostalCode = '12345');
       insert objContact;
       
       DMA_Master__c ojDMA01 = new DMA_Master__c(Name = '500', DMA_Name__c = 'TestName DMA', DMA_Postal_Code__c = '12345', DMA_City_Name__c = 'testCity', DMA_Rank__c = '001', DMA_State__c = 'AB');
       insert ojDMA01;
       
       Test.startTest();
       
       /** processing the test data */ 
       TBN_BatchToUpdateDMAonAccountAndContact objBatch = new TBN_BatchToUpdateDMAonAccountAndContact('Account');
       Database.executeBatch(objBatch,5);
       TBN_BatchToUpdateDMAonAccountAndContact objBatch1 = new TBN_BatchToUpdateDMAonAccountAndContact('Contact');
       Database.executeBatch(objBatch1,5); 
       Test.stopTest();
       
       /** verfifying the test result */
       system.assertEquals([select DMA_Name__c from Contact where Id = :objContact.Id].DMA_Name__c, 'TestName DMA');
       system.assertEquals([select DMA_Code__c from Contact where Id = :objContact.Id].DMA_Code__c, '500');
       system.assertEquals([select DMA_Name__c from Account where Id = :objAccount.Id].DMA_Name__c, 'TestName DMA');
       system.assertEquals([select DMA_Code__c from Account where Id = :objAccount.Id].DMA_Code__c, '500');

    }

}