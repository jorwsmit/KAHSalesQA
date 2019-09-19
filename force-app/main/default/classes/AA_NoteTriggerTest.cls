@isTest(SeeAllData=true) 
private class AA_NoteTriggerTest {
    static testMethod void myUnitTest(){
    	id pID = [SELECT ID FROM Profile WHERE Name = 'Contact Center Representative'].ID;
    	id rID = [SELECT ID FROM UserRole WHERE Name = 'Contact Center Manager'].ID;
    	
        User u2 = new User(ProfileId = pID, 
	    				   UserRoleId = rID,
	    				   FirstName = 'Test2',
	    				   LastName = 'User2',
	    				   userName = 'test2323@usertest.none',
	    				   Alias = 'te9200', Email ='testC98@testorg.com', 
            			   EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			   LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
	    				  
	    insert u2;				  
		
		
		system.runAs(u2){
			list<Note> toUpdate = new list<Note>();
			toUpdate = [SELECT ID, Body FROM Note WHERE OwnerId !=: u2.ID LIMIT 1];
			system.debug('Notes: ' + toUpdate.size());
			for(Note nte: toUpdate){
				nte.Body = 'Blah';
				}
			try{
				update toUpdate;
				}
			catch(Exception E){
				system.debug('Passed');
				}
			try{
				delete toUpdate;
				}
			catch(Exception E){
				system.debug('Passed');
				}		
    		}
    }
    
    static testMethod void myUnitTest2(){
    	
    	id pID = [SELECT ID FROM Profile WHERE Name = 'Contact Center Representative'].ID;
    	id rID = [SELECT ID FROM UserRole WHERE Name = 'Contact Center Manager'].ID;
        User u2 = new User(ProfileId = pID, 
	    				   UserRoleId = rID,
	    				   FirstName = 'Test2',
	    				   LastName = 'User2',
	    				   userName = 'test2323@usertest.none',
	    				   Alias = 'te9200', Email ='testC98@testorg.com', 
            			   EmailEncodingKey ='UTF-8', LanguageLocaleKey ='en_US', 
            			   LocaleSidKey ='en_US', TimeZoneSidKey ='America/Los_Angeles');
	    				  
	    insert u2;				  
		
		
		system.runAs(u2){
			list<Note> toUpdate = new list<Note>();
			toUpdate = [SELECT ID, Body FROM Note WHERE OwnerId !=: u2.ID LIMIT 1];
			system.debug('Notes: ' + toUpdate.size());
			try{
				delete toUpdate;
				}
			catch(Exception E){
				system.debug('Passed');
				}		
    		}
    }
}