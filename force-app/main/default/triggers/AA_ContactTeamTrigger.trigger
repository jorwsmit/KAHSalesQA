trigger AA_ContactTeamTrigger on Contact_Team__c (after insert, after update, before delete, before insert, before update) {
  
	TBN_ContactTeamHandler objContactTeamHandler = new TBN_ContactTeamHandler();
    
    if(trigger.isInsert && trigger.isBefore){
        objContactTeamHandler.onBeforeInsert(trigger.New);
    	} 
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
    	for(Contact_Team__c ct : trigger.new){
    		if(ct.Historic_ID__c == null){
    			ct.Historic_ID__c = ct.ID;
    			}
    		}
    	}
    
    public ID unassignedID = AA_UtilityClass.getKAHAdminAccount;
    if(trigger.isInsert && trigger.isAfter){
        objContactTeamHandler.onAfterInsert(trigger.NewMap);
    	Map<Id, Account> ContactIdToAccount = new Map<Id, Account>();
  		Map<Id, Id> ContactIdToAccountId = new Map<Id, Id>();
  		for(Contact_Team__c ct : [SELECT user__c, contact__c, contact__r.accountId, contact__r.firstName, contact__r.lastName,
  			contact__r.mailingCity, contact__r.mailingState, contact__r.mailingCountry,
  			contact__r.mailingPostalCode, contact__r.mailingStreet, contact__r.Practice_Account__c, contact__r.phone FROM contact_team__c
  			WHERE Id in :Trigger.new AND (contact__r.horizon_id__c != null OR contact__r.unity_id__c != null)]){
    	if(ct.contact__r.practice_account__c == null){
      		if(!ContactIdToAccount.containsKey(ct.contact__c)){
        		String acctName;
        		if(ct.contact__r.firstName != null){
        			acctName=ct.contact__r.lastName + ', ' + ct.contact__r.firstName + ' [Practice]';
        			}
        		else{
        			acctName=ct.contact__r.lastName + ', [Practice]';
        			}
        String postalCode = null;
        if(ct.contact__r.mailingPostalCode != null){
          if(String.valueOf(ct.contact__r.mailingPostalCode).replaceAll('[^0-9]', '').length()==9){
          	 postalCode=String.valueOf(ct.contact__r.mailingPostalCode).replaceAll('[^0-9]', '').substring(0,5)+'-'+String.valueOf(ct.contact__r.mailingPostalCode).replaceAll('[^0-9]', '').substring(5);
          	 }
          else if(String.valueOf(ct.contact__r.mailingPostalCode).replaceAll('[^0-9]', '').length()==5){
          	postalCode=String.valueOf(ct.contact__r.mailingPostalCode).replaceAll('[^0-9]', '');
        	}
        	}
        	
        String phoneNum = null;
        if(ct.contact__r.phone!=null){
          phoneNum = String.valueOf(ct.contact__r.phone).replaceAll('[^0-9]', '');
          if(phoneNum.length()==10){
          	phoneNum = '(' + phoneNum.substring(0, 3) + ') ' + phoneNum.substring(3, 6) + '-' + phoneNum.substring(6);
          	}
          else{
          	 phoneNum=null;
          	}
        	} 
        else{
          	phoneNum=null;
        	}
        ContactIdToAccount.put(ct.contact__c, new Account(name = acctName,
        shippingCity = ct.contact__r.mailingCity, shippingState = ct.contact__r.mailingState,
        shippingCountry = ct.contact__r.mailingCountry, shippingPostalCode = postalCode,
        shippingStreet = ct.contact__r.mailingStreet, is_practice_account__c=true, phone=phoneNum));
      	}
    	}
    else{
      if(!ContactIdToAccountId.containsKey(ct.contact__c)){
        ContactIdToAccountId.put(ct.contact__c, ct.contact__r.accountId);
      	}
    	}
  	}
  //Insert the created practice accounts
  //insert ContactIdToAccount.values();
  //Update the practice account fields for the null practice account contacts
  List<Contact> contacts = new List<Contact>();
  for(Contact c : [select practice_account__c, account.name, accountId, title__c, mailingPostalCode, phone from contact where id in :ContactIdToAccount.keySet()]){
    if(c.accountId == unassignedId){
    	c.accountId = ContactIdToAccount.get(c.Id).Id;
    	}
    if(c.mailingPostalCode != null){
      if(String.valueOf(c.mailingPostalCode).replaceAll('[^0-9]', '').length()==9){
      	 c.mailingPostalCode=String.valueOf(c.mailingPostalCode).replaceAll('[^0-9]', '').substring(0,5)+'-'+String.valueOf(c.mailingPostalCode).replaceAll('[^0-9]', '').substring(5);
      	}
      else if(String.valueOf(c.mailingPostalCode).replaceAll('[^0-9]', '').length()==5){
      	 c.mailingPostalCode=String.valueOf(c.mailingPostalCode).replaceAll('[^0-9]', '');
      	}
      else{
      		c.mailingPostalCode=null;
      		}
    	}
    String phoneNum;
    if(c.phone!=null){
      phoneNum = String.valueOf(c.phone).replaceAll('[^0-9]', '');
      if(phoneNum.length()==10){
      	c.phone = '(' + phoneNum.substring(0, 3) + ') ' + phoneNum.substring(3, 6) + '-' + phoneNum.substring(6);
      	}
      else{
      	c.phone=null;
      	}
    	}
    else{
    	c.phone=null;
    	}
    if(c.title__c == null){
    	c.title__c = 'Physician';
    	}
    c.practice_account__c = ContactIdToAccount.get(c.Id).Id;
    contacts.add(c);
  	}
  	//update contacts;
  	//ContactIdToUsers holds a list of the users on that contact team
  	Map<Id, Id> UserIdToAccountId = new Map<Id, Id>();
  	Map<String, AccountTeamMember> atms = new Map<String, AccountTeamMember>();
  for(Contact_Team__c ct : [SELECT user__c, contact__c, contact__r.practice_account__c FROM Contact_Team__c WHERE user__r.isActive=true AND (contact__c in :ContactIdToAccount.keySet()
  		OR contact__c in : ContactIdToAccountId.keySet())]){
    UserIdToAccountId.put(ct.user__c, ct.contact__r.practice_account__c);
    atms.put(String.valueOf(ct.user__c)+String.valueOf(ct.contact__r.practice_account__c),
    new AccountTeamMember(userId=ct.user__c, accountId=ct.contact__r.practice_account__c, teamMemberRole='Clinical Liaison'));
  	}

  for(AccountTeamMember atm : [SELECT userId, accountId FROM accountTeamMember WHERE userId in :UserIdToAccountId.keySet() AND accountId in :UserIdToAccountId.values()]){
  	atms.remove(String.valueOf(atm.userId)+String.valueOf(atm.accountId));
  	}
    }  
    
    if(trigger.isupdate && trigger.isAfter){
        objContactTeamHandler.onAfterUpdate(trigger.NewMap);
    	}
    
    if(trigger.isupdate && trigger.isBefore){
        objContactTeamHandler.onBeforeUpdate(trigger.NewMap, trigger.oldMap);
    	}
    
    if(trigger.isdelete && trigger.isBefore){
        objContactTeamHandler.onBeforeDelete(trigger.oldMap);
    	}
  
}