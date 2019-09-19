public with sharing class AA_SRSAccountTeamHelper{
	
	private static list<SRS_BDO_Territory__c> sBDOs = AA_UtilityClass.getSRSBDO;
  	
	public static void processItems(list<Account> srsAccounts, list<ID> accList){
		try{
			if(!srsAccounts.isEmpty() && !accList.isEmpty()){
				map<ID, ID> ctVPBDO = new map<ID, ID>();
  				for(SRS_BDO_Territory__c sb: sBDOs){
  					if(sb.CT_VP__c != null){
  						ctVPBDO.put(sb.SRS_BDO__c, sb.CT_VP__c);
  						}
  					}
				Map<Id, list<AccountTeamMember>> accounts = new Map<Id, list<AccountTeamMember>>();
			list<AccountTeamMember> acMemb = new list<AccountTeamMember>();
 				 	acMemb = [SELECT Id, 
                          			 UserId,
                          			 AccountID 
                          			 FROM AccountTeamMember
                          			 WHERE AccountId In :accList];
                	List<AccountTeamMember> newMembers = new List<AccountTeamMember>();          			 
                    for(Account srs : srsAccounts){      			 
                    for(ID i: accList){
                    	list<AccountTeamMember> tempList = new list<AccountTeamMember>();      			 
                    	for(AccountTeamMember acb : acMemb){
                    		if(acb.AccountID == i){
                    			tempList.add(acb);
                    			}
                    		accounts.put(i, tempList);
                    		} 
                    	}
                    for(SRS_BDO_Territory__c sbt: sBDOs){	     			 
                    system.debug('MAP: ' + accounts); 		
        			list<AccountTeamMember> temp2 = new list<AccountTeamMember>();
            		system.debug('AccountID1 : ' + srs.ID);
            		temp2 = accounts.get(srs.ID);
           	 		list<ID> tempIDs = new list<ID>();
           		 	if(temp2 != null){
                        	for(AccountTeamMember atm : temp2){
                        		tempIDs.add(atm.UserID);
                        		}
                        	}
                        if(tempIDs.size() > 0){	
      						if(!tempIDs.contains(sbt.SRS_BDO__c) && sbt.SRS_BDO__c == srs.KRS_SRS_BDO_Territory3__c){
          						AccountTeamMember newMember = new AccountTeamMember();
          						system.debug('AccountID2 : ' + srs.ID);
            					newMember.AccountId = srs.Id;
            					newMember.UserId = sbt.SRS_BDO__c;
            					newMember.TeamMemberRole = sbt.Role__c;
            					newMembers.Add(newMember);
      							}
      						for(ID i : ctVPBDO.keyset()){	
      							if(i == srs.KRS_SRS_BDO_Territory3__c && !tempIDs.contains(ctVPBDO.get(i))){
          							AccountTeamMember newMember = new AccountTeamMember();
          							system.debug('AccountID4 : ' + srs.ID);
            						newMember.AccountId = srs.Id;
            						newMember.UserId = ctVPBDO.get(i);
            						newMember.TeamMemberRole = 'CT VP';
            						newMembers.Add(newMember);
      								}
      							}	
                        	}
          				else{
          					if(sbt.SRS_BDO__c == srs.KRS_SRS_BDO_Territory3__c){
          						AccountTeamMember newMember = new AccountTeamMember();
          						system.debug('AccountID3 : ' + srs.ID);
            					newMember.AccountId = srs.Id;
            					newMember.UserId = sbt.SRS_BDO__c;
            					newMember.TeamMemberRole = sbt.Role__c;
            					newMembers.Add(newMember);
          						}
          					for(ID i : ctVPBDO.keyset()){	
      							if(i == srs.KRS_SRS_BDO_Territory3__c){
          							AccountTeamMember newMember = new AccountTeamMember();
          							system.debug('AccountID4 : ' + srs.ID);
            						newMember.AccountId = srs.Id;
            						newMember.UserId = ctVPBDO.get(i);
            						newMember.TeamMemberRole = 'CT VP';
            						newMembers.Add(newMember);
      								}
      							}	
          					}
                    }	
            	}
        	if(!newMembers.isEmpty()){
    			insert newMembers;
            	}
                }
			}
	catch(Exception E){
		system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			}
		}
    
}