public with sharing class AA_ReferralSourceAuditReporting{
  
  	private static final ID parentRole = [SELECT ID, Name FROM UserRole WHERE Name = 'KAH - Corporate'].Id;
  	private static final list<Profile> pList = [SELECT ID, Name FROM Profile];
  	
  	@AuraEnabled
  	public static list<string> getFirstRoles(){
  		list<String> roleList = new list<String>();
  		roleList.add('');
  		set<String> cleanSet = new set<String>();
  		for(UserRole userRole : [SELECT ID, Name FROM UserRole WHERE ParentRoleID =: parentRole]){
  			cleanSet.add(userRole.Name);
  			}
  		roleList.addAll(cleanSet);	
  		return roleList;
  		}
  		
  	@AuraEnabled
  	public static list<string> getSubRoleNames(String roleName){
  		list<String> roleList = new list<String>();
  		roleList.add('');
  		ID roleID;
  		try{
  			roleID = [SELECT ID FROM UserRole WHERE Name =: roleName].ID;
  			system.debug('RoleID: ' + roleID);
  			set<String> cleanSet = new set<String>();
  			for(UserRole userRole : [SELECT ID, Name FROM UserRole WHERE ParentRoleID =: roleID]){
  				cleanSet.add(userRole.Name);
  				}
  			roleList.addAll(cleanSet);
  			system.debug('roleList: ' + roleList);	
  			return roleList;
  			}
  		catch(Exception E){
        	system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
        	return null;
        	}	
  		}
  	
  	@AuraEnabled
    public static list<User> getUsersList(string searchString){
    	system.debug('searchString: ' + searchString);
    	list<string> profileList = new list<string>();
    	for(Profile p : pList){
    		if(p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			profileList.add(p.ID);
    			}
    		}
        
        list<User> usersList = new list<User>();
        
       	 	usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE isActive = true AND ProfileId IN: profileList AND (Name LIKE: searchString OR PERNER__c LIKE: searchString) ORDER BY LastName ASC];
        	if(usersList.size() < 1){
        		usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE isActive = true AND ProfileId IN: profileList AND (FirstName =: searchString OR LastName =: searchString) ORDER BY LastName ASC];
        		}
        	return usersList;	
        }
        
    @AuraEnabled
    public static list<User> getFirstUsersList(){
    	list<string> profileList = new list<string>();
        for(Profile p : pList){
    		if(p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			profileList.add(p.ID);
    			}
    		}
        
        list<User> usersList = new list<User>();
        usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE isActive = true AND ProfileId IN: profileList ORDER BY LastName ASC];
        return usersList;	
        }    
  		
  	@AuraEnabled
  	public static userWrapper getSelectedUser(string selectedUser){
        system.debug('selection: ' + selectedUser);
        
        try{
        string ln = selectedUser.substringBefore(',');
        string prnr = '';
        
        	prnr = selectedUser.substringAfterLast('-').deleteWhitespace();
        system.debug('LastName: ' + ln);
        
        try{
        	prnr = selectedUser.substringAfterLast('-').substring(4);
        	system.debug('Perner: ' + prnr);
        	Home_Facility__c hf = new Home_Facility__c();
        	hf = [SELECT Account__r.Shipping_Geolocation__c, Account__r.Latitude__c, Account__r.Longitude__c, User__r.ID, User__r.FirstName, User__r.LastName, User__r.PERNER__c, User__r.UserName, User__r.Line_of_Business__c, User__r.Title, User__r.Phone, User__r.UserRole.ID, User__r.UserRole.Name, Account__r.Name, Account__r.Facility_Number__c, Account__r.Type FROM Home_Facility__c WHERE User__r.LastName =: ln AND User__r.PERNER__c =: prnr];
        	userWrapper uw = new userWrapper(hf);
        	system.debug('Home Facility wrapper: ' + uw);
        	return uw;
        	}
        catch(Exception exc){
        	prnr = selectedUser.substringAfterLast('-').deleteWhitespace();
        	system.debug('Perner: ' + prnr);
        	User u = new User();
        	u = [SELECT ID, FirstName, LastName, UserName, Line_of_Business__c, Title, Phone, UserRole.ID, UserRole.Name, PERNER__c FROM User WHERE LastName =: ln AND Perner__c =: prnr];
        	userWrapper uw = new userWrapper(u);
        	system.debug('User wrapper: ' + uw);
        	return uw;
        	}	
        }
        catch(Exception E){
        	system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
        	}
        }
        
    public class userWrapper{
        @AuraEnabled 
        public string uID   {get;set;}
        @AuraEnabled 
        public string location  {get;set;}
        @AuraEnabled 
        public string roleName {get;set;}
        @AuraEnabled 
        public string roleID    {get;set;} 
        @AuraEnabled 
        public string firstName {get;set;}
        @AuraEnabled 
        public string lastName  {get;set;}
        @AuraEnabled 
        public string perner    {get;set;}
        @AuraEnabled 
        public string lineOfBusiness    {get;set;}
        @AuraEnabled 
        public string userName  {get;set;}
        @AuraEnabled 
        public string title {get;set;}
        @AuraEnabled 
        public string phone     {get;set;}
        @AuraEnabled 
        public string accName   {get;set;}
        @AuraEnabled 
        public string facilityNumber    {get;set;}
        @AuraEnabled 
        public string accType   {get;set;}
        @AuraEnabled 
        public User selectedUser    {get;set;}
        
        public userWrapper(Home_Facility__c hf){
            location = hf.Account__r.Shipping_Geolocation__c.getLatitude() + ', ' + hf.Account__r.Shipping_Geolocation__c.getLongitude(); 
            uID = hf.User__r.ID; 
            firstName = hf.User__r.FirstName; 
            lastName = hf.User__r.LastName; 
            perner = hf.User__r.PERNER__c; 
            userName = hf.User__r.UserName; 
            lineOfBusiness = hf.User__r.Line_of_Business__c; 
            title = hf.User__r.Title; 
            phone = hf.User__r.Phone; 
            roleID = hf.User__r.UserRole.ID; 
            roleName = hf.User__r.UserRole.Name; 
            accName = hf.Account__r.Name; 
            facilityNumber = hf.Account__r.Facility_Number__c; 
            accType = hf.Account__r.Type;   
            selectedUser = hf.User__r;
            }
            
        public userWrapper(User u){
            location = null;
            uID = u.ID; 
            firstName = u.FirstName; 
            lastName = u.LastName; 
            perner = u.PERNER__c; 
            userName = u.UserName; 
            lineOfBusiness = u.Line_of_Business__c; 
            title = u.Title; 
            phone = u.Phone; 
            roleID = u.UserRole.ID; 
            roleName = u.UserRole.Name; 
            selectedUser = u;
            }    
        }    	
  		
  	@AuraEnabled	
  	public static list<reportWrapper> getReport(String roleName, string selDteFrom, string selDteTo, string selectedUser, string sortField, boolean isAsc, string accountFilter, string contactFilter, string unityFilter, string horizonFilter, ID sfIDFilter){
  		try{
  			system.debug('sortField: ' + sortField);
  			system.debug('isAsc: ' + isAsc);
  			list<reportWrapper> rw = new list<reportWrapper>();
  			ID roleID;
  			ID uID;
  				if(selectedUser == null){
  					roleID = [SELECT ID FROM UserRole WHERE Name =: roleName].ID;
  				}
  			system.debug('roleID: ' + roleID);	
  			list<Referral_Source_Audit__c> rsLst = new list<Referral_Source_Audit__c>();
  			list<Referral_Source_Audit__c> addLst;
  			list<Referral_Source_Audit__c> delLst;
  			list<ID> userIDs = new list<ID>();
  			list<User> uLst = new list<User>();
  			string queryString = '';
  			string dtToStr;
            string dtFromStr;
            system.debug('SelDteFrom' + selDteFrom);
            system.debug('SelDteTo' + selDteTo);
            if(!string.isBlank(SelDteFrom)){
                  Datetime dteFromFrmt = dateTime.NewInstance(date.valueOf(SelDteFrom), Time.newInstance(0,0,0,0));
                  dtFromStr = dteFromFrmt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                  system.debug('dtFrom: ' + dtFromStr);
                  }
                
                if(!string.isBlank(SelDteTo)){
                  Datetime dteToFrmt = dateTime.NewInstance(date.valueOf(SelDteTo), Time.newInstance(0,0,0,0));
                  dtToStr = dteToFrmt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                  system.debug('dteTo: ' + dtToStr);
                  }
                  
  			system.debug('selectedUser: ' + selectedUser);
  			system.debug('SELECTED USER EMPTY? ' + string.isBlank(selectedUser));	
  			if(string.isBlank(selectedUser) == true){
  				uLst = [SELECT ID, Name FROM User WHERE UserRoleId =: roleID];
  				for(User un : uLst){
  					userIDs.add(un.ID);
  					}
  				system.debug('userIDs 1: ' + userIDs);		
  				queryString = 'SELECT Name, ID, Account__c, Account__r.Name, Account__r.Id, Contact__c, Contact__r.Name, Contact__r.Id, Effective_Date__c, EST__c, Horizon_ID__c, Status__c, Unity_ID__c, User__c, User__r.ID FROM Referral_Source_Audit__c WHERE User__r.ID IN: userIDs';
  				}
  			else if(string.isBlank(selectedUser) == false){
  				userWrapper uu = getSelectedUser(selectedUser);
  				system.debug('UserWrapper: ' + uu);
  				system.debug('User ID: ' + uu.uID);
  				uID = uu.uID;
  				uLst = [SELECT ID, Name FROM User WHERE ID =: uID];
  				for(User un : uLst){
  					userIDs.add(un.ID);
  					}
  				system.debug('userIDs 2: ' + userIDs);	
  				queryString = 'SELECT Name, ID, Account__c, Account__r.Name, Account__r.Id, Contact__c, Contact__r.Name, Contact__r.Id, Effective_Date__c, EST__c, Horizon_ID__c, Status__c, Unity_ID__c, User__c, User__r.ID FROM Referral_Source_Audit__c WHERE User__c =: uID';
  				}
  				
  			if(!string.isBlank(SelDteFrom) && !string.isBlank(SelDteTo)){
              	queryString = queryString + ' AND (CreatedDate >='+dtFromStr+' OR CreatedDate <='+dtToStr +')';
              	}
            else if (!string.isBlank(SelDteFrom) && string.isBlank(SelDteTo)){
              queryString = queryString + ' AND (CreatedDate >=' + dtFromStr + ')';
              }
            else if(string.isBlank(SelDteFrom) && !string.isBlank(SelDteTo)){
              queryString = queryString + ' AND (CreatedDate <=' + dtToStr + ')';
              }
            else if(string.isBlank(SelDteFrom) && string.isBlank(SelDteTo) && string.isBlank(selectedUser) == true){
              queryString = queryString + ' AND (CreatedDate = THIS_MONTH)';
              }
            
            system.debug('AccountFilter: ' + accountFilter);
            system.debug('ContactFilter: ' + contactFilter);
            system.debug('UnityFilter: ' + unityFilter);
            system.debug('SFIDFilter: ' + sfIDFilter);
            
            string aFilter;
            string cFilter;
            string uFilter;
            string hFilter;
            string sfFilter;
            
            if(accountFilter != null){
            	aFilter = String.escapeSingleQuotes(accountFilter);
            	}
            if(contactFilter != null){	
            	cFilter = String.escapeSingleQuotes(contactFilter);
            	}
            if(unityFilter != null){
            	uFilter = String.escapeSingleQuotes(unityFilter);	
            	}	
            if(horizonFilter != null){
            	hFilter = String.escapeSingleQuotes(horizonFilter);
            	}
            if(sfIDFilter != null){	
            	sfFilter = String.escapeSingleQuotes(sfIDFilter);
            	}
            
            if(!string.isBlank(accountFilter)){
            	queryString = queryString + ' AND Account__r.Name LIKE: aFilter';
            	}
            
            if(!string.isBlank(contactFilter)){
            	queryString = queryString + ' AND Contact__r.Name LIKE: cFilter';
            	}
            	
            if(!string.isBlank(unityFilter)){
            	queryString = queryString + ' AND Unity_ID__c =: uFilter';
            	}
            
            if(!string.isBlank(horizonFilter)){
            	queryString = queryString + ' AND Horizon_ID__c =: hFilter';
            	}
            	
            if(!string.isBlank(sfIDFilter)){
            	queryString = queryString + ' AND (Account__r.ID =: sfIDFilter OR Contact__r.ID =: sfFilter)';
            	}			
              	
            if(!string.isBlank(sortField)){
            	string sortDir = '';
            	if(isAsc == true){
            		sortDir = ' ASC';
            		}
            	else if(isAsc == false){
            		sortDir = ' DESC';
            		}	
            	queryString = queryString + ' Order By ' + sortField + sortDir + ' NULLS LAST';
            	}			
  			system.debug('Query String: ' + queryString);  
        	rsLst = database.Query(queryString);      	
  			system.debug('rsLst: ' + rsLst);
  			system.debug('uLst: ' + uLst);
  						
  			for(User u: uLst){
  				addLst = new list<Referral_Source_Audit__c>();
  				delLst = new list<Referral_Source_Audit__c>();
  				for(Referral_Source_Audit__c rsa : rsLst){
  					if(rsa.User__r.ID == u.ID){
  						if(rsa.Status__c == 'Added'){
  							addLst.add(rsa);
  							}
  						if(rsa.Status__c == 'Deleted'){
  							delLst.add(rsa);
  							}	
  						}									   	   	
  					}
  				if(addLst.size() > 0 || delLst.size() > 0){
  					rw.add(new reportWrapper(u, addLst, delLst));
  					}
  			}
  			system.debug('Report Wrapper: ' + rw);
  				return rw;
  				}
  			catch(Exception E){
  				system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
  				return null;
  				}	
  		}
  		
  	public class reportWrapper{
  		@AuraEnabled
  		public User user 	{get;set;}
  		@AuraEnabled
  		public list<Referral_Source_Audit__c> addLst	{get;set;}
  		@AuraEnabled
  		public list<Referral_Source_Audit__c> delLst	{get;set;}
  		
  		public reportWrapper(User u, list<Referral_Source_Audit__c> addLst, list<Referral_Source_Audit__c> delLst){
  			this.user = u;
  			this.addLst = addLst;
  			this.delLst = delLst;
  			}
  		
  		}			
    
}