/**
@ClassName    : TBN_BatchToRollupInitialMetrics 
@CreatedOn    : 07/03/2016
@ModifiedBy   : Ritika
@Description  : Batch to update Account and Contact Metrics data onto parent records
                Script to run batch from Dev Console: 
                    Database.executeBatch(new TBN_BatchToRollupInitialMetrics('Sales_Account_Metrics__c'), 200);
                Scheduler: 
                    TBN_ScheduleBatch
**/
global without sharing class TBN_BatchToRollupInitialMetrics implements Database.batchable<sObject> {
   		/** stores the child object name whose fields value are summarised to the parent object */
   private String objectName {get;set;}
   		/**
        @MethodName : TBN_BatchToRollupInitialMetrics
        @param      : String objectName
        @Description: This is a constructor which is used to initialise the instance variable value at the time of loading 
    	*/
   public TBN_BatchToRollupInitialMetrics(String objectName) {
        this.objectName = objectName;
   		}
   
   		/**
        @MethodName : start
        @param      : Database.batchableContext batchableContext
        @Description: This method is called first time during batch execution, in this method we are retrieving records and passes it to execute method for further processing.
    	*/
   global Database.QueryLocator start(Database.batchableContext batchableContext){
        //stores the soql query string 
        String strQuery = '';
        //checking the objectName if Account Metrics then retrieving Account Metrics records
        if(objectName == 'Sales_Account_Metrics__c'){
            strQuery = ' SELECT Account__r.Id, Month__c, LastModifiedDate FROM Sales_Account_Metrics__c Order By Account__c ';
        	}
        //otherwise if Contact Metrics then retrieving Contact Metrics records
        else if(objectName == 'Sales_Contact_Metrics__c'){
            strQuery = ' SELECT Contact__r.Id, Month__c, LastModifiedDate FROM Sales_Contact_Metrics__c Order By Contact__c  ';
        	}
        return Database.getQueryLocator(strQuery);
   		}
   
   		/**
        @MethodName : execute
        @param1      : Database.BatchableContext batchableContext
        @param2      : List<sObject> scope
        @Description: This method is called after start and perform the activity on the records coming from start.
   		*/
   global void execute(Database.BatchableContext batchableContext, List<sObject> scope){
       try{
           //stores the ids associted to Sales_Account_Metrics__c or Sales_Contact_Metrics__c based on the objectName
           Set<Id> setSobjectIds = new Set<Id>();
           Set<Id> setFirstTimeSobjectIds = new Set<Id>();
           //stores the child object query string
           String strChildQuery = '';
           //check if objectName is Sales_Account_Metrics__c then storing all the account ids associated to the Sales_Account_Metrics__c.
           if(objectName == 'Sales_Account_Metrics__c'){
                //storing the parent object ids
                for(Sales_Account_Metrics__c objAccountMetric : (List<Sales_Account_Metrics__c>)(Scope)){
                    setSobjectIds.add(objAccountMetric.Account__c);
                	}
                setFirstTimeSobjectIds.addAll(setSobjectIds);
                
                //formatting the child object query string 
                strChildQuery = ' SELECT SUM(KAH_HP_Referrals__c) totalhpreferal, SUM(KAH_HP_Admits__c) totalhpadmits, SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmits, '
                              + ' SUM(KAH_HH_Referrals__c) totalhhreferal, SUM(KAH_HH_Admits__c) totalhhadmits, SUM(KAH_HH_Discounted_Qualified_Admits__c) totalhhqualadmits, SUM(KAH_HH_Admits_Prior__c) totalhhpy, Account__r.Id accId, CALENDAR_YEAR(Month__c) CYear'
                              + ' FROM Sales_Account_Metrics__c WHERE Account__r.Id in :setSobjectIds'
                              + ' AND (CALENDAR_YEAR(Month__c) = ' +Date.today().year()+ ' OR CALENDAR_YEAR(Month__c) = ' + (Date.today().year()-1) +
                              + ') group by Account__r.Id, CALENDAR_YEAR(Month__c)';
    
                //stores the account records needed for updation
                Map<Id, Account> mapAccounts = new Map<Id, Account>();
                
                //Getting each Sales_Account_Metrics__c record having total values of admits & referal fields and storing as account object record             
                for(AggregateResult sobj : Database.Query(strChildQuery)){
                    //stores the value of accountId
                    String accId = String.valueOf(sobj.get('accId'));
                    Account objAccount;
                    if(mapAccounts.containsKey(accId)){
                        objAccount = mapAccounts.get(accId);
                    	}
                    else{
                        objAccount = new Account(Id = accId);
                    	}
                    if(setFirstTimeSobjectIds.contains(String.valueOf(sobj.get('accId')))){
                        objAccount.KAH_HH_Admits_YTD__c = 0;
                        objAccount.KAH_HH_Discounted_Qualified_Admits_PY__c = 0;
                        objAccount.KAH_HH_Discounted_Qualified_Admits_YTD__c = 0;
                        objAccount.KAH_HP_Qualified_Admits_PY__c = 0;
                        objAccount.KAH_HP_Qualified_Admits_YTD__c = 0;
                        objAccount.KAH_HH_Referrals_YTD__c = 0;
                        objAccount.KAH_HP_Admits_YTD__c = 0;
                        objAccount.KAH_HP_Referrals_YTD__c = 0;
                        objAccount.HH_Admits_PY__c = 0;
                        objAccount.HH_Referrals_PY__c = 0;
                        objAccount.HP_Admits_PY__c = 0;
                        objAccount.HP_Referrals_PY__c = 0;
                        objAccount.KAH_HH_PPS_Prior_Year_Admits_Prior__c = 0;
                        setFirstTimeSobjectIds.remove(String.valueOf(sobj.get('accId')));
                    	}
                    
                    if(Integer.valueOf(sobj.get('CYear')) == Date.today().year()){
                        //creates the account variable to store the summation value of Sales_Account_Metrics__c > admits & referal field values
                        objAccount.KAH_HH_Admits_YTD__c = Double.valueof(sobj.get('totalhhadmits'));
                        objAccount.KAH_HH_Discounted_Qualified_Admits_YTD__c = Double.valueof(sobj.get('totalhhqualadmits'));
                        objAccount.KAH_HP_Qualified_Admits_YTD__c = Double.valueof(sobj.get('totalhpqualadmits'));
                        objAccount.KAH_HH_Referrals_YTD__c = Double.valueof(sobj.get('totalhhreferal'));
                        objAccount.KAH_HP_Admits_YTD__c = Double.valueof(sobj.get('totalhpadmits'));
                        objAccount.KAH_HP_Referrals_YTD__c = Double.valueof(sobj.get('totalhpreferal'));
                    	}    
                    else if(Integer.valueOf(sobj.get('CYear')) == (Date.today().year()-1)) {
                        objAccount.HH_Admits_PY__c = Double.valueof(sobj.get('totalhhadmits'));
                        objAccount.HH_Referrals_PY__c = Double.valueof(sobj.get('totalhhreferal'));
                        objAccount.KAH_HH_Discounted_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhhqualadmits'));
                        objAccount.KAH_HP_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhpqualadmits'));
                        objAccount.HP_Admits_PY__c = Double.valueof(sobj.get('totalhpadmits'));
                        objAccount.HP_Referrals_PY__c = Double.valueof(sobj.get('totalhpreferal'));
                        objAccount.KAH_HH_PPS_Prior_Year_Admits_Prior__c = Double.valueof(sobj.get('totalhhpy'));
                    	}
                    mapAccounts.put(accId, objAccount);
                	}
                if(!setFirstTimeSobjectIds.isEmpty()){
                    for(String objId: setFirstTimeSobjectIds){
                        Account objAccount = new Account(Id = objId, 
                                                         KAH_HH_Admits_YTD__c = 0,
                                                         KAH_HH_Discounted_Qualified_Admits_PY__c = 0,
                                                         KAH_HH_Discounted_Qualified_Admits_YTD__c = 0,
                                                         KAH_HP_Qualified_Admits_PY__c = 0,
                                                         KAH_HP_Qualified_Admits_YTD__c = 0,
                                                         KAH_HH_Referrals_YTD__c = 0,
                                                         KAH_HH_PPS_Admits_YTD__c = 0,
                                                         KAH_HP_Admits_YTD__c = 0,
                                                         KAH_HP_Referrals_YTD__c = 0,
                                                         HH_Admits_PY__c = 0,
                                                         HH_Referrals_PY__c = 0,
                                                         HP_Admits_PY__c = 0,
                                                         HP_Referrals_PY__c = 0);
                        mapAccounts.put(objId, objAccount);
                    	}
                	}
                //updating the account records
                update mapAccounts.values();
           		}
           //check if objectName is Sales_Contact_Metrics__c then storing all the account ids associated to the Sales_Contact_Metrics__c.
           else if(objectName == 'Sales_Contact_Metrics__c'){
 				//storing the parent object ids
                for(Sales_Contact_Metrics__c objContactMetric : (List<Sales_Contact_Metrics__c>)(Scope)){
                    setSobjectIds.add(objContactMetric.Contact__c);
                	}
                setFirstTimeSobjectIds.addAll(setSobjectIds);
                
                //formatting the child object query string 
                strChildQuery = ' SELECT SUM(KAH_HP_Referrals__c) totalhpreferal, SUM(KAH_HP_Admits__c) totalhpadmits, SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmits, '
                              + ' SUM(KAH_HH_Referrals__c) totalhhreferal, SUM(KAH_HH_Admits__c) totalhhadmits, SUM(KAH_HH_Qualified_Admits__c) totalhhqualadmits, SUM(KAH_HH_PPS_Admits__c) totalhhpy, Contact__r.Id conId, CALENDAR_YEAR(Month__c) CYear'
                              + ' FROM Sales_Contact_Metrics__c WHERE Contact__r.Id in :setSobjectIds'
                              + ' AND (CALENDAR_YEAR(Month__c) = ' +Date.today().year()+ ' OR CALENDAR_YEAR(Month__c) = ' + (Date.today().year()-1) +
                              + ') group by Contact__r.Id, CALENDAR_YEAR(Month__c)';
                //stores the contact records needed for updation
                Map<Id, Contact> mapContacts = new Map<Id, Contact> ();
                //Getting each Sales_Account_Metrics__c record having total values of admits & referal fields and storing as account object record             
                for(AggregateResult sobj : Database.Query(strChildQuery)){
                    //stores the value of accountId
                    String conId = String.valueOf(sobj.get('conId'));
                    Contact objContact;
                    if(mapContacts.containsKey(conId)){
                        objContact = mapContacts.get(conId);
                    	}
                    else{
                        objContact = new Contact(Id = conId);
                    	}
                    if(setFirstTimeSobjectIds.contains(String.valueOf(sobj.get('conId')))){
                        objContact.KAH_HH_Admits_YTD__c = 0;
                        objContact.KAH_HH_Discounted_Qualified_Admits_PY__c = 0;
                        objContact.KAH_HH_Discounted_Qualified_Admits_YTD__c = 0;
                        objContact.KAH_HP_Qualified_Admits_PY__c = 0;
                        objContact.KAH_HP_Qualified_Admits_YTD__c = 0;
                        objContact.KAH_HH_Referrals_YTD__c = 0;
                        objContact.KAH_HH_PPS_Admits_YTD__c = 0;
                        objContact.KAH_HP_Admits_YTD__c = 0;
                        objContact.KAH_HP_Referrals_YTD__c = 0;
                        objContact.HH_Admits_PY__c = 0;
                        objContact.HH_Referrals_PY__c = 0;
                        objContact.HP_Admits_PY__c = 0;
                        objContact.HP_Referrals_PY__c = 0;
                        objContact.KAH_HH_PPS_Prior_Year_Admits_Prior__c = 0;
                       	setFirstTimeSobjectIds.remove(String.valueOf(sobj.get('conId')));
                    	}
                    if(Integer.valueOf(sobj.get('CYear')) == Date.today().year()){
                        //creates the account variable to store the summation value of Sales_Account_Metrics__c > admits & referal field values
                        objContact.KAH_HH_Admits_YTD__c = Double.valueof(sobj.get('totalhhadmits'));
                        objContact.KAH_HH_Discounted_Qualified_Admits_YTD__c = Double.valueof(sobj.get('totalhhqualadmitsytd'));
                        objContact.KAH_HP_Qualified_Admits_YTD__c = Double.valueof(sobj.get('totalhpqualadmitsytd'));
                        objContact.KAH_HH_Referrals_YTD__c = Double.valueof(sobj.get('totalhhreferal'));
                        objContact.KAH_HP_Admits_YTD__c = Double.valueof(sobj.get('totalhpadmits'));
                        objContact.KAH_HP_Referrals_YTD__c = Double.valueof(sobj.get('totalhpreferal'));
                        objContact.KAH_HH_PPS_Admits_YTD__c = Double.valueof(sobj.get('totalhhpy'));
                        }    
                    else if(Integer.valueOf(sobj.get('CYear')) == (Date.today().year()-1)){
                        objContact.HH_Admits_PY__c = Double.valueof(sobj.get('totalhhadmits'));
                        objContact.HH_Referrals_PY__c = Double.valueof(sobj.get('totalhhreferal'));
                        objContact.KAH_HH_Discounted_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhhqualadmitspy'));
                        objContact.KAH_HP_Qualified_Admits_PY__c = Double.valueof(sobj.get('totalhpqualadmitspy'));
                        objContact.HP_Admits_PY__c = Double.valueof(sobj.get('totalhpadmits'));
                        objContact.HP_Referrals_PY__c = Double.valueof(sobj.get('totalhpreferal'));
                        objContact.KAH_HH_PPS_Prior_Year_Admits_Prior__c = Double.valueof(sobj.get('totalhhpy'));
                    	}
                    mapContacts.put(conId, objContact);
                	}
                
                if(!setFirstTimeSobjectIds.isEmpty()){
                    for(String objId: setFirstTimeSobjectIds){
                        Contact objContact = new Contact(Id = objId, 
                                                         KAH_HH_Admits_YTD__c = 0,
                                                         KAH_HH_Discounted_Qualified_Admits_PY__c = 0,
                                                         KAH_HH_Discounted_Qualified_Admits_YTD__c = 0,
                                                         KAH_HP_Qualified_Admits_PY__c = 0,
                                                         KAH_HP_Qualified_Admits_YTD__c = 0,
                                                         KAH_HH_PPS_Admits_YTD__c = 0,
                                                         KAH_HH_PPS_Prior_Year_Admits_Prior__c = 0,
                                                         KAH_HH_Referrals_YTD__c = 0,
                                                         KAH_HP_Admits_YTD__c = 0,
                                                         KAH_HP_Referrals_YTD__c = 0,
                                                         HH_Admits_PY__c = 0,
                                                         HH_Referrals_PY__c = 0,
                                                         HP_Admits_PY__c = 0,
                                                         HP_Referrals_PY__c = 0);
                        mapContacts.put(objId, objContact);
                    	}
                	}
                //updating the account records
                update mapContacts.values();
           		}
       		}
       catch(exception Ex){
        	system.debug('--------line----'+Ex.getLineNumber());
       		}
   		}
   
   /**
        @MethodName : finish
        @param      : Database.BatchableContext batchableContext
        @Description: This method is called at the last of batch execution.
   */
   global void finish(Database.BatchableContext batchableContext){
        if(this.objectName == 'Sales_Account_Metrics__c'){
            Database.executeBatch(new TBN_BatchToRollupInitialMetrics('Sales_Contact_Metrics__c'), 200);
        	}
   		}
}