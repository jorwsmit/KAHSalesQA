public with sharing class TBN_EmailNotificationonRecordMerge {
    
    private final string TEMPLATE_NAME = Label.Email_Template_Name_For_Merge_Notifications;             //string to store the name of the HTML template.
	private final EmailTemplate objEmailTemplate = [SELECT id, HtmlValue, Body, Subject FROM EmailTemplate WHERE DeveloperName =: TEMPLATE_NAME];
    //constructor
    public TBN_EmailNotificationonRecordMerge() {
        
        // Do Nothing
    }
    
    public class EmailNotificationsInfo {
        
        private String strUserId;
        private String strOwnerName;
        private String strUserEmail;
        private String strChildRecordsInfo;
        private String strMasterRecordId;
        
        // Constructor to initialize parameters passed
        public EmailNotificationsInfo(String strUserId, String strOwnerName, String strUserEmail, String strChildRecordsInfo, String strMasterRecordId) {
            
            this.strUserId = strUserId;
            this.strOwnerName = strOwnerName;
            this.strUserEmail = strUserEmail;
            this.strMasterRecordId = strMasterRecordId;
            this.strChildRecordsInfo = strChildRecordsInfo;
        }
    }
    
    /*
    Method Name: sendEmailNotification
    Parameters : set<Id> setSobjects - Set of child records(Accounts/Contacts) Ids merged and deleted 
                 string strsObjectName - Identifies the type of SObject - Account/Contact
    Description: To send an Email alert on merge of Account/Contact records to the merged acount/contact owner. 
                 In case of users saved in 'Email_Notification_On_Merge__c' CS havnig 'Notify_Members__c' set to true, emails will be sent to Account/Contact team members.
                 In case of users saved in 'Email_Notification_On_Merge__c' CS havnig '' set to true, emails will be sent to Account/Contact team members.
                 In case of users saved in 'Email_Notification_On_Merge__c' CS havnig 'Notify_Members__c' set to true, emails will be sent to Account/Contact team members.
    */
    
    public void sendEmailNotification( Map<Id, SObject> mapSobjects, string strsObjectName ) {
        
        try {
            
            //list to store the emails which is sent to merged record owner.
            list<Messaging.SingleEmailMessage> lstEmails = new list<Messaging.SingleEmailMessage>();
            
            // Map containing email notifications information
            Map<String, EmailNotificationsInfo> mapEmailNotificationsInfo = fetchEmailDetails( mapSobjects, strsObjectName );
            
            String senderEmail = (String.isNotBlank(Label.Sending_User_Email_on_Records_Merge)) ? 
                                    Label.Sending_User_Email_on_Records_Merge : UserInfo.getUserEmail();
            
            // Iterate over email information and form emails to be sent
            for( EmailNotificationsInfo objEmailNotificationsInfo: mapEmailNotificationsInfo.values() ) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                String baseURL = 'https://'+System.URL.getSalesforceBaseURL().getHost() +'/';
                String htmlBody = objEmailTemplate.HtmlValue
                                            .replace('##UserName##', objEmailNotificationsInfo.strOwnerName)
                                            .replace('##MasterLink##', (baseURL + objEmailNotificationsInfo.strMasterRecordId))
                                            .replace('##ChildRecords##', objEmailNotificationsInfo.strChildRecordsInfo);
                                            
                mail.setHtmlBody(htmlBody);
                mail.setSubject(objEmailTemplate.Subject);
                mail.setReplyTo( senderEmail );
                mail.setTargetObjectId( objEmailNotificationsInfo.strUserId );
                mail.setSaveAsActivity(false);
                lstEmails.add(mail); 
            }

            // Sends the email
            if(!lstEmails.isEmpty())
                Messaging.sendEmail(lstEmails); 
        }
        catch(Exception Ex) {
            
            system.debug('Exception Occured: ' + Ex.getMessage() + ' on line '+Ex.getLineNumber());
        }
    }
    
    /*
    Method Name: sendEmailNotification
    Parameters : set<Id> setSobjects - Set of child records(Accounts/Contacts) Ids merged and deleted 
                 string strsObjectName - Identifies the type of SObject - Account/Contact
    Description: To send an Email alert on merge of Account/Contact records to the merged acount/contact owner. 
                 In case of users saved in 'Email_Notification_On_Merge__c' CS havnig 'Notify_Members__c' set to true, emails will be sent to Account/Contact team members.
                 In case of users saved in 'Email_Notification_On_Merge__c' CS havnig '' set to true, emails will be sent to Account/Contact team members.
                 In case of users saved in 'Email_Notification_On_Merge__c' CS havnig 'Notify_Members__c' set to true, emails will be sent to Account/Contact team members.
    */
    
    private Map<String, EmailNotificationsInfo> fetchEmailDetails( Map<Id, SObject> mapSobjects, string strsObjectName ) {
        
        // Map containing email notifications information
        Map<String, EmailNotificationsInfo> mapEmailNotificationsInfo = new Map<String, EmailNotificationsInfo>();
            
        try {
            
            Set<Id> setUsers_HasNotifyMembers = new Set<Id>();
            map<Id, set<Id>> mapUserIdToSobject = new map<Id, set<Id>>();
            
            // map to store Email_Notification_On_Merge__c custom setting values which indicates users to be notified when record merge happens
            Map<string, Email_Notification_On_Merge__c> mapUserToBeNotified = Email_Notification_On_Merge__c.getAll(); 

            set<Id> setSobjectIdKeys = mapSobjects.keyset();
            map<id, sObject> mapMergedsObjects = new Map<Id, sObject> (database.query(  'SELECT Id, MasterRecordId, Name, Owner.Email, ' + 
                                                                                            'OwnerId, Owner.FirstName, Owner.LastName '+
                                                                                        ' FROM ' + strsObjectName + 
                                                                                        ' WHERE Id IN: setSobjectIdKeys '+
                                                                                        ' ALL ROWS' ));
            
            // Blank check to verify records are present in the set passed
            if(!mapSobjects.isEmpty()) {
                
                for(Email_Notification_On_Merge__c objEmailNotifications : mapUserToBeNotified.values()) {
                    
                    // Identifying the users having Notify Members settings marked as true
                    if(objEmailNotifications.Notify_Members__c) {
                        
                        setUsers_HasNotifyMembers.add(objEmailNotifications.Name);
                    }
                }
            
                if( strsObjectName == 'Account' ) {
                    
                    // Querying ATM records with Accounts being merged(passed to method as a parameter)
                        // and where Account Owner has settings to Notify Members
                    for(AccountTeamMember objAccTeamMember : [  SELECT Id, AccountId, Account.Name,
                                                                        UserId, User.FirstName, User.LastName, User.Email
                                                                FROM AccountTeamMember 
                                                                WHERE AccountId IN: mapSobjects.keyset() AND
                                                                      Account.OwnerId IN: setUsers_HasNotifyMembers
                                                                ALL ROWS ]) {
                                                                
                        String strUserId = ((String)objAccTeamMember.UserId).substring(0, 15);
                        
                        // Filter users either not mentioned in CS or having Send Email permissions                                         
                        if( (!mapUserToBeNotified.containsKey( strUserId )  || 
                                ( mapUserToBeNotified.containsKey( strUserId ) && 
                                  mapUserToBeNotified.get( strUserId ).Send_Emails__c) ) && 
                            (!mapUserIdToSobject.containsKey(strUserId) || 
                                ( mapUserIdToSobject.containsKey(strUserId) && 
                                  !mapUserIdToSobject.get(strUserId).contains(objAccTeamMember.AccountId) ) )  ) {
                                        
                            if(mapUserIdToSobject.containsKey(strUserId))
                                mapUserIdToSobject.get(strUserId).add(objAccTeamMember.AccountId);
                            else
                                mapUserIdToSobject.put(strUserId, new set<Id>{objAccTeamMember.AccountId} );
                            
                                    
                            EmailNotificationsInfo objEmailNotificationsInfo;
                            String strATMChildRecordsInfo = '<span style="padding-left: 25px; margin-left: 25px;"> - ' + 
                                                                    objAccTeamMember.Account.Name + '</span>';
                            
                            if( mapEmailNotificationsInfo.containsKey(strUserId) ) {
                                
                                objEmailNotificationsInfo = mapEmailNotificationsInfo.get( strUserId );
                                objEmailNotificationsInfo.strChildRecordsInfo += '<br/>' + strATMChildRecordsInfo;
                            }
                            else {
                                
                                String strOwnerName = ( String.isNotBlank(objAccTeamMember.User.FirstName)) ? 
                                                                objAccTeamMember.User.FirstName : objAccTeamMember.User.LastName;
                                                                
                                objEmailNotificationsInfo = new EmailNotificationsInfo( strUserId, strOwnerName, 
                                                                                        objAccTeamMember.User.Email, 
                                                                                        strATMChildRecordsInfo, 
                                                                                        (String)mapMergedsObjects.get( objAccTeamMember.AccountId ).get('MasterRecordId') );
                            }
                            
                            mapEmailNotificationsInfo.put( strUserId, objEmailNotificationsInfo );
                        }
                    }
                }
            
                else if( strsObjectName == 'Contact' ) {
                    
                    // Querying Contact Team records with Contacts being merged (passed to method as a parameter)
                        // and where Contact Owner has settings to Notify Members
                    for(Contact_Team__c objContactTeamMember : [SELECT Id, Contact__c, Contact__r.Name, User__c, 
                                                                        User__r.FirstName, User__r.LastName, User__r.Email, Previous_ContactId__c
                                                                FROM Contact_Team__c 
                                                                WHERE Previous_ContactId__c IN: mapSobjects.keyset()
                                                                ALL ROWS]) {
                                                                    
                         String strUserId = ((String)objContactTeamMember.User__c).substring(0, 15);
                         String strPreviousUserId = ((String)mapSobjects.get( objContactTeamMember.Previous_ContactId__c ).get('OwnerId')).substring(0, 15);
                        // Identifying users having Notify Members CS and also
                        // Filtering users who are either not mentioned in CS or having Send Email permissions
                        if( ( setUsers_HasNotifyMembers.contains(strPreviousUserId) &&
                                ( !mapUserToBeNotified.containsKey( strUserId )  || 
                                    ( mapUserToBeNotified.containsKey( strUserId ) && 
                                      mapUserToBeNotified.get( strUserId ).Send_Emails__c ) ) ) &&
                                (!mapUserIdToSobject.containsKey(strUserId) || 
                                    ( mapUserIdToSobject.containsKey(strUserId) && 
                                      !mapUserIdToSobject.get(strUserId).contains(objContactTeamMember.Previous_ContactId__c) ) ) ) {
                                        
                                        
                            if(mapUserIdToSobject.containsKey(strUserId))
                                mapUserIdToSobject.get(strUserId).add(objContactTeamMember.Previous_ContactId__c);
                            else
                                mapUserIdToSobject.put(strUserId, new set<Id>{objContactTeamMember.Previous_ContactId__c} );
                                
                            EmailNotificationsInfo objEmailNotificationsInfo;
                            String strATMChildRecordsInfo = '<span style="padding-left: 25px; margin-left: 25px;"> - ' + 
                                                                    (String)mapMergedsObjects.get( objContactTeamMember.Previous_ContactId__c ).get('Name') + '</span>';
                            
                            if( mapEmailNotificationsInfo.containsKey(strUserId) ) {
                                
                                objEmailNotificationsInfo = mapEmailNotificationsInfo.get( strUserId );
                                objEmailNotificationsInfo.strChildRecordsInfo += '<br/>' + strATMChildRecordsInfo;
                            }
                            else {
                                
                                String strOwnerName = ( String.isNotBlank(objContactTeamMember.User__r.FirstName)) ? 
                                                            objContactTeamMember.User__r.FirstName : objContactTeamMember.User__r.LastName;
                                                            
                                objEmailNotificationsInfo = new EmailNotificationsInfo( strUserId, strOwnerName, 
                                                                                        objContactTeamMember.User__r.Email, 
                                                                                        strATMChildRecordsInfo, 
                                                                                        (String)mapMergedsObjects.get( objContactTeamMember.Previous_ContactId__c ).get('MasterRecordId'));
                            }
                            
                            mapEmailNotificationsInfo.put( strUserId, objEmailNotificationsInfo );
                        }
                    }
                }
            }                 
            
            for(SObject objAccOrCon : mapMergedsObjects.values() ) {
                  
                String strUserId = ((String)objAccOrCon.get('OwnerId')).substring(0, 15);
                // Filter users either not mentioned in CS or having Send Email permissions                                         
                if( ( !mapUserToBeNotified.containsKey( strUserId )  || 
                        ( mapUserToBeNotified.containsKey( strUserId ) 
                            && mapUserToBeNotified.get( strUserId ).Send_Emails__c ) ) && 
                    ( !mapUserIdToSobject.containsKey( strUserId ) || 
                        ( mapUserIdToSobject.containsKey( strUserId ) && 
                            !mapUserIdToSobject.get( strUserId ).contains( (Id)objAccOrCon.get('Id') ) ) )
                        ) {
                                
                    if( mapUserIdToSobject.containsKey( strUserId) )
                        mapUserIdToSobject.get(strUserId).add( (Id)objAccOrCon.get('Id') );
                    else
                        mapUserIdToSobject.put(strUserId, new set<Id>{ (Id)objAccOrCon.get('Id') } );
                                
                
                    EmailNotificationsInfo objEmailNotificationsInfo;
                    String strATMChildRecordsInfo = '<span style="padding-left: 25px; margin-left: 25px;"> - ' + 
                                                            (String)objAccOrCon.get('Name') + '</span>';
                    
                    if( mapEmailNotificationsInfo.containsKey( strUserId) ) {
                        
                        objEmailNotificationsInfo = mapEmailNotificationsInfo.get( strUserId );
                        objEmailNotificationsInfo.strChildRecordsInfo += '<br/>' + strATMChildRecordsInfo;
                    }
                    else {
                        
                        String strOwnerName = ( String.isNotBlank((String)objAccOrCon.getSobject('Owner').get('FirstName'))) ? 
                                                    (String)objAccOrCon.getSobject('Owner').get('FirstName') : 
                                                    (String)objAccOrCon.getSobject('Owner').get('LastName');
                                                    
                        objEmailNotificationsInfo = new EmailNotificationsInfo( strUserId, strOwnerName, 
                                                                                (String)objAccOrCon.getSobject('Owner').get('Email'), 
                                                                                strATMChildRecordsInfo, 
                                                                                (String)objAccOrCon.get('MasterRecordId'));
                    }
                    
                    mapEmailNotificationsInfo.put( strUserId, objEmailNotificationsInfo );   
                }
            }
        }
        catch(Exception Ex) {
            
            system.debug('Exception Occured: ' + Ex.getMessage() + ' on line '+Ex.getLineNumber());
        }
        
        return mapEmailNotificationsInfo;
    }
}