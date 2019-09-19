public with sharing class AA_Dashboard {
   
   	public static list<RecordType> lstRTAccount = [Select SobjectType, Name, DeveloperName 
                                                            From RecordType 
                                                            Where SobjectType = 'Account' AND DeveloperName IN ('PF_Chain', 'PF_Client')];
   	
	//constructor
    public AA_Dashboard(){
    	}
    
    /**
    @MethodName : getRoles
    @Param      : string selRole
    @Description: Method returns list of roles that contains value selected in the first picklist in it.
    **/ 
    @AuraEnabled
    public static list<string> getRoles(string selRole){
        //list to store the names of the roles to be passed.
        List<string> lstroleNames = new List<string>();
        
        lstroleNames.add('--None Selected--');
        system.debug('selRole:' + selRole);
        if(selRole != 'COO'){
        	string strQueryString = 'Select Name, Id From UserRole';
        	//iterates over the roles from UserRole and adds to the list
        	for(UserRole objUserRole : database.query(strQueryString)){
            	if(objUserRole.Name.contains(selRole) && !objUserRole.Name.contains(selRole + 'S')){
            		lstroleNames.add(objUserRole.Name);
            		}
        		}
        	}
        else{
        	lstRoleNames.add('COO - Glenda Mack');
        	}	
        return lstroleNames;
    	}
    
    /**
    @MethodName : getIndividuals
    @Param      : 
    @Description: Method returns list of Individuals under selected hierarchy
    **/
    @AuraEnabled
    public static list<string> getIndividuals(string selRole){
        list<string> individuals = new list<string>();
        string query = 'SELECT ID, Name, UserRole.Name FROM User WHERE UserRole.Name != null';
        individuals.add('--None Selected--');
        if(selRole != 'COO'){
        for(User u : database.query(query)){
            if(u.UserRole.Name.contains(selRole) && !u.UserRole.Name.contains(selRole + 'S')){
            	individuals.add(u.Name);
            	}
        	}
        individuals.sort();
        }
        individuals.add('Glenda Mack');
        return individuals;
    	}
    	
    /**
    @MethodName : getRoleNames
    @Param      : 
    @Description: Method returns list of roles containing, 'National', 'DVP', 'RVP', 'ADO'
    **/
    @AuraEnabled
    public static list<string> getRoleNames(){
        List<string> lstroleNames = new List<string>{'National', 'DVP', 'RVP', 'ADO'};
        return lstroleNames;
    	}
    	
    	
    @AuraEnabled
    public static list<string> getRoleAlt(){
        List<string> lstroleNames = new List<string>{'National', 'COO', 'DVP', 'RVP'};
        return lstroleNames;
    	}
    	
    @AuraEnabled
    public static list<string> getRoleAlt2(){
        List<string> lstroleNames = new List<string>{'None','ADO'};
        return lstroleNames;
    	}		
    
    /**
    @MethodName : getReportNames
    @Param      : 
    @Description: Method returns list of report names
    **/
    @AuraEnabled
    public static list<string> getReportNames(){
        List<string> lstReportNames = new List<string>{'Accounts without Activity', 'QBR Tracking', 'Risk Account (SNF Only)', 'Facility Reporting', 'ADO Activities'};
        return lstReportNames;
    	}
    	
}