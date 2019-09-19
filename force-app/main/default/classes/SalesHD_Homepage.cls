global with sharing class SalesHD_Homepage {

	public String actualAdmits {get; set;}
	public String admitTarget {get; set;}
	public String admitsTotarget {get; set;}

	public String accountSearchString {get; set;}
	public String selectedAccountId {get; set;}

	public String contactSearchString {get; set;}
	public String selectedContactId {get; set;}

	public String medparStates {get; set;}
	public String medparYears {get; set;}
	public String medparFiles {get; set;}

	private static Id currentUser = UserInfo.getUserId();

	public class directoryObject{
		public String name;
		public Id directoryId;
		public String type;
		public String title = '';
		public boolean isPhysician = false;
		// public String lastCalled ='<p class="text-danger">Never called</p>';
		public String lastCalled ='';
	}

	public class leaderboardObject{
		public String name;
		public Id userId;
		public String market;
		public String district;
		public String revenue;
		public String photoUrl;
		public Integer ranking;
	}

	public class message{
		public String author = '';
		public String authorTitle = '';
		public String message = '';
		public String sentDate = '';
	}

	public class notification{
		public String n_date = '';
		public String body = '';
		public String n_id = '';
		public String n_type = '';
		public String icon = '';
	}

	public SalesHD_Homepage() {
		this.actualAdmits = null;
		this.admitTarget = null;
		this.admitsTotarget = null;
		for(Sales_Performance__c sp : [select Actual_Admissions__c, Targeted_Admissions__c from Sales_Performance__c where
		OwnerId =: currentUser and Month__c = this_month]){
			this.actualAdmits = String.valueOf(sp.Actual_Admissions__c);
			this.admitTarget = String.valueOf(sp.Targeted_Admissions__c);
			if(sp.Actual_Admissions__c < sp.Targeted_Admissions__c){
				this.admitsTotarget = String.valueOf(sp.Targeted_Admissions__c - sp.Actual_Admissions__c);
			} else{
				this.admitsTotarget = String.valueOf(0);
			}

		}

		Id workspaceId;

		for(ContentWorkspace cw : [select Id from ContentWorkspace where name='Sales Medpar' limit 1]){
			workspaceId = cw.Id;
		}

		List<ContentVersion> medpar = new List<ContentVersion>();
		Set<String> medparStateSet = new Set<String>();
		Set<Integer> medparYearSet = new Set<Integer>();
		for(ContentVersion cv : [select Title, Id, FileType, Medpar_Year__c, Medpar_State__c from ContentVersion where IsLatest=true and ContentDocument.ParentId =: workspaceId]){
			if(cv.Medpar_State__c!=null && !medparStateSet.contains(cv.Medpar_State__c)){
				medparStateSet.add(cv.Medpar_State__c);
			}
			if(cv.Medpar_Year__c!=null && !medparYearSet.contains(Integer.valueOf(cv.Medpar_Year__c))){
				medparYearSet.add(Integer.valueOf(cv.Medpar_Year__c));
			}
			medpar.add(cv);
		}
		medparStates = JSON.serializePretty(medparStateSet);
		medparYears = JSON.serializePretty(medparYearSet);
		medparFiles = JSON.serializePretty(medpar);


	}

	@RemoteAction global static String getDirectory() {
		List<directoryObject> directory = new List<directoryObject>();

		for(Contact_team__c c : [select Contact__r.Id, Contact__r.Name, Contact__r.RecordType.Name, Contact__r.Title__c from Contact_Team__c where User__c =: currentUser]){
			directoryObject temp = new directoryObject();
			temp.name = c.Contact__r.Name;
			temp.directoryId = c.Contact__r.Id;
			temp.type = 'Contact';
			if(c.Contact__r.Title__c!=null) temp.title= ' - ' + String.valueOf(c.Contact__r.Title__c);
			if(c.Contact__r.RecordType.Name=='HD Physicians') temp.isPhysician=true;
			directory.add(temp);
		}

		for(AccountTeamMember a : [select AccountId, Account.Name from AccountTeamMember where Account.Status__c='Active' and UserId =: currentUser and Account.RecordType.Name='HD Accounts']){
			directoryObject temp = new directoryObject();
			temp.name = a.Account.Name;
			temp.directoryId = a.AccountId;
			temp.type = 'Account';
			directory.add(temp);
		}

		return JSON.serializePretty(directory);
	}

	@RemoteAction global static String getLeaderboard() {
		List<leaderboardObject> leaderboard = new List<leaderboardObject>();
		Integer i = 1;
		List<Id> roleId = new List<Id>();
		roleId.add(UserInfo.getUserRoleId());
		Map<Id, User> users = new Map<ID, User>([select Name, SmallPhotoUrl, UserRole.Name from User where UserRoleId in :roleId]);
		for(Sales_Performance__c sp : [select OwnerId, Actual_Revenue__c, Revenue_to_Goal__c  from Sales_Performance__c where
		OwnerId in :users.keyset() and Month__c = last_month and Actual_Revenue__c!=null order by Revenue_to_Goal__c desc]){
			leaderboardObject temp = new leaderboardObject();
			temp.name = users.get(sp.OwnerId).Name;
			temp.userId = sp.OwnerId;
			// temp.revenue = '$'+String.valueOf(sp.Actual_Revenue__c.setScale(2));
			temp.revenue = '%'+String.valueOf(sp.Revenue_to_Goal__c.setScale(2));
			temp.market = users.get(sp.OwnerId).UserRole.Name;
			temp.photoUrl =  users.get(sp.OwnerId).SmallPhotoUrl;
			temp.ranking =  i;
			leaderboard.add(temp);
			i++;
		}
		return JSON.serializePretty(leaderboard);
	}

	@RemoteAction global static String getAccounts() {
		return JSON.serializePretty([select AccountId, Account.Name, Account.ShippingAddress__c from AccountTeamMember where Account.Status__c='Active' and UserId =: currentUser and Account.RecordType.Name='HD Accounts']);
	}

	@RemoteAction global static String getMessages() {
		Set<Id> parentUserIds = getParentRoleId(new Set<ID>{UserInfo.getUserRoleId()});
		parentUserIds.add(UserInfo.getUserRoleId());

		List<message> messages = new List<message>();
		for(Alert_and_Comment__c ac : [select Comment__c, Comment_By__r.Name, Comment_By__r.Title, Datetime__c
		from Alert_and_Comment__c where Type__c='HD Corporate Message' and Comment_By__r.UserRoleId in: parentUserIds
		and (Datetime__c=last_n_days:15 or Datetime__c=this_month)]){
			message temp = new message();
			if(ac.Comment__c!=null) temp.message=ac.Comment__c;
			if(ac.Comment_By__r.Name!=null) temp.author=ac.Comment_By__r.Name;
			if(ac.Comment_By__r.Title!=null) temp.authorTitle=ac.Comment_By__r.Title;
			if(ac.Datetime__c!=null) temp.sentDate=Date.valueOf(ac.Datetime__c).format();
			messages.add(temp);
		}
		return JSON.serializePretty(messages);
	}

	@RemoteAction global static String getNotifications() {
		List<notification> notifications = new List<notification>();

		// for(New_Physician_Request__c pr : [select First_Name__c, Last_Name__c, Contact__c, Completed_Date__c from New_Physician_Request__c
		// where (Completed_Date__c=null or Completed_Date__c>=last_n_weeks:2
		// or Completed_Date__c=today or Completed_Date__c<=next_n_weeks:2)
		// and CreatedById=:currentUser]){
		// 	notification temp = new notification();
		// 	temp.n_type = 'physician';
		// 	if(pr.Completed_Date__c==null){
		// 		temp.icon = '<i class="fas fa-user-md blue round-icon-blue"></i>';
		// 		temp.body = 'Your new physician, '+pr.First_Name__c+' '+pr.Last_Name__c+', has been requested.';
		// 	} else {
		// 		temp.n_id = pr.Contact__c;
		// 		temp.icon = '<i class="fas fa-user-md green round-icon-green"></i>';
		// 		temp.body = 'Your new physician, '+pr.First_Name__c+' '+pr.Last_Name__c+', has been processed! Click here to open their contact page.';
		// 	}
		// 	notifications.add(temp);
		// }

		for(Contact pr : [select FirstName, LastName, Id, HD_Physician_Request_Completed_Date__c from Contact
		where (HD_Physician_Request_Completed_Date__c=null or HD_Physician_Request_Completed_Date__c>=last_n_weeks:2
		or HD_Physician_Request_Completed_Date__c=today or HD_Physician_Request_Completed_Date__c<=next_n_weeks:2)
		and OwnerId=:currentUser and RecordType.Name='HD Physician Requests']){
			notification temp = new notification();
			temp.n_type = 'physician';
			if(pr.HD_Physician_Request_Completed_Date__c==null){
				temp.icon = '<i class="fas fa-user-md blue round-icon-blue"></i>';
				temp.body = 'Your new physician, '+pr.FirstName+' '+pr.LastName+', has been requested.';
			} else {
				temp.n_id = pr.Id;
				temp.icon = '<i class="fas fa-user-md green round-icon-green"></i>';
				temp.body = 'Your new physician, '+pr.FirstName+' '+pr.LastName+', has been processed! Click here to open their contact page.';
			}
			notifications.add(temp);
		}

		for(event e : [select ActivityDateTime, who.Name, what.Name, Id from event where ownerId=:currentUser and
		(activityDateTime=last_n_weeks:2 or activityDateTime=last_n_days:14) and (SalesHD_Complete__c=false or Result__c=null) and WhoId!=null and WhatId!=null]){
			notification temp = new notification();
			// if(e.who.Name!=null) temp.body = 'You have a follow up with '+e.who.Name+' scheduled for '+ String.valueOf(Date.valueOf(e.ActivityDateTime).format())+'.';
			// else if(e.what.Name!=null) temp.body = 'You have a follow up with '+e.what.Name+' scheduled for '+ String.valueOf(Date.valueOf(e.ActivityDateTime).format())+'.';
			temp.n_id = e.Id;
			temp.n_type = 'event';
			temp.icon = '<i class="fas fa-phone red round-icon-red"></i>';
			temp.body = 'You need to fill out results/follow-ups for the encounter with '+e.who.Name+' at '+e.what.Name+' scheduled for '+ String.valueOf(Date.valueOf(e.ActivityDateTime).format())+'.';

			notifications.add(temp);
		}
		return JSON.serializePretty(notifications);
	}


	@RemoteAction global static String getContacts() {
		return JSON.serializePretty([select Contact__r.Id, Contact__r.Name, Contact__r.MailingAddress__c, Contact__r.RecordType.Name, Contact__r.Title__c from Contact_Team__c where User__c =: currentUser]);
	}

	@RemoteAction global static List<Account> searchAccounts(String accountSearchString, String selectedState) {
		List<Account> accounts = new List<Account>();
		if(selectedState!=null && selectedState!='') accounts = Database.query('Select Id, Name, ShippingAddress__c from Account where name like \'%' + String.escapeSingleQuotes(accountSearchString) + '%\' and recordtype.name=\'HD Accounts\' and Status__c=\'Active\' and ShippingState=\''+selectedState+'\' limit 100');
		else  accounts = Database.query('Select Id, Name, ShippingAddress__c from Account where name like \'%' + String.escapeSingleQuotes(accountSearchString) + '%\' and recordtype.name=\'HD Accounts\' and Status__c=\'Active\' limit 100');
		return accounts;
	}

	@RemoteAction global static List<Contact> searchContacts(String contactSearchString, String selectedState) {
		List<Contact> contacts = new List<Contact>();
		if(selectedState!=null && selectedState!='') contacts = Database.query('Select Id, Name, MailingAddress__c from Contact where name like \'%' + String.escapeSingleQuotes(contactSearchString) + '%\' and (recordtype.name=\'HD Contacts\' or recordtype.name=\'HD Physicians\') and Status__c=\'Active\' and MailingState=\''+selectedState+'\' limit 100');
		else contacts = Database.query('Select Id, Name, MailingAddress__c, Title__c from Contact where name like \'%' + String.escapeSingleQuotes(contactSearchString) + '%\' and (recordtype.name=\'HD Contacts\' or recordtype.name=\'HD Physicians\') and Status__c=\'Active\' limit 100');
		return contacts;
	}

	@RemoteAction global static String getDischargeDisposition() {
		Id workspaceId;
		for(ContentWorkspace cw : [select Id from ContentWorkspace where Name = 'Sales Discharge Disposition']){
			workspaceId = cw.Id;
		}

		return resourceJSON(workspaceId);
	}

	@RemoteAction global static String getReports() {
		return JSON.serializePretty([select Id, Name FROM Report where FolderName='HD Redesign Reports' order by Name asc]);
	}

	private static String resourceJSON(Id workspaceId){
		Id dischargeId;
		for(ContentVersion cv : [select Title, Id, Description, FileType from ContentVersion where IsLatest=true and ContentDocument.ParentId=:workspaceId order by LastModifiedDate desc limit 1]){
			dischargeId = cv.Id;
		}
		return dischargeId;
	}

	public static Set<ID> getParentRoleId(Set<ID> roleIds) {
		Set<ID> currentRoleIds = new Set<ID>();
		for(UserRole ur :[select Id, ParentRoleId from UserRole where Id in: roleIds]) {
			currentRoleIds.add(ur.ParentRoleId);
		}
		if(currentRoleIds.size() > 0) {
			currentRoleIds.addAll(getParentRoleId(currentRoleIds));
		}
		return currentRoleIds;
	}

}