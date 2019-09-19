public with sharing class AA_SRSAccountRequest{
    
    @AuraEnabled
    public static string processAccount(string accName, string accType, string accStreet, string accState, string accCity, string accZip, string accPhone, string accDefID, boolean accNewConst){
        string result = '';
        system.debug('name: ' + accName);
        system.debug('type: ' + accType);
        system.debug('street: ' + accStreet);
        system.debug('city: ' + accCity);
        system.debug('state: ' + accState);
        system.debug('zip: ' + accZip);
        system.debug('phone: ' + accPhone);
        system.debug('Def ID: ' + accDefID);
        
        ID accTemp = [SELECT ID FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'TempAccount_SRS'].ID;
        
        try{
            Account tempAccount = new Account();
            tempAccount.Name = accName;
            tempAccount.Type = accType;
            tempAccount.BillingStreet = accStreet;
            tempAccount.BillingCity = accCity;
            tempAccount.BillingState = accState;
            tempAccount.BillingPostalCode = accZip;
            tempAccount.Phone = accPhone;
            tempAccount.KRS_Definitive_ID__c = accDefID;
            tempAccount.KRS_New_Construction__c = accNewConst;
            tempAccount.RecordTypeId = accTemp;
            insert tempAccount;
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('A new account has been requested to be created by:  ' +
                                'Please review the items and approve or reject the request so it can be processed.');
                req.setObjectId(tempAccount.ID);
                system.debug('reqCheck'+req);
                // submit the approval request(s) for processing
            Approval.ProcessResult rslt = Approval.process(req);
            result = 'Your account record has been submitted for review.  A manager will evaluate the record and determine if it is valid for use.';
            return result;
            }
        catch(Exception E){
            result = 'Something went wrong.  Please try your submission again.  If issue persists, contact an administrator: ' + e.getMessage() + ' Line: ' + e.getLineNumber();
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            return result;
            }   
        
        }
        
    @AuraEnabled(cacheable=true) 
    public static list<string> getStateList(){
        list<string> lstStates = new list<string>();
        lstStates.add('None');
        for(States__c objState : [SELECT Id, Name FROM States__c Order BY Name]) {
            lstStates.add(objState.Name);
            }
        return lstStates;
        }   
        
    @AuraEnabled
    public static list<String> getTypes(){
        list<string> typeOptions = new list<string>();
        typeOptions.add('--None Selected--');
        typeOptions.add('Adult Day Care');
        typeOptions.add('Agency');
        typeOptions.add('Assisted Living');
        typeOptions.add('CCRC');
        typeOptions.add('Corporate Office - SRS');
        typeOptions.add('Home Care - Adults');
        typeOptions.add('Independent Living');
        typeOptions.add('Physician Practice - SRS');
        typeOptions.add('Skilled Nursing');
        
        return typeOptions;
        }       
    
}