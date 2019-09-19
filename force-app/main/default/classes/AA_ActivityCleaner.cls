public class AA_ActivityCleaner{
	
	public static list<RecordType> pfIDs = [SELECT ID FROM RecordType WHERE (sObjectType = 'Task' OR sObjectType = 'Event') AND (developerName = 'Partner_First_Task' OR developerName = 'Partner_First')];
	
	public static void cleanActivities(){
		list<ID> exclusions = new list<ID>();
		for(RecordType rt : pfIDs){
			exclusions.add(rt.ID);
			}
		
		list<Event> events = new list <Event>();
		list<Task> tasks = new list<Task>();
		
		events = [SELECT ID FROM Event WHERE RecordTypeID NOT IN: exclusions AND ActivityDate < LAST_N_MONTHS:24 LIMIT 10000];
		tasks = [SELECT ID FROM Task WHERE RecordTypeID NOT IN: exclusions AND ActivityDate < LAST_N_MONTHS:24 LIMIT 10000];
		
		system.debug('Events: ' + events + ' size: ' + events.size());
		system.debug('Tasks: ' + tasks + ' size: ' + tasks.size());
		delete events;
		delete tasks;
		}
    
}