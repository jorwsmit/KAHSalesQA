@isTest(SeeAllData=false)
public class Sales_TestAssignmentsController {
	@isTest static void calingAllRemoteQueryFunctions() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        Account a = new Account(Name='Unassigned Account - Admin Maintenance');
        Contact c = new Contact(LastName='Test Contact');
        final ID KAH_Manager = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Manager'].id;
        
        UserRole urP = new UserRole(DeveloperName = 'pRole', Name = 'pRole');
		insert urP;
        UserRole urC =  new UserRole(DeveloperName = 'cRole', Name = 'cRole', parentRoleId=urP.Id);
        insert urC;
        User u = new User(Alias = 'standt', Email='test@kindredTest.com', EmailEncodingKey='UTF-8',
                          LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = KAH_Manager, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='test@kindredTest.com', userRoleId = urP.Id);
        
        System.runAs ( thisUser ) {
         	insert u;
            insert a;
            insert c;
            
            List<Referral_Source_Audit__c> rsa = new List<Referral_Source_Audit__c>();
            rsa.add(new Referral_Source_Audit__c(user__c=u.id, request_date__c=System.now().date(), account__c=a.Id, status__c='Added'));
            rsa.add(new Referral_Source_Audit__c(user__c=u.id, request_date__c=System.now().date(), contact__c=c.Id, status__c='Added'));
            rsa.add(new Referral_Source_Audit__c(user__c=u.id, request_date__c=System.now().date(), account__c=a.Id, status__c='Deleted'));
            rsa.add(new Referral_Source_Audit__c(user__c=u.id, request_date__c=System.now().date(), contact__c=c.Id, status__c='Deleted'));
            insert rsa;
            
        }
        
        
        Sales_AssignmentsController.getUsersByRoleId(u.userRoleId);
        Sales_AssignmentsController.getChildRoles(urP.Id);
        Sales_AssignmentsController.getUsersUnderRoleId(urP.Id);
        Sales_AssignmentsController.getAssignments(u.id, null, null, 1);
        Sales_AssignmentsController.getAssignments(u.id, 'Today', null, 1);
        Sales_AssignmentsController.getAssignments(u.id, 'Yesterday', null, 1);
        Sales_AssignmentsController.getAssignments(u.id, 'This Week', null, 1);
        Sales_AssignmentsController.getAssignments(u.id, 'Last Week', null, 1);
        for(Integer i=0; i<24; i++){
            Sales_AssignmentsController.getAssignments(u.id, String.valueOf(i+1), null, 1);
        }
        System.runAs(u){Sales_AssignmentsController.getAdded('Today');}
        System.runAs(u){Sales_AssignmentsController.getDeleted('Today');}
        Sales_AssignmentsController.getUserName(u.id);
    }
}