/**
@ClassName    : TBN_AssociateTargetAssignmentController
@JIRATicket   : https://trekbin.jira.com/browse/KINCCR-22
@CreatedOn    : 24/11/2015
@ModifiedBy   : Ritika
@Description  : This class is used to handle the logic for TBN_AssociateTargetAssignment page.
**/
global with sharing class TBN_AssociateTargetAssignmentController {
    
    // variables declared for fetching the value selected in the dropdowns
    public String strSelectedYear                               {   get; set;   }               // Year selected in the drop-down
    public String strSelectedDivision                           {   get; set;   }               // Division selected in the drop-down
    public String strPreviousSelectedUser                       {   get; set;   }               // The selected previously user. This is used to fetch SP records when Year is updated
    public Decimal totalAssignedHours                           {   get; set;   }               // Total of all the hours allocated in Sales Performance records for Admission
    public Decimal totalAssignedHoursRev                        {   get; set;   }               // Total of all the hours allocated in Sales Performance records for Revenue
    public String strRefererURL                                 {   get; set;   }               // Gets the referer url to redirect to when Cancel button is clicked
    public String strErrorMessage                               {   get; set;   }               // Error message to be displayed to the user
    public String strSelectedUserId                             {   get; set;   }               //string to store the selected userId from the picklist.
    public boolean isRevSelected                                {   get; set;   }               //Boolean to check if revenue radio is selected.
    public boolean isAdmSelected                                {   get; set;   }               //Boolean to check if admission radio is selected.
    public boolean isPageMessage                                {   get; set;   }               //Boolean for showing the message if there are no users.
    public List<SelectOption> lstRVPs                           {   get; set;   }               // List of users having roles belonging to RVP level
    public boolean isSuccess                                    {   get; set;   }               //to show the success message if the Boolean is true
    public List<String> lstMonthNames                           {   get; set;   }               // Month Names used as Header for Sales Performance table
    public Map<Integer, Decimal> mapColumnarAssignmentsTotal    {   get; set;   }               //Total of Admission in sales performance table for each column.
    public Map<Integer, Decimal> mapColumnarRevenueTotal        {   get; set;   }               // Totals of revenue in sales performance table for each column.
    
    public List<EmployeeAssignment> lstEmployeeAssignments      {   get; set;   }               // Employee Assignments based on the dropdown selections
    
    // Static variables used in the class
    static final String PARENT_ROLE = 'SVP - KAH';       //Variable which contains 'SVP - KAH' role name, used to query all the roles below it in the division picklist.
    
    /**
    @ClassName  : UserRoleDependent
    @Description: This class acts as a wrapper for collective information representing the Userid and corresponding name
    
    public class UserRoleDependent {
        
        public Id strUserId                                     {   get;set;    } 
        public String strUserName                               {   get;set;    }
            
        public UserRoleDependent(String strUserId, String strUserName) {
            
            this.strUserId = strUserId;
            this.strUserName = strUserName;
        }
    }**/
    
    /**
    @ClassName  : EmployeeAssignment
    @Description: This class acts as a wrapper for collective information representing an Employee and assignments during the selected year
    **/
    public class EmployeeAssignment {
        
        public String strEmployeeId                                         {   get; set;   }
        public String strEmployeeName                                       {   get; set;   }
        public String strFacilityName                                       {   get; set;   }
        public String strDivisionName                                       {   get; set;   }
        
        public Decimal intUserTotalAdmissions                               {   get; set;   }       // Row Totals - Used to denote admission totals in Sales Performance rows
        public Decimal intUserTotalRevenue                                  {   get; set;   }       // Row Totals - Used to denote revenue totals in Sales Performance rows
        public Map<Integer, Sales_Performance__c> mapMonthAssignments       {   get; set;   }       // This map contains assignments for each user
        
        public EmployeeAssignment() {
            
            intUserTotalAdmissions = 0;
            intUserTotalRevenue = 0;
            
            // Initialize the map with Sales Performance records
            mapMonthAssignments = new Map<Integer, Sales_Performance__c>{   1 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            2 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            3 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            4 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            5 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            6 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0),
                                                                            7 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            8 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            9 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            10 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            11 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0), 
                                                                            12 => new Sales_Performance__c(Targeted_Admissions__c = 0, Targeted_Revenue__c = 0)};
        }
    }
    
    /* Constructor */
    public TBN_AssociateTargetAssignmentController() {
        
        // Calls the init method
        init();
    }
    
    /**
    @MethodName : init
    @Param      : None
    @Description: Method used to intialize variables in the class
    **/
    public void init() {
            
        strErrorMessage = strSelectedDivision = '';
        strPreviousSelectedUser = '';
        
        totalAssignedHours = 0;
        totalAssignedHoursRev = 0;
        isPageMessage = false;
        // If retUrl has been defined for the page
        strRefererURL = ApexPages.currentPage().getParameters().get('retURL');
        
        // If no referer is returned, make sure that the page is redirected to Case list view
        if(strRefererURL == null) {
            
            String keyPrefix = Sales_Performance__c.sObjectType.getDescribe().getKeyPrefix();
            strRefererURL = '/' +keyPrefix+ '/o';
        }
        
        lstRVPs = new List<SelectOption>();
        lstEmployeeAssignments = new List<EmployeeAssignment>();
        
        // Initialize Month names to be displayed as table headers
        lstMonthNames = new List<String>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        
        isRevSelected = false;   
        isAdmSelected = true;                              
    }
    
    /**
    @MethodName : fetchUserRoles
    @Param      : selectedRole
    @Description: This method called to get the users whose parent user role is the selected user role
    **/
    @RemoteAction
    global static String fetchUserRoles( String selectedRole, Integer rowIndex ) {
        
        String strUserIds = '';
        String selectedUserRole = '';
        String strSelectOptionsHTML;  // string to form HTML select options which is passed to the page.
        
        set<Id> setUserRoleId = new set<Id>();
        
        // selectedRole - selectedUserOrRole
        // selectedUserRole - selectedRole
        if( String.isNotBlank(selectedRole) ) {
            
            // Checks if the selectedRole is a role or a user and proceed with the query accordingly
            if( ((Id)(SelectedRole)).getSObjectType() == UserRole.sObjectType ) {
                
                selectedUserRole = selectedRole; 
            }
            else {
                
                User objUserforRole = [Select Id, UserRoleId From User where Id =: selectedRole]; 
                selectedUserRole = objUserforRole.UserRoleId;
            }
            
            // Query the users based on the parent role
            for(User objUser : [Select Id, Name, UserRoleId 
                                From User 
                                Where UserRole.ParentRoleId =: selectedUserRole AND 
                                        isActive = true AND 
                                        UserRoleId != NULL 
                                Order By Name 
                                Limit 1000] ) {
                
                setUserRoleId.add( objUser.UserRoleId );
                strSelectOptionsHTML += '<option value="' + objUser.Id + '">' + objUser.Name + '</option>';
            }
            
            
            // If the users exist
                // Else Query roles till the users are reached
            if( String.isNotBlank(strSelectOptionsHTML) ) {
            
                strSelectOptionsHTML = '<tr class="rowContainingPicklist" id="row_'+rowIndex+'">' +
                                            '<td colspan="1" width="16%" margin = 20px"></td>' + 
                                            '<td width="28%">' +
                                                '<div class="form-group mediumMarginTop formElementsWidth">' +
                                                    '<select class="form-control formElementsWidth mediumMarginTop" size="1" onchange="fetchDependentRoles(this.value, this.id);" id="pickVal_'+rowIndex+'">'+
                                                        '<option value="">--None Selected--</option>' + 
                                                        strSelectOptionsHTML + 
                                                    '</select>' +
                                                '</div>' + 
                                            '</td>' +
                                        '</tr>';
            }
            else {
            
                String strInnerSelectOptionRoles = '';
                String strInnerSecondarySelectOptionRoles = '';
                
                Set<Id> setUserRolesToQuery = new Set<Id>();
                Set<Id> setInnerUserRoleId = new Set<Id>();
                Set<Id> setPrevUserRoles = new Set<Id>();
                setUserRolesToQuery = new Set<Id>();
                setUserRolesToQuery.add(selectedUserRole);
                
                /* Start - Identifying child roles not having any users */
                do {
                    
                    String strFirstLevelRoles = '';
                    rowIndex++;     // Incrementing the rowIndex of picklists, used in the page
                    String strInnerSelectOptionsHTML = '';
                    Boolean isFurtherHierarchyAvailable = false;
                    Set<Id> setTertiaryUserRoleId = new Set<Id>();
                    Map<Id, UserRole> mapUserRoles = new Map<Id, UserRole>();
                    Map<Id, UserRole> mapSecondaryUserRoles = new Map<Id, UserRole>();
                    
                    // Query the roles belonging to the selected role or fetched in the last iteration
                    for(UserRole objUserRole : [Select Id, Name, ParentRoleId
                                                From UserRole 
                                                Where ParentRoleId IN :setUserRolesToQuery AND 
                                                        Id NOT IN : setUserRoleId]) {
                    
                        mapUserRoles.put( objUserRole.Id, objUserRole );
                        strFirstLevelRoles += '<option disabled value="' + objUserRole.Id + '">' + objUserRole.Name + '</option>';
                    }
                    
                    // Set which will be used to query child roles in the next iteration
                    setUserRolesToQuery = mapUserRoles.keyset();
                    
                    // Identify if there are any users belonging to the child roles queried above
                    for(User objUser : [Select Id, Name, UserRoleId, UserRole.ParentRoleId, UserRole.Name
                                        From User 
                                        Where UserRoleId IN :mapUserRoles.keyset()  AND 
                                                isActive = true AND 
                                                UserRoleId != NULL 
                                        Order By Name 
                                        Limit 1000] ) {
                                            
                        // Adding users belonging to the parent role to options list
                        setInnerUserRoleId.add( objUser.UserRole.ParentRoleId );
                        strInnerSelectOptionRoles += '<option value="' + objUser.Id + '">' + objUser.Name + '</option>';
                        strUserIds += objUser.Id + ',';
                    }
                    
                    // If there are no users found belonging to the child roles
                    if( String.isBlank(strInnerSelectOptionRoles) ) {
                        
                        // If there are child user roles 
                        if( String.isNotBlank(strFirstLevelRoles) ) {
                            
                            // Form the HTML to be sent to page and displayed as an options list
                            String strChildRoles = '<select class="form-control formElementsWidth mediumMarginTop" size="1" onchange="fetchDependentRoles(this.value, this.id);" id="pickVal_'+rowIndex+'">'+
                                            '<option value="">--Roles--</option>' + 
                                            strFirstLevelRoles + 
                                        '</select>';

                            strSelectOptionsHTML += '<tr class="rowContainingPicklist" id="row_'+rowIndex+'">' +
                                                        '<td colspan="1" width="16%" margin = 20px"></td>' + 
                                                        '<td width="28%">' +
                                                            '<div class="form-group mediumMarginTop formElementsWidth">' +
                                                                strChildRoles + 
                                                            '</div>' + 
                                                        '</td>' +
                                                    '</tr>';
                            
                            // Set maintaining the child roles, these will be excluded in the next iteration
                            setUserRoleId = mapUserRoles.keyset();
                        }
                    }
                    else {
                        
                        strFirstLevelRoles = '';
                        
                        for(UserRole objUserRole : [Select Id, Name, ParentRoleId
                                                    From UserRole 
                                                    Where Id IN :setPrevUserRoles]) {
                            
                            strFirstLevelRoles += '<option value="' + objUserRole.Id + '">' + objUserRole.Name + '</option>';
                        }
                        
                        if( String.isNotBlank(strFirstLevelRoles) ) {
                            
                            // Form the HTML to be sent to page and displayed as an options list
                            String strChildRoles = '<select class="form-control formElementsWidth mediumMarginTop" size="1" onchange="fetchDependentRoles(this.value, this.id);" id="pickVal_'+rowIndex+'">'+
                                                '<option value="">--Roles--</option>' + 
                                                     strFirstLevelRoles + 
                                            '</select>';

                            strSelectOptionsHTML += '<tr class="rowContainingPicklist" id="row_'+rowIndex+'">' +
                                                        '<td colspan="1" width="16%" margin = 20px"></td>' + 
                                                        '<td width="28%">' +
                                                            '<div class="form-group mediumMarginTop formElementsWidth">' +
                                                                strChildRoles + 
                                                            '</div>' + 
                                                        '</td>' +
                                                    '</tr>';
                            
                            // Set maintaining the child roles, these will be excluded in the next iteration
                            setUserRoleId = mapUserRoles.keyset();
                        }
                        
                        rowIndex++; // Incrementing the row index again to display the users picklist option
                        
                        strSelectOptionsHTML += '<tr class="rowContainingPicklist" id="row_'+rowIndex+'">' +
                                                    '<td colspan="1" width="16%" margin = 20px"></td>' + 
                                                    '<td width="28%">' +
                                                        '<div class="form-group mediumMarginTop formElementsWidth">' +
                                                            '<select class="form-control formElementsWidth mediumMarginTop" size="1" onchange="fetchDependentRoles(this.value, this.id);" id="pickVal_'+rowIndex+'">'+
                                                            '<option value="">--None Selected--</option>' + 
                                                                strInnerSelectOptionRoles + 
                                                        '</select></div>' + 
                                                    '</td>' +
                                                '</tr>';
                    }

                    // Set of user roles 
                    setPrevUserRoles = setInnerUserRoleId;
                    
                } while ( !setUserRolesToQuery.isEmpty() && String.isBlank(strInnerSelectOptionRoles));
                // If there are no further roles to explore and no users to display, terminate the while loop
                
                /* End - Identifying child roles not having any users */
            }
            
            if( String.isNotBlank(strSelectOptionsHTML) )
                return strSelectOptionsHTML + '#$#' + strUserIds;
        }
        
        return '';
    }
    
    /**
    @MethodName : getlstTargetYears
    @Param      : None
    @Description: This method fetches the target years drop-down
    **/
    public List<SelectOption> getlstTargetYears() {
        
        List<SelectOption> lstOptions = new List<SelectOption>();
        
        //Iterates over the TargetAssignmentYears__c object and adds the name into the list which is displayed in target year selection
        for( TargetAssignmentYears__c obj : [Select Name From TargetAssignmentYears__c Order By Name] ) {
            
            lstOptions.add( new SelectOption(obj.Name, obj.Name));
        }
        
        return lstOptions;
    }
    
    /**
    @MethodName : getlstDivisions
    @Param      : None
    @Description: This method fetches the Roles which are direct descendent of Enterprise Sales role
    **/
    public List<SelectOption> getlstDivisions() {
        
        List<SelectOption> lstOptions = new List<SelectOption>();
        
        // Form the list of all the user roles where Enterprise Sales role is the parent
        List<UserRole> lstEnterpriseUserRole = [Select Id From UserRole Where Name = :PARENT_ROLE Limit 1];
        lstOptions.add( new SelectOption('', '--None Selected--'));
        //iterates over the UserRole to get all the roles that are directly below the Enterprise Role.
        for(UserRole objUserRole : [Select Name, Id From UserRole Where ParentRoleId IN: lstEnterpriseUserRole Order By Name]) {
            
            lstOptions.add( new SelectOption(objUserRole.Id, objUserRole.Name));
        }
        return lstOptions;
    }
    
    /**
    @MethodName : onTargetYearSelect
    @Param      : None
    @Description: Resets the dependent picklists and variables used on the page
    **/
    public void onTargetYearSelect() {
        
        try {
            
            // Calls the fetchTargetAssignments method to ensure the data displayed is correct
            fetchTargetAssignments(strPreviousSelectedUser);
        }
        catch(Exception ex) {
            
            strErrorMessage = ex.getMessage();
        }
    }
    
    /**
    @MethodName : onDivisionSelect
    @Param      : None
    @Description: Fetch the users where users role is directly dependent on selected division 
    **/
    public void onDivisionSelect() {
        
        // Reinitialize the error message on function call
        strErrorMessage = '';
        
        try {
            
            // If a division has been selected
            if(String.isNotBlank(strSelectedDivision)) {
                
                // Fetch the users dependent on selected division
                lstRVPs = fetchDependentUsers(strSelectedDivision);
            }
        }
        catch(Exception ex) {
            
            strErrorMessage = ex.getMessage();
        }
        
        // Reinitialize the dependent picklists and variables
        lstEmployeeAssignments = new List<EmployeeAssignment>();
    }
    
    
    /**
    @MethodName : fetchAssessments
    @Param      : none
    @Description: calls the method fetchTargetAssignments.
    **/
    public void fetchAssessments() {
        
        fetchTargetAssignments(strSelectedUserId);
    }
    
    /**
    @MethodName : fetchTargetAssignments
    @Param      : lastSelectedUser - user id which was selected in the last picklist being changed (RVP/VP/AVP/Area Director/Market Manager)
    @Description: Fetch Employee Assignments based on the last selected user
    **/
    public void fetchTargetAssignments( String lastSelectedUser ) {
        
        totalAssignedHours = 0;
        totalAssignedHoursRev = 0;
        isPageMessage = false;
        strPreviousSelectedUser = lastSelectedUser;
        list<Id> lstUserIdforSalesPerformance = new list<Id>();
        //Map<Id, List<UserRoleDependent>> mapRoleToUserlist = new Map<Id, List<UserRoleDependent>>();
        
        // Initialize the map of totals for all the months for Admission
        mapColumnarAssignmentsTotal = new Map<Integer, Decimal>{1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0,
                                                                7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 0};
                                                                
        // Initialize the map of totals for all the months for Admission                                                        
        mapColumnarRevenueTotal = new Map<Integer, Decimal>{1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0,
                                                                7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 0};
        lstEmployeeAssignments = new List<EmployeeAssignment>();
        Map<Id, EmployeeAssignment> mapEmployeeAssignments = new Map<Id, EmployeeAssignment>();
        
        if(lastSelectedUser != '') {
                
            try {
                
                String strUserQuery = '';
                String strParentRole = '';
                String strSalesPerformanceQuery = '';
                User objUserForRole;
                Set<String> setUserIds = new Set<String>();
                
                if(strPreviousSelectedUser.contains(',')) {
                    
                    strUserQuery = 'Id IN: setUserIds AND  ';
                    setUserIds.addAll(strPreviousSelectedUser.split(','));
                    strSalesPerformanceQuery = 'User__c IN: setUserIds AND  ';
                }
                else {
                    
                    setUserIds.add(strPreviousSelectedUser);
                    objUserForRole = [select id, name, UserRoleId from user where Id IN: setUserIds];
                    strParentRole = objUserForRole.UserRoleId;
                    strUserQuery = 'UserRole.ParentRoleId =: strParentRole AND  ';
                    strSalesPerformanceQuery = 'User__r.UserRole.ParentRoleId =: strParentRole AND  ';
                }
                
                String strSPQuery = 'Select Id, User__c, User__r.Name, User__r.UserRole.ParentRoleId, User__r.KAH_Facility__c, ' +
                                            'User__r.Division, Targeted_Admissions__c, Targeted_Revenue__c, Calendar_Month__c, User__r.ManagerId ' +
                                    'From Sales_Performance__c ' +
                                    'Where ' + strSalesPerformanceQuery + ' User__r.isActive = true AND ' + 
                                          'Calendar_Month__c != null ' +
                                    'Order By Month__c';
                               
                // Query Sales Performance records belonging to the users whose manager has been selected in the last option
                for(Sales_Performance__c objSalesPerformance : database.query( strSPQuery )) {
                                                                    
                    // Calendar Month has the format MM-YYYY
                    List<String> lstCalendarMonthAndYear = objSalesPerformance.Calendar_Month__c.split('-');
                    
                    // If the year matches with the Selected Year picklist
                    if(strSelectedYear == lstCalendarMonthAndYear[1]) {
                        
                        EmployeeAssignment objEmployeeAssignment;
                        
                        // If a SP record for some other month was found for the same user, get the previous record selected
                        if((mapEmployeeAssignments.containsKey(objSalesPerformance.User__c))) {
                            
                            objEmployeeAssignment = mapEmployeeAssignments.get(objSalesPerformance.User__c);
                            
                            // Add the amount to row totals
                            objEmployeeAssignment.intUserTotalAdmissions += (objSalesPerformance.Targeted_Admissions__c);
                            
                            // Add amounts for revenue row totals
                            if(objSalesPerformance.Targeted_Revenue__c != null)
                                objEmployeeAssignment.intUserTotalRevenue += (objSalesPerformance.Targeted_Revenue__c);
                        }
                        // Else form a new record for the user and initialize the variables as needed 
                        else {
                            
                            objEmployeeAssignment = new EmployeeAssignment();
                            
                            objEmployeeAssignment.strEmployeeId = objSalesPerformance.User__c;
                            objEmployeeAssignment.strEmployeeName = objSalesPerformance.User__r.Name;
                            objEmployeeAssignment.strFacilityName = objSalesPerformance.User__r.KAH_Facility__c;
                            objEmployeeAssignment.strDivisionName = objSalesPerformance.User__r.Division;
                            objEmployeeAssignment.intUserTotalAdmissions = (objSalesPerformance.Targeted_Admissions__c);
                            
                            // Add amounts for revenue row totals
                            if(objSalesPerformance.Targeted_Revenue__c != null)
                                objEmployeeAssignment.intUserTotalRevenue = (objSalesPerformance.Targeted_Revenue__c);
                        }
                        
                        // Map the Sales Performance record for each month
                        objEmployeeAssignment.mapMonthAssignments.put(Integer.valueOf(lstCalendarMonthAndYear[0]), objSalesPerformance);
                        
                        // Calculate the column totals of all users for individual months
                        if(mapColumnarAssignmentsTotal.containsKey(Integer.valueOf(lstCalendarMonthAndYear[0]))) {
                            
                            Decimal monthTotal = mapColumnarAssignmentsTotal.get(Integer.valueOf(lstCalendarMonthAndYear[0])) + 
                                                    (objSalesPerformance.Targeted_Admissions__c);
                            mapColumnarAssignmentsTotal.put(Integer.valueOf(lstCalendarMonthAndYear[0]), monthTotal);
                            
                            Decimal monthTotalRev = mapColumnarRevenueTotal.get(Integer.valueOf(lstCalendarMonthAndYear[0])) + 
                                                    (objSalesPerformance.Targeted_Revenue__c);
                            mapColumnarRevenueTotal.put(Integer.valueOf(lstCalendarMonthAndYear[0]), monthTotalRev);
                        }
                        else {
                            
                            mapColumnarAssignmentsTotal.put(Integer.valueOf(lstCalendarMonthAndYear[0]), (objSalesPerformance.Targeted_Admissions__c));
                            mapColumnarRevenueTotal.put(Integer.valueOf(lstCalendarMonthAndYear[0]), (objSalesPerformance.Targeted_Revenue__c));
                        }
                        
                        // These are the overall totals for all users for all months
                        totalAssignedHours += (objSalesPerformance.Targeted_Admissions__c);
                        totalAssignedHoursRev += (objSalesPerformance.Targeted_Revenue__c);
                        // Map the EmployeeAssignment record to User
                        mapEmployeeAssignments.put(objSalesPerformance.User__c, objEmployeeAssignment);
                    }
                }
                
                //Iterates over the user to get list of Employees whose ParentRoleId is selected user roleId
                for(User objUser : database.query( 'Select Id, Name, KAH_Facility__c, Division ' +
                                                    'From User ' +
                                                    'Where ' + strUserQuery + ' isActive = true ' +
                                                    'Order By Name ' +
                                                    'Limit 1000')) {
                                        
                    if(mapEmployeeAssignments.containsKey(objUser.Id)) {
                       
                       lstEmployeeAssignments.add( mapEmployeeAssignments.get(objUser.Id) );
                    }
                    // Else a new row needs to be associated to the user
                    else {
                        
                        EmployeeAssignment objEmployeeAssignment = new EmployeeAssignment();
                        objEmployeeAssignment.strEmployeeId = objUser.Id;
                        objEmployeeAssignment.strEmployeeName = objUser.Name;
                        objEmployeeAssignment.strFacilityName = objUser.KAH_Facility__c;
                        objEmployeeAssignment.strDivisionName = objUser.Division;
                        lstEmployeeAssignments.add( objEmployeeAssignment );
                    } 
                }
            }
            catch(Exception ex) {
                
                strErrorMessage = ex.getMessage();
            }
        }
    }
    
    
    /**
    @MethodName : fetchDependentUsers
    @Param      : selectedRole - Role of the user selected in the master picklist
    @Description: This is the generic method which identifies the dependent picklist values based on the selected user 
    **/
    public List<SelectOption> fetchDependentUsers(String selectedRole) {
        
        List<SelectOption> lstOptions = new List<SelectOption>();
        
        // Fetch the roles where selected user's role was the parent for it  
        List<UserRole> lstUserRoles = [Select Id From UserRole Where ParentRoleId = :selectedRole];
        lstOptions.add( new SelectOption('', '--None Selected--'));
         
        // Query users based on the roles
        for(User objUser : [Select Id, Name From User Where UserRoleId = :lstUserRoles AND isActive = true Order By Name Limit 1000]) {
            
            lstOptions.add( new SelectOption(objUser.Id, objUser.Name));
        }
        
        return lstOptions;
    }
    
    /**
    @MethodName : checkisRev
    @Param      : None
    @Description: method is called on click of Revenue radio button, used to hide Admission table and show Revenue table.
    **/
    public void checkisRev()    {
        
        isRevSelected = true;
        isAdmSelected = false;
    }
    
    /**
    @MethodName : checkisAdm
    @Param      : None
    @Description: method is called on click of Admission radio button, used to hide Revenue table and show Admission table.
    **/
    public void checkisAdm()    {
        
        isRevSelected = false;
        isAdmSelected =true;
    }
    
    /**
    @MethodName : upsertSalesPerformances
    @Param      : none
    @Description: Method called to upsert Sales Performance records
    **/
    public void upsertSalesPerformances() {
        
        isSuccess = false;
        List<Sales_Performance__c> lstSalesPerformanceToUpsert = new List<Sales_Performance__c>();
        
        // Iterate through all the user rows
        for(EmployeeAssignment objEmployeeAssignment : lstEmployeeAssignments) {
        
            // Iterate through all the months
            for(Integer intMonth : objEmployeeAssignment.mapMonthAssignments.keyset()) {
                
                // Fetch the Sales Performance record
                Sales_Performance__c objSalesPerformance = objEmployeeAssignment.mapMonthAssignments.get(intMonth);
                
                // If the record Id exists, the record will be directly added to list to upsert
                if(objSalesPerformance.Id != null) {
                    
                    lstSalesPerformanceToUpsert.add(objSalesPerformance);
                }
                // Else a new Sales Performance record will be created
                else if(objSalesPerformance.Targeted_Admissions__c != 0 || objSalesPerformance.Targeted_Revenue__c !=0) {
                    
                    String strMonth = String.valueof(intMonth);
                    
                    if (strMonth.length() == 1) 
                        strMonth = '0' + intMonth;
                    
                    objSalesPerformance.Name = objEmployeeAssignment.strEmployeeName +' - ' +strMonth+'/'+strSelectedYear;
                    objSalesPerformance.Sales_Performance_Id__c = objEmployeeAssignment.strEmployeeId + strMonth + strSelectedYear;
                    objSalesPerformance.User__c = objEmployeeAssignment.strEmployeeId;
                    objSalesPerformance.Month__c = Date.newInstance(Integer.valueOf(strSelectedYear), intMonth, 1);
                    objSalesPerformance.OwnerId = objEmployeeAssignment.strEmployeeId;
                    lstSalesPerformanceToUpsert.add(objSalesPerformance);
                }
            }
        }
        
        upsert lstSalesPerformanceToUpsert;
                        
        fetchTargetAssignments(strPreviousSelectedUser);
        isSuccess = true;
    }
}