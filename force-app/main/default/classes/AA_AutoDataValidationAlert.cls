public class AA_AutoDataValidationAlert {

	public static ID accID = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND developerName = 'Referring_Facility_Child'].ID;
	public static ID ctcID = [SELECT ID FROM RecordType WHERE sObjectType = 'Contact' AND developerName = 'General_Contact'].ID;
	
	public static list<User> usrList = [SELECT ID, Name FROM User WHERE (Name = 'All Users - Admin Maintenance' OR Name = 'All HD Users - Admin Maintenance' OR Name = 'Charles Cox' OR Name = 'All HD Users - Admin Maintenance' OR Name = 'Integration User' OR Name = 'Brian Seong' OR Name = 'Marketo Integration' OR Name = 'All Users')];
	
	public static string orgURL = string.valueOf(system.Url.getOrgDomainUrl());
	
    public static void searchRecords(){
    	ID accReportID;
    	ID ctcReportID;
        if(!test.isRunningTest()){
        	accReportID = [SELECT ID, Name, DeveloperName FROM Report WHERE DeveloperName = 'Account_Info_Audit'].ID;
			ctcReportID = [SELECT ID, Name, DeveloperName FROM Report WHERE DeveloperName = 'Contact_Info_Audit'].ID;
        	}
        else{
        	//Generic Report IDs, leave 'em be
        	accReportID = '00O1B000008d3K5UAI';
			ctcReportID = '00O1B000008d3K6UAI';
        	}	
        list<Account> accs = new list<Account>();
        list<Contact> ctcs = new list<Contact>();
        set<ID> ids = new set<ID>(); 
        set<User> userSet = new set<User>();
        list<User> users = new list<User>();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        list<string> exclusionOwners = new list<string>();
        for(User u : usrList){
        	exclusionOwners.add(u.ID);
        	}
        
        accs = [SELECT OwnerID, Name, ShippingCity, ShippingState, ShippingPostalCode FROM Account WHERE (ShippingCity = null OR ShippingState = null OR ShippingPostalCode = null) AND RecordType.ID =: accID];
    	ctcs = [SELECT OwnerID, Name, MailingCity, MailingState, MailingPostalCode FROM Contact WHERE (MailingCity = null OR MailingState = null OR MailingPostalCode = null) AND RecordType.ID =: ctcID];
    	
    	for(Account a: accs){
    		ids.add(a.OwnerID);
    		}
    	for(Contact c: ctcs){
    		ids.add(c.OwnerID);
    		}
    		
    	users = [SELECT ID, Email, isActive, Name, Manager.Email, Manager.isActive, Manager.ID FROM User WHERE ID IN: ids];
    	userSet.addAll(users);		    	
    	string subject = 'Notification of invalid record data';
    	string sendEmail;
    	string addressee = '';
    	for(User u: userSet){
    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    		string userID = '';
    		if(u.isActive == true && !exclusionOwners.contains(u.Id) && u.Email != null){
    			sendEmail = u.Email;
    			userID = u.ID;
    			addressee = u.Name;
    			}
    		else if(u.Manager.Email != null && u.Manager.isActive == true && !exclusionOwners.contains(u.Manager.ID)){
    				sendEmail = u.Manager.Email;
    				userID = u.ID;
    				addressee = u.Manager.Name;
    				}
    		else{
    			sendEmail = 'RMB_Sales_Support@kindred.com';
    			userID = u.ID;
    			addressee = 'Admin';
    			}			
    		
    		string htmlBody = 'Hello ' + u.Name + ', <br>' 
    		+ 'You are receiving this notification because you are listed as the owner of'
    		+ ' Account or Contact records with invalid data, or have been designated the recipient for a user of such that is no longer active.<br/>'
    		+ 'In this case, invalid data refers to missing contact informaiton for the record in question, such as city, state, and zip missing from an applicable contact address.<br/>'
    		+ 'If the issue is not remediated, the record will be deleted, so please address promptly.<br/>'
    		+ 'You can view a report containing all records in question to see what they\'re missing by clicking <a href="' + orgURL + '/'+ accReportID +'?pv0='+u.Name+'" target="_blank">here</a> for Accounts and <a href="' + orgURL + '/'+ ctcReportID +'?pv0='+u.Name+'" target="_blank">here</a> for contacts.<br/>'
    		+ 'Thanks for your assistance with this.';

            System.debug('Email Body: ' + htmlBody);
            // Build Email
            String[] toAddresses = new String[] {};
            toAddresses.add(sendEmail);                             
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mailList.add(mail);
    		
    		}
    		
    	 if(mailList != null && mailList.size() != 0){
         	system.debug('mailList' + mailList);
            Messaging.sendEmail(mailList,true);
            }	
    	
    	}
}