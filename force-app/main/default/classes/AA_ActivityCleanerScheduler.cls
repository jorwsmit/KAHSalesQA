global class AA_ActivityCleanerScheduler implements schedulable{
    
    global void execute(SchedulableContext sc){
        AA_ActivityCleaner.cleanActivities();
        }
    
}