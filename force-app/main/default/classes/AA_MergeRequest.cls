public with sharing class AA_MergeRequest {

  private static list<Profile> pList = [SELECT ID, Name FROM Profile WHERE (Name = 'KRS: HRS Admin' OR Name = 'KRS: HRS User' OR Name = 'KRS: Read Only' OR Name = 'KRS: SRS Admin' OR Name = 'KRS: SRS Finance' OR Name = 'KRS: SRS Support Admin' OR Name = 'KRS: SRS User')];
  
  public class listWrapper{
        @AuraEnabled 
        public sObject itm  {get;set;}
        @AuraEnabled 
        public Boolean selected    {get;set;}
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
        public string phone {get;set;}
        @AuraEnabled
        public string email {get;set;}
        @AuraEnabled
        public string horizon   {get;set;}
        @AuraEnabled
        public string unity {get;set;}
        @AuraEnabled
        public string meditech  {get;set;}
        @AuraEnabled 
        public string rType {get;set;}
        @AuraEnabled 
        public string owner {get;set;}
        @AuraEnabled 
        public string definitive {get;set;}
        @AuraEnabled 
        public string cms {get;set;}
        
        public listWrapper(Account a){
            itm = a;
            itemID = a.ID;
            selected = false;
            name = a.Name;
            npi = a.NPI__c;
            horizon = a.Horizon_ID__c;
            meditech = a.Meditech_ID__c;
            unity = a.Unity_ID__c;
            if(a.ShippingCity != null){
              shippingCity = a.ShippingCity;
              }
            else{
              shippingCity = a.BillingCity;
              }
            if(a.shippingState != null){    
              shippingState = a.ShippingState;
              }
            else{
              shippingState = a.BillingState;
              }
            if(a.Shippingstreet != null){     
              shippingStreet = a.Shippingstreet;
              }
            else{
              shippingStreet = a.Billingstreet;
              }  
            if(a.ShippingPostalCode != null){
              shippingPostalCode = a.ShippingPostalCode;
              }
            else{
              shippingPostalCode = a.BillingPostalCode;
              }  
            rType = a.RecordType.Name;
            owner = a.Owner.Name;
            phone = a.Phone;
            definitive = a.KRS_Definitive_ID__c;
            cms = a.CMS_Provider_ID__c;
            }
            
        public listWrapper(Contact c){
            itm = c;
            selected = false;
            itemID = c.ID;
            name = c.Name;
            npi = c.NPI__c;
            horizon = c.Horizon_ID__c;
            meditech = c.Meditech_Contact_ID__c;
            unity = c.Unity_ID__c;
            shippingCity = c.MailingCity;
            shippingState = c.MailingState; 
            shippingStreet = c.MailingStreet;
            shippingPostalCode = c.MailingPostalCode;
            rType = c.RecordType.Name;
            owner = c.Owner.Name;
            phone = c.Phone;
            email = c.Email;
            }
            
        public listWrapper(Lead l){
            itm = l;
            selected = false;
            itemID = l.ID;
            name = l.Name;
            rType = l.RecordType.Name;
            owner = l.Owner.Name;
            phone = l.Phone;
            shippingCity = l.City;
            shippingState = l.State; 
            shippingStreet = l.Street;
            shippingPostalCode = l.PostalCode;
            email = l.Email;
            }        
        
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

    @AuraEnabled(cacheable=true)
    public static Account getAccount(ID id){
        Account acc = new Account();
            acc = [SELECT ID,
                          Name,
                          Phone,
                          NPI__c,
                          Type,
                          Owner.Name,
                          Horizon_ID__c,
                          Unity_ID__c,
                          Meditech_ID__c,
                          RecordType.Name,
                          BillingStreet, 
                          BillingCity, 
                          BillingState, 
                          BillingPostalCode,
                          ShippingStreet,
                          ShippingCity,
                          ShippingState,
                          ShippingPostalCode,
                          KRS_Definitive_ID__c,
                          CMS_Provider_ID__c,
                          KRS_RHB_Business_Unit__c
                          FROM
                          Account
                          WHERE ID =: id];
        return acc;
        }
    
    @AuraEnabled(cacheable=true)
    public static Contact getContact(ID id){
        Contact ctc = new Contact();
        ctc = [SELECT ID,
                      Account.Name,
                      Account.NPI__c,
                      Owner.Name,
                      Name,
                      Email,
                      NPI__c,
                      Horizon_ID__c,
                      Unity_ID__c,
                      Meditech_Contact_ID__c,
                      FirstName,
                      LastName,
                      Phone,
                      RecordType.Name,
                      MailingStreet,
                      MailingCity,
                      MailingState,
                      MailingPostalCode,
                      Account.KRS_RHB_Business_Unit__c
                      FROM
                      Contact
                      WHERE ID =: id];
        return ctc; 
        }
        
    @AuraEnabled(cacheable=true)
    public static Lead getLead(ID id){
        Lead lead = new Lead();
            lead = [SELECT ID, 
                     Name, 
                     Owner.Name, 
                     Company, 
                     Title, 
                     LeadSource, 
                     KRS_Source_Description__c, 
                     Phone, 
                     MobilePhone, 
                     Email, 
                     City, 
                     PostalCode, 
                     State, 
                     Street,
                           RecordType.Name
                           FROM
                           Lead
                           WHERE ID =: id];
        return lead;
        }    
    
    @AuraEnabled
    public static boolean assignProfileType(){
      list<string> khrsProfiles = new list<string>();
    
    for(Profile p: pList){
      khrsProfiles.add(p.ID);  
      }
    
      boolean isKHRS = false;
      
      system.debug('userInfo.getProfileID(): ' + userInfo.getProfileID());
      string userID = string.valueOf(userInfo.getProfileID());  
      
      if(khrsProfiles.contains(userID)){
        isKHRS = true;
        }
      
      return isKHRS;
      }
        
    
    @AuraEnabled(cacheable=true)
    public static list<listWrapper> getAccountItems(string searchStr, ID id, string cityFilter, string stateFilter){
        
        system.debug('City filter: ' + cityFilter);
        system.debug('State filter: ' + stateFilter);
        
        list<ID> rhcIDs = AA_UtilityClass.getAllRHCProfileIDs;
                
        ID id1 = userInfo.getProfileID();
        list<listWrapper> acclstWrp = new list<ListWrapper>();
        string sortStr = '';
        string sortVal = '';
        list<Account> accList = new list<Account>();
            string searchID = id;
            string query = '';
                query = 'SELECT ID, Name, Phone, KRS_Definitive_ID__c, CMS_Provider_ID__c, NPI__c, Owner.Name, HMS_POID__c, Horizon_ID__c, HPAS_ID__c, Unity_ID__c, Meditech_ID__c, RecordType.Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE ID !=: searchID AND Name LIKE \'%'+ String.escapeSingleQuotes(searchStr) + '%\'';
            
            if(cityFilter != null && cityFilter != ''){
                query = query + ' AND (ShippingCity LIKE: cityFilter OR BillingCity =: cityFilter)';
                }
            if(stateFilter != null && stateFilter != 'None'){
                query = query + ' AND (ShippingState =: stateFilter OR BillingState =: stateFilter)';
                }       
            string khrsFilter = '';
            
            list<ID> hrsIDs = new list<ID>();
            list<ID> srsIDs = new list<ID>();
            for(Profile p: pList){
              if(p.Name.contains('HRS')){
          hrsIDs.add(p.ID);
                }
              else if(p.Name.contains('SRS')){
                srsIDs.add(p.ID);
                }    
        }
            
            if(rhcIDs.contains(UserInfo.getProfileID())){
              List<ID> recordTypeRHC = AA_UtilityClass.getRHCAccountTypeIDs;
              query = query + ' AND RecordTypeID IN : recordTypeRHC';
              }
            
            if(hrsIDs.contains(UserInfo.getProfileID())){
              khrsFilter = 'HRS';
              query = query + ' AND KRS_RHB_Business_Unit__c =: khrsFilter';
              }
            if(srsIDs.contains(UserInfo.getProfileID())){
              khrsFilter = 'SRS';
              query = query + ' AND KRS_RHB_Business_Unit__c =: khrsFilter';
              }  
                
            system.debug('query: ' + query);        
            accList = database.query(query);    
        for(Account a: accList){
            accLstWrp.add(new listWrapper(a));
            }
        return accLstWrp;
        }
    
    @AuraEnabled(cacheable=true)
    public static list<listWrapper> getContactItems(string searchStr, ID id, string cityFilter, string stateFilter){
        
        system.debug('City filter: ' + cityFilter);
        system.debug('State filter: ' + stateFilter);
         
        list<ID> rhcIDs = AA_UtilityClass.getAllRHCProfileIDs;
        
        list<listWrapper> conlstWrp = new list<ListWrapper>();
        string sortStr = '';
        string sortVal = '';
        list<Contact> ctcList = new list<Contact>();
        
            string searchID = id;   
            string query = 'SELECT ID, Name, Email, NPI__c, HMS_PIID__c, Horizon_ID__c, HPAS_Contact_ID__c, Unity_ID__c, Meditech_Contact_ID__c, Phone, RecordType.Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, Owner.Name FROM Contact WHERE ID !=: searchID AND Name LIKE \'%'+ String.escapeSingleQuotes(searchStr) + '%\'';
            
            if(cityFilter != null  && cityFilter != ''){
                query = query + ' AND MailingCity LIKE: cityFilter';
                }
            if(stateFilter != null && stateFilter != 'None'){
                query = query + ' AND MailingState =: stateFilter';
                }
                
            list<ID> hrsIDs = new list<ID>();
            list<ID> srsIDs = new list<ID>();
            for(Profile p: pList){
              if(p.Name.contains('HRS')){
          hrsIDs.add(p.ID);
                }
              else if(p.Name.contains('SRS')){
                srsIDs.add(p.ID);
                }    
        }    
            string khrsFilter = '';
            
            if(rhcIDs.contains(UserInfo.getProfileID())){
              List<ID> recordTypeRHC = AA_UtilityClass.getRHCAccountTypeIDs;
              query = query + ' AND Account.RecordTypeID IN : recordTypeRHC';
              }
            
            if(hrsIDs.contains(UserInfo.getProfileID())){
              khrsFilter = 'HRS';
              query = query + ' AND Account.KRS_RHB_Business_Unit__c =: khrsFilter';
              }
            if(srsIDs.contains(UserInfo.getProfileID())){
              khrsFilter = 'SRS';
              query = query + ' AND Account.KRS_RHB_Business_Unit__c =: khrsFilter';
              }    
            system.debug('query: ' + query);
            ctcList = database.query(query);
        for(Contact c: ctcList){
            conLstWrp.add(new listWrapper(c));
            }
        
        return conLstWrp;
        }
        
    @AuraEnabled(cacheable=true)
    public static list<listWrapper> getLeadItems(string searchStr, ID id, string cityFilter, string stateFilter){
        
        system.debug('City filter: ' + cityFilter);
        system.debug('State filter: ' + stateFilter);
         
        list<ID> rhcIDs = AA_UtilityClass.getAllRHCProfileIDs;
        
        list<listWrapper> leadlstWrp = new list<ListWrapper>();
        string sortStr = '';
        string sortVal = '';
        list<Lead> leadList = new list<Lead>();
        
            string searchID = id;   
            string query = 'SELECT ID, Name, Owner.Name, Company, Title, LeadSource, KRS_Source_Description__c, Phone, MobilePhone, Email, City, PostalCode, State, Street, RecordType.ID, RecordType.Name FROM Lead WHERE ID !=: searchID AND Name LIKE \'%'+ String.escapeSingleQuotes(searchStr) + '%\'';
            
            if(cityFilter != null  && cityFilter != ''){
                query = query + ' AND City LIKE: cityFilter';
                }
            if(stateFilter != null && stateFilter != 'None'){
                query = query + ' AND State =: stateFilter';
                }
                ID recordTypeHRS = AA_UtilityClass.getHRSLead;
              query = query + ' AND RecordTypeID =: recordTypeHRS';
              
            
            system.debug('query: ' + query);
            leadList = database.query(query);
        for(Lead l: leadList){
            leadLstWrp.add(new listWrapper(l));
            }
        
        return leadLstWrp;
        }    
    
    @AuraEnabled
    public static string getRequestMergeResult(list<string> checkedItems, ID accID, ID ctcID, ID leadId, string additionalInstruct, string objType){
        list<Account> toUpdateA = new list<Account>();
        list<Contact> toUpdateC = new list<Contact>();
        list<Lead> toUpdateL = new list<Lead>();
        list<Approval> toInsertA = new list<Approval>();
                
        ID objID;
        string result = '';
        system.debug('checkedItems: ' + checkedItems);
        system.debug('accID: ' + accID);
        system.debug('ctcID: ' + ctcID);
        system.debug('objType: ' + objType);
        if(accID != null && objType == 'account'){
            objID = accID;
            Account mWin = [SELECT ID, Name, Merge_Approved__c, Merge_Master__c, Merge_Requested__c, Merge_Request_With_Name__c, Merge_Requested_With_ID__c, Merge_requested_by__c FROM Account WHERE ID =: accID];
            mWin.Merge_Master__c = true;
            mWin.Merge_Requested__c = true;
            mWin.Merge_Requested_With_ID__c = accID;
            mWin.Merge_Request_With_Name__c = mWin.Name;
            mwin.Merge_Approved__c = true;
            mWin.Merge_requested_by__c = UserInfo.getName();
            
            update mWin;
            
            for(Account a : [SELECT ID, Name, Merge_Requested__c, Merge_Requested_With_ID__c, Merge_Request_With_Name__c, Merge_requested_by__c FROM Account WHERE ID In: checkedItems]){
                a.Merge_Requested__c = true;
                a.Merge_Requested_With_ID__c = objID;
                a.Merge_Request_With_Name__c = mWin.Name;
                a.Merge_requested_by__c = UserInfo.getName();
                update a;
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            
                req.setComments('A Merge has Been Requested for the following items.  ' +
                                'New master item: ' + mWin.Name 
                              + '.  Merged Record: ' + a.Name + '.  ' +
                                'Please review the items and approve or reject the request so it can be processed.  ' +
                                'If the requester has provided any additional comments they will appear here: ' + additionalInstruct);
                req.setObjectId(a.ID);
                system.debug('reqCheck'+req);
                // submit the approval request(s) for processing
                Approval.ProcessResult rslt = Approval.process(req);
                }
            result = 'Your request has been sent and will be processed.';   
            }
        if(ctcID != null && objType == 'contact'){
            objID = ctcID;
            Contact mWin = [SELECT ID, Name, Merge_Approved__c, Merge_Master__c, Merge_Requested__c, Merge_Request_With_Name__c, Merge_Requested_With_ID__c, Merge_requested_by__c FROM Contact WHERE ID =: ctcID];
            mWin.Merge_Master__c = true;
            mWin.Merge_Requested__c = true;
            mWin.Merge_Requested_With_ID__c = ctcID;
            mWin.Merge_Request_With_Name__c = mWin.Name;
            mwin.Merge_Approved__c = true;
            mWin.Merge_requested_by__c = UserInfo.getName();
            update mWin;
            
            for(Contact c : [SELECT ID, Name, Merge_Requested__c, Merge_Requested_With_ID__c, Merge_Request_With_Name__c, Merge_requested_by__c FROM Contact WHERE ID In: checkedItems]){
                c.Merge_Requested__c = true;
                c.Merge_Requested_With_ID__c = objID;
                c.Merge_Request_With_Name__c = mWin.Name;
                c.Merge_requested_by__c = UserInfo.getName();
                update c;
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            
                req.setComments('A Merge has Been Requested for the following items.  ' +
                                'New master item: ' + mWin.Name 
                              + '.  Merged Record: ' + c.Name + '.  ' +
                                'Please review the items and approve or reject the request so it can be processed.  ' +
                                'If the requester has provided any additional comments they will appear here: ' + additionalInstruct);
                req.setObjectId(c.ID);
                //req.setSubmitterId(system.Userinfo.getUserId());
                system.debug('reqCheck'+req);
                // submit the approval request for processing
                system.debug('Submitting Contact approval');
                Approval.ProcessResult rslt = Approval.process(req);
                }
            result = 'Your request has been sent and will be processed.';
            }
        if(leadId != null && objType == 'lead'){
            objID = leadId;
            Lead mWin = [SELECT ID, Name, Merge_Approved__c, Merge_Master__c, Merge_Requested__c, Merge_Request_With_Name__c, Merge_Requested_With_ID__c, Merge_requested_by__c FROM Lead WHERE ID =: leadId];
            mWin.Merge_Master__c = true;
            mWin.Merge_Requested__c = true;
            mWin.Merge_Requested_With_ID__c = leadId;
            mWin.Merge_Request_With_Name__c = mWin.Name;
            mwin.Merge_Approved__c = true;
            mWin.Merge_requested_by__c = UserInfo.getName();
            update mWin;
            
            for(Lead lea : [SELECT ID, Name, Merge_Requested__c, Merge_Requested_With_ID__c, Merge_Request_With_Name__c, Merge_requested_by__c FROM Lead WHERE ID In: checkedItems]){
                lea.Merge_Requested__c = true;
                lea.Merge_Requested_With_ID__c = objID;
                lea.Merge_Request_With_Name__c = mWin.Name;
                lea.Merge_requested_by__c = UserInfo.getName();
                update lea;
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            
                req.setComments('A Merge has Been Requested for the following items.  ' +
                                'New master item: ' + mWin.Name 
                              + '.  Merged Record: ' + lea.Name + '.  ' +
                                'Please review the items and approve or reject the request so it can be processed.  ' +
                                'If the requester has provided any additional comments they will appear here: ' + additionalInstruct);
                req.setObjectId(lea.ID);
                //req.setSubmitterId(system.Userinfo.getUserId());
                system.debug('reqCheck'+req);
                // submit the approval request for processing
                system.debug('Submitting Contact approval');
                Approval.ProcessResult rslt = Approval.process(req);
                }
            result = 'Your request has been sent and will be processed.';
            }    
        return result;
        }
                   
    @AuraEnabled
    public static boolean evalBusUnits(boolean isKRS, string busUnit){
      system.debug('isKRS: ' + isKRS);
      system.debug('busUnit: ' + busUnit);
      
      boolean busUnitCorrect = false;
      list<ID> hrsIDs = new list<ID>();
        list<ID> srsIDs = new list<ID>();
            for(Profile p: pList){
              if(p.Name.contains('HRS')){
          hrsIDs.add(p.ID);
                }
              else if(p.Name.contains('SRS')){
                srsIDs.add(p.ID);
                }    
        }
      if(isKRS == false){
        busUnitCorrect = true;
        }
      else if(isKRS == true){
        if(hrsIDs.contains(UserInfo.getProfileID()) && busUnit == 'HRS'){
          busUnitCorrect = true;  
          }
        else if(srsIDs.contains(UserInfo.getProfileID()) && busUnit == 'SRS'){
          busUnitCorrect = true;
          }
        else{
          busUnitCorrect = false;
          }    
        }  
      return busUnitCorrect;
      }
}