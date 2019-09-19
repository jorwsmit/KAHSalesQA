public with sharing class AA_ApprovalReviewController{

	@AuraEnabled
	public static list<approvalWrapper> getApprovals(){
		
		list<ProcessInstance> apLst = new list<ProcessInstance>();
		list<approvalWrapper> apWrp = new list<approvalWrapper>();
		set<ID> ids = new set<ID>();
		set<ID> actIds = new set<ID>();
		list<Account> accs = new list<Account>();
		list<Contact> ctcs = new list<Contact>();
		list<User> users = new list<User>();
		//map<ID, String> asignees = new map<ID, String>();
		
			system.debug(LoggingLevel.Info,'START');
			apLst = [SELECT CreatedDate, 
							TargetObjectId,
							(SELECT Actor.Id, Comments FROM Steps)
		 					FROM ProcessInstance WHERE Status != 'Approved' AND Status != 'Rejected'];
			
			system.debug(LoggingLevel.Info,'apLst: ' + apLst);
		 				
			for(ProcessInstance p : apLst){
				ids.add(p.TargetObjectId);
			for(ProcessInstanceStep s: p.Steps){
				actIds.add(s.ActorId);
				}
			}
		
			system.debug(LoggingLevel.Info,'ids: ' + ids);
			system.debug(LoggingLevel.Info,'actIds: ' + actIds);
			
			users = [SELECT ID, Name FROM User WHERE ID IN: actIDs];
			/*for(User u: users){
				asignees.put(u.ID, u.Name);
				}*/
		
			system.debug('users: ' + users);
		
		accs = [SELECT ID, Name, Merge_Requested_With_ID__c, Merge_Request_With_Name__c FROM Account WHERE ID IN: ids];
		ctcs = [SELECT ID, Name, Merge_Requested_With_ID__c, Merge_Request_With_Name__c FROM Contact WHERE ID IN: ids];	
		
		system.debug(LoggingLevel.Info,'accs: ' + accs);
		system.debug(LoggingLevel.Info,'ctcs: ' + ctcs);
		
				
		for(processInstance pI: apLst){
			for(User u: users){
				for(Account a : accs){
					for(ProcessInstanceStep st: pI.Steps){
						if(u.ID == st.ActorId && a.ID == pI.TargetObjectId){
							apWrp.add(new approvalWrapper(pI, a, u.Name));
							}
						}
					}
				for(Contact c : ctcs){
					for(ProcessInstanceStep st: pI.Steps){
						if(u.ID == st.ActorId && c.ID == pI.TargetObjectId){
							apWrp.add(new approvalWrapper(pI, c, u.Name));
							}
						}
					}	
				}
			
			}
		
		return apWrp;
		}
		
	public class approvalWrapper{
		@AuraEnabled
		public string itemType	{get;set;}
		@AuraEnabled 
		public string assignedTo	{get;set;}
		@AuraEnabled 
		public string requestedDate	{get;set;}
		@AuraEnabled
		public string requestedMergeWith	{get;set;} 
		@AuraEnabled 
		public string itemName	{get;set;}
		@AuraEnabled
		public string itemID	{get;set;}
		@AuraEnabled
		public string mergeMasterID	{get;set;}
		
		public approvalWrapper(ProcessInstance p, Account a, string name){
		 	itemType = 'Account';
		 	itemName = a.Name;
		 	itemID = a.ID;
		 	assignedTo = name;
		 	requestedDate = string.valueOf(p.CreatedDate.format('MM/dd/YYYY'));
		 	mergeMasterID = a.Merge_Requested_With_ID__c;
			requestedMergeWith = a.Merge_Request_With_Name__c;
			}
			
		public approvalWrapper(ProcessInstance p, Contact c, string name){
		 	itemType = 'Contact';
		 	itemName = c.Name;
		 	itemID = c.ID;
		 	assignedTo = name;
		 	requestedDate = string.valueOf(p.createdDate.format('MM/dd/YYYY'));
			mergeMasterID = c.Merge_Requested_With_ID__c;
			requestedMergeWith = c.Merge_Request_With_Name__c; 
			}	
		
		}	
    
}