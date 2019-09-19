global with sharing class Sales_ExecAssignmentReport {
	/*
	@RemoteAction global static String getData(Id offsetId, Integer batchSize){
		String html='{';
		List<String> temp = new String[19];
		/*
		Index               Data
		0                   User Name
		1                   Hire Date
		2                   Title
		3                   Region
		4                   Area
		5                   Market
		6                   Home Facility
		7                   Manager
		8                   Total Assignments
		9                   Ref Accounts
		10                   Ref Contacts
		11                  Non-Ref Accounts
		12                  Non-Ref Contacts
		13                  YTD Target
		14                  YTD Referrals
		15                  YTD Admits
		16                  YTD Conv %
		17                  Total # Planned Calls
		18                  Total # Completed Calls
		19                  Last Login Date
		20                  Perner
		21                  User ID
		*/
/*
		Map<Id, List<String>> users = new Map<Id, List<String>>();

		Integer size = 0;
		String lastUserId = '';
		String hireDate, title, region, area, market, manager, login, perner;

		if(offsetId == null){
			for(User u : [select Id, Name, Date_of_hire__c, Title, Region__c, Area__c, Market__c, Manager.Name, LastLoginDate, Perner__c from User where(profileId='00e1300000225C9' or profileId='00e130000024QC8')
			and isActive=true and alias!='tuser' order by Id limit :batchSize]){
				hireDate='<span class=\\"lnr lnr-cross\\"></span>'; title='<span class=\\"lnr lnr-cross\\"></span>';
				region='<span class=\\"lnr lnr-cross\\"></span>'; area='<span class=\\"lnr lnr-cross\\"></span>'; market='<span class=\\"lnr lnr-cross\\"></span>';
				manager='<span class=\\"lnr lnr-cross\\"></span>'; login='<span class=\\"lnr lnr-cross\\"></span>';

				if(u.Date_of_hire__c!=null) hireDate = String.valueOf(u.Date_of_hire__c);
				if(u.Title!=null) title = String.valueOf(u.Title);
				if(u.Region__c!=null) region = String.valueOf(u.Region__c);
				if(u.Area__c!=null) area = String.valueOf(u.Area__c);
				if(u.Market__c!=null) market = String.valueOf(u.Market__c);
				if(u.Manager.Name!=null) manager = String.valueOf(u.Manager.Name);
				if(u.LastLoginDate!=null) login = String.valueOf(u.LastLoginDate).left(String.valueOf(u.LastLoginDate).indexOf(' '));
				if(u.Perner__c!=null) perner = String.valueOf(u.Perner__c);
				users.put(u.Id, new List<String>{
					String.valueOf(u.Name),
					hireDate,
					title,
					region,
					area,
					market,
					'<span class=\\"lnr lnr-cross\\"></span>',
					manager,
					String.valueOf(0),
					String.valueOf(0),
					String.valueOf(0),
					String.valueOf(0),
					String.valueOf(0),
					String.valueOf(0.00),
					String.valueOf(0.00),
					String.valueOf(0.00),
					String.valueOf(0),
					String.valueOf(0),
					String.valueOf(0),
					login,
					perner,
					String.valueOf(u.Id)});
					lastUserId = String.valueOf(u.Id);
					size++;
				}
			} else{
				for(User u : [select Id, Name, Date_of_hire__c, Title, Region__c, Area__c, Market__c, Manager.Name, LastLoginDate, Perner__c from User where (profileId='00e1300000225C9' or profileId='00e130000024QC8') and isActive=true and alias!='tuser' and Id>:offsetId order by Id limit :batchSize]){
					hireDate='<span class=\\"lnr lnr-cross\\"></span>'; title='<span class=\\"lnr lnr-cross\\"></span>';
					region='<span class=\\"lnr lnr-cross\\"></span>'; area='<span class=\\"lnr lnr-cross\\"></span>'; market='<span class=\\"lnr lnr-cross\\"></span>';
					manager='<span class=\\"lnr lnr-cross\\"></span>'; login='<span class=\\"lnr lnr-cross\\"></span>';

					if(u.Date_of_hire__c!=null) hireDate = String.valueOf(u.Date_of_hire__c);
					if(u.Title!=null) title = String.valueOf(u.Title);
					if(u.Region__c!=null) region = String.valueOf(u.Region__c);
					if(u.Area__c!=null) area = String.valueOf(u.Area__c);
					if(u.Market__c!=null) market = String.valueOf(u.Market__c);
					if(u.Manager.Name!=null) manager = String.valueOf(u.Manager.Name);
					if(u.LastLoginDate!=null) login = String.valueOf(u.LastLoginDate).left(String.valueOf(u.LastLoginDate).indexOf(' '));
					if(u.Perner__c!=null) perner = String.valueOf(u.Perner__c);
					users.put(u.Id, new List<String>{
						String.valueOf(u.Name),
						hireDate,
						title,
						region,
						area,
						market,
						'<span class=\\"lnr lnr-cross\\"></span>',
						manager,
						String.valueOf(0),
						String.valueOf(0),
						String.valueOf(0),
						String.valueOf(0),
						String.valueOf(0),
						String.valueOf(0.00),
						String.valueOf(0.00),
						String.valueOf(0.00),
						String.valueOf(0),
						String.valueOf(0),
						String.valueOf(0),
						login,
						perner,
						String.valueOf(u.Id)});
						lastUserId = String.valueOf(u.Id);
						size++;
					}
				}

				if(size==0) html += '"size" : 0, "offsetId" : null, "html" : "';
				else html += '"size" : '+String.valueOf(size)+', "offsetId" : "'+String.valueOf(lastUserId)+'", "html" : "';

				for(AccountTeamMember atm : [select UserId, Account.Unity_Id__c, Account.Horizon_Id__c from AccountTeamMember where UserId in :users.keySet()]){
					temp = new String[20];
					temp = users.remove(atm.UserId);
					temp.set(8, String.valueOf(Integer.valueOf(temp[8])+1));
					if(atm.Account.Unity_Id__c!=null || atm.Account.Horizon_Id__c!=null) temp.set(9, String.valueOf(Integer.valueOf(temp[9])+1));
					else temp.set(11, String.valueOf(Integer.valueOf(temp[11])+1));
					users.put(atm.UserId, temp);
				}

				for(Contact_Team__c ct : [select User__c, Contact__r.Unity_Id__c, Contact__r.Horizon_Id__c from Contact_Team__c where User__c in :users.keySet()]){
					temp = new String[20];
					temp = users.remove(ct.User__c);
					temp.set(8, String.valueOf(Integer.valueOf(temp[8])+1));
					if(ct.Contact__r.Unity_Id__c!=null || ct.Contact__r.Horizon_Id__c!=null) temp.set(10, String.valueOf(Integer.valueOf(temp[10])+1));
					else temp.set(12, String.valueOf(Integer.valueOf(temp[12])+1));
					users.put(ct.User__c, temp);
				}

				for(Home_Facility__c hf : [select User__c, Account__r.Name from Home_Facility__c where User__c in :users.keySet()]){
					temp = new String[20];
					temp = users.remove(hf.User__c);
					temp.set(6, String.valueOf(hf.Account__r.Name));
					users.put(hf.User__c, temp);
				}

				for(Sales_Performance__c sp : [select OwnerId, Sales_Calls__c, Planned_Sales_Calls__c, KAH_HH_Admit_Target__c, KAH_HH_Referrals__c, KAH_HH_PPS_Qualified_Admits__c, KAH_HP_Admit_Target__c, KAH_HP_Referrals__c, KAH_HP_Total_Admits__c from Sales_Performance__c where OwnerId in :users.keySet() and Month__c=THIS_YEAR and Month__c<=THIS_MONTH]){
					temp = new String[20];
					temp = users.remove(sp.OwnerId);
					Integer plannedCalls=0, salesCalls=0;
					if(sp.Planned_Sales_Calls__c!=null) plannedCalls=Integer.valueOf(sp.Planned_Sales_Calls__c);
					if(sp.Sales_Calls__c!=null) salesCalls=Integer.valueOf(sp.Sales_Calls__c);

					Decimal HHtarget=0, HHreferrals=0, HHadmits=0, HPtarget=0, HPreferrals=0, HPadmits=0;
					if(sp.KAH_HH_Admit_Target__c!=null) HHtarget=sp.KAH_HH_Admit_Target__c;
					if(sp.KAH_HH_Referrals__c!=null) HHreferrals=sp.KAH_HH_Referrals__c;
					if(sp.KAH_HH_PPS_Qualified_Admits__c!=null) HHadmits=sp.KAH_HH_PPS_Qualified_Admits__c;
					if(sp.KAH_HP_Admit_Target__c!=null) HPtarget=sp.KAH_HP_Admit_Target__c;
					if(sp.KAH_HP_Referrals__c!=null) HPreferrals=sp.KAH_HP_Referrals__c;
					if(sp.KAH_HP_Total_Admits__c!=null) HPadmits=sp.KAH_HP_Total_Admits__c;

					temp.set(13, String.valueOf(Decimal.valueOf(temp[13])+HHtarget + HPtarget));
					temp.set(14, String.valueOf(Decimal.valueOf(temp[14])+HHreferrals + HPreferrals));
					temp.set(15, String.valueOf(Decimal.valueOf(temp[15])+HHadmits + HPadmits));
					if(Decimal.valueOf(temp[14])!=0) temp.set(16, String.valueOf(((Decimal.valueOf(temp[15])/Decimal.valueOf(temp[14]))*100).setScale(2))+'%');
					else temp.set(16, String.valueOf(0.00)+'%');
					temp.set(17, String.valueOf(Integer.valueOf(temp[17])+plannedCalls));
					temp.set(18, String.valueOf(Integer.valueOf(temp[18])+salesCalls));

					users.put(sp.OwnerId, temp);
				}


				for(Id userId : users.keySet()){
					temp = users.remove(userId);
					html+='<tr>';
					html+='<td style=\\"border-left:1pt solid black; border-bottom:1pt solid black\\">'+temp[0]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[1]+'</td>';
					html+='<td style=\\"border-right:1pt solid black; border-bottom:1pt solid black\\">'+temp[2]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[3]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[4]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[5]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[6]+'</td>';
					html+='<td style=\\"border-right:1pt solid black; border-bottom:1pt solid black\\">'+temp[7]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[8]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[9]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[10]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[11]+'</td>';
					html+='<td style=\\"border-right:1pt solid black; border-bottom:1pt solid black\\">'+temp[12]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+Decimal.valueOf(temp[13]).setScale(2)+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+Decimal.valueOf(temp[14]).setScale(2)+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+Decimal.valueOf(temp[15]).setScale(2)+'</td>';
					html+='<td style=\\"border-right:1pt solid black; border-bottom:1pt solid black\\">'+temp[16]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[17]+'</td>';
					html+='<td style=\\"border-right:1pt solid black; border-bottom:1pt solid black\\">'+temp[18]+'</td>';
					html+='<td style=\\"border-right:1pt solid black; border-bottom:1pt solid black\\">'+temp[19]+'</td>';
					html+='<td style=\\"border-bottom:1pt solid black\\">'+temp[20]+'</td>';
					html+='<td style=\\"border-right:1pt solid black; border-bottom:1pt solid black\\">'+temp[21]+'</td>';
					html+='</tr>';
				}
				html+='"}';
				return html;
			}*/
		}