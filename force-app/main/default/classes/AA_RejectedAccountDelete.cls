public class AA_RejectedAccountDelete {
	
	public static void deleteAccounts(){
		list<Account> accs = new list<Account>();
		accs = [SELECT ID, Approval_Denied__c FROM Account WHERE Approval_Denied__c = true];
		
		delete accs;
		}
    
}