global class AA_YearEndMetricRollupScheduler implements schedulable{
    
	global void execute(schedulableContext SC){
		AA_YearEndMetricRollup obj = new AA_YearEndMetricRollup('Sales_Account_Metrics__c');
		database.executeBatch(obj);
		AA_YearEndMetricRollup obj2 = new AA_YearEndMetricRollup('Sales_Contact_Metrics__c');
		database.executeBatch(obj2);
		}

}