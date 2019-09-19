public class TBN_LandingPageController {
    
    public S2_custom_permissions__c objS2CustomPermissions 		    {   get; set;   }
    public boolean isS2Available									{	get; set;	}
    
    // Constructor
    public TBN_LandingPageController() {
        
        fetchUserPermissions();
    }
    
    /**
    @MethodName : fetchUserPermissions
    @Param      : None
    @Description: Fetch the accesses set for the current user from Custom Settings
    **/
    public void fetchUserPermissions() {
        
        // Landing Page CS configured which is used to determine current logged in user's access to VF pages
        objS2CustomPermissions = S2_custom_permissions__c.getInstance(UserInfo.getProfileId().substring(0,15));
        if(objS2CustomPermissions == null)
        	isS2Available= true;
        else
        	isS2Available = objS2CustomPermissions.S2_Available__c;	
    }
}