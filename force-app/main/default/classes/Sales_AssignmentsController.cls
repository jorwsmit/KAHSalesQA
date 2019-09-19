global class Sales_AssignmentsController {

    //----------------------Used for Drilldown------------------------------------
    @RemoteAction global static string getUsersByRoleId(String roleId) {
        String returnStr = '';
        if([select Id, Name from User where UserRoleId =: roleId and IsActive=true].size() > 0){
            for (User u : [select Id, Name from User where UserRoleId =: roleId and IsActive=true order by name]){
                returnStr += '<a style="text-align:left; display:block;" onclick="selectUser(\''+u.Id+'\', null)">'+u.name+'</a>';
            }
        }
        return returnStr;
    }
    
    @RemoteAction global static string getChildRoles(String roleId) {
        String returnStr = '';
        if([select Id, Name from UserRole where Id =: roleId].size() > 0){
            for (UserRole ur : [select Id, Name from UserRole where parentRoleId =: roleId order by name]){
                returnStr += '<a style="text-align:left; display:block;" onclick="roleNav.push([roleId, document.getElementById(\'currentRoleText\').innerHTML]); roleId=\''+ur.Id+'\'; selectDrill(); document.getElementById(\'currentRoleText\').innerHTML=\''+ur.Name+' Employees\'">'+ur.name+'</a>';
            }
        }
        return returnStr;
    }
    //----------------------END Used for Drilldown---------------------------------
    
    //----------------------Used For Employee Search-------------------------------
    
    @RemoteAction global static string getUsersUnderRoleId(Id roleId) {
        String returnStr = '';
        List<Id> allSubRoleIds = new List<ID>{roleId};
        allSubRoleIds.addAll(getSubRoleIds(new List<ID>{roleId}));
        if([select Id, Name, UserRoleId, UserRole.Name from User where UserRoleId in :allSubRoleIds and IsActive=true].size() > 0){
            for (User u : [select Id, Name from User where UserRoleId in :allSubRoleIds and IsActive=true order by Name]){
                returnStr += '<li style="text-align:left;"><a onclick="selectUser(\''+u.Id+'\', null)">'+u.name+'</a></li>';
            }
        }
        return returnStr;
    }
    
    private static List<Id> getSubRoleIds(List<Id> roleIds) {
        List<Id> returnRoleIds = new List<Id>();
        for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
            returnRoleIds.add(r.Id);
        }
        if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
        return returnRoleIds;
    }
    
    //----------------------END Used For Employee Search-------------------------------
    
    
    //----------------------Used For User Search-------------------------------
    @RemoteAction global static String getAssignments(String usrId, String dateRng, Id offsetId, Integer countNum) {
        if(dateRng!=null) return getAssignmentsFunction(usrId, dateRng, '', offsetId, countNum);
        else return getAssignmentsFunction(usrId, null, '', offsetId, countNum);
    }
    
    private static String getAssignmentsFunction(String usrId, String dateRng, String status, Id offsetId, Integer countNum) {
        String html = '{';
        if(dateRng==null){
            
            List<Referral_Source_Audit__c> rsas = new List<Referral_Source_Audit__c>();
            if(offsetId == null) rsas.addAll([select effective_date__c, request_date__c, account__c, account__r.name, contact__c, contact__r.name, user__r.name, status__c, unity_id__c, horizon_id__c from Referral_Source_Audit__c where user__c=:usrId and status__c!='Remaining' order by id limit :countNum]);
            else rsas.addAll([select effective_date__c, request_date__c, account__c, account__r.name, contact__c, contact__r.name, user__r.name, status__c, unity_id__c, horizon_id__c from Referral_Source_Audit__c where user__c=:usrId and status__c!='Remaining' and id>:offsetId order by id limit :countNum]);
            
            if(rsas.isEmpty()) html += '"count" : 0, "offsetId" : null, "html" : "';
            else html += '"count" : '+String.valueOf(rsas.size())+', "offsetId" : "'+String.valueOf(rsas.get(rsas.size()-1).Id)+'", "html" : "';
            
            while(!rsas.isEmpty()){
                Referral_Source_Audit__c rsa =rsas.remove(0);
                String unityId = '';
                String horizonId = '';
                String color = '';
                String effectiveDate = String.valueOf(rsa.effective_date__c.month())+'/'+String.valueOf(rsa.effective_date__c.day())+'/'+String.valueOf(rsa.effective_date__c.year());
                String requestDate = String.valueOf(rsa.request_date__c.month())+'/'+String.valueOf(rsa.request_date__c.day())+'/'+String.valueOf(rsa.request_date__c.year());
                
                if(rsa.unity_id__c != null) unityId = String.valueOf(rsa.unity_id__c);
                if(rsa.horizon_id__c != null) horizonId = String.valueOf(rsa.horizon_id__c);
                if(rsa.status__c == 'Added') color = '#4AB471';
                if(rsa.status__c == 'Deleted') color = '#E86166';
                
                html += '<tr><td scope=\'row\' data-label=\'Name\'><div class=\'slds-truncate\' title=\''+effectiveDate+'\'>'+effectiveDate+'</div>'+
                    '<td scope=\'row\' data-label=\'Name\'><div class=\'slds-truncate columnPadding\' title=\''+requestDate+'\'>'+requestDate+'</div></td>'+
                    '<td scope=\'row\' data-label=\'Name\'><div class=\'slds-truncate\' title=\''+rsa.status__c+'\' style=\'color:'+color+'; font-weight:bold;\'>'+rsa.status__c+'</div></td>';
                if(rsa.account__c!=null) html+= '<td data-label=\'Account Name\'><div class=\'columnPadding\' title=\''+String.valueOf(rsa.account__r.name).replace('"', ' ')+'\'>'+String.valueOf(rsa.account__r.name).replace('"', '\'')+'</div></td>';
                else if (rsa.contact__c!=null)  html+= '<td data-label=\'Account Name\'><div class=\'slds-truncate columnPadding\' title=\''+String.valueOf(rsa.contact__r.name).replace('"', ' ')+'\'>'+String.valueOf(rsa.contact__r.name).replace('"', '\'')+'</div></td>';
                html += '<td scope=\'row\' data-label=\'Name\'><div class=\'columnPadding\' title=\''+rsa.user__r.name+'\'>'+rsa.user__r.name+'</div></td>'+
                    '<td scope=\'row\' data-label=\'Name\'><div title=\''+unityId+'\'>'+unityId+'</div></td>'+
                    '<td scope=\'row\' data-label=\'Name\'><div title=\''+horizonId+'\'>'+horizonId+'</div></td></tr>';
            }
        } else {
            
            List<Referral_Source_Audit__c> rsas = new List<Referral_Source_Audit__c>();
            if(offsetId == null) rsas.addAll([select id, effective_date__c, request_date__c, account__c, account__r.name, contact__c, contact__r.name, user__r.name, status__c, unity_id__c, horizon_id__c from Referral_Source_Audit__c where request_date__c>=:getDateFunction(dateRng, true) and request_date__c<=:getDateFunction(dateRng, false) and status__c!='Remaining' and user__c=:usrId order by id limit :countNum]);
            else rsas.addAll([select id, effective_date__c, request_date__c, account__c, account__r.name, contact__c, contact__r.name, user__r.name, status__c, unity_id__c, horizon_id__c from Referral_Source_Audit__c where request_date__c>=:getDateFunction(dateRng, true) and request_date__c<=:getDateFunction(dateRng, false) and status__c!='Remaining' and user__c=:usrId and id>:offsetId order by id limit :countNum]);
            
            if(rsas.isEmpty()) html += '"count" : 0, "offsetId" : null, "html" : "';
            else html += '"count" : '+String.valueOf(rsas.size())+', "offsetId" : "'+String.valueOf(rsas.get(rsas.size()-1).Id)+'", "html" : "';
            
            while(!rsas.isEmpty()){
                Referral_Source_Audit__c rsa =rsas.remove(0);
                String unityId = '';
                String horizonId = '';
                String color = '';
                String effectiveDate = String.valueOf(rsa.effective_date__c.month())+'/'+String.valueOf(rsa.effective_date__c.day())+'/'+String.valueOf(rsa.effective_date__c.year());
                String requestDate = String.valueOf(rsa.request_date__c.month())+'/'+String.valueOf(rsa.request_date__c.day())+'/'+String.valueOf(rsa.request_date__c.year());
                
                if(rsa.unity_id__c != null) unityId = String.valueOf(rsa.unity_id__c);
                if(rsa.horizon_id__c != null) horizonId = String.valueOf(rsa.horizon_id__c);
                if(rsa.status__c == 'Added') color = '#4AB471';
                if(rsa.status__c == 'Deleted') color = '#E86166';
                
                html += '<tr><td scope=\'row\' data-label=\'Name\'><div class=\'slds-truncate\' title=\''+effectiveDate+'\'>'+effectiveDate+'</div>'+
                    '<td scope=\'row\' data-label=\'Name\'><div class=\'slds-truncate columnPadding\' title=\''+requestDate+'\'>'+requestDate+'</div></td>'+
                    '<td scope=\'row\' data-label=\'Name\'><div class=\'slds-truncate\' title=\''+rsa.status__c+'\' style=\'color:'+color+'; font-weight:bold;\'>'+rsa.status__c+'</div></td>';
                if(rsa.account__c!=null) html+= '<td data-label=\'Account Name\'><div class=\'columnPadding\' title=\''+String.valueOf(rsa.account__r.name).replace('"', ' ')+'\'>'+String.valueOf(rsa.account__r.name).replace('"', '\'')+'</div></td>';
                else if (rsa.contact__c!=null)  html+= '<td data-label=\'Account Name\'><div class=\'slds-truncate columnPadding\' title=\''+String.valueOf(rsa.contact__r.name).replace('"', ' ')+'\'>'+String.valueOf(rsa.contact__r.name).replace('"', '\'')+'</div></td>';
                html += '<td scope=\'row\' data-label=\'Name\'><div class=\'columnPadding\' title=\''+rsa.user__r.name+'\'>'+rsa.user__r.name+'</div></td>'+
                    '<td scope=\'row\' data-label=\'Name\'><div title=\''+unityId+'\'>'+unityId+'</div></td>'+
                    '<td scope=\'row\' data-label=\'Name\'><div title=\''+horizonId+'\'>'+horizonId+'</div></td></tr>';
            }
            
        }
        html += '\"}';
        return html;
    }
    
    @RemoteAction global static String getUserName(String usrId) {
        User u = [select name from user where id=:usrId];
        return String.valueOf(u.name);
    }
    
    //----------------------END Used For User Search-------------------------------
    
    @RemoteAction global static String getAdded(String dateRng) {
        String html = '';
        List<Id> allSubRoleIds = new List<ID>{UserInfo.getUserRoleId()};
                 allSubRoleIds.addAll(getSubRoleIds(new List<ID>{UserInfo.getUserRoleId()}));
        Map<Id, String> uNames = new Map<Id, String>();
        for(User u : [select id, name from user where userRoleId in :allSubRoleIds]){
            uNames.put(u.id, u.name);
        }
        for(AggregateResult ar : [select user__c uId, count(id) num from Referral_Source_Audit__c where request_date__c>=:getDateFunction(dateRng, true) and request_date__c<=:getDateFunction(dateRng, false) and status__c='Added' and user__c in (select id from user where userRoleId in :allSubRoleIds) group by user__c]){
                html += '<tr><td scope=\'row\' data-label=\'Name\'><div class=\'slds-truncate\' title=\''+uNames.get((String)ar.get('uId'))+'\'><a onclick="selectEmployee(); selectUser(\''+(String)ar.get('uId')+'\', handleDate); $(\'#assignmentNav > .backButton\').attr(\'onclick\', \'selectAdded(handleDate)\');">'+uNames.get((String)ar.get('uId'))+'</a></div>'+
                        '<td scope=\'row\' data-label=\'Name\'><div title=\''+(Integer)ar.get('num')+'\'>'+(Integer)ar.get('num')+'</div></td></tr>';
                
            }
        return html;
    }
    
    @RemoteAction global static String getDeleted(String dateRng) {
        String html = '';
        List<Id> allSubRoleIds = new List<ID>{UserInfo.getUserRoleId()};
                 allSubRoleIds.addAll(getSubRoleIds(new List<ID>{UserInfo.getUserRoleId()}));
        Map<Id, String> uNames = new Map<Id, String>();
        for(User u : [select id, name from user where userRoleId in :allSubRoleIds]){
            uNames.put(u.id, u.name);
        }
        for(AggregateResult ar : [select user__c uId, count(id) num from Referral_Source_Audit__c where request_date__c>=:getDateFunction(dateRng, true) and request_date__c<=:getDateFunction(dateRng, false) and status__c='Deleted' and user__c in (select id from user where userRoleId in :allSubRoleIds) group by user__c]){
                html += '<tr><td scope=\'row\' data-label=\'salesAssociate\'><div class=\'slds-truncate\' title=\''+uNames.get((String)ar.get('uId'))+'\'><a onclick="selectEmployee(); selectUser(\''+(String)ar.get('uId')+'\', handleDate); $(\'#assignmentNav > .backButton\').attr(\'onclick\', \'selectDeleted(handleDate)\');">'+uNames.get((String)ar.get('uId'))+'</a></div>'+
                        '<td scope=\'row\' data-label=\'totalAssignments\'><div title=\''+(Integer)ar.get('num')+'\'>'+(Integer)ar.get('num')+'</div></td></tr>';
                
            }
        return html;
    }
    
    private static Date getDateFunction(String dateRng, Boolean isGreater){
        Date dG=Date.today();
        Date dL=Date.today();
        Integer year=dG.year();
        if(dateRng.isNumeric() && Integer.valueOf(dateRng)>11) {year--; dateRng=String.valueOf(Integer.valueOf(dateRng)-12);}
        
        if(dateRng=='Today') {dG=Date.today(); dL=Date.today();}
        else if(dateRng=='Yesterday') {dG=dG.addDays(-1); dL=dG;}
        else if(dateRng=='This Week') {dG=dG.toStartOfWeek(); dL=dG.addDays(6);}
        else if(dateRng=='Last Week') {dG=dG.toStartOfWeek(); dG=dG.addDays(-7); dL=dG.addDays(6);}
        else if(dateRng.isNumeric()){dG=Date.newInstance(year, Integer.valueOf(dateRng)+1, 1); dL=dG; dL=dL.addMonths(1); dL=dL.addDays(-1);}
        
        if(isGreater) return dG;
        else return dL;
    }
}