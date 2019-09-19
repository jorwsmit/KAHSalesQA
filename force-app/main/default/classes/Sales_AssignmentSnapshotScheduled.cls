global class Sales_AssignmentSnapshotScheduled implements Schedulable {
	private static final Id kahSalesAssociate = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
	private static final Id kahMarketManager = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Market Manager'].ID;
	global string query = 'select id from user where user.isActive=true and (user.profileId=\''+kahSalesAssociate+'\' or user.profileId=\''+kahMarketManager+'\')';
    global void execute(SchedulableContext sc) {
        Sales_AssignmentSnapshot batch = new Sales_AssignmentSnapshot();
        batch.query = query;
        Database.executeBatch(batch, 1);
    }
}