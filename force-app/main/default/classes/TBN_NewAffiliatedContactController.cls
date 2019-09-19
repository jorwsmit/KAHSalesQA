public without sharing class TBN_NewAffiliatedContactController {
    
    private string strUnassignedUser; 
    private static final String strCreatePractiseConst = 'Create Practice of ';
    private final string TEMPLATE_NAME = Label.Email_Notification_For_Practice_Account; 
    
    public Contact objCurrentContact {get;set;}               // List to store current Contact details ---remove the list
    private Id strCurrentContactId;                              // Stores the id of Contact from where the page is launched
    public List<WrapperPracticeAccount> lstWrapperPracticeAccount {get;set;} // list of wrapper object to store the Account details and display on page
    public String strSelectedAccount                              {get;set;} // stores the selected Account to create Practice Account
    public Contact objNewContact                                  {get;set;} // New contact to be inserted
    public ID objNewAccount                                  {get;set;}
    public Boolean isFormDisplay                                  {get;set;}
    
    public list<AccountTeamMember> lstAccountTeamsToInsert	{get;set;}
        // List to hold the Account Share records to insert
    public list<AccountShare> lstAccountShareToInsert	{get;set;} 
        //list to store the emails which is sent to Contact owner.
    public transient list<Messaging.SingleEmailMessage> lstEmails = new list<Messaging.SingleEmailMessage>();
    	//store contact records when user is adding multiple contacts at once
    public list<Contact> ctcsToInsert	{get;set;}
    
    public boolean showAccount	{get;set;}
    public boolean showContact	{get;set;}
    public boolean accountCreated	{get;set;}
    
    public Account objNewPracticeAcc	{get;set;}
    
    // Constructor
    public TBN_NewAffiliatedContactController() {
    
        if( apexpages.currentPage().getParameters().containsKey('id') && 
                String.isNotBlank( (String)apexpages.currentPage().getParameters().get('id') ) ) {
            
            init();
            
            // method will initialize a list of Accounts to display on page              
            displayAccountOptions(objCurrentContact);
            
            isFormDisplay = true;
        }
        else {
            
            isFormDisplay = false;
        }
    }
    
    /* Wrapper class to hold account Id and address of Accounts to display on page */
    public class WrapperPracticeAccount {
        
        public String acctId            { get; set; }
        public String Name              { get; set; }
        public String acctCity          { get; set; }
        public String acctStreet        { get; set; }
        public String acctState         { get; set; }
        public String acctPostalcode    { get; set; }
        public boolean isCurrentAcct    { get; set; }
        
        public WrapperPracticeAccount(String acctId, String Name, String acctStreet, String acctCity, String acctState, String acctPostalcode, Boolean isCurrentAcct) {
            
            this.acctId = acctId;
            this.Name = Name;
            this.acctCity = acctCity;
            this.acctStreet = acctStreet;
            this.acctState = acctState;
            this.acctPostalcode = acctPostalcode;
            this.isCurrentAcct = isCurrentAcct;
        }
        
        public WrapperPracticeAccount(String acctId, String Name) {
            
            this.acctId = acctId;
            this.Name = Name;
        }
    }
    
     /* Wrapper class to hold email notification information */
     public class EmailNotificationsInfo {
        
        private String strUserId;
        private String strUserEmail;
        private String strUserName;
        
        public EmailNotificationsInfo(String strUserId, String strUserEmail, String strUserName) {
            
             this.strUserId = strUserId;
             this.strUserEmail = strUserEmail;
             this.strUserName = strUserName;
        }
     }
    
    /*
        MethodName : init
        Parameters : None
        Description: This method is used to initialize the variables used in the class
    */  
    public void init() {
        lstAccountTeamsToInsert = new List<AccountTeamMember>();
        ctcsToInsert = new list<Contact>();
    	lstAccountShareToInsert = new List<AccountShare>(); 
        showContact = false;
    	showAccount = true;
        
        strCurrentContactId = apexpages.currentPage().getParameters().get('id');
        objCurrentContact = new Contact();
        objNewContact = new Contact();
        strSelectedAccount = '';
        lstWrapperPracticeAccount = new List<WrapperPracticeAccount>();
        
        objCurrentContact = [ SELECT Id, Name, FirstName, LastName, OwnerId, Owner.Name, Owner.Email, MailingStreet, MailingState, MailingPostalCode, MailingCountry, 
                                     MailingCity, AccountId, Account.Name, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingPostalCode,
                                     Account.Is_Practice_Account__c, Account.Owner.Name
                              FROM   Contact 
                              WHERE  Id = : strCurrentContactId ];
                              
        List<Email_Notification_On_Merge__c> lstSettings = [  SELECT Name, Is_Practice_Account_Owner__c 
                                                              FROM Email_Notification_On_Merge__c
                                                              WHERE Is_Practice_Account_Owner__c = true limit 1];
        
        if( !lstSettings.isEmpty() ) {                                                
         
            strUnassignedUser = lstSettings[0].Name;
        }
        
    }
    
    /*
        Method Name: createPracticeAccount
        Parameters : None
        Description: Method will create a new' Practice Account' for current Contact , inserts a new Contact and changes the Account of the Current contact to 'Practice Account'
    */
    public void createPracticeAccount(){
        objNewPracticeAcc = new Account();
        String strAccountName = '';
        lstEmails = new list<Messaging.SingleEmailMessage>();
        // temporary contact instance
        Contact objContactTemp = objCurrentContact;
        
        String strAcctNameString = '';
        
        try {
        
            /* when user selects create new Practice Account option, then inserting new Practice Account, new Contact and copying Contact Teams To Account Teams and updating current Contact's Account
             to new Practice Account */
            if(strSelectedAccount == 'New Account') {
                
                RecordType objRecordType = [SELECT Id, Name, DeveloperName  
                                            FROM RecordType 
                                            WHERE sobjectType = 'Account' AND 
                                                    DeveloperName = 'Referring_Facility_Child' limit 1];
                
                if(objCurrentContact.FirstName != null){
                    strAcctNameString = objCurrentContact.LastName+', '+objCurrentContact.FirstName+' ';
                	}
                else{
                    strAcctNameString = objCurrentContact.LastName+' ';
                	}
                strAcctNameString += '[Practice]';

				if(AccountCreated != true){
                // To hold new Practice Account instance
                objNewPracticeAcc = new Account( Name = strAcctNameString, 
                                                         Is_Practice_Account__c = true,
                                                         OwnerId = strUnassignedUser,
                                                         RecordTypeId = objRecordType.Id,
                                                         ShippingStreet = objCurrentContact.MailingStreet,
                                                         ShippingCity = objCurrentContact.MailingCity,
                                                         ShippingState = objCurrentContact.MailingState,
                                                         ShippingPostalCode = objCurrentContact.MailingPostalCode,
                                                         ShippingCountry = objCurrentContact.MailingCountry);
                insert objNewPracticeAcc;
				accountCreated = true;
				}
                try{
                	objNewContact.AccountId = objNewPracticeAcc.Id;
                	}
                catch(Exception E){
                	objNewPracticeAcc = new Account( Name = strAcctNameString, 
                                                         Is_Practice_Account__c = true,
                                                         OwnerId = strUnassignedUser,
                                                         RecordTypeId = objRecordType.Id,
                                                         ShippingStreet = objCurrentContact.MailingStreet,
                                                         ShippingCity = objCurrentContact.MailingCity,
                                                         ShippingState = objCurrentContact.MailingState,
                                                         ShippingPostalCode = objCurrentContact.MailingPostalCode,
                                                         ShippingCountry = objCurrentContact.MailingCountry);
                insert objNewPracticeAcc;
				accountCreated = true;
				objNewContact.AccountId = objNewPracticeAcc.Id;
                	}	
                objContactTemp = new Contact(Id = objCurrentContact.Id, AccountId = objNewPracticeAcc.Id );
                
                /* iterating over the contact team members to create account team members for the new Practice Account*/
               for(Contact_Team__c objContactTeam : [ SELECT User__c, Contact__c, User__r.Email 
                                                       FROM Contact_Team__c 
                                                       WHERE Contact__c =: objCurrentContact.Id ]) {
                                                         
                    lstAccountTeamsToInsert.add( new AccountTeamMember( UserId = objContactTeam.User__c, 
                                                                        AccountId = objNewPracticeAcc.Id));
                                                                        
                    // Assign the object permissions for selected user
                    lstAccountShareToInsert.add(new AccountShare(   AccountId =  objNewPracticeAcc.Id,
                                                                    UserOrGroupId = objContactTeam.User__c,
                                                                    ContactAccessLevel = 'Read',
                                                                    OpportunityAccessLevel = 'None',
                                                                    AccountAccessLevel = 'Edit',
                                                                    CaseAccessLevel = 'Read' ));
                     
                  
                } 
                
                if(!lstAccountTeamsToInsert.isEmpty()){
                	insert lstAccountTeamsToInsert;
                	}
                if(!lstAccountShareToInsert.isEmpty())
                    insert lstAccountShareToInsert;
                	}
            else{
                /* when user selects other Account as 'Practice Account' then inserting a new Contact and updating current Contact's Account to selected Account*/
                objNewContact.AccountId = strSelectedAccount == '' ? objCurrentContact.AccountId : strSelectedAccount;
                objContactTemp = new Contact(Id = objCurrentContact.Id, AccountId = strSelectedAccount == '' ? objCurrentContact.AccountId : strSelectedAccount );
            	}
            
             objNewContact.MailingStreet = objCurrentContact.MailingStreet;
             objNewContact.MailingCity = objCurrentContact.MailingCity;
             objNewContact.MailingState = objCurrentContact.MailingState;
             objNewContact.MailingPostalCode = objCurrentContact.MailingPostalCode;
             objNewContact.MailingCountry = objCurrentContact.MailingCountry;
            
            // inserting a new Contact
            if(objNewContact.id != null){
            	objNewContact.id = null;
            	}
            insert objNewContact;
            
            // updating AccountId of current Contact
            update objContactTemp;
            
            strAccountName = [ Select Name From Account where Id = : objContactTemp.AccountId].Name;
            
            if(String.isNotBlank(strSelectedAccount)){
            
                // Sending email to the Contact's owner to notify about Account change
                EmailTemplate objEmailTemplate = [SELECT id, HtmlValue, Body, Subject FROM EmailTemplate WHERE DeveloperName =: TEMPLATE_NAME];
                
                // Map containing email notifications information
                Map<String, EmailNotificationsInfo> mapEmailNotificationsInfo = fetchEmailDetails();
                
                String senderEmail = (String.isNotBlank(Label.Sending_User_Email_on_Records_Merge)) ? 
                                        Label.Sending_User_Email_on_Records_Merge : UserInfo.getUserEmail();
                                        
                // Iterate over email information and form emails to be sent
                for(EmailNotificationsInfo objEmailNotificationsInfo : mapEmailNotificationsInfo.values()){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String baseURL = 'https://'+System.URL.getSalesforceBaseURL().getHost() +'/';
                    
                    String htmlBody = objEmailTemplate.HtmlValue
                                                    .replace('##ContactOwnerName##', objEmailNotificationsInfo.strUserName)
                                                    .replace('##contactName##', '<b>'+objCurrentContact.Name+'</b>' )
                                                    .replace('##newAccountName##', '<b>'+strAccountName+'</b>')
                                                    .replace('##ContactLink##', (baseURL + objCurrentContact.Id));
                                                    
                    mail.setHtmlBody( htmlBody );
                    mail.setSubject( objEmailTemplate.Subject );
                    mail.setTargetObjectId( objEmailNotificationsInfo.strUserId );
                    mail.setSaveAsActivity( false );
                    lstEmails.add( mail ); 
                	}
                
                // Sends the email
                if(!lstEmails.isEmpty()){
                    Messaging.sendEmail(lstEmails);
                	}
            	}
        	}
        catch(System.DmlException ex){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(ex.getdmlMessage(0) + 'Line: ' + ex.getLineNumber())));
        	}
    	}
    
    public void createContactOnly(){
    	lstEmails = new list<Messaging.SingleEmailMessage>();
        // temporary contact instance
        Contact objContactTemp = objCurrentContact;
        
        String strAcctNameString = '';
        
        try {
        
            /* when user selects other Account as 'Practice Account' then inserting a new Contact only*/
            try{
                objNewContact.AccountId = strSelectedAccount == '' ? objCurrentContact.AccountId : strSelectedAccount;
            	objContactTemp = new Contact(Id = objCurrentContact.Id, AccountId = strSelectedAccount == '' ? objCurrentContact.AccountId : strSelectedAccount );
            	}
            catch(Exception E){
            	Account a = new Account(Name = 'Practice of ' + objContactTemp.FirstName + ' ' + objContactTemp.LastName);
            	insert a;
            	objNewContact.AccountId = a.ID;
            	objContactTemp = new Contact(Id = objCurrentContact.Id, AccountId = a.Id );
            	}	
                
            	
            
             objNewContact.MailingStreet = objCurrentContact.MailingStreet;
             objNewContact.MailingCity = objCurrentContact.MailingCity;
             objNewContact.MailingState = objCurrentContact.MailingState;
             objNewContact.MailingPostalCode = objCurrentContact.MailingPostalCode;
             objNewContact.MailingCountry = objCurrentContact.MailingCountry;
            
            // inserting a new Contact
            if(objNewContact.id != null){
            	objNewContact.id = null;
            	}
            insert objNewContact;
            
            // updating AccountId of current Contact
            update objContactTemp;
            
            string strAccountName = [ Select Name From Account where Id = : objContactTemp.AccountId].Name;
            
            if(String.isNotBlank(strSelectedAccount)){
            
                // Sending email to the Contact's owner to notify about Account change
                EmailTemplate objEmailTemplate = [SELECT id, HtmlValue, Body, Subject FROM EmailTemplate WHERE DeveloperName =: TEMPLATE_NAME];
                
                // Map containing email notifications information
                Map<String, EmailNotificationsInfo> mapEmailNotificationsInfo = fetchEmailDetails();
                
                String senderEmail = (String.isNotBlank(Label.Sending_User_Email_on_Records_Merge)) ? 
                                        Label.Sending_User_Email_on_Records_Merge : UserInfo.getUserEmail();
                                        
                // Iterate over email information and form emails to be sent
                for(EmailNotificationsInfo objEmailNotificationsInfo : mapEmailNotificationsInfo.values()){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String baseURL = 'https://'+System.URL.getSalesforceBaseURL().getHost() +'/';
                    
                    String htmlBody = objEmailTemplate.HtmlValue
                                                    .replace('##ContactOwnerName##', objEmailNotificationsInfo.strUserName)
                                                    .replace('##contactName##', '<b>'+objCurrentContact.Name+'</b>' )
                                                    .replace('##newAccountName##', '<b>'+strAccountName+'</b>')
                                                    .replace('##ContactLink##', (baseURL + objCurrentContact.Id));
                                                    
                    mail.setHtmlBody( htmlBody );
                    mail.setSubject( objEmailTemplate.Subject );
                    mail.setTargetObjectId( objEmailNotificationsInfo.strUserId );
                    mail.setSaveAsActivity( false );
                    lstEmails.add( mail ); 
                	}
                
                // Sends the email
                if(!lstEmails.isEmpty()){
                    Messaging.sendEmail(lstEmails);
                	}
            	}
        	}
        catch(System.DmlException ex){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(ex.getdmlMessage(0) + 'Line: ' + ex.getLineNumber())));
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ' You need to at least fill in a last name for a Contact if choosing to Save and Finish'));
        	}
    	}
        
    //For when a user has no additional soft contacts to add during the process.
    public PageReference createPracticeAccountWithout(){
    			createPracticeAccountAlt();
    			PageReference retURL = new PageReference('/'+objNewAccount);
      			retURL.setRedirect(true);
      			return retURL;       		
        }	
    
    /*
    Method is utilized when user wants to skip creating additional contacts for the practice Account and have only the one added, 
    or be able to return to the process later rather than being forced to create a new contact to proceed.     
    */
    public void createPracticeAccountAlt(){
        String strAccountName = '';
        lstEmails = new list<Messaging.SingleEmailMessage>();
        // temporary contact instance
        Contact objContactTemp = objCurrentContact;
        String strAcctNameString = '';
        try {
            /* when user selects create new Practice Account option, then inserting new Practice Account, new Contact and copying Contact Teams To Account Teams and updating current Contact's Account
             to new Practice Account */
            if(strSelectedAccount == 'New Account') {
                RecordType objRecordType = [SELECT Id, Name, DeveloperName  
                                            FROM RecordType 
                                            WHERE sobjectType = 'Account' AND 
                                                    DeveloperName = 'Referring_Facility_Child' limit 1];
                if(objCurrentContact.FirstName != null){
                    strAcctNameString = objCurrentContact.LastName+', '+objCurrentContact.FirstName+' ';
               	 	}
                else{
                    strAcctNameString = objCurrentContact.LastName+' ';
                	}
                strAcctNameString += '[Practice]';

                // To hold new Practice Account instance
                Account objNewPracticeAcc = new Account( Name = strAcctNameString, 
                                                         Is_Practice_Account__c = true,
                                                         OwnerId = strUnassignedUser,
                                                         RecordTypeId = objRecordType.Id,
                                                         ShippingStreet = objCurrentContact.MailingStreet,
                                                         ShippingCity = objCurrentContact.MailingCity,
                                                         ShippingState = objCurrentContact.MailingState,
                                                         ShippingPostalCode = objCurrentContact.MailingPostalCode,
                                                         ShippingCountry = objCurrentContact.MailingCountry);
                insert objNewPracticeAcc;
                objNewAccount = objNewPracticeAcc.ID;
                
                objContactTemp = new Contact(Id = objCurrentContact.Id, AccountId = objNewPracticeAcc.Id );
                
                /* iterating over the contact team members to create account team members for the new Practice Account*/
               for(Contact_Team__c objContactTeam : [ SELECT User__c, Contact__c, User__r.Email 
                                                       FROM Contact_Team__c 
                                                       WHERE Contact__c =: objCurrentContact.Id ]) {
                                                         
                    lstAccountTeamsToInsert.add( new AccountTeamMember( UserId = objContactTeam.User__c, 
                                                                        AccountId = objNewPracticeAcc.Id));
                                                                        
                    // Assign the object permissions for selected user
                    lstAccountShareToInsert.add(new AccountShare(   AccountId =  objNewPracticeAcc.Id,
                                                                    UserOrGroupId = objContactTeam.User__c,
                                                                    ContactAccessLevel = 'Read',
                                                                    OpportunityAccessLevel = 'None',
                                                                    AccountAccessLevel = 'Edit',
                                                                    CaseAccessLevel = 'Read' ));
                     
                  
                } 
                
                if(!lstAccountTeamsToInsert.isEmpty())
                    insert lstAccountTeamsToInsert;
                    
                if(!lstAccountShareToInsert.isEmpty())
                    insert lstAccountShareToInsert;
                
            }
            else{
                /* when user selects other Account as 'Practice Account' then inserting a new Contact and updating current Contact's Account to selected Account*/
                objContactTemp = new Contact(Id = objCurrentContact.Id, AccountId = strSelectedAccount == '' ? objCurrentContact.AccountId : strSelectedAccount );
            	}
            
            // updating AccountId of current Contact
            update objContactTemp;
            objNewAccount =  objContactTemp.AccountId;
            strAccountName = [ Select Name From Account where Id = : objContactTemp.AccountId].Name;
            
            if( String.isNotBlank(strSelectedAccount) ) {
                // Sending email to the Contact's owner to notify about Account change
                EmailTemplate objEmailTemplate = [SELECT id, HtmlValue, Body, Subject FROM EmailTemplate WHERE DeveloperName =: TEMPLATE_NAME];
                
                // Map containing email notifications information
                Map<String, EmailNotificationsInfo> mapEmailNotificationsInfo = fetchEmailDetails();
                
                String senderEmail = (String.isNotBlank(Label.Sending_User_Email_on_Records_Merge)) ? 
                                        Label.Sending_User_Email_on_Records_Merge : UserInfo.getUserEmail();
                                        
                // Iterate over email information and form emails to be sent
                for(EmailNotificationsInfo objEmailNotificationsInfo : mapEmailNotificationsInfo.values()){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String baseURL = 'https://'+System.URL.getSalesforceBaseURL().getHost() +'/';
                    
                    String htmlBody = objEmailTemplate.HtmlValue
                                                    .replace('##ContactOwnerName##', objEmailNotificationsInfo.strUserName)
                                                    .replace('##contactName##', '<b>'+objCurrentContact.Name+'</b>' )
                                                    .replace('##newAccountName##', '<b>'+strAccountName+'</b>')
                                                    .replace('##ContactLink##', (baseURL + objCurrentContact.Id));
                                                    
                    mail.setHtmlBody( htmlBody );
                    mail.setSubject( objEmailTemplate.Subject );
                    //mail.setReplyTo( senderEmail );
                    mail.setTargetObjectId( objEmailNotificationsInfo.strUserId );
                    mail.setSaveAsActivity( false );
                    lstEmails.add( mail ); 
                	}
                
                // Sends the email
               if(!lstEmails.isEmpty()){
            	   Messaging.sendEmail(lstEmails);
               	}
            }
        }
        catch(System.DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(ex.getdmlMessage(0))));
        	}
        }
    
    
    /*
        Method Name: displayAccountOptions
        Parameters : 
        Description: This method is called onload of page, to display a list of Accounts to be selected to clear Practice Account
    */
    private void displayAccountOptions(Contact objCurrentContactLocal) {
        
        // variables to hold the Current contact Address field values
        String mailingStreet, mailingCity, mailingState, mailingCountry, mailingPostalCode, strAcctAddrs = '';
        
        // map which stores the value of CS which has configuration to indicate whether mail has 
        Map<string, Email_Notification_On_Merge__c> mapUserToBeNotified = Email_Notification_On_Merge__c.getAll();
        
        try
        {
             // if a current Conatct's Account is Practice Account then on page current Account is displayed with radio button selected by default
                
            lstWrapperPracticeAccount.add( new WrapperPracticeAccount(objCurrentContactLocal.AccountId, 
                                                                      objCurrentContactLocal.Account.Name, 
                                                                      objCurrentContactLocal.Account.ShippingStreet == null?'':objCurrentContactLocal.Account.ShippingStreet,
                                                                      objCurrentContactLocal.Account.ShippingCity == null?'':objCurrentContactLocal.Account.ShippingCity+',',
                                                                      objCurrentContactLocal.Account.ShippingState == null?'':objCurrentContactLocal.Account.ShippingState,
                                                                      objCurrentContactLocal.Account.ShippingPostalCode == null?'':objCurrentContactLocal.Account.ShippingPostalCode,
                                                                      true));
                
        
            if( objCurrentContactLocal.MailingStreet != null || 
                objCurrentContactLocal.MailingCity != null || 
                objCurrentContactLocal.MailingState != null || 
                objCurrentContactLocal.MailingCountry != null ||
                objCurrentContactLocal.MailingPostalCode != null ) {
            
                    mailingStreet = objCurrentContactLocal.MailingStreet;
                    mailingCity = objCurrentContactLocal.MailingCity;
                    mailingState = objCurrentContactLocal.MailingState;
                    mailingCountry = objCurrentContactLocal.MailingCountry;
                    mailingPostalCode = objCurrentContactLocal.MailingPostalCode;
                    
                    /* searching all the Accounts which exactly match the current Contact address and storing it in a wrapper list to display in page*/
                    for(Account objAcc : [SELECT Name, ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity 
                                          FROM  Account
                                          WHERE ShippingStreet =: mailingStreet AND
                                                ShippingState = : mailingState AND
                                                ShippingPostalCode = : mailingPostalCode AND
                                                ShippingCountry = : mailingCountry AND
                                                ShippingCity = : mailingCity AND
                                                Id <> : objCurrentContactLocal.AccountId AND
                                                OwnerId <> : strUnassignedUser limit 100]) {
                                 
                        lstWrapperPracticeAccount.add(new WrapperPracticeAccount(objAcc.Id,
                                                                                 objAcc.Name,
                                                                                 objAcc.ShippingStreet == null?'':objAcc.ShippingStreet,
                                                                                 objAcc.ShippingCity == null?'':objAcc.ShippingCity+',',
                                                                                 objAcc.ShippingState == null?'':objAcc.ShippingState,
                                                                                 objAcc.ShippingPostalCode == null?'':objAcc.ShippingPostalCode,
                                                                                 false ));
                    }
              }
            
            if( !objCurrentContact.Account.Is_Practice_Account__c ) 
                lstWrapperPracticeAccount.add( new WrapperPracticeAccount('New Account', strCreatePractiseConst+objCurrentContactLocal.Name));
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(ex.getMessage() )));
        }
    }
    
     /*
        Method Name: fetchEmailDetails
        Parameters : None
        Description: Send email to Contact owner during the reparenting of Contact as a result of 'Practice Account' creation
                    In case of  Contact owner saved in 'Email_Notification_On_Merge__c' CS havnig 'Notify_Members__c' set to true, emails will be sent to Contact team members.
                    In case of  Contact owner saved in 'Email_Notification_On_Merge__c' CS havnig 'Send_Emails__c' set to true, emails will be sent to owner itself.
                    
    */
    private Map<String, EmailNotificationsInfo> fetchEmailDetails() {
        
        Map<String, EmailNotificationsInfo> mapToReturn = new Map<String, EmailNotificationsInfo>();
        
        Map<string, Email_Notification_On_Merge__c> mapUserToBeNotified = Email_Notification_On_Merge__c.getAll();
        
        try
        {
            if( mapUserToBeNotified.containsKey( ((String)objCurrentContact.OwnerId).substring(0,15) ) ) {
                
                /* if owner Id is present in CS and its Notify_Members__c is true, send email to all the user in Contact Team Member */
                if( mapUserToBeNotified.get( ( (String)objCurrentContact.OwnerId ).substring(0,15) ).Notify_Members__c ) {
                    
                    for(Contact_Team__c objContactTeam : [ SELECT User__c, Contact__c, User__r.Email, User__r.Name
                                                           FROM Contact_Team__c 
                                                           WHERE Contact__c =: objCurrentContact.Id ]) {
                    
                        mapToReturn.put( objContactTeam.User__c, new EmailNotificationsInfo(objContactTeam.User__c, objContactTeam.User__r.Email, objContactTeam.User__r.Name ) );
                    }
                }
                
                /* if send email in CS is true then send email to the owner */
                if(  mapUserToBeNotified.get( ( (String)objCurrentContact.OwnerId ).substring(0,15) ).Send_Emails__c && !mapToReturn.containsKey( objCurrentContact.OwnerId ) )
                     mapToReturn.put( objCurrentContact.OwnerId, new EmailNotificationsInfo( objCurrentContact.OwnerId, objCurrentContact.Owner.Email, objCurrentContact.Owner.Name ));
            }
            else /* if owner id is not present in CS, then send email to that user */
                mapToReturn.put( objCurrentContact.OwnerId, new EmailNotificationsInfo( objCurrentContact.OwnerId, objCurrentContact.Owner.Email, objCurrentContact.Owner.Name ));
            
            return mapToReturn;
        }
        catch(Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(ex.getMessage() )));
            return null;
        }
    }
    
    public void dummyCancel() {
    }
    	
    	public void showContactPanel(){
    		showContact = true;
    		showAccount = false;
    		}
    		
    	public void showAccountPanel(){
    		showContact = false;
    		showAccount = true;
    		}	
    	
}