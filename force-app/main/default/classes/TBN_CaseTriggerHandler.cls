public class TBN_CaseTriggerHandler {
    
    // Constructor
    public TBN_CaseTriggerHandler() {
        
        
    }
    
    /**
    @MethodName : onAfterInsert
    @Param      : map<id,Case> mapNewCases - Inserted case records
    @Description: Update Contact.Case Origin based on Case.Origin field
    **/
    public void onAfterInsert(Map<Id, Case> mapNewCases){
        
        Set<Id> setUniqueContacts = new Set<Id>();
        List<Contact> lstContactsToUpdate = new List<Contact>();
        
        for( Case objCase: [ Select ContactId, Origin
                             From Case
                             Where Id IN: mapNewCases.keyset() 
                             Order By CreatedDate DESC]) {
            
            // If Case.Origin is not Null and the related Contact has not already been updated
                // map Origin of Case to related Contact
            if( String.isNotBlank(objCase.Origin) && !setUniqueContacts.contains(objCase.ContactId ) && String.isNotBlank(objCase.ContactId)) {
                
                // Maps the most recent Case inserted to Contact
                Contact objContact = new Contact(Id = objCase.ContactId, Case_Origin__c = objCase.Origin);
                lstContactsToUpdate.add(objContact);
                
                setUniqueContacts.add(objCase.ContactId);
            }
        }
        
        try {
            
            // Update Related Contacts
            if(!lstContactsToUpdate.isEmpty()) {
                
                update lstContactsToUpdate;
            }
        }
        catch(DMLException ex) {
            
            system.debug('Ex: '+ex.getDmlMessage(0));
        }
        catch(Exception ex) {
            
            system.debug('Ex: '+ex.getMessage());
        }
    }
    
    
    /**
    @MethodName : onBeforeInsert
    @Param      : list<Case> lstCases
    @Description: Based on the case email, it will check for the contact with same Email,
                    If only one match is found we need to relate the Contact and it's Account to the Case. 
                    If no matches are found, then we need to create the Household Account and Individual 
                    Contact based on the data entered on the form and relate that Account and Contact to the Case. 
                    If more than one match is found, we do nothing.
    **/
    public void onBeforeInsert(list<Case> lstCases){
        
        try{
            //list to store case created from web to case based on SuppliedEmail field value.
            list<Case> lstCaseFromWebtoCase = new list<Case>();
            //set to store the email 
            set<String> setCaseSuppliedEmail = new set<String>();
            //map to store email and list od contacts containing same email
            map<string,list<Contact>> mapEmailtoContactList = new map<string,list<Contact>>();
            
            Id contactRTIndividual = [Select SobjectType, Name, DeveloperName From RecordType where SobjectType = 'Contact' AND DeveloperName = 'Individual'].Id;
            Id accountRtHousehold = [Select SobjectType, Name, DeveloperName From RecordType where SobjectType = 'Account' AND DeveloperName = 'Household'].Id;
            
            //iterates over list of cases and checks if SuppliedEmail is not empty 
            for(Case objCase : lstCases){ 
                
                if(string.isNotEmpty(objCase.SuppliedEmail)){
                    lstCaseFromWebtoCase.add(objCase);
                    setCaseSuppliedEmail.add(objCase.SuppliedEmail);
                	}
            }
            
            if(!setCaseSuppliedEmail.isEmpty()){  
                //iterates over the contact where email in the above set, setCaseSuppliedEmail and adds it into the map.
                for(Contact objContact: [select id, Email,AccountId, CreatedDate from Contact where Email != null AND Email IN: setCaseSuppliedEmail AND RecordTypeId =: contactRTIndividual order By CreatedDate Desc LIMIT 1]){
                    if(!mapEmailtoContactList.containsKey(objContact.Email)) {
                        List<Contact> lstContact = new list<Contact>();
                        lstContact.add(objContact);
                        mapEmailtoContactList.put(objContact.Email, lstContact);
                    	} 
                	}
            	}
            
            //for the case inserted from web to case, checks if map has value, if so it will update ContactId and AccountId of inserted case else it will create new contact and Account 
            for(Case objCase : lstCaseFromWebtoCase){
            	if(objCase.SuppliedEmail.containsWhiteSpace()){
            		objCase.SuppliedEmail = 'invalid@email.com';
            		}
                String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
                Pattern MyPattern = Pattern.compile(emailRegex);
                list<Contact>lstCon = new list<Contact>();
                if(mapEmailtoContactList.containsKey(objCase.SuppliedEmail))
                    lstCon = mapEmailtoContactList.get(objCase.SuppliedEmail);
                if(lstCon!=null && !lstCon.isEmpty() && lstCon.size() ==1){
                    
                    objCase.ContactId = lstCon[0].Id;
                    objCase.AccountId = lstCon[0].AccountId;
                	}
                else if(String.isNotBlank(objCase.Web_Last_Name__c)) {
                    Contact objContact = new Contact();
                    
                    objContact.RecordTypeId = contactRTIndividual;
                    
                    objContact.LastName = objCase.Web_Last_Name__c;
                    objContact.FirstName = objCase.Web_First_Name__c;
                    Matcher MyMatcher = MyPattern.matcher(objCase.SuppliedEmail);
                    if(MyMatcher.matches() && !objCase.SuppliedEmail.containsWhiteSpace()){
                    	objContact.Email = objCase.SuppliedEmail;
                    	}
                    else{
                    	objCase.SuppliedEmail = 'invalid@email.com';
                    	objContact.Email = 'invalid@email.com';
                    	}	
                    if(objCase.Web_City__c != '' && string.isNotEmpty(objCase.Web_City__c)){
                        objContact.MailingCity = objCase.Web_City__c;
                    	}
                    if(objCase.Web_State__c != '' && string.isNotEmpty(objCase.Web_State__c)){
                        objContact.MailingState = objCase.Web_State__c;
                    	}
                    if(objCase.Web_Zip_Code__c != '' && string.isNotEmpty(objCase.Web_Zip_Code__c)){    
                        objContact.MailingPostalCode = objCase.Web_Zip_Code__c;
                    	}
                    if(objCase.Web_Street_Address__c != '' && string.isNotEmpty(objCase.Web_Street_Address__c)){    
                        objContact.MailingStreet = objCase.Web_Street_Address__c;  
                    	}
                    if(objCase.SuppliedPhone != '' && string.isNotEmpty(objCase.SuppliedPhone)){    
                        objContact.Phone = objCase.SuppliedPhone;       
                    	}
                    Account objAccount = new Account();
                    
                    objAccount.RecordTypeId = accountRtHousehold;
                        
                    if(!String.isEmpty(objContact.FirstName)){
                        objAccount.Name = 'The Household of '+objContact.FirstName +' '+objContact.LastName;
                    	}
                    else{
                        objAccount.Name = 'The Household of '+objContact.LastName;    
                    	}
                    if(objCase.Web_City__c != '' && string.isNotEmpty(objCase.Web_City__c)){    
                        objAccount.ShippingCity = objCase.Web_City__c;
                    	}
                    if(objCase.Web_State__c != '' && string.isNotEmpty(objCase.Web_State__c)){     
                        objAccount.ShippingState = objCase.Web_State__c;
                    	}
                    if(objCase.Web_Zip_Code__c != '' && string.isNotEmpty(objCase.Web_Zip_Code__c)){   
                        objAccount.ShippingPostalCode = objCase.Web_Zip_Code__c;
                    	}
                    if(objCase.Web_Street_Address__c != '' && string.isNotEmpty(objCase.Web_Street_Address__c)){    
                        objAccount.ShippingStreet = objCase.Web_Street_Address__c;  
                    	}
                    if(objCase.SuppliedPhone != '' && string.isNotEmpty(objCase.SuppliedPhone)){    
                        objAccount.Phone = objCase.SuppliedPhone;           
                    	}
                    insert objAccount;
                    
                    objContact.AccountId = objAccount.Id;
                    insert objContact;
                    
                    objCase.ContactId = objContact.Id;
                    objCase.AccountId = objAccount.Id; 
                }
            }
        }
        catch(DMLException ex) {
            
            system.debug('Ex: '+ex.getDmlMessage(0));
        }
        catch(Exception ex) {
            
            system.debug('Ex: '+ex.getMessage());
        }
    }
    
    /**
    @MethodName : onAfterUpdate
    @Param      : Map<Id, Case> mapOldCases - Old case records 
                : Map<Id, Case> mapNewCases - New Case records
    @Description: Identifies if Case's origin has been updated and update related Contacts with Origin value
    **/
    public void onAfterUpdate(Map<Id, Case> mapOldCases, Map<Id, Case> mapNewCases){
        
        Set<Id> setUniqueContacts = new Set<Id>();
        
        for(Case objCase: mapNewCases.values() ) {

            // If Origin for a Case has been updated, fetch the most recent Case updated and 
                // update Case Origin field on Contact as well
            if( ( mapOldCases.get(objCase.Id).Origin != objCase.Origin ) || ( mapOldCases.get( objCase.Id ).ContactId != objCase.ContactId ) ) {
                
                if( String.isNotBlank(objCase.ContactId) && !setUniqueContacts.contains(objCase.ContactId) ) {
                
                    setUniqueContacts.add( objCase.ContactId );
                }
                
                if( String.isNotBlank( mapOldCases.get(objCase.Id).ContactId ) && !setUniqueContacts.contains( mapOldCases.get(objCase.Id).ContactId ) ) {
                
                    setUniqueContacts.add( mapOldCases.get(objCase.Id).ContactId );
                }
                
            }
        }
        
        if( !setUniqueContacts .isEmpty() ) {
        
            updateDeletedContacts( setUniqueContacts );
        }
    }
    
    /**
    @MethodName : onAfterDelete
    @Param      : Map<Id, Case> mapOldCases - Old case records 
    @Description: Update Origin field information on Contact record when a related case has been deleted
    **/
    public void onAfterDelete(Map<Id, Case> mapOldCases){

        Set<Id> setAllContactsWhereCaseDeleted = new Set<Id>();

        // Iterate over to fetch the contact record ids for which the related Case records were deleted
        for(Case objCase: mapOldCases.values() ) {

            setAllContactsWhereCaseDeleted.add(objCase.ContactId);
        }

        if( !setAllContactsWhereCaseDeleted.isEmpty() ) {
        
            updateDeletedContacts(setAllContactsWhereCaseDeleted);
        }
    }
    
    /**
    @MethodName : updateDeletedContacts
    @Param      : Set<Id> setAllContactsWhereCaseDeleted - Set of contacts to remap Origin fields
    @Description: Update Origin field information on Contact record when a related case has been deleted
    **/
    public void updateDeletedContacts( Set<Id> setAllContactsWhereCaseDeleted ) {
        
        Set<Id> setUniqueContacts = new Set<Id>();
        List<Contact> lstContactsToUpdate = new List<Contact>();
        
        // Identify the Cases related to a Contact and update the Origin accordingly
        for(Case objCase: [ Select Id, ContactId, Origin
                             From Case
                             Where ContactId IN: setAllContactsWhereCaseDeleted
                             Order By LastModifiedDate DESC] ) {
            
            // If Origin for a Case has been updated, fetch the most recent Case updated and 
                // update Case Origin field on Contact as well
            if( !setUniqueContacts.contains(objCase.ContactId) && String.isNotBlank(objCase.ContactId) ) {
             
                Contact objContact = new Contact(   Id = objCase.ContactId, 
                                                    Case_Origin__c = objCase.Origin );
                lstContactsToUpdate.add(objContact);
                
                setUniqueContacts.add(objCase.ContactId);
            }
        }

        // If there are any contacts which were not updated during the last iteration
        if( setUniqueContacts.isEmpty() || setAllContactsWhereCaseDeleted.removeAll(setUniqueContacts) ) {
            
            for( Id contactId : setAllContactsWhereCaseDeleted ) {
                
                if( !setUniqueContacts.contains(contactId) ) {
                 
                    Contact objContact = new Contact(   Id = contactId, 
                                                        Case_Origin__c = null );
                    lstContactsToUpdate.add(objContact);
                }
            }
        }
        
        try {
            
            // Update Related Contacts
            if(!lstContactsToUpdate.isEmpty()) {
                
                update lstContactsToUpdate;
            }
        }
        catch(DMLException ex) {
            
            system.debug('Ex: '+ex.getDmlMessage(0));
        }
        catch(Exception ex) {
            
            system.debug('Ex: '+ex.getMessage());
        }
    }
}