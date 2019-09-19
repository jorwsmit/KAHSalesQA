global class TBN_MyAccountsAndContactsController {

   // wrapper list that holds the list of Account/Contact details, where current user is a memeber
   public Integer intTotalCount         { get; set; }   
   
   global String strErrorMessage        { get; set; }
   
   //constructor
   public TBN_MyAccountsAndContactsController() {
       
       init();
   }
   
   // wrapper class which implements comaprable interface to sort Accounts/Contacts
   
   global class AccountsAndContactsWrapper implements Comparable {
       
        public String strAddress        { get; set; }
       
        public AccountsAndContactsWrapper(String strAddress) {
            
            this.strAddress = strAddress;
       }
       
       //Comparable interface it has to implement a method called compareTo()
       public Integer compareTo(Object other) {
        
        String CompareName = other != null ? ((AccountsAndContactsWrapper)other).strAddress : '';
        // use string class compareTo()
        return this.strAddress.toUpperCase().compareTo(CompareName.toUpperCase());
      }
   }
   
    @RemoteAction
    global static List<AccountsAndContactsWrapper> getRecords() {
            
            // list of Wrapper class that holds Account/Contacts to be displayed on page
            List<AccountsAndContactsWrapper> lstAccountsAndContactsToDisplay = new List<AccountsAndContactsWrapper>();
            
            // total of Accounts and contacts where User is member
            Integer intTotalCount;
            // total of Contact wher current User is member
            Integer intContactCount;
            // total of Account where curent User is member
            Integer intAccountCount;
            Integer intContactLimit  = 5000;
            Integer intAccountLimit  = 5000;
            
            List<AggregateResult> resultContact  = [Select count(User__c) total From Contact_Team__c where User__c =: UserInfo.getUserId()];
            List<AggregateResult> resultAccount  = [Select count(UserId) total From AccountTeamMember where UserId =: UserInfo.getUserId()];
        
            intContactCount = Integer.valueOf( resultContact[0].get('total') );
            intAccountCount = Integer.valueOf( resultAccount[0].get('total') );
            
            intTotalCount = intContactCount + intAccountCount;
            system.debug('Total: ' + intTotalCount);
        system.debug('Contact: ' + intContactCount);
        system.debug('Account: ' + intAccountCount);
            // adding a dynamic limit to number of Account/contact to be displayed. Maximum records displayed is 10000
            if(  intTotalCount <= 10000 ) {
                
                if( intContactCount < 5000 &&  intAccountCount > 5000 )
                    intAccountLimit = intAccountCount + ( 5000 - intContactCount );
                else if ( intAccountCount < 5000 && intContactCount > 5000 && intTotalCount <= 10000 )
                    intContactLimit = intContactLimit + ( 5000 - intAccountCount );
                
            }
            else {
                
                 if( intContactCount < 5000 &&  intAccountCount > 5000 )
                    intAccountLimit = 5000 + ( 5000 - intContactCount );
                else if ( intAccountCount < 5000 && intContactCount > 5000 )
                    intContactLimit = 5000 + ( 5000 - intAccountCount );
            }
                
            String strAddressString;
       
       try {
               // Get Contact Teams where the User is member
               for(Contact_Team__c objContactTeam : [ SELECT Contact__c, Contact__r.Name, Contact__r.MailingStreet, Contact__r.MailingCity, Contact__r.Phone, Contact__r.MailingState
                                                      FROM Contact_Team__c 
                                                      WHERE User__c =: UserInfo.getUserId() AND Contact__c != null
                                                      ORDER BY Contact__r.Name ASC
                                                      LIMIT :intContactLimit 
                                                      ]) {
                                                          
                      strAddressString = '';
                      strAddressString = '<a onclick="redirectTosObject(\''+objContactTeam.Contact__c+'\');" style="text-decoration:none;">';
                      strAddressString+= objContactTeam.Contact__r.Name == null?'':objContactTeam.Contact__r.Name+'</a><br/>';
                      strAddressString+= objContactTeam.Contact__r.MailingStreet == null?'':objContactTeam.Contact__r.MailingStreet+'<br/>';
                      strAddressString+= objContactTeam.Contact__r.MailingCity == null?'':objContactTeam.Contact__r.MailingCity+', ';
                      strAddressString+= objContactTeam.Contact__r.MailingState == null?'':objContactTeam.Contact__r.MailingState+'<br/>';
                      strAddressString+= objContactTeam.Contact__r.Phone == null?'':objContactTeam.Contact__r.Phone;
                      
                      lstAccountsAndContactsToDisplay.add( new AccountsAndContactsWrapper( strAddressString ) );      
                            
               }
               
               // get Accounts where current user is member and add fields which is to be displayed to wrapper object
               for(AccountTeamMember objAccountTeamMember : [ SELECT AccountId, Account.Name, Account.ShippingCity, Account.ShippingState, Account.Shippingstreet, Account.Phone 
                                                              FROM AccountTeamMember
                                                              WHERE UserId =: UserInfo.getUserId() AND AccountId != null 
                                                              ORDER BY Account.Name ASC
                                                              LIMIT :intAccountLimit
                                                              ]) {  
                      strAddressString = '';
                      strAddressString = '<a onclick="redirectTosObject(\''+objAccountTeamMember.AccountId+'\');" style="text-decoration:none;">';
                      strAddressString+= objAccountTeamMember.Account.Name == null?'':objAccountTeamMember.Account.Name+'</a><br/>';
                      strAddressString+= objAccountTeamMember.Account.Shippingstreet == null?'':objAccountTeamMember.Account.Shippingstreet+'<br/>';
                      strAddressString+= objAccountTeamMember.Account.ShippingCity == null?'':objAccountTeamMember.Account.ShippingCity+', ';
                      strAddressString+= objAccountTeamMember.Account.ShippingState == null?'':objAccountTeamMember.Account.ShippingState+'<br/>';
                      strAddressString+= objAccountTeamMember.Account.Phone == null?'':objAccountTeamMember.Account.Phone;
                      
                      lstAccountsAndContactsToDisplay.add( new AccountsAndContactsWrapper( strAddressString ) );   
               }
               
               lstAccountsAndContactsToDisplay.sort();
               
               return lstAccountsAndContactsToDisplay;
           }
           catch(Exception ex) {
               
               //strErrorMessage = ex.getmessage();
               system.debug('===='+ex.getmessage());
               return null;
           }
    }
    
    private void init() {
        
        try
        {
            strErrorMessage = '';
            intTotalCount = getRecordCount();
        }
        catch(Exception ex){
            
            strErrorMessage = ex.getmessage();
        }
        
    }
    
     // method to calculate total accounts/contacts where the user is member
    private Integer getRecordCount() {
        
        Integer intContactCount;
        Integer intAccountCount;
        
        List<AggregateResult> resultContact  = [Select count(User__c) total From Contact_Team__c where User__c =: UserInfo.getUserId()];
        List<AggregateResult> resultAccount  = [Select count(UserId) total From AccountTeamMember where UserId =: UserInfo.getUserId()];
        
        intContactCount = Integer.valueOf( resultContact[0].get('total') );
        intAccountCount = Integer.valueOf( resultAccount[0].get('total') );
        
        return  intContactCount + intAccountCount;
    }
}