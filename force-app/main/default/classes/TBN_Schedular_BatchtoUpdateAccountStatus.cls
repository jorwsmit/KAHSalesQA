/**
@ClassName    : TBN_Schedular_BatchtoUpdateAccountStatus
@CreatedOn    : 27/05/2016
@ModifiedBy   : Rashmi
@Description  : This Schedular class will call TBN_BatchToUpdateAccountStatus batch in chunks of 2000 records.
**/
public with sharing class TBN_Schedular_BatchtoUpdateAccountStatus implements Schedulable 
{
    public void execute(SchedulableContext SC) 
    { 
        TBN_BatchToUpdateAccountStatus batchAccounts = new TBN_BatchToUpdateAccountStatus();
        database.executeBatch(batchAccounts, 2000);              
    }
}