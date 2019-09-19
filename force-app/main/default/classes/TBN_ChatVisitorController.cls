global class TBN_ChatVisitorController {

    public Boolean isCapacityFull       {   get; set;   }
    public Boolean isChatAvailable      {   get; set;   }
    public string deploymentId          {   get; set;   }
    public string orgId                 {   get; set;   }
    public string buttonId              {   get; set;   }
    public string LAResourceDomain      {   get; set;   }
    public string LAChatDomain          {   get; set;   }
    public string strCaseRecordTypeId   {   get; set;   }
    public string srtRedirectURL        {   get; set;   }
    
    map<string, string> mapLiveAgentIds = new map<string, string>();
    
    // Constructor
    public TBN_ChatVisitorController() {
        
        
        strCaseRecordTypeId = [Select SobjectType, Name, DeveloperName From RecordType where SobjectType = 'Case' AND DeveloperName = 'General_Inquiry'].Id;
        init();
    }
    
    public void init() {
         
        isCapacityFull = true;
        isChatAvailable = false;

        List<Live_Agent_Ids__c> lstLAIds = Live_Agent_Ids__c.getall().values();

        for(Live_Agent_Ids__c objLAId : lstLAIds){
            
            if(objLAId.Name == 'DeploymentId')
                deploymentId = objLAId.Value__c;
            else if(objLAId.Name == 'OrgId')
                orgId = objLAId.Value__c; 
            else if(objLAId.Name == 'ButtonId')
                buttonId = objLAId.Value__c; 
            else if(objLAId.Name == 'LAResourceDomain')
                LAResourceDomain = objLAId.Value__c;  
            else if(objLAId.Name == 'LAChatDomain')
                LAChatDomain = objLAId.Value__c; 
            else if(objLAId.Name == 'RedirectURL')  
                srtRedirectURL = objLAId.Value__c;  
        }
    }
    
    /**
    @MethodName : checkForAgentsCapacity
    @Param      : None
    @Description:  
    **/
    public void checkForAgentsCapacity() {
        
        ServiceChannel objServiceChannel = [ SELECT Id
                                             FROM ServiceChannel
                                             WHERE DeveloperName = 'sfdc_liveagent'
                                             LIMIT 1];
        
        ServicePresenceStatus objServicePresenceStatus = [   SELECT Id
                                                             FROM ServicePresenceStatus
                                                             WHERE DeveloperName = 'Online'
                                                             LIMIT 1];
                                    
        Map<Id, Integer> mapAgentCapacity = new Map<Id, Integer>();
        
        for(AggregateResult ar: [Select Count(Id) userCapacity, UserId userAgent
                                 From AgentWork 
                                 Where Status = 'Opened'
                                 Group By UserId]) {
        
            mapAgentCapacity.put(String.valueOf(ar.get('userAgent')), Integer.valueOf(ar.get('userCapacity')));
        }
        for(UserServicePresence objPresence: [  SELECT Id, Name, ConfiguredCapacity, IsCurrentState, UserId, ServicePresenceStatusId 
                                                FROM UserServicePresence 
                                                WHERE IsCurrentState = true AND 
                                                        ServicePresenceStatusId = :objServicePresenceStatus.Id]) {
              
              
              if(mapAgentCapacity.isEmpty() || mapAgentCapacity.containsKey(objPresence.UserId)) {
              
                  isCapacityFull = false;
                  break;
              }                                                          
        }
    }
    
    @RemoteAction
    global static Boolean getIsAgentOnline() {
    
        ServiceChannel objServiceChannel = [ SELECT Id
                                             FROM ServiceChannel
                                             WHERE DeveloperName = 'sfdc_liveagent'
                                             LIMIT 1];
        
        ServicePresenceStatus objServicePresenceStatus = [   SELECT Id
                                                             FROM ServicePresenceStatus
                                                             WHERE DeveloperName = 'Online'
                                                             LIMIT 1];

        List<UserServicePresence> lstUserServicePresence = [SELECT Id, Name
                                                            FROM UserServicePresence 
                                                            WHERE IsCurrentState = true AND 
                                                                    ServicePresenceStatusId = :objServicePresenceStatus.Id];
        
        return !lstUserServicePresence.isEmpty();
    }
  
}