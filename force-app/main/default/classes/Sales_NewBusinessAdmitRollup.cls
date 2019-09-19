global class Sales_NewBusinessAdmitRollup implements Database.Batchable<sObject> {

	global String query = 'select Id from user where isActive=true and profileId in (select Id from profile where name like \'%Sales: KAH%\')';

	global Integer year = System.now().year();

	global Sales_NewBusinessAdmitRollup() {

	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		Map<Id, Map<Integer, Decimal>> userData = new Map<Id, Map<Integer, Decimal>>();
		for(sObject s : scope){
			User u = (User)s;
			userData.put(u.Id, new Map<Integer, Decimal>());
		}
		Date beginDate = Date.newInstance(year,01,01);
		Date endDate = Date.newInstance(year,12,31);

		Map<Id, List<Id>> newAccounts = new Map<Id, List<Id>>();
		Map<Id, List<Id>> newContacts = new Map<Id, List<Id>>();
		for(New_Business__c nb : [select User__c, Account__c, Contact__c from New_Business__c where
		User__c in :userData.keySet() and (Account__c!=null or Contact__c!=null)]){
			if(nb.User__c!=null){
				List<id> userList = new List<Id> {nb.User__c};
				if(nb.Account__c!=null){
					if(newAccounts.containsKey(nb.Account__c)){
						userList.addAll(newAccounts.remove(nb.Account__c));
					}
					newAccounts.put(nb.Account__c, userList);
				} else if(nb.Contact__c!=null){
					if(newContacts.containsKey(nb.Contact__c)){
						userList.addAll(newContacts.remove(nb.Contact__c));
					}
					newContacts.put(nb.Contact__c, userList);
				}
			}
		}

		Map<Integer, Decimal> rollup = new Map<Integer, Decimal>();
		for(Sales_account_metrics__c am : [select KAH_HH_PPS_Admits__c, Month__c, Account__c from Sales_account_metrics__c where
		KAH_HH_PPS_Admits__c!=null and Month__c>=:beginDate and Month__c<=:endDate and Account__c in :newAccounts.keySet()]){
			for(Id userId : newAccounts.get(am.Account__c)){
				rollup = userData.remove(userId);
				Decimal rollupVal = am.KAH_HH_PPS_Admits__c;
				if(rollup.containsKey(am.Month__c.month())){
					rollupVal += rollup.remove(am.Month__c.month());
				}
				rollup.put(am.Month__c.month(), rollupVal);
				userData.put(userId, rollup);
			}
		}

		for (Sales_contact_metrics__c cm : [select KAH_HH_PPS_Admits__c, Month__c, Contact__c from Sales_contact_metrics__c where
		KAH_HH_PPS_Admits__c!=null and Month__c>=:beginDate and Month__c<=:endDate and Contact__c in :newContacts.keySet()]) {
			for(Id userId : newContacts.get(cm.Contact__c)){
				rollup = userData.remove(userId);
				Decimal rollupVal = cm.KAH_HH_PPS_Admits__c;
				if(rollup.containsKey(cm.Month__c.month())){
					rollupVal += rollup.remove(cm.Month__c.month());
				}
				rollup.put(cm.Month__c.month(), rollupVal);
				userData.put(userId, rollup);
			}
		}

		List<Sales_Performance__c> sps = new List<Sales_Performance__c>();
		for(Sales_Performance__c sp : [select month__c, ownerId, Sales_KAH_New_Business_HH_PPS_Admits__c from
		Sales_Performance__c where ownerId in :userData.keySet() and month__c>=:beginDate and month__c<=:endDate]){
			for(Id userId : userData.keySet()){
				rollup = userData.remove(userId);
				if(rollup.containsKey(sp.Month__c.month()) ){
					sp.Sales_KAH_New_Business_HH_PPS_Admits__c = rollup.remove(sp.Month__c.month());
					// if(sp.Sales_KAH_New_Business_HH_PPS_Admits__c!=null || sp.Sales_KAH_New_Business_HH_PPS_Admits__c!=0) sps.add(sp);
					sps.add(sp);
				}
				userData.put(userId, rollup);
			}
		}

		update sps;

	}


	global void finish(Database.BatchableContext BC) {

	}

}