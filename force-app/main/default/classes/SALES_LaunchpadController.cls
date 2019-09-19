global class SALES_LaunchpadController {

  @RemoteAction global static Sales_Performance__c[] getSPDataSalesCalls(Id usrId, Integer dateIterator) {
    Date month = Date.newinstance(Date.today().year(), Date.today().month()+dateIterator, 01);
    return [select Planned_Sales_Calls__c, Sales_Calls__c from Sales_Performance__c where OwnerId = :usrId and Month__c = :month];
    //return [select Complete__c from Event where Sales_Performance_Id__c in (select Id from Sales_Performance__c where OwnerId = :usrId and Month__c = :month)];
  }

  @RemoteAction global static Sales_Performance__c[] getSPData(Id usrId, Integer dateIterator) {
    Date month = Date.newinstance(Date.today().year(), Date.today().month()+dateIterator, 01);
    return [select KAH_HP_Total_Admits__c, KAH_HP_Admit_Target__c, KAH_HH_Commissionable_Admits__c, KAH_HH_Admit_Target__c, Targeted_Revenue__c, Actual_Revenue__c, Targeted_Admissions__c, Actual_Admissions__c, RecordType.Name from Sales_Performance__c where OwnerId = :usrId and Month__c = :month];
  }

  @RemoteAction global static Event[] getThisWeeksEvents(Id usrId, Integer weekIterator) {
    Date thisWeek = Date.today().toStartofWeek();
    thisWeek = thisWeek.addDays(7*weekIterator);
    return [select Id, Subject, Who.Name, WhoId, What.Name, WhatId, ActivityDateTime, Complete__c, recurrenceActivityId from Event where OwnerId = :usrId and ActivityDate >= :thisWeek and ActivityDate <= :thisWeek.addDays(6) and isRecurrence != true order by ActivityDateTime];
  }

  @RemoteAction global static User[] getDefaultRadio(Id usrId) {
    return [select Line_of_Business__c from User where Id = :usrId];
  }

  @RemoteAction global static Contact_Team__c[] getRecentBirthdays(Id usrId) {
    return [select Contact__c, Contact__r.Name, Contact__r.Birthdate, Contact__r.Title from Contact_Team__c where (Contact__r.Birthdate = LAST_N_DAYS:7 or Contact__r.Birthdate = TODAY or Contact__r.Birthdate = NEXT_N_DAYS:30) and User__c = :usrId order by Contact__r.Birthdate];
  }

  @RemoteAction global static Report[] getReports(String name) {
    return [select Id, Name, Description from Report where FolderName = :name or Name = :name];
  }

  @RemoteAction global static RecordType[] getRecordType(String name) {
    return [select Id from RecordType where Name = :name];
  }

  private static Integer daysBetween(ActivityHistory ah){
    return math.abs(Date.today().daysBetween(ah.activitydate));
  }

  @RemoteAction global static String getLastActivityByClassification(Id usrId, String alfaClassification, String numClassification, String nameSearch, String searchOption) {
    User u = [select profile.name from user where Id = :usrId];

    String returnStr = '';
    nameSearch = '%'+nameSearch+'%';
    String alfaNum;


    if(alfaClassification=='All' && numClassification=='All') alfaNum = '%';
    else if(alfaClassification=='All') alfaNum = '%'+numClassification;
    else if(numClassification=='All') alfaNum = alfaClassification+'%';
    else alfaNum = alfaClassification+numClassification;

    if(searchOption == 'HH'){
      if (alfaClassification == 'All' && numClassification == 'All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, HH_Admits_PY__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, Integer.valueOf(c.HH_Admits_PY__c), Integer.valueOf(c.KAH_HH_Admits_YTD__c), c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, HH_Admits_PY__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, Integer.valueOf(a.HH_Admits_PY__c), Integer.valueOf(a.KAH_HH_Admits_YTD__c), a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, HH_Admits_PY__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, Integer.valueOf(c.HH_Admits_PY__c), Integer.valueOf(c.KAH_HH_Admits_YTD__c), c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }

        for (Account a : [select Id, Name, KAH_Account_Classification__c, HH_Admits_PY__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, Integer.valueOf(a.HH_Admits_PY__c), Integer.valueOf(a.KAH_HH_Admits_YTD__c), a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A+' || alfaClassification == 'B' || alfaClassification == 'C' || alfaClassification == 'D' || numClassification == 'All' || alfaClassification =='All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, HH_Admits_PY__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, Integer.valueOf(c.HH_Admits_PY__c), Integer.valueOf(c.KAH_HH_Admits_YTD__c), c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, HH_Admits_PY__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, Integer.valueOf(A.HH_Admits_PY__c), Integer.valueOf(a.KAH_HH_Admits_YTD__c), a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      }
    } else if(searchOption == 'HP'){
      if (alfaClassification == 'All' && numClassification == 'All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, HP_Admits_PY__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, Integer.valueOf(c.HP_Admits_PY__c), Integer.valueOf(c.KAH_HP_Admits_YTD__c), c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, HP_Admits_PY__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, Integer.valueOf(a.HP_Admits_PY__c), Integer.valueOf(a.KAH_HP_Admits_YTD__c), a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, HP_Admits_PY__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, Integer.valueOf(c.HP_Admits_PY__c), Integer.valueOf(c.KAH_HP_Admits_YTD__c), c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }

        for (Account a : [select Id, Name, KAH_Account_Classification__c, HP_Admits_PY__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, Integer.valueOf(a.HP_Admits_PY__c), Integer.valueOf(a.KAH_HP_Admits_YTD__c), a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A+' || alfaClassification == 'B' || alfaClassification == 'C' || alfaClassification == 'D' || numClassification == 'All' || alfaClassification =='All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, HP_Admits_PY__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, Integer.valueOf(c.HP_Admits_PY__c), Integer.valueOf(c.KAH_HP_Admits_YTD__c), c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, HP_Admits_PY__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, Integer.valueOf(a.HP_Admits_PY__c), Integer.valueOf(a.KAH_HP_Admits_YTD__c), a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      }
    } else if(searchOption.contains('MTD')){
      Map<Id, Integer[]> idToAccountMetrics = new Map<Id, Integer[]>{};
      for (Sales_Account_Metrics__c am : [select account__c, month__c, KAH_HH_Admits__c, KAH_HP_Admits__c, Sales_HD_Admits__c, Sales_KHRS_Admits__c, Sales_NCD_Admits__c from Sales_Account_Metrics__c where (Month__c = this_month or Month__c = last_month) and account__c in (select accountId from accountTeamMember where userId = :usrId)]){
        Integer admits;
        if(searchOption.contains('HH')) admits = Integer.valueOf(am.KAH_HH_Admits__c);
        else if(searchOption.contains('HP')) admits = Integer.valueOf(am.KAH_HP_Admits__c);
        else if(searchOption.contains('HD')) admits = Integer.valueOf(am.Sales_HD_Admits__c);
        else if(searchOption.contains('KHRS')) admits = Integer.valueOf(am.Sales_KHRS_Admits__c);
        else if(searchOption.contains('NCD')) admits = Integer.valueOf(am.Sales_NCD_Admits__c);

        Integer[] nums = new List<Integer>{null, null};
        if(idToAccountMetrics.containsKey(am.account__c)){
          nums = idToAccountMetrics.remove(am.account__c);
          if(am.Month__c.month()==System.today().month()) nums[1]=admits;
          else nums[0]=admits;
          idToAccountMetrics.put(am.account__c, nums);
        } else {
          if(am.Month__c.month()==System.today().month()) nums[1]=admits;
          else nums[0]=admits;
          idToAccountMetrics.put(am.account__c, nums);
        }
      }

      Map<Id, Integer[]> idToContactMetrics = new Map<Id, Integer[]>{};
      for (Sales_Contact_Metrics__c cm : [select contact__c, month__c, KAH_HH_Admits__c, KAH_HP_Admits__c, Sales_HD_Admits__c, Sales_KHRS_Admits__c, Sales_NCD_Admits__c from Sales_Contact_Metrics__c where (Month__c = this_month or Month__c = last_month) and contact__c in (select contact__c from contact_team__c where user__c = :usrId)]){
        Integer admits;
        if(searchOption.contains('HH')) admits = Integer.valueOf(cm.KAH_HH_Admits__c);
        else if(searchOption.contains('HP')) admits = Integer.valueOf(cm.KAH_HP_Admits__c);
        else if(searchOption.contains('HD')) admits = Integer.valueOf(cm.Sales_HD_Admits__c);
        else if(searchOption.contains('KHRS')) admits = Integer.valueOf(cm.Sales_KHRS_Admits__c);
        else if(searchOption.contains('NCD')) admits = Integer.valueOf(cm.Sales_NCD_Admits__c);

        Integer[] nums = new List<Integer>{null, null};
        if(idToContactMetrics.containsKey(cm.contact__c)){
          nums = idToContactMetrics.remove(cm.contact__c);
          if(cm.Month__c.month()==System.today().month()) nums[1]=admits;
          else nums[0]=admits;
          idToContactMetrics.put(cm.contact__c, nums);
        } else {
          if(cm.Month__c.month()==System.today().month()) nums[1]=admits;
          else nums[0]=admits;
          idToContactMetrics.put(cm.contact__c, nums);
        }
      }

      if (alfaClassification == 'All' && numClassification == 'All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToContactMetrics.containsKey(c.Id)) nums = idToContactMetrics.remove(c.Id);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToAccountMetrics.containsKey(a.Id)) nums = idToAccountMetrics.remove(a.Id);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToContactMetrics.containsKey(c.Id)) nums = idToContactMetrics.remove(c.Id);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }

        for (Account a : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToAccountMetrics.containsKey(a.Id)) nums = idToAccountMetrics.remove(a.Id);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A+' || alfaClassification == 'B' || alfaClassification == 'C' || alfaClassification == 'D' || numClassification == 'All' || alfaClassification =='All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToContactMetrics.containsKey(c.Id)) nums = idToContactMetrics.remove(c.Id);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToAccountMetrics.containsKey(a.Id)) nums = idToAccountMetrics.remove(a.Id);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      }
    }  else if(searchOption.contains('YOY')){
      Map<Id, Integer[]> idToAccountMetrics = new Map<Id, Integer[]>{};
      for (Sales_Account_Metrics__c am : [select account__c, month__c, KAH_HH_Admits__c, KAH_HP_Admits__c, Sales_HD_Admits__c, Sales_KHRS_Admits__c, Sales_NCD_Admits__c from Sales_Account_Metrics__c where (Month__c = this_month or Month__c = n_months_ago:12) and account__c in (select accountId from accountTeamMember where userId = :usrId)]){
        Integer admits;
        if(searchOption.contains('HH')) admits = Integer.valueOf(am.KAH_HH_Admits__c);
        else if(searchOption.contains('HP')) admits = Integer.valueOf(am.KAH_HP_Admits__c);
        else if(searchOption.contains('HD')) admits = Integer.valueOf(am.Sales_HD_Admits__c);
        else if(searchOption.contains('KHRS')) admits = Integer.valueOf(am.Sales_KHRS_Admits__c);
        else if(searchOption.contains('NCD')) admits = Integer.valueOf(am.Sales_NCD_Admits__c);

        Integer[] nums = new List<Integer>{null, null};
        if(idToAccountMetrics.containsKey(am.account__c)){
          nums = idToAccountMetrics.remove(am.account__c);
          if(am.Month__c.year()==System.today().year()) nums[1]=admits;
          else nums[0]=admits;
          idToAccountMetrics.put(am.account__c, nums);
        } else {
          if(am.Month__c.year()==System.today().year()) nums[1]=admits;
          else nums[0]=admits;
          idToAccountMetrics.put(am.account__c, nums);
        }
      }

      Map<Id, Integer[]> idToContactMetrics = new Map<Id, Integer[]>{};
      for (Sales_Contact_Metrics__c cm : [select contact__c, month__c, KAH_HH_Admits__c, KAH_HP_Admits__c, Sales_HD_Admits__c, Sales_KHRS_Admits__c, Sales_NCD_Admits__c from Sales_Contact_Metrics__c where (Month__c = this_month or Month__c = n_months_ago:12) and contact__c in (select contact__c from contact_team__c where user__c = :usrId)]){
        Integer admits;
        if(searchOption.contains('HH')) admits = Integer.valueOf(cm.KAH_HH_Admits__c);
        else if(searchOption.contains('HP')) admits = Integer.valueOf(cm.KAH_HP_Admits__c);
        else if(searchOption.contains('HD')) admits = Integer.valueOf(cm.Sales_HD_Admits__c);
        else if(searchOption.contains('KHRS')) admits = Integer.valueOf(cm.Sales_KHRS_Admits__c);
        else if(searchOption.contains('NCD')) admits = Integer.valueOf(cm.Sales_NCD_Admits__c);

        Integer[] nums = new List<Integer>{null, null};
        if(idToContactMetrics.containsKey(cm.contact__c)){
          nums = idToContactMetrics.remove(cm.contact__c);
          if(cm.Month__c.year()==System.today().year()) nums[1]=admits;
          else nums[0]=admits;
          idToContactMetrics.put(cm.contact__c, nums);
        } else {
          if(cm.Month__c.year()==System.today().year()) nums[1]=admits;
          else nums[0]=admits;
          idToContactMetrics.put(cm.contact__c, nums);
        }
      }

      if (alfaClassification == 'All' && numClassification == 'All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToContactMetrics.containsKey(c.Id)) nums = idToContactMetrics.remove(c.Id);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToAccountMetrics.containsKey(a.Id)) nums = idToAccountMetrics.remove(a.Id);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToContactMetrics.containsKey(c.Id)) nums = idToContactMetrics.remove(c.Id);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }

        for (Account a : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and (not KAH_Account_Classification__c like 'A+%')  and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToAccountMetrics.containsKey(a.Id)) nums = idToAccountMetrics.remove(a.Id);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      } else if (alfaClassification == 'A+' || alfaClassification == 'B' || alfaClassification == 'C' || alfaClassification == 'D' || numClassification == 'All' || alfaClassification =='All'){
        for (Contact c : [select Id, Name, KAH_Account_Classification__c, KAH_HH_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from contact where Id in (select contact__c from contact_team__c where user__c = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(c.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(c.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToContactMetrics.containsKey(c.Id)) nums = idToContactMetrics.remove(c.Id);
          returnStr += returnStrFormat(c.Id, c.Name, c.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], c.Unity_ID__c, c.Horizon_ID__c, u.profile.name);
        }
        for (Account a : [select Id, Name, KAH_Account_Classification__c, KAH_HP_Admits_YTD__c, Unity_ID__c, Horizon_ID__c, (select activityDate from activityHistories where ownerId = :usrId and complete__c = true order by activityDate desc limit 1) from account where Id in (select accountId from accountTeamMember where userId = :usrId) and KAH_Account_Classification__c like :alfaNum and name like :nameSearch]){
          Integer daysBetween;
          if(a.getSObjects('ActivityHistories') != null) daysBetween = daysBetween(a.activityHistories);
          Integer[] nums = new List<Integer>{null, null};
          if(idToAccountMetrics.containsKey(a.Id)) nums = idToAccountMetrics.remove(a.Id);
          returnStr += returnStrFormat(a.Id, a.Name, a.KAH_Account_Classification__c, daysBetween, nums[0], nums[1], a.Unity_ID__c, a.Horizon_ID__c, u.profile.name);
        }
      }
    }
    return returnStr;
  }

  private static String returnStrFormat(Id Ids, String names, String alfaClassification, Integer daysBetween, Integer Current, Integer Prior, String Unity, String Horizon, String profileName){
    String returnStr = '';
    String color = '#E3686C';
    if(daysBetween != null){
      if (daysBetween >= 14){
        color = '#E3686C';
      } else if (daysBetween >= 7){
        color = '#FEDF6B';
      } else if (daysBetween >= 3){
        color = '#52D76C';
      } else {
        color = '#4FBAF8';
      }
    }

    String classVal;
    if (alfaClassification != null) {
      classVal = alfaClassification;
    } else {
      alfaClassification = 'N/A';
      classVal = 'Z';
    }

    if (Unity != null && profileName.contains('KAH')){
      names += ' <span class="unity">U</span>';
    }

    if (Horizon != null && profileName.contains('KAH')){
      names += ' <span class="horizon">H</span>';
    }

    String daysBetweenStr = '<i class="fa fa-times-circle-o" aria-hidden="true"></i> Never';
    String priorStr = '<i class="fa fa-times-circle-o" aria-hidden="true"></i>';
    String currentStr = '<i class="fa fa-times-circle-o" aria-hidden="true"></i>';
    if (daysBetween != null) daysBetweenStr = String.valueOf(daysBetween)+' Days';
    else daysBetween = 1000000000;
    if (Prior != null) priorStr = String.valueOf(Prior);
    if (Current != null) currentStr = String.valueOf(Current);

    returnStr += '<tr><td><a href="javascript:navigateTo(&quot;'+Ids+'&quot;, &quot;view&quot;)">'+names+'</a></td><td>'+priorStr+'</td><td>'+currentStr+'</td>'+
    '<td data-value="'+classVal+'">'+alfaClassification+'</td><td style="background:'+color+'; text-align:center;" class="sorted" data-value="'+daysBetween+'"><b>'+daysBetweenStr+'</b></td></tr>';

    return returnStr;
  }

  @RemoteAction global static String getUsersByRole(String roleId) {
    String returnStr = '';


    if([select Id from UserRole where parentRoleId = :roleId].size() >= 1){
      UserRole currentRoleName = [select Name from UserRole where Id = :roleId];
      returnStr += '<table class="table table-bordered">'+
      '<thead>'+
      '<tr>'+
      '<th>Roles</th>'+
      '<th>'+currentRoleName.Name+'</th>'+
      '</tr>'+
      '</thead>'+
      '<tbody>';
      List<UserRole> ur = [select Id, Name from UserRole where parentRoleId = :roleId order by Name];
      List<User> u = [select Id, Name from User where UserRoleId = :roleId and isActive=true order by Name];

      while(!ur.isEmpty() || !u.isEmpty()){
        if (!ur.isEmpty()){
          UserRole usrRole = ur.Remove(0);
          returnStr += '<tr><td><a onclick="getRoles(\''+usrRole.Id+'\'); roleNav.push(\''+roleId+'\'); currentRole=\''+usrRole.Id+'\';" style=\"cursor: pointer;\">'+usrRole.Name+'</a></td>';
        } else {
          returnStr += '<tr><td></td>';
        }

        if (!u.isEmpty()){
          User usr = u.Remove(0);
          returnStr += '<td><a onclick="usrId=\''+usr.Id+'\'; SPData();$(\'#managerDrilldownModal\').modal(\'hide\'); $(\'#managerDrilldown\').html(\' '+usr.Name+'\'); $(\'#drilldownSpinner\').removeClass().addClass(\'fa fa-refresh fa-spin fa-1x fa-fw\'); SPData(); $(\'#managerDrilldownEvents\').html(\' '+usr.Name+'\'); $(\'#drilldownSpinnerEvents\').show();" style="cursor: pointer;">'+usr.Name+'</a></td></tr>';
        } else {
          returnStr += '<td></td></tr>';
        }
      }

      returnStr += '</tbody>'+
      '</table>';
    } else if ([select Id from UserRole where parentRoleId = :UserInfo.getUserRoleId()].size() >= 1){
      UserRole currentRoleName = [select Name from UserRole where Id = :roleId];
      returnStr += '<table class="table table-bordered">'+
      '<thead>'+
      '<tr>'+
      '<th>Roles</th>'+
      '<th>'+currentRoleName.Name+'</th>'+
      '</tr>'+
      '</thead>'+
      '<tbody>';
      for(User u : [select Id, Name from User where UserRoleId = :roleId  and isActive=true order by Name]){
        returnStr += '<tr><td></td><td><a onclick="usrId=\''+u.Id+'\'; $(\'#managerDrilldown\').html(\' '+u.Name+'\'); $(\'#drilldownSpinner\').removeClass().addClass(\'fa fa-refresh fa-spin fa-1x fa-fw\'); SPData(); $(\'#managerDrilldownModal\').modal(\'hide\');" style="cursor: pointer;">'+u.Name+'</a></td></tr>';
      }
    } else {
      returnStr += '<div class="alert alert-danger"><b><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> This is for managers only!</b> Modifying code is against Salesforce use policy.</div>';
    }
    return returnStr;
  }

  @RemoteAction global static string getUsersUnderRoleId(Id roleId) {
    String returnStr = '';
    set<Id> allSubRoleIds = getSubRoleIds(new set<ID>{roleId});
    if([select Id, Name, UserRoleId, UserRole.Name from User where UserRoleId in :allSubRoleIds and IsActive=true].size() > 0){
      for (User u : [select Id, Name, UserRole.Name from User where UserRoleId in :allSubRoleIds and IsActive=true order by Name]){
        returnStr += '<tr><td><a onclick="$(\'#roleDrilldown-tab\').tab(\'show\'); $(\'#roleHierarchy\').show(); $(\'#roleHierarchyButtons\').show(); $(\'#roleHierarchyText\').show(); $(\'#usersUnderRole\').hide(); $(\'#roleSearchText\').hide(); $(\'#usersUnderRoleTableSearch\').hide(); getRoles(\''+u.UserRoleId+'\'); roleNav.push(\''+roleId+'\'); currentRole=\''+u.UserRoleId+'\';" style=\"cursor: pointer;\">'+u.UserRole.Name+'</a></td><td><a onclick="usrId=\''+u.Id+'\'; $(\'#managerDrilldown\').html(\' '+u.Name+'\'); $(\'#drilldownSpinner\').removeClass().addClass(\'fa fa-refresh fa-spin fa-1x fa-fw\'); SPData(); $(\'#managerDrilldownModal\').modal(\'hide\');" style="cursor: pointer;">'+u.Name+'</a></td></tr>';
      }
    }
    return returnStr;
  }

  private static set<Id> getSubRoleIds(set<Id> roleIds) {
    set<Id> returnRoleIds = new set<Id>();
    for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
      returnRoleIds.add(r.Id);
    }
    if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
    return returnRoleIds;
  }

  @RemoteAction global static void emailLastActivityByClassification(Id usrId, String tableContents) {
    User u = [select Name from user where Id = :usrId];

    Messaging.EmailFileAttachment attachmentPDF = new Messaging.EmailFileAttachment();
    attachmentPDF.setFileName(u.Name + '\'s Last Called Referral Sources '+Date.today().month()+'-'+Date.today().day()+'-'+Date.today().year()+'.csv');
    attachmentPDF.setBody(Blob.valueOf(tableContents));

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    List<String> toAddresses = new List<String>{UserInfo.getUserEmail()};
    email.setSubject('Report Generated! '+u.Name + '\'s Last Called Referral Sources');
    email.setToAddresses(toAddresses);
    email.setHtmlBody('Hi '+UserInfo.getFirstName()+',<br><br>Attached to this email you will find a CSV file containing the data you requested from Salesforce.<br><br><b>Requested File: </b> '+u.Name + '\'s Last Called Referral Sources '+Date.today().month()+'-'+Date.today().day()+'-'+Date.today().year()+'.csv<br><br>Thank you,<br><a href="mailto:salessupport@kindred.com" target="_top">Kindred Healthcare Sales Support</a>');
    email.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachmentPDF});
    List<Messaging.SendEmailResult> r = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
  }
  
  @RemoteAction global static String getLogins(Id usrId, Id roleId){
    Set<Id> allSubRoleIds = new Set<ID>();
    allSubRoleIds.addAll(getSubRoleIds(new Set<ID>{roleId}));
    Integer userCount = [select Name, LastLoginDate from User where UserRoleId in :allSubRoleIds and IsActive=true].size();
    String html = '{"count": '+userCount+', "html": "';
    if(userCount > 0){
      for (User u : [select Name, LastLoginDate from User where UserRoleId in :allSubRoleIds and IsActive=true]){
        Integer integerDaysBetween = 1000000000;
        String stringDaysBetween = '<i class=\\"fa fa-times-circle-o\\" aria-hidden=\\"true\\"></i> Never';
        String name = String.valueOf(u.Name).replace('"', '\\"');
        if(u.LastLoginDate!=null){
          integerDaysBetween = Integer.valueOf(math.abs(Date.today().daysBetween(Date.valueOf(u.LastLoginDate))));
          stringDaysBetween = String.valueOf(integerDaysBetween) + ' Days';
        }
        html +='<tr><td data-value=\\"'+name+'\\">'+name+'</td><td data-value=\\"'+integerDaysBetween+'\\"><b>'+ stringDaysBetween+'</b></td></tr>';
      }
    }
    html += '"}';
    return html;
  }

}//end SALES_LaunchpadController