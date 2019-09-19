global class SALES_Follow_Up {
   @RemoteAction global static String insertEvent(Id eventId) {
      Event e = [select Id, Description, WhoId, WhatId, OwnerId, ActivityDateTime, DurationInMinutes, endDateTime, RecordTypeId, Type from Event where Id = :eventId];
      Event insertEvent = new Event(Description = e.Description, WhoId = e.WhoId, WhatId = e.WhatId, OwnerId = e.OwnerId, Type = e.Type, 
                                  ActivityDateTime = e.ActivityDateTime, DurationInMinutes = e.DurationInMinutes, endDateTime = e.endDateTime, RecordTypeId = e.RecordTypeId);
      insert insertEvent;
      return insertEvent.Id;
   }
}//end SALES_Follow_Up