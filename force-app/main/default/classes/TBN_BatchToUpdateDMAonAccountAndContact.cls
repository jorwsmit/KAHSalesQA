/**
@ClassName    : TBN_BatchToUpdateDMAonAccountAndContact
@CreatedOn    : 23/06/2016
@ModifiedBy   : Rashmi
@Description  : Batch which will update DMA_Code__c and DMA_Name__c on Account's and Contact's ShippingPostalCode/MailingPostalCode field with DMA_Master__c's
                Name and DMA_Name__c field value based on match found with DMA_Postal_Code__c.
**/
public with sharing class TBN_BatchToUpdateDMAonAccountAndContact implements Database.batchable<sObject> {
    
    private String objectName {get;set;}
    
    //constructor
    public TBN_BatchToUpdateDMAonAccountAndContact(String objectName){
        
        this.objectName = objectName;
    }
    
    /**
        @MethodName : start
        @param      : Database.batchableContext batchableContext
        @Description: 
    */
    public Database.QueryLocator start(Database.batchableContext batchableContext) {
        
        //stores the soql query string 
        String strQuery;
        
        //checking the objectName if Account, if so it returns Account records
        if(objectName == 'Account')
            strQuery = ' SELECT DMA_Code__c, DMA_Name__c, ShippingPostalCode From Account Where ShippingPostalCode != null ';
        //checking the objectName if Contact, if so it returns Contact records
        if(objectName == 'Contact')
            strQuery = ' SELECT DMA_Code__c, DMA_Name__c, MailingPostalCode From Contact Where MailingPostalCode != null ';
            
        return Database.getQueryLocator(strQuery);
    }
    
    /**
        @MethodName  : execute
        @param1      : Database.BatchableContext BC
        @param2      : List<sObject> scope
        @Description : This method will process records coming from start method to update DMA_Name__c, DMA_Code__c of Account and Contact respectively.
    */
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        try{
            TBN_UpdateDMAOnAccountAndContactHandler objDMA = new TBN_UpdateDMAOnAccountAndContactHandler();
            objDMA.onAfterInsert(Scope);
        }
        catch(Exception ex){
			system.debug('===='+ex.getMessage());
		}
    } 
    
    /**
        @MethodName : finish
        @param      : Database.BatchableContext BC
        @Description: This method is called at the last of batch execution.
   */
    public void finish(Database.BatchableContext BC) {
          
        if(this.objectName == 'Account')
            Database.executeBatch(new TBN_BatchToUpdateDMAonAccountAndContact('Contact'), 2000);
            
    } 
    
}