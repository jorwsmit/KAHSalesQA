global class Sales_AssignedCountSP implements Database.Batchable<sObject> {

	// select users with either Sales: KAH Associate or Sales: KAH Market Manager profiles.
	final static ID assocID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
	final static ID manaID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Market Manager'].ID;
	
	global String query = 'select id from user where isActive=true and (profileId=:assocID or profileId=:manaID)';

	global Sales_AssignedCountSP() {

	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<User> users = new List<User>();
		for(sObject s : scope){
			users.add((User)s);
		}

		Map<Id, Sales_Performance__c> UsersSalesPerformance = new Map<Id, Sales_Performance__c>();
		for(Sales_Performance__c sp : [select OwnerId, Sales_KAH_Number_of_Assigned_Accounts__c, Sales_KAH_Number_of_Assigned_Contacts__c
		from Sales_Performance__c where ownerId in :users and month__c=this_month]){
			sp.Sales_KAH_Number_of_Assigned_Accounts__c = 0;
			sp.Sales_KAH_Number_of_Assigned_Contacts__c = 0;
			UsersSalesPerformance.put(sp.OwnerId, sp);
		}

		for(AggregateResult ar : [select userId, count(accountId) total from accountteammember
		where userId in :users group by userId limit 200]){
			if(UsersSalesPerformance.containsKey(String.valueOf(ar.get('userId')))){
				UsersSalesPerformance.get(String.valueOf(ar.get('userId'))).Sales_KAH_Number_of_Assigned_Accounts__c = Integer.valueOf(ar.get('total'));

			}
		}

		for(AggregateResult ar : [select user__c, count(contact__c) total from contact_team__c
		where user__c in :users group by user__c limit 200]){
			if(UsersSalesPerformance.containsKey(String.valueOf(ar.get('user__c')))){
				UsersSalesPerformance.get(String.valueOf(ar.get('user__c'))).Sales_KAH_Number_of_Assigned_Contacts__c = Integer.valueOf(ar.get('total'));
			}
		}

		update UsersSalesPerformance.values();

	}

	global void finish(Database.BatchableContext BC) {

	}

}