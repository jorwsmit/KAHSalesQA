global with sharing class Sales_ReferralSourceTrendReport {
    @RemoteAction global static String getUsers(Id roleId){
        String html = '';
        List<Id> allSubRoleIds = new List<ID>{roleId};
        allSubRoleIds.addAll(getSubRoleIds(new List<ID>{roleId}));
        if([select Id, Name, UserRoleId, UserRole.Name from User where UserRoleId in :allSubRoleIds and IsActive=true].size() > 0){
            for (User u : [select Id, Name, Line_Of_Business__c from User where UserRoleId in :allSubRoleIds and IsActive=true order by Name]){
                html += '<li><a onclick="selectUser(\''+u.Name+'\', \''+u.Id+'\', \''+u.Line_Of_Business__c+'\')">'+u.Name+'</a></li>';
            }
        }
        return html;
    }

    @RemoteAction global static List<User> getUsers_2(){
        List<Id> allSubRoleIds = new List<ID>{UserInfo.getUserRoleId()};
        allSubRoleIds.addAll(getSubRoleIds(new List<ID>{UserInfo.getUserRoleId()}));
        return [select Id, Name, Line_Of_Business__c from User where UserRoleId in :allSubRoleIds and IsActive=true order by Name];
    }

    @RemoteAction global static String getData_2(Id usrId, String[] years, String lob){
        String html = '';
        List<String> temp;
        Map<String, List<String>> accountData = new Map<String, List<String>>();
        Map<String, List<String>> contactData = new Map<String, List<String>>();
        Map<String, List<String>> data = new Map<String, List<String>>();
        List<String> newBusiness = new List<String>();

        for(AccountTeamMember atm : [select AccountId, Account.Name from AccountTeamMember where UserId = :usrId and (Account.Unity_Id__c!=null or Account.Horizon_Id__c!=null)]){
            if(years.size()==1) temp = new String[36];
            if(years.size()==2) temp = new String[72];
            accountData.put(atm.AccountId+String.valueOf(atm.Account.Name), temp);
        }

        for(Contact_Team__c ct : [select Contact__c, Contact__r.Name from Contact_Team__c where User__c = :usrId and (Contact__r.Unity_Id__c!=null or Contact__r.Horizon_Id__c!=null)]){
            if(years.size()==1) temp = new String[36];
            if(years.size()==2) temp = new String[72];
            contactData.put(ct.Contact__c+String.valueOf(ct.Contact__r.Name), temp);
        }

        for(Business_Plan__c bp : [select Account__c, Contact__c from Business_Plan__c where User__c=:usrId]){
            if(bp.Account__c!=null) swots.add(bp.Account__c);
            else if(bp.Contact__c!=null) swots.add(bp.Contact__c);
        }

        for(New_Business__c nb : [select Account__c, Contact__c from New_Business__c where User__c=:usrId]){
            if(nb.Account__c!=null) newBusiness.add(nb.Account__c);
            else if(nb.Contact__c!=null) newBusiness.add(nb.Contact__c);
        }

        for(Sales_5x5x5_Ratings__c r : [select Account__c, Contact__c, Rating__c from Sales_5x5x5_Ratings__c where User__c=:usrId]){
            String color = '';
            if(r.Rating__c=='Top') color = '#28a745';
            else if(r.Rating__c=='Flat') color = '#f5bf1b';
            else if(r.Rating__c=='Bottom') color = '#dc3545';

            if(r.Account__c!=null) ratings.put(r.Account__c, color);
            else if(r.Contact__c!=null) ratings.put(r.Contact__c, color);
        }



        if(years.size()==1){
            Date monthBegin = Date.newInstance(Integer.valueOf(years[0]), 01, 01);
            Date monthEnd = Date.newInstance(Integer.valueOf(years[0]), 12, 31);

            /*
            TEMP DATA STRUCTURE
            0-11 are admits for JAN-FEB
            12-23 are referrals for JAN-FEB
            24-35 are qualified admits for JAN-FEB
            */

            for(Sales_Account_Metrics__c am : [select Account__c, Account__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c from Sales_Account_Metrics__c where
            (Month__c>=:monthBegin and Month__c<=:monthEnd) and Account__c in
            (select AccountId from AccountTeamMember where UserId = :usrId and (Account.Unity_Id__c!=null or Account.Horizon_Id__c!=null))]){
                temp = new String[36];
                if(accountData.containsKey(am.Account__c+String.valueOf(am.Account__r.Name)))
                temp = accountData.remove(am.Account__c+String.valueOf(am.Account__r.Name));
                if(lob=='HH'){
                    if(am.KAH_HH_Admits__c!=null) temp.set(am.Month__c.month()-1, String.valueOf(am.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1, String.valueOf(0));

                    if(am.KAH_HH_Referrals__c!=null) temp.set(am.Month__c.month()+11, String.valueOf(am.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+11, String.valueOf(0));

                    if(am.KAH_HH_PPS_Admits__c!=null) temp.set(am.Month__c.month()+23, String.valueOf(am.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23, String.valueOf(0));
                } else if(lob=='HP'){
                    if(am.KAH_HP_Admits__c!=null) temp.set(am.Month__c.month()-1, String.valueOf(am.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1, String.valueOf(0));

                    if(am.KAH_HP_Referrals__c!=null) temp.set(am.Month__c.month()+11, String.valueOf(am.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+11, String.valueOf(0));

                    if(am.KAH_HP_Qualified_Admits__c!=null) temp.set(am.Month__c.month()+23, String.valueOf(am.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23, String.valueOf(0));
                }
                accountData.put(am.Account__c+String.valueOf(am.Account__r.Name), temp);
            }

            for(Sales_Contact_Metrics__c cm : [select Contact__c, Contact__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c from Sales_Contact_Metrics__c where
            (Month__c>=:monthBegin and Month__c<=:monthEnd) and Contact__c in
            (select Contact__c from Contact_Team__c where User__c = :usrId and (Contact__r.Unity_Id__c!=null or Contact__r.Horizon_Id__c!=null))]){
                temp = new String[36];
                if(contactData.containsKey(cm.Contact__c+String.valueOf(cm.Contact__r.Name)))
                temp = contactData.remove(cm.Contact__c+String.valueOf(cm.Contact__r.Name));
                if(lob=='HH'){
                    if(cm.KAH_HH_Admits__c!=null) temp.set(cm.Month__c.month()-1, String.valueOf(cm.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1, String.valueOf(0));

                    if(cm.KAH_HH_Referrals__c!=null) temp.set(cm.Month__c.month()+11, String.valueOf(cm.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+11, String.valueOf(0));

                    if(cm.KAH_HH_PPS_Admits__c!=null) temp.set(cm.Month__c.month()+23, String.valueOf(cm.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23, String.valueOf(0));
                } else if(lob=='HP'){
                    if(cm.KAH_HP_Admits__c!=null) temp.set(cm.Month__c.month()-1, String.valueOf(cm.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1, String.valueOf(0));

                    if(cm.KAH_HP_Referrals__c!=null) temp.set(cm.Month__c.month()+11, String.valueOf(cm.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+11, String.valueOf(0));

                    if(cm.KAH_HP_Qualified_Admits__c!=null) temp.set(cm.Month__c.month()+23, String.valueOf(cm.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23, String.valueOf(0));
                }
                contactData.put(cm.Contact__c+String.valueOf(cm.Contact__r.Name), temp);
            }

            data.putAll(accountData);
            data.putAll(contactData);

            for(AggregateResult ar : [select whoId, whatId, count(id)num, calendar_month(month__c)month, calendar_year(month__c)year from event
            where ownerId=:usrId and (whoId!=null or whatId!=null) and complete__c=true and (ActivityDate>=:monthBegin and ActivityDate<=:monthEnd)
            group by whoId, whatId, calendar_month(month__c), calendar_year(month__c)]){
                if(ar.get('whatId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whatId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whatId')));
                    temp[Integer.valueOf(ar.get('month'))-1] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whatId')), temp);
                }
                if(ar.get('whoId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whoId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whoId')));
                    temp[Integer.valueOf(ar.get('month'))-1] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whoId')), temp);
                }
            }

        } else if(years.size()==2){

            /*
            TEMP DATA STRUCTURE
            0-11 are admits for JAN-FEB for year[0]
            12-23 are admits for JAN-FEB for year[1]
            24-35 are referrals for JAN-FEB for year[0]
            36-47 are referrals for JAN-FEB for year[1]
            48-59 are qualified admits for JAN-FEB for year[0]
            60-71 are qualified admits for JAN-FEB for year[1]
            */

            years.sort();
            Date monthBegin1 = Date.newInstance(Integer.valueOf(years[0]), 01, 01);
            Date monthEnd1 = Date.newInstance(Integer.valueOf(years[0]), 12, 31);
            Date monthBegin2 = Date.newInstance(Integer.valueOf(years[1]), 01, 01);
            Date monthEnd2 = Date.newInstance(Integer.valueOf(years[1]), 12, 31);

            for(Sales_Account_Metrics__c am : [select Account__c, Account__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c
            from Sales_Account_Metrics__c where ((Month__c>=:monthBegin1 and Month__c<=:monthEnd1) or (Month__c>=:monthBegin2 and Month__c<=:monthEnd2))
            and Account__c in (select AccountId from AccountTeamMember where UserId = :usrId and (Account.Unity_Id__c!=null or Account.Horizon_Id__c!=null))]){
                temp = new String[72];
                Integer addYear=0;
                if(am.Month__c.year()==Double.valueOf(years[1])) addYear=12;
                if(accountData.containsKey(am.Account__c+String.valueOf(am.Account__r.Name)))
                temp = accountData.remove(am.Account__c+String.valueOf(am.Account__r.Name));
                if(lob=='HH'){
                    if(am.KAH_HH_Admits__c!=null) temp.set(am.Month__c.month()-1+addYear, String.valueOf(am.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1+addYear, String.valueOf(0));

                    if(am.KAH_HH_Referrals__c!=null) temp.set(am.Month__c.month()+23+addYear, String.valueOf(am.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23+addYear, String.valueOf(0));

                    if(am.KAH_HH_PPS_Admits__c!=null) temp.set(am.Month__c.month()+47+addYear, String.valueOf(am.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+47+addYear, String.valueOf(0));
                } else if(lob=='HP'){
                    if(am.KAH_HP_Admits__c!=null) temp.set(am.Month__c.month()-1+addYear, String.valueOf(am.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1+addYear, String.valueOf(0));

                    if(am.KAH_HP_Referrals__c!=null) temp.set(am.Month__c.month()+23+addYear, String.valueOf(am.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23+addYear, String.valueOf(0));

                    if(am.KAH_HP_Qualified_Admits__c!=null) temp.set(am.Month__c.month()+47+addYear, String.valueOf(am.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+47+addYear, String.valueOf(0));
                }
                accountData.put(am.Account__c+String.valueOf(am.Account__r.Name), temp);
            }

            for(Sales_Contact_Metrics__c cm : [select Contact__c, Contact__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c
            from Sales_Contact_Metrics__c where ((Month__c>=:monthBegin1 and Month__c<=:monthEnd1) or (Month__c>=:monthBegin2 and Month__c<=:monthEnd2))
            and Contact__c in (select Contact__c from Contact_Team__c where User__c = :usrId and (Contact__r.Unity_Id__c!=null or Contact__r.Horizon_Id__c!=null))]){
                temp = new String[72];
                Integer addYear=0;
                if(cm.Month__c.year()==Double.valueOf(years[1])) addYear=12;
                if(contactData.containsKey(cm.Contact__c+String.valueOf(cm.Contact__r.Name)))
                temp = contactData.remove(cm.Contact__c+String.valueOf(cm.Contact__r.Name));
                if(lob=='HH'){
                    if(cm.KAH_HH_Admits__c!=null) temp.set(cm.Month__c.month()-1+addYear, String.valueOf(cm.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1+addYear, String.valueOf(0));

                    if(cm.KAH_HH_Referrals__c!=null) temp.set(cm.Month__c.month()+23+addYear, String.valueOf(cm.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23+addYear, String.valueOf(0));

                    if(cm.KAH_HH_PPS_Admits__c!=null) temp.set(cm.Month__c.month()+47+addYear, String.valueOf(cm.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+47+addYear, String.valueOf(0));

                } else if(lob=='HP'){
                    if(cm.KAH_HP_Admits__c!=null) temp.set(cm.Month__c.month()-1+addYear, String.valueOf(cm.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1+addYear, String.valueOf(0));

                    if(cm.KAH_HP_Referrals__c!=null) temp.set(cm.Month__c.month()+23+addYear, String.valueOf(cm.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23+addYear, String.valueOf(0));

                    if(cm.KAH_HP_Qualified_Admits__c!=null) temp.set(cm.Month__c.month()+47+addYear, String.valueOf(cm.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+47+addYear, String.valueOf(0));
                }
                contactData.put(cm.Contact__c+String.valueOf(cm.Contact__r.Name), temp);
            }

            data.putAll(accountData);
            data.putAll(contactData);

            for(AggregateResult ar : [select whoId, whatId, count(id)num, calendar_month(month__c)month, calendar_year(month__c)year from event
            where ownerId=:usrId and (whoId!=null or whatId!=null) and complete__c=true and ((ActivityDate>=:monthBegin1 and ActivityDate<=:monthEnd1) or
            (ActivityDate>=:monthBegin2 and ActivityDate<=:monthEnd2)) group by whoId, whatId, calendar_month(month__c), calendar_year(month__c)]){
                Integer addYear=0;
                if(Integer.valueOf(ar.get('year'))==Double.valueOf(years[1])) addYear=12;
                if(ar.get('whatId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whatId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whatId')));
                    temp[Integer.valueOf(ar.get('month'))-1+addYear] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1+addYear])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whatId')), temp);
                }
                if(ar.get('whoId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whoId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whoId')));
                    temp[Integer.valueOf(ar.get('month'))-1+addYear] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1+addYear])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whoId')), temp);
                }
            }
        }
        return '{"admitData":'+JSON.serialize(data)+', "callData": '+JSON.serialize(salesCalls)+', "ratingsData": '+JSON.serialize(ratings)+', "swotData": '+JSON.serialize(swots)+', "newBusinessData": '+JSON.serialize(newBusiness)+'}';
    }


    private static List<Id> getSubRoleIds(List<Id> roleIds) {
        List<Id> returnRoleIds = new List<Id>();
        for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
            returnRoleIds.add(r.Id);
        }
        if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
        return returnRoleIds;
    }

    private static Set<String> swots = new Set<String>();
    private static Map<String, String> ratings = new Map<String, String>();
    private static Map<String, List<String>> salesCalls = new Map<String, List<String>>();

    public static String oneYearReferral(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[12+(i*3)+j]);
                    total_1 += Integer.valueOf(data[12+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[12+(i*3)+j]);
                } else data[12+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[12]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[13]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[14]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[15]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[16]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[17]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[18]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[19]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[20]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[21]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[22]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[23]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+ytd_1+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+total_1+'</div></td>';
        html += '</tr>';

        return html;
    }

    public static String oneYearAdmit(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[(i*3)+j]);
                    total_1 += Integer.valueOf(data[(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[(i*3)+j]);
                } else data[(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[0]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[1]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[3]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[4]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[5]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[6]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[7]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[8]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[9]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[10]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[11]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+ytd_1+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+total_1+'</div></td>';
        html += '</tr>';

        return html;
    }

    public static String oneYearQualifiedAdmit(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[24+(i*3)+j]);
                    total_1 += Integer.valueOf(data[24+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[24+(i*3)+j]);
                } else data[24+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[24]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[25]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[26]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[27]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[28]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[29]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[30]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[31]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[32]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[33]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[34]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[35]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+ytd_1+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+total_1+'</div></td>';
        html += '</tr>';

        return html;
    }

    public static String oneYearConversion(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        List<String> months1 = new List<String>{'','','','','','','','','','','',''};

        for(Integer i=0;i<months1.size();i++){
            months1[i] = getConversion(data[i], data[i+12]);
        }

        List<String> quarters1 = new List<String>{'','','',''};

        Integer ytdAdmits_1=0, totalAdmits_1=0, ytdReferrals_1=0, totalReferrals_1=0;

        for(Integer i=0;i<4;i++){
            Integer admit_1=0, referral_1=0;
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric()){
                    admit_1 += Integer.valueOf(data[(i*3)+j]);
                    totalAdmits_1 += Integer.valueOf(data[(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdAdmits_1+=Integer.valueOf(data[(i*3)+j]);
                }
                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric()){
                    referral_1 += Integer.valueOf(data[12+(i*3)+j]);
                    totalReferrals_1 += Integer.valueOf(data[12+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdReferrals_1+=Integer.valueOf(data[12+(i*3)+j]);
                }
            }
            quarters1[i] = getConversion(String.valueOf(admit_1), String.valueOf(referral_1));
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;">'+years[0]+'</div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;">'+years[0]+'</div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[0]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[1]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[3]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[4]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[5]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[6]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[7]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[8]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[9]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[10]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[11]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+getConversion(String.valueOf(ytdAdmits_1), String.valueOf(ytdReferrals_1))+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+getConversion(String.valueOf(totalAdmits_1), String.valueOf(totalReferrals_1))+'</div></td>';
        html += '</tr>';

        return html;
    }

    public static String oneYearCalls(String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);



        List<String> data = new List<String>{'<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>'};

        if(salesCalls.containsKey(key.left(18)))
        data = salesCalls.remove(key.left(18));

        Integer ytd_1=0, total_1=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric() && Integer.valueOf(data[(i*3)+j])!=0){
                    quarters1[i] += Integer.valueOf(data[(i*3)+j]);
                    total_1 += Integer.valueOf(data[(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[(i*3)+j]);
                } else data[(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[0]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[1]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[3]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[4]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[5]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[6]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[7]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[8]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[9]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[10]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[11]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+ytd_1+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+total_1+'</div></td>';
        html += '</tr>';

        return html;
    }

    public static String oneYearAdmitCalls(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1_admits=0, total_1_admits=0;
        List<Integer> quarters1_admits = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric()){
                    quarters1_admits[i] += Integer.valueOf(data[24+(i*3)+j]);
                    total_1_admits += Integer.valueOf(data[24+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1_admits+=Integer.valueOf(data[24+(i*3)+j]);
                } else data[24+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
            }
        }

        List<String> callData = new List<String>{'<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>'};

        if(salesCalls.containsKey(key.left(18)))
        callData = salesCalls.remove(key.left(18));

        Integer ytd_1_calls=0, total_1_calls=0;
        List<Integer> quarters1_calls = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(callData[(i*3)+j]!=null && callData[(i*3)+j].isNumeric() && Integer.valueOf(callData[(i*3)+j])!=0){
                    quarters1_calls[i] += Integer.valueOf(callData[(i*3)+j]);
                    total_1_calls += Integer.valueOf(callData[(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1_calls+=Integer.valueOf(callData[(i*3)+j]);
                } else callData[(i*3)+j] = '<span class="lnr lnr-cross"></span>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[24]+' / '+callData[0]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[25]+' / '+callData[1]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[26]+' / '+callData[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[0]+' / '+quarters1_calls[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[27]+' / '+callData[3]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[28]+' / '+callData[4]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[29]+' / '+callData[5]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[1]+' / '+quarters1_calls[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[30]+' / '+callData[6]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[31]+' / '+callData[7]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[32]+' / '+callData[8]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[2]+' / '+quarters1_calls[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[33]+' / '+callData[9]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[34]+' / '+callData[10]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[35]+' / '+callData[11]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[3]+' / '+quarters1_calls[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(ytd_1_calls).setScale(0))+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(total_1_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(total_1_calls).setScale(0))+'</div></td>';
        html += '</tr>';

        return html;
    }

    public static String twoYearAdmit(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[(i*3)+j]);
                    total_1 += Integer.valueOf(data[(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[(i*3)+j]);
                } else data[(i*3)+j] = '<div class="lnr lnr-cross"></div>';

                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric()){
                    quarters2[i] += Integer.valueOf(data[12+(i*3)+j]);
                    total_2 += Integer.valueOf(data[12+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_2+=Integer.valueOf(data[12+(i*3)+j]);
                } else data[12+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[0]+'</div><div class="slds-truncate">'+data[12]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[1]+'</div><div class="slds-truncate">'+data[13]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[2]+'</div><div class="slds-truncate">'+data[14]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[3]+'</div><div class="slds-truncate">'+data[15]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[4]+'</div><div class="slds-truncate">'+data[16]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[5]+'</div><div class="slds-truncate">'+data[17]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[6]+'</div><div class="slds-truncate">'+data[18]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[7]+'</div><div class="slds-truncate">'+data[19]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[8]+'</div><div class="slds-truncate">'+data[20]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[9]+'</div><div class="slds-truncate">'+data[21]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[10]+'</div><div class="slds-truncate">'+data[22]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[11]+'</div><div class="slds-truncate">'+data[23]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String twoYearQualifiedAdmit(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[48+(i*3)+j]!=null && data[48+(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[48+(i*3)+j]);
                    total_1 += Integer.valueOf(data[48+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[48+(i*3)+j]);
                } else data[48+(i*3)+j] = '<div class="lnr lnr-cross"></div>';

                if(data[60+(i*3)+j]!=null && data[60+(i*3)+j].isNumeric()){
                    quarters2[i] += Integer.valueOf(data[60+(i*3)+j]);
                    total_2 += Integer.valueOf(data[60+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_2+=Integer.valueOf(data[60+(i*3)+j]);
                } else data[60+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[48]+'</div><div class="slds-truncate">'+data[60]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[49]+'</div><div class="slds-truncate">'+data[61]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[50]+'</div><div class="slds-truncate">'+data[62]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[51]+'</div><div class="slds-truncate">'+data[63]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[52]+'</div><div class="slds-truncate">'+data[64]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[53]+'</div><div class="slds-truncate">'+data[65]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[54]+'</div><div class="slds-truncate">'+data[66]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[55]+'</div><div class="slds-truncate">'+data[67]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[56]+'</div><div class="slds-truncate">'+data[68]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[57]+'</div><div class="slds-truncate">'+data[69]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[58]+'</div><div class="slds-truncate">'+data[70]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[59]+'</div><div class="slds-truncate">'+data[71]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String getPercent(Decimal earlierNum, Decimal laterNum){
        String html = '';
        if(earlierNum!=0){
            if(((laterNum-earlierNum)/earlierNum)*100 > 0){
                html = ' <span style="float:right;text-align:center;font-size:10px;color:white;width:60px;background-color:#6bba76;border-radius:25px;"><span class="lnr lnr-arrow-up"></span>'+String.valueOf((((laterNum-earlierNum)/earlierNum)*100).setScale(0))+'%</span>';
            } else if(((laterNum-earlierNum)/earlierNum)*100 < 0){
                html = ' <span style="float:right;text-align:center;font-size:10px;color:white;width:60px;background-color:#dd786c;border-radius:25px;"><span class="lnr lnr-arrow-down"></span>'+String.valueOf((((laterNum-earlierNum)/earlierNum)*100).setScale(0))+'%</span>';
            } else {
                html = ' <span style="float:right;text-align:center;font-size:10px;color:white;width:60px;background-color:#b7b7b7;border-radius:25px;">0%</span>';
            }
        }
        return html;
    }

    public static String twoYearReferral(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[24+(i*3)+j]);
                    total_1 += Integer.valueOf(data[24+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[24+(i*3)+j]);
                } else data[24+(i*3)+j] = '<div class="lnr lnr-cross"></div>';

                if(data[36+(i*3)+j]!=null && data[36+(i*3)+j].isNumeric()){
                    quarters2[i] += Integer.valueOf(data[36+(i*3)+j]);
                    total_2 += Integer.valueOf(data[36+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_2+=Integer.valueOf(data[36+(i*3)+j]);
                } else data[36+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[24]+'</div><div class="slds-truncate">'+data[36]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[25]+'</div><div class="slds-truncate">'+data[37]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[26]+'</div><div class="slds-truncate">'+data[38]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[27]+'</div><div class="slds-truncate">'+data[39]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[28]+'</div><div class="slds-truncate">'+data[40]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[29]+'</div><div class="slds-truncate">'+data[41]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[30]+'</div><div class="slds-truncate">'+data[42]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[31]+'</div><div class="slds-truncate">'+data[43]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[32]+'</div><div class="slds-truncate">'+data[44]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[33]+'</div><div class="slds-truncate">'+data[45]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[34]+'</div><div class="slds-truncate">'+data[46]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[35]+'</div><div class="slds-truncate">'+data[47]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String getConversion(String admit, String referral){
        String html='';
        if(referral!=null && referral.isNumeric() && Decimal.valueOf(referral)!=0) html = String.valueOf(((Decimal.valueOf(admit)/Decimal.valueOf(referral))*100).setScale(1))+'%';
        else html = '<div class="lnr lnr-cross"></div>';
        return html;
    }

    public static String twoYearConversion(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        List<String> months1 = new List<String>{'','','','','','','','','','','',''};
        List<String> months2 = new List<String>{'','','','','','','','','','','',''};

        for(Integer i=0;i<months1.size();i++){
            months1[i] = getConversion(data[i], data[i+24]);
            months2[i] = getConversion(data[i+12], data[i+36]);
        }

        List<String> quarters1 = new List<String>{'','','',''};
        List<String> quarters2 = new List<String>{'','','',''};


        Integer ytdAdmits_1=0, totalAdmits_1=0, ytdReferrals_1=0, totalReferrals_1=0,
        ytdAdmits_2=0, totalAdmits_2=0, ytdReferrals_2=0, totalReferrals_2=0;

        for(Integer i=0;i<4;i++){
            Integer admit_1=0, referral_1=0, admit_2=0, referral_2=0;
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric()){
                    admit_1 += Integer.valueOf(data[(i*3)+j]);
                    totalAdmits_1 += Integer.valueOf(data[(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdAdmits_1+=Integer.valueOf(data[(i*3)+j]);
                }
                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric()){
                    admit_2 += Integer.valueOf(data[12+(i*3)+j]);
                    totalAdmits_2 += Integer.valueOf(data[12+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdAdmits_2+=Integer.valueOf(data[12+(i*3)+j]);
                }

                if(data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric()){
                    referral_1 += Integer.valueOf(data[24+(i*3)+j]);
                    totalReferrals_1 += Integer.valueOf(data[24+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdReferrals_1+=Integer.valueOf(data[24+(i*3)+j]);
                }
                if(data[36+(i*3)+j]!=null && data[36+(i*3)+j].isNumeric()){
                    referral_2 += Integer.valueOf(data[36+(i*3)+j]);
                    totalReferrals_2 += Integer.valueOf(data[36+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdReferrals_2+=Integer.valueOf(data[36+(i*3)+j]);
                }
            }
            quarters1[i] = getConversion(String.valueOf(admit_1), String.valueOf(referral_1));
            quarters2[i] = getConversion(String.valueOf(admit_2), String.valueOf(referral_2));
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[0]+'</div><div class="slds-truncate">'+months2[0]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[1]+'</div><div class="slds-truncate">'+months2[1]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[2]+'</div><div class="slds-truncate">'+months2[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[3]+'</div><div class="slds-truncate">'+months2[3]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[4]+'</div><div class="slds-truncate">'+months2[4]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[5]+'</div><div class="slds-truncate">'+months2[5]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[6]+'</div><div class="slds-truncate">'+months2[6]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[7]+'</div><div class="slds-truncate">'+months2[7]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[8]+'</div><div class="slds-truncate">'+months2[8]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[9]+'</div><div class="slds-truncate">'+months2[9]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[10]+'</div><div class="slds-truncate">'+months2[10]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[11]+'</div><div class="slds-truncate">'+months2[11]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+getConversion(String.valueOf(ytdAdmits_1), String.valueOf(ytdReferrals_1))+'</div><div>'+getConversion(String.valueOf(ytdAdmits_2), String.valueOf(ytdReferrals_2))+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+getConversion(String.valueOf(totalAdmits_1), String.valueOf(totalReferrals_1))+'</div><div>'+getConversion(String.valueOf(totalAdmits_2), String.valueOf(totalReferrals_2))+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String twoYearCalls(String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        List<String> data = new List<String>{'<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>'};

        if(salesCalls.containsKey(key.left(18)))
        data = salesCalls.remove(key.left(18));

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric() && Integer.valueOf(data[(i*3)+j])!=0){
                    quarters1[i] += Integer.valueOf(data[(i*3)+j]);
                    total_1 += Integer.valueOf(data[(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[(i*3)+j]);
                } else data[(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric() && Integer.valueOf(data[12+(i*3)+j])!=0){
                    quarters2[i] += Integer.valueOf(data[12+(i*3)+j]);
                    total_2 += Integer.valueOf(data[12+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_2+=Integer.valueOf(data[12+(i*3)+j]);
                } else data[12+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[0]+'</div><div class="slds-truncate">'+data[12]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[1]+'</div><div class="slds-truncate">'+data[13]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[2]+'</div><div class="slds-truncate">'+data[14]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[3]+'</div><div class="slds-truncate">'+data[15]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[4]+'</div><div class="slds-truncate">'+data[16]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[5]+'</div><div class="slds-truncate">'+data[17]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[6]+'</div><div class="slds-truncate">'+data[18]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[7]+'</div><div class="slds-truncate">'+data[19]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[8]+'</div><div class="slds-truncate">'+data[20]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[9]+'</div><div class="slds-truncate">'+data[21]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[10]+'</div><div class="slds-truncate">'+data[22]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[11]+'</div><div class="slds-truncate">'+data[23]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String twoYearAdmitCalls(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1_admits=0, total_1_admits=0, ytd_2_admits=0, total_2_admits=0;
        List<Integer> quarters1_admits = new List<Integer>{0,0,0,0};
        List<Integer> quarters2_admits = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[48+(i*3)+j]!=null && data[48+(i*3)+j].isNumeric()){
                    quarters1_admits[i] += Integer.valueOf(data[48+(i*3)+j]);
                    total_1_admits += Integer.valueOf(data[48+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_1_admits+=Integer.valueOf(data[48+(i*3)+j]);
                } else data[48+(i*3)+j] = '<span class="lnr lnr-cross"></span>';

                if(data[60+(i*3)+j]!=null && data[60+(i*3)+j].isNumeric()){
                    quarters2_admits[i] += Integer.valueOf(data[60+(i*3)+j]);
                    total_2_admits += Integer.valueOf(data[60+(i*3)+j]);
                    if( ((i*3)+j) < System.today().month()) ytd_2_admits+=Integer.valueOf(data[60+(i*3)+j]);
                } else data[60+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
            }
        }

        List<String> callData = new List<String>{'<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>'};

        if(salesCalls.containsKey(key.left(18)))
        callData = salesCalls.remove(key.left(18));

        Integer ytd_1_calls=0, total_1_calls=0, ytd_2_calls=0, total_2_calls=0;
        List<Integer> quarters1_calls = new List<Integer>{0,0,0,0};
        List<Integer> quarters2_calls = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(callData[(i*3)+j]!=null && callData[(i*3)+j].isNumeric() && Integer.valueOf(callData[(i*3)+j])!=0){
                    quarters1_calls[i] += Integer.valueOf(callData[(i*3)+j]);
                    total_1_calls += Integer.valueOf(callData[(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_1_calls+=Integer.valueOf(callData[(i*3)+j]);
                } else callData[(i*3)+j] = '<span class="lnr lnr-cross"></span>';
                if(callData[12+(i*3)+j]!=null && callData[12+(i*3)+j].isNumeric() && Integer.valueOf(callData[12+(i*3)+j])!=0){
                    quarters2_calls[i] += Integer.valueOf(callData[12+(i*3)+j]);
                    total_2_calls += Integer.valueOf(callData[12+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_2_calls+=Integer.valueOf(callData[12+(i*3)+j]);
                } else callData[12+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[48]+' / '+callData[0]+'</div><div class="slds-truncate">'+data[60]+' / '+callData[12]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[49]+' / '+callData[1]+'</div><div class="slds-truncate">'+data[61]+' / '+callData[13]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[50]+' / '+callData[2]+'</div><div class="slds-truncate">'+data[62]+' / '+callData[14]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[0]+' / '+quarters1_calls[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[0]+' / '+quarters2_calls[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[51]+' / '+callData[3]+'</div><div class="slds-truncate">'+data[63]+' / '+callData[15]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[52]+' / '+callData[4]+'</div><div class="slds-truncate">'+data[64]+' / '+callData[16]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[53]+' / '+callData[5]+'</div><div class="slds-truncate">'+data[65]+' / '+callData[17]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[1]+' / '+quarters1_calls[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[1]+' / '+quarters2_calls[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[54]+' / '+callData[6]+'</div><div class="slds-truncate">'+data[66]+' / '+callData[18]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[55]+' / '+callData[7]+'</div><div class="slds-truncate">'+data[67]+' / '+callData[19]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[56]+' / '+callData[8]+'</div><div class="slds-truncate">'+data[68]+' / '+callData[20]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[2]+' / '+quarters1_calls[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[2]+' / '+quarters2_calls[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[57]+' / '+callData[9]+'</div><div class="slds-truncate">'+data[69]+' / '+callData[21]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[58]+' / '+callData[10]+'</div><div class="slds-truncate">'+data[70]+' / '+callData[22]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[59]+' / '+callData[11]+'</div><div class="slds-truncate">'+data[71]+' / '+callData[23]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[3]+' / '+quarters1_calls[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[3]+' / '+quarters2_calls[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(ytd_1_calls).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(ytd_2_calls).setScale(0))+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(total_1_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(total_1_calls).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(total_2_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(total_2_calls).setScale(0))+'</div></td>';
        html += '</tr>';

        return html;
    }

    public static String threeYearAdmit(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0, ytd_3=0, total_3=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};
        List<Integer> quarters3 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[(i*3)+j]);
                    total_1 += Integer.valueOf(data[(i*3)+j]);
                } else data[(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[(i*3)+j]!=null && data[(i*3)+j].isNumeric())
                ytd_1+=Integer.valueOf(data[(i*3)+j]);

                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric()){
                    quarters2[i] += Integer.valueOf(data[12+(i*3)+j]);
                    total_2 += Integer.valueOf(data[12+(i*3)+j]);
                } else data[12+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric())
                ytd_2+=Integer.valueOf(data[12+(i*3)+j]);

                if(data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric()){
                    quarters3[i] += Integer.valueOf(data[24+(i*3)+j]);
                    total_3 += Integer.valueOf(data[24+(i*3)+j]);
                } else data[24+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric())
                ytd_3+=Integer.valueOf(data[24+(i*3)+j]);
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[0]+'</div><div class="slds-truncate">'+data[12]+'</div><div class="slds-truncate">'+data[24]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[1]+'</div><div class="slds-truncate">'+data[13]+'</div><div class="slds-truncate">'+data[25]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[2]+'</div><div class="slds-truncate">'+data[14]+'</div><div class="slds-truncate">'+data[26]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[0]+getPercent(quarters2[0], quarters3[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[3]+'</div><div class="slds-truncate">'+data[15]+'</div><div class="slds-truncate">'+data[27]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[4]+'</div><div class="slds-truncate">'+data[16]+'</div><div class="slds-truncate">'+data[28]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[5]+'</div><div class="slds-truncate">'+data[17]+'</div><div class="slds-truncate">'+data[29]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[1]+getPercent(quarters2[1], quarters3[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[6]+'</div><div class="slds-truncate">'+data[18]+'</div><div class="slds-truncate">'+data[30]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[7]+'</div><div class="slds-truncate">'+data[19]+'</div><div class="slds-truncate">'+data[31]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[8]+'</div><div class="slds-truncate">'+data[20]+'</div><div class="slds-truncate">'+data[32]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[2]+getPercent(quarters2[2], quarters3[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[9]+'</div><div class="slds-truncate">'+data[21]+'</div><div class="slds-truncate">'+data[33]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[10]+'</div><div class="slds-truncate">'+data[22]+'</div><div class="slds-truncate">'+data[34]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[11]+'</div><div class="slds-truncate">'+data[23]+'</div><div class="slds-truncate">'+data[35]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[3]+getPercent(quarters2[3], quarters3[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_3).setScale(0))+getPercent(ytd_2, ytd_3)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_3).setScale(0))+getPercent(total_2, total_3)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String threeYearQualifiedAdmit(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0, ytd_3=0, total_3=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};
        List<Integer> quarters3 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[72+(i*3)+j]!=null && data[72+(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[72+(i*3)+j]);
                    total_1 += Integer.valueOf(data[72+(i*3)+j]);
                } else data[72+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[72+(i*3)+j]!=null && data[72+(i*3)+j].isNumeric())
                ytd_1+=Integer.valueOf(data[72+(i*3)+j]);

                if(data[84+(i*3)+j]!=null && data[84+(i*3)+j].isNumeric()){
                    quarters2[i] += Integer.valueOf(data[84+(i*3)+j]);
                    total_2 += Integer.valueOf(data[84+(i*3)+j]);
                } else data[84+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[84+(i*3)+j]!=null && data[84+(i*3)+j].isNumeric())
                ytd_2+=Integer.valueOf(data[84+(i*3)+j]);

                if(data[96+(i*3)+j]!=null && data[96+(i*3)+j].isNumeric()){
                    quarters3[i] += Integer.valueOf(data[96+(i*3)+j]);
                    total_3 += Integer.valueOf(data[96+(i*3)+j]);
                } else data[96+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[96+(i*3)+j]!=null && data[96+(i*3)+j].isNumeric())
                ytd_3+=Integer.valueOf(data[96+(i*3)+j]);
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[72]+'</div><div class="slds-truncate">'+data[84]+'</div><div class="slds-truncate">'+data[96]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[73]+'</div><div class="slds-truncate">'+data[85]+'</div><div class="slds-truncate">'+data[97]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[74]+'</div><div class="slds-truncate">'+data[86]+'</div><div class="slds-truncate">'+data[98]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[0]+getPercent(quarters2[0], quarters3[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[75]+'</div><div class="slds-truncate">'+data[87]+'</div><div class="slds-truncate">'+data[99]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[76]+'</div><div class="slds-truncate">'+data[88]+'</div><div class="slds-truncate">'+data[100]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[77]+'</div><div class="slds-truncate">'+data[89]+'</div><div class="slds-truncate">'+data[101]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[1]+getPercent(quarters2[1], quarters3[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[78]+'</div><div class="slds-truncate">'+data[90]+'</div><div class="slds-truncate">'+data[102]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[79]+'</div><div class="slds-truncate">'+data[91]+'</div><div class="slds-truncate">'+data[103]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[80]+'</div><div class="slds-truncate">'+data[92]+'</div><div class="slds-truncate">'+data[104]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[2]+getPercent(quarters2[2], quarters3[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[81]+'</div><div class="slds-truncate">'+data[93]+'</div><div class="slds-truncate">'+data[105]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[82]+'</div><div class="slds-truncate">'+data[94]+'</div><div class="slds-truncate">'+data[106]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[83]+'</div><div class="slds-truncate">'+data[95]+'</div><div class="slds-truncate">'+data[107]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[3]+getPercent(quarters2[3], quarters3[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_3).setScale(0))+getPercent(ytd_2, ytd_3)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_3).setScale(0))+getPercent(total_2, total_3)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String threeYearReferral(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0, ytd_3=0, total_3=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};
        List<Integer> quarters3 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[36+(i*3)+j]!=null && data[36+(i*3)+j].isNumeric()){
                    quarters1[i] += Integer.valueOf(data[36+(i*3)+j]);
                    total_1 += Integer.valueOf(data[36+(i*3)+j]);
                } else data[36+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[36+(i*3)+j]!=null && data[36+(i*3)+j].isNumeric())
                ytd_1+=Integer.valueOf(data[36+(i*3)+j]);

                if(data[48+(i*3)+j]!=null && data[48+(i*3)+j].isNumeric()){
                    quarters2[i] += Integer.valueOf(data[48+(i*3)+j]);
                    total_2 += Integer.valueOf(data[48+(i*3)+j]);
                } else data[48+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[48+(i*3)+j]!=null && data[48+(i*3)+j].isNumeric())
                ytd_2+=Integer.valueOf(data[48+(i*3)+j]);

                if(data[60+(i*3)+j]!=null && data[60+(i*3)+j].isNumeric()){
                    quarters3[i] += Integer.valueOf(data[60+(i*3)+j]);
                    total_3 += Integer.valueOf(data[60+(i*3)+j]);
                } else data[60+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if( ((i*3)+j) < System.today().month() && data[60+(i*3)+j]!=null && data[60+(i*3)+j].isNumeric())
                ytd_3+=Integer.valueOf(data[60+(i*3)+j]);
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[36]+'</div><div class="slds-truncate">'+data[48]+'</div><div class="slds-truncate">'+data[60]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[37]+'</div><div class="slds-truncate">'+data[49]+'</div><div class="slds-truncate">'+data[61]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[38]+'</div><div class="slds-truncate">'+data[50]+'</div><div class="slds-truncate">'+data[62]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[0]+getPercent(quarters2[0], quarters3[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[39]+'</div><div class="slds-truncate">'+data[51]+'</div><div class="slds-truncate">'+data[63]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[40]+'</div><div class="slds-truncate">'+data[52]+'</div><div class="slds-truncate">'+data[64]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[41]+'</div><div class="slds-truncate">'+data[53]+'</div><div class="slds-truncate">'+data[65]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[1]+getPercent(quarters2[1], quarters3[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[42]+'</div><div class="slds-truncate">'+data[54]+'</div><div class="slds-truncate">'+data[66]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[43]+'</div><div class="slds-truncate">'+data[55]+'</div><div class="slds-truncate">'+data[67]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[44]+'</div><div class="slds-truncate">'+data[56]+'</div><div class="slds-truncate">'+data[68]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[2]+getPercent(quarters2[2], quarters3[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[45]+'</div><div class="slds-truncate">'+data[57]+'</div><div class="slds-truncate">'+data[69]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[46]+'</div><div class="slds-truncate">'+data[58]+'</div><div class="slds-truncate">'+data[70]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[47]+'</div><div class="slds-truncate">'+data[59]+'</div><div class="slds-truncate">'+data[71]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[3]+getPercent(quarters2[3], quarters3[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_3).setScale(0))+getPercent(ytd_2, ytd_3)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_3).setScale(0))+getPercent(total_2, total_3)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String threeYearConversion(List<String> data, String key, List<String> years){

        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        List<String> months1 = new List<String>{'','','','','','','','','','','',''};
        List<String> months2 = new List<String>{'','','','','','','','','','','',''};
        List<String> months3 = new List<String>{'','','','','','','','','','','',''};

        for(Integer i=0;i<months1.size();i++){
            months1[i] = getConversion(data[i], data[i+36]);
            months2[i] = getConversion(data[i+12], data[i+48]);
            months3[i] = getConversion(data[i+24], data[i+60]);
        }

        List<String> quarters1 = new List<String>{'','','',''};
        List<String> quarters2 = new List<String>{'','','',''};
        List<String> quarters3 = new List<String>{'','','',''};


        Integer ytdAdmits_1=0, totalAdmits_1=0, ytdReferrals_1=0, totalReferrals_1=0,
        ytdAdmits_2=0, totalAdmits_2=0, ytdReferrals_2=0, totalReferrals_2=0,
        ytdAdmits_3=0, totalAdmits_3=0, ytdReferrals_3=0, totalReferrals_3=0;

        for(Integer i=0;i<4;i++){
            Integer admit_1=0, referral_1=0, admit_2=0, referral_2=0, admit_3=0, referral_3=0;
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric()){
                    admit_1 += Integer.valueOf(data[(i*3)+j]);
                    totalAdmits_1 += Integer.valueOf(data[(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdAdmits_1+=Integer.valueOf(data[(i*3)+j]);
                }
                if(data[36+(i*3)+j]!=null && data[36+(i*3)+j].isNumeric()){
                    referral_1 += Integer.valueOf(data[36+(i*3)+j]);
                    totalReferrals_1 += Integer.valueOf(data[36+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdReferrals_1+=Integer.valueOf(data[36+(i*3)+j]);
                }

                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric()){
                    admit_2 += Integer.valueOf(data[12+(i*3)+j]);
                    totalAdmits_2 += Integer.valueOf(data[12+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdAdmits_2+=Integer.valueOf(data[12+(i*3)+j]);
                }
                if(data[48+(i*3)+j]!=null && data[48+(i*3)+j].isNumeric()){
                    referral_2 += Integer.valueOf(data[48+(i*3)+j]);
                    totalReferrals_2 += Integer.valueOf(data[48+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdReferrals_2+=Integer.valueOf(data[48+(i*3)+j]);
                }

                if(data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric()){
                    admit_3 += Integer.valueOf(data[24+(i*3)+j]);
                    totalAdmits_3 += Integer.valueOf(data[24+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdAdmits_3+=Integer.valueOf(data[24+(i*3)+j]);
                }
                if(data[60+(i*3)+j]!=null && data[60+(i*3)+j].isNumeric()){
                    referral_3 += Integer.valueOf(data[60+(i*3)+j]);
                    totalReferrals_3 += Integer.valueOf(data[60+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytdReferrals_3+=Integer.valueOf(data[60+(i*3)+j]);
                }

            }
            quarters1[i] = getConversion(String.valueOf(admit_1), String.valueOf(referral_1));
            quarters2[i] = getConversion(String.valueOf(admit_2), String.valueOf(referral_2));
            quarters3[i] = getConversion(String.valueOf(admit_3), String.valueOf(referral_3));
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[0]+'</div><div class="slds-truncate">'+months2[0]+'</div><div class="slds-truncate">'+months3[0]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[1]+'</div><div class="slds-truncate">'+months2[1]+'</div><div class="slds-truncate">'+months3[1]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[2]+'</div><div class="slds-truncate">'+months2[2]+'</div><div class="slds-truncate">'+months3[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[3]+'</div><div class="slds-truncate">'+months2[3]+'</div><div class="slds-truncate">'+months3[3]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[4]+'</div><div class="slds-truncate">'+months2[4]+'</div><div class="slds-truncate">'+months3[4]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[5]+'</div><div class="slds-truncate">'+months2[5]+'</div><div class="slds-truncate">'+months3[5]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[6]+'</div><div class="slds-truncate">'+months2[6]+'</div><div class="slds-truncate">'+months3[6]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[7]+'</div><div class="slds-truncate">'+months2[7]+'</div><div class="slds-truncate">'+months3[7]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[8]+'</div><div class="slds-truncate">'+months2[8]+'</div><div class="slds-truncate">'+months3[8]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+months1[9]+'</div><div class="slds-truncate">'+months2[9]+'</div><div class="slds-truncate">'+months3[9]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[10]+'</div><div class="slds-truncate">'+months2[10]+'</div><div class="slds-truncate">'+months3[10]+'</div></td>';
        html += '<td><div class="slds-truncate">'+months1[11]+'</div><div class="slds-truncate">'+months2[11]+'</div><div class="slds-truncate">'+months3[11]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+getConversion(String.valueOf(ytdAdmits_1), String.valueOf(ytdReferrals_1))+'</div><div>'+getConversion(String.valueOf(ytdAdmits_2), String.valueOf(ytdReferrals_2))+'</div><div>'+getConversion(String.valueOf(ytdAdmits_3), String.valueOf(ytdReferrals_3))+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+getConversion(String.valueOf(totalAdmits_1), String.valueOf(totalReferrals_1))+'</div><div>'+getConversion(String.valueOf(totalAdmits_2), String.valueOf(totalReferrals_2))+'</div><div>'+getConversion(String.valueOf(totalAdmits_3), String.valueOf(totalReferrals_3))+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String threeYearCalls(String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        List<String> data = new List<String>{'<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>', '<div class="lnr lnr-cross"></div>',
        '<div class="lnr lnr-cross"></div>'};

        if(salesCalls.containsKey(key.left(18)))
        data = salesCalls.remove(key.left(18));

        Integer ytd_1=0, total_1=0, ytd_2=0, total_2=0, ytd_3=0, total_3=0;
        List<Integer> quarters1 = new List<Integer>{0,0,0,0};
        List<Integer> quarters2 = new List<Integer>{0,0,0,0};
        List<Integer> quarters3 = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[(i*3)+j]!=null && data[(i*3)+j].isNumeric() && Integer.valueOf(data[(i*3)+j])!=0){
                    quarters1[i] += Integer.valueOf(data[(i*3)+j]);
                    total_1 += Integer.valueOf(data[(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_1+=Integer.valueOf(data[(i*3)+j]);
                } else data[(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if(data[12+(i*3)+j]!=null && data[12+(i*3)+j].isNumeric() && Integer.valueOf(data[12+(i*3)+j])!=0){
                    quarters2[i] += Integer.valueOf(data[12+(i*3)+j]);
                    total_2 += Integer.valueOf(data[12+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_2+=Integer.valueOf(data[12+(i*3)+j]);
                } else data[12+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
                if(data[24+(i*3)+j]!=null && data[24+(i*3)+j].isNumeric() && Integer.valueOf(data[24+(i*3)+j])!=0){
                    quarters3[i] += Integer.valueOf(data[24+(i*3)+j]);
                    total_3 += Integer.valueOf(data[24+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_3+=Integer.valueOf(data[24+(i*3)+j]);
                } else data[24+(i*3)+j] = '<div class="lnr lnr-cross"></div>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[0]+'</div><div class="slds-truncate">'+data[12]+'</div><div class="slds-truncate">'+data[24]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[1]+'</div><div class="slds-truncate">'+data[13]+'</div><div class="slds-truncate">'+data[25]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[2]+'</div><div class="slds-truncate">'+data[14]+'</div><div class="slds-truncate">'+data[26]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[0]+getPercent(quarters1[0], quarters2[0])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[0]+getPercent(quarters2[0], quarters3[0])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[3]+'</div><div class="slds-truncate">'+data[15]+'</div><div class="slds-truncate">'+data[27]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[4]+'</div><div class="slds-truncate">'+data[16]+'</div><div class="slds-truncate">'+data[28]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[5]+'</div><div class="slds-truncate">'+data[17]+'</div><div class="slds-truncate">'+data[29]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[1]+getPercent(quarters1[1], quarters2[1])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[1]+getPercent(quarters2[1], quarters3[1])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[6]+'</div><div class="slds-truncate">'+data[18]+'</div><div class="slds-truncate">'+data[30]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[7]+'</div><div class="slds-truncate">'+data[19]+'</div><div class="slds-truncate">'+data[31]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[8]+'</div><div class="slds-truncate">'+data[20]+'</div><div class="slds-truncate">'+data[32]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[2]+getPercent(quarters1[2], quarters2[2])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[2]+getPercent(quarters2[2], quarters3[2])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[9]+'</div><div class="slds-truncate">'+data[21]+'</div><div class="slds-truncate">'+data[33]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[10]+'</div><div class="slds-truncate">'+data[22]+'</div><div class="slds-truncate">'+data[34]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[11]+'</div><div class="slds-truncate">'+data[23]+'</div><div class="slds-truncate">'+data[35]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2[3]+getPercent(quarters1[3], quarters2[3])+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3[3]+getPercent(quarters2[3], quarters3[3])+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2).setScale(0))+getPercent(ytd_1, ytd_2)+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_3).setScale(0))+getPercent(ytd_2, ytd_3)+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_1).setScale(0))+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_2).setScale(0))+getPercent(total_1, total_2)+'</div><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;">'+String.valueOf(Decimal.valueOf(total_3).setScale(0))+getPercent(total_2, total_3)+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    public static String threeYearAdmitCalls(List<String> data, String key, List<String> years){
        String html = '';
        String accountName = '';

        if(swots.contains(key.left(18))) accountName = '<span class="lnr lnr-license"></span> '+key.mid(18, key.length()-1);
        else accountName = key.mid(18, key.length()-1);

        Integer ytd_1_admits=0, total_1_admits=0, ytd_2_admits=0, total_2_admits=0, ytd_3_admits=0, total_3_admits=0;
        List<Integer> quarters1_admits = new List<Integer>{0,0,0,0};
        List<Integer> quarters2_admits = new List<Integer>{0,0,0,0};
        List<Integer> quarters3_admits = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(data[72+(i*3)+j]!=null && data[72+(i*3)+j].isNumeric()){
                    quarters1_admits[i] += Integer.valueOf(data[72+(i*3)+j]);
                    total_1_admits += Integer.valueOf(data[72+(i*3)+j]);
                } else data[72+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
                if( ((i*3)+j) < System.today().month() && data[72+(i*3)+j]!=null && data[72+(i*3)+j].isNumeric())
                ytd_1_admits+=Integer.valueOf(data[72+(i*3)+j]);

                if(data[84+(i*3)+j]!=null && data[84+(i*3)+j].isNumeric()){
                    quarters2_admits[i] += Integer.valueOf(data[84+(i*3)+j]);
                    total_2_admits += Integer.valueOf(data[84+(i*3)+j]);
                } else data[84+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
                if( ((i*3)+j) < System.today().month() && data[84+(i*3)+j]!=null && data[84+(i*3)+j].isNumeric())
                ytd_2_admits+=Integer.valueOf(data[84+(i*3)+j]);

                if(data[96+(i*3)+j]!=null && data[96+(i*3)+j].isNumeric()){
                    quarters3_admits[i] += Integer.valueOf(data[96+(i*3)+j]);
                    total_3_admits += Integer.valueOf(data[96+(i*3)+j]);
                } else data[96+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
                if( ((i*3)+j) < System.today().month() && data[96+(i*3)+j]!=null && data[96+(i*3)+j].isNumeric())
                ytd_3_admits+=Integer.valueOf(data[96+(i*3)+j]);
            }
        }

        List<String> callData = new List<String>{'<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
        '<span class="lnr lnr-cross"></span>'};

        if(salesCalls.containsKey(key.left(18)))
        callData = salesCalls.remove(key.left(18));

        Integer ytd_1_calls=0, total_1_calls=0, ytd_2_calls=0, total_2_calls=0, ytd_3_calls=0, total_3_calls=0;
        List<Integer> quarters1_calls = new List<Integer>{0,0,0,0};
        List<Integer> quarters2_calls = new List<Integer>{0,0,0,0};
        List<Integer> quarters3_calls = new List<Integer>{0,0,0,0};

        for(Integer i=0;i<4;i++){
            for(Integer j=0;j<3;j++){
                if(callData[(i*3)+j]!=null && callData[(i*3)+j].isNumeric() && Integer.valueOf(callData[(i*3)+j])!=0){
                    quarters1_calls[i] += Integer.valueOf(callData[(i*3)+j]);
                    total_1_calls += Integer.valueOf(callData[(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_1_calls+=Integer.valueOf(callData[(i*3)+j]);
                } else callData[(i*3)+j] = '<span class="lnr lnr-cross"></span>';
                if(callData[12+(i*3)+j]!=null && callData[12+(i*3)+j].isNumeric() && Integer.valueOf(callData[12+(i*3)+j])!=0){
                    quarters2_calls[i] += Integer.valueOf(callData[12+(i*3)+j]);
                    total_2_calls += Integer.valueOf(callData[12+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_2_calls+=Integer.valueOf(callData[12+(i*3)+j]);
                } else callData[12+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
                if(callData[24+(i*3)+j]!=null && callData[24+(i*3)+j].isNumeric() && Integer.valueOf(callData[24+(i*3)+j])!=0){
                    quarters3_calls[i] += Integer.valueOf(callData[24+(i*3)+j]);
                    total_3_calls += Integer.valueOf(callData[24+(i*3)+j]);
                    if(((i*3)+j) < System.today().month()) ytd_3_calls+=Integer.valueOf(callData[24+(i*3)+j]);
                } else callData[24+(i*3)+j] = '<span class="lnr lnr-cross"></span>';
            }
        }

        if(ratings.containsKey(key.left(18))) html += '<tr data-five="true"><td style="color:white;background-color:'+ratings.get(key.left(18))+'"><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a style="color:white;" onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        else html += '<tr data-five="false"><td><div style="position:absolute;right:5px;top:8px;"><div>'+years[0]+'</div><div>'+years[1]+'</div><div>'+years[2]+'</div></div><div class="slds-truncate"><a onclick="openRating(\''+key.left(18)+'\', \''+key.mid(18, key.length()-1)+'\')">'+accountName+'</a></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[72]+' / '+callData[0]+'</div><div class="slds-truncate">'+data[84]+' / '+callData[12]+'</div><div class="slds-truncate">'+data[96]+' / '+callData[24]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[73]+' / '+callData[1]+'</div><div class="slds-truncate">'+data[85]+' / '+callData[13]+'</div><div class="slds-truncate">'+data[97]+' / '+callData[25]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[74]+' / '+callData[2]+'</div><div class="slds-truncate">'+data[86]+' / '+callData[14]+'</div><div class="slds-truncate">'+data[98]+' / '+callData[26]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[0]+' / '+quarters1_calls[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[0]+' / '+quarters2_calls[0]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3_admits[0]+' / '+quarters3_calls[0]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[75]+' / '+callData[3]+'</div><div class="slds-truncate">'+data[87]+' / '+callData[15]+'</div><div class="slds-truncate">'+data[99]+' / '+callData[27]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[76]+' / '+callData[4]+'</div><div class="slds-truncate">'+data[88]+' / '+callData[16]+'</div><div class="slds-truncate">'+data[100]+' / '+callData[28]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[77]+' / '+callData[5]+'</div><div class="slds-truncate">'+data[89]+' / '+callData[17]+'</div><div class="slds-truncate">'+data[101]+' / '+callData[29]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[1]+' / '+quarters1_calls[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[1]+' / '+quarters2_calls[1]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3_admits[1]+' / '+quarters3_calls[1]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[78]+' / '+callData[6]+'</div><div class="slds-truncate">'+data[90]+' / '+callData[18]+'</div><div class="slds-truncate">'+data[102]+' / '+callData[30]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[79]+' / '+callData[7]+'</div><div class="slds-truncate">'+data[91]+' / '+callData[19]+'</div><div class="slds-truncate">'+data[103]+' / '+callData[31]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[80]+' / '+callData[8]+'</div><div class="slds-truncate">'+data[92]+' / '+callData[20]+'</div><div class="slds-truncate">'+data[104]+' / '+callData[32]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[2]+' / '+quarters1_calls[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[2]+' / '+quarters2_calls[2]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3_admits[2]+' / '+quarters3_calls[2]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate">'+data[81]+' / '+callData[9]+'</div><div class="slds-truncate">'+data[93]+' / '+callData[21]+'</div><div class="slds-truncate">'+data[105]+' / '+callData[33]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[82]+' / '+callData[10]+'</div><div class="slds-truncate">'+data[94]+' / '+callData[22]+'</div><div class="slds-truncate">'+data[106]+' / '+callData[34]+'</div></td>';
        html += '<td><div class="slds-truncate">'+data[83]+' / '+callData[11]+'</div><div class="slds-truncate">'+data[95]+' / '+callData[23]+'</div><div class="slds-truncate">'+data[107]+' / '+callData[35]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;">'+quarters1_admits[3]+' / '+quarters1_calls[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters2_admits[3]+' / '+quarters2_calls[3]+'</div><div class="slds-truncate" style="font-weight:bold;">'+quarters3_admits[3]+' / '+quarters3_calls[3]+'</div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(ytd_1_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(ytd_1_calls).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(ytd_2_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(ytd_2_calls).setScale(0))+'</div><div>'+
        String.valueOf(Decimal.valueOf(ytd_3_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(ytd_3_calls).setScale(0))+'</div></div></td>';
        html += '<td class="borderleft"><div class="slds-truncate" style="font-weight:bold;color:#64a3e5;"><div>'+String.valueOf(Decimal.valueOf(total_1_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(total_1_calls).setScale(0))+'</div><div>'+String.valueOf(Decimal.valueOf(total_2_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(total_2_calls).setScale(0))+'</div><div>'+
        String.valueOf(Decimal.valueOf(total_3_admits).setScale(0))+' / '+String.valueOf(Decimal.valueOf(total_3_calls).setScale(0))+'</div></div></td>';
        html += '</tr>';

        return html;
    }

    @RemoteAction global static String getData(Id usrId, String[] years, String lob, String rac){
        String html = '';
        List<String> temp;
        Map<String, List<String>> accountData = new Map<String, List<String>>();
        Map<String, List<String>> contactData = new Map<String, List<String>>();
        Map<String, List<String>> data = new Map<String, List<String>>();

        for(Business_Plan__c bp : [select Account__c, Contact__c from Business_Plan__c where User__c=:usrId]){
            if(bp.Account__c!=null) swots.add(bp.Account__c);
            else if(bp.Contact__c!=null) swots.add(bp.Contact__c);
        }

        for(Sales_5x5x5_Ratings__c r : [select Account__c, Contact__c, Rating__c from Sales_5x5x5_Ratings__c where User__c=:usrId]){
            String color = '';
            if(r.Rating__c=='Top') color = '#6bba76';
            else if(r.Rating__c=='Flat') color = '#e5a949';
            else if(r.Rating__c=='Bottom') color = '#dd786c';

            if(r.Account__c!=null) ratings.put(r.Account__c, color);
            else if(r.Contact__c!=null) ratings.put(r.Contact__c, color);
        }



        if(years.size()==1){
            Date monthBegin = Date.newInstance(Integer.valueOf(years[0]), 01, 01);
            Date monthEnd = Date.newInstance(Integer.valueOf(years[0]), 12, 31);

            /*
            TEMP DATA STRUCTURE
            0-11 are admits for JAN-FEB
            12-23 are referrals for JAN-FEB
            24-35 are qualified admits for JAN-FEB
            */

            for(Sales_Account_Metrics__c am : [select Account__c, Account__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c from Sales_Account_Metrics__c where
            (Month__c>=:monthBegin and Month__c<=:monthEnd) and Account__c in
            (select AccountId from AccountTeamMember where UserId = :usrId and (Account.Unity_Id__c!=null or Account.Horizon_Id__c!=null))]){
                temp = new String[36];
                if(accountData.containsKey(am.Account__c+String.valueOf(am.Account__r.Name)))
                temp = accountData.remove(am.Account__c+String.valueOf(am.Account__r.Name));
                if(lob=='HH'){
                    if(am.KAH_HH_Admits__c!=null) temp.set(am.Month__c.month()-1, String.valueOf(am.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1, String.valueOf(0));

                    if(am.KAH_HH_Referrals__c!=null) temp.set(am.Month__c.month()+11, String.valueOf(am.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+11, String.valueOf(0));

                    if(am.KAH_HH_PPS_Admits__c!=null) temp.set(am.Month__c.month()+23, String.valueOf(am.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23, String.valueOf(0));
                } else if(lob=='HP'){
                    if(am.KAH_HP_Admits__c!=null) temp.set(am.Month__c.month()-1, String.valueOf(am.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1, String.valueOf(0));

                    if(am.KAH_HP_Referrals__c!=null) temp.set(am.Month__c.month()+11, String.valueOf(am.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+11, String.valueOf(0));

                    if(am.KAH_HP_Qualified_Admits__c!=null) temp.set(am.Month__c.month()+23, String.valueOf(am.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23, String.valueOf(0));
                }
                accountData.put(am.Account__c+String.valueOf(am.Account__r.Name), temp);
            }

            for(Sales_Contact_Metrics__c cm : [select Contact__c, Contact__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c from Sales_Contact_Metrics__c where
            (Month__c>=:monthBegin and Month__c<=:monthEnd) and Contact__c in
            (select Contact__c from Contact_Team__c where User__c = :usrId and (Contact__r.Unity_Id__c!=null or Contact__r.Horizon_Id__c!=null))]){
                temp = new String[36];
                if(contactData.containsKey(cm.Contact__c+String.valueOf(cm.Contact__r.Name)))
                temp = contactData.remove(cm.Contact__c+String.valueOf(cm.Contact__r.Name));
                if(lob=='HH'){
                    if(cm.KAH_HH_Admits__c!=null) temp.set(cm.Month__c.month()-1, String.valueOf(cm.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1, String.valueOf(0));

                    if(cm.KAH_HH_Referrals__c!=null) temp.set(cm.Month__c.month()+11, String.valueOf(cm.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+11, String.valueOf(0));

                    if(cm.KAH_HH_PPS_Admits__c!=null) temp.set(cm.Month__c.month()+23, String.valueOf(cm.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23, String.valueOf(0));
                } else if(lob=='HP'){
                    if(cm.KAH_HP_Admits__c!=null) temp.set(cm.Month__c.month()-1, String.valueOf(cm.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1, String.valueOf(0));

                    if(cm.KAH_HP_Referrals__c!=null) temp.set(cm.Month__c.month()+11, String.valueOf(cm.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+11, String.valueOf(0));

                    if(cm.KAH_HP_Qualified_Admits__c!=null) temp.set(cm.Month__c.month()+23, String.valueOf(cm.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23, String.valueOf(0));
                }
                contactData.put(cm.Contact__c+String.valueOf(cm.Contact__r.Name), temp);
            }

            data.putAll(accountData);
            data.putAll(contactData);

            for(AggregateResult ar : [select whoId, whatId, count(id)num, calendar_month(month__c)month, calendar_year(month__c)year from event
            where ownerId=:usrId and (whoId!=null or whatId!=null) and complete__c=true and (ActivityDate>=:monthBegin and ActivityDate<=:monthEnd)
            group by whoId, whatId, calendar_month(month__c), calendar_year(month__c)]){
                if(ar.get('whatId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whatId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whatId')));
                    temp[Integer.valueOf(ar.get('month'))-1] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whatId')), temp);
                }
                if(ar.get('whoId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whoId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whoId')));
                    temp[Integer.valueOf(ar.get('month'))-1] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whoId')), temp);
                }
            }

            for(String key : data.keySet()){
                if(rac=='Admit') html += oneYearAdmit(data.remove(key), key, years);
                if(rac=='Qualified Admit') html += oneYearQualifiedAdmit(data.remove(key), key, years);
                else if (rac=='Referral') html += oneYearReferral(data.remove(key), key, years);
                else if(rac=='Conversion %') html += oneYearConversion(data.remove(key), key, years);
                else if(rac=='Sales Calls') html += oneYearCalls(key, years);
                else if (rac=='Admits / Calls') html += oneYearAdmitCalls(data.remove(key), key, years);
            }

        } else if(years.size()==2){

            /*
            TEMP DATA STRUCTURE
            0-11 are admits for JAN-FEB for year[0]
            12-23 are admits for JAN-FEB for year[1]
            24-35 are referrals for JAN-FEB for year[0]
            36-47 are referrals for JAN-FEB for year[1]
            48-59 are qualified admits for JAN-FEB for year[0]
            60-71 are qualified admits for JAN-FEB for year[1]
            */

            years.sort();
            Date monthBegin1 = Date.newInstance(Integer.valueOf(years[0]), 01, 01);
            Date monthEnd1 = Date.newInstance(Integer.valueOf(years[0]), 12, 31);
            Date monthBegin2 = Date.newInstance(Integer.valueOf(years[1]), 01, 01);
            Date monthEnd2 = Date.newInstance(Integer.valueOf(years[1]), 12, 31);

            for(Sales_Account_Metrics__c am : [select Account__c, Account__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c
            from Sales_Account_Metrics__c where ((Month__c>=:monthBegin1 and Month__c<=:monthEnd1) or (Month__c>=:monthBegin2 and Month__c<=:monthEnd2))
            and Account__c in (select AccountId from AccountTeamMember where UserId = :usrId and (Account.Unity_Id__c!=null or Account.Horizon_Id__c!=null))]){
                temp = new String[72];
                Integer addYear=0;
                if(am.Month__c.year()==Double.valueOf(years[1])) addYear=12;
                if(accountData.containsKey(am.Account__c+String.valueOf(am.Account__r.Name)))
                temp = accountData.remove(am.Account__c+String.valueOf(am.Account__r.Name));
                if(lob=='HH'){
                    if(am.KAH_HH_Admits__c!=null) temp.set(am.Month__c.month()-1+addYear, String.valueOf(am.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1+addYear, String.valueOf(0));

                    if(am.KAH_HH_Referrals__c!=null) temp.set(am.Month__c.month()+23+addYear, String.valueOf(am.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23+addYear, String.valueOf(0));

                    if(am.KAH_HH_PPS_Admits__c!=null) temp.set(am.Month__c.month()+47+addYear, String.valueOf(am.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+47+addYear, String.valueOf(0));
                } else if(lob=='HP'){
                    if(am.KAH_HP_Admits__c!=null) temp.set(am.Month__c.month()-1+addYear, String.valueOf(am.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1+addYear, String.valueOf(0));

                    if(am.KAH_HP_Referrals__c!=null) temp.set(am.Month__c.month()+23+addYear, String.valueOf(am.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+23+addYear, String.valueOf(0));

                    if(am.KAH_HP_Qualified_Admits__c!=null) temp.set(am.Month__c.month()+47+addYear, String.valueOf(am.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+47+addYear, String.valueOf(0));
                }
                accountData.put(am.Account__c+String.valueOf(am.Account__r.Name), temp);
            }

            for(Sales_Contact_Metrics__c cm : [select Contact__c, Contact__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c
            from Sales_Contact_Metrics__c where ((Month__c>=:monthBegin1 and Month__c<=:monthEnd1) or (Month__c>=:monthBegin2 and Month__c<=:monthEnd2))
            and Contact__c in (select Contact__c from Contact_Team__c where User__c = :usrId and (Contact__r.Unity_Id__c!=null or Contact__r.Horizon_Id__c!=null))]){
                temp = new String[72];
                Integer addYear=0;
                if(cm.Month__c.year()==Double.valueOf(years[1])) addYear=12;
                if(contactData.containsKey(cm.Contact__c+String.valueOf(cm.Contact__r.Name)))
                temp = contactData.remove(cm.Contact__c+String.valueOf(cm.Contact__r.Name));
                if(lob=='HH'){
                    if(cm.KAH_HH_Admits__c!=null) temp.set(cm.Month__c.month()-1+addYear, String.valueOf(cm.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1+addYear, String.valueOf(0));

                    if(cm.KAH_HH_Referrals__c!=null) temp.set(cm.Month__c.month()+23+addYear, String.valueOf(cm.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23+addYear, String.valueOf(0));

                    if(cm.KAH_HH_PPS_Admits__c!=null) temp.set(cm.Month__c.month()+47+addYear, String.valueOf(cm.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+47+addYear, String.valueOf(0));

                } else if(lob=='HP'){
                    if(cm.KAH_HP_Admits__c!=null) temp.set(cm.Month__c.month()-1+addYear, String.valueOf(cm.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1+addYear, String.valueOf(0));

                    if(cm.KAH_HP_Referrals__c!=null) temp.set(cm.Month__c.month()+23+addYear, String.valueOf(cm.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+23+addYear, String.valueOf(0));

                    if(cm.KAH_HP_Qualified_Admits__c!=null) temp.set(cm.Month__c.month()+47+addYear, String.valueOf(cm.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+47+addYear, String.valueOf(0));
                }
                contactData.put(cm.Contact__c+String.valueOf(cm.Contact__r.Name), temp);
            }

            data.putAll(accountData);
            data.putAll(contactData);

            for(AggregateResult ar : [select whoId, whatId, count(id)num, calendar_month(month__c)month, calendar_year(month__c)year from event
            where ownerId=:usrId and (whoId!=null or whatId!=null) and complete__c=true and ((ActivityDate>=:monthBegin1 and ActivityDate<=:monthEnd1) or
            (ActivityDate>=:monthBegin2 and ActivityDate<=:monthEnd2)) group by whoId, whatId, calendar_month(month__c), calendar_year(month__c)]){
                Integer addYear=0;
                if(Integer.valueOf(ar.get('year'))==Double.valueOf(years[1])) addYear=12;
                if(ar.get('whatId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whatId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whatId')));
                    temp[Integer.valueOf(ar.get('month'))-1+addYear] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1+addYear])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whatId')), temp);
                }
                if(ar.get('whoId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whoId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whoId')));
                    temp[Integer.valueOf(ar.get('month'))-1+addYear] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1+addYear])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whoId')), temp);
                }
            }

            for(String key : data.keySet()){
                if(rac=='Admit') html += twoYearAdmit(data.remove(key), key, years);
                else if(rac=='Qualified Admit') html += twoYearQualifiedAdmit(data.remove(key), key, years);
                else if (rac=='Referral') html += twoYearReferral(data.remove(key), key, years);
                else if(rac=='Conversion %') html += twoYearConversion(data.remove(key), key, years);
                else if(rac=='Sales Calls') html += twoYearCalls(key, years);
                else if (rac=='Admits / Calls') html += twoYearAdmitCalls(data.remove(key), key, years);
            }

        } else if(years.size()==3){
            years.sort();

            /*
            TEMP DATA STRUCTURE
            0-11 are admits for JAN-FEB for year[0]
            12-23 are admits for JAN-FEB for year[1]
            24-35 are admits for JAN-FEB for year[2]
            36-47 are referrals for JAN-FEB for year[0]
            48-59 are referrals for JAN-FEB for year[1]
            60-71 are referrals for JAN-FEB for year[2]
            72-83 are qualified admits for JAN-FEB for year[0]
            84-95 are qualified admits for JAN-FEB for year[1]
            96-107 are qualified admits for JAN-FEB for year[2]
            */

            Date monthBegin1 = Date.newInstance(Integer.valueOf(years[0]), 01, 01);
            Date monthEnd1 = Date.newInstance(Integer.valueOf(years[0]), 12, 31);
            Date monthBegin2 = Date.newInstance(Integer.valueOf(years[1]), 01, 01);
            Date monthEnd2 = Date.newInstance(Integer.valueOf(years[1]), 12, 31);
            Date monthBegin3 = Date.newInstance(Integer.valueOf(years[2]), 01, 01);
            Date monthEnd3 = Date.newInstance(Integer.valueOf(years[2]), 12, 31);

            for(Sales_Account_Metrics__c am : [select Account__c, Account__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c
            from Sales_Account_Metrics__c where ((Month__c>=:monthBegin1 and Month__c<=:monthEnd1) or (Month__c>=:monthBegin2 and Month__c<=:monthEnd2) or (Month__c>=:monthBegin3 and Month__c<=:monthEnd3))
            and Account__c in (select AccountId from AccountTeamMember where UserId = :usrId and (Account.Unity_Id__c!=null or Account.Horizon_Id__c!=null))]){
                temp = new String[108];

                Integer addYear=0;
                if(am.Month__c.year()==Double.valueOf(years[1])) addYear=12;
                else if(am.Month__c.year()==Double.valueOf(years[2])) addYear=24;

                if(accountData.containsKey(am.Account__c+String.valueOf(am.Account__r.Name)))
                temp = accountData.remove(am.Account__c+String.valueOf(am.Account__r.Name));
                if(lob=='HH'){
                    if(am.KAH_HH_Admits__c!=null) temp.set(am.Month__c.month()-1+addYear, String.valueOf(am.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1+addYear, String.valueOf(0));

                    if(am.KAH_HH_Referrals__c!=null) temp.set(am.Month__c.month()+35+addYear, String.valueOf(am.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+35+addYear, String.valueOf(0));

                    if(am.KAH_HH_PPS_Admits__c!=null) temp.set(am.Month__c.month()+71+addYear, String.valueOf(am.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+71+addYear, String.valueOf(0));
                } else if(lob=='HP'){
                    if(am.KAH_HP_Admits__c!=null) temp.set(am.Month__c.month()-1+addYear, String.valueOf(am.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()-1+addYear, String.valueOf(0));

                    if(am.KAH_HP_Referrals__c!=null) temp.set(am.Month__c.month()+35+addYear, String.valueOf(am.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(am.Month__c.month()+35+addYear, String.valueOf(0));

                    if(am.KAH_HP_Qualified_Admits__c!=null) temp.set(am.Month__c.month()+71+addYear, String.valueOf(am.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(am.Month__c.month()+71+addYear, String.valueOf(0));
                }
                accountData.put(am.Account__c+String.valueOf(am.Account__r.Name), temp);
            }

            for(Sales_Contact_Metrics__c cm : [select Contact__c, Contact__r.Name, KAH_HH_Admits__c, KAH_HH_PPS_Admits__c, KAH_HH_Referrals__c, KAH_HP_Admits__c, KAH_HP_Qualified_Admits__c, KAH_HP_Referrals__c, Month__c
            from Sales_Contact_Metrics__c where ((Month__c>=:monthBegin1 and Month__c<=:monthEnd1) or (Month__c>=:monthBegin2 and Month__c<=:monthEnd2) or (Month__c>=:monthBegin3 and Month__c<=:monthEnd3))
            and Contact__c in (select Contact__c from Contact_Team__c where User__c = :usrId and (Contact__r.Unity_Id__c!=null or Contact__r.Horizon_Id__c!=null))]){
                temp = new String[108];
                Integer addYear=0;
                if(cm.Month__c.year()==Double.valueOf(years[1])) addYear=12;
                if(cm.Month__c.year()==Double.valueOf(years[2])) addYear=24;
                if(contactData.containsKey(cm.Contact__c+String.valueOf(cm.Contact__r.Name)))
                temp = contactData.remove(cm.Contact__c+String.valueOf(cm.Contact__r.Name));
                if(lob=='HH'){
                    if(cm.KAH_HH_Admits__c!=null) temp.set(cm.Month__c.month()-1+addYear, String.valueOf(cm.KAH_HH_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1+addYear, String.valueOf(0));

                    if(cm.KAH_HH_Referrals__c!=null) temp.set(cm.Month__c.month()+35+addYear, String.valueOf(cm.KAH_HH_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+35+addYear, String.valueOf(0));

                    if(cm.KAH_HH_PPS_Admits__c!=null) temp.set(cm.Month__c.month()+71+addYear, String.valueOf(cm.KAH_HH_PPS_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+71+addYear, String.valueOf(0));
                } else if(lob=='HP'){
                    if(cm.KAH_HP_Admits__c!=null) temp.set(cm.Month__c.month()-1+addYear, String.valueOf(cm.KAH_HP_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()-1+addYear, String.valueOf(0));

                    if(cm.KAH_HP_Referrals__c!=null) temp.set(cm.Month__c.month()+35+addYear, String.valueOf(cm.KAH_HP_Referrals__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+35+addYear, String.valueOf(0));

                    if(cm.KAH_HP_Qualified_Admits__c!=null) temp.set(cm.Month__c.month()+71+addYear, String.valueOf(cm.KAH_HP_Qualified_Admits__c.setScale(0)));
                    else temp.set(cm.Month__c.month()+71+addYear, String.valueOf(0));
                }
                contactData.put(cm.Contact__c+String.valueOf(cm.Contact__r.Name), temp);
            }



            data.putAll(accountData);
            data.putAll(contactData);

            for(AggregateResult ar : [select whoId, whatId, count(id)num, calendar_month(month__c)month, calendar_year(month__c)year from event
            where ownerId=:usrId and (whoId!=null or whatId!=null) and complete__c=true and ((ActivityDate>=:monthBegin1 and ActivityDate<=:monthEnd1) or
            (ActivityDate>=:monthBegin2 and ActivityDate<=:monthEnd2) or (ActivityDate>=:monthBegin3 and ActivityDate<=:monthEnd3))
            group by whoId, whatId, calendar_month(month__c), calendar_year(month__c)]){
                Integer addYear=0;
                if(Integer.valueOf(ar.get('year'))==Double.valueOf(years[1])) addYear=12;
                else if(Integer.valueOf(ar.get('year'))==Double.valueOf(years[2])) addYear=24;
                if(ar.get('whatId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whatId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whatId')));
                    temp[Integer.valueOf(ar.get('month'))-1+addYear] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1+addYear])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whatId')), temp);
                }
                if(ar.get('whoId')!=null){
                    temp = new List<String>{'0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0',
                    '0','0','0','0','0','0','0','0','0','0','0','0'};
                    if(salesCalls.containsKey(String.valueOf(ar.get('whoId'))))
                    temp = salesCalls.remove(String.valueOf(ar.get('whoId')));
                    temp[Integer.valueOf(ar.get('month'))-1+addYear] = String.valueOf(Integer.valueOf(temp[Integer.valueOf(ar.get('month'))-1+addYear])+Integer.valueOf(ar.get('num')));
                    salesCalls.put(String.valueOf(ar.get('whoId')), temp);
                }
            }

            for(String key : data.keySet()){
                if(rac=='Admit') html += threeYearAdmit(data.remove(key), key, years);
                else if (rac=='Qualified Admit') html += threeYearQualifiedAdmit(data.remove(key), key, years);
                else if (rac=='Referral') html += threeYearReferral(data.remove(key), key, years);
                else if(rac=='Conversion %') html += threeYearConversion(data.remove(key), key, years);
                else if(rac=='Sales Calls') html += threeYearCalls(key, years);
                else if (rac=='Admits / Calls') html += threeYearAdmitCalls(data.remove(key), key, years);
            }

        }
        return html;
    }

    @RemoteAction global static Boolean rateReferral(String referralId, String userId, String rating){
        Boolean success = false;
        if(rating=='TOP') rating = 'Top';
        else if(rating=='FLAT') rating = 'Flat';
        else if(rating=='BOTTOM') rating = 'Bottom';
        else if(rating=='REMOVE') rating = 'Remove';

        List<Sales_5x5x5_Ratings__c> ratingsList = [select Id from Sales_5x5x5_Ratings__c where User__c=:userId and (Account__c=:referralId or Contact__c=:referralId)];
        if(referralId.left(3)=='001' && rating!='Remove'){
            if(ratingsList.size()==0){
                insert new Sales_5x5x5_Ratings__c(User__c=userId, Account__c=referralId, Rating__c=rating);
            } else if(ratingsList.size()==1){
                Sales_5x5x5_Ratings__c r = ratingsList.remove(0);
                r.Rating__c = rating;
                update r;
            }
            success=true;
        } else if(referralId.left(3)=='003' && rating!='Remove'){
            if(ratingsList.size()==0){
                insert new Sales_5x5x5_Ratings__c(User__c=userId, Contact__c=referralId, Rating__c=rating);
            } else if(ratingsList.size()==1){
                Sales_5x5x5_Ratings__c r = ratingsList.remove(0);
                r.Rating__c = rating;
                update r;
            }
            success=true;
        } else if(rating=='Remove'){
            if(ratingsList.size()==1)
            delete [select Id from Sales_5x5x5_Ratings__c where User__c=:userId and (Account__c=:referralId or Contact__c=:referralId)];
            success=true;
        }
        return success;
    }

    @RemoteAction global static String getSwot(String referralId, String userId){
        List<Business_Plan__c> swots = [select Strength__c, Weakness__c, Opportunity__c, Threat__c, Competitor__c, Plan__c from Business_Plan__c where User__c=:userId and (Account__c=:referralId or Contact__c=:referralId)];
        if(swots.size()==1){
            Business_Plan__c swot = swots.remove(0);
            String strength='', weakness='', opportunity='', threat='', competitor='', plan='';

            if(swot.Strength__c!=null) strength=prepJson(String.valueOf(swot.Strength__c));
            if(swot.Weakness__c!=null) weakness=prepJson(String.valueOf(swot.Weakness__c));
            if(swot.Opportunity__c!=null) opportunity=prepJson(String.valueOf(swot.Opportunity__c));
            if(swot.Threat__c!=null) threat=prepJson(String.valueOf(swot.Threat__c));
            if(swot.Competitor__c!=null) competitor=prepJson(String.valueOf(swot.Competitor__c));
            if(swot.Plan__c!=null) plan=prepJson(String.valueOf(swot.Plan__c));

            return '{"hasSwot":true, "strength":"'+strength+'", "weakness":"'+weakness+'", "opportunity":"'+opportunity+'", "threat":"'+threat+'", "competitor":"'+competitor+'", "plan":"'+plan+'"}';
        } else {
            return '{"hasSwot":false, "strength":null, "weakness":null, "opportunity":null, "threat":null, "competitor":null, "plan":null}';
        }
    }

    private static String prepJson(String json){
        String escaped = json;
        escaped = escaped.replace('\n', '\\n');
        escaped = escaped.replace('"', '\\"');
        return escaped;
    }

    @RemoteAction global static Boolean saveSwot(String referralId, String userId, String strength, String weakness, String opportunity, String threat, String competitor, String plan){
        Boolean success = false;
        List<Business_Plan__c> swots = [select Strength__c, Weakness__c, Opportunity__c, Threat__c, Competitor__c, Plan__c from Business_Plan__c where User__c=:userId and (Account__c=:referralId or Contact__c=:referralId)];
        if(swots.size()==0){
            if(referralId.left(3)=='001'){
                insert new Business_Plan__c(User__c=userId, Account__c=referralId, Strength__c=strength, Weakness__c=weakness, Opportunity__c=opportunity, Threat__c=threat, Competitor__c=competitor, Plan__c=plan);
                success=true;
            } else if(referralId.left(3)=='003'){
                insert new Business_Plan__c(User__c=userId, Contact__c=referralId, Strength__c=strength, Weakness__c=weakness, Opportunity__c=opportunity, Threat__c=threat, Competitor__c=competitor, Plan__c=plan);
                success=true;
            }
        } else if(swots.size()==1){
            Business_Plan__c swot = swots.remove(0);
            swot.Strength__c=strength;
            swot.Weakness__c=weakness;
            swot.Opportunity__c=opportunity;
            swot.Threat__c=threat;
            swot.Competitor__c=competitor;
            swot.Plan__c=plan;
            update swot;
            success=true;
        }
        return success;
    }

    @RemoteAction global static String saveNewBusiness(String referralId, String userId){
        Boolean success = false;
        String str = '';

        List<New_Business__c> nbs = [select Id from New_Business__c where User__c=:userId and (Account__c=:referralId or Contact__c=:referralId)];
        if(nbs.size()==0 && NewBusinessAccess()){
            Date lowDate = Date.newInstance(2018, 01, 01);
            Date highDate = Date.newInstance(2018, 06, 30);

            User u = [select Line_of_Business__c from User where Id=:userId];

            if(u.Line_of_Business__c!=null && String.valueOf(u.Line_of_Business__c).equals('HP')){
                if(referralId.left(3)=='001' && [select id from Sales_Account_Metrics__c where Account__c=:referralId and Month__c >=:lowDate and Month__c <=:highDate and ((KAH_HP_Qualified_Admits__c!=null and KAH_HP_Qualified_Admits__c!=0))].size()==0){
                    insert new New_Business__c(User__c=userId, Account__c=referralId);
                    success=true;
                    str = '<strong>The new business was added successfully. </strong>';
                } else if(referralId.left(3)=='003' && [select id from Sales_Contact_Metrics__c where Contact__c=:referralId and Month__c >=:lowDate and Month__c <=:highDate and ((KAH_HP_Qualified_Admits__c!=null and KAH_HP_Qualified_Admits__c!=0))].size()==0){
                    insert new New_Business__c(User__c=userId, Contact__c=referralId);
                    success=true;
                    str = '<strong>The new business was added successfully. </strong>';
                } else {
                    str = '<strong>Unable to save new business. </strong> The selected business has admits that fall between '+lowDate.format()+' and '+highDate.format()+'.';
                }
            } else{
                if(referralId.left(3)=='001' && [select id from Sales_Account_Metrics__c where Account__c=:referralId and Month__c >=:lowDate and Month__c <=:highDate and ((KAH_HH_PPS_Admits__c!=null and KAH_HH_PPS_Admits__c!=0))].size()==0){
                    insert new New_Business__c(User__c=userId, Account__c=referralId);
                    success=true;
                    str = '<strong>The new business was added successfully. </strong>';
                } else if(referralId.left(3)=='003' && [select id from Sales_Contact_Metrics__c where Contact__c=:referralId and Month__c >=:lowDate and Month__c <=:highDate and ((KAH_HH_PPS_Admits__c!=null and KAH_HH_PPS_Admits__c!=0))].size()==0){
                    insert new New_Business__c(User__c=userId, Contact__c=referralId);
                    success=true;
                    str = '<strong>The new business was added successfully. </strong>';
                } else {
                    str = '<strong>Unable to save new business. </strong> The selected business has admits that fall between '+lowDate.format()+' and '+highDate.format()+'.';
                }
            }

            // if(referralId.left(3)=='001' && [select id from Sales_Account_Metrics__c where Account__c=:referralId and Month__c >=:lowDate and Month__c <=:highDate and ((KAH_HH_PPS_Admits__c!=null and KAH_HH_PPS_Admits__c!=0) or (KAH_HP_Qualified_Admits__c!=null and KAH_HP_Qualified_Admits__c!=0))].size()==0){
            //  insert new New_Business__c(User__c=userId, Account__c=referralId);
            //  success=true;
            //  str = '<strong>The new business was added successfully. </strong>';
            // } else if(referralId.left(3)=='003' && [select id from Sales_Contact_Metrics__c where Contact__c=:referralId and Month__c >=:lowDate and Month__c <=:highDate and ((KAH_HH_PPS_Admits__c!=null and KAH_HH_PPS_Admits__c!=0) or (KAH_HP_Qualified_Admits__c!=null and KAH_HP_Qualified_Admits__c!=0))].size()==0){
            //  insert new New_Business__c(User__c=userId, Contact__c=referralId);
            //  success=true;
            //  str = '<strong>The new business was added successfully. </strong>';
            // } else {
            //  str = '<strong>Unable to save new business. </strong> The selected business has admits that fall between '+lowDate.format()+' and '+highDate.format()+'.';
            // }
        } else if(nbs.size()==1){
            delete nbs[0];
            success=true;
            str = '<strong>The new business was removed successfully. </strong>';
        } else {
            str = '<strong>There was an error is saving the new business. </strong> Multiple records were found for the referral source.';
        }

        return '{"success":'+success+', "string":"'+str+'"}';
    }

    @RemoteAction global static Boolean deleteSwot(String referralId, String userId){
        List<Business_Plan__c> swots = [select Strength__c, Weakness__c, Opportunity__c, Threat__c from Business_Plan__c where User__c=:userId and (Account__c=:referralId or Contact__c=:referralId)];
        if(swots.size()==1){
            delete swots;
        }
        return true;
    }

    @RemoteAction global static Boolean NewBusinessAccess(){
        Set<Id> allowedIds = new Set<ID>();
        List<UserRole> usrRole = [SELECT Id FROM UserRole where name ='SVP - South Atlantic'];
        if(usrRole.size()==1){
            allowedIds.addAll(getSubRoleIds(new List<ID>{usrRole[0].Id}));
            allowedIds.add(usrRole[0].Id);
        }
        for(UserRole uRole : [select Id from UserRole where name='SVP - KAH' or name='KAH Administrative Oversight' or name='KAH Admin' or name='KAH']){
            allowedIds.add(uRole.Id);
        }
        return allowedIds.contains(UserInfo.getUserRoleId());
    }
}