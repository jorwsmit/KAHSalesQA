global class AA_MedparArchiverScheduler implements schedulable{
    
    global void execute(SchedulableContext sc){
    	AA_MedparArchiver.archiveItems();
    	}
    
}