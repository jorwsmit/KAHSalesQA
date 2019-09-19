global without sharing class AA_AssociateDataManagementController {
    
    //list to store the records types of Accounts to be shown
    global static list<RecordType> lstAccountRecordType = [ SELECT Id, Name, Description, DeveloperName, IsActive 
                                                            FROM RecordType
                                                            WHERE sobjecttype='Account' AND 
                                                                  (DeveloperName='Referring_Facility_Parent' OR 
                                                                  DeveloperName='Referring_Facility_Child' OR DeveloperName = 'Center')];
 
    global static list<RecordType> lstAccountRecordTypeforSourceFilter = [ SELECT Id, Name, Description, DeveloperName, IsActive 
                                                            FROM RecordType
                                                            WHERE sobjecttype='Account' AND 
                                                                  (DeveloperName='Center' OR 
                                                                  DeveloperName='Referring_Facility_Child')];                                                              
                                                                  
    //list to store the records types of Contacts to be shown
    global static list<RecordType> lstContactRecordType = [ SELECT Id 
                                                            FROM RecordType
                                                            WHERE sobjecttype = 'Contact' AND 
                                                                    DeveloperName='General_Contact'];
    
    private static list<Profile> proList = [SELECT ID, Name FROM Profile WHERE (Name = 'Sales: KAH Manager' OR Name = 'Sales: KAH Market Manager' OR Name = 'Sales - KAH Admin' OR Name = 'System Administrator' OR Name = 'SysAdmin - No Lightning' OR Name = 'Sales: KAH Associate')];
    
    //Holds logged in UserID
    global static string loggedInProfileID  {get;set;}
    
    @AuraEnabled(cacheable=true) 
    public static User getLoggedInUser(){
        User loggedInUser = new User();
        loggedInUser = [SELECT ID, LastName, FirstName, Line_of_Business__c, PERNER__c, ProfileId FROM User WHERE ID = :UserInfo.getUserId()];
        system.debug('loggedInUser: ' + loggedInUser);
        loggedInProfileID = loggedInUser.ProfileId;
        system.debug('loggedInProfile: ' + loggedInProfileID);
        return loggedInUser;
        }
        
    @AuraEnabled(cacheable=true) 
    public static permissionWrapper getPermissions(){
      User loggedInUser = new User();
      loggedInUser = [SELECT ID, LastName, FirstName, Line_of_Business__c, PERNER__c, ProfileId FROM User WHERE ID = :UserInfo.getUserId()];
        system.debug('Permissions Logged In User: ' + loggedInUser);
        string ID = loggedInUser.profileId;
        system.debug('Profile ID: ' + ID);
        S2_custom_permissions__c userPermissions = [SELECT Name, Org_Alignment__c, Remove_All_User_Assignments__c, Profile_Description__c, Reassign_Referral_Sources__c, S2_Available__c, Target_Assignment_Available__c, Referral_Access__c, User_Create__c, User_Request__c FROM S2_custom_permissions__c WHERE Name =: ID];
        system.debug('User Permissions: ' + userPermissions);
        permissionWrapper pw = new PermissionWrapper(userPermissions);
        system.debug('Permission Wrapper: ' + pw);
        return pw;  
        }
        
    public class permissionWrapper{
      @AuraEnabled
      public boolean reassign  {get;set;}
      @AuraEnabled
      public boolean s2Available  {get;set;}
      @AuraEnabled
      public boolean targetAvailable  {get;set;}
      @AuraEnabled
      public boolean referral  {get;set;}
      @AuraEnabled
      public boolean userCreate  {get;set;}
      @AuraEnabled
      public boolean userRequest  {get;set;}
      @AuraEnabled
      public boolean orgAlignment  {get;set;}
      @AuraEnabled
      public boolean isSalesRep  {get;set;}
      @AuraEnabled
      public boolean canRemoveAll  {get;set;}
      
      public permissionWrapper(S2_custom_permissions__c userPermissions){
        list<string> nonRepList = new list<string>();
        system.debug('ProfileList: ' + proList);
        for(Profile p: proList){
        	if(p.Name == 'System Administrator' || p.Name == 'SysAdmin - No Lightning' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager' || p.Name == 'Sales - KAH Admin'){
        		nonRepList.add(p.ID);
        		}
        	}
        system.debug('nonRepList: ' + nonRepList);
        this.reassign = userPermissions.Reassign_Referral_Sources__c;
        this.s2Available = userPermissions.S2_Available__c;
        this.targetAvailable = userPermissions.Target_Assignment_Available__c;
        this.referral = userPermissions.Referral_Access__c;
        this.userCreate = userPermissions.User_Create__c;
        this.userRequest = userPermissions.User_Request__c;
        this.orgAlignment = userPermissions.Org_Alignment__c;
        this.canRemoveAll = userPermissions.Remove_All_User_Assignments__c;
        system.debug('userPermissions.Name: ' + userPermissions.Name);
        if(nonRepList.contains(userPermissions.Name)){
          this.isSalesRep = false;
          }
        else{
          this.isSalesRep = true;
          }  
        }
      }    
    
    //Get source list options
    @AuraEnabled(cacheable=true) 
    public static list<string> getSourceList(){
        list<String> lstSourceSystemOptions = new list<string>();
        lstSourceSystemOptions.add('All');
        lstSourceSystemOptions.add('Horizon');
        lstSourceSystemOptions.add('Unity');
        lstSourceSystemOptions.add('HCHB HH');
        lstSourceSystemOptions.add('HCHB HP');
        return lstSourceSystemOptions;
        }
    
    //Get Distance list options
    @AuraEnabled(cacheable=true) 
    public static list<string> getDistanceList(){
        list<String> lstDistanceOptions = new list<string>();
        lstDistanceOptions.add('Currently Assigned');
        lstDistanceOptions.add('All');
        //NEED TO FIX APEX BIND ISSUE FOR DISTANCE FILTER
        //lstDistanceOptions.add('All within 50 miles');
        //lstDistanceOptions.add('All within 100 miles');
        return lstDistanceOptions;
        }
    
    //Get list of available status options
    @AuraEnabled(cacheable=true) 
    public static list<string> getStatusList(){
        list<String> lstDistanceSubOptions = new list<string>();
        lstDistanceSubOptions.add('All');
        lstDistanceSubOptions.add('Customer');
        lstDistanceSubOptions.add('Prospect');
        return lstDistanceSubOptions;
        }
        
    //Get list of available state options
    @AuraEnabled(cacheable=true) 
    public static list<string> getStateList(){
        list<string> lstStates = new list<string>();
        lstStates.add('None');
        for(States__c objState : [SELECT Id, Name FROM States__c Order BY Name]) {
            lstStates.add(objState.Name);
            }
        return lstStates;
        }
        
    /**
    Submit change in details to update user details made on the page.
    **/
    @AuraEnabled 
    public static userWrapper getUpdatedInfo(User selectedUser, string selectedAccount, string lineOfBusiness, string title, string phone){
        try{
            system.debug('selectedUser: ' + selectedUser);
            User updatedUser = new User();
            string accountTemp = selectedAccount;
            string accountID = accountTemp.substringAfterLast('-').trim().right(18);
            system.debug('accountID: ' + accountID);
            string tempPhone = phone;
            system.debug('tempPhone: ' + tempPhone);
            string tempTitle = title;
            system.debug('tempTitle: ' + tempTitle);
            Account a = new Account();
            a = [SELECT ID, Name, Facility_Number__c FROM Account WHERE ID =: accountID];
          	string accId = a.ID;
          	system.debug('Selected Account: ' + accId);
          
            updatedUser = [SELECT ID, Profile.UserLicense.Name, Line_of_Business__c, Title, Phone FROM User WHERE ID =: selectedUser.ID];
            
            if(tempPhone != null){
                updatedUser.Phone = phone;
                }
                
            if(tempTitle != null){
                updatedUser.Title = title;
                }   
            
            if(updatedUser.Profile.UserLicense.Name == 'Chatter Free' && selectedUser.UserRoleId != null){
                updatedUser.UserRoleId = null;
                }
            if(updatedUser.Line_of_Business__c != lineOfBusiness){
                updatedUser.Line_of_Business__c = lineOfBusiness;
                } 
            
            update updatedUser;
            
            list<Home_Facility__c> lstHomeFacility = new list<Home_Facility__c>();
            lstHomeFacility = [SELECT ID, Account__c FROM Home_Facility__c WHERE User__c = :selectedUser.ID limit 1];
            system.debug('UpdatedUser ID: ' + updatedUser.ID);
            //creating the HomeFacility for User if not there and updating the Homefacilty if already present
            if(accountID != '' && accountID != null){
                if(lstHomeFacility.isEmpty()){
                    Home_Facility__c objFacility = new Home_Facility__c(User__c = updatedUser.ID,  Account__c = accId); 
                    insert objFacility;
                    }
                else{
                    Home_Facility__c objFacility = new Home_Facility__c(Id = lstHomeFacility[0].Id,  Account__c = accId); 
                    update objFacility;
                    }
                }
            
            return new userWrapper(updatedUser); 
            }
        catch(exception e){
             system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
             if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                system.debug('Error Validation: ' + e.getMessage().split(',')[1].Substring(0,e.getMessage().split(',')[1].length()-4));
                }
            else{
                system.debug('Error Alternate: ' + e.getMessage());
                }
                return null;
            }
        } 
    
    //Generate current active account list to select from.
    @AuraEnabled(cacheable=true) 
    public static List<Account> getAccountList() {
        List<Account> lstAccountsToReturn = new List<Account>();
        list<RecordType> lstRecordType = new list<RecordType>();
        lstRecordType = [   select Id, Name, Description, DeveloperName, IsActive 
                            from RecordType
                            where sobjecttype='Account' AND 
                                  DeveloperName='Center'];
        lstAccountsToReturn = [Select Name, Facility_Number__c, Type
                            From Account
                            WHERE Account.recordtypeid IN: lstRecordType
                            AND Status__c =:'Active'
                            AND Parent.Name =:'Kindred Healthcare Inc'
                            Order By Name];
        
        return lstAccountsToReturn;    
        }
        
    //Generate current active account list to select from.
    @AuraEnabled(cacheable=true) 
    public static List<Account> filterAccountList(string facilityListFilter) {
        List<Account> lstAccountsToReturn = new List<Account>();
        list<RecordType> lstRecordType = new list<RecordType>();
        lstRecordType = [SELECT Id, Name, Description, DeveloperName, IsActive 
                         FROM RecordType
                         WHERE sobjecttype='Account'
                         AND DeveloperName='Center'];
                                  
        lstAccountsToReturn = [SELECT Name, Facility_Number__c, Type
                               FROM Account
                               WHERE Account.recordtypeid IN: lstRecordType
                               AND Status__c =:'Active'
                               AND Parent.Name =:'Kindred Healthcare Inc'
                               AND (Name LIKE: facilityListFilter OR Facility_Number__c LIKE: facilityListFilter) 
                               Order By Name];
            if(lstAccountsToReturn.size() < 1){
                lstAccountsToReturn = [SELECT Name, Facility_Number__c, Type
                               FROM Account
                               WHERE Account.recordtypeid IN: lstRecordType
                               AND Status__c =:'Active'
                               AND Parent.Name =:'Kindred Healthcare Inc'
                               AND (Name =: facilityListFilter OR Facility_Number__c =: facilityListFilter) 
                               Order By Name];
                }
        
        return lstAccountsToReturn;    
        }    
        
    @AuraEnabled(cacheable=true) 
    public static list<TeamMembers> getTeamAssigned(ID itemID){
        list<TeamMembers> teamMembers = new list<TeamMembers>();
        for(AccountTeamMember atm: [SELECT ID, User.Name, User.ID, User.Title FROM AccountTeamMember WHERE AccountID =: itemID]){
            teamMembers.add(new TeamMembers(atm.User.Name, atm.User.ID, atm.User.Title));
            }
        for(Contact_Team__c ctcs: [SELECT ID, User__r.Name, User__r.ID, User__r.Title, CreatedDate FROM Contact_Team__c WHERE Contact__c =: itemID]){
            teamMembers.add(new TeamMembers(ctcs.User__r.Name, ctcs.User__r.ID, ctcs.User__r.Title));
            }
        return teamMembers;
        }
        
    public class TeamMembers{
      @AuraEnabled
      public string name  {get;set;}
      @AuraEnabled
      public ID personID  {get;set;}
      
      public TeamMembers(String name, ID personID, string title){
        this.name = name + ' - ' + title;
        this.personID = personID;
        }
      }     
    
    //Gen up the lines of business options to select from.
    @AuraEnabled(cacheable=true) 
    public static List<String> getBusinessList() {
        List<String> businessList = new List<String>();
        businessList.add('HD');
        businessList.add('NCD');
        businessList.add('KHRS - ARU');
        businessList.add('KHRS - IRF');
        businessList.add('KHRS - OP');
        businessList.add('HH');
        businessList.add('HP');
        businessList.add('HH/HP');
        return businessList;   
        }
    
    //Gen up the options to select from for object type.
    @AuraEnabled(cacheable=true) 
    public static List<String> getTypeList() {
        List<String> typeList = new List<String>();
        typeList.add('All');
        typeList.add('Account');
        typeList.add('Contact');
        return typeList;   
        }
    
    //Gen initial user selection list for consumption
    @AuraEnabled(cacheable=true) 
    public static list<User> getUsersList(){
        list<string> profileList = new list<string>();
        
        for(Profile p : proList){
        	if(p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager' || p.Name == 'Sales: KAH Associate'){
        		profileList.add(p.Id);
        		}
        	}
        
        list<User> usersList = new list<User>();
        usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE isActive = true AND ProfileId IN: profileList ORDER BY LastName ASC];
        return usersList;
        }
        
    //Gen initial user selection list for consumption
    @AuraEnabled(cacheable=true) 
    public static list<User> getUsersList2(){
        list<string> profileList = new list<string>();
        list<string> profileName = new list<string>();
        
        for(Profile p : proList){
        	if(p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager' || p.Name == 'Sales: KAH Associate'){
        		profileList.add(p.Id);
        		profileName.add(p.Name);
        		}
        	}
        
        list<User> usersList = new list<User>();
        usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE (isActive = true AND ProfileId IN: profileList) OR (isActive = false AND Previous_Profile__c IN: profileName) ORDER BY LastName ASC];
        return usersList;
        }    
        
    @AuraEnabled(cacheable=true) 
    public static list<User> filterUserList(string nameListFilter){
        list<string> profileList = new list<string>();
        string s = String.escapeSingleQuotes(nameListFilter);
        for(Profile p : proList){
        	if(p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager' || p.Name == 'Sales: KAH Associate'){
        		profileList.add(p.Id);
        		}
        	}
        
        list<User> usersList = new list<User>();
        usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE isActive = true AND ProfileId IN: profileList AND (Name LIKE: s OR PERNER__c LIKE: s) ORDER BY LastName ASC];
            if(usersList.size() < 1){
                usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE isActive = true AND ProfileId IN: profileList AND (FirstName =: s OR LastName =: s) ORDER BY LastName ASC];
                }
            return usersList;
        }
        
    @AuraEnabled(cacheable=true) 
    public static list<User> filterUserList2(string nameListFilter2){
        list<string> profileList = new list<string>();
        list<string> profileName = new list<string>();
        String s = String.escapeSingleQuotes(nameListFilter2);
        for(Profile p : proList){
        	if(p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager' || p.Name == 'Sales: KAH Associate'){
        		profileList.add(p.Id);
        		profileName.add(p.Name);
        		}
        	}
        
        	list<User> usersList = new list<User>();
        	usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE (isActive = true AND ProfileId IN: profileList AND (Name LIKE: s OR PERNER__c LIKE: s)) OR (isActive = false AND Previous_Profile__c IN: profileName AND (Name LIKE: s OR PERNER__c LIKE: s)) ORDER BY LastName ASC];
        	if(usersList.size() < 1){
                usersList = [SELECT PERNER__c, FirstName, LastName, Line_of_Business__c FROM User WHERE (isActive = true AND ProfileId IN: profileList AND (FirstName =: s OR LastName=: s OR PERNER__c =: s)) OR (isActive = false AND Previous_Profile__c IN: profileName AND (FirstName =: s OR LastName=: s OR PERNER__c =: s)) ORDER BY LastName ASC];
                }
            return usersList;
        }        
    
    //Get detailed information for user when selected from usersList
    @AuraEnabled(cacheable=true) 
    public static userWrapper getSelectedUser(string selectedUser, boolean isSalesRep){
        system.debug('selection: ' + selectedUser);
        system.debug('isSalesRep: ' + isSalesRep);
        try{
        string ln = selectedUser.substringBefore(',');
        string prnr = '';
        if(isSalesRep == false){
          prnr = selectedUser.substringAfterLast('-').substring(4);
          }
        else{
          prnr = selectedUser.substringAfterLast('-').deleteWhitespace();
          }  
        system.debug('LastName: ' + ln);
        system.debug('Perner: ' + prnr);
        try{
          Home_Facility__c hf = new Home_Facility__c();
          hf = [SELECT Account__r.Shipping_Geolocation__c, Account__r.Latitude__c, Account__r.Longitude__c, User__r.ID, User__r.FirstName, User__r.LastName, User__r.PERNER__c, User__r.UserName, User__r.Line_of_Business__c, User__r.Title, User__r.Phone, User__r.UserRole.ID, User__r.UserRole.Name, Account__r.Name, Account__r.Facility_Number__c, Account__r.Type, Account__r.Id FROM Home_Facility__c WHERE User__r.LastName =: ln AND User__r.PERNER__c =: prnr];
          system.debug('Home Facility: ' + hf);
          userWrapper uw = new userWrapper(hf);
          return uw;
          }
        catch(Exception exc){
          User u = new User();
          u = [SELECT ID, FirstName, LastName, UserName, Line_of_Business__c, Title, Phone, UserRole.ID, UserRole.Name, PERNER__c FROM User WHERE LastName =: ln AND Perner__c =: prnr];
          userWrapper uw = new userWrapper(u);
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
        public string accId   {get;set;}
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
            accId =    hf.Account__r.Id;
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
    
    //Called on selection of referral source tab to get the count of referrals assigned to selected user
    @AuraEnabled 
    public static integer getReferralSourceCount(User selectedUser){
        integer totalAssignments;
        system.debug('selectedUser: ' + selectedUser);
        string strSelectedUser = selectedUser.ID;
        try{
            //list to hold the count of AccountTeamMembers assigned for Selected User
            List<AggregateResult> lstATM = Database.query(  'Select COUNT_DISTINCT(Account.Id) countATMs '+
                                                            'From AccountTeamMember '+
                                                            'Where UserId =: strSelectedUser AND '+ 
                                                            'Account.Recordtypeid IN: lstAccountRecordType');
                                                            
            //list to hold the count of ContactTeamMembers assigned for Selected User
            List<AggregateResult> lstCTM = Database.query(  'Select COUNT_DISTINCT(Contact__r.Id) countCTMs '+
                                                            'From Contact_Team__c '+
                                                            'Where User__c =: strSelectedUser AND '+ 
                                                            'Contact__r.Recordtypeid IN: lstContactRecordType');
                                                            
            totalAssignments = Integer.valueOf(lstATM[0].get('countATMs')) + Integer.valueOf(lstCTM[0].get('countCTMs'));
            return totalAssignments;
            }
        catch(exception e){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
            }
        }
    
    
    @AuraEnabled
    public static string sortOrder  {get;set;}
    @AuraEnabled 
    public static string compareField   {get;set;}  
    
    //Wraps the Account and Contact team records for display an interaction on the interface    
    global class listWrapper{
        @AuraEnabled 
        public sObject atm  {get;set;}
        @AuraEnabled 
        public Boolean selected    {get;set;}
        @AuraEnabled 
        public integer teamCount    {get;set;}
        @AuraEnabled 
        public string itemID  {get;set;}
        @AuraEnabled 
        public string name  {get;set;} 
        @AuraEnabled 
        public string npi   {get;set;} 
        @AuraEnabled 
        public string shippingCity  {get;set;} 
        @AuraEnabled 
        public string shippingState {get;set;} 
        @AuraEnabled 
        public string shippingStreet    {get;set;} 
        @AuraEnabled 
        public string shippingPostalCode    {get;set;} 
        @AuraEnabled 
        public string accType   {get;set;} 
        @AuraEnabled 
        public decimal hhYTDRefer   {get;set;} 
        @AuraEnabled 
        public decimal hpYTDAdmit   {get;set;} 
        @AuraEnabled 
        public decimal hpYTDRefer   {get;set;} 
        @AuraEnabled 
        public decimal hpPYAdmit    {get;set;} 
        @AuraEnabled 
        public decimal hpQualPYAdmit    {get;set;} 
        @AuraEnabled 
        public decimal hhYTDAdmit   {get;set;} 
        @AuraEnabled 
        public decimal hhPYAdmit    {get;set;} 
        @AuraEnabled 
        public decimal hhPYPPSAdmit {get;set;} 
        @AuraEnabled 
        public decimal hdYTDAdmit   {get;set;} 
        @AuraEnabled 
        public decimal hdPYAdmit    {get;set;} 
        @AuraEnabled 
        public decimal hhYTDPPSAdmit    {get;set;} 
        @AuraEnabled 
        public decimal hhDiscQualYTDAdmit   {get;set;}
        @AuraEnabled 
        public decimal hhDiscQualPYAdmit   {get;set;} 
        @AuraEnabled 
        public decimal hpQualYTDAdmit   {get;set;}
        @AuraEnabled 
        public string hms   {get;set;}
        @AuraEnabled 
        public string hpas  {get;set;}
        @AuraEnabled 
        public string horizon   {get;set;}
        @AuraEnabled 
        public string meditech  {get;set;} 
        @AuraEnabled 
        public string unity {get;set;}
        @AuraEnabled 
        public decimal lengthOfStay {get;set;}
        @AuraEnabled 
        public string specialty {get;set;}
        @AuraEnabled 
        public string assignedTime {get;set;}
        @AuraEnabled 
        public string hchbhh {get;set;}
        @AuraEnabled 
        public string hchbhp {get;set;} 
        
    public listWrapper(AccountTeamMember a, boolean isSelected, integer teamCnt){
        atm = a;
        itemID = a.AccountID;
        teamCount = teamCnt;
        selected = isSelected;
        name = a.Account.Name;
        npi = a.Account.NPI__c;
        hms = a.Account.HMS_POID__c;
        hpas = a.Account.HPAS_ID__c;
        horizon = a.Account.Horizon_ID__c;
        meditech = a.Account.Meditech_ID__c;
        unity = a.Account.Unity_ID__c;
        shippingCity = a.Account.ShippingCity;
        shippingState = a.Account.ShippingState; 
        shippingStreet = a.Account.Shippingstreet;
        shippingPostalCode = a.Account.ShippingPostalCode;
        accType = 'Account'; 
        hhYTDRefer = a.Account.KAH_HH_Referrals_YTD__c;
        hpYTDAdmit = a.Account.KAH_HP_Admits_YTD__c;
        hpYTDRefer = a.Account.KAH_HP_Referrals_YTD__c;
        hpPYAdmit = a.Account.HP_Admits_PY__c;
        hpQualPYAdmit = a.Account.KAH_HP_Qualified_Admits_PY__c;
        hhYTDAdmit = a.Account.KAH_HH_Admits_YTD__c;
        hhPYAdmit = a.Account.HH_Admits_PY__c;
        hhPYPPSAdmit = a.Account.KAH_HH_PPS_Prior_Year_Admits_Prior__c;
        hdYTDAdmit = a.Account.KAH_HD_Admits_YTD__c;
        hdPYAdmit = a.Account.HD_Admits_PY__c;
        hhYTDPPSAdmit = a.Account.KAH_HH_PPS_Admits_YTD__c;
        hhDiscQualYTDAdmit = a.Account.KAH_HH_Discounted_Qualified_Admits_YTD__c;
        hhDiscQualPYAdmit = a.Account.KAH_HH_Discounted_Qualified_Admits_PY__c;
        hpQualYTDAdmit = a.Account.KAH_HP_Qualified_Admits_YTD__c;
        lengthOfStay = a.Account.KAH_Avg_LOS_Hospice_Only__c;
        hchbhh = a.Account.HCHB_HH_ID__c;
        hchbhp = a.Account.HCHB_HP_ID__c;
        try{
          assignedTime = a.CreatedDate.format('MM/dd/yyyy hh:mm a','America/New_York');
          }
        catch(Exception t){
          }  
        }
        
    public listWrapper(Account a, boolean isSelected, integer teamCnt){
        atm = a;
        itemID = a.ID;
        teamCount = teamCnt;
        selected = isSelected;
        name = a.Name;
        npi = a.NPI__c;
        hms = a.HMS_POID__c;
        hpas = a.HPAS_ID__c;
        horizon = a.Horizon_ID__c;
        meditech = a.Meditech_ID__c;
        unity = a.Unity_ID__c;
        shippingCity = a.ShippingCity;
        shippingState = a.ShippingState; 
        shippingStreet = a.Shippingstreet;
        shippingPostalCode = a.ShippingPostalCode;
        accType = 'Account'; 
        hhYTDRefer = a.KAH_HH_Referrals_YTD__c;
        hpYTDAdmit = a.KAH_HP_Admits_YTD__c;
        hpYTDRefer = a.KAH_HP_Referrals_YTD__c;
        hpPYAdmit = a.HP_Admits_PY__c;
        hpQualPYAdmit = a.KAH_HP_Qualified_Admits_PY__c;
        hhYTDAdmit = a.KAH_HH_Admits_YTD__c;
        hhPYAdmit = a.HH_Admits_PY__c;
        hhPYPPSAdmit = a.KAH_HH_PPS_Prior_Year_Admits_Prior__c;
        hdYTDAdmit = a.KAH_HD_Admits_YTD__c;
        hdPYAdmit = a.HD_Admits_PY__c;
        hhYTDPPSAdmit = a.KAH_HH_PPS_Admits_YTD__c;
        hhDiscQualYTDAdmit = a.KAH_HH_Discounted_Qualified_Admits_YTD__c;
        hhDiscQualPYAdmit = a.KAH_HH_Discounted_Qualified_Admits_PY__c;
        hpQualYTDAdmit = a.KAH_HP_Qualified_Admits_YTD__c;
        lengthOfStay = a.KAH_Avg_LOS_Hospice_Only__c;
        hchbhh = a.HCHB_HH_ID__c;
        hchbhp = a.HCHB_HP_ID__c;
        }    

    public listWrapper(Contact_Team__c c, boolean isSelected, integer teamCnt){
        atm = c;
        selected = isSelected;
        teamCount = teamCnt;
        itemID = c.Contact__r.ID;
        name = c.Contact__r.Name;
        npi = c.Contact__r.NPI__c;
        hms = c.Contact__r.HMS_PIID__c;
        hpas = c.Contact__r.HPAS_Contact_ID__c;
        horizon = c.Contact__r.Horizon_ID__c;
        meditech = c.Contact__r.Meditech_Contact_ID__c;
        unity = c.Contact__r.Unity_ID__c;
        shippingCity = c.Contact__r.MailingCity;
        shippingState = c.Contact__r.MailingState; 
        shippingStreet = c.Contact__r.MailingStreet;
        shippingPostalCode = c.Contact__r.MailingPostalCode;
        accType = 'Contact'; 
        hhYTDRefer = c.Contact__r.KAH_HH_Referrals_YTD__c;
        hpYTDAdmit = c.Contact__r.KAH_HP_Admits_YTD__c;
        hpYTDRefer = c.Contact__r.KAH_HP_Referrals_YTD__c;
        hpPYAdmit = c.Contact__r.HP_Admits_PY__c;
        hpQualPYAdmit = c.Contact__r.KAH_HP_Qualified_Admits_PY__c;
        hhYTDAdmit = c.Contact__r.KAH_HH_Admits_YTD__c;
        hhPYAdmit = c.Contact__r.HH_Admits_PY__c;
        hhPYPPSAdmit = c.Contact__r.KAH_HH_PPS_Prior_Year_Admits_Prior__c;
        hdYTDAdmit = c.Contact__r.KAH_HD_Admits_YTD__c;
        hdPYAdmit = c.Contact__r.HD_Admits_PY__c;
        hhYTDPPSAdmit = c.Contact__r.KAH_HH_PPS_Admits_YTD__c;
        hhDiscQualYTDAdmit = c.Contact__r.KAH_HH_Discounted_Qualified_Admits_YTD__c;
        hhDiscQualPYAdmit = c.Contact__r.KAH_HH_Discounted_Qualified_Admits_PY__c;
        hpQualYTDAdmit = c.Contact__r.KAH_HP_Qualified_Admits_YTD__c;
        lengthOfStay = c.Contact__r.KAH_HMS_HP_LOS__c;
        specialty = c.Contact__r.Specialties__c;
        hchbhh = c.Contact__r.HCHB_HH_ID__c;
        hchbhp = c.Contact__r.HCHB_HP_ID__c;
        try{
          assignedTime = c.CreatedDate.format('MM/dd/yyyy hh:mm a','America/New_York');
          }
        catch(Exception t){
          
          }  
        }
        
        public listWrapper(Contact c, boolean isSelected, integer teamCnt){
        atm = c;
        selected = isSelected;
        teamCount = teamCnt;
        itemID = c.ID;
        name = c.Name;
        npi = c.NPI__c;
        hms = c.HMS_PIID__c;
        hpas = c.HPAS_Contact_ID__c;
        horizon = c.Horizon_ID__c;
        meditech = c.Meditech_Contact_ID__c;
        unity = c.Unity_ID__c;
        shippingCity = c.MailingCity;
        shippingState = c.MailingState; 
        shippingStreet = c.MailingStreet;
        shippingPostalCode = c.MailingPostalCode;
        accType = 'Contact'; 
        hhYTDRefer = c.KAH_HH_Referrals_YTD__c;
        hpYTDAdmit = c.KAH_HP_Admits_YTD__c;
        hpYTDRefer = c.KAH_HP_Referrals_YTD__c;
        hpPYAdmit = c.HP_Admits_PY__c;
        hpQualPYAdmit = c.KAH_HP_Qualified_Admits_PY__c;
        hhYTDAdmit = c.KAH_HH_Admits_YTD__c;
        hhPYAdmit = c.HH_Admits_PY__c;
        hhPYPPSAdmit = c.KAH_HH_PPS_Prior_Year_Admits_Prior__c;
        hdYTDAdmit = c.KAH_HD_Admits_YTD__c;
        hdPYAdmit = c.HD_Admits_PY__c;
        hhYTDPPSAdmit = c.KAH_HH_PPS_Admits_YTD__c;
        hhDiscQualYTDAdmit = c.KAH_HH_Discounted_Qualified_Admits_YTD__c;
        hhDiscQualPYAdmit = c.KAH_HH_Discounted_Qualified_Admits_PY__c;
        hpQualYTDAdmit = c.KAH_HP_Qualified_Admits_YTD__c;
        lengthOfStay = c.KAH_HMS_HP_LOS__c;
        specialty = c.Specialties__c;
        hchbhh = c.HCHB_HH_ID__c;
        hchbhp = c.HCHB_HP_ID__c;
        }
        }
        
    @AuraEnabled(cacheable=true) 
    public static list<listWrapper> getReferralList(User selectedUser, list<string> filters, string sortField, string distanceFilter, string typeFilter, string isAsc, string location, string reqType){
        system.debug('reqType: ' + reqType);
        system.debug('filters: ' + filters);
        string andClauseAccount = '';
        string andClauseContact = '';
        string andClauseAccount2 = '';
        string andClauseContact2 = '';
        sortOrder = isAsc;
        compareField = sortField;
        string placeholder = ' AND ';
        string sourceFilter;
        string activeFilter;
        string stateFilter; 
        string nameFilter;
        string npiFilter;
        string hmsFilter;
        string sfIDFilter;
        string addressFilter;
        string cityFilter;
        string stFilter;
        string zipFilter;
        string specialtyFilter;
        string hhYTDAdmitFilter;
        string hhPYAdmitFilter;
        string hpYTDAdmitFilter;
        string hpPYAdmitFilter;
        string hhPPSYTDAdmitFilter;
        string hhPPSPYAdmitFilter;
        string hhYTDReferralFilter;
        string hhDiscQualAdmitYTDFilter;
        string hpQualifiedYTDAdmitFilter;
        string hpQualifiedPYAdmitFilter;
        string hpYTDReferralFilter;
        string hpLengthFilter;
        integer teamCount;
                
        system.debug('typeFilter: ' + typeFilter);
        list<AccountTeamMember> accCollectionLst = new list<AccountTeamMember>();
        list<Contact_Team__c> conCollectionLst = new list<Contact_Team__c>();
        set<listWrapper> cleanSet = new set<listWrapper>();
        list<listWrapper> displayList = new list<listWrapper>();
        set<ID> accIDSet = new set<ID>();
        set<ID> ctcIDSet = new set<ID>();
        set<ID> accAgrIDSet = new set<ID>();
        set<ID> ctcAgrIDSet = new set<ID>();
        set<ID> accIDSet2 = new set<ID>();
        set<ID> ctcIDSet2 = new set<ID>();
        set<ID> accAgrIDSet2 = new set<ID>();
        set<ID> ctcAgrIDSet2 = new set<ID>();
        string uId = selectedUser.ID;
        try{
          for(string s: filters){
            if(s.contains('sourceFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                sourceFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                if(sourceFilter.trim() == 'Horizon'){
                  andClauseAccount = andClauseAccount + placeholder + ' Account.Horizon_ID__c != null';
                  andClauseContact = andClauseContact + placeholder + ' Contact__r.Horizon_ID__c != null';
                  andClauseAccount2 = andClauseAccount2 + placeholder + ' Horizon_ID__c != null';
                  andClauseContact2 = andClauseContact2 + placeholder + ' Horizon_ID__c != null';
                  }  
                else if(sourceFilter.trim() == 'Unity'){
                  andClauseAccount = andClauseAccount + placeholder + ' Account.Unity_ID__c != null';
                  andClauseContact = andClauseContact + placeholder + ' Contact__r.Unity_ID__c != null';
                  andClauseAccount2 = andClauseAccount2 + placeholder + ' Unity_ID__c != null';
                  andClauseContact2 = andClauseContact2 + placeholder + ' Unity_ID__c != null';
                  }
                else if(sourceFilter.trim() == 'HCHB HH'){
                  andClauseAccount = andClauseAccount + placeholder + ' Account.HCHB_HH_ID__c != null';
                  andClauseContact = andClauseContact + placeholder + ' Contact__r.HCHB_HH_ID__c != null';
                  andClauseAccount2 = andClauseAccount2 + placeholder + ' HCHB_HH_ID__c != null';
                  andClauseContact2 = andClauseContact2 + placeholder + ' HCHB_HH_ID__c != null';
                  }
                else if(sourceFilter.trim() == 'HCHB HP'){
                  andClauseAccount = andClauseAccount + placeholder + ' Account.HCHB_HP_ID__c != null';
                  andClauseContact = andClauseContact + placeholder + ' Contact__r.HCHB_HP_ID__c != null';
                  andClauseAccount2 = andClauseAccount2 + placeholder + ' HCHB_HP_ID__c != null';
                  andClauseContact2 = andClauseContact2 + placeholder + ' HCHB_HP_ID__c != null';
                  }         
                }
            if(s.contains('activeFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'All' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                activeFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                if(activeFilter.trim() == 'Customer'){
                  andClauseAccount = andClauseAccount + placeholder + ' Account.Doing_business_with__c = true ';
                  andClauseContact = andClauseContact + placeholder + ' Contact__r.Doing_business_with__c = true';
                  andClauseAccount2 = andClauseAccount2 + placeholder + ' Doing_business_with__c = true ';
                  andClauseContact2 = andClauseContact2 + placeholder + ' Doing_business_with__c = true';
                  }
                else if(activeFilter.trim() == 'Prospect'){
                  andClauseAccount = andClauseAccount + placeholder + ' Account.Doing_business_with__c = false';
                  andClauseContact = andClauseContact + placeholder + ' Contact__r.Doing_business_with__c = false';
                  andClauseAccount2 = andClauseAccount2 + placeholder + ' Doing_business_with__c = false';
                  andClauseContact2 = andClauseContact2 + placeholder + ' Doing_business_with__c = false';
                  }  
                }
            if(s.contains('stateFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'None' && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                stateFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.ShippingState =: stateFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.MailingState =: stateFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' ShippingState =: stateFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' MailingState =: stateFilter';
                }
            if(s.contains('nameFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                nameFilter = '%' + String.escapeSingleQuotes(s.substringAfterLast(':')) + '%';
                andClauseAccount = andClauseAccount + placeholder + ' Account.Name LIKE: nameFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.Name LIKE: nameFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' Name LIKE: nameFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' Name LIKE: nameFilter';
                }
            if(s.contains('npiFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                npiFilter = String.escapeSingleQuotes(s.substringAfterLast(':').trim());
                andClauseAccount = andClauseAccount + placeholder + ' Account.NPI__c =: npiFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.NPI__c =: npiFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' NPI__c =: npiFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' NPI__c =: npiFilter';
                }
            if(s.contains('addressFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                addressFilter = '%' + String.escapeSingleQuotes(s.substringAfterLast(':')) + '%';
                andClauseAccount = andClauseAccount + placeholder + ' Account.ShippingStreet LIKE: addressFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.MailingStreet LIKE: addressFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' ShippingStreet LIKE: addressFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' MailingStreet LIKE: addressFilter';
                }
            if(s.contains('cityFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                cityFilter = '%' + String.escapeSingleQuotes(s.substringAfterLast(':')) + '%';
                andClauseAccount = andClauseAccount + placeholder + ' Account.ShippingCity LIKE: cityFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.MailingCity LIKE: cityFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' ShippingCity LIKE: cityFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' MailingCity LIKE: cityFilter';
                }
            if(s.contains('stFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                stFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.ShippingState =: stFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.MailingState =: stFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' ShippingState =: stFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' MailingState =: stFilter';
                }
            if(s.contains('zipFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                zipFilter = '%' + String.escapeSingleQuotes(s.substringAfterLast(':')) + '%';
                andClauseAccount = andClauseAccount + placeholder + ' Account.ShippingPostalCode LIKE: zipFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.MailingPostalCode LIKE: zipFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' ShippingPostalCode LIKE: zipFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' MailingPostalCode LIKE: zipFilter';
                }
            if(s.contains('specialtyFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                specialtyFilter = '%' + String.escapeSingleQuotes(s.substringAfterLast(':')) + '%';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.Specialties__c LIKE: specialtyFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' Specialties__c LIKE: specialtyFilter';
                }
            if(s.contains('hhYTDAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hhYTDAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HH_Admits_YTD__c =: hhYTDAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HH_Admits_YTD__c =: hhYTDAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HH_Admits_YTD__c =: hhYTDAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HH_Admits_YTD__c =: hhYTDAdmitFilter';
                }
            if(s.contains('hhPYAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hhPYAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.HH_Admits_PY__c =: hhPYAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.HH_Admits_PY__c =: hhPYAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' HH_Admits_PY__c =: hhPYAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' HH_Admits_PY__c =: hhPYAdmitFilter';
                }
            if(s.contains('hpYTDAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hpYTDAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HP_Admits_YTD__c =: hpYTDAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HP_Admits_YTD__c =: hpYTDAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HP_Admits_YTD__c =: hpYTDAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HP_Admits_YTD__c =: hpYTDAdmitFilter';
                }
            if(s.contains('hpPYAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hpPYAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.HP_Admits_PY__c =: hpPYAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.HP_Admits_PY__c =: hpPYAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' HP_Admits_PY__c =: hpPYAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' HP_Admits_PY__c =: hpPYAdmitFilter';
                }
            if(s.contains('hhPPSYTDAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hhPPSYTDAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HH_PPS_Admits_YTD__c =: hhPPSYTDAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HH_PPS_Admits_YTD__c =: hhPPSYTDAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HH_PPS_Admits_YTD__c =: hhPPSYTDAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HH_PPS_Admits_YTD__c =: hhPPSYTDAdmitFilter';
                }
            if(s.contains('hhPPSPYAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hhPPSPYAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HH_PPS_Prior_Year_Admits_Prior__c =: hhPPSPYAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HH_PPS_Prior_Year_Admits_Prior__c =: hhPPSPYAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HH_PPS_Prior_Year_Admits_Prior__c =: hhPPSPYAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HH_PPS_Prior_Year_Admits_Prior__c =: hhPPSPYAdmitFilter';
                }
            if(s.contains('hhYTDReferralFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hhYTDReferralFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HH_Referrals_YTD__c =: hhYTDReferralFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HH_Referrals_YTD__c =: hhYTDReferralFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HH_Referrals_YTD__c =: hhYTDReferralFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HH_Referrals_YTD__c =: hhYTDReferralFilter';
                }
            if(s.contains('hhDiscQualAdmitYTDFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hhDiscQualAdmitYTDFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HH_Discounted_Qualified_Admits_YTD__c =: hhDiscQualAdmitYTDFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HH_Discounted_Qualified_Admits_YTD__c =: hhDiscQualAdmitYTDFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HH_Discounted_Qualified_Admits_YTD__c =: hhDiscQualAdmitYTDFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HH_Discounted_Qualified_Admits_YTD__c =: hhDiscQualAdmitYTDFilter';
                }
            if(s.contains('hpQualifiedYTDAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hpQualifiedYTDAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HP_Qualified_Admits_YTD__c =: hpQualifiedYTDAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HP_Qualified_Admits_YTD__c =: hpQualifiedYTDAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HP_Qualified_Admits_YTD__c =: hpQualifiedYTDAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HP_Qualified_Admits_YTD__c =: hpQualifiedYTDAdmitFilter';
                }
            if(s.contains('hpQualifiedPYAdmitFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hpQualifiedPYAdmitFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HP_Qualified_Admits_PY__c =: hpQualifiedPYAdmitFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HP_Qualified_Admits_PY__c =: hpQualifiedPYAdmitFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HP_Qualified_Admits_PY__c =: hpQualifiedPYAdmitFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HP_Qualified_Admits_PY__c =: hpQualifiedPYAdmitFilter';
                }
            if(s.contains('hpYTDReferralFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hpYTDReferralFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_HP_Referrals_YTD__c =: hpYTDReferralFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_HP_Referrals_YTD__c =: hpYTDReferralFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_HP_Referrals_YTD__c =: hpYTDReferralFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_HP_Referrals_YTD__c =: hpYTDReferralFilter';
                }
            if(s.contains('hpLengthFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hpLengthFilter = String.escapeSingleQuotes(s.substringAfterLast(':'));
                andClauseAccount = andClauseAccount + placeholder + ' Account.KAH_Avg_LOS_Hospice_Only__c =: hpLengthFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.KAH_Avg_LOS_Hospice_Only__c =: hpLengthFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' KAH_Avg_LOS_Hospice_Only__c =: hpLengthFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' KAH_Avg_LOS_Hospice_Only__c =: hpLengthFilter';
                }
            if(s.contains('sfIDFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                sfIDFilter = String.escapeSingleQuotes(s.substringAfterLast(':').trim());
                andClauseAccount = andClauseAccount + placeholder + ' Account.ID =: sfIDFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.ID =: sfIDFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' ID =: sfIDFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' ID =: sfIDFilter';
                }
            if(s.contains('hmsFilter:') && !s.substringAfterLast(':').isWhitespace() && s.substringAfterLast(':') != 'undefined' && s.substringAfterLast(':') != 'null'){
                hmsFilter = String.escapeSingleQuotes(s.substringAfterLast(':').trim());
                andClauseAccount = andClauseAccount + placeholder + ' Account.HMS_POID__c =: hmsFilter';
                andClauseContact = andClauseContact + placeholder + ' Contact__r.HMS_PIID__c =: hmsFilter';
                andClauseAccount2 = andClauseAccount2 + placeholder + ' HMS_POID__c =: hmsFilter';
                andClauseContact2 = andClauseContact2 + placeholder + ' HMS_PIID__c =: hmsFilter';
                }   
            
            /* APEX BIND ISSUE FOR DISTANCE FILTER NEEDS WORKAROUND IF SALES WANTS TO RE-IMPLEMENT
            Check this type of format first for Re-Implementation--> AND DISTANCE(Shipping_Geolocation__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\') < '+ maxDistance+
                                ' ORDER BY DISTANCE(Shipping_Geolocation__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\') limit 250';
            
            if(distanceFilter == 'All within 50 miles' || distanceFilter == 'All within 100 miles'){
            if(distanceFilter == 'All within 50 miles'){
                andClauseAccount = andClauseAccount + placeholder + ' DISTANCE(accLoc__c, GEOLOCATION(location), \'mi\') <= 50';
                andClauseContact = andClauseContact + placeholder + ' DISTANCE(Location__c, GEOLOCATION(location), \'mi\') <= 50';
                }
            else if(distanceFilter == 'All within 100 miles'){
                andClauseAccount = andClauseAccount + placeholder + ' DISTANCE(accLoc__c, GEOLOCATION(location), \'mi\') <= 100';
                andClauseContact = andClauseContact + placeholder + ' DISTANCE(Location__c, GEOLOCATION(location), \'mi\') <= 100';
                }
            }
        */
            }
            //Query string to get the Account details from Account team Member based on selected users and applied filters.   
            if(typeFilter == 'Account' || typeFilter == 'All'){
            string AccountTeamMemberQuery = 'Select CreatedDate, Id, AccountId, Account.RecordType.Name, Account.Name, Account.NPI__c, Account.HMS_POID__c, Account.HPAS_ID__c, Account.Horizon_ID__c, Account.Meditech_ID__c, Account.Unity_ID__c, Account.ShippingCity, Account.ShippingState, Account.Shippingstreet, '+
                                            'Account.ShippingPostalCode, Account.Account_Type_Display__c, UserId, Account.KAH_HMS_ALL_HH_DR__c, '+
                                            'Account.KAH_HMS_All_HP_DR__c, Account.KAH_HH_Referrals_YTD__c, '+
                                            'Account.KAH_HP_Admits_YTD__c, Account.HCHB_HH_ID__c, Account.HCHB_HP_ID__c, Account.KAH_HP_Referrals_YTD__c, '+
                                            'Account.KAH_Avg_LOS_Hospice_Only__c, Account.HP_Admits_PY__c, Account.KAH_HP_Qualified_Admits_PY__c, '+
                                            'Account.KAH_HMS_Total_Patient_Volume_DR__c, '+
                                            'Account.KAH_HH_Admits_YTD__c, Account.HH_Admits_PY__c, Account.KAH_HH_PPS_Prior_Year_Admits_Prior__c, '+
                                            'Account.KAH_HD_Admits_YTD__c, Account.HD_Admits_PY__c, '+
                                            'Account.Doing_business_with__c, Account.Parent.Name, '+  
                                            'Account.KAH_HH_PPS_Admits_YTD__c, Account.KAH_HH_Discounted_Qualified_Admits_PY__c, Account.KAH_HH_Discounted_Qualified_Admits_YTD__c, Account.KAH_HP_Qualified_Admits_YTD__c '+
                                            'From AccountTeamMember ' +
                                            'WHERE UserId =: uId AND Account.recordtypeid IN: lstAccountRecordType ';
        
                                            if(andClauseAccount != null){
                                                AccountTeamMemberQuery = AccountTeamMemberQuery + andClauseAccount;
                                                } 
        system.debug('Account Team Query: ' + AccountTeamMemberQuery);                                    
                                           //AccountTeamMemberQuery = AccountTeamMemberQuery + ' Limit 1000'; 
                // Iterates over the Account Teams to get the Account Associates with it and to add it to the list.
                list<AccountTeamMember> atmLst = new list<AccountTeamMember>();
                atmLst = database.Query(AccountTeamMemberQuery);
                map<ID, Integer> atmMap = new map<ID, Integer>();
                for(AccountTeamMember objATM : atmLst){
                    accIDSet.add(objATM.Account.ID);
                    accAgrIDSet.add(objATM.Account.ID);
                    }
            for(AggregateResult agrA: [SELECT Count(User.ID)userCount, AccountID accID FROM AccountTeamMember WHERE User.ID !=:uId AND AccountID IN: accAgrIDSet Group By AccountID]){
                  atmMap.put(string.valueOf(agrA.get('accID')), integer.valueOf(agrA.get('userCount')));
                  }
                for(AccountTeamMember objATM : atmLst){
                  teamCount = 0;
                  if(atmMap.get(objATM.AccountID) != null){
                    teamCount = atmMap.get(objATM.AccountID);
                    }
                    if(reqType == 'Referral'){
                      cleanSet.add(new listWrapper(objATM, true,teamCount));
                      }
                    else if(reqType == 'Reassignment'){
                      cleanSet.add(new listWrapper(objATM, false,teamCount));
                      }  
                    }    
                    
             if(reqType == 'Referral'){
             if(distanceFilter != 'Currently Assigned' && distanceFilter != null){
                string AllAccountQuery =  'Select CreatedDate, AccountId, Account.RecordType.Name, Account.Name, Account.NPI__c, Account.HMS_POID__c, Account.HPAS_ID__c, Account.Horizon_ID__c, Account.Meditech_ID__c, Account.Unity_ID__c, Account.ShippingCity, Account.ShippingState, Account.Shippingstreet, '+
                                            'Account.ShippingPostalCode, Account.Account_Type_Display__c, Account.KAH_HMS_ALL_HH_DR__c, '+
                                            'Account.KAH_HMS_All_HP_DR__c, Account.KAH_HH_Referrals_YTD__c, '+
                                            'Account.KAH_HP_Admits_YTD__c, Account.HCHB_HH_ID__c, Account.HCHB_HP_ID__c, Account.KAH_HP_Referrals_YTD__c, '+
                                            'Account.KAH_Avg_LOS_Hospice_Only__c, Account.HP_Admits_PY__c, Account.KAH_HP_Qualified_Admits_PY__c, '+
                                            'Account.KAH_HMS_Total_Patient_Volume_DR__c, '+
                                            'Account.KAH_HH_Admits_YTD__c, Account.HH_Admits_PY__c, Account.KAH_HH_PPS_Prior_Year_Admits_Prior__c, '+
                                            'Account.KAH_HD_Admits_YTD__c, Account.HD_Admits_PY__c, '+
                                            'Account.Doing_business_with__c, Account.Parent.Name, '+  
                                            'Account.KAH_HH_PPS_Admits_YTD__c, Account.KAH_HH_Discounted_Qualified_Admits_PY__c, Account.KAH_HH_Discounted_Qualified_Admits_YTD__c, Account.KAH_HP_Qualified_Admits_YTD__c '+
                                          'From AccountTeamMember ' +
                                          'WHERE Account.recordtypeid IN: lstAccountRecordType AND Account.ID NOT IN: accIDSet ';
                                          if(andClauseAccount != null){
                                            AllAccountQuery = AllAccountQuery + andClauseAccount;
                                            }
                                          AllAccountQuery = AllAccountQuery + ' LIMIT 1000';            
                    system.debug('All Account Query: ' + AllAccountQuery);
                    for(AccountTeamMember objATM2 : database.Query(AllAccountQuery)){
                      accIDSet2.add(objATM2.AccountID);
                      accAgrIDSet2.add(objATM2.AccountID);
                        }
                    map<ID, Integer> atmMap2 = new map<ID, Integer>();
                  for(AggregateResult agrA2: [SELECT Count(User.ID)userCount, AccountID accID FROM AccountTeamMember WHERE User.ID !=:uId AND AccountID IN: accAgrIDSet2 Group By AccountID]){
                    atmMap2.put(string.valueOf(agrA2.get('accID')), integer.valueOf(agrA2.get('userCount')));
                    }
                  set<ID> accTeamCleanIDSet = new set<ID>();  
                  for(AccountTeamMember objATM2 : database.Query(AllAccountQuery)){
                      teamCount = 0;
                  if(atmMap2.get(objATM2.AccountID) != null){
                    teamCount = atmMap2.get(objATM2.AccountID);
                    }
                    if(accTeamCleanIDSet.contains(objATM2.AccountID) == false){
                       cleanSet.add(new listWrapper(objATM2, false, teamCount));
                      }
                        accTeamCleanIDSet.add(objATM2.AccountID);
                        }    
                
                string accountQuery = 'Select Id, Name, NPI__c, ShippingCity, ShippingState, ShippingPostalCode, ShippingStreet, Account_Type_Display__c, ' +
                                                                            'KAH_HMS_ALL_HH_DR__c, KAH_HP_Qualified_Admits_PY__c, ' +
                                                                            'KAH_HMS_All_HP_DR__c, HCHB_HH_ID__c, HCHB_HP_ID__c, KAH_HP_Admits_YTD__c, KAH_HP_Referrals_YTD__c, KAH_HH_Referrals_YTD__c, ' +
                                                                            'HP_Admits_PY__c, ' +
                                                                            'KAH_HH_Admits_YTD__c, HH_Admits_PY__c, '+
                                                                            'HMS_POID__c, HPAS_ID__c, Horizon_ID__c, Meditech_ID__c, Unity_ID__c, '+
                                                                            'KAH_HH_PPS_Prior_Year_Admits_Prior__c, ' +
                                                                            'KAH_HMS_Total_Patient_Volume_DR__c, KAH_Avg_LOS_Hospice_Only__c, '+
                                                                            'KAH_HD_Admits_YTD__c, HD_Admits_PY__c, KAH_NCD_Admits_YTD__c, NCD_Admits_PY__c, '+
                                                                            'KAH_HH_PPS_Admits_YTD__c, KAH_HH_Discounted_Qualified_Admits_YTD__c, KAH_HH_Discounted_Qualified_Admits_PY__c, KAH_HP_Qualified_Admits_YTD__c, '+
                                                                            'Doing_business_with__c, RecordType.Name, Parent.Name, Status__c '+
                                                                'From Account WHERE recordtypeid IN: lstAccountRecordType AND ID NOT IN: accIDSet AND ID NOT IN: accIDSet2';
                                                                if(andClauseAccount != null){
                                            accountQuery = accountQuery + andClauseAccount2;
                                            }
                                          accountQuery = accountQuery + ' LIMIT 1000';
                                          list<Account> accLst = new list<Account>();
                                          accLst = database.Query(accountQuery);
                                          for(Account a : accLst){
                                            cleanSet.add(new listWrapper(a, false, 0));
                                            }
                                          
                                           
                }
               }
            }
            
            if(typeFilter == 'Contact' || typeFilter == 'All'){
            // checks if filter has applied in strtype containing "contact" or there is no filter.
                string strContactTeamMemberQuery = 'Select CreatedDate, Id, Contact__c, Contact__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.NPI__c, Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingStreet, '+
                                                          'Contact__r.MailingPostalCode, User__c, Contact__r.HMS_PIID__c, Contact__r.RecordType.Name, Contact__r.Specialties__c, Contact__r.KAH_HMS_ALL_HH_DR__c, '+
                                                          'Contact__r.KAH_HMS_All_HP_DR__c, Contact__r.Unity_ID__c, '+
                                                          'Contact__r.HCHB_HH_ID__c, Contact__r.HCHB_HP_ID__c, Contact__r.Horizon_ID__c, Contact__r.HPAS_Contact_ID__c, '+
                                                          'Contact__r.Meditech_Contact_ID__c, '+
                                                          'Contact__r.KAH_HMS_Total_Patient_Volume_DR__c, '+
                                                          'Contact__r.KAH_HH_Admits_YTD__c, Contact__r.HH_Admits_PY__c, '+
                                                          'Contact__r.KAH_HP_Admits_YTD__c, Contact__r.KAH_HP_Referrals_YTD__c, Contact__r.KAH_HH_Referrals_YTD__c, Contact__r.HP_Admits_PY__c, Contact__r.KAH_HH_PPS_Prior_Year_Admits_Prior__c, Contact__r.KAH_HD_Admits_YTD__c, '+
                                                          'Contact__r.HD_Admits_PY__c, Contact__r.KAH_NCD_Admits_YTD__c, Contact__r.NCD_Admits_PY__c, Contact__r.KAH_HP_Qualified_Admits_PY__c, '+
                                                          'Contact__r.Doing_business_with__c, Contact__r.KAH_HMS_HP_LOS__c, '+
                                                          'Contact__r.KAH_HH_PPS_Admits_YTD__c, Contact__r.KAH_HH_Discounted_Qualified_Admits_PY__c, Contact__r.KAH_HH_Discounted_Qualified_Admits_YTD__c, Contact__r.KAH_HP_Qualified_Admits_YTD__c '+
                                                          'From Contact_Team__c Where User__c =: uId AND Contact__r.Recordtypeid IN: lstContactRecordType '; 
                                                        
                                                        if(andClauseContact != null){
                                                            strContactTeamMemberQuery = strContactTeamMemberQuery + andClauseContact;
                                                            }
                system.debug('ContactTeam Query: ' + strContactTeamMemberQuery);
                list<Contact_Team__c> ctmLst = new list<Contact_Team__c>();
                ctmLst = database.Query(strContactTeamMemberQuery);
                map<ID, Integer> ctmMap = new map<ID, Integer>();
                for(Contact_Team__c objCTM : ctmLst){
                    ctcIDSet.add(objCTM.Contact__r.ID);
                    ctcAgrIDSet.add(objCTM.Contact__r.ID);
                    }
                for(AggregateResult agrC: [SELECT Count(User__r.ID)userCount, Contact__r.ID ctcID FROM Contact_Team__c WHERE User__r.ID !=:uId AND Contact__r.ID IN: ctcAgrIDSet Group By Contact__r.ID]){
                  ctmMap.put(string.valueOf(agrC.get('ctcID')), integer.valueOf(agrC.get('userCount')));
                  }
                //Iterates over the Account Teams to get the Account Associates with it and to add it to the list.                                         
                for(Contact_Team__c objCTM : ctmLst){
                  teamCount = 0;
                  if(ctmMap.get(objCTM.Contact__r.ID) != null){
                    teamCount = ctmMap.get(objCTM.Contact__r.ID);
                    }
                    if(reqType == 'Referral'){
                      cleanSet.add(new listWrapper(objCTM, true,teamCount));
                      }
                    else if(reqType == 'Reassignment'){
                      cleanSet.add(new listWrapper(objCTM, false,teamCount));
                      }  
                    }
            
            if(reqType == 'Referral'){
            if(distanceFilter != 'Currently Assigned' && distanceFilter != null){
                string AllContactTeamMemberQuery = 'Select CreatedDate, Contact__c, Contact__r.Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.NPI__c, Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingStreet, '+
                                                          'Contact__r.MailingPostalCode, Contact__r.HMS_PIID__c, Contact__r.RecordType.Name, Contact__r.Specialties__c, Contact__r.KAH_HMS_ALL_HH_DR__c, '+
                                                          'Contact__r.KAH_HMS_All_HP_DR__c, Contact__r.Unity_ID__c, '+
                                                          'Contact__r.HCHB_HH_ID__c, Contact__r.HCHB_HP_ID__c, Contact__r.Horizon_ID__c, Contact__r.HPAS_Contact_ID__c, '+
                                                          'Contact__r.Meditech_Contact_ID__c, '+
                                                          'Contact__r.KAH_HMS_Total_Patient_Volume_DR__c, '+
                                                          'Contact__r.KAH_HH_Admits_YTD__c, Contact__r.HH_Admits_PY__c, '+
                                                          'Contact__r.KAH_HP_Admits_YTD__c, Contact__r.KAH_HP_Referrals_YTD__c, Contact__r.KAH_HH_Referrals_YTD__c, Contact__r.HP_Admits_PY__c, Contact__r.KAH_HH_PPS_Prior_Year_Admits_Prior__c, Contact__r.KAH_HD_Admits_YTD__c, '+
                                                          'Contact__r.HD_Admits_PY__c, Contact__r.KAH_NCD_Admits_YTD__c, Contact__r.NCD_Admits_PY__c, Contact__r.KAH_HP_Qualified_Admits_PY__c, '+
                                                          'Contact__r.Doing_business_with__c, Contact__r.KAH_HMS_HP_LOS__c, '+
                                                          'Contact__r.KAH_HH_PPS_Admits_YTD__c, Contact__r.KAH_HH_Discounted_Qualified_Admits_PY__c, Contact__r.KAH_HH_Discounted_Qualified_Admits_YTD__c, Contact__r.KAH_HP_Qualified_Admits_YTD__c '+
                                                          'From Contact_Team__c WHERE Contact__r.ID NOT IN: ctcIDSet AND Contact__r.Recordtypeid IN: lstContactRecordType '; 
                                                        
                                                        if(andClauseContact != null){
                                                            AllContactTeamMemberQuery = AllContactTeamMemberQuery + andClauseContact;
                                                            }
                                                        AllContactTeamMemberQuery = AllContactTeamMemberQuery + ' LIMIT 1000';  
                system.debug('All Contact Query: ' + AllContactTeamMemberQuery);
                for(Contact_Team__c objCTM2 :  database.query(AllContactTeamMemberQuery)){
                    ctcIDSet2.add(objCTM2.Contact__r.ID);      
                    ctcAgrIDSet2.add(objCTM2.Contact__r.ID);
                    }
                map<ID, Integer> ctmMap2 = new map<ID, Integer>();
                  for(AggregateResult agrC2: [SELECT Count(User__r.ID)userCount, Contact__r.ID ctcID FROM Contact_Team__c WHERE User__r.ID !=:uId AND Contact__r.ID IN: ctcAgrIDSet2 Group By Contact__r.ID]){
                    ctmMap2.put(string.valueOf(agrC2.get('ctcID')), integer.valueOf(agrC2.get('userCount')));
                    }
                  set<ID> cleanConIDSet = new set<ID>();  
                  for(Contact_Team__c objCTM2 : database.Query(AllContactTeamMemberQuery)){
                      teamCount = 0;
                    if(ctmMap2.get(objCTM2.Contact__r.ID) != null){
                      teamCount = ctmMap2.get(objCTM2.Contact__r.ID);
                      }
                      if(cleanConIDSet.contains(objCTM2.Contact__r.ID) == false){  
                        cleanSet.add(new listWrapper(objCTM2, false, teamCount));
                          }
                        cleanConIDSet.add(objCTM2.Contact__r.ID);  
                        }
                               
                string contactQuery = 'Select CreatedDate, Id, Name, FirstName, LastName, NPI__c, MailingCity, MailingState, MailingStreet, '+
                                                          'MailingPostalCode, HMS_PIID__c, RecordType.Name, Specialties__c, KAH_HMS_ALL_HH_DR__c, '+
                                                          'KAH_HMS_All_HP_DR__c, Unity_ID__c, '+
                                                          'HCHB_HH_ID__c, HCHB_HP_ID__c, Horizon_ID__c, HPAS_Contact_ID__c, '+
                                                          'Meditech_Contact_ID__c, '+
                                                          'KAH_HMS_Total_Patient_Volume_DR__c, '+
                                                          'KAH_HH_Admits_YTD__c, HH_Admits_PY__c, '+
                                                          'KAH_HP_Admits_YTD__c, KAH_HP_Referrals_YTD__c, KAH_HH_Referrals_YTD__c, HP_Admits_PY__c, KAH_HH_PPS_Prior_Year_Admits_Prior__c, KAH_HD_Admits_YTD__c, '+
                                                          'HD_Admits_PY__c, KAH_NCD_Admits_YTD__c, NCD_Admits_PY__c, KAH_HP_Qualified_Admits_PY__c, '+
                                                          'Doing_business_with__c, KAH_HMS_HP_LOS__c, '+
                                                          'KAH_HH_PPS_Admits_YTD__c, KAH_HH_Discounted_Qualified_Admits_PY__c, KAH_HH_Discounted_Qualified_Admits_YTD__c, KAH_HP_Qualified_Admits_YTD__c '+
                                                          'From Contact WHERE ID NOT IN: ctcIDSet AND ID NOT IN: ctcIDSet2 AND Recordtypeid IN: lstContactRecordType '; 
                                                        
                                                        if(andClauseContact != null){
                                                            contactQuery = contactQuery + andClauseContact2;
                                                            }
                                                        contactQuery = contactQuery + ' LIMIT 1000';
                 
                 for(Contact c :  database.query(contactQuery)){
                    cleanSet.add(new listWrapper(c, false, 0));
                    }
                                                                     
                }
              }
            }
            displayList.addAll(cleanSet);
            system.debug('displayList: ' + displayList);
            return displayList;
            }
        catch(exception e){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
            }
        }
    
    @AuraEnabled
    public static integer removeAllUserAssignments(User selectedUser){
        list<Referral_Source_Audit__c> auditList = new list<Referral_Source_Audit__c>();
        //list to hold AccountTeammembers to delete
        List<AccountTeamMember> lstATMsToDelete = new List<AccountTeamMember>(); 
        //list to hold ContactTeamMembers to delete
        List<Contact_Team__c> lstContactTeamsToDelete = new List<Contact_Team__c>();
        integer totalCount = 0;
        try{
            list<Contact_Team__c> ctmList = [SELECT ID, User__c, Contact__c FROM Contact_Team__c WHERE User__c =: selectedUser.ID];
            for(Contact_Team__c objCTM : ctmList){
                    lstContactTeamsToDelete.add(objCTM);
                    auditList.add(new Referral_Source_Audit__c(Contact__c = objCTM.Contact__c, 
                                           Request_Date__c = system.today(), 
                                           Status__c = 'Deleted', 
                                           User__c = selectedUser.ID));
                    }
            list<AccountTeamMember> objATM = [SELECT ID, Account.RecordType.Name, AccountID, UserID FROM AccountTeamMember WHERE UserID =: SelectedUser.ID];
            for(AccountTeamMember atm : objATM){
                lstATMsToDelete.add(atm);
                auditList.add(new Referral_Source_Audit__c(Account__c = atm.AccountID, 
                                                           Request_Date__c = system.today(), 
                                                           Status__c = 'Deleted', 
                                                           User__c = selectedUser.ID));
                    }
            delete lstATMsToDelete;
            delete lstContactTeamsToDelete;        
            totalCount = getReferralSourceCount(selectedUser);
            return totalCount;
            }
        catch(Exception E){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
            }   
       }
    
    /**
    @MethodName : assignReferralSources
    @Description: Method used to assign the ReferralSources based on selected user. If the assign is checked, the referral is assigned to the user and vise versa.
    **/
    @AuraEnabled 
    global static integer getProcessAssignReferralSources(User selectedUser, string idList){
        try{
            //list to hold AccountteamMembers to insert
            List<AccountTeamMember> lstATMsToInsert = new List<AccountTeamMember>(); 
            //list to hold ContactTeamMembers to insert
            List<Contact_Team__c> lstContactTeamsToInsert = new List<Contact_Team__c>();
            //list to hold AccountTeammembers to delete
            List<AccountTeamMember> lstATMsToDelete = new List<AccountTeamMember>(); 
            //list to hold ContactTeamMembers to delete
            List<Contact_Team__c> lstContactTeamsToDelete = new List<Contact_Team__c>();
            integer totalCount = 0;
            list<Referral_Source_Audit__c> auditList = new list<Referral_Source_Audit__c>();
            system.debug('selectedUser: ' + selectedUser);
            system.debug('idList: ' + idList);
            list<Contact_Team__c> ctmList = [SELECT ID, User__c, Contact__c FROM Contact_Team__c WHERE Contact__r.Id =: idList AND User__c =: selectedUser.ID];
            if(ctmList.size() > 0){
                for(Contact_Team__c objCTM : ctmList){
                    lstContactTeamsToDelete.add(objCTM);
                    auditList.add(new Referral_Source_Audit__c(Contact__c = objCTM.Contact__c, 
                                           Request_Date__c = system.today(), 
                                           Status__c = 'Deleted', 
                                           User__c = selectedUser.ID));
                    }
                }
            else{
                 ID c;
                 try{
                    c = [SELECT ID FROM Contact WHERE ID =: idList LIMIT 1].ID; 
                    if(c != null){
                        lstContactTeamsToInsert.add(new Contact_Team__c(User__c = selectedUser.ID,
                        Contact__c = c));
                        auditList.add(new Referral_Source_Audit__c(Contact__c = c, 
                                           Request_Date__c = system.today(), 
                                           Status__c = 'Added', 
                                           User__c = selectedUser.ID));
                    }
                    }
                 catch(Exception cE){
                    system.debug('Not a Contact Team Record');
                    }   
                }   
                
            list<AccountTeamMember> objATM = [SELECT ID, Account.RecordType.Name, AccountID, UserID FROM AccountTeamMember WHERE AccountID =: idList AND UserID =: SelectedUser.ID];
            if(objATM.size() > 0){
                for(AccountTeamMember atm : objATM){
                    lstATMsToDelete.add(atm);
                    auditList.add(new Referral_Source_Audit__c(Account__c = atm.AccountID, 
                                           Request_Date__c = system.today(), 
                                           Status__c = 'Deleted', 
                                           User__c = selectedUser.ID));
                    }
                }   
            else{
                list<Account> newList = [SELECT ID, RecordType.Name FROM Account WHERE ID =: idList];
                    for(Account s : newList){
                        if(s.RecordType.Name == 'Center'){
                            lstATMsToInsert.add(new AccountTeamMember(AccountId = s.ID,
                                                                      UserId = selectedUser.ID, 
                                                                      TeamMemberRole = 'Clinical Liaison',
                                                                      ContactAccessLevel = 'Read',
                                                                      OpportunityAccessLevel = 'Read',
                                                                      CaseAccessLevel = 'Read',
                                                                      AccountAccessLevel = 'Read'));
                            
                            auditList.add(new Referral_Source_Audit__c(Account__c = s.ID, 
                                                   Request_Date__c = system.today(), 
                                                   Status__c = 'Added', 
                                                   User__c = selectedUser.ID));                                          
                            }
                        else{
                            lstATMsToInsert.add(new AccountTeamMember(AccountId = s.ID,
                                                                      UserId = selectedUser.ID, 
                                                                      TeamMemberRole = 'Clinical Liaison',
                                                                      ContactAccessLevel = 'Read',
                                                                      OpportunityAccessLevel = 'None',
                                                                      CaseAccessLevel = 'Read',
                                                                      AccountAccessLevel = 'Edit'));
                                                                      
              auditList.add(new Referral_Source_Audit__c(Account__c = s.ID, 
                                                   Request_Date__c = system.today(), 
                                                   Status__c = 'Added', 
                                                   User__c = selectedUser.ID));                                          
                                                                                                  
                            }
                        }
                  }
            if(!lstATMsToInsert.isEmpty()){
                insert lstATMsToInsert; 
                }
            if(!lstContactTeamsToInsert.isEmpty()){
                insert lstContactTeamsToInsert;
                }
            if(!lstATMsToDelete.isEmpty()){
                delete lstATMsToDelete; 
                }
            if(!lstContactTeamsToDelete.isEmpty()){
                delete lstContactTeamsToDelete; 
                }
            if(!auditList.isEmpty()){
              insert auditList;
              }    
            totalCount = getReferralSourceCount(selectedUser);
            return totalCount; 
            }
        catch(exception e){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
            }
        }
    
    /**
    @MethodName : reAssignReferralSources
    @Description: Method used to assign the ReferralSources based on selected user to 'to user' 
    **/
    @AuraEnabled 
    global static integer getProcessReassignReferralSources(User selectedUser, User selectedFromUser, list<string> idList) {
        system.debug('selectedUser: ' + selectedUser);
        system.debug('selectedFromUser: ' + selectedFromUser);
        system.debug('idList: ' + idList);
        
        try{
            //list to hold AccountteamMembers to insert
            List<AccountTeamMember> lstATMsToInsert = new List<AccountTeamMember>(); 
            //list to hold ContactTeamMembers to insert
            List<Contact_Team__c> lstContactTeamsToInsert = new List<Contact_Team__c>();
            //list to hold AccountTeammembers to delete
            List<AccountTeamMember> lstATMsToDelete = new List<AccountTeamMember>(); 
            //list to hold ContactTeamMembers to delete
            List<Contact_Team__c> lstContactTeamsToDelete = new List<Contact_Team__c>();
            integer totalCount = 0;
            list<Referral_Source_Audit__c> auditList = new list<Referral_Source_Audit__c>();
            
            for(Contact_Team__c objCTM : [SELECT ID, Contact__c, Contact__r.ID FROM Contact_Team__c WHERE Contact__r.ID =: idList AND User__c =: selectedFromUser.ID]){
                    lstContactTeamsToDelete.add(objCTM);
                    auditList.add(new Referral_Source_Audit__c(Contact__c = objCTM.Contact__r.ID, 
                                                   Request_Date__c = system.today(), 
                                                   Status__c = 'Deleted', 
                                                   User__c = selectedFromUser.ID));
                    lstContactTeamsToInsert.add(new Contact_Team__c(User__c = selectedUser.ID,
                                            Contact__c = objCTM.Contact__c));
                    auditList.add(new Referral_Source_Audit__c(Contact__c = objCTM.Contact__r.ID, 
                                                   Request_Date__c = system.today(), 
                                                   Status__c = 'Added', 
                                                   User__c = selectedUser.ID));                        
                    
                    }
            for(AccountTeamMember objATM : [SELECT ID, Account.RecordType.Name, AccountID, UserID FROM AccountTeamMember WHERE AccountID =: idList AND UserID =: selectedFromUser.ID]){
                    lstATMsToDelete.add(objATM);
                    auditList.add(new Referral_Source_Audit__c(Account__c = objATM.AccountID, 
                                                   Request_Date__c = system.today(), 
                                                   Status__c = 'Deleted', 
                                                   User__c = selectedFromUser.ID));
                    if(objATM.Account.RecordType.Name == 'Center'){
                        lstATMsToInsert.add(new AccountTeamMember(AccountId = objATM.AccountID, 
                                                                  TeamMemberRole = 'Clinical Liaison',
                                                                  ContactAccessLevel = 'Read',
                                                                  OpportunityAccessLevel = 'Read',
                                                                  CaseAccessLevel = 'Read',
                                                                  AccountAccessLevel = 'Read',
                                                                  UserId = selectedUser.ID));
                                                                  
                        auditList.add(new Referral_Source_Audit__c(Account__c = objATM.AccountID, 
                                                  Request_Date__c = system.today(), 
                                                  Status__c = 'Added', 
                                                  User__c = selectedUser.ID));
                        }
                    else{
                        lstATMsToInsert.add(new AccountTeamMember(AccountId = objATM.AccountID, 
                                                                  TeamMemberRole = 'Clinical Liaison',
                                                                  ContactAccessLevel = 'Read',
                                                                  OpportunityAccessLevel = 'Read',
                                                                  CaseAccessLevel = 'Read',
                                                                  AccountAccessLevel = 'Edit',
                                                                  UserId = selectedUser.ID));
                                                                  
                        auditList.add(new Referral_Source_Audit__c(Account__c = objATM.AccountID, 
                                                  Request_Date__c = system.today(), 
                                                  Status__c = 'Added', 
                                                  User__c = selectedUser.ID));                                          
                        }                       
                }
            if(!lstATMsToInsert.isEmpty()){
                insert lstATMsToInsert;
                }
            if(!lstContactTeamsToInsert.isEmpty()){
                insert lstContactTeamsToInsert;
                }
            if(!lstATMsToDelete.isEmpty()){
                delete lstATMsToDelete; 
                }
            if(!lstContactTeamsToDelete.isEmpty()){
                delete lstContactTeamsToDelete; 
                }
            if(!auditList.isEmpty()){
              insert auditList;
              }    
            totalCount = getReferralSourceCount(selectedFromUser);
            return totalCount; 
            }
        catch(exception e){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
            }
        }
    
    public class Response {
      @AuraEnabled public list<String> roles;
      @AuraEnabled public string users;
      
      public Response(list<String> roles, String users){
        this.roles = roles;
        this.users = users;
        }
    }
    
    @AuraEnabled(cacheable=true) 
    public static list<Response> fetchParentRoles(String strSelectedUser, String strSelectedUserRole){
      list<Response> resList = new list<Response>(); 
      try{
            system.debug('strSelectedUser: ' + strSelectedUser);
            system.debug('strSelectedUserRole: ' + strSelectedUserRole);
            Integer rowCount = 0;              // Variable used for row count
            Id prevRoleSelected;
            Id parentRoleId;
            if(strSelectedUserRole != ''){
                parentRoleId = strSelectedUserRole;
              }
            if(String.isNotBlank(strSelectedUser) && String.isNotBlank(strSelectedUserRole)){
                Boolean isNewResultsFound = false;
                UserRole objEnterpriseUserRole = [Select ParentRoleId From UserRole Where Name = 'SVP - KAH' Limit 1];
                map<Integer, list<String>> mapOptions = new map<Integer, list<String>>();
                map<Integer, String> mapUsersHTML = new map<Integer, String>();
                map<integer, string> roleOrder = new map<integer, string>();
                list<String> roleSelectOptions = new list<String>();
                integer counter = 0;
                string firstRole = '';
                do{
                   isNewResultsFound = false;
                   String userNames = '';
                   List<UserRole> lstUserRoles = [Select ParentRoleId, Id From UserRole Where Id = :strSelectedUserRole limit 1];
                    // Iterating over UserRole based on ParentRole to fetch the Role names of user  
                    for(UserRole objUserRole : [Select Id, Name, ParentRoleId From UserRole Where ParentRoleId = :parentRoleId]) {
                        isNewResultsFound = true;
                        roleOrder.put(counter, objUserRole.Name);
                        //roleSelectOptions.add(objUserRole.Name);
                        counter++;
            }
            if(!lstUserRoles.isEmpty()){  
                        isNewResultsFound = true;
                        parentRoleId = lstUserRoles[0].ParentRoleId;
                  }
                    else{
                        isNewResultsFound = false;
                  }
                    if(rowCount > 0){
                        //Iterating over users to fetch the Usernames based on selected role
                        for(User objUser : [SELECT Id, Name, userRole.name  FROM User WHERE userroleId =:prevRoleSelected Order By Name]) {
                            if(userNames == ''){
                                userNames+= objUser.Name;
                        }
                            else{
                                userNames+= ', ' + objUser.Name;
                        }
                  firstRole = objUser.userRole.name;
                  }
                }
                    if(roleOrder.size() > 0){
                      system.debug('roleOrder: ' + roleOrder);
                        if(firstRole != ''){
                          roleSelectOptions.add(firstRole);
                          }
                        for(integer i = 0; i<= counter; i++){
                          roleSelectOptions.add(roleOrder.get(i));
                          }
                        mapOptions.put(rowCount, roleSelectOptions);
                        mapUsersHTML.put(rowCount, userNames);
                        roleSelectOptions = new list<String>();
                counter = 0;
                firstRole = '';
                }
                    // Assign the previous role in hierarchy for comparison
                    prevRoleSelected = strSelectedUserRole;
                    // Updating the parent role for further querying
                    strSelectedUserRole = parentRoleId;
                    rowCount++;
                    }while(parentRoleId != objEnterpriseUserRole.ParentRoleId && isNewResultsFound && rowCount < 25);
                for(Integer j = rowCount; j >= (rowCount * -1); j--){
                    if(mapUsersHTML.containsKey(j)){
                    if(mapOptions.containsKey(j)) {
                        resList.add(new Response(mapOptions.get(j), mapUsersHTML.get(j)));
                      }
                    }
                }
            }
            system.debug('ResList: ' + resList); 
            return resList;
            }
        catch(exception e){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
            }
        }
      
    @AuraEnabled(cacheable=true) 
    public static list<Response> fetchNewRoles(String strSelectedUser, String strSelectedUserRole){
      list<Response> resList = new list<Response>();
      UserRole role = new UserRole();
      string newRole;
      role = [SELECT ID FROM UserRole WHERE Name =: strSelectedUserRole LIMIT 1];
      newRole = role.ID;
      system.debug('newRole: ' + newRole);
      reslist = fetchParentRoles(strSelectedUser, newRole);
      return resList; 
      }
      
    @AuraEnabled 
    public static string setNewRole(String newSelectedRole, User selectedUser){
      try{
        system.debug('newSelectedRole: ' + newSelectedRole);
        string newR = '';
        UserRole newRole = new UserRole();
        User usrToUpd = new User();
        usrToUpd = [SELECT ID, UserRoleId FROM User WHERE ID =: selectedUser.ID];
        newRole = [SELECT ID, Name FROM UserRole WHERE Name =: newSelectedRole];
        usrToUpd.UserRoleId = newRole.ID;
        newR = newRole.Name;
        update usrToUpd;
        return newR;
        }
       catch(exception e){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return null;
          }
      }    
  
}