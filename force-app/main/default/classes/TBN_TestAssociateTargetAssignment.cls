@isTest 
private class TBN_TestAssociateTargetAssignment {    

    static testMethod void TestAssociateTargetAssignment() {
    
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
        
            String PARENT_ROLE = 'SVP - KAH';
            UserRole objUserRole = [select id from UserRole where Name =:PARENT_ROLE Limit 1];
            UserRole objUserRole1 = [select id from UserRole where ParentRoleId =:objUserRole.Id Limit 1];
            
            TBN_AssociateTargetAssignmentController TargetAssignment = new TBN_AssociateTargetAssignmentController();
            TargetAssignment.strSelectedDivision = objUserRole.Id;
            
            list<User> toInsertU = new list<User>();
            
            User objUser = new User(
                                    FirstName = 'testFirst2',
                                    LastName = 'TestUser2' + String.valueOf(Date.today()), 
                                    Email = 'TestUser2' + String.valueOf(Date.today()) + '_' + '@gmail.com',
                                    Username = 'TestUser_Test2' + String.valueOf(Date.today()) + '_' +  '@gmail.com',
                                    isActive = true,
                                    Alias = 'tu',
                                    TimeZoneSidKey = 'America/New_York',
                                    LocaleSidKey = 'en_US',
                                    EmailEncodingKey = 'ISO-8859-1', 
                                    LanguageLocaleKey = 'en_US',
                                    ProfileId =  Userinfo.getProfileId(),
                                    CommunityNickname = 'TestCommunity1' + String.valueOf(Date.today()) + '_', 
                                    Title = 'Title11',
                                    City = 'testCity',
                                    Country = 'testCountry',
                                    Street = 'testStreet',
                                    CompanyName = 'testCompanyName',
                                    Phone = 'testPhone',
                                    Extension = 'testExtension',
                                    PostalCode = '2345',
                                    UserRoleId = objUserRole1.Id
                                );
            
            toInsertU.add(objUser);
            
            User objUser2 = new User(
                                    
                                    username = 'newUserTargerAssignment@yahoo.com', 
                                    email = 'pb@ff.com', 
                                    emailencodingkey = 'UTF-8', 
                                    localesidkey = 'en_US', 
                                    languagelocalekey = 'en_US', 
                                    timezonesidkey = 'America/Los_Angeles', 
                                    alias='nuser', 
                                    lastname='lastname', 
                                    ProfileId =  Userinfo.getProfileId(),
                                    managerId= objUser.id,
                                    UserRoleId = objUserRole.Id
                                  
            ); 
            
            toInsertU.add(objUser2);
            
            insert toInsertU;
            
            list<TargetAssignmentYears__c> toInsertTargets = new list<TargetAssignmentYears__c>();
            
            TargetAssignmentYears__c  objTargetAssignmentYear = new TargetAssignmentYears__c  (Name = string.valueOf(system.today().year()));
            toInsertTargets.add(objTargetAssignmentYear);
            insert toInsertTargets;
            
            list<Sales_Performance__c> toInsertSP = new list<Sales_Performance__c>();
            Sales_Performance__c objSalePerformance = new Sales_Performance__c(Name = 'Test SalesPerformance' , Targeted_Admissions__c=5, Targeted_Revenue__c = 5, User__c = objUser2.Id, Month__c = date.newInstance(Date.Today().Year(),date.today().month(), 1));
            toInsertSP.add(objSalePerformance);
            
            Sales_Performance__c objSalePerformance2 = new Sales_Performance__c(Name = 'Test SalesPerformance', Targeted_Admissions__c=5, Targeted_Revenue__c = 5,User__c = objUser2.Id, Month__c = date.newInstance(Date.Today().Year(),date.today().month(),1));
            toInsertSP.add(objSalePerformance2);
            
            Sales_Performance__c objSalePerformance3 = new Sales_Performance__c(Name = 'Test SalesPerformance' , Targeted_Admissions__c=5, Targeted_Revenue__c = 5, User__c = objUser.Id, Month__c = date.newInstance(Date.Today().Year(),date.today().month(), 1));
            toInsertSP.add(objSalePerformance3);
            
            Sales_Performance__c objSalePerformance4 = new Sales_Performance__c(Name = 'Test SalesPerformance', Targeted_Admissions__c=5, Targeted_Revenue__c = 5,User__c = objUser.Id, Month__c = date.newInstance(Date.Today().Year(),date.today().month(),1));
            toInsertSP.add(objSalePerformance4);
            insert toInsertSP;
            
            list<Sales_Performance__c> toUpdateSP = new list<Sales_Performance__c>();
            
            Test.startTest();
            
            Sales_Performance__c objSP = [select Calendar_Month__c,Name,Targeted_Admissions__c,Targeted_Revenue__c,User__c from Sales_Performance__c where id=:objSalePerformance.Id];
            toUpdateSP.add(objSP);
            
            Sales_Performance__c objSP2 = [select Calendar_Month__c,Name,Targeted_Admissions__c,Targeted_Revenue__c,User__c from Sales_Performance__c where id=:objSalePerformance2.Id];
            toUpdateSP.add(objSP2);
            
            Sales_Performance__c objSP3 = [select Calendar_Month__c,Name,Targeted_Admissions__c,Targeted_Revenue__c,User__c from Sales_Performance__c where id=:objSalePerformance3.Id];
            toUpdateSP.add(objSP3);
            
            Sales_Performance__c objSP4 = [select Calendar_Month__c,Name,Targeted_Admissions__c,Targeted_Revenue__c,User__c from Sales_Performance__c where id=:objSalePerformance4.Id];
            toUpdateSP.add(objSP4);
            
            update toUpdateSP;
            
            TargetAssignment.strSelectedYear = string.valueOf(system.today().year());
            TargetAssignment.strSelectedUserId = objUser2.Id;
            
            String strtest=TargetAssignment.strSelectedUserId;
            
            TBN_AssociateTargetAssignmentController.fetchUserRoles(strtest, 2);
            TBN_AssociateTargetAssignmentController.fetchUserRoles(objUserRole.Id, 2);
            
            TargetAssignment.fetchTargetAssignments(TargetAssignment.strSelectedYear);
            TargetAssignment.fetchTargetAssignments(TargetAssignment.strSelectedUserId);
            TargetAssignment.strSelectedUserId = objUser.Id;
            TargetAssignment.fetchTargetAssignments(TargetAssignment.strSelectedUserId);
            TargetAssignment.strSelectedUserId = objUser2.Id;
            TargetAssignment.fetchTargetAssignments(TargetAssignment.strSelectedUserId);
            
                
            TargetAssignment.fetchDependentUsers(TargetAssignment.strSelectedUserId);
            
            TargetAssignment.onTargetYearSelect(); 
            TargetAssignment.onDivisionSelect();
            TargetAssignment.fetchAssessments();
            TargetAssignment.upsertSalesPerformances();
            TargetAssignment.checkisAdm();
            TargetAssignment.checkisRev();
            
            objSP.Targeted_Admissions__c = 10;
            objSP.Targeted_Revenue__c=8;
            update objSP;
            
            objSP2.Targeted_Admissions__c = 11;
            objSP2.Targeted_Revenue__c=11;
            update objSP2;
            TargetAssignment.upsertSalesPerformances();
            list<SelectOption> lstOptions  =TargetAssignment.getlstTargetYears();
            system.AssertEquals(lstOptions.size(),1);
            
            list<SelectOption> lstOptionsforDivision  =TargetAssignment.getlstDivisions();
            
            Test.stopTest();
        }
    
    }
    
    
   private static testMethod void testWork2(){
   	
   	TBN_AssociateTargetAssignmentController controller = new TBN_AssociateTargetAssignmentController();
   	
   	controller.fetchTargetAssignments('Chris Mills, Josh Cates');
   	
   	User u = new User(username = 'a@a324234463634643623423532534534.com', 
                             email = 'pb@ff.com', 
                             emailencodingkey = 'UTF-8', 
                             localesidkey = 'en_US', 
                             languagelocalekey = 'en_US', 
                             timezonesidkey = 'America/Los_Angeles', 
                             alias='nuser', 
                             lastname='aaa', 
                             firstname = ' ',
                             Line_of_Business__c = '',
                             Perner__c = '24234234234223',
                             ProfileId =  Userinfo.getProfileId()
                             ); 
            insert u;
            ID roleID = [SELECT ID FROM UserRole WHERE Name = 'SVP - KAH'].ID;
   			TBN_AssociateTargetAssignmentController.fetchUserRoles(roleID, 0);
   			controller.fetchTargetAssignments(string.valueOf(u.ID));
   			controller.checkisAdm();
   			controller.checkisRev();
   			controller.upsertSalesPerformances();
   			TBN_AssociateTargetAssignmentController.fetchUserRoles('', 0);
   	
   	} 
    
}