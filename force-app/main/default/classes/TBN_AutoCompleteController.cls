/**
@ClassName    : TBN_AutoCompleteController
@JIRATicket   : https://trekbin.jira.com/browse/KINCCR-22
@CreatedOn    : 26/11/2015
@ModifiedBy   : Ritika
@Description  : Controller logic for Autocomplete component
*/
global with sharing class TBN_AutoCompleteController {
    
    /**
    @MethodName : findUsers
    @Param      : strSearch - Typed string to search in the users
    @Description: It checks for the corresponding users and fetches all the records matching to the typed string to search   
    **/
    @RemoteAction
    global static List<User> findUsers(String strSearch) {
    
        List<User> lstUsersToReturn = new List<User>();
        
        String strSearchTerm = '%' + string.escapeSingleQuotes(strSearch) + '%';
        lstUsersToReturn = [Select Id, FirstName, LastName, PERNER__c, Line_of_Business__c 
                            From User 
                            Where 
                                    (FirstName LIKE: strSearchTerm OR 
                                    LastName LIKE: strSearchTerm)
                            Order By LastName];
        return lstUsersToReturn;   
    }
    
    @RemoteAction
    global static List<User> findActiveUsers(String strSearch) {
    
        List<User> lstUsersToReturn = new List<User>();
        
        String strSearchTerm = '%' + string.escapeSingleQuotes(strSearch) + '%';
        lstUsersToReturn = [Select Id, FirstName, LastName, PERNER__c, Line_of_Business__c 
                            From User 
                            Where isActive=: true AND
                                    (FirstName LIKE: strSearchTerm OR 
                                    LastName LIKE: strSearchTerm)
                            Order By LastName];
        
        return lstUsersToReturn;   
    }
    
    @RemoteAction
    global static List<Account> fetchAccount(String strSearch) {
    
        List<Account> lstAccountsToReturn = new List<Account>();
        list<RecordType> lstRecordType = new list<RecordType>();
        
        lstRecordType = [   select Id, Name, Description, DeveloperName, IsActive 
                            from RecordType
                            where sobjecttype='Account' AND 
                                  DeveloperName='Center'];
        
        String strSearchTerm = '%' + string.escapeSingleQuotes(strSearch) + '%';
        lstAccountsToReturn = [Select Id, Name, Parent.Name, Facility_Number__c, Type
                            From Account
                            WHERE Account.recordtypeid IN: lstRecordType
                            AND Name LIKE: strSearchTerm 
                            AND Status__c =:'Active'
                            AND Parent.Name =:'Kindred Healthcare Inc'
                            Order By Name];
                    
        return lstAccountsToReturn;   
    }    
}