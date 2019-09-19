global class AA_TranscriptCleanerScheduler implements schedulable{
    
    global void execute(SchedulableContext sc){  
        	AA_TranscriptCleaner.getList();
    		}
    
}