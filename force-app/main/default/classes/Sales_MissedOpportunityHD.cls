global with sharing class Sales_MissedOpportunityHD {

	public class data {
		public String cl;
		public String patient;
		public String facility;
		public String payor;
		public String referralDate;
		public String reason;
		public String days;
		public String comments;
		public Boolean delayed;
		public Boolean lost;
	}

	@RemoteAction global static String getUsers(){
		List<Id> allSubRoleIds = new List<ID>{UserInfo.getUserRoleId()};
		allSubRoleIds.addAll(getSubRoleIds(new List<ID>{UserInfo.getUserRoleId()}));
		String html = '';
		for(User u : [select Id, Name, Line_Of_Business__c from User where UserRoleId in :allSubRoleIds and IsActive=true order by Name]){
			html += '<li id="'+u.Id+'"">'+u.Name+'</li>';
		}
		return html;
	}

	private static List<Id> getSubRoleIds(List<Id> roleIds) {
		List<Id> returnRoleIds = new List<Id>();
		for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
			returnRoleIds.add(r.Id);
		}
		if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
		return returnRoleIds;
	}

	@RemoteAction global static String sendEmail(String jsonStr){
		data d = (Data)JSON.deserializeStrict(jsonStr, data.class);

		Boolean success = true;
		String cl_error = '';
		String admission_error = '';

		List<Id> allSubRoleIds = new List<ID>{UserInfo.getUserRoleId()};
		allSubRoleIds.addAll(getSubRoleIds(new List<ID>{UserInfo.getUserRoleId()}));
		if([select Id from user where name=:d.cl and UserRoleId in :allSubRoleIds and IsActive=true].size()==0) {
			success = false;
			cl_error = d.cl + ' is not a valid input for the clinical liaison.';
		}
		if(!d.lost && !d.delayed){
			success = false;
			admission_error = 'Lost or delayed admission must be selected.';
		}

		if(success){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			List<String> toAddresses = new List<String>();
			toAddresses.add('jack.holbrook@kindred.com');
			mail.setToAddresses(toAddresses);
			mail.setReplyTo(UserInfo.getUserEmail());
			mail.setSenderDisplayName(UserInfo.getName());
			String body = '';
			mail.setSubject('Missing Opportunities for '+d.cl);
			body += '<b style="font-size: 20px;">Missing Opportunities Form</b>';
			body += '<br/><div style="font-size: 20px;">This form was filled out by '+UserInfo.getName()+'.</div><br/><br/>';
			body += '<div style="font-size: 15px;">';
			body += '<b>Clinical Liaison</b><br>'+d.cl+'<br><br>';
			body += '<b>Patient Name</b><br>'+d.patient+'<br><br>';
			body += '<b>Referring Facility</b><br>'+d.facility+'<br><br>';
			body += '<b>Payor</b><br>'+d.payor+'<br><br>';
			body += '<b>Referral Date</b><br>'+d.referralDate+'<br><br>';
			body += '<b>Reason</b><br>'+d.reason+'<br><br>';
			if(d.lost) body += '<b>Lost Admission</b><br>'+d.lost+'<br><br>';
			if(d.delayed) body += '<b>Delayed Admission</b><br>'+d.delayed+'<br><br>';
			if(d.delayed) body += '<b>Days Delayed</b><br>'+d.days+'<br><br>';
			body += '<b>Comments</b><br>'+d.comments+'<br><br>';
			body += '</div>';
			mail.setHtmlBody(body);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
		}
		return '{"success": '+success+', "cl_error": "'+cl_error+'", "admission_error": "'+admission_error+'"}';
	}
}