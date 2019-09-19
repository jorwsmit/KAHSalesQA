// AccountDashboardExt is remoted into by AccountDashboard_2
// it returns the related data

global class AccountDashboardExt {

    @RemoteAction global static Sales_Account_Metrics__c[] loadOpps(Id acctId) {
        return [select Account__c, KAH_HH_Referrals__c, KAH_HH_PPS_Admits__c, KAH_HP_Referrals__c, KAH_HP_Qualified_Admits__c, Month__c from Sales_Account_Metrics__c where Account__c = :acctId and Month__c = LAST_N_DAYS:180 order by Month__c asc];
    }

    @RemoteAction global static Account[] queryHms(Id acctId) {
        return [select id, KAH_HMS_ALL_HH_DR__c, KAH_HMS_ALL_HH_MIN__c, KAH_HMS_ALL_HH_MAX__c, KAH_HMS_HH_Cancer_Bold_Vascular_DR__c, KAH_HMS_HH_CHF_Stroke_COPD_DR__c, KAH_HMS_HH_Endo_Wounds_DR__c, KAH_HMS_HH_Ortho_DR__c, KAH_HMS_HH_Urinary_Kidney_GI_DR__c, KAH_HMS_ALL_HP_DR__c, KAH_HMS_ALL_HP_MIN__c, KAH_HMS_ALL_HP_MAX__c, KAH_HMS_HP_Cancer_DR__c, KAH_HMS_HP_CHF_DR__c, KAH_HMS_HP_COPD_DR__c, KAH_HMS_HP_Debility_DR__c, KAH_HMS_HP_Dementia_DR__c, KAH_HMS_HP_Influencer_Network_DR__c from Account where id = :acctId];
    }

    @RemoteAction global static Account[] queryAdmits(Id acctId) {
        //return [select id, KAH_HMS_ALL_HH_DR__c, KAH_HMS_ALL_HH_MIN__c, KAH_HMS_ALL_HH_MAX__c, KAH_HMS_HH_Cancer_Bold_Vascular_DR__c, KAH_HMS_HH_CHF_Stroke_COPD_DR__c, KAH_HMS_HH_Endo_Wounds_DR__c, KAH_HMS_HH_Ortho_DR__c, KAH_HMS_HH_Urinary_Kidney_GI_DR__c, KAH_HMS_ALL_HP_DR__c, KAH_HMS_ALL_HP_MIN__c, KAH_HMS_ALL_HP_MAX__c, KAH_HMS_HP_Cancer_DR__c, KAH_HMS_HP_CHF_DR__c, KAH_HMS_HP_COPD_DR__c, KAH_HMS_HP_Debility_DR__c, KAH_HMS_HP_Dementia_DR__c, KAH_HMS_HP_Influencer_Network_DR__c from Account where id = :acctId];
        return [select id, KAH_HH_PPS_Admits_YTD__c, KAH_HP_Qualified_Admits_YTD__c, KAH_HH_PPS_Prior_Year_Admits_Prior__c, KAH_HP_Qualified_Admits_PY__c from Account where id = :acctId];
    }

    @RemoteAction global static AccountTeamMember[] queryAccountTeam(Id acctId) {
        return [select AccountId, User.Id, User.Name, User.FullPhotoUrl, User.Title, User.Line_of_Business__c, CreatedDate from AccountTeamMember where AccountId = :acctId];
    }

    @RemoteAction global static Event[] queryLastActivty(Id usrId, Id acctId) {
        return [select AccountId, ActivityDate, OwnerId from Event where isRecurrence = false and AccountId = :acctId and OwnerId = :usrId order by ActivityDate limit 1];
    }

    @RemoteAction global static Contact[] queryBirthdays(Id acctId) {
        return [select id, AccountId, Name, Phone, Birthdate, Title__c from Contact where AccountId = :acctId and (Birthdate = LAST_N_DAYS:7 or Birthdate = TODAY or Birthdate = NEXT_N_DAYS:30) order by Birthdate];
    }


    @RemoteAction global static event[] queryEvents(Id acctId) {
        //return [select AccountId, ActivityDate, Owner.Name, WhoId from event where AccountId = :acctId and ActivityDate = LAST_N_DAYS:30 order by ActivityDate];
        return [select AccountId, ActivityDate, Owner.Name, WhoId from event where isRecurrence = false and AccountId = :acctId and (ActivityDate = THIS_MONTH and ActivityDate <= TODAY) order by ActivityDate];
    }

    @RemoteAction global static event[] queryEvent180(Id acctId) {
        return [select Id, AccountId, ActivityDate, Owner.Name from event where isRecurrence = false and AccountId = :acctId and (ActivityDate = LAST_N_MONTHS:7 or ActivityDate = THIS_MONTH) order by ActivityDate];
    }

    @RemoteAction global static event[] queryTouchpoints(Id acctId) {
        return [select AccountId, ActivityDate, Owner.Name, WhoId, Who.Name, Complete__c from event where isRecurrence = false and ActivityDate <= TODAY and AccountId = :acctId order by ActivityDate desc limit 5];
    }

}