//TesStacICUAccountsQueryExt test for StacICUAccountsQueryExt
@isTest 
public class TestStacICUAccountsQueryExt {
    
    static testMethod void callingAllRemoteQueryFunctions(){
        Account acct = new Account(Name='Test Account');
        insert acct;
        ICU_CCU_Location__c icu = new ICU_CCU_Location__c(Unit__c='Test Unit', Discharge_Volume__c=1, Account__c=acct.Id, ICU_Code__c='0200 - General ICU');      	
        StacICUAccountsQueryExt.query('Texas');
        insert icu;	
        StacICUAccountsQueryExt.queryAccount(acct.Id);
        StacICUAccountsQueryExt.queryAccounts('Texas');
        StacICUAccountsQueryExt.queryICU(acct.Id);
        StacICUAccountsQueryExt.updateICU(String.valueOf(icu.Id), String.valueOf(icu.unit__c));
    	}
}