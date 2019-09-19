// AccountDashboardExt is remoted into by AccountDashboard_2
// it returns the related data

global class ContactDashboardExt {

    @RemoteAction global static Sales_Contact_Metrics__c[] loadOpps(Id contId) {
        return [select Contact__c, KAH_HH_Referrals__c, KAH_HH_PPS_Admits__c, KAH_HP_Referrals__c, KAH_HP_Qualified_Admits__c, Month__c from Sales_Contact_Metrics__c where Contact__c = :contId and Month__c = LAST_N_DAYS:180 order by Month__c asc];
    }

    @RemoteAction global static Contact[] queryHms(Id contId) {
        return [select id, KAH_HMS_ALL_HH_DR__c, KAH_HMS_ALL_HH_MIN__c, KAH_HMS_ALL_HH_MAX__c, KAH_HMS_HH_Cancer_Bold_Vascular_DR__c, KAH_HMS_HH_CHF_Stroke_COPD_DR__c, KAH_HMS_HH_Endo_Wounds_DR__c, KAH_HMS_HH_Ortho_DR__c, KAH_HMS_HH_Urinary_Kidney_GI_DR__c, KAH_HMS_ALL_HP_DR__c, KAH_HMS_ALL_HP_MIN__c, KAH_HMS_ALL_HP_MAX__c, KAH_HMS_HP_Cancer_DR__c, KAH_HMS_HP_CHF_DR__c, KAH_HMS_HP_COPD_DR__c, KAH_HMS_HP_Debility_DR__c, KAH_HMS_HP_Dementia_DR__c, KAH_HMS_HP_Influencer_Network_DR__c from Contact where id = :contId];
    }

    @RemoteAction global static Contact[] queryAdmits(Id contId) {
        //return [select id, KAH_HMS_ALL_HH_DR__c, KAH_HMS_ALL_HH_MIN__c, KAH_HMS_ALL_HH_MAX__c, KAH_HMS_HH_Cancer_Bold_Vascular_DR__c, KAH_HMS_HH_CHF_Stroke_COPD_DR__c, KAH_HMS_HH_Endo_Wounds_DR__c, KAH_HMS_HH_Ortho_DR__c, KAH_HMS_HH_Urinary_Kidney_GI_DR__c, KAH_HMS_ALL_HP_DR__c, KAH_HMS_ALL_HP_MIN__c, KAH_HMS_ALL_HP_MAX__c, KAH_HMS_HP_Cancer_DR__c, KAH_HMS_HP_CHF_DR__c, KAH_HMS_HP_COPD_DR__c, KAH_HMS_HP_Debility_DR__c, KAH_HMS_HP_Dementia_DR__c, KAH_HMS_HP_Influencer_Network_DR__c from Account where id = :acctId];
        return [select id, KAH_HH_PPS_Admits_YTD__c, KAH_HP_Qualified_Admits_YTD__c, KAH_HH_PPS_Prior_Year_Admits_Prior__c, KAH_HP_Qualified_Admits_PY__c from Contact where id = :contId];
    }

    @RemoteAction global static Contact_Team__c[] queryContactTeam(Id contId) {
        return [select Contact__c, User__r.Id, User__r.Name, User__r.FullPhotoUrl, User__r.Title, User__r.Line_of_Business__c, CreatedDate from Contact_Team__c where Contact__c = :contId];
    }

    @RemoteAction global static Event[] queryLastActivty(Id usrId, Id contId) {
        return [select WhoId, ActivityDate, OwnerId from Event where isRecurrence = false and WhoId = :contId and OwnerId = :usrId order by ActivityDate limit 1];
    }

    @RemoteAction global static Contact[] queryBirthdays(Id contId) {
        return [select id, Name, Phone, Birthdate, Title__c from Contact where id = :contId];
    }


    @RemoteAction global static event[] queryEvents(Id contId) {
        //return [select WhoId, ActivityDate, Owner.Name from event where WhoId = :contId and ActivityDate = LAST_N_DAYS:30 order by ActivityDate];
        return [select WhoId, ActivityDate, Owner.Name from event where isRecurrence = false and WhoId = :contId and (ActivityDate = THIS_MONTH and ActivityDate <= TODAY) order by ActivityDate];
    }

    @RemoteAction global static event[] queryEvent180(Id contId) {
        return [select WhoId, ActivityDate, Owner.Name from event where isRecurrence = false and  WhoId = :contId and (ActivityDate = LAST_N_MONTHS:7 or ActivityDate = THIS_MONTH) order by ActivityDate];
    }

    @RemoteAction global static event[] queryTouchpoints(Id contId) {
        return [select WhoId, ActivityDate, Owner.Name, Who.Name, Complete__c from event where isRecurrence = false and ActivityDate <= TODAY and WhoId = :contId order by ActivityDate desc limit 5];
    }

}