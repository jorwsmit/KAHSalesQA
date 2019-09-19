trigger AA_AccountUnitContactTrigger on Account_Unit_Contact__c (before insert){
    
    for(Account_Unit_Contact__c auc : trigger.new){
        list<Account_Unit_Contact__c> accountUnitContacts = new list<Account_Unit_Contact__c>();        
        accountUnitContacts = [SELECT ID, Unit_Name__c FROM Account_Unit_Contact__c WHERE Account_Unit__c =: auc.Account_Unit__c AND Contact__c =: auc.Contact__c];
        if(accountUnitContacts.size() > 0){
            auc.addError('This Account Unit Contact link has already been created.');
            }
        }
    
}