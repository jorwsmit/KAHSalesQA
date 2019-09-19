global with sharing class SalesHD_LMS {

	private static Id currentUserId = UserInfo.getUserId();

	private static Map<String, String> fileIcons = new Map<String, String>{'PDF' => '<i class="fa fa-file-pdf-o resource-icon" aria-hidden="true"></i>',
	'CSV' => '<i class="fa fa-file-excel-o resource-icon" aria-hidden="true"></i>',
	'EXCEL' => '<i class="fa fa-file-excel-o resource-icon" aria-hidden="true"></i>',
	'EXCEL_M' => '<i class="fa fa-file-excel-o resource-icon" aria-hidden="true"></i>',
	'EXCEL_X' => '<i class="fa fa-file-excel-o resource-icon" aria-hidden="true"></i>',
	'JPG' => '<i class="fa fa-file-image-o resource-icon" aria-hidden="true"></i>',
	'JPEG' => '<i class="fa fa-file-image-o resource-icon" aria-hidden="true"></i>',
	'MOV' => '<i class="fa fa-file-video-o resource-icon" aria-hidden="true"></i>',
	'MP4' => '<i class="fa fa-file-video-o resource-icon" aria-hidden="true"></i>',
	'PNG' => '<i class="fa fa-file-image-o resource-icon" aria-hidden="true"></i>',
	'TIFF' => '<i class="fa fa-file-image-o resource-icon" aria-hidden="true"></i>',
	'POWER_POINT' => '<i class="fa fa-file-powerpoint-o resource-icon" aria-hidden="true"></i>',
	'POWER_POINT_X' => '<i class="fa fa-file-powerpoint-o resource-icon" aria-hidden="true"></i>',
	'WORD' => '<i class="fa fa-file-word-o resource-icon" aria-hidden="true"></i>',
	'WORD_X' => '<i class="fa fa-file-word-o resource-icon" aria-hidden="true"></i>',
	'UNKNOWN' => '<i class="fa fa-file-o resource-icon" aria-hidden="true"></i>'};

	public class course{
		public Id courseId;
		public String name;
		public List<assignment> assignments = new List<assignment>();
	}

	public class quiz{
		public Integer quizTime;
		public Boolean isTimed = false;
		public List<question> questions = new List<question>();
	}

	public class assignment{
		public Id assignmentId;
		public String name;
		public String type;
		public String dueDate;
		public String fileId;
		public String submittedDate;
		public String status;
		public course assignedCourse;
		public String embedUrl;
		public String answerJson;
		public boolean complete;
		public boolean overdue;
	}

	public class trainingDate{
		public Id trainingDateId;
		public Id fileId;
		public String name;
		public String colorClass;
		public String type;
		public boolean complete = false;
		public datetime trainingTime;
	}

	public class resource{
		public Id resourceId;
		public String name;
		public String type;
		public String icon;
		public String category;
	}

	public class dashboard {
		public Integer todo = 0;
		public Integer overdue = 0;
		public Integer complete = 0;
		public Decimal completionPercent = 0.0;
		public List<course> courses = new List<course>();
		public boolean canTakeFinal = false;
		public String finalId = '';
	}

	public class question {
		public String question;
		public String questionType;
		public List<String> answers = new List<String>();
	}

	@RemoteAction global static String loadDashboard(){
		dashboard db = new dashboard();

		List<Id> orderedCourses = new List<Id>();
		Map<Id, course> coursesMap = new Map<Id, course>();

		Boolean allAssignmentsComplete = true;
		for(SalesHD_LMS_Assigned__c a : [select Id, Due_Date__c, Complete__c, LMS_Assignment__c, LMS_Assignment__r.Name,
		LMS_Assignment__r.Type__c, LMS_Assignment__r.LMS_Course__c, LMS_Assignment__r.LMS_Course__r.Name, LMS_Assignment__r.Salesforce_File_ID__c from
		SalesHD_LMS_Assigned__c where User__c=:currentUserId order by Due_Date__c asc]){
			if(a.LMS_Assignment__r.Type__c != 'Final'){
				assignment newAssignment = new assignment();
				// newAssignment.assignmentId = a.LMS_Assignment__c;
				newAssignment.assignmentId = a.Id;
				newAssignment.fileId = a.LMS_Assignment__r.Salesforce_File_ID__c;
				newAssignment.name = a.LMS_Assignment__r.Name;
				newAssignment.dueDate = a.Due_Date__c.format();
				newAssignment.type = a.LMS_Assignment__r.Type__c;

				if(System.now()>=a.Due_Date__c && !a.Complete__c){
					db.overdue++;
					newAssignment.overdue = true;
					newAssignment.complete = false;
					allAssignmentsComplete = false;
				} else if(System.now()<a.Due_Date__c && !a.Complete__c){
					db.todo++;
					newAssignment.overdue = false;
					newAssignment.complete = false;
					allAssignmentsComplete = false;
				} else{
					db.complete++;
					newAssignment.overdue = false;
					newAssignment.complete = true;
				}

				course c = new course();
				if(!coursesMap.containsKey(a.LMS_Assignment__r.LMS_Course__c)){
					orderedCourses.add(a.LMS_Assignment__r.LMS_Course__c);
					c.Name = a.LMS_Assignment__r.LMS_Course__r.Name;
					c.assignments.add(newAssignment);
					coursesMap.put(a.LMS_Assignment__r.LMS_Course__c, c);
				} else{
					coursesMap.get(a.LMS_Assignment__r.LMS_Course__c).assignments.add(newAssignment);
				}
			} else {
				db.finalId = a.Id;
			}
		}

		for(Id c : orderedCourses){
			db.courses.add(coursesMap.remove(c));
		}

		Integer total = db.todo + db.overdue + db.complete;
		if(total!=0) db.completionPercent = ((Decimal.valueOf(db.complete) / Decimal.valueOf(total))*100.00).setScale(1);

		db.canTakeFinal = allAssignmentsComplete;
		return JSON.serializePretty(db);
	}

	@RemoteAction global static String getCalendar(Integer monthOffset){
		Datetime firstDay =  Datetime.newInstance(Date.valueOf(System.now()).addMonths(monthOffset).toStartOfMonth(), System.now().time());
		Integer numberOfDays = Date.daysInMonth(firstDay.year(), firstDay.month());
		String startDay = String.valueOf(firstDay.format('EEEE'));
		Date lowDate = Date.newInstance(firstDay.year(), firstDay.month(),1);
		Date highDate = Date.newInstance(firstDay.year(), firstDay.month(), Date.daysInMonth(firstDay.year(), firstDay.month()));
		Map<Integer, List<trainingDate>> traingingDates = new Map<Integer, List<trainingDate>>();
		for(SalesHD_Training_Date__c td : [select Id, Name, Training_Datetime__c from SalesHD_Training_Date__c where Training_Datetime__c>=:lowDate and Training_Datetime__c<=:highDate]){
			trainingDate temp = new trainingDate();
			temp.trainingDateId=td.Id;
			temp.name=td.Name;
			temp.type='Training Date';
			temp.trainingTime=td.Training_Datetime__c;
			if(traingingDates.containsKey(td.Training_Datetime__c.day())){
				traingingDates.get(td.Training_Datetime__c.day()).add(temp);
			} else{
				traingingDates.put(td.Training_Datetime__c.day(), new List<trainingDate>{temp});
			}
		}

		for(SalesHD_LMS_Assigned__c td : [select Id, Complete__c, LMS_Assignment__r.Type__c, LMS_Assignment__r.Name,
		LMS_Assignment__r.Salesforce_File_ID__c, Due_Date__c, Submitted_Datetime__c from SalesHD_LMS_Assigned__c where
		User__c=:currentUserId and ((Due_Date__c>=:lowDate and Due_Date__c<=:highDate and Submitted_Datetime__c=null) or
		(Submitted_Datetime__c>=:lowDate and Submitted_Datetime__c<=:highDate))]){
			trainingDate temp = new trainingDate();
			temp.trainingDateId=td.Id;
			if(td.Complete__c) temp.colorClass='complete';
			else if(td.Due_Date__c < System.now()) temp.colorClass='overdue';
			temp.name=td.LMS_Assignment__r.Name;
			if(td.LMS_Assignment__r.Salesforce_File_ID__c!=null) temp.fileId = td.LMS_Assignment__r.Salesforce_File_ID__c;
			temp.type=td.LMS_Assignment__r.Type__c;
			temp.complete=td.Complete__c;
			if(td.Submitted_Datetime__c!=null) temp.trainingTime=td.Submitted_Datetime__c;
			else if(td.Due_Date__c!=null) temp.trainingTime=td.Due_Date__c;

			if(traingingDates.containsKey(temp.trainingTime.day())){
				traingingDates.get(temp.trainingTime.day()).add(temp);
			} else{
				traingingDates.put(temp.trainingTime.day(), new List<trainingDate>{temp});
			}
		}

		return '{"startDay": "'+startDay+'", "numberOfDays": '+numberOfDays+', "traingingDates":'+JSON.serialize(traingingDates)+'}';
		// return '{"startDay": "'+startDay+'", "numberOfDays": '+numberOfDays+', "traingingDates":'+JSON.serialize(traingingDates2)+'}';
	}

	@RemoteAction global static String getQuestions(String assignmentId){
		// List<question> questions = new List<question>();
		quiz returnQuiz = new quiz();
		for(SalesHD_Assignment__c a : [select Type__c, Is_Timed__c, Number_of_Seconds__c from SalesHD_Assignment__c where Id in (select LMS_Assignment__c from SalesHD_LMS_Assigned__c where Id =: assignmentId and User__c=:currentUserId)]){
			if(a.Is_Timed__c){
				returnQuiz.isTimed = true;
				returnQuiz.quizTime = Integer.valueOf(a.Number_of_Seconds__c);
			}
		}
		for(SalesHD_LMS_Quiz_Question__c q : [select Question__c, Answers__c, Question_Type__c from SalesHD_LMS_Quiz_Question__c where Assignment__c in
		(select LMS_Assignment__c from SalesHD_LMS_Assigned__c where Id =: assignmentId) order by Question_Number__c asc]){
			question temp = new question();
			temp.question = q.Question__c;
			temp.questionType = q.Question_Type__c;
			if(q.Answers__c!=null) temp.answers = q.Answers__c.split('\n');
			returnQuiz.questions.add(temp);
		}
		return JSON.serializePretty(returnQuiz);
	}

	@RemoteAction global static String submitQuiz(String assignmentId, String jsonInput){
		Map<String, Object> answers = (Map<String, Object>)JSON.deserializeUntyped(jsonInput);
		String answersJson = '{';
		Decimal totalNumberQuestions = 0.00;
		Decimal totalCorrect = 0.00;
		Decimal percent = 0.00;
		for(SalesHD_LMS_Quiz_Question__c q : [select Question__c, Question_Number__c, Correct_Answer__c from SalesHD_LMS_Quiz_Question__c
		where Assignment__c in (select LMS_Assignment__c from SalesHD_LMS_Assigned__c where Id =: assignmentId and User__c=:currentUserId)
		order by Question_Number__c asc]){
			totalNumberQuestions++;
			String correctAnswer = q.Correct_Answer__c.replaceAll('([\\s,-.$])', '');
			String userGuess = String.valueOf(answers.get(String.valueOf(q.Question_Number__c))).replaceAll('([\\s,-.$])', '');
			if(correctAnswer == userGuess){
				totalCorrect++;
				answersJson += '"'+q.Question_Number__c+'" : {"correct" : true, "question" : "'+q.Question__c+
				'", "answer" : "'+q.Correct_Answer__c+'", "userGuess" : "'+answers.get(String.valueOf(q.Question_Number__c))+'"}, ';
			} else {
				answersJson += '"'+q.Question_Number__c+'" : {"correct" : false, "question" : "'+q.Question__c+
				'", "answer" : "'+q.Correct_Answer__c+'", "userGuess" : "'+answers.get(String.valueOf(q.Question_Number__c))+'"}, ';
			}
		}

		percent = ((totalCorrect/totalNumberQuestions)*100).setScale(2);

		answersJson = answersJson.substring(0, answersJson.length()-2);
		answersJson += '}';

		List<SalesHD_LMS_Assigned__c> assigned = [select Started_Datetime__c, Submitted_Datetime__c, Complete__c,
		Submitted_Answers_JSON__c, LMS_Assignment__r.Is_Timed__c, LMS_Assignment__r.Number_of_Seconds__c, Grade__c
		from SalesHD_LMS_Assigned__c where Id=:assignmentId and User__c=:currentUserId];
		for(SalesHD_LMS_Assigned__c a : assigned){
			Boolean canSave = true;
			if(!a.Complete__c){
				if(a.LMS_Assignment__r.Is_Timed__c && a.LMS_Assignment__r.Number_of_Seconds__c!=null){
					Long submittedTime = System.now().getTime();
					Long startedTime = a.Started_Datetime__c.getTime();
					Long quizTime =  (submittedTime - startedTime) / 1000;
					if(quizTime >= a.LMS_Assignment__r.Number_of_Seconds__c+30){
						canSave = false;
					}
				}
				if(canSave){
					a.Submitted_Datetime__c = System.now();
					a.Complete__c = true;
					a.Submitted_Answers_JSON__c = answersJson;
					a.Grade__c = percent;
				}
			}
		}
		if(!assigned.isEmpty()) update assigned;


		return answersJson;
	}

	@RemoteAction global static String submitVideo(String assignmentId){
		String payload;
		List<SalesHD_LMS_Assigned__c> assigned = [select Started_Datetime__c, Submitted_Datetime__c,
		Complete__c, LMS_Assignment__r.Is_Timed__c, LMS_Assignment__r.Number_of_Seconds__c, Grade__c from
		SalesHD_LMS_Assigned__c where Id=:assignmentId and User__c=:currentUserId];
		for(SalesHD_LMS_Assigned__c a : assigned){
			if(!a.Complete__c){
				// a.Submitted_Datetime__c = System.now();
				if(a.LMS_Assignment__r.Is_Timed__c && a.LMS_Assignment__r.Number_of_Seconds__c!=null){
					Long submittedTime = System.now().getTime();
					Long startedTime = a.Started_Datetime__c.getTime();
					Long watchTime =  (submittedTime - startedTime) / 1000;
					if(watchTime >= a.LMS_Assignment__r.Number_of_Seconds__c){
						a.Complete__c = true;
						a.Grade__c = 100.00;
						a.Submitted_Datetime__c = System.now();
						payload = '{"complete" : true}';
					} else{
						a.Complete__c = false;
						payload = '{"complete" : false, "message" : "You must watch the video in its entirety before submitting."}';
					}
				} else {
					a.Complete__c = true;
					a.Grade__c = 100.00;
					a.Submitted_Datetime__c = System.now();
					payload = '{"complete" : true}';
				}
			}
		}
		if(!assigned.isEmpty()) update assigned;
		return payload;
	}

	@RemoteAction global static String getResources(){
		Id workspaceId;
		for(ContentWorkspace cw : [select Id from ContentWorkspace where Name = 'Sales Resource Library']){
			// for(ContentWorkspace cw : [select Id from ContentWorkspace where Name = 'Sales Training Documents']){
			workspaceId = cw.Id;
		}

		return resourceJSON(workspaceId);
	}

	@RemoteAction global static String getHomework(){
		Id workspaceId;
		for(ContentWorkspace cw : [select Id from ContentWorkspace where Name = 'Sales LMS Homework']){
			// for(ContentWorkspace cw : [select Id from ContentWorkspace where Name = 'Sales Training Documents']){
			workspaceId = cw.Id;
		}

		return resourceJSON(workspaceId);
	}

	private static String resourceJSON(Id workspaceId){
		List<resource> resources = new List<resource>();

		for(ContentVersion cv : [select Title, Id, Description, FileType, SalesHD_Sales_Training_Categories__c from ContentVersion where IsLatest=true and ContentDocument.ParentId=:workspaceId]){
			resource r = new resource();
			r.name = cv.Title;
			r.icon = fileIcons.get(cv.FileType);
			r.type = cv.FileType;
			if(cv.SalesHD_Sales_Training_Categories__c!=null) r.category = cv.SalesHD_Sales_Training_Categories__c;
			r.resourceId = cv.Id;
			resources.add(r);
		}

		return JSON.serializePretty(resources);
	}



	@RemoteAction global static String startAssignment(String assignmentId){
		String payload = '{"timed" : false}';
		List<SalesHD_LMS_Assigned__c> assigned = [select Started_Datetime__c, LMS_Assignment__r.Is_Timed__c, LMS_Assignment__r.Number_of_Seconds__c from SalesHD_LMS_Assigned__c where Id=:assignmentId and User__c=:currentUserId];
		for(SalesHD_LMS_Assigned__c a : assigned){
			a.Started_Datetime__c = System.now();
		}
		if(!assigned.isEmpty()){
			update assigned;
			if(assigned[0].LMS_Assignment__r.Is_Timed__c && assigned[0].LMS_Assignment__r.Number_of_Seconds__c!=null){
				payload = '{"timed" : true, "seconds" : '+assigned[0].LMS_Assignment__r.Number_of_Seconds__c+'}';
			}
		}
		return payload;
	}

	@RemoteAction global static String checkCompleted(String assignmentId){
		assignment assigned = new assignment();
		for(SalesHD_LMS_Assigned__c a : [select Complete__c, Submitted_Answers_JSON__c, Submitted_Datetime__c, LMS_Assignment__c,
		LMS_Assignment__r.Video_URL__c, LMS_Assignment__r.Name, LMS_Assignment__r.Type__c from SalesHD_LMS_Assigned__c where Id =: assignmentId and  User__c=:currentUserId]){
			if(a.Complete__c!=null) assigned.complete = a.Complete__c;
			if(a.Submitted_Datetime__c!=null) assigned.submittedDate = a.Submitted_Datetime__c.format();
			if(a.Submitted_Answers_JSON__c!=null) assigned.answerJson = a.Submitted_Answers_JSON__c;
			if(a.LMS_Assignment__r.Video_URL__c!=null) assigned.embedUrl = a.LMS_Assignment__r.Video_URL__c;
			if(a.LMS_Assignment__r.Name!=null) assigned.name = a.LMS_Assignment__r.Name;
			if(a.LMS_Assignment__r.Type__c!=null) assigned.type = a.LMS_Assignment__r.Type__c;
		}
		return JSON.serializePretty(assigned);
	}

	@RemoteAction global static String submitFileOpen(String assignmentId){
		String payload = '';
		List<SalesHD_LMS_Assigned__c> assigned = [select Started_Datetime__c, Submitted_Datetime__c, Complete__c from SalesHD_LMS_Assigned__c where Id=:assignmentId and User__c=:currentUserId and LMS_Assignment__r.Type__c='Document'];
		for(SalesHD_LMS_Assigned__c a : assigned){
			if(a.Started_Datetime__c==null) a.Started_Datetime__c = System.now();
			if(a.Submitted_Datetime__c==null) a.Submitted_Datetime__c = System.now();
			if(!a.Complete__c) a.Complete__c = true;
		}
		if(!assigned.isEmpty()){
			update assigned;
		}
		return payload;
	}

}