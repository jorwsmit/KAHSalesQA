trigger AA_UnitTrigger on Unit__c (after insert, after update){

    ID hdType = AA_UtilityClass.getNewHDID;

    if(trigger.isAfter && trigger.isInsert){
        list<Account> hdAccounts = new list<Account>();
        list<Account_Unit__c> newAccUnits = new list<Account_Unit__c>();
        
        hdAccounts = [SELECT ID FROM Account WHERE RecordTypeID =: hdType];
        for(Unit__c u: trigger.new){
            for(Account a : hdAccounts){
                Account_Unit__c au = new Account_Unit__c();
                    au.Account__c = a.Id;
                    au.Unit__c = u.Id;
                    if(u.Name == 'Administrative'){
                        au.Active__c = true;
                        }
                    else{
                        au.Active__c = false;
                        }   
                    newAccUnits.add(au);
                }
            	}
            	system.debug('new AU Size: ' + newAccUnits.size());
            if(newAccUnits.size() > 0){
            	system.debug('Starting Process');
                AA_UnitProcessingActivate bc = new AA_UnitProcessingActivate(newAccUnits);
                Database.executeBatch(bc);
                }
        }
        
        
        if(trigger.isAfter && trigger.isUpdate){
            list<ID> unitIds = new list<ID>();
            for(Unit__c u : trigger.new){
                if(u.Active__c == false){
                    unitIds.add(u.Id);
                    }
                }
                list<Account_Unit__c> toUpdate = new list<Account_Unit__c>();
                toUpdate = [SELECT ID, Unit__c, Active__c FROM Account_Unit__c WHERE Unit__c IN: unitIds AND Active__c = true];
                
                for(Account_Unit__c au: toUpdate){
                    au.Active__c = false;
                }
                system.debug('Deactivate Size: ' + toUpdate.size());
            if(toUpdate.size() > 0){
            	AA_UnitProcessingDeactivate bc = new AA_UnitProcessingDeactivate(toUpdate);
                Database.executeBatch(bc);
            	}
        }
    
}