global class ScheduleBatchSP4NextYear implements Schedulable {

    private static final Id marketoLiaisonProfileId = '00ea0000001servAAA';
    private static final Id ncdClProfileId = '00e1300000225LuAAI';
    private static final Id kahSalesAssociateProfileId = '00e1300000225C9AAI';

    global String query = 'select Id from user where ProfileId = \''+kahSalesAssociateProfileId+'\' or ProfileId = \''+marketoLiaisonProfileId+'\' or ProfileId = \''+ncdClProfileId+'\'';
    global void execute(SchedulableContext sc) {
        BatchCreate12SalesPerf4NextYear insertSPs = new BatchCreate12SalesPerf4NextYear();
        insertSPs.query = query;
        Database.executeBatch(insertSPs, 150);
    }
}