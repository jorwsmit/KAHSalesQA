@isTest
private class AA_AccountChoiceControllerTest {

    static testMethod void myUnitTest(){
    	
    	list<RecordType> accTypes = new list<RecordType>();
		list<ID> hdProfileIDs = AA_UtilityClass.getAllHDProfileIDs;
		list<ID> kahProfileIDs = AA_UtilityClass.getAllSTDKAHProfileIDs;
		list<ID> kahBDProfileIDs = AA_UtilityClass.getAllBDKAHProfileIDs;
		list<ID> rhcProfileIDs = AA_UtilityClass.getAllRHCProfileIDs;
		list<ID> lacProfileIDs = AA_UtilityClass.getAllLacunaProfileIDs;
		list<ID> krsProfileIDs = AA_UtilityClass.getAllKRSProfileIDs;
		ID sysAdmin = AA_UtilityClass.getSysAdminID;
    	
        list<User> uToInsert = new list<User>();
         
        User u = new User(ProfileId = sysAdmin, 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'te43534st23345345354242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam10935353398098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
        User u2 = new User(ProfileId = krsProfileIDs[0], 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'test342223445345334242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam454564510998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
        
        User u3 = new User(ProfileId = lacProfileIDs[0], 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'test23453424234242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam234234210998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
        User u4 = new User(ProfileId = rhcProfileIDs[0], 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'test3452342242242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam1099234238098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
       User u5 = new User(ProfileId = kahBDProfileIDs[0], 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 't435est23423234242423@usertest.none',
                          Alias = 'te9000', Email ='testContactTeam109923428098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
       User u6 = new User(ProfileId = kahProfileIDs[0], 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'te345st2244234242423@usert2342est.none',
                          Alias = 'te9000', Email ='testContact242Team10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');                                                                                             
        
        User u7 = new User(ProfileId = hdProfileIDs[0], 
                          FirstName = 'Test',
                          LastName = 'User',
                          userName = 'te435st234234242423@user2test.none',
                          Alias = 'te9000', Email ='testCont3242actTeam10998098@testorg.com', 
                          EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
                          LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
                          
        uToInsert.add(u);
        uToInsert.add(u2);
        uToInsert.add(u3);
        uToInsert.add(u4);
        uToInsert.add(u5);
        uToInsert.add(u6);
        uToInsert.add(u7);
        
        insert uToInsert;
        
        system.runAs(u){
        	AA_AccountChoiceController.getAccountChoices();
        	AA_AccountChoiceController.getViewState();
        	}
        system.runAs(u2){
        	AA_AccountChoiceController.getAccountChoices();
        	AA_AccountChoiceController.getViewState();
        	}
        system.runAs(u3){
        	AA_AccountChoiceController.getAccountChoices();
        	AA_AccountChoiceController.getViewState();
        	}
        system.runAs(u4){
        	AA_AccountChoiceController.getAccountChoices();
        	AA_AccountChoiceController.getViewState();
        	}
        system.runAs(u5){
        	AA_AccountChoiceController.getAccountChoices();
        	AA_AccountChoiceController.getViewState();
        	}
        system.runAs(u6){
        	AA_AccountChoiceController.getAccountChoices();
        	AA_AccountChoiceController.getViewState();
        	}
        system.runAs(u7){
        	AA_AccountChoiceController.getAccountChoices();
        	AA_AccountChoiceController.getViewState();
        	}						
        
    	}
}