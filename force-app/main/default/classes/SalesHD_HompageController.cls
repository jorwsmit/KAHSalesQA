public with sharing class SalesHD_HompageController {
	@RemoteAction public static List<String> getCorporateMessages(){
		List<String> messages = new List<String>();
		messages.add('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
		messages.add('Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');
		messages.add('Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
		return messages;
	}

	@RemoteAction public static String getCalendar(Integer monthOffset){
		Datetime firstDay =  Datetime.newInstance(Date.valueOf(System.now()).addMonths(monthOffset).toStartOfMonth(), System.now().time());
		Integer numberOfDays = Date.daysInMonth(firstDay.year(), firstDay.month());
		String startDay = String.valueOf(firstDay.format('EEEE'));
		Date lowDate = Date.newInstance(firstDay.year(), firstDay.month(),1);
		Date highDate = Date.newInstance(firstDay.year(), firstDay.month(), Date.daysInMonth(firstDay.year(), firstDay.month()));
		Map<Integer, List<Event>> events = new Map<Integer, List<Event>>();
		for(Event e : [select id, subject, startDateTime, complete__c, description, who.name from event where ownerId=:UserInfo.getUserId() and startDateTime>=:lowDate and endDateTime<=:highDate]){
			if(events.containsKey(e.startDateTime.day())){
				events.get(e.startDateTime.day()).add(e);
			} else{
				events.put(e.startDateTime.day(), new List<event>{e});
			}
		}

		// return '{"startDay": "'+startDay+'", "numberOfDays": '+numberOfDays+', "events":{"1":[{"subject":"cats", "time": "1:00PM", "complete": false},{"subject":"cats2", "time": "2:00PM", "complete": false},{"subject":"cats3", "time": "3:00PM", "complete": false},{"subject":"cats with a long title here", "time": "10:00PM", "complete": false},{"subject":"cats with a long title here", "time": "10:00PM", "complete": false}], "12":[{"subject":"dogs", "time": "2:30PM", "complete": true}], "20":[{"subject":"turtle", "time": "5:00PM", "complete": true}]}}';

		return '{"startDay": "'+startDay+'", "numberOfDays": '+numberOfDays+', "events":'+JSON.serialize(events)+'}';
	}

}