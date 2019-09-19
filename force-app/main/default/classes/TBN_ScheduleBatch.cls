global class TBN_ScheduleBatch implements Schedulable {
    
    /** stores the child object name whose fields value are summarised to the parent object */
    private String objectName {get;set;}
    private Integer scheduledHour   {get;set;}
    
    public TBN_ScheduleBatch() {
        //default constructor
    }
    
    /**
        @MethodName : TBN_ScheduleBatch
        @param      : String ObjectName
        @Description: This method is called first time during batch execution, in this method we are retrieving records and passes it to execute method for further processing.
    */
    public TBN_ScheduleBatch(String objectName, Integer scheduledHour) {
        
        this.objectName = objectName;
        this.scheduledHour = scheduledHour;
    }
    
    /**
        @MethodName : scheduleBatchDaily
        @param      : String ObjectName
        @Description: This method is used to schedule the batch daily at parameter passed
    */
    public static void scheduleBatchDaily(String ObjectName, Integer scheduledHour) {
        
        String CRON_EXP = '0 0 ' +scheduledHour+ ' * * ?';
        System.schedule('SummariseAccountMtricDetailTo'+ObjectName, CRON_EXP, new TBN_ScheduleBatch(ObjectName, scheduledHour));
    }
    
    /**
        @MethodName : execute
        @param      : SchedulableContext SC
        @Description: This method is calling batch to perform the roll up summary functionality regarding contact nad account metrics
    */
    public void execute(SchedulableContext SC) {
        
        Database.executeBatch(new TBN_RollUpSummaryBatch(objectName, scheduledHour), 200); 
    }
}