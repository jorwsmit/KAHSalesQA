@isTest
private class AA_HomeFacilityTriggerTest {

    static testMethod void myUnitTest() {
    	RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Referring_Facility_Child' Limit 1];
    	Account objAccount = new Account(name = 'Test AccountTest AccountTest Account', Status__c ='Active', shippingstate = 'FA', recordTypeId = rt.Id, Shipping_Geolocation__Longitude__s = 13.49,Shipping_Geolocation__Latitude__s = 84.66, KAH_HH_Referrals_YTD__c = 10);
       	  insert objAccount;
        Home_Facility__c objHomeFacility1 = new Home_Facility__c (User__c = UserInfo.getUserId(), Account__c = objAccount.Id);
          insert objHomeFacility1;
          
          objHomeFacility1.Historic_ID__c = null;
          update objHomeFacility1;
        }
}