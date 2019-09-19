global with sharing class Sales_SalesIncentivesTeamReports {
	public string getReportHtml() {
    Id taId = null;
    if(ApexPages.currentPage().getParameters().get('report')!='null' && ApexPages.currentPage().getParameters().get('report')=='1' && ApexPages.currentPage().getParameters().get('year')!='null' && ApexPages.currentPage().getParameters().get('lob')!='null')
		return getTargetTable(Integer.valueOf(ApexPages.currentPage().getParameters().get('year')), String.valueOf(ApexPages.currentPage().getParameters().get('lob')));
		else if(ApexPages.currentPage().getParameters().get('report')!='null' && ApexPages.currentPage().getParameters().get('report')=='2' && ApexPages.currentPage().getParameters().get('year')!='null' && ApexPages.currentPage().getParameters().get('lob')!='null')
		return getTargetHiddenTable(Integer.valueOf(ApexPages.currentPage().getParameters().get('year')), String.valueOf(ApexPages.currentPage().getParameters().get('lob')));
		/*
		else if(ApexPages.currentPage().getParameters().get('report')!='null' && ApexPages.currentPage().getParameters().get('report')=='3' && ApexPages.currentPage().getParameters().get('year')!='null' && ApexPages.currentPage().getParameters().get('lob')!='null')
		return getAllTargets(Integer.valueOf(ApexPages.currentPage().getParameters().get('year')), String.valueOf(ApexPages.currentPage().getParameters().get('lob')));
		*/
		else
		return '';
  }

	@RemoteAction global static String getTargetTable(Integer year, String lob){
		Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
		system.debug('allRoleIDs: ' + allSubRoleIds);
		String html = '<table style="font-size: 14px; width: 100%; text-align: left; border-collapse: collapse; border: 0.8px solid #ddd;">'+
		'<thead>'+
		'<tr>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Name</th><th style="background-color: #007bff; color: white; padding: 10px;">Perner</th><th style="background-color: #007bff; color: white; padding: 10px;">Line of Business</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Region</th><th style="background-color: #007bff; color: white; padding: 10px;">Area</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Market</th><th style="background-color: #007bff; color: white; padding: 10px;">Manager</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">JAN Target</th><th style="background-color: #007bff; color: white; padding: 10px;">FEB Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">MAR Target</th><th style="background-color: #007bff; color: white; padding: 10px;">APR Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">MAY Target</th><th style="background-color: #007bff; color: white; padding: 10px;">JUN Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">JUL Target</th><th style="background-color: #007bff; color: white; padding: 10px;">AUG Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">SEP Target</th><th style="background-color: #007bff; color: white; padding: 10px;">OCT Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">NOV Target</th><th style="background-color: #007bff; color: white; padding: 10px;">DEC Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Annualized Total Targets</th>'+
		'</tr>'+
		'</thead>'+
		'<tbody>';

		Map<Id, User> allUsers = new Map<Id, User>([select Id, Name, Perner__c, Line_of_business__c, Region__c, Area__c, Market__c, Manager.Name from user
		where UserRoleId in : allSubRoleIds and isActive=true and Line_of_business__c like : '%'+lob+'%' and
	  Id in (select SA_Agreement_By__c from Target_Agreement__c where Manager_Agreed__c=true and Retired__c=false)]);

		//Map user id to a list of strings
		// List has user info at index 0
		//         HH Targets at index 1
		//         HP Targets at index 2
		Map<Id, List<List<String>>> data = new Map<Id, List<List<String>>>();


		Map<Id, Sales_Performance__c> sps = new Map<Id, Sales_Performance__c>([select Id, OwnerId, KAH_HH_Admit_Target__c,
		KAH_HP_Admit_Target__c, Month__c from Sales_Performance__c
		where Month__c >= :Date.newInstance(year,1,1) and Month__c <= :Date.newInstance(year,12,31)
		and OwnerId in : allUsers.keySet()]);

		for(Sales_Performance__c sp : sps.values()){
			if(data.containsKey(sp.OwnerId)){
				List<List<String>> temp = data.remove(sp.OwnerId);
				Integer index = sp.Month__c.month()-1;
				if(sp.KAH_HH_Admit_Target__c!=null) temp[1].set(index, String.valueOf(sp.KAH_HH_Admit_Target__c));
				if(sp.KAH_HP_Admit_Target__c!=null) temp[2].set(index, String.valueOf(sp.KAH_HP_Admit_Target__c));
				data.put(sp.OwnerId, temp);
			} else{
				String name='', perner='', line='', region='', area='', market='', manager='';
				if(allUsers.get(sp.OwnerId).Name!=null) name = String.valueOf(allUsers.get(sp.OwnerId).Name);
				if(allUsers.get(sp.OwnerId).Perner__c!=null) perner = String.valueOf(allUsers.get(sp.OwnerId).Perner__c);
				if(allUsers.get(sp.OwnerId).Line_of_business__c!=null) line = String.valueOf(allUsers.get(sp.OwnerId).Line_of_business__c);
				if(allUsers.get(sp.OwnerId).Region__c!=null) region = String.valueOf(allUsers.get(sp.OwnerId).Region__c);
				if(allUsers.get(sp.OwnerId).Area__c!=null) area = String.valueOf(allUsers.get(sp.OwnerId).Area__c);
				if(allUsers.get(sp.OwnerId).Market__c!=null) market = String.valueOf(allUsers.get(sp.OwnerId).Market__c);
				if(allUsers.get(sp.OwnerId).Manager.Name!=null) manager = String.valueOf(allUsers.get(sp.OwnerId).Manager.Name);
				Integer index = sp.Month__c.month()-1;
				List<String> userInfo = new List<String> {name, perner, line, region, area, market, manager};
				List<String> hhTargets = new List<String> {'', '', '',
				'', '', '', '', '', '', '', '', ''};
				List<String> hpTargets = new List<String> {'', '', '',
				'', '', '', '', '', '', '', '', ''};
				if(sp.KAH_HH_Admit_Target__c!=null) hhTargets.set(index, String.valueOf(sp.KAH_HH_Admit_Target__c));
				if(sp.KAH_HP_Admit_Target__c!=null) hpTargets.set(index, String.valueOf(sp.KAH_HP_Admit_Target__c));
				data.put(sp.OwnerId, new List<List<String>>{userInfo, hhTargets, hpTargets});
			}
		}

		for(List<List<String>> dataLists : data.values()){
			Integer i=1;
			if(math.mod(i,2) == 0) html += '<tr style="background-color: #f2f2f2;">';
			else html += '<tr>';
			html += '<td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][0]+'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][1]+'</td>'+
			'<td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][2]+'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][3]+'</td>'+
			'<td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][4]+'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][5]+'</td>'+
			'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][6]+'</td>';

			Integer index = 1;
			if(lob!=null && lob=='HP') index = 2;

			Integer monthNum = 0;
			Decimal num = 0.00;
			for(Integer j=0; j<12; j++){
				if(dataLists[index][j] != '' && Decimal.valueOf(dataLists[index][j]) > 0){
					monthNum++;
					num += Decimal.valueOf(dataLists[index][j]);
				}
				html += '<td style="border: 0.8px solid #ddd; padding: 10px;"><div>'+dataLists[index][j]+'</div></td>';
			}
			if(monthNum != 0) html += '<td style="border: 0.8px solid #ddd; padding: 10px;"><div>'+((num/monthNum)*12).setScale(2)+'</div></td>';
			else html += '<td style="border: 0.8px solid #ddd; padding: 10px;"><div></div></td>';
			html += '</tr>';
			i++;
		}

		html += '</tbody>'+
		'</table>';

		return html;
	}

	@RemoteAction global static String getTargetHiddenTable(Integer year, String lob){
		Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
		system.debug('SubRoleIDs: ' + allSubRoleIds);
		String html = '<table style="font-size: 14px; width: 100%; text-align: left; border-collapse: collapse; border: 0.8px solid #ddd;">'+
		'<thead>'+
		'<tr>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Name</th><th style="background-color: #007bff; color: white; padding: 10px;">Perner</th><th style="background-color: #007bff; color: white; padding: 10px;">Line of Business</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Region</th><th style="background-color: #007bff; color: white; padding: 10px;">Area</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Market</th><th style="background-color: #007bff; color: white; padding: 10px;">Manager</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">JAN Target</th><th style="background-color: #007bff; color: white; padding: 10px;">FEB Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">MAR Target</th><th style="background-color: #007bff; color: white; padding: 10px;">APR Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">MAY Target</th><th style="background-color: #007bff; color: white; padding: 10px;">JUN Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">JUL Target</th><th style="background-color: #007bff; color: white; padding: 10px;">AUG Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">SEP Target</th><th style="background-color: #007bff; color: white; padding: 10px;">OCT Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">NOV Target</th><th style="background-color: #007bff; color: white; padding: 10px;">DEC Target</th>'+
		'<th style="background-color: #007bff; color: white; padding: 10px;">Annualized Total Targets</th>'+
		'</tr>'+
		'</thead>'+
		'<tbody>';

		Map<Id, User> allUsers = new Map<Id, User>([select Id, Name, Perner__c, Line_of_business__c, Region__c, Area__c, Market__c, Manager.Name from user
		where UserRoleId in : allSubRoleIds and isActive=true and Line_of_business__c like : '%'+lob+'%' and
		Id in (select SA_Agreement_By__c from Target_Agreement__c where Manager_Agreed__c=false and Retired__c=false)]);

		//Map user id to a list of strings
		// List has user info at index 0
		//         HH Targets at index 1
		//         HP Targets at index 2
		Map<Id, List<List<String>>> data = new Map<Id, List<List<String>>>();


		Map<Id, Sales_Performance__c> sps = new Map<Id, Sales_Performance__c>([select Id, OwnerId, KAH_Hidden_HH_Admit_Target__c,
		KAH_Hidden_HP_Admit_Target__c, Month__c from Sales_Performance__c
		where Month__c >= :Date.newInstance(year,1,1) and Month__c <= :Date.newInstance(year,12,31)
		and OwnerId in : allUsers.keySet()]);

		for(Sales_Performance__c sp : sps.values()){
			if(data.containsKey(sp.OwnerId)){
				List<List<String>> temp = data.remove(sp.OwnerId);
				Integer index = sp.Month__c.month()-1;
				if(sp.KAH_Hidden_HH_Admit_Target__c!=null) temp[1].set(index, String.valueOf(sp.KAH_Hidden_HH_Admit_Target__c));
				if(sp.KAH_Hidden_HP_Admit_Target__c!=null) temp[2].set(index, String.valueOf(sp.KAH_Hidden_HP_Admit_Target__c));
				data.put(sp.OwnerId, temp);
			} else{
				String name='', perner='', line='', region='', area='', market='', manager='';
				if(allUsers.get(sp.OwnerId).Name!=null) name = String.valueOf(allUsers.get(sp.OwnerId).Name);
				if(allUsers.get(sp.OwnerId).Perner__c!=null) perner = String.valueOf(allUsers.get(sp.OwnerId).Perner__c);
				if(allUsers.get(sp.OwnerId).Line_of_business__c!=null) line = String.valueOf(allUsers.get(sp.OwnerId).Line_of_business__c);
				if(allUsers.get(sp.OwnerId).Region__c!=null) region = String.valueOf(allUsers.get(sp.OwnerId).Region__c);
				if(allUsers.get(sp.OwnerId).Area__c!=null) area = String.valueOf(allUsers.get(sp.OwnerId).Area__c);
				if(allUsers.get(sp.OwnerId).Market__c!=null) market = String.valueOf(allUsers.get(sp.OwnerId).Market__c);
				if(allUsers.get(sp.OwnerId).Manager.Name!=null) manager = String.valueOf(allUsers.get(sp.OwnerId).Manager.Name);
				Integer index = sp.Month__c.month()-1;
				List<String> userInfo = new List<String> {name, perner, line, region, area, market, manager};
				List<String> hhTargets = new List<String> {'', '', '',
				'', '', '', '', '', '', '', '', ''};
				List<String> hpTargets = new List<String> {'', '', '',
				'', '', '', '', '', '', '', '', ''};
				if(sp.KAH_Hidden_HH_Admit_Target__c!=null) hhTargets.set(index, String.valueOf(sp.KAH_Hidden_HH_Admit_Target__c));
				if(sp.KAH_Hidden_HP_Admit_Target__c!=null) hpTargets.set(index, String.valueOf(sp.KAH_Hidden_HP_Admit_Target__c));
				data.put(sp.OwnerId, new List<List<String>>{userInfo, hhTargets, hpTargets});
			}
		}

		for(List<List<String>> dataLists : data.values()){
			Integer i=1;
			if(math.mod(i,2) == 0) html += '<tr style="background-color: #f2f2f2;">';
			else html += '<tr>';
			html += '<td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][0]+'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][1]+'</td>'+
			'<td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][2]+'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][3]+'</td>'+
			'<td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][4]+'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][5]+'</td>'+
			'</td><td style="border: 0.8px solid #ddd; padding: 10px;">'+dataLists[0][6]+'</td>';

			Integer index = 1;
			if(lob!=null && lob=='HP') index = 2;

			Integer monthNum = 0;
			Decimal num = 0.00;
			for(Integer j=0; j<12; j++){
				if(dataLists[index][j] != '' && Decimal.valueOf(dataLists[index][j]) > 0){
					monthNum++;
					num += Decimal.valueOf(dataLists[index][j]);
				}
				html += '<td style="border: 0.8px solid #ddd; padding: 10px;"><div>'+dataLists[index][j]+'</div></td>';
			}
			if(monthNum != 0) html += '<td style="border: 0.8px solid #ddd; padding: 10px;"><div>'+((num/monthNum)*12).setScale(2)+'</div></td>';
			else html += '<td style="border: 0.8px solid #ddd; padding: 10px;"><div></div></td>';
			html += '</tr>';
			i++;
		}

		html += '</tbody>'+
		'</table>';

		return html;
	}

	@RemoteAction global static List<List<List<String>>> getAllTargets(Integer year, String lob){
		Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});

		Map<Id, User> allUsers = new Map<Id, User>([select Id, Name, Perner__c, Line_of_business__c, Region__c, Area__c, Market__c, Manager.Name from user
		where UserRoleId in : allSubRoleIds and isActive=true and (Line_of_business__c like : '%HH%' or Line_of_business__c like : '%HP%')]);

		//Map user id to a list of strings
		// List has user info at index 0
		//         HH Targets at index 1
		//         HP Targets at index 2
		Map<Id, List<List<String>>> data = new Map<Id, List<List<String>>>();
		
		Map<Id, Sales_Performance__c> sps = new Map<Id, Sales_Performance__c>([select Id, OwnerId, KAH_HH_Admit_Target__c,
		KAH_HP_Admit_Target__c, Month__c from Sales_Performance__c
		where Month__c >= :Date.newInstance(year,1,1) and Month__c <= :Date.newInstance(year,12,31)
		and OwnerId in : allUsers.keySet()]);

		for(Sales_Performance__c sp : sps.values()){
			if(data.containsKey(sp.OwnerId)){
				List<List<String>> temp = data.remove(sp.OwnerId);
				Integer index = sp.Month__c.month()-1;
				if(sp.KAH_HH_Admit_Target__c!=null) temp[1].set(index, String.valueOf(sp.KAH_HH_Admit_Target__c));
				if(sp.KAH_HP_Admit_Target__c!=null) temp[2].set(index, String.valueOf(sp.KAH_HP_Admit_Target__c));
				data.put(sp.OwnerId, temp);
			} else{
				String name='', perner='', line='', region='', area='', market='', manager='';
				if(allUsers.get(sp.OwnerId).Name!=null) name = String.valueOf(allUsers.get(sp.OwnerId).Name);
				if(allUsers.get(sp.OwnerId).Perner__c!=null) perner = String.valueOf(allUsers.get(sp.OwnerId).Perner__c);
				if(allUsers.get(sp.OwnerId).Line_of_business__c!=null) line = String.valueOf(allUsers.get(sp.OwnerId).Line_of_business__c);
				if(allUsers.get(sp.OwnerId).Region__c!=null) region = String.valueOf(allUsers.get(sp.OwnerId).Region__c);
				if(allUsers.get(sp.OwnerId).Area__c!=null) area = String.valueOf(allUsers.get(sp.OwnerId).Area__c);
				if(allUsers.get(sp.OwnerId).Market__c!=null) market = String.valueOf(allUsers.get(sp.OwnerId).Market__c);
				if(allUsers.get(sp.OwnerId).Manager.Name!=null) manager = String.valueOf(allUsers.get(sp.OwnerId).Manager.Name);
				Integer index = sp.Month__c.month()-1;
				List<String> userInfo = new List<String> {name, perner, line, region, area, market, manager};
				List<String> hhTargets = new List<String> {'', '', '',
				'', '', '', '', '', '', '', '', ''};
				List<String> hpTargets = new List<String> {'', '', '',
				'', '', '', '', '', '', '', '', ''};
				if(sp.KAH_HH_Admit_Target__c!=null) hhTargets.set(index, String.valueOf(sp.KAH_HH_Admit_Target__c));
				if(sp.KAH_HP_Admit_Target__c!=null) hpTargets.set(index, String.valueOf(sp.KAH_HP_Admit_Target__c));
				data.put(sp.OwnerId, new List<List<String>>{userInfo, hhTargets, hpTargets});
			}
		}

		return data.values();
	}

	private static Set<Id> getSubRoleIds(Set<Id> roleIds) {
		Set<Id> returnRoleIds = new Set<Id>();
		for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
			returnRoleIds.add(r.Id);
		}
		if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
		return returnRoleIds;
	}

}