public with sharing class AA_CleanTempItems{
    
    public static id caseTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Case' AND DeveloperName = 'caseTemp'].Id;
    public static id contactTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'contactTemp'].Id;
    public static id accountLacTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'accountLacTemp'].Id;
    public static id patientTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Patient_New__c' AND DeveloperName = 'patientTemp'].Id;
    public static id assessmentTempID = [SELECT sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Assessment__c' AND DeveloperName = 'assessmentTemp'].Id;
    
    public static void cleanItems(){
        
        list<Case> caseTemp = new list<Case>();
        list<Contact> contactTemp = new list<Contact>();
        list<Account> accountTemp = new list<Account>();
        list<Patient_New__c> patientTemp = new list<Patient_New__c>();
        list<Assessment__c> assessmentTemp = new list<Assessment__c>();
        
        set<Case> caseClean = new set<Case>();
        set<Contact> contactClean = new set<Contact>();
        set<Account> accountClean = new set<Account>();
        set<Patient_New__c> patientClean = new set<Patient_New__c>();
        set<Assessment__c> assessmentClean = new set<Assessment__c>();
        
        list<Case> caseDelete = new list<Case>();
        list<Contact> contactDelete = new list<Contact>();
        list<Account> accountDelete = new list<Account>();
        list<Patient_New__c> patientDelete = new list<Patient_New__c>();
        list<Assessment__c> assessmentDelete = new list<Assessment__c>();
        
        
        caseTemp = [SELECT ID, CreatedDate FROM Case WHERE RecordTypeID =: caseTempID AND CreatedDate <= YESTERDAY];
        contactTemp = [SELECT ID, CreatedDate FROM Contact WHERE RecordTypeID =: contactTempID AND CreatedDate <= YESTERDAY];
        accountTemp = [SELECT ID, CreatedDate FROM Account WHERE RecordTypeID =: accountLacTempID AND CreatedDate <= YESTERDAY];
        patientTemp = [SELECT ID, CreatedDate FROM Patient_New__c WHERE RecordTypeID =: patientTempID AND CreatedDate <= YESTERDAY];
        assessmentTemp = [SELECT ID, CreatedDate FROM Assessment__c WHERE RecordTypeID =: assessmentTempID AND CreatedDate <= YESTERDAY];
        
        caseClean.addAll(caseTemp);
        contactClean.addAll(contactTemp);
        accountClean.addAll(accountTemp);
        patientClean.addAll(patientTemp);
        assessmentClean.addAll(assessmentTemp);
        
        caseDelete.addAll(caseClean);
        accountDelete.addAll(accountClean);
        contactDelete.addAll(contactClean);
        patientDelete.addAll(patientClean);
        assessmentDelete.addAll(assessmentClean);
        
        system.debug('caseTemp: ' + caseDelete);
        system.debug('contactTemp: ' + contactDelete);
        system.debug('accountTemp: ' + accountDelete);
        system.debug('patientTemp: ' + patientDelete);
        system.debug('assessmentTemp: ' + assessmentDelete);
        
        if(caseDelete.size() > 0){
        	try{
            	delete caseDelete;
        		}
        		catch(Exception e){
                system.debug('Already Deleted');
                }
            }
        if(accountDelete.size() > 0){
            try{
            	delete accountDelete;
            	}
            	catch(Exception e){
                system.debug('Already Deleted');
                }
            } 
        if(contactDelete.size() > 0){
            try{
            	delete contactDelete;
            	}
            	catch(Exception e){
                system.debug('Already Deleted');
                }
            }
        if(patientDelete.size() > 0){
            try{
            	delete patientDelete;
            	}
            	catch(Exception e){
                system.debug('Already Deleted');
                }
            }   
        if(assessmentDelete.size() > 0){
            try{
            	delete assessmentDelete;
                }
            catch(Exception e){
                system.debug('Assessments Already Deleted');
                }   
            }           
            
        }
    
}