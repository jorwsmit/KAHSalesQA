global class AA_YearEndMetricRollup implements database.Batchable<sObject>{
    
    /** stores the child object name whose fields value are summarised to the parent object */
    private String objectName;
    
    global Database.QueryLocator start(Database.batchableContext batchableContext){
        //stores the soql query string 
        String strQuery = '';
        system.debug('objectName: ' + objectName);
        //checking the objectName if Account Metrics then retrieving Account Metrics records which are modified current day and year
        if(objectName == 'Sales_Account_Metrics__c'){
            return Database.getQueryLocator([SELECT Account__r.Id, Month__c, LastModifiedDate FROM Sales_Account_Metrics__c Order By Account__r.Id]);
            }
        //otherwise if Contact Metrics then retrieving Contact Metrics records which are modified current day and year
        else if(objectName == 'Sales_Contact_Metrics__c'){
            return Database.getQueryLocator([SELECT Contact__r.Id, Month__c, LastModifiedDate FROM Sales_Contact_Metrics__c Order By Contact__r.Id]);
            }
        else{
            return null;
            }               
        }
    
    public AA_YearEndMetricRollup(String objectName){
        this.objectName = objectName;
        }
    
    global void execute(Database.BatchableContext batchableContext, List<sObject> scope)  {
         try{
           //stores the ids associted to Sales_Account_Metrics__c or Sales_Contact_Metrics__c based on the objectName
           Set<Id> setSobjectIds = new Set<Id>();
           //stores the account data retrieved from the parent SOQL 
           Map<Id, Account> mapAccount = new Map<Id, Account>(); 
           //stores the contact data retrieved from the parent SOQL 
           Map<Id, Contact> mapContact = new Map<Id, Contact>(); 
           
           List<Account> lstAccounts = new List<Account> ();
           List<Contact> lstContacts = new List<Contact> ();
           
           //check if objectName is Sales_Account_Metrics__c then storing all the account ids associated to the Sales_Account_Metrics__c.
           if(objectName == 'Sales_Account_Metrics__c'){
                    system.debug('Accounts processing');
                    //storing the parent object ids
                    for(Sales_Account_Metrics__c objAccountMetric : (List<Sales_Account_Metrics__c>)(Scope)) {
                        setSobjectIds.add(objAccountMetric.Account__c);
                        }
                    mapAccount = new Map<Id, Account>( [SELECT ID, KAH_HH_Admits_YTD__c, KAH_HH_Referrals_YTD__c, KAH_HP_Admits_YTD__c, KAH_HP_Referrals_YTD__c, 
                                                               KAH_HH_Discounted_Qualified_Admits_YTD__c, KAH_HP_Qualified_Admits_YTD__c, KAH_HP_PPS_Prior_Year_Admits_Prior__c
                                                               FROM Account WHERE Id in :setSobjectIds]);    
                    //formatting the child object query string 
                    list<AggregateResult> query = [SELECT SUM(KAH_HP_Referrals__c) totalhpreferal, 
                                                           SUM(KAH_HP_Admits__c) totalhpadmits, 
                                                           SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmits, 
                                                           SUM(KAH_HP_Admits__c) totalhppy,
                                                           SUM(KAH_HH_Referrals__c) totalhhreferal,
                                                           SUM(KAH_HH_Admits__c) totalhhadmits,
                                                           SUM(KAH_HH_Discounted_Qualified_Admits__c) totalhhqualadmits, 
                                                           SUM(KAH_HH_PPS_Admits__c) totalhhpy,
                                                           Account__r.Id accId
                                                           FROM Sales_Account_Metrics__c WHERE Account__r.Id in :setSobjectIds
                                                           AND Month__c = LAST_YEAR
                                                           group by Account__r.Id];
                    
                    for(AggregateResult sobj : query){
                        for(Id key : mapAccount.keySet()){
                        if(mapAccount.get(key).ID == sobj.get('accId')){
                        Account objAccount = new Account(Id = String.valueOf(sobj.get('accId')),
                                                         HH_Admits_PY__c = Double.valueof(sobj.get('totalhhadmits')),
                                                         KAH_HH_Discounted_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhhqualadmits')),
                                                         HH_Referrals_PY__c = Double.valueof(sobj.get('totalhhreferal')),
                                                         KAH_HH_PPS_Prior_Year_Admits_Prior__c = Double.valueof(sobj.get('totalhhpy')),
                                                         KAH_HP_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhpqualadmits')),
                                                         HP_Admits_PY__c = Double.valueof(sobj.get('totalhpadmits')),
                                                         HP_Referrals_PY__c = Double.valueof(sobj.get('totalhpreferal')),
                                                         KAH_HH_Admits_YTD__c = 0,
                                                         KAH_HH_Discounted_Qualified_Admits_YTD__c = 0,
                                                         KAH_HH_Referrals_YTD__c = 0,
                                                         KAH_HH_PPS_Admits_YTD__c = 0,
                                                         KAH_HP_Qualified_Admits_YTD__c = 0,
                                                         KAH_HP_Admits_YTD__c = 0,
                                                         KAH_HP_Referrals_YTD__c = 0);
                                                         
                        lstAccounts.add(objAccount);
                        }
                        }
                        }
                system.debug('lstAccounts: ' + lstAccounts);    
                //updating the account records
                update lstAccounts;
                }
           else if(objectName == 'Sales_Contact_Metrics__c') {
                //storing the parent object ids
                for(Sales_Contact_Metrics__c objContactMetric : (List<Sales_Contact_Metrics__c>)(Scope)){
                    setSobjectIds.add(objContactMetric.Contact__c);
                    }
                    mapContact = new Map<Id, Contact>( [SELECT ID, KAH_HH_Admits_YTD__c,KAH_HH_Referrals_YTD__c, KAH_HP_Admits_YTD__c, KAH_HP_Referrals_YTD__c, 
                                                               KAH_HH_Discounted_Qualified_Admits_YTD__c, KAH_HP_Qualified_Admits_YTD__c
                                                               FROM Contact WHERE Id in :setSobjectIds]);
                    
                    list<AggregateResult> query = [SELECT SUM(KAH_HP_Referrals__c) totalhpreferal,
                                                          SUM(KAH_HP_Admits__c) totalhpadmits, 
                                                          SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmits,
                                                          SUM(KAH_HH_Referrals__c) totalhhreferal, 
                                                          SUM(KAH_HH_Admits__c) totalhhadmits, 
                                                          SUM(KAH_HH_Discounted_Qualified_Admits__c) totalhhqualadmits, 
                                                          SUM(KAH_HH_PPS_Admits__c) totalhhpy, 
                                                          Contact__r.Id conId
                                                          FROM Sales_Contact_Metrics__c 
                                                          WHERE Contact__r.Id in :setSobjectIds
                                                          AND Month__c = LAST_YEAR 
                                                          group by Contact__r.Id];
                              
                    for(AggregateResult sobj : query){
                        for(Id key : mapContact.keySet()){
                        if(mapContact.get(key).ID == sobj.get('conId')){    
                        Contact objContact = new Contact(Id = String.valueOf(sobj.get('conId')),
                                                         HH_Admits_PY__c = Double.valueof(sobj.get('totalhhadmits')),
                                                         KAH_HH_Discounted_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhhqualadmits')),
                                                         HH_Referrals_PY__c = Double.valueof(sobj.get('totalhhreferal')),
                                                         KAH_HH_PPS_Prior_Year_Admits_Prior__c = Double.valueof(sobj.get('totalhhpy')),
                                                         HP_Admits_PY__c = Double.valueof(sobj.get('totalhpadmits')),
                                                         KAH_HP_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhpqualadmits')),
                                                         HP_Referrals_PY__c = Double.valueof(sobj.get('totalhpreferal')),
                                                         KAH_HH_Admits_YTD__c = 0,
                                                         KAH_HH_Discounted_Qualified_Admits_YTD__c = 0,
                                                         KAH_HH_Referrals_YTD__c = 0,
                                                         KAH_HH_PPS_Admits_YTD__c = 0,
                                                         KAH_HP_Admits_YTD__c = 0,
                                                         KAH_HP_Qualified_Admits_YTD__c = 0,
                                                         KAH_HP_Referrals_YTD__c = 0);
                            lstContacts.add(objContact);
                            }
                            }
                        }
                system.debug('listContacts: ' + lstContacts);       
                //Getting each Sales_Contact_Metrics__c record having total values of admits & referal fields and storing as contact object record             
                update lstContacts;
                }
                }
       catch(Exception e){
            system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            }
        }
        
    global void finish(Database.BatchableContext batchableContext) {
       //   if(this.objectName == 'Sales_Account_Metrics__c')
        //    Database.executeBatch(new AA_YearEndMetricRollup('Sales_Contact_Metrics__c'), 200);
            }    
}