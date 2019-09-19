public with sharing class AA_RHCAccountTeamHelper{
	
	@future 
	public static void processAccounts(List<ID> rhcAccounts){
		list<ID> accIDs = new list<ID>();
		set<ID> cleanAccounts = new set<ID>();
		cleanAccounts.addAll(rhcAccounts);
		
		list<Account> toProcess = new list<Account>();
		
		map<ID, list<string>> accountAndADOMap = new map<ID, list<string>>();
		map<ID, list<User>> accountAndADOMapDetail = new map<ID, list<User>>();
		map<ID, list<string>> accountAndDVPMap = new map<ID, list<string>>();
		map<ID, list<User>> accountAndDVPMapDetail = new map<ID, list<User>>();
		map<ID, list<string>> accountAndRVPMap = new map<ID, list<string>>();
		map<ID, list<User>> accountAndRVPMapDetail = new map<ID, list<User>>();
		
		accIDs.addAll(cleanAccounts);
		
		list<AccountTeamMember> atms = new list<AccountTeamMember>();
		atms = [SELECT ID, UserID, AccountID, Account.Name, TeamMemberRole, User.Name FROM AccountTeamMember WHERE Account.ID IN : accIDs AND TeamMemberRole != 'Corporate (Partner First)' Order By Account.Name];
		system.debug('atms: ' + atms);
			
			for(ID accID : accIDs){
				list<String> ados = new list<String>();
				list<String> dvps = new list<String>();
				list<String> rvps = new list<String>();
			for(AccountTeamMember atm: atms){
				if(string.isNotBlank(atm.TeamMemberRole) && atm.TeamMemberRole == 'ADO (Partner First)' && atm.accountID == accID){
					ados.add(atm.User.Name);
					}
				else if(string.isNotBlank(atm.TeamMemberRole) && atm.TeamMemberRole == 'DVP (Partner First)' && atm.accountID == accID){
						dvps.add(atm.User.Name);
						}
				else if(string.isNotBlank(atm.TeamMemberRole) && atm.TeamMemberRole == 'RVP (Partner First)' && atm.accountID == accID){
						rvps.add(atm.User.Name);
						}
					}
					system.debug('ado1: ' + ados);
					system.debug('dvp1: ' + dvps);
					system.debug('rvp1: ' + rvps);
					accountAndADOMap.put(accID, ados);
					accountAndDVPMap.put(accID, dvps);
					accountAndRVPMap.put(accID, rvps);
				}
				
			toProcess = [SELECT ID, ADOs__c, DVPs__c, RVPs__c, Name FROM Account WHERE ID IN: accIDs Order By Name];
			list<Account> toUpdate = new list<Account>();
			
			for(Account acc : toProcess){
				set<string> adoClean = new set<string>();
				list<string> ados = new list<string>();
				set<string> dvpClean = new set<string>();
				list<string> dvps = new list<string>();
				set<string> rvpClean = new set<string>();
				list<string> rvps = new list<string>();
					
				for(ID aID : accountAndADOMap.keySet()){
					if(aID == acc.ID){
						adoClean.addAll(accountAndADOMap.get(aID));
						}
					}
				for(ID aID2 : accountAndDVPMap.keySet()){
					if(aID2 == acc.ID){
						dvpClean.addAll(accountAndDVPMap.get(aID2));
						}
					}
				for(ID aID3 : accountAndRVPMap.keySet()){
					if(aID3 == acc.ID){
						rvpClean.addAll(accountAndrVPMap.get(aID3));
						}
					}
					
				ados.addAll(adoClean);
				dvps.addAll(dvpClean);
				rvps.addAll(rvpClean);
				
				
					string adosList = '';
					system.debug('adoSize: ' + ados.size());
					system.debug('ados: ' + ados);
					for(String u: ados){
						adosList = adosList + u + '\n';
						}
						acc.ADOs__c = adosList;
					if(ados.size() == 0){
						acc.ADOs__c = null;
						}
				
					system.debug('dvpsSize: ' + dvps.size());
					system.debug('dvps: ' + dvps);	
					string dvpsList = '';
					for(String u : dvps){
						dvpsList = dvpsList + u + '\n';
						}
						acc.DVPs__c = dvpsList;
					if(dvps.size() == 0){
						acc.DVPs__c = null;
						}
					
					system.debug('rvpsSize: ' + rvps.size());
					system.debug('rvps: ' + rvps);	
					string rvpsList = '';
					for(string u : rvps){
						rvpsList = rvpsList + u + '\n';
						}
						acc.RVPs__c = rvpsList;
					if(rvps.size() == 0){
						acc.RVPs__c = null;
						}
					
					toUpdate.add(acc);
			}
			list<ID> rhcIDs = new list<ID>();
			for(Account a: toUpdate){
				rhcIDs.add(a.ID);
				}
			list<Contact> rhcContacts = new list<Contact>();
			rhcContacts = [SELECT ID, DVPs__c, RVPs__c, ADOs__c, AccountID FROM Contact WHERE AccountID IN: rhcIDs];
			
			for(Account a: toUpdate){
				for(Contact c: rhcContacts){
					if(a.ID == c.AccountID){
						c.RVPs__c = a.RVPs__c;
						c.DVPs__c = a.DVPs__c;
						c.ADOs__c = a.ADOs__c;
						}
					}
				}
			try{
				system.debug('toUpdate: ' + toUpdate);
				system.debug('rhcContacts: ' + rhcContacts);
				update toUpdate;
				update rhcContacts;
				}
			catch(Exception E){
				system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
				}		
		}
    
}