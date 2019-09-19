public with sharing class AA_KeyItemRefresh{
	
	public static void refreshItems(){
		
		list<Account> accs = new list<Account>();
		list<Contact> ctcs = new list<Contact>();
		list<Sales_Account_Metrics__c> sams = new list<Sales_Account_Metrics__c>();
		list<Sales_Contact_Metrics__c> scms = new list<Sales_Contact_Metrics__c>();
		list<Home_Facility__c> hfs = new list<Home_Facility__c>();
		list<Target_Agreement__c> tgts = new list<Target_Agreement__c>();
		list<Contact_Team__c> cteams = new list<Contact_Team__c>();
		list<User> usrs = new list<User>();
		list<Sales_Performance__c> sPerfs = new list<Sales_Performance__c>();
		list<Task> tasks = new list<Task>();
		list<Opportunity> opps = new list<Opportunity>();
		list<Favorites__c> favs = new list<Favorites__c>();
		
		accs = [SELECT ID, Historic_ID__c FROM Account WHERE Historic_ID__c = null LIMIT 1000];
		
		ctcs = [SELECT ID, Historic_ID__c FROM Contact WHERE Historic_ID__c = null LIMIT 1000];
		
		sams = [SELECT ID, Historic_ID__c FROM Sales_Account_Metrics__c WHERE Historic_ID__c = null LIMIT 1000];
		
		hfs = [SELECT ID, Historic_ID__c FROM Home_Facility__c WHERE Historic_ID__c = null LIMIT 1000];
		
		tgts = [SELECT ID, Historic_ID__c FROM Target_Agreement__c WHERE Historic_ID__c = null LIMIT 1000];
		
		cteams = [SELECT ID, Historic_ID__c FROM Contact_Team__c WHERE Historic_ID__c = null LIMIT 1000];
		
		usrs = [SELECT ID, Historic_ID__c FROM User WHERE Historic_ID__c = null LIMIT 1000];
		
		sPerfs = [SELECT ID, Historic_ID__c FROM Sales_Performance__c WHERE Historic_ID__c = null LIMIT 1000];
		
		opps = [SELECT ID, Historic_ID__c FROM Opportunity WHERE Historic_ID__c = null LIMIT 1000];
		
		favs = [SELECT ID, Historic_ID__c FROM Favorites__c WHERE Historic_ID__c = null LIMIT 1000];
		
		for(Account a: accs){
			a.Historic_ID__c = a.Id;
			}
		for(Contact c: ctcs){
			c.Historic_ID__c = c.Id;
			}
		for(Sales_Account_Metrics__c a: sams){
			a.Historic_ID__c = a.Id;
			}
		for(Sales_Contact_Metrics__c c: scms){
			c.Historic_ID__c = c.Id;
			}
		for(Home_Facility__c a: hfs){
			a.Historic_ID__c = a.Id;
			}
		for(Target_Agreement__c a: tgts){
			a.Historic_ID__c = a.Id;
			}
		for(Contact_Team__c c: cteams){
			c.Historic_ID__c = c.Id;
			}
		for(User u: usrs){
			u.Historic_ID__c = u.Id;
			}
		for(Sales_Performance__c s: sPerfs){
			s.Historic_ID__c = s.Id;
			}
		for(Opportunity s: opps){
			s.Historic_ID__c = s.Id;
			}		
		for(Favorites__c s: favs){
			s.Historic_ID__c = s.Id;
			}	
		
		if(accs.size() > 0){
			update accs;
			}
		if(ctcs.size() > 0){
			update ctcs;
			}
		if(sams.size() > 0){
			update sams;
			}
		if(hfs.size() > 0){
			update hfs;
			}
		if(tgts.size() > 0){
			update tgts;
			}
		if(cteams.size() > 0){
			update cteams;
			}
		if(usrs.size() > 0){
			update usrs;
			}
		if(sPerfs.size() > 0){
			update sPerfs;
			}
		if(favs.size() > 0){
			update favs;
			}	
		if(opps.size() > 0){
			update opps;
			}										
		
		}
    
}