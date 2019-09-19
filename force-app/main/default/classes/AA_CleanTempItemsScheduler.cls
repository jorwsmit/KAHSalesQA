global class AA_CleanTempItemsScheduler implements schedulable{
    
     global void execute(SchedulableContext sc){
        AA_CleanTempItems.cleanItems();
        }
    
}