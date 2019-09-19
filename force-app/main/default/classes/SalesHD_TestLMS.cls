@isTest
private class SalesHD_TestLMS {

	@testSetup static void setup(){
		User usr = new User(Alias = 'test', Email='hdsalestest@kndcrm.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = '00ea0000001serv',
		TimeZoneSidKey='America/Los_Angeles', UserName='hdsalestest@kndcrm.com');

		insert usr;

		// Id, Due_Date__c, Complete__c, LMS_Assignment__c, LMS_Assignment__r.Name,
		// LMS_Assignment__r.Type__c, LMS_Assignment__r.LMS_Course__c, LMS_Assignment__r.LMS_Course__r.Name, LMS_Assignment__r.Salesforce_File_ID__c from
		// SalesHD_LMS_Assigned__c

		SalesHD_LMS_Course__c course = new SalesHD_LMS_Course__c(Name='Test Course');
		insert course;

		List<SalesHD_Assignment__c> assignmentList = new List<SalesHD_Assignment__c>();
		SalesHD_Assignment__c assignment = new SalesHD_Assignment__c(Name='Test Video Assignment', Type__c='Video', LMS_Course__c=course.Id,
		Is_Timed__c=True, Number_of_Seconds__c=10);
		assignmentList.add(assignment);
		assignment = new SalesHD_Assignment__c(Name='Test Quiz Assignment', Type__c='Quiz', LMS_Course__c=course.Id);
		assignmentList.add(assignment);
		assignment = new SalesHD_Assignment__c(Name='Test Timed Quiz Assignment', Type__c='Quiz', LMS_Course__c=course.Id, Is_Timed__c=True, Number_of_Seconds__c=10);
		assignmentList.add(assignment);
		assignment = new SalesHD_Assignment__c(Name='Test Video Assignment Complete', Type__c='Video', LMS_Course__c=course.Id,
		Is_Timed__c=True, Number_of_Seconds__c=10);
		assignmentList.add(assignment);
		assignment = new SalesHD_Assignment__c(Name='Test Document Assignment', Type__c='Document', LMS_Course__c=course.Id);
		assignmentList.add(assignment);
		assignment = new SalesHD_Assignment__c(Name='Test Video Assignment Not Timed', Type__c='Video', LMS_Course__c=course.Id);
		assignmentList.add(assignment);
		insert assignmentList;

		// select Question__c, Answers__c, Question_Type__c from SalesHD_LMS_Quiz_Question__c where Assignment__c
		List<SalesHD_LMS_Quiz_Question__c> questionList = new List<SalesHD_LMS_Quiz_Question__c>();
		SalesHD_LMS_Quiz_Question__c question = new SalesHD_LMS_Quiz_Question__c(Question__c='Test Question', Correct_Answer__c='Test Answer 1',
		Answers__c='Test Answer 1\nTest Answer 2', Question_Type__c='Multiple Choice', Assignment__c=assignmentList[1].Id, Question_Number__c=1);
		questionList.add(question);
		question = new SalesHD_LMS_Quiz_Question__c(Question__c='Test Question', Correct_Answer__c='Test Answer 1',
		Answers__c='Test Answer 1\nTest Answer 2', Question_Type__c='Multiple Choice', Assignment__c=assignmentList[2].Id, Question_Number__c=1);
		questionList.add(question);
		insert questionList;

		List<SalesHD_LMS_Assigned__c> assignedList = new List<SalesHD_LMS_Assigned__c>();
		SalesHD_LMS_Assigned__c assigned = new SalesHD_LMS_Assigned__c(Due_Date__c=System.now().addDays(-1),
		LMS_Assignment__c=assignmentList[0].Id, User__c=usr.Id, Started_Datetime__c=System.now().addDays(-1));
		assignedList.add(assigned);
		assigned = new SalesHD_LMS_Assigned__c(Due_Date__c=System.now().addDays(1), LMS_Assignment__c=assignmentList[1].Id, User__c=usr.Id);
		assignedList.add(assigned);
		assigned = new SalesHD_LMS_Assigned__c(Due_Date__c=System.now(), LMS_Assignment__c=assignmentList[2].Id, User__c=usr.Id);
		assignedList.add(assigned);
		assigned = new SalesHD_LMS_Assigned__c(Due_Date__c=System.now().addDays(-1),
		LMS_Assignment__c=assignmentList[3].Id, User__c=usr.Id, Complete__c=true);
		assignedList.add(assigned);
		assigned = new SalesHD_LMS_Assigned__c(Due_Date__c=System.now().addDays(-1),
		LMS_Assignment__c=assignmentList[4].Id, User__c=usr.Id);
		assignedList.add(assigned);
		assigned = new SalesHD_LMS_Assigned__c(Due_Date__c=System.now().addDays(3),
		LMS_Assignment__c=assignmentList[5].Id, User__c=usr.Id, Started_Datetime__c=System.now().addDays(-1));
		assignedList.add(assigned);
		insert assignedList;

		List<SalesHD_Training_Date__c> trainingDateList = new List<SalesHD_Training_Date__c>();
		SalesHD_Training_Date__c td = new SalesHD_Training_Date__c(Name = 'Test Date 1', Training_Datetime__c = System.now());
		trainingDateList.add(td);
		td = new SalesHD_Training_Date__c(Name = 'Test Date 2', Training_Datetime__c = System.now());
		trainingDateList.add(td);
		insert trainingDateList;

	}

	@isTest static void loadDashboard(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.loadDashboard();
		}
		Test.StopTest();
	}

	@isTest static void getCalendar(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.getCalendar(0);
		}
		Test.StopTest();
	}

	@isTest static void getQuestions(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Quiz Assignment'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.getQuestions(assigned.Id);
		}
		Test.StopTest();
	}
	@isTest static void getQuestionsTimed(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Timed Quiz Assignment'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.getQuestions(assigned.Id);
		}
		Test.StopTest();
	}

	@isTest static void submitQuizCorrect(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Timed Quiz Assignment'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.startAssignment(assigned.Id);
			String jsonPayload = '{"1" : "Test Answer 1"}';
			SalesHD_LMS.submitQuiz(assigned.Id, jsonPayload);
		}
		Test.StopTest();
	}

	@isTest static void submitQuizIncorrect(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Timed Quiz Assignment'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.startAssignment(assigned.Id);
			String jsonPayload = '{"1" : "Incorrect Test Answer 1"}';
			SalesHD_LMS.submitQuiz(assigned.Id, jsonPayload);
		}
		Test.StopTest();
	}

	@isTest static void submitVideo(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Video Assignment'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.submitVideo(assigned.Id);
		}
		Test.StopTest();
	}

	@isTest static void submitVideoNotTimed(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Video Assignment Not Timed'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.submitVideo(assigned.Id);
		}
		Test.StopTest();
	}

	@isTest static void submitFileOpen(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Document Assignment'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.submitFileOpen(assigned.Id);
		}
		Test.StopTest();
	}

	@isTest static void checkCompleted(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		SalesHD_LMS_Assigned__c assigned = [select Id from SalesHD_LMS_Assigned__c where User__c =: usr.Id and LMS_Assignment__r.Name='Test Video Assignment Complete'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.checkCompleted(assigned.Id);
		}
		Test.StopTest();
	}

	@isTest static void getResources(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.getResources();
		}
		Test.StopTest();
	}

	@isTest static void getHomework(){
		User usr = [select Id from user where UserName='hdsalestest@kndcrm.com'];
		Test.StartTest();
		System.runAs(usr) {
			SalesHD_LMS.getHomework();
		}
		Test.StopTest();
	}

}