/**
@ClassName    : TBN_BatchToUpdateAccountStatus
@CreatedOn    : 26/05/2016
@ModifiedBy   : Rashmi
@Description  : This batch is used to update the Status__c field to 'inactive' of those accounts whose record type 
                is Chain (Partner First) and Client (Partner First) and Last Date of Service is less than today.
                Script to run batch from Dev Console: 
                    Database.executeBatch(new TBN_BatchToUpdateAccountStatus(), 2000);
                Scheduler: 
                    TBN_Schedular_BatchtoUpdateAccountStatus
**/
public with sharing class TBN_BatchToUpdateAccountStatus implements Database.batchable<sObject> {
    
    //constructor
    public TBN_BatchToUpdateAccountStatus(){
        
    }
    
    /**
        @MethodName : start
        @param      : Database.batchableContext batchableContext
        @Description: This method is called first time during batch execution, in this method we are retrieving records and passes it to execute method for further processing.
    */
    public Database.QueryLocator start(Database.batchableContext batchableContext) {
        
        //list to contain Account record type. 
        list<RecordType> lstAccountRecordType = [ Select Id 
                                                  From RecordType
                                                  Where sobjecttype = 'Account' AND 
                                                        (DeveloperName='PF_Chain' OR DeveloperName='PF_Client')];
        String strQuery = 'SELECT Id, PF_Last_Date_of_Service__c, Status__c '+
                            'FROM Account '+
                            'where PF_Last_Date_of_Service__c < TODAY AND recordtypeid IN: lstAccountRecordType';
        return Database.getQueryLocator(strQuery);
    }
    
    /**
        @MethodName : execute
        @param1      : Database.BatchableContext BC
        @param2      : List<Account> scope
        @Description: This method is called after start and perform the activity on the records coming from start.
   */
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        
        //list to store Account whose status has to be updated
        list<Account> lstAccounttoUpdate = new list<Account>();
        for(Account objAccount : scope){
            
            objAccount.Status__c = 'Inactive';  
            lstAccounttoUpdate.add(objAccount);
        }
        if(!lstAccounttoUpdate.isEmpty())
            update lstAccounttoUpdate;
    }  
    
    /**
        @MethodName : finish
        @param      : Database.BatchableContext BC
        @Description: This method is called at the last of batch execution.
   */
    public void finish(Database.BatchableContext BC) {
         
    }
}