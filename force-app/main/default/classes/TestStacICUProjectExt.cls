@isTest (seeAllData=false)
public class TestStacICUProjectExt {
	
	static testMethod void calingAllRemoteQueryFunctions() {
    	Account acct = new Account(Name='Test Account');
        insert acct;
    	ApexPages.StandardController sc = new ApexPages.standardController(acct);
    	StacICUProjectExt ext = new StacICUProjectExt(sc);
    	StacICUProjectExt.query(acct.id);
    	}
}