/**
@ClassName    : TBN_RollUpSummaryBatch 
@CreatedOn    : 07/03/2016
@ModifiedBy   : Ritika
@Description  : Batch to update Account and Contact Metrics data onto parent records on a daily basis
                Script to run batch from Dev Console: 
                    Database.executeBatch(new TBN_RollUpSummaryBatch('Sales_Account_Metrics__c', 2), 200);
                Scheduler: 
                    TBN_ScheduleBatch
**/
global with sharing class TBN_RollUpSummaryBatch implements Database.batchable<sObject> {
    
   /** stores the child object name whose fields value are summarised to the parent object */
   private String objectName;
   
   /** stores the past local day-time */
   private Datetime prevScheduleDatetime;

   /** stores the current local day-time */     
   private Datetime localdatetime;
   
   /** stores the Hour at which scheduler runs */    
   private Integer schduledHour;
   
   /**
        @MethodName : TBN_RollUpSummaryBatch
        @param      : String objectName - Object on which the batch will run
                      Integer schduledHour - Last run time hour of scheduler
        @Description: This is a constructor which is used to initialise the instance variable value at the time of loading 
    */
   public TBN_RollUpSummaryBatch(String objectName, Integer schduledHour) {
       
        this.objectName = objectName;
        this.schduledHour = schduledHour;
        
        /** conversion of Datetime.now into local (user) timezone */
        //retrieving the date into GMT timezone
        localdatetime = Datetime.newInstance(date.today(), Time.newInstance(schduledHour, 0, 0, 0));
     
        //retrieving the user timezone
        TimeZone tz = UserInfo.getTimeZone();
        //retrieving timezone offset
        Integer offset = tz.getOffset(localdatetime);//fix DST timezone related issue
        //conversion of gmt date time into local date time
        localdatetime.addSeconds(-offset / 1000);
        
        //retrieving the one day before date time
        prevScheduleDatetime = localdatetime.addDays(-1);
   }
   
   /**
        @MethodName : start
        @param      : Database.batchableContext batchableContext
        @Description: This method is called first time during batch execution, in this method we are retrieving records and passes it to execute method for further processing.
    */
   global Database.QueryLocator start(Database.batchableContext batchableContext) {
       
        //stores the soql query string 
        String strQuery = '';
        
        //checking the objectName if Account Metrics then retrieving Account Metrics records which are modified current day and year
        if(objectName == 'Sales_Account_Metrics__c')
            strQuery = ' SELECT Account__r.Id, Month__c, LastModifiedDate FROM Sales_Account_Metrics__c ' +
                       ' WHERE LastModifiedDate >: prevScheduleDatetime Order By Account__r.Id';
        //otherwise if Contact Metrics then retrieving Contact Metrics records which are modified current day and year
        else if(objectName == 'Sales_Contact_Metrics__c')
            strQuery = ' SELECT Contact__r.Id, Month__c, LastModifiedDate FROM Sales_Contact_Metrics__c ' + 
                       ' WHERE LastModifiedDate >: prevScheduleDatetime Order By Contact__r.Id';
        
        return Database.getQueryLocator(strQuery);
   }
   
   /**
        @MethodName : execute
        @param1      : Database.BatchableContext batchableContext
        @param2      : List<sObject> scope
        @Description: This method is called after start and perform the activity on the records coming from start.
   */
   global void execute(Database.BatchableContext batchableContext, List<sObject> scope)  {
       
       try{
           //stores the ids associted to Sales_Account_Metrics__c or Sales_Contact_Metrics__c based on the objectName
           Set<Id> setSobjectIds = new Set<Id>();
           //stores the child object query string
           String strChildQuery = '';
           String LAST_YEAR = string.valueOf(system.now().year() - 1);
           //stores the account data retrieved from the parent SOQL 
           Map<Id, Account> mapAccount = new Map<Id, Account>(); 
           //stores the contact data retrieved from the parent SOQL 
           Map<Id, Contact> mapContact = new Map<Id, Contact>(); 
           
           //check if objectName is Sales_Account_Metrics__c then storing all the account ids associated to the Sales_Account_Metrics__c.
           if(objectName == 'Sales_Account_Metrics__c'){
                //storing the parent object ids
                for(Sales_Account_Metrics__c objAccountMetric : (List<Sales_Account_Metrics__c>)(Scope)) {
                    setSobjectIds.add(objAccountMetric.Account__c);
                	}
    
                //stores the account records needed for updating
                List<Account> lstAccounts = new List<Account>();
                
                //formatting the child object query string 
                strChildQuery = ' SELECT SUM(KAH_HP_Referrals__c) totalhpreferal, SUM(KAH_HP_Admits__c) totalhpadmits, SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmits, '
                              + ' SUM(KAH_HH_Referrals__c) totalhhreferal, SUM(KAH_HH_Admits__c) totalhhadmits, SUM(KAH_HH_Discounted_Qualified_Admits__c) totalhhqualadmits, SUM(KAH_HH_PPS_Admits__c) totalhhpy, Account__r.Id accId'
                              + ' FROM Sales_Account_Metrics__c WHERE Account__r.Id in :setSobjectIds'
                              + ' AND CALENDAR_YEAR(Month__c) = '+localdatetime.yearGMT() 
                              + ' group by Account__r.Id';
    			
                //formatting the child object query string 
                String strPYQuery = ' SELECT SUM(KAH_HP_Referrals__c) totalhpreferalpy, SUM(KAH_HP_Admits__c) totalhpadmitspy, SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmitspy, SUM(KAH_HP_Admits__c) totalhppy,'
                                          + ' SUM(KAH_HH_Referrals__c) totalhhreferalpy, SUM(KAH_HH_Admits__c) totalhhadmitspy, SUM(KAH_HH_Discounted_Qualified_Admits__c) totalhhqualadmitspy, SUM(KAH_HH_PPS_Admits__c) totalhhpy, Account__r.Id accIdpy'
                                          + ' FROM Sales_Account_Metrics__c WHERE Account__r.Id in :setSobjectIds'
                                          + ' AND CALENDAR_YEAR(Month__c) = ' + LAST_YEAR
                                          + ' group by Account__r.Id';
               
               list<AggregateResult> pyQuery = Database.Query(strPYQuery);
               system.debug('pyQuery size: ' + pyQuery.size());
                    if(pyQuery.size() > 0){
                    for(AggregateResult sobjPY : pyQuery){
                    for(AggregateResult sobjYTD : Database.Query(strChildQuery)){	
                        if(sobjPY.get('accIdpy') == sobjYTD.get('accId')){
                        	Account objAccount = new Account(Id = String.valueOf(sobjYTD.get('accId')),
                                                         HH_Admits_PY__c = Double.valueof(sobjPY.get('totalhhadmitspy')),
                                                         KAH_HH_Discounted_Qualified_Admits_PY__c = Double.valueof(sobjPY.get('totalhhqualadmitspy')),
                                                         HH_Referrals_PY__c = Double.valueof(sobjPY.get('totalhhreferalpy')),
                                                         KAH_HH_PPS_Prior_Year_Admits_Prior__c = Double.valueof(sobjPY.get('totalhhpy')),
                                                         KAH_HP_Qualified_Admits_PY__c = Double.valueof(sobjPY.get('totalhpqualadmitspy')),
                                                         HP_Admits_PY__c = Double.valueof(sobjPY.get('totalhpadmitspy')),
                                                         HP_Referrals_PY__c = Double.valueof(sobjPY.get('totalhpreferalpy')),
                                                         KAH_HH_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhadmits')),
                                                     	 KAH_HH_Discounted_Qualified_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhqualadmits')),
                                                     	 KAH_HH_Referrals_YTD__c = Double.valueof(sobjYTD.get('totalhhreferal')),
                                                         KAH_HH_PPS_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhpy')),
                                                         KAH_HP_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhpadmits')),
                                                         KAH_HP_Qualified_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhpqualadmits')),
                                                         KAH_HP_Referrals_YTD__c = Double.valueof(sobjYTD.get('totalhpreferal')));
                        	lstAccounts.add(objAccount);
                        	}
                        }
                    }
                    }
                   else{
                   		for(AggregateResult sobjYTD : Database.Query(strChildQuery)){	
                        		Account objAccount = new Account(Id = String.valueOf(sobjYTD.get('accId')),
                                		                         KAH_HH_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhadmits')),
                                            	         	 	 KAH_HH_Discounted_Qualified_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhqualadmits')),
                                                	     	 	 KAH_HH_Referrals_YTD__c = Double.valueof(sobjYTD.get('totalhhreferal')),
                                                    	     	 KAH_HH_PPS_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhpy')),
                                                        	 	 KAH_HP_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhpadmits')),
                                                        		 KAH_HP_Qualified_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhpqualadmits')),
                                                         		 KAH_HP_Referrals_YTD__c = Double.valueof(sobjYTD.get('totalhpreferal')));
                        	lstAccounts.add(objAccount);
                        }
                   	} 
                //updating the account records
                update lstAccounts;
           		}
           //check if objectName is Sales_Contact_Metrics__c then storing all the contact ids associated to the Sales_Contact_Metrics__c.
           else if(objectName == 'Sales_Contact_Metrics__c') {
            
                //storing the parent object ids
                for(Sales_Contact_Metrics__c objContactMetric : (List<Sales_Contact_Metrics__c>)(Scope))
                    setSobjectIds.add(objContactMetric.Contact__c);
             
                //formatting the child object query string 
                strChildQuery = ' SELECT SUM(KAH_HP_Referrals__c) totalhpreferal, SUM(KAH_HP_Admits__c) totalhpadmits, SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmits, '
                              + ' SUM(KAH_HH_Referrals__c) totalhhreferal, SUM(KAH_HH_Admits__c) totalhhadmits, SUM(KAH_HH_Discounted_Qualified_Admits__c) totalhhqualadmits, SUM(KAH_HH_PPS_Admits__c) totalhhpy, Contact__r.Id conId'
                              + ' FROM Sales_Contact_Metrics__c WHERE Contact__r.Id in :setSobjectIds'
                              + ' AND CALENDAR_YEAR(Month__c) = ' + localdatetime.yearGMT()
                              + ' group by Contact__r.Id';
                    
                //formatting the child object query string 
                String strPYQuery = ' SELECT SUM(KAH_HP_Referrals__c) totalhpreferalpy, SUM(KAH_HP_Admits__c) totalhpadmitspy, SUM(KAH_HP_Qualified_Admits__c) totalhpqualadmitspy, '
                              + ' SUM(KAH_HH_Referrals__c) totalhhreferalpy, SUM(KAH_HH_Admits__c) totalhhadmitspy, SUM(KAH_HH_Discounted_Qualified_Admits__c) totalhhqualadmitspy, SUM(KAH_HH_PPS_Admits__c) totalhhpy, Contact__r.Id conIdpy'
                              + ' FROM Sales_Contact_Metrics__c WHERE Contact__r.Id in :setSobjectIds'
                              + ' AND CALENDAR_YEAR(Month__c) = ' + LAST_YEAR
                              + ' group by Contact__r.Id';
                //stores the contact records needed for updating
                List<Contact> lstContacts = new List<Contact>();
                    
                    for(AggregateResult sobjPY : Database.Query(strPYQuery)){
                    for(AggregateResult sobjYTD : Database.Query(strChildQuery)){
                    	if(String.valueOf(sobjPY.get('conIdpy')) == String.valueOf(sobjYTD.get('conId'))){
                        Contact objContact = new Contact(Id = String.valueOf(sobjYTD.get('conId')),
                                                         HH_Admits_PY__c = Double.valueof(sobjPY.get('totalhhadmitspy')),
                                                         KAH_HH_Discounted_Qualified_Admits_PY__c = Double.valueof(sobjPY.get('totalhhqualadmitspy')),
                                                         HH_Referrals_PY__c = Double.valueof(sobjPY.get('totalhhreferalpy')),
                                                         KAH_HH_PPS_Prior_Year_Admits_Prior__c = Double.valueof(sobjPY.get('totalhhpy')),
                                                         HP_Admits_PY__c = Double.valueof(sobjPY.get('totalhpadmitspy')),
                                                         KAH_HP_Qualified_Admits_PY__c = Double.valueof(sobjPY.get('totalhpqualadmitspy')),
                                                         HP_Referrals_PY__c = Double.valueof(sobjPY.get('totalhpreferalpy')),
                                                         KAH_HH_Referrals_YTD__c = Double.valueof(sobjYTD.get('totalhhreferal')),
                                                		 KAH_HH_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhadmits')),
                                                		 KAH_HP_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhpadmits')),
                                                		 KAH_HH_PPS_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhpy')),
                                                		 KAH_HH_Discounted_Qualified_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhhqualadmits')),
                                                		 KAH_HP_Qualified_Admits_YTD__c = Double.valueof(sobjYTD.get('totalhpqualadmits')),
                                                		 KAH_HP_Referrals_YTD__c = Double.valueof(sobjYTD.get('totalhpreferal')));
                            lstContacts.add(objContact);
                    		}
                    	}
                    	}
                
                //updating the account records
                update lstContacts;
           }
       }
       catch(Exception Ex){
        
        system.debug('--------line----'+Ex.getLineNumber());
       }
   }
   
   /**
        @MethodName : finish
        @param      : Database.BatchableContext batchableContext
        @Description: This method is called at the last of batch execution.
   */
   global void finish(Database.BatchableContext batchableContext) {
       
        if(this.objectName == 'Sales_Account_Metrics__c')
            Database.executeBatch(new TBN_RollUpSummaryBatch('Sales_Contact_Metrics__c', schduledHour), 200);
   }
}