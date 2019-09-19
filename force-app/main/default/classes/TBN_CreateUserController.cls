/**
@ClassName    : TBN_CreateUserController 
@CreatedOn    : 26/11/2015
@ModifiedBy   : Rashmi
@Description  : Controller logic for Create User Page
*/
public with sharing class TBN_CreateUserController {
    
    public User objUser                 {   get; set;   }
    public boolean isSuccess            {   get; set;   }
    public TBN_CreateUserController()
    {
        isSuccess= false;
        objUser = new User();
    }
    public void CreateNewUserRecord()
    {
        try{
            insert objUser;
            isSuccess = true;
        }
        catch(exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'UserName already exits in the org. Please try with other UserName'));
        }
        
    }
}