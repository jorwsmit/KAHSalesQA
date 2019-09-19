public with sharing class AA_RHCReportController{
	
	public static list<RecordType> lstRTAccount = [Select SobjectType, Name, DeveloperName 
                                                            From RecordType 
                                                            Where SobjectType = 'Account' AND DeveloperName IN ('PF_Chain', 'PF_Client')];
	
	public static list<Profile> proList = [SELECT ID, Name FROM Profile];
	
	/**
    @MethodName : getReportNames
    @Param      : 
    @Description: Method returns list of report names
    **/
    @AuraEnabled(cacheable=true) 
    public static list<string> getReportNames(){
        List<string> lstReportNames = new List<string>{'--None Selected--', 'All Accounts Reporting', 'Activity Reporting', 'Contacts Reporting', 'NPS Activity Report', 'PDPM Assessment 1', 'PDPM Contract Meeting', 'PDPM Contract Renewal'};
        return lstReportNames;
    	}
	
	/**
    @MethodName : getAccounts
    @Param      : 
    @Description: Method returns list of account names
    **/
	@AuraEnabled(cacheable=true) 
	public static list<string> getAccounts(){
		list<string> accounts = new list<string>();
		list<Account> accs = new list<Account>();
		accounts.add('--None Selected--');
		for(Account acc : [SELECT Name, ID FROM Account WHERE RecordTypeID IN: lstRTAccount ORDER BY Name]){
			accounts.add(acc.Name);
			}
		return accounts;
		}
		
	@AuraEnabled(cacheable=true) 
	public static list<string> getADOs(){
		ID adoProID;
		ID dvpProID;
		ID rvpProID;
		ID rhcManagerID;
	
		for(Profile p: proList){
			if(p.Name == 'RHC Ops: ADO'){
				adoProID = p.ID;
				}
			}
		
		list<string> users = new list<string>();
		list<User> usr = new list<User>();
		for(User u : [SELECT Name, ID, UserRole.Name, ProfileID FROM User WHERE ProfileID =: adoProID ORDER By Name]){
				users.add(u.Name);
			}
		return users;
		}
		
	@AuraEnabled(cacheable=true) 
	public static list<string> getRVPs(){
		ID adoProID;
		ID dvpProID;
		ID rvpProID;
		ID rhcManagerID;
	
		for(Profile p: proList){
			if(p.Name == 'RHC Ops: Manager'){
				rhcManagerID = p.ID;
				}
			if(p.Name == 'RHC Ops: ADO'){
				adoProID = p.ID;
				}	
			}
		
		list<string> users = new list<string>();
		list<User> usr = new list<User>();
		for(User u : [SELECT Name, ID, UserRole.Name, ProfileID FROM User WHERE (ProfileID =: rhcManagerID OR ProfileID =: adoProID) ORDER By Name]){
			if(string.isNotBlank(u.UserRole.Name) && u.UserRole.Name.contains('RVP')){
				users.add(u.Name);
				}
			}
		return users;
		}
		
	@AuraEnabled(cacheable=true) 
	public static list<string> getDVPs(){
		ID adoProID;
		ID dvpProID;
		ID rvpProID;
		ID rhcManagerID;
	
		for(Profile p: proList){
			if(p.Name == 'RHC Ops: Manager'){
				rhcManagerID = p.ID;
				}
			if(p.Name == 'RHC Ops: ADO'){
				adoProID = p.ID;
				}	
			}
		list<string> users = new list<string>();
		list<User> usr = new list<User>();
		for(User u : [SELECT Name, ID, UserRole.Name, ProfileID FROM User WHERE (ProfileID =: rhcManagerID OR ProfileID =: adoProID) ORDER By Name]){
			if(string.isNotBlank(u.UserRole.Name) && u.UserRole.Name.contains('DVP')){
				users.add(u.Name);
				}
			}
		return users;
		}			
	
	@AuraEnabled(cacheable=true)
    public static list<sObject> getReportTable(string selReport, string accName){
    	system.debug('SelReport value: ' + selReport);
        
        list<sObject> returnlist = new list<sObject>();
        //calls the method based on selReport value and assigns result to JsonString.
        if(selReport == 'Contacts Reporting'){
            returnlist = getContacts(accName);
          	}
        return returnlist;
    	}
	
	/**
    @MethodName : getContacts
    @Param      : 
    @Description: Method returns list of Contacts under selected account
    **/
	@AuraEnabled(cacheable=true) 
	public static list<Contact> getContacts(string accName){
		
		list<Contact> ctcs = new list<Contact>();
		ctcs = [SELECT Title, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, Phone FROM Contact WHERE Account.RecordTypeID IN: lstRTAccount AND Account.Name =: accName AND Account.Status__c = 'Active'];
		return ctcs;
		}
	
	/**
    @MethodName : getTeams
    @Param      : 
    @Description: Method returns list of facility info for selected account
    **/
    @AuraEnabled(cacheable=true) 	
	public static list<User> getDVPTeams(string accName){
		system.debug('accName: ' + accName);
		list<ID> DVP = new list<ID>();
		list<AccountTeamMember> atms = new list<AccountTeamMember>();
		atms = [SELECT ID, User.FirstName, User.LastName, User.UserRole.Name, User.ProfileID FROM AccountTeamMember WHERE Account.Name =: accName AND Account.RecordTypeID IN: lstRTAccount AND Account.Status__c = 'Active'];
		system.debug('atms: ' + atms);
		for(AccountTeamMember atm: atms){
			system.debug('UserRoleName: ' + atm.User.UserRole.Name);
			if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP')){
				DVP.add(atm.UserID);
				}
			}
		list<User> dvps = new list<User>();
		dvps = [SELECT FirstName, LastName, ProfileID FROM User WHERE ID IN: DVP];	
		
		return dvps;
		}
	
	@AuraEnabled(cacheable=true) 	
	public static list<User> getRVPTeams(string accName){
		system.debug('accName: ' + accName);
		list<ID> RVP = new list<ID>();
		list<AccountTeamMember> atms = new list<AccountTeamMember>();
		atms = [SELECT ID, User.FirstName, User.LastName, User.UserRole.Name, User.ProfileID FROM AccountTeamMember WHERE Account.Name =: accName AND Account.RecordTypeID IN: lstRTAccount AND Account.Status__c = 'Active'];
		system.debug('atms: ' + atms);
		for(AccountTeamMember atm: atms){
			system.debug('UserRoleName: ' + atm.User.UserRole.Name);
			if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP')){
				RVP.add(atm.UserID);
				}
			}
		list<User> rvps = new list<User>();
		rvps = [SELECT FirstName, LastName, ProfileID FROM User WHERE ID IN: RVP];	
		
		return rvps;
		}
	
	@AuraEnabled(cacheable=true) 	
	public static list<User> getADOTeams(string accName){
		ID adoProID;
		ID dvpProID;
		ID rvpProID;
		ID rhcManagerID;
	
		for(Profile p: proList){
			if(p.Name == 'RHC Ops: ADO'){
				adoProID = p.ID;
				}	
			}
		system.debug('accName: ' + accName);
		list<ID> ADO = new list<ID>();
		list<AccountTeamMember> atms = new list<AccountTeamMember>();
		atms = [SELECT ID, User.FirstName, User.LastName, User.UserRole.Name, User.ProfileID FROM AccountTeamMember WHERE Account.Name =: accName AND Account.RecordTypeID IN: lstRTAccount AND Account.Status__c = 'Active'];
		system.debug('atms: ' + atms);
		for(AccountTeamMember atm: atms){
			system.debug('UserRoleName: ' + atm.User.UserRole.Name);
			if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID){
				ADO.add(atm.UserID);
				}
			}
		list<User> ados = new list<User>();
		ados = [SELECT FirstName, LastName, ProfileID FROM User WHERE ID IN: ADO];	
		
		return ados;
		}		
		
	/**
    @MethodName : getFacility
    @Param      : 
    @Description: Method returns list of facility info for selected account
    **/	
	@AuraEnabled(cacheable=true) 
	public static Account getFacility(string accName){
		Account acc = new Account(); 
		acc = [SELECT Name, PF_Product_Type__c, PF_Smart_ID__c, PF_SAP_ID__c FROM Account WHERE recordtypeid IN: lstRTAccount AND Name =: accName];
		return acc;
		}
	
	/**
    @MethodName : getActivities
    @Param      : 
    @Description: Method returns list of Activities under selected account
    **/	
	@AuraEnabled(cacheable=true) 
	public static list<Event> getDVPActivities(string accName){
		list<Event> events = new list<Event>();
		list<ID> ids = new list<ID>();
		for(AccountTeamMember atm : [SELECT ID, User.ID, User.UserRole.Name, User.ProfileID FROM AccountTeamMember WHERE Account.Name =: accName]){
			if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP')){
				ids.add(atm.User.ID);
				}
			}
		events = [SELECT Type, StartDateTime, Description, Owner.ID, Owner.Name FROM Event WHERE Account.RecordTypeID IN: lstRTAccount AND Account.Name =: accName AND Account.Status__c = 'Active' and Owner.ID IN: ids];		
		
		system.debug('DVP Activities: ' + events);
		return events;
		}
		
	@AuraEnabled(cacheable=true)
	public static list<Event> getRVPActivities(string accName){
		list<Event> events = new list<Event>();
		list<ID> ids = new list<ID>();
		for(AccountTeamMember atm : [SELECT ID, User.ID, User.UserRole.Name, User.ProfileID FROM AccountTeamMember WHERE Account.Name =: accName]){
			if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP')){
				ids.add(atm.User.ID);
				}
			}
		events = [SELECT Type, StartDateTime, Description, Owner.ID, Owner.Name FROM Event WHERE Account.RecordTypeID IN: lstRTAccount AND Account.Name =: accName AND Account.Status__c = 'Active' and Owner.ID IN: ids];		
		
		system.debug('RVP Activities: ' + events);
		return events;
		}
		
	@AuraEnabled(cacheable=true) 
	public static list<Event> getADOActivities(string accName){
		ID adoProID;
		ID dvpProID;
		ID rvpProID;
		ID rhcManagerID;
	
		for(Profile p: proList){
			if(p.Name == 'RHC Ops: ADO'){
				adoProID = p.ID;
				}	
			}
		list<Event> events = new list<Event>();
		list<ID> ids = new list<ID>();
		for(AccountTeamMember atm : [SELECT ID, User.ID, User.UserRole.Name, User.ProfileID FROM AccountTeamMember WHERE Account.Name =: accName]){
			if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID){
				ids.add(atm.User.ID);
				}
			}
		events = [SELECT Type, StartDateTime, Description, Owner.ID, Owner.Name FROM Event WHERE Account.RecordTypeID IN: lstRTAccount AND Account.Name =: accName AND Account.Status__c = 'Active' and Owner.ID IN: ids];		
		
		system.debug('ADO Activities: ' + events);
		return events;
		}
		
	@AuraEnabled(cacheable=true) 
	public static list<accountWrapper> getAllRHBActive(string letterStart, string letterEnd, list<string> ADO_Filter, list<string> RVP_Filter, list<string> DVP_Filter){
		ID adoProID;
		ID dvpProID;
		ID rvpProID;
		ID rhcManagerID;
	
		for(Profile p: proList){
			if(p.Name == 'RHC Ops: ADO'){
				adoProID = p.ID;
				}	
			}
		system.debug('letterStart: ' + letterStart);
		system.debug('letterEnd: ' + letterEnd);
		system.debug('ADO Filter: ' + ADO_Filter + ' RVP: ' + RVP_Filter);
		list<accountWrapper> accountWrap = new list<accountWrapper>();
		list<ID> accIDs = new list<ID>();
		list<Account> accounts = new list<Account>();
		list<ID> adoUserIDs = new list<ID>();
		list<ID> dvpUserIDs = new list<ID>();
		list<ID> rvpUserIDs = new list<ID>();
		list<ID> teamUserIDs = new list<ID>();
		list<User> adoUsers = new list<User>();
		list<User> dvpUsers = new list<User>();
		list<User> rvpUsers = new list<User>();
		list<User> teamUsers = new list<User>();
		
		list<Contact> contacts = new list<Contact>();
		
		map<ID, ID> accountAndADOMap = new map<ID, ID>();
		map<ID, User> accountAndADOMapDetail = new map<ID, User>();
		map<ID, ID> accountAndDVPMap = new map<ID, ID>();
		map<ID, User> accountAndDVPMapDetail = new map<ID, User>();
		map<ID, ID> accountAndRVPMap = new map<ID, ID>();
		map<ID, User> accountAndRVPMapDetail = new map<ID, User>();
		
		map<ID, ID> accountAndTeamMap = new map<ID, ID>();
		map<ID, User> accountAndTeamMapDetail = new map<ID, User>();
		map<ID, list<Contact>> accountAndConMap = new map<ID, list<Contact>>();
		
		try{
		for(Account a: [SELECT ID, PF_SAP_ID__c, PF_Smart_ID__c, Name, PF_Product_Type__c, PF_Start_Date__c, PF_Last_Date_of_Service__c FROM Account WHERE RecordTypeID IN: lstRTAccount AND Status__c = 'Active' AND Name >=: letterStart AND Name <: letterEnd Order By Name ASC]){
			accIDs.add(a.ID);
			accounts.add(a);			
			}
		
		list<Contact> ctcs = new list<Contact>();	
		list<AccountTeamMember> atms = new list<AccountTeamMember>();
		atms = [SELECT ID, UserID, AccountID, Account.Name, TeamMemberRole, User.UserRole.Name, User.Name, User.ProfileID  FROM AccountTeamMember WHERE Account.ID IN : accIDs AND Account.RecordTypeID IN: lstRTAccount AND Account.Status__c = 'Active'];
			list<ID> tempAccs = new list<ID>();
			for(AccountTeamMember atm: atms){
				if(ADO_Filter.isEmpty() && RVP_Filter.isEmpty() && DVP_Filter.isEmpty()){
				if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID){
					adoUserIDs.add(atm.UserID);
					accountAndADOMap.put(atm.AccountID, atm.UserID);
					}
				else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP')){
						dvpUserIDs.add(atm.UserID);
						accountAndDVPMap.put(atm.AccountID, atm.UserID);
						}
				else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP')){
						rvpUserIDs.add(atm.UserID);
						accountAndRVPMap.put(atm.AccountID, atm.UserID);
						}
					}
				else{
					if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID && ADO_Filter.contains(atm.User.Name)){
						adoUserIDs.add(atm.UserID);
						accountAndADOMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}
					else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP') && RVP_Filter.contains(atm.User.Name)){
						rvpUserIDs.add(atm.UserID);
						accountAndRVPMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}
					else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP') && DVP_Filter.contains(atm.User.Name)){
						dvpUserIDs.add(atm.UserID);
						accountAndDVPMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}	
					}	
				}
		
		if(ADO_Filter.isEmpty() && RVP_Filter.isEmpty() && DVP_Filter.isEmpty()){
			ctcs = [SELECT ID, Name, Title, Email, Account.ID FROM Contact WHERE Account.ID IN: accIDs  AND Status__c =: 'Active'];		
			}
		else{
			ctcs = [SELECT ID, Name, Title, Email, Account.ID FROM Contact WHERE Account.ID IN: accIDs  AND Status__c =: 'Active' AND Account.ID IN: tempAccs];	
			}
		
		system.debug('ctcs size: ' + ctcs.size());
		
		for(ID i : accIDs){
		list<Contact> tempCons = new list<Contact>();	
		for(Contact c: ctcs){
			if(c.Account.ID == i){
				tempCons.add(c);
				}
			}
			accountAndConMap.put(i, tempCons);
		}
		
		system.debug('adoUserIDs.size: ' + adoUserIDs.size());
		system.debug('dvpUserIDs.size: ' + dvpUserIDs.size());
		system.debug('rvpUserIDs.size: ' + rvpUserIDs.size());			
		system.debug('AccountAndADOMap: ' + accountAndADOMap);
		system.debug('AccountAndDVPMap: ' + accountAndDVPMap);
		system.debug('AccountAndRVPMap: ' + accountAndRVPMap);
			
		
		for(User u: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: adoUserIDs]){
			adoUsers.add(u);
			}
			
		for(User u2: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: dvpUserIDs]){
			dvpUsers.add(u2);
			}
			
		for(User u3: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: rvpUserIDs]){
			rvpUsers.add(u3);
			}		
		
		for(ID aID : accountAndADOMap.keySet()){	
			for(User u4: adoUsers){
				if(u4.ID == accountAndADOMap.get(aID)){
					accountAndADOMapDetail.put(aID, u4);
					}
				}
			}
		system.debug('accountAndADOMapDetail: ' + accountAndADOMapDetail);
		for(ID aID : accountAndDVPMap.keySet()){	
			for(User u5: dvpUsers){
				if(u5.ID == accountAndDVPMap.get(aID)){
					accountAndDVPMapDetail.put(aID, u5);
					}
				}
			}
			
		for(ID aID : accountAndRVPMap.keySet()){	
			for(User u6: rvpUsers){
				if(u6.ID == accountAndRVPMap.get(aID)){
					accountAndRVPMapDetail.put(aID, u6);
					}
				}
			}		
			
		system.debug('accountAndADOMapDetail: ' + accountAndADOMapDetail);
		system.debug('accountAndDVPMapDetail: ' + accountAndDVPMapDetail);
		system.debug('accountAndRVPMapDetail: ' + accountAndRVPMapDetail);		
			
		for(Contact_Team__c ctm: [SELECT ID, Contact__r.AccountId, User__r.ID FROM Contact_Team__c WHERE Contact__r.AccountId IN: accIDs]){
			teamUserIDs.add(ctm.User__r.ID);
			accountAndTeamMap.put(ctm.User__r.ID, ctm.Contact__r.AccountID);
			}
		
		for(User u7: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: teamUserIDs]){
			teamUsers.add(u7);
			}
			
		for(User u8: teamUsers){
			if(accountAndTeamMap.get(u8.ID) != null){
				accountAndTeamMapDetail.put(accountAndTeamMap.get(u8.ID), u8);
				}
			}
		
		for(Account acc: accounts){
			set<User> adoClean = new set<User>();
			list<User> ados = new list<User>();
			set<User> dvpClean = new set<User>();
			list<User> dvps = new list<User>();
			set<User> rvpClean = new set<User>();
			list<User> rvps = new list<User>();
			set<User> teamClean = new set<User>();
			list<User> cTeam = new list<User>();
			list<Contact> cons = new list<Contact>();
			set<Contact> conClean = new set<Contact>();
			integer accSize = 0;
			Integer adoSize	= 0;
			Integer dvpSize	= 0;
			Integer rvpSize	= 0;
			Integer cTeamSize = 0;
			Integer conSize = 0;
			for(ID aID : accountAndADOMapDetail.keySet()){
				if(aID == acc.ID){
					adoClean.add(accountAndADOMapDetail.get(aID));
					accSize += 1;
					adoSize += 1;
					}
				}
			for(ID aID2 : accountAndDVPMapDetail.keySet()){
				if(aID2 == acc.ID){
					dvpClean.add(accountAndDVPMapDetail.get(aID2));
					accSize += 1;
					dvpSize += 1;
					}
				}
			for(ID aID3 : accountAndRVPMapDetail.keySet()){
				if(aID3 == acc.ID){
					rvpClean.add(accountAndrVPMapDetail.get(aID3));
					accSize += 1;
					rvpSize += 1;
					}
				}		
			for(ID cID : accountAndTeamMapDetail.keySet()){
				if(cID == acc.ID){
					teamClean.add(accountAndTeamMapDetail.get(cID));
					accSize += 1;
					cTeamSize += 1;
					}
				}
			for(ID conID : accountAndConMap.keySet()){
				if(conID == acc.ID && accountAndConMap.get(conID) != null){
					conClean.addAll(accountAndConMap.get(conID));
					accSize +=1;
					conSize +=1;
					}
				}	
			ados.addAll(adoClean);
			dvps.addAll(dvpClean);
			rvps.addAll(rvpClean);
			cTeam.addAll(teamClean);
			cons.addAll(conClean);
			if(ados.size() > 0 || dvps.size() > 0 || rvps.size() > 0 || cTeam.size() > 0 || cons.size() > 0){		
				accountWrap.add(new accountWrapper(acc, ados, dvps, rvps, cteam, cons, accSize, adoSize, dvpSize, rvpSize, cTeamSize, conSize));
				}
			}
		return accountWrap;
		}
		catch(Exception E){
			system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			return null;
			}
		}
		
	public class accountWrapper{
		@AuraEnabled
		list<User> cTeam	{get;set;}
		@AuraEnabled
		list<User> ados	{get;set;}
		@AuraEnabled
		list<User> dvps	{get;set;}
		@AuraEnabled
		list<User> rvps	{get;set;}
		@AuraEnabled
		Account a	{get;set;}
		@AuraEnabled
		Integer accSize	{get;set;}
		@AuraEnabled
		Integer adoSize	{get;set;}
		@AuraEnabled
		Integer dvpSize	{get;set;}
		@AuraEnabled
		Integer rvpSize	{get;set;}
		@AuraEnabled
		Integer cTeamSize	{get;set;}
		@AuraEnabled
		list<Contact> cons	{get;set;}
		@AuraEnabled
		Integer conSize	{get;set;}
		
		
		public accountWrapper(Account a, list<User> ados, list<User> dvps, list<User> rvps, list<User> cTeam, list<Contact> cons, Integer accSize, integer adoSize, integer dvpSize, integer rvpSize, integer cTeamSize, Integer conSize){
			this.a = a;
			this.ados = ados;
			this.dvps = dvps;
			this.rvps = rvps;
			this.cTeam = cTeam;
			this.accSize = accSize;
			this.adoSize = adoSize;
			this.dvpSize = dvpSize;
			this.rvpSize = rvpSize;
			this.cTeamSize = cTeamSize;
			this.cons = cons;
			this.conSize = conSize;
			}
		
		}
		
		@AuraEnabled(cacheable=true) 
		public static list<ActivityWrapper> getNPSTasks(list<String> ADO_Filter, list<String> RVP_Filter, list<String> DVP_Filter, string letterStart, string letterEnd){
			ID adoProID;
			ID dvpProID;
			ID rvpProID;
			ID rhcManagerID;
	
			for(Profile p: proList){
				if(p.Name == 'RHC Ops: ADO'){
					adoProID = p.ID;
					}	
				}
			list<ActivityWrapper> npsList = new list<ActivityWrapper>();
			
			system.debug('ADO Filter: ' + ADO_Filter + ' RVP: ' + RVP_Filter);
			set<ID> accIDs = new set<ID>();
			list<Account> accounts = new list<Account>();
			list<ID> adoUserIDs = new list<ID>();
			list<ID> dvpUserIDs = new list<ID>();
			list<ID> rvpUserIDs = new list<ID>();
			list<User> adoUsers = new list<User>();
			list<User> dvpUsers = new list<User>();
			list<User> rvpUsers = new list<User>();
		
			map<ID, ID> accountAndADOMap = new map<ID, ID>();
			map<ID, User> accountAndADOMapDetail = new map<ID, User>();
			map<ID, ID> accountAndDVPMap = new map<ID, ID>();
			map<ID, User> accountAndDVPMapDetail = new map<ID, User>();
			map<ID, ID> accountAndRVPMap = new map<ID, ID>();
			map<ID, User> accountAndRVPMapDetail = new map<ID, User>();
			
			list<Task> tasks = new list<Task>();
			map<ID, list<Task>> accountAndTaskMap = new map<ID, list<Task>>();
			
		try{
			list<Task> initTaskList = new list<Task>();
			initTaskList = [SELECT Owner.ID, Owner.Name, Subject, WhatID, What.Name, Priority, Status, LastModifiedDate, WhoID, Who.Name, PF_Product_Type2__c, PF_NPS_Score__c, Description, Who.Title, ActivityDate FROM Task WHERE Subject =: 'NPS Survey Follow-up' Order By What.Name ASC]; 
			for(Task t: initTaskList){
				accIDs.add(t.WhatID);
				}
			accounts = [SELECT ID, Name, PF_Product_Type__c, PF_Start_Date__c, PF_Last_Date_of_Service__c, PF_SAP_ID__c, PF_Smart_ID__c FROM Account WHERE ID IN: accIDs AND RecordTypeID IN: lstRTAccount AND Status__c = 'Active' AND Name >=: letterStart AND Name <: letterEnd Order By Name ASC];
			
			for(Account a : accounts){
				list<Task> accTasks = new list<Task>();
				for(Task t : initTaskList){
					if(t.WhatID == a.ID){
						accTasks.add(t);
						}
					accountAndTaskMap.put(a.ID, accTasks);
					}
				}
			
			system.debug('Tasks:' + initTaskList);
			system.debug('Accounts:' + accounts);
			
			list<AccountTeamMember> atms = new list<AccountTeamMember>();
			atms = [SELECT ID, UserID, AccountID, Account.Name, TeamMemberRole, User.UserRole.Name, User.Name, User.ProfileID  FROM AccountTeamMember WHERE Account.ID IN : accIDs AND Account.RecordTypeID IN: lstRTAccount AND Account.Status__c = 'Active'];
			list<ID> tempAccs = new list<ID>();
			for(AccountTeamMember atm: atms){
				if(ADO_Filter.isEmpty() && RVP_Filter.isEmpty() && DVP_Filter.isEmpty()){
				if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID){
					adoUserIDs.add(atm.UserID);
					accountAndADOMap.put(atm.AccountID, atm.UserID);
					}
				else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP')){
						dvpUserIDs.add(atm.UserID);
						accountAndDVPMap.put(atm.AccountID, atm.UserID);
						}
				else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP')){
						rvpUserIDs.add(atm.UserID);
						accountAndRVPMap.put(atm.AccountID, atm.UserID);
						}
					}
				else{
					if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID && ADO_Filter.contains(atm.User.Name)){
						adoUserIDs.add(atm.UserID);
						accountAndADOMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}
					else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP') && RVP_Filter.contains(atm.User.Name)){
						rvpUserIDs.add(atm.UserID);
						accountAndRVPMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}
					else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP') && DVP_Filter.contains(atm.User.Name)){
						dvpUserIDs.add(atm.UserID);
						accountAndDVPMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}	
					}	
				}
				
				for(User u: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: adoUserIDs]){
			adoUsers.add(u);
			}
			
		for(User u2: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: dvpUserIDs]){
			dvpUsers.add(u2);
			}
			
		for(User u3: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: rvpUserIDs]){
			rvpUsers.add(u3);
			}		
		
		for(ID aID : accountAndADOMap.keySet()){	
			for(User u4: adoUsers){
				if(u4.ID == accountAndADOMap.get(aID)){
					accountAndADOMapDetail.put(aID, u4);
					}
				}
			}
		
		for(ID aID : accountAndDVPMap.keySet()){	
			for(User u5: dvpUsers){
				if(u5.ID == accountAndDVPMap.get(aID)){
					accountAndDVPMapDetail.put(aID, u5);
					}
				}
			}
			
		for(ID aID : accountAndRVPMap.keySet()){	
			for(User u6: rvpUsers){
				if(u6.ID == accountAndRVPMap.get(aID)){
					accountAndRVPMapDetail.put(aID, u6);
					}
				}
			}
			
			for(Account acc: accounts){
			set<User> adoClean = new set<User>();
			list<User> ados = new list<User>();
			set<User> dvpClean = new set<User>();
			list<User> dvps = new list<User>();
			set<User> rvpClean = new set<User>();
			list<User> rvps = new list<User>();
			set<Task> taskClean = new set<Task>();
			list<Task> tasks2 = new list<Task>();
			integer accSize = 0;
			Integer adoSize	= 0;
			Integer dvpSize	= 0;
			Integer rvpSize	= 0;
			Integer taskSize = 0;
					
			for(ID taskID : accountAndTaskMap.keySet()){
				if(taskID == acc.ID  && accountAndTaskMap.get(taskID) != null){
					taskClean.addAll(accountAndTaskMap.get(taskID));
					accSize +=1;
					taskSize +=1;
			for(ID aID : accountAndADOMapDetail.keySet()){
				if(aID == acc.ID){
					adoClean.add(accountAndADOMapDetail.get(aID));
					adoSize += 1;
					}
				}
			for(ID aID2 : accountAndDVPMapDetail.keySet()){
				if(aID2 == acc.ID){
					dvpClean.add(accountAndDVPMapDetail.get(aID2));
					dvpSize += 1;
					}
				}
			for(ID aID3 : accountAndRVPMapDetail.keySet()){
				if(aID3 == acc.ID){
					rvpClean.add(accountAndrVPMapDetail.get(aID3));
					rvpSize += 1;
					}
				}
					}
					}	
			ados.addAll(adoClean);
			dvps.addAll(dvpClean);
			rvps.addAll(rvpClean);
			tasks2.addAll(taskClean);
			if(tasks2.size() > 0 && (adoSize > 0 || dvpSize > 0 || rvpSize > 0)){		
				npsList.add(new activityWrapper(acc, ados, dvps, rvps, tasks2, accSize, adoSize, dvpSize, rvpSize, taskSize));
				}
			}
			
			return npsList;
			}
		catch(Exception E){
			system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			return null;
			}	
			}
			
	@AuraEnabled(cacheable=true) 
		public static list<ActivityWrapper> getPDPMTasks(list<String> ADO_Filter, list<String> RVP_Filter, list<String> DVP_Filter, string letterStart, string letterEnd, string reportName){
			list<ActivityWrapper> pdpmList = new list<ActivityWrapper>();
			ID adoProID;
			ID dvpProID;
			ID rvpProID;
			ID rhcManagerID;
	
			for(Profile p: proList){
				if(p.Name == 'RHC Ops: ADO'){
					adoProID = p.ID;
					}	
				}
			string taskType = reportName;
			system.debug('reportName: ' + taskType);
			system.debug('ADO Filter: ' + ADO_Filter + ' RVP: ' + RVP_Filter + ' DVP: ' + DVP_Filter);
			set<ID> accIDs = new set<ID>();
			list<Account> accounts = new list<Account>();
			list<ID> adoUserIDs = new list<ID>();
			list<ID> dvpUserIDs = new list<ID>();
			list<ID> rvpUserIDs = new list<ID>();
			list<User> adoUsers = new list<User>();
			list<User> dvpUsers = new list<User>();
			list<User> rvpUsers = new list<User>();
		
			map<ID, ID> accountAndADOMap = new map<ID, ID>();
			map<ID, User> accountAndADOMapDetail = new map<ID, User>();
			map<ID, ID> accountAndDVPMap = new map<ID, ID>();
			map<ID, User> accountAndDVPMapDetail = new map<ID, User>();
			map<ID, ID> accountAndRVPMap = new map<ID, ID>();
			map<ID, User> accountAndRVPMapDetail = new map<ID, User>();
			
			list<Task> tasks = new list<Task>();
			map<ID, list<Task>> accountAndTaskMap = new map<ID, list<Task>>();
		try{
			list<Task> initTaskList = new list<Task>();
			initTaskList = [SELECT Owner.ID, Owner.Name, Subject, WhatID, What.Name, Priority, Status, LastModifiedDate, WhoID, Who.Name, PF_Product_Type2__c, PF_NPS_Score__c, Description, Who.Title, ActivityDate, Type FROM Task WHERE Type =: taskType Order By What.Name ASC]; 
			for(Task t: initTaskList){
				accIDs.add(t.WhatID);
				}
			accounts = [SELECT ID, Name, PF_Product_Type__c, PF_Start_Date__c, PF_Last_Date_of_Service__c, PF_SAP_ID__c, PF_Smart_ID__c FROM Account WHERE ID IN: accIDs AND RecordTypeID IN: lstRTAccount AND Status__c = 'Active' AND Name >=: letterStart AND Name <: letterEnd Order By Name ASC];
			
			for(Account a : accounts){
				list<Task> accTasks = new list<Task>();
				for(Task t : initTaskList){
					if(t.WhatID == a.ID){
						accTasks.add(t);
						}
					accountAndTaskMap.put(a.ID, accTasks);
					}
				}
			
			system.debug('Tasks:' + initTaskList);
			system.debug('Accounts:' + accounts);
			
			list<AccountTeamMember> atms = new list<AccountTeamMember>();
			atms = [SELECT ID, UserID, AccountID, Account.Name, TeamMemberRole, User.UserRole.Name, User.Name, User.ProfileID  FROM AccountTeamMember WHERE Account.ID IN : accIDs AND Account.RecordTypeID IN: lstRTAccount AND Account.Status__c = 'Active'];
			list<ID> tempAccs = new list<ID>();
			for(AccountTeamMember atm: atms){
				if(ADO_Filter.isEmpty() && RVP_Filter.isEmpty() && DVP_Filter.isEmpty()){
				if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID){
					adoUserIDs.add(atm.UserID);
					accountAndADOMap.put(atm.AccountID, atm.UserID);
					}
				else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP')){
						dvpUserIDs.add(atm.UserID);
						accountAndDVPMap.put(atm.AccountID, atm.UserID);
						}
				else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP')){
						rvpUserIDs.add(atm.UserID);
						accountAndRVPMap.put(atm.AccountID, atm.UserID);
						}
					}
				else{
					if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.ProfileID == adoProID && ADO_Filter.contains(atm.User.Name)){
						adoUserIDs.add(atm.UserID);
						accountAndADOMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}
					else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('RVP') && RVP_Filter.contains(atm.User.Name)){
						rvpUserIDs.add(atm.UserID);
						accountAndRVPMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}
					else if(string.isNotBlank(atm.User.UserRole.Name) && atm.User.UserRole.Name.contains('DVP') && DVP_Filter.contains(atm.User.Name)){
						dvpUserIDs.add(atm.UserID);
						accountAndDVPMap.put(atm.AccountID, atm.UserID);
						tempAccs.add(atm.Account.ID);
						}	
					}	
				}
				
				for(User u: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: adoUserIDs]){
					adoUsers.add(u);
					}
			
				for(User u2: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: dvpUserIDs]){
					dvpUsers.add(u2);
					}
			
				for(User u3: [SELECT Name, ID, Title, Email, ProfileID FROM User WHERE ID IN: rvpUserIDs]){
					rvpUsers.add(u3);
					}		
		
			for(ID aID : accountAndADOMap.keySet()){	
				for(User u4: adoUsers){
					if(u4.ID == accountAndADOMap.get(aID)){
						accountAndADOMapDetail.put(aID, u4);
						}
					}
				}
		
			for(ID aID : accountAndDVPMap.keySet()){	
				for(User u5: dvpUsers){
					if(u5.ID == accountAndDVPMap.get(aID)){
						accountAndDVPMapDetail.put(aID, u5);
						}
					}
				}
			
			for(ID aID : accountAndRVPMap.keySet()){	
				for(User u6: rvpUsers){
					if(u6.ID == accountAndRVPMap.get(aID)){
						accountAndRVPMapDetail.put(aID, u6);
						}
					}
				}
			
			for(Account acc: accounts){
				set<User> adoClean = new set<User>();
				list<User> ados = new list<User>();
				set<User> dvpClean = new set<User>();
				list<User> dvps = new list<User>();
				set<User> rvpClean = new set<User>();
				list<User> rvps = new list<User>();
				set<Task> taskClean = new set<Task>();
				list<Task> tasks2 = new list<Task>();
				integer accSize = 0;
				Integer adoSize	= 0;
				Integer dvpSize	= 0;
				Integer rvpSize	= 0;
				Integer taskSize = 0;
					
			for(ID taskID : accountAndTaskMap.keySet()){
				if(taskID == acc.ID  && accountAndTaskMap.get(taskID) != null){
					taskClean.addAll(accountAndTaskMap.get(taskID));
					accSize +=1;
					taskSize +=1;
			for(ID aID : accountAndADOMapDetail.keySet()){
				if(aID == acc.ID){
					adoClean.add(accountAndADOMapDetail.get(aID));
					adoSize += 1;
					}
				}
			for(ID aID2 : accountAndDVPMapDetail.keySet()){
				if(aID2 == acc.ID){
					dvpClean.add(accountAndDVPMapDetail.get(aID2));
					dvpSize += 1;
					}
				}
			for(ID aID3 : accountAndRVPMapDetail.keySet()){
				if(aID3 == acc.ID){
					rvpClean.add(accountAndrVPMapDetail.get(aID3));
					rvpSize += 1;
					}
					}
					}
					}	
				ados.addAll(adoClean);
				dvps.addAll(dvpClean);
				rvps.addAll(rvpClean);
				tasks2.addAll(taskClean);
				if(tasks2.size() > 0 && (adoSize > 0 || dvpSize > 0 || rvpSize > 0)){		
					pdpmList.add(new activityWrapper(acc, ados, dvps, rvps, tasks2, accSize, adoSize, dvpSize, rvpSize, taskSize));
					}
				}
			
				return pdpmList;
				}
			catch(Exception E){
				system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
				return null;
				}	
			}		 				
	
	public class activityWrapper{
		@AuraEnabled
		list<User> ados	{get;set;}
		@AuraEnabled
		list<User> dvps	{get;set;}
		@AuraEnabled
		list<User> rvps	{get;set;}
		@AuraEnabled
		Account a	{get;set;}
		@AuraEnabled
		Integer accSize	{get;set;}
		@AuraEnabled
		Integer adoSize	{get;set;}
		@AuraEnabled
		Integer dvpSize	{get;set;}
		@AuraEnabled
		Integer rvpSize	{get;set;}
		@AuraEnabled
		List<Task> tasks	{get;set;}
		@AuraEnabled
		Integer taskSize	{get;set;}
		
		public activityWrapper(Account a, list<User> ados, list<User> dvps, list<User> rvps, list<Task> tasks, Integer accSize, integer adoSize, integer dvpSize, integer rvpSize, Integer taskSize){
			this.a = a;
			this.ados = ados;
			this.dvps = dvps;
			this.rvps = rvps;
			this.accSize = accSize;
			this.adoSize = adoSize;
			this.dvpSize = dvpSize;
			this.rvpSize = rvpSize;
			this.taskSize = taskSize;
			this.tasks = tasks;
			}
		
		}    
}