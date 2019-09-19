/**
@ClassName    : TBN_PostChatVisitorFormController
@CreatedOn    : 06/01/2017
@ModifiedBy   : Ritika
@Description  : 
                
**/
public class TBN_PostChatVisitorFormController {
    
    public string srtRedirectURL        {   get; set;   }
    public boolean strIsAgent           {   get; set;   }
    
    //constructor
    public TBN_PostChatVisitorFormController(){
        
        strIsAgent = false;
        List<Live_Agent_Ids__c> lstLiveAgentParams = [Select Name, Value__c from Live_Agent_Ids__c where Name = 'RedirectURL' LIMIT 1];
        srtRedirectURL = lstLiveAgentParams[0].Value__c;
    }
    
    /**
    @MethodName : 
    @Param      : 
    @Description: 
    **/
    public PageReference fetchPresences() {
        
        PageReference pr;
        
        ServiceChannel objServiceChannel = [ SELECT Id
                                             FROM ServiceChannel
                                             WHERE DeveloperName = 'sfdc_liveagent'
                                             LIMIT 1];
        
        ServicePresenceStatus objServicePresenceStatus = [   SELECT Id
                                                             FROM ServicePresenceStatus
                                                             WHERE DeveloperName = 'Online'
                                                             LIMIT 1];
                                    
        Map<Id, UserServicePresence> mapUserPresences = new Map<Id, UserServicePresence>();
        
        for(UserServicePresence objPresence: [  SELECT Id, Name, ConfiguredCapacity, IsCurrentState, UserId, ServicePresenceStatusId
                                                FROM UserServicePresence 
                                                WHERE IsCurrentState = true AND 
                                                        ServicePresenceStatusId = :objServicePresenceStatus.Id]) {
              
              
            //if(objPresence.Capacity < objPresence.ConfiguredCapacity)
                mapUserPresences.put(objPresence.UserId, objPresence);
        }
        
        if(mapUserPresences.isEmpty()) {
            
            pr = new PageReference(srtRedirectURL);
            pr.setRedirect(true);
            return pr;
        }
        else {
            
            String strChatKey = ApexPages.currentPage().getParameters().get('disconnectedBy');
            
            if(strChatKey == 'agent')
                strIsAgent = true;
                
            
            // If the chat has been timed out by client, disconnected by agent, interrupted by some error or 
                // no agents are available to attend the chat -> redirect the user to W2C form
            if( strChatKey == 'clientIdleTimeout' || 
                    strChatKey == 'error' || strChatKey == 'agentsUnavailable') {
            
                pr = new PageReference(srtRedirectURL);
                pr.setRedirect(true);
                return pr;
            }
        }
        
        return null;
    }
}