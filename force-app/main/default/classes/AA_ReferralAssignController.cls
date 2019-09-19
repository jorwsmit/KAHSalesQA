public without sharing class AA_ReferralAssignController{
	
	public AA_ReferralAssignController(apexPages.StandardController controller){
		
	}
	
	public static void assignUnassignAccountAlt(){
		string result;
		ID id = ApexPages.currentPage().getParameters().get('id');
		system.debug('ID Account: ' + id);
		try{
			ID userID = userInfo.getUserId();
			list<Referral_Source_Audit__c> auditList = new list<Referral_Source_Audit__c>();
			//list to hold AccountteamMembers to insert
            List<AccountTeamMember> lstATMsToInsert = new List<AccountTeamMember>(); 
            //list to hold AccountTeammembers to delete
            List<AccountTeamMember> lstATMsToDelete = new List<AccountTeamMember>(); 
            system.debug('Account list: ' + [SELECT ID, Account.RecordType.Name, AccountID, UserID FROM AccountTeamMember WHERE AccountID =: id AND UserID =: userID]); 
            list<AccountTeamMember> objATM = [SELECT ID, Account.RecordType.Name, AccountID, UserID FROM AccountTeamMember WHERE AccountID =: id AND UserID =: userID];
            system.debug('objATM.Size(): ' + objATM.size());
            if(objATM.size() > 0){
                for(AccountTeamMember atm : objATM){
                    lstATMsToDelete.add(atm);
                    auditList.add(new Referral_Source_Audit__c(Account__c = atm.AccountID, 
                                           Request_Date__c = system.today(), 
                                           Status__c = 'Deleted', 
                                           User__c = userID));
                    }
                }   
            else{
                list<Account> newList = [SELECT ID, RecordType.Name FROM Account WHERE ID =: id];
                    for(Account s : newList){
                        if(s.RecordType.Name == 'Center'){
                            lstATMsToInsert.add(new AccountTeamMember(AccountId = s.ID,
                                                                      UserId = userID, 
                                                                      TeamMemberRole = 'Clinical Liaison',
                                                                      ContactAccessLevel = 'Read',
                                                                      OpportunityAccessLevel = 'Read',
                                                                      CaseAccessLevel = 'Read',
                                                                      AccountAccessLevel = 'Read'));
                            
                            auditList.add(new Referral_Source_Audit__c(Account__c = s.ID, 
                                                   Request_Date__c = system.today(), 
                                                   Status__c = 'Added', 
                                                   User__c = userID));                                          
                            }
                        else{
                            lstATMsToInsert.add(new AccountTeamMember(AccountId = s.ID,
                                                                      UserId = userID, 
                                                                      TeamMemberRole = 'Clinical Liaison',
                                                                      ContactAccessLevel = 'Read',
                                                                      OpportunityAccessLevel = 'None',
                                                                      CaseAccessLevel = 'Read',
                                                                      AccountAccessLevel = 'Edit'));
                                                                      
              auditList.add(new Referral_Source_Audit__c(Account__c = s.ID, 
                                                   Request_Date__c = system.today(), 
                                                   Status__c = 'Added', 
                                                   User__c = userID));                                         
                                                                                                  
                            }
                        }
                  }
            system.debug('lstATMsToDelete: ' + lstATMsToDelete);
            system.debug('lstATMsToInsert: ' + lstATMsToInsert);
            if(!lstATMsToInsert.isEmpty()){
                insert lstATMsToInsert;
                result = 'You have successfully assigned this referral source.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, result));
                }
            if(!lstATMsToDelete.isEmpty()){
                delete lstATMsToDelete; 
                result = 'You have successfully removed this referral source.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, result));
                }
            if(!auditList.isEmpty()){
              insert auditList;
              }
			}
		catch(Exception E){
			result = 'There was an issue completing your request, please try again.  If issue persists, please contact an administrator.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, result));
            }
		}
	
	
	public static void assignUnassignContactAlt(){
		string result;
		ID id = ApexPages.currentPage().getParameters().get('id');
		system.debug('ID Contact: ' + id);
		try{
			ID userID = userInfo.getUserId();
		    //list to hold ContactTeamMembers to insert
            List<Contact_Team__c> lstContactTeamsToInsert = new List<Contact_Team__c>();
            //list to hold ContactTeamMembers to delete
            List<Contact_Team__c> lstContactTeamsToDelete = new List<Contact_Team__c>();
            list<Referral_Source_Audit__c> auditList = new list<Referral_Source_Audit__c>();
		    system.debug('contact list: ' + [SELECT ID, User__c, Contact__c FROM Contact_Team__c WHERE Contact__r.Id =: id AND User__c =: userID]);
            list<Contact_Team__c> ctmList = [SELECT ID, User__c, Contact__c FROM Contact_Team__c WHERE Contact__r.Id =: id AND User__c =: userID];
            if(ctmList.size() > 0){
            	for(Contact_Team__c objCTM : ctmList){
            		lstContactTeamsToDelete.add(objCTM);
                    auditList.add(new Referral_Source_Audit__c(Contact__c = objCTM.Contact__c, 
                                           Request_Date__c = system.today(), 
                                           Status__c = 'Deleted', 
                                           User__c = userID));
            		}
            	}
            else{
            	 ID c;
                 c = [SELECT ID FROM Contact WHERE ID =: id LIMIT 1].ID; 
            	 	if(c != null){
            	    	lstContactTeamsToInsert.add(new Contact_Team__c(User__c = userID,
                    	Contact__c = c));
                    	auditList.add(new Referral_Source_Audit__c(Contact__c = c, 
                                           Request_Date__c = system.today(), 
                                           Status__c = 'Added', 
                                           User__c = userID));
            	    }
            	}
            if(!lstContactTeamsToInsert.isEmpty()){
                insert lstContactTeamsToInsert;
                result = 'You have successfully assigned this referral source.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, result)); 
                }
            if(!lstContactTeamsToDelete.isEmpty()){
                delete lstContactTeamsToDelete;
                result = 'You have successfully removed this referral source.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, result));  
                }
            if(!auditList.isEmpty()){
              insert auditList;
              }
                	
			}
		 catch(Exception E){
			result = 'There was an issue completing your request, please try again.  If issue persists, please contact an administrator.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, result));
			}    
		}	
    
}