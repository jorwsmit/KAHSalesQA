global class SALES_SupportPageController {
	
	private static final list<Profile> proList = [SELECT ID, Name FROM Profile];
	
    @RemoteAction global static void sendSupportTicket(String type, String description) {
    	Set<Id> kahIds = new set<ID>(); 
    	Set<Id> marketoIds = new set<ID>(); 
    	Set<Id> ncdIds = new set<ID>();
    	for(Profile p : proList){
    		if(p.Name == 'KAH Corporate Sales' || p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			kahIds.add(p.ID);
    			}
    		if(p.Name == 'Marketo Integration v2' || p.Name == 'Sales: HD Associate' || p.Name == 'Sales: HD Manager'){
    			marketoIds.add(p.ID);
    			}
    		if(p.Name == 'Sales: NCD Associate' || p.Name == 'Sales: NCD ADAM' || p.Name == 'Sales: NCD Manager' || p.Name == 'NCD Surveys Profile'){
    			ncdIds.add(p.ID);
    			}
    		}
        //Get current users profile name
        User u = [select id, name, profileId, profile.name, userRole.name from user where id = :userinfo.getUserId()];

        //Create a new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Set to address
        List<String> toAddresses = new List<String>();
        toAddresses.add('kindredcomsalessupport@kindredhealthcare.freshdesk.com');
        mail.setToAddresses(toAddresses);

        //Set from addresses to the current user who is sending the email
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getName());

        //Fill out the emails body
        String body = '';
        if(type!=null){
            mail.setSubject('Salesforce Support - '+type);
            body += '<b style="font-size: 18px;">User Info</b>';
            body += '<br/>Name: '+UserInfo.getName();
            if(marketoIds.contains(u.profileId)){
                body += '<br/>Division: HD';
                body += '<br/>Role: '+u.userRole.name;
            } else if (ncdIds.contains(u.profileId)) {
                body += '<br/>Division: NCD';
                body += '<br/>Role: '+u.userRole.name;
            } else if (kahIds.contains(u.profileId)) {
                body += '<br/>Division: KAH';
                body += '<br/>Role: '+u.userRole.name;
            } else {
                body += '<br/>Profile: '+u.profile.name;
                body += '<br/>Role: '+u.userRole.name;
            }
            body += '<br/><a class="btn btn-default" href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+UserInfo.getUserId()+'?noredirect=1&isUserEntityOverride=1">View '+UserInfo.getName()+' in Salesforce</a>';
            body += '<br/><br/><b>Type of ticket</b><br/>'+type;
        } else {
            mail.setSubject('Salesforce Support - No Type Provided ('+UserInfo.getName()+' may have tampered with Javascript)');
        }

        if(description!=null) body+='<br/><br/><b>Description</b><br/>'+description;
        else body+='<br/><br/><br/>No Description Provided. ('+UserInfo.getName()+' may have tampered with Javascript)';

        mail.setHtmlBody(body);

        //Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction global static void passwordReset(String name) {
    	Set<Id> kahIds = new set<ID>(); 
    	Set<Id> marketoIds = new set<ID>(); 
    	Set<Id> ncdIds = new set<ID>();
    	for(Profile p : proList){
    		if(p.Name == 'KAH Corporate Sales' || p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			kahIds.add(p.ID);
    			}
    		if(p.Name == 'Marketo Integration v2' || p.Name == 'Sales: HD Associate' || p.Name == 'Sales: HD Manager'){
    			marketoIds.add(p.ID);
    			}
    		if(p.Name == 'Sales: NCD Associate' || p.Name == 'Sales: NCD ADAM' || p.Name == 'Sales: NCD Manager' || p.Name == 'NCD Surveys Profile'){
    			ncdIds.add(p.ID);
    			}
    		}
        name = '%'+name+'%';
        //Get info of the user who needs the password reset
        List<User> usrs= [select id, name, email, profile.name, profileId, userRole.name from user where name like :name and isActive = true];

        //Create a new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Set to address
        List<String> toAddresses = new List<String>();
        toAddresses.add('kindredcomsalessupport@kindredhealthcare.freshdesk.com');
        mail.setToAddresses(toAddresses);


        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getName());

        //Fill out the emails body
        String body = '';
        if(usrs.size()==1){
            mail.setSubject('Salesforce Support - Password Reset');
            body += '<b>One user has been matched with the name '+name.mid(1,name.length()-2)+'!</b><br/>';
            body += '<b style="font-size: 18px;">User Info</b>';
            body += '<br/>Name: '+usrs[0].name;
            if(marketoIds.contains(usrs[0].profileId)){
                body += '<br/>Division: HD';
            } else if (ncdIds.contains(usrs[0].profileId)) {
                body += '<br/>Division: NCD';
            } else if (kahIds.contains(usrs[0].profileId)) {
                body += '<br/>Division: KAH';
            } else {
                body += '<br/>Profile: '+usrs[0].profile.name;
            }
            body += '<br/>Role: '+usrs[0].userRole.name;
            body += '<br/><a class="btn btn-default" href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+usrs[0].Id+'?noredirect=1&isUserEntityOverride=1">View '+usrs[0].Name+' in Salesforce</a><br/>';
        } else if (usrs.size()>1){
            mail.setSubject('Salesforce Support - Password Reset (Multiple Matching Names)');
            Integer count = 1;
            body += '<b>Multiple users have been matched with the name '+name.mid(1,name.length()-2)+'!</b><br/>';
            for(User u: usrs){
                body += '<br/><b style="font-size: 18px;">User Info '+count+'</b>';
                body += '<br/>Name: '+u.name;
                                if(marketoIds.contains(u.profileId)){
                        body += '<br/>Division: HD';
                    } else if (ncdIds.contains(u.profileId)) {
                        body += '<br/>Division: NCD';
                    } else if (kahIds.contains(u.profileId)) {
                        body += '<br/>Division: KAH';
                    } else {
                        body += '<br/>Profile: '+u.profile.name;
                    }
                body += '<br/>Role: '+u.userRole.name;
                body += '<br/><a class="btn btn-default" href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+u.Id+'?noredirect=1&isUserEntityOverride=1">View '+u.Name+' in Salesforce</a><br/>';
                count++;
            }
        } else {
            mail.setSubject('Salesforce Support - Password Reset (No Matching Names)');
            body += '<b>No users have been matched with the name '+name.mid(1,name.length()-2)+'!</b><br/>';
        }

        body += '<br/><b>Type of ticket</b><br/>Password Reset';

        if(usrs.size()==1) body+='<br/><br/><b>Description</b><br/>'+UserInfo.getName()+' typed in "'+name.mid(1,name.length()-2)+'" for a password reset.';
        else if(usrs.size()>1) body+='<br/><br/><b>Description</b><br/>'+UserInfo.getName()+' typed in "'+name.mid(1,name.length()-2)+'" for a password reset.';
        else body+='<br/><br/><b>Description</b><br/>'+UserInfo.getName()+' typed in "'+name.mid(1,name.length()-2)+'" for a password reset.';

        mail.setHtmlBody(body);

        //Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction global static void employeeForm(String activityType, String employeeDivision, String employeeNameMaint, String employeeEmailMaint, String managerName, String effectiveDate, String userId, String employeeNumber, String regionDistrict, String referringLocations, String notes) {
        Set<Id> kahIds = new set<ID>(); 
    	Set<Id> marketoIds = new set<ID>(); 
    	Set<Id> ncdIds = new set<ID>();
        for(Profile p : proList){
    		if(p.Name == 'KAH Corporate Sales' || p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			kahIds.add(p.ID);
    			}
    		if(p.Name == 'Marketo Integration v2' || p.Name == 'Sales: HD Associate' || p.Name == 'Sales: HD Manager'){
    			marketoIds.add(p.ID);
    			}
    		if(p.Name == 'Sales: NCD Associate' || p.Name == 'Sales: NCD ADAM' || p.Name == 'Sales: NCD Manager' || p.Name == 'NCD Surveys Profile'){
    			ncdIds.add(p.ID);
    			}
    		}
        //Create a new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Set to address
        List<String> toAddresses = new List<String>();
        toAddresses.add('kindredcomsalessupport@kindredhealthcare.freshdesk.com');
        mail.setToAddresses(toAddresses);

        //Set from addresses to the current user who is sending the email
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getName());

        String body = '';

        if(activityType.equals('New Employee') || activityType.equals('Edit Employee') || activityType.equals('Transfer Employee')){
            if(activityType.equals('New Employee')){
                mail.setSubject('Salesforce Support - Maintenance Form: New Employee');
                body += UserInfo.getName() + ' has requested Salesforce access for a new employee. See the info below to process this request.<br/><br/><br/>';
            } else if (activityType.equals('Edit Employee')){
                mail.setSubject('Salesforce Support - Maintenance Form: Edit Employee');
                body += UserInfo.getName() + ' has requested an edit on an employee\'s Salesforce account. See the info below to process this request.<br/><br/><br/>';
            } else if (activityType.equals('Transfer Employee')){
                mail.setSubject('Salesforce Support - Maintenance Form: Transfer Employee');
                body += UserInfo.getName() + ' has requested a transfer for an employee. See the info below to process this request.<br/><br/><br/>';
            }

            body += '<b style="font-size: 18px;">User Info</b><br/>';
            body += '<b>Employee Division</b><br/>' + employeeDivision + '<br/><br/>';
            body += '<b>Employee Name</b><br/>' + employeeNameMaint + '<br/><br/>';
            body += '<b>Employee Email</b><br/>' + employeeEmailMaint + '<br/><br/>';
            body += '<b>Manager Name</b><br/>' + managerName + '<br/><br/>';
            body += '<b>Effective Date</b><br/>' + effectiveDate + '<br/><br/>';
            body += '<b>User ID</b><br/>' + userId + '<br/><br/>';
            body += '<b>Employee Number (PERNER)</b><br/>' + employeeNumber + '<br/><br/>';
            body += '<b>Region/District Name or Central Admissions Office</b><br/>' + regionDistrict + '<br/><br/>';
            body += '<b>Referring Locations</b><br/>' + referringLocations + '<br/><br/>';
            body += '<b>Notes/Comments</b><br/>' + notes + '<br/><br/>';


        } else if (activityType.equals('Terminate Employee')){
            mail.setSubject('Salesforce Support - Maintenance Form: Terminate Employee');

            mail.setSubject('Salesforce Support - Maintenance Form: Terminate Employee');
            body += UserInfo.getName() + ' has requested a termination for an employee. See the info below to process this request.<br/><br/><br/>';

            body += '<b style="font-size: 18px;">User Info</b><br/>';
            body += '<b>Employee Name</b><br/>' + employeeNameMaint + '<br/><br/>';
            body += '<b>Effective Date</b><br/>' + effectiveDate + '<br/><br/>';
            body += '<b>Employee Number (PERNER)</b><br/>' + employeeNumber + '<br/><br/>';
            body += '<b>Notes/Comments</b><br/>' + notes + '<br/><br/>';
        }

        mail.setHtmlBody(body);

        //Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction global static void issue(String issue, String description) {
    	Set<Id> kahIds = new set<ID>(); 
    	Set<Id> marketoIds = new set<ID>(); 
    	Set<Id> ncdIds = new set<ID>();
    	for(Profile p : proList){
    		if(p.Name == 'KAH Corporate Sales' || p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			kahIds.add(p.ID);
    			}
    		if(p.Name == 'Marketo Integration v2' || p.Name == 'Sales: HD Associate' || p.Name == 'Sales: HD Manager'){
    			marketoIds.add(p.ID);
    			}
    		if(p.Name == 'Sales: NCD Associate' || p.Name == 'Sales: NCD ADAM' || p.Name == 'Sales: NCD Manager' || p.Name == 'NCD Surveys Profile'){
    			ncdIds.add(p.ID);
    			}
    		}
        //Get current users profile name
        User u = [select id, name, profile.name, userRole.name from user where id = :userinfo.getUserId()];

        //Create a new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Set to address
        List<String> toAddresses = new List<String>();
        toAddresses.add('kindredcomsalessupport@kindredhealthcare.freshdesk.com');
        mail.setToAddresses(toAddresses);

        //Set from addresses to the current user who is sending the email
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getName());

        String body = '';

        mail.setSubject('Salesforce Support - Issue: '+issue);

        body += '<b style="font-size: 18px;">User Info</b>';
        body += '<br/>Name: '+UserInfo.getName();
                if(marketoIds.contains(u.profileId)){
                        body += '<br/>Division: HD';
                } else if (ncdIds.contains(u.profileId)) {
                        body += '<br/>Division: NCD';
                } else if (kahIds.contains(u.profileId)) {
                        body += '<br/>Division: KAH';
                } else {
                        body += '<br/>Profile: '+u.profile.name;
                }

        body += '<br/>Role: '+u.userRole.name;
        body += '<br/><a class="btn btn-default" href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+UserInfo.getUserId()+'?noredirect=1&isUserEntityOverride=1">View '+UserInfo.getName()+' in Salesforce</a>';
        body += '<br/><br/><b>Type of ticket</b><br/>Issue';
        body += '<br/><br/><b>Type of issue</b><br/>'+issue;

        body+='<br/><br/><b>Description</b><br/>'+description;

        mail.setHtmlBody(body);

        //Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction global static void trainingDates() {
    	Set<Id> kahIds = new set<ID>(); 
    	Set<Id> marketoIds = new set<ID>(); 
    	Set<Id> ncdIds = new set<ID>();
    	for(Profile p : proList){
    		if(p.Name == 'KAH Corporate Sales' || p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			kahIds.add(p.ID);
    			}
    		if(p.Name == 'Marketo Integration v2' || p.Name == 'Sales: HD Associate' || p.Name == 'Sales: HD Manager'){
    			marketoIds.add(p.ID);
    			}
    		if(p.Name == 'Sales: NCD Associate' || p.Name == 'Sales: NCD ADAM' || p.Name == 'Sales: NCD Manager' || p.Name == 'NCD Surveys Profile'){
    			ncdIds.add(p.ID);
    			}
    		}
        //Get current users profile name
        User u = [select id, name, profile.name, userRole.name from user where id = :userinfo.getUserId()];

        //Create a new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Set to address
        List<String> toAddresses = new List<String>();
        toAddresses.add('kindredcomsalessupport@kindredhealthcare.freshdesk.com');
        mail.setToAddresses(toAddresses);

        //Set from addresses to the current user who is sending the email
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getName());

        String body = '';

        body += '<b style="font-size: 18px;">User Info</b>';
        body += '<br/>Name: '+UserInfo.getName();
                if(marketoIds.contains(u.profileId)){
                        body += '<br/>Division: HD';
                } else if (ncdIds.contains(u.profileId)) {
                        body += '<br/>Division: NCD';
                } else if (kahIds.contains(u.profileId)) {
                        body += '<br/>Division: KAH';
                } else {
                        body += '<br/>Profile: '+u.profile.name;
                }

        body += '<br/>Role: '+u.userRole.name;
        body += '<br/><a class="btn btn-default" href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+UserInfo.getUserId()+'?noredirect=1&isUserEntityOverride=1">View '+UserInfo.getName()+' in Salesforce</a>';
        body += '<br/><br/><b>Description</b><br/>'+UserInfo.getName()+' requested training dates, so an automated reply containing the dates was sent. <b>No action is necessary at this time!</b>';

        mail.setSubject('Salesforce Support - Training Dates');

        mail.setHtmlBody(body);

        //Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction global static void missingReferralSources(String description) {
    	Set<Id> kahIds = new set<ID>(); 
    	Set<Id> marketoIds = new set<ID>(); 
    	Set<Id> ncdIds = new set<ID>();
    	for(Profile p : proList){
    		if(p.Name == 'KAH Corporate Sales' || p.Name == 'Sales: KAH Associate' || p.Name == 'Sales: KAH Manager' || p.Name == 'Sales: KAH Market Manager'){
    			kahIds.add(p.ID);
    			}
    		if(p.Name == 'Marketo Integration v2' || p.Name == 'Sales: HD Associate' || p.Name == 'Sales: HD Manager'){
    			marketoIds.add(p.ID);
    			}
    		if(p.Name == 'Sales: NCD Associate' || p.Name == 'Sales: NCD ADAM' || p.Name == 'Sales: NCD Manager' || p.Name == 'NCD Surveys Profile'){
    			ncdIds.add(p.ID);
    			}
    		}
        //Get current users profile name
        User u = [select id, name, profile.name, userRole.name from user where id = :userinfo.getUserId()];

        //Create a new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Set to address
        List<String> toAddresses = new List<String>();
        toAddresses.add('kindredcomsalessupport@kindredhealthcare.freshdesk.com');
        mail.setToAddresses(toAddresses);

        //Set from addresses to the current user who is sending the email
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getName());

        String body = '';

        body += '<b style="font-size: 18px;">User Info</b>';
        body += '<br/>Name: '+UserInfo.getName();
                if(marketoIds.contains(u.profileId)){
                        body += '<br/>Division: HD';
                } else if (ncdIds.contains(u.profileId)) {
                        body += '<br/>Division: NCD';
                } else if (kahIds.contains(u.profileId)) {
                        body += '<br/>Division: KAH';
                } else {
                        body += '<br/>Profile: '+u.profile.name;
                }

        body += '<br/>Role: '+u.userRole.name;
        body += '<br/><a class="btn btn-default" href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+UserInfo.getUserId()+'?noredirect=1&isUserEntityOverride=1">View '+UserInfo.getName()+' in Salesforce</a>';
        body += '<br/><br/><b>Type of ticket</b><br/>Missing Referral Sources';
        body += '<br/><br/><b>Description</b><br/>' + description;

        mail.setSubject('Salesforce Support - Missing Referral Sources');

        mail.setHtmlBody(body);

        //Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

}