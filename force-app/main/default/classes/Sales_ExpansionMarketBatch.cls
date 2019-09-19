global class Sales_ExpansionMarketBatch implements Database.Batchable<sObject> {

	global String query;
	global Integer year = System.now().year();
	global Sales_ExpansionMarketBatch() {
		query = 'select Id, OwnerId, Month__c, Sales_KAH_Total_Growth_Admits__c '+
		'from Sales_Performance__c where Month__c>='+year+'-01-01 and Month__c<='+year+'-12-31 and '+
		'OwnerId in (select Id from user where KAH_Growth__c=true)';
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		Map<Id, Map<Integer, Sales_Performance__c>> users = new Map<Id, Map<Integer, Sales_Performance__c>>();
		for(sObject s : scope){
			Sales_Performance__c sp = (Sales_Performance__c)s;
			sp.Sales_KAH_Total_Growth_Admits__c = null;
			if(!users.containsKey(sp.OwnerId)){
				users.put(sp.OwnerId, new Map<Integer, Sales_Performance__c>{sp.Month__c.month() => sp});
			} else {
				Map<Integer, Sales_Performance__c> temp = users.remove(sp.OwnerId);
				if(!temp.containsKey(sp.Month__c.month())) temp.put(sp.Month__c.month(), sp);
				users.put(sp.OwnerId, temp);
			}
		}

		Map<Id, String> lineOfBusiness = new Map<Id, String>();
		for(User u : [select Id, Line_of_Business__c from User where Id in: users.keySet()]){
			if(u.Line_of_Business__c!=null) lineOfBusiness.put(u.Id, String.valueOf(u.Line_of_Business__c));
		}

		Map<Id, List<Id>> userAssignments = new Map<Id, List<Id>>();
		for(sObject so : [select UserId, AccountId from AccountTeamMember where UserId in :users.keySet()]){
			if(!userAssignments.containsKey((Id)so.get('UserId'))) userAssignments.put((Id)so.get('UserId'), new List<Id>{(Id)so.get('AccountId')});
			else userAssignments.get((Id)so.get('UserId')).add((Id)so.get('AccountId'));
		}
		for(sObject so : [select User__c, Contact__c from Contact_Team__c where User__c in :users.keySet()]){
			if(!userAssignments.containsKey((Id)so.get('User__c'))) userAssignments.put((Id)so.get('User__c'), new List<Id>{(Id)so.get('Contact__c')});
			else userAssignments.get((Id)so.get('User__c')).add((Id)so.get('Contact__c'));
		}

		Map<Id, Map<Integer, List<Decimal>>> assignmentData = new Map<Id, Map<Integer, List<Decimal>>>();
		for(AggregateResult ar : [select Month__c, Contact__c, SUM(KAH_HH_Admits__c), SUM(KAH_HP_Admits__c) from Sales_Contact_Metrics__c where
		Contact__c in (select Contact__c from Contact_Team__c where User__c in: users.keySet())
		and Month__c>=:Date.newInstance(year,01,01) and Month__c<=:Date.newInstance(year,12,31)
		group by Contact__c, Month__c]){
			if(!assignmentData.containsKey((Id)ar.get('Contact__c')))
			assignmentData.put((Id)ar.get('Contact__c'), new Map<Integer, List<Decimal>>{((Date)ar.get('Month__c')).month() => new List<Decimal>{(Decimal)ar.get('expr0'), (Decimal)ar.get('expr1')}});
			else
			assignmentData.get((Id)ar.get('Contact__c')).put(((Date)ar.get('Month__c')).month(), new List<Decimal>{(Decimal)ar.get('expr0'), (Decimal)ar.get('expr1')});

		}

		for(AggregateResult ar : [select Month__c, Account__c, SUM(KAH_HH_Admits__c), SUM(KAH_HP_Admits__c) from Sales_Account_Metrics__c where
		Account__c in (select AccountId from AccountTeamMember where UserId in: users.keySet())
		and Month__c>=:Date.newInstance(year,01,01) and Month__c<=:Date.newInstance(year,12,31)
		group by Account__c, Month__c]){
			if(!assignmentData.containsKey((Id)ar.get('Account__c')))
			assignmentData.put((Id)ar.get('Account__c'), new Map<Integer, List<Decimal>>{((Date)ar.get('Month__c')).month() => new List<Decimal>{(Decimal)ar.get('expr0'), (Decimal)ar.get('expr1')}});
			else
			assignmentData.get((Id)ar.get('Account__c')).put(((Date)ar.get('Month__c')).month(), new List<Decimal>{(Decimal)ar.get('expr0'), (Decimal)ar.get('expr1')});

		}

		List<Sales_Performance__c> updateSP = new List<Sales_Performance__c>();

		for(Id userId : users.keySet()){
			Map<Integer, Sales_Performance__c> userData = users.remove(userId);
			for(Integer month : userData.keySet()){
				if(userAssignments.containsKey(userId)){
					for(Id assignmentId : userAssignments.get(userId)){
						if(assignmentData.containsKey(assignmentId) && assignmentData.get(assignmentId).containsKey(month)){
							if(lineOfBusiness.get(userId)=='HH'){
								if(userData.get(month).Sales_KAH_Total_Growth_Admits__c==null) userData.get(month).Sales_KAH_Total_Growth_Admits__c = assignmentData.get(assignmentId).get(month)[0];
								else userData.get(month).Sales_KAH_Total_Growth_Admits__c += assignmentData.get(assignmentId).get(month)[0];
							} else if(lineOfBusiness.get(userId)=='HP'){
								if(userData.get(month).Sales_KAH_Total_Growth_Admits__c==null) userData.get(month).Sales_KAH_Total_Growth_Admits__c = assignmentData.get(assignmentId).get(month)[1];
								else userData.get(month).Sales_KAH_Total_Growth_Admits__c += assignmentData.get(assignmentId).get(month)[1];
							}
						}
					}
				}
				updateSP.add(userData.remove(month));
			}
		}
		if(!updateSP.isEmpty()) update updateSP;
	}

	global void finish(Database.BatchableContext BC) {

	}

}