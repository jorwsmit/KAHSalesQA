global class Sales_LaunchpadNCDController {
  @RemoteAction global static String getSPdata(){
    Sales_Performance__c sp;
    if([select Sales_Calls__c, Targeted_Admissions__c, Actual_Admissions__c, Targeted_Revenue__c, Actual_Revenue__c from Sales_Performance__c where Month__c=this_month and ownerId=:UserInfo.getUserId()].size()==1)
      sp = [select Sales_Calls__c, Targeted_Admissions__c, Actual_Admissions__c, Targeted_Revenue__c, Actual_Revenue__c from Sales_Performance__c where Month__c=this_month and ownerId=:UserInfo.getUserId()];
    if(sp!=null) return '{"callNum" : '+sp.Sales_Calls__c+', "admitTar" : '+sp.Targeted_Admissions__c+', "admitAct" : '+sp.Actual_Admissions__c+', "revTar" : '+sp.Targeted_Revenue__c+', "revAct" : '+sp.Actual_Revenue__c+'}';
    else return null;
  }
}