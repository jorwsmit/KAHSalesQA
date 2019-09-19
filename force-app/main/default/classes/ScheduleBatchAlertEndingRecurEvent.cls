global class ScheduleBatchAlertEndingRecurEvent implements Schedulable {
    
    final string Sales_KAH_Associate = '00e1300000225C9';
    final string Sales_KAH_MANAGER = '00e1300000225CA';
    final string Sales_KAH_MARKET_MANAGER = '00e130000024QC8';
    global String query = 'select Id, OwnerId, Owner.Email from event where (Owner.Profile.ID = ' + Sales_KAH_MANAGER + ' or Owner.Profile.ID =' + Sales_KAH_Associate + ' or Owner.Profile.ID = ' + Sales_KAH_MARKET_MANAGER + ')and IsRecurrence = TRUE and RecurrenceEndDateOnly = NEXT_N_DAYS:7';
    global void execute(SchedulableContext sc) {
        BatchAlertEndingRecurringEvent sendAlerts = new BatchAlertEndingRecurringEvent();
        sendAlerts.query = query;
        Database.executeBatch(sendAlerts, 200);
    }
}