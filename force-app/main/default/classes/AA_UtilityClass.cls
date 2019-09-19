global without sharing class AA_UtilityClass{
	
	global static list<Profile> pFiles = [SELECT ID, Name FROM Profile];
		
	global static list<RecordType> typeList = [SELECT ID, DeveloperName FROM RecordType WHERE 
																						(sObjectType = 'Contact' AND (developerName = 'Contact_KRS' OR developerName = 'Individual' OR developerName = 'contactTemp' OR developerName = 'HD_Physicians' OR developerName = 'General_Contact')) 
																						OR 
																						(sObjectType = 'Event' AND DeveloperName = 'KRS_Standard_Event') 
																						OR 
																						(sObjectType = 'Account' AND (DeveloperName = 'HD_Accounts' OR DeveloperName = 'KRS_Standard_Account' OR DeveloperName = 'Center' OR developerName = 'Household' OR DeveloperName = 'Referring_Facility_Child' OR DeveloperName = 'accountLacTemp' OR DeveloperName = 'PF_Chain' OR DeveloperName = 'PF_Client'))
																						OR
																						(sObjectType = 'Lead' AND (DeveloperName = 'KRS_SRS_Lead' OR DeveloperName = 'KRS_HRS_Lead'))
																						OR
																						(sObjectType = 'Task' AND (DeveloperName = 'Partner_First_Task' OR DeveloperName = 'KRS_Standard_Task'))
																						OR
																						(sObjectType = 'Sales_Performance__c' and (DeveloperName = 'KAH' or DeveloperName = 'Legacy'))
																						OR
																						(sObjectType = 'Opportunity' AND DeveloperName = 'SRS')
																						OR
																						(sObjectType = 'Case' AND (DeveloperName = 'Referral' OR DeveloperName = 'General_Inquiry' OR DeveloperName = 'caseTemp' OR DeveloperName = 'AfterHours'))
																						OR 
																						(sObjectType = 'Patient_New__c' AND (DeveloperName = 'patientTemp' OR DeveloperName = 'patientValid'))
																						OR
																						(sObjectType = 'Assessment__c' AND (DeveloperName = 'assessmentTemp' OR DeveloperName = 'assessmentValid'))
																						];
																						
	global static list<User> usrList = [SELECT ID, Name FROM User WHERE (Name = 'Cheryl Land' OR Name = 'Jen Humphrey' OR Name = 'Brad Miner' OR Name = 'Jerry Novickas')];
	
	global static list<Unit__c> activeUnits = [SELECT ID, Name FROM Unit__c WHERE Active__c = true];
	
	global static list<Unit__c> inactiveUnits = [SELECT ID, Name FROM Unit__c WHERE Active__c = false];
	
	global static list<HRS_BDO_Territory__c> hBDOs = [SELECT ID, HRS_BDO__c, Outside_US_Territories__c, US_Territories__c FROM HRS_BDO_Territory__c];
  	global static list<SRS_BDO_Territory__c> sBDOs = [SELECT ID, SRS_BDO__c, Role__c, States__c, CT_VP__c FROM SRS_BDO_Territory__c];
  
	global static list<SRS_BDO_Territory__c> bdos = [SELECT ID, SRS_BDO__c, SRS_BDO__r.Name FROM SRS_BDO_Territory__c];
	
	global static id uIDRon = [SELECT ID FROM User WHERE Name =: 'Ron Kilgore'].ID;
  	global static id uIDErika = [SELECT ID FROM User WHERE Name =: 'Erika Bantz'].ID;
	
	global static ID hrsDefaultUser = [SELECT ID, Name FROM User WHERE Name = 'Nicholas Talsma'].ID;
	
	global static ID srsDefaultUser = [SELECT ID, Name FROM User WHERE Name = 'Jerry Novickas'].ID;
	
	global static ID FlosumUser = [SELECT ID, Name FROM User WHERE Name = 'Flosum Integration User'].ID;
	
	global static ID crmFusionDefaultUser = [SELECT ID, Name FROM User WHERE Name = 'Charles Cox'].ID;
	
	global static id inactiveRole = [SELECT ID, Name FROM UserRole WHERE Name = 'Inactive Users'].ID;
	
	global static list<UserRole> rList = [SELECT ID, Name FROM UserRole];
	
	//Begin General System Gets
	public static ID getFlosumUser{
		get{
			ID defaultFlosumUser = FlosumUser;
			return defaultFlosumUser;
			}
		set;	
		}
	
	public static ID getCRMFusionID{
		get{
			ID crmFusionUser = crmFusionDefaultUser;
			return crmFusionUser;
			}
		set;
		}
	
  	public static ID getCenterID{
  		get{
  			ID centerAccount;
  			for(recordType rt: typeList){
  				if(rt.developerName == 'Center'){
  					centerAccount = rt.ID;
  					}		
  				}
  				return centerAccount;
  			}
  		set;	
  		}
  	
  	public static ID getInactiveID{
		get{
			id inactiveProfileID;
			for(Profile up : pFiles){
    			if(up.Name == 'Inactive Profile'){
    				inactiveProfileID = up.ID;
    				}				
    			}
    			return inactiveProfileID;
			}
		set;
		}				
	
	public static map<ID, string> getProfileMap{
		get{
			map<ID, string> profileMap = new map<ID, string>();
			for(Profile up : pFiles){
    			profileMap.put(up.ID, up.Name);
				}
			return profileMap;
			}
		set;	
		}
	
	public static map<ID,String> getRoleMap{
    	get{
    		map<ID, string> roleMap = new map<ID, string>();
    		for(UserRole ur : rList){
    			roleMap.put(ur.ID, ur.Name);
    			}
    		return roleMap;	
    		}
    	set;	
		}
	
	public static id getInactiveRoleID{
		get{
			ID inactiveRoleId = inactiveRole;
			return inactiveRoleId;
			}
		set;	
		}
	
	public static ID getSysAdminID{
		get{
			ID sysAdmin;
			for(Profile up : pFiles){
    		if(up.Name == 'System Administrator'){
    			sysAdmin = up.ID;
    			}
    		}
    		return sysAdmin;	
			}
		set;
		}
	
	public static list<ID> getAllHDProfileIDs{
		get{
			list<ID> hdProfiles = new list<ID>();
			for(Profile up : pFiles){
    			if(up.Name == 'Sales: HD Associate' || up.Name == 'Sales: HD Associate Redesign' || up.Name == 'Sales: HD Manager' || up.Name == 'Sales: HD Manager Redesign' || up.Name == 'Sales: HD PAC' || up.Name == 'Sales: HD PAC Redesign' || up.Name == 'Sales: HD Trainer' || up.Name == 'Sales - HD Admin'){
    				hdProfiles.add(up.ID);
    				}
    			}
			return hdProfiles;
			}
		set;
		}
	
	public static list<ID> getAllSTDKAHProfileIDs{
		get{
			list<ID> kahProfiles = new list<ID>();
			for(Profile up : pFiles){
    			if(up.Name == 'KAH Corporate Sales' || up.Name == 'Sales: KAH Associate' || up.Name == 'Sales: KAH Manager' || up.Name == 'Sales: KAH Market Manager' || up.Name == 'Sales - KAH Admin'){
    				kahProfiles.add(up.ID);
    				}
    			}
			return kahProfiles;
			}
		set;
		}
	
	public static list<ID> getAllBDKAHProfileIDs{
		get{
			list<ID> kahProfiles = new list<ID>();
			for(Profile up : pFiles){
    			if(up.Name == 'Sales: KAH Bus Dev'){
    				kahProfiles.add(up.ID);
    				}
    			}
			return kahProfiles;
			}
		set;
		}
	
	public static list<ID> getAllLacunaProfileIDs{
		get{
			list<ID> lacProfiles = new list<ID>();
			for(Profile up : pFiles){
    			if(up.Name.contains('Contact Center')){
    				lacProfiles.add(up.ID);
    				}
    			}
			return lacProfiles;
			}
		set;
		}
		
	public static list<ID> getAllRHCProfileIDs{
		get{
			list<ID> rhcProfiles = new list<ID>();
			for(Profile up : pFiles){
    			if(up.Name == 'RHC Ops: ADO' || up.Name == 'RHC Ops: Manager' || up.Name == 'RHC: CPS User' || up.Name == 'RHC: Read Only' || up.Name == 'PF/KRS Support'){
    				rhcProfiles.add(up.ID);
    				}
    			}
			return rhcProfiles;
			}
		set;
		}
		
	public static list<ID> getAllKRSProfileIDs{
		get{
			list<ID> rhcProfiles = new list<ID>();
			for(Profile up : pFiles){
    			if(up.Name.contains('KRS') && !up.Name.contains('PF/KRS Support')){
    				rhcProfiles.add(up.ID);
    				}
    			}
			return rhcProfiles;
			}
		set;
		}
		
	public static list<RecordType> getKAHAccountTypes{
		get{
			list<RecordType> accountTypes = new list<RecordType>();
			accountTypes = [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account' AND (DeveloperName = 'Referring_Facility_Child')];
			return accountTypes;
			}
		set;	
		}
		
	public static list<RecordType> getKAHBDAccountTypes{
		get{
			list<RecordType> accountTypes = new list<RecordType>();
			accountTypes = [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account' AND (DeveloperName = 'Sales_KAH_BD')];
			return accountTypes;
			}
		set;	
		}
		
	public static list<RecordType> getRHCAccountTypes{
		get{
			list<RecordType> accountTypes = new list<RecordType>();
			accountTypes = [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account' AND (DeveloperName = 'PF_Chain' OR DeveloperName = 'PF_Client')];
			return accountTypes;
			}
		set;	
		}
		
	public static list<ID> getRHCAccountTypeIDs{
		get{
			list<ID> accountIDs = new list<ID>();
			for(RecordType rt: [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account' AND (DeveloperName = 'PF_Chain' OR DeveloperName = 'PF_Client')]){
				accountIDs.add(rt.ID);
				}
			return accountIDs;	
			}
		set;	
		}	
	
	public static list<RecordType> getLACAccountTypes{
		get{
			list<RecordType> accountTypes = new list<RecordType>();
			accountTypes = [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account' AND (DeveloperName = 'Household')];
			return accountTypes;
			}
		set;	
		}	
										
	public static list<RecordType> getKRSAccountTypes{
		get{
			list<RecordType> accountTypes = new list<RecordType>();
			accountTypes = [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account' AND (DeveloperName = 'KRS_Standard_Account')];
			return accountTypes;
			}
		set;	
		}
	
	public static list<RecordType> getHDAccountTypes{
		get{
			list<RecordType> accountTypes = new list<RecordType>();
			accountTypes = [SELECT ID, Name, Description FROM RecordType WHERE sObjectType = 'Account' AND (DeveloperName = 'HD_Accounts' OR DeveloperName = 'Sales_HD_Account')];
			return accountTypes;
			}
		set;	
		}	
	
	//Begin HD/NCD Gets
	public static ID getHDAdminProfileID{
		get{
			ID sysId;
			for(Profile up : pFiles){
    			if(up.Name == 'Sales - HD Admin'){
    				sysId = up.ID;
    				}
    			}
    			return sysId;
			}		
		set;
		}
		
	public static ID getHdAssociate{
		get{
			id hdAssociate;
			for(Profile p : pFiles){
  				if(p.Name == 'Sales: HD Associate'){
  					hdAssociate = p.ID;		
  					} 
			}
			return hdAssociate;
			}
		set;
		}
	
	public static ID getNcdAssociate{
		get{
			id ncdAssociate;
			for(Profile p : pFiles){
  				if(p.Name == 'Sales: NCD Associate'){
  					ncdAssociate = p.ID;		
  					} 
			}
			return ncdAssociate;
			}
		set;	
		}
	
    public static ID getNewHDID{
  		get{
  			ID newHDAccount;
  			for(recordType rt: typeList){
  				if(rt.developerName == 'HD_Accounts'){
  					newHDAccount = rt.ID;
  					}
  				}
  			return newHDAccount;
  			}
  		set;	
  		}
  		
  	public static ID getHDAssociateID{
		get{
			ID SALES_HD_Associate;
			for(Profile up : pFiles){
    		if(up.Name == 'Sales: HD Associate'){
    			SALES_HD_Associate = up.ID;
    			}
			}
			return SALES_HD_Associate;
			}
		set;
		}
		
	public static ID getNCDAssociateID{
		get{
			ID SALES_NCD_Associate;
			for(Profile up : pFiles){
    		if(up.Name == 'Sales: NCD Associate'){
    			SALES_NCD_Associate = up.ID;
    			}
    		}
    		return SALES_NCD_Associate;	
			}
		set;
		}
		
	public static ID getHDLibraryID{
		get{
			ID hdLib = getHDLibraryID;
			return hdLib;
			}
			set;		
		}
	
	public static boolean getHDiPathSwitch{
		get{
			boolean hdConverted;
			try{
				hdConverted = boolean.valueOf([SELECT Configuration_Value__c FROM IPathConfig__c WHERE Name = 'HD_CONVERTED'].Configuration_Value__c);
				}
			catch(Exception E){
				system.debug('Test Class');
				}	
			boolean hdConvertedValue = hdConverted;
			return hdConvertedValue;
			}
		set;
		}
		
	public static ID getHDPhysicianID{
		get{
			ID hdPhysType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'HD_Physicians'){
   					hdPhysType = rt.ID;
   					}	
   				}
   			return hdPhysType;
			}
		set;	
		}			
  	
  	//Begin HD Unit Gets
	public static list<Unit__c> getUnitList{
		get{
			list<Unit__c> uList = new list<Unit__c>();
			uList = activeUnits;
			return uList;
			}
		set;
		}
	
	public static list<ID> getActiveUnitIDList{
		get{
			list<ID> uList = new list<ID>();
			for(Unit__c u : activeUnits){
				uList.add(u.ID);
				}
			return uList;
			}
		set;
		}
		
	public static list<ID> getInactiveUnitIDList{
		get{
			list<ID> uList = new list<ID>();
			for(Unit__c u : inactiveUnits){
				uList.add(u.ID);
				}
			return uList;
			}
		set;
		}	
	
	//Begin Lacuna/Contact Center Group Gets
	public static ID getindvCtc{
  		get{
  			id indvCtc;
  			for(RecordType rt: typeList){
  				if(rt.developerName == 'Individual'){
  					indvCtc = rt.ID;
  					}
  				}
  				return indvCtc;
  			}
  		set;
  		}
  	
  public static ID gethouseAcc{
  	get{
  		id houseAcc;
  		for(RecordType rt: typeList){
  			if(rt.developerName == 'Household'){
  				houseAcc = rt.ID;
  				}
  			}
  			return houseAcc;
  		}
  	set;
  	}
  
  public static ID gettempContact{
  	get{
  		id tempContact;
  		for(RecordType rt: typeList){
  			if(rt.developerName == 'contactTemp'){
  				tempContact = rt.ID;
  				}
  			}
  			return tempContact;
  		}
  	set;
  	} 
    
    public static ID getPatientTempID{
		get{
			ID ptRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'patientTemp'){
   					ptRefType = rt.ID;
   					}	
   				}
   			return ptRefType;
			}
		set;	
		}
		
	public static ID getAssessmentTempID{
		get{
			ID assmRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'assessmentTemp'){
   					assmRefType = rt.ID;
   					}	
   				}
   			return assmRefType;
			}
		set;	
		}
		
	public static ID getPatientValidID{
		get{
			ID ptRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'patientValid'){
   					ptRefType = rt.ID;
   					}	
   				}
   			return ptRefType;
			}
		set;	
		}
		
	public static ID getAssessmentValidID{
		get{
			ID assmRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'assessmentValid'){
   					assmRefType = rt.ID;
   					}	
   				}
   			return assmRefType;
			}
		set;	
		}
		
	public static ID getAccountTempID{
		get{
			ID accRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'accountLacTemp'){
   					accRefType = rt.ID;
   					}	
   				}
   			return accRefType;
			}
		set;	
		}
	
	
	public static list<RecordType> getCaseTypeList{
		get{
			list<RecordType> caseTypeList;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'AfterHours' || rt.DeveloperName == 'General_Inquiry'){
   					caseTypeList.add(rt);
   					}	
   				}
   			return caseTypeList;
			}
		set;	
		}
	
	public static ID getCaseTempID{
		get{
			ID caseRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'caseTemp'){
   					caseRefType = rt.ID;
   					}	
   				}
   			return caseRefType;
			}
		set;	
		}
	
	public static ID getCaseReferralID{
		get{
			ID caseRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'Referral'){
   					caseRefType = rt.ID;
   					}	
   				}
   			return caseRefType;
			}
		set;	
		}
		
	public static ID getCaseAfterHoursID{
		get{
			ID caseRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'AfterHours'){
   					caseRefType = rt.ID;
   					}	
   				}
   			return caseRefType;
			}
		set;	
		}	
	
	public static ID getCaseInquiryID{
		get{
			ID caseRefType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'General_Inquiry'){
   					caseRefType = rt.ID;
   					}	
   				}
   			return caseRefType;
			}
		set;	
		}
    
    public static ID getContactCenterProfile{
    		get{
    			ID contactCenterProfile;
    		for(Profile p : pFiles){
  				if(p.Name == 'Contact Center Representative'){
  					contactCenterProfile = p.ID;		
  					}
  					}
  				return contactCenterProfile;	
    			}
    		set;
    	}	
    
    //Begin KHRS Group Gets
    public static list<HRS_BDO_Territory__c> getHRSBDO{
		get{
			list<HRS_BDO_Territory__c> hList = new list<HRS_BDO_Territory__c>();
			hList = hBDOs;
			return hList;
			}
		set;
		}
		
	public static list<SRS_BDO_Territory__c> getSRSBDO{
		get{
			list<SRS_BDO_Territory__c> sList = new list<SRS_BDO_Territory__c>();
			sList = sBDOs;
			return sList;
			}
		set;
		}
	
	public static map<String, ID> getSRSInfo{
		get{
			map <String, ID> info = new map<String, ID>();
			for(SRS_BDO_Territory__c sbt : bdos){
  				info.put(sbt.SRS_BDO__r.Name, sbt.SRS_BDO__c);
    			}
    		return info;
			}
		set;
		}
	
	public static ID getSRSOpporunityID{
		get{
			ID srsType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'SRS'){
   					srsType = rt.ID;
   					}	
   				}
   			return srsType;
			}
		set;	
		}
	
	public static ID getKRSStandardID{
  		get{
  			ID srsAccount;
  			for(recordType rt: typeList){
  				if(rt.developerName == 'KRS_Standard_Account'){
  				srsAccount = rt.ID;
  				}
  				}
  			return srsAccount;
  			}
  		set;	
  		}	
    
    public static ID getkrsContact{
		get{
			id krsContact;
			for(RecordType rt: typeList){
  				if(rt.developerName == 'Contact_KRS'){
  					krsContact = rt.ID;
  					}
  				}
  				return krsContact;
			}
		set;
		}
    
    public static ID getkrsEvent{
  	get{
  		id krsEvent;
  		for(RecordType rt: typeList){
  			if(rt.developerName == 'KRS_Standard_Event'){
  				krsEvent = rt.ID;
  				}
  			}
  			return krsEvent;
  		}
  	set;
  	}
    
    public static ID getHRSDefault{
		get{
			ID hrsDefault = hrsDefaultUser;
			return hrsDefault;
			}
		set;	
		}
		
	public static ID getSRSDefault{
		get{
			ID srsDefault = srsDefaultUser;
			return srsDefault;
			}
		set;	
		}	
	
	public static ID getHRSLead{
		get{
			id hrsLead;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'KRS_HRS_Lead'){
   					hrsLead = rt.ID;
   					}	
   				}
   			return hrsLead;	
			}
		set;
		}
		
	public static ID getSRSLead{
		get{
			id srsLead;
		for(RecordType rt: typeList){
			if(rt.DeveloperName == 'KRS_SRS_Lead'){
   					srsLead = rt.ID;
   					}
			}
			return srsLead;
			}
			set;
		}	
	
	public static ID getKRSTask{
		get{
			id krsTask;
			for(RecordType rt: typeList){
			if(rt.DeveloperName == 'KRS_Standard_Task'){
   					krsTask = rt.ID;
   					}
			}
			return krsTask;
			}
		set;	
		}
	
	public static ID getRon{
		get{
		ID idRon = uIDRon;
		return idRon; 	
		}
		set;
		}
	
	public static ID getErika{
		get{
		ID idErika = uIDErika;
		return idErika;	
		}
		set;
		}
    
    public static ID getKRSSRSSupportID{
		get{
			ID srsSupport;
			for(Profile up : pFiles){
    		if(up.Name == 'KRS: SRS Support Admin'){
    			srsSupport = up.ID;
    			}
    		}
    		return srsSupport;	
			}
		set;
		}
		
	public static ID getKRSSRSAdminID{
		get{
			ID srsSupport;
			for(Profile up : pFiles){
    		if(up.Name == 'KRS: SRS Admin'){
    			srsSupport = up.ID;
    			}
    		}
    		return srsSupport;	
			}
		set;
		}
    
    public static list<ID> getKRSProfiles{
    		get{
    			list<ID> krsProfiles = new list<ID>();
    		for(Profile p : pFiles){
  				if(p.Name == 'KRS: SRS Admin' || p.Name == 'KRS: SRS Support Admin' || p.Name == 'System Administrator'){
  					krsProfiles.add(p.ID);		
  					}
  					}
  				return krsProfiles;	
    			}
    		set;
    	}
    
    public static list<ID> getKRSNoDeleteProfiles{
    		get{
    			list<ID> krsNoDeleteProfiles = new list<ID>();
    		for(Profile p : pFiles){
  				if(p.Name == 'KRS: SRS Finance' || p.Name == 'KRS: SRS User'){
  					krsNoDeleteProfiles.add(p.ID);		
  					}
  					}
  				return krsNoDeleteProfiles;	
    			}
    		set;
    	}
    	
    public static list<ID> getNonKRSAdmins{
    	get{
    		list<ID> krsNonAdmins = new list<ID>();
    		for(Profile p: pFiles){
    			if(p.Name == 'KRS: Read Only' || p.Name == 'KRS: SRS Finance' || p.Name == 'KRS: SRS User'){
  					krsNonAdmins.add(p.ID);		
  					}	
    			}
    		return krsNonAdmins;
    		}
    	set;
    }	
    
    public static list<ID> getKRSUSers{
    	get{
    		list<ID> krsUsers = new list<ID>();
    		for(User u : usrList){
  				krsUsers.add(u.ID);
  				}
  				return krsUsers;
    		}
    	set;
    }
    
    public static list<Account> getSRSAthroughL{
		get{
			list<Account> srsAccount = [SELECT ID, 
								  			   Name 
						   				FROM Account 
								   		WHERE RecordTypeID =: getKRSStandardID 
						   				AND KRS_RHB_Business_Unit__c = 'SRS' AND Name > 'A' AND Name < 'L'];
			return srsAccount;
			}
			set;		
		}
		
	public static list<Account> getSRSMthroughS{
		get{
			list<Account> srsAccount = [SELECT ID, 
								  			   Name 
						   				FROM Account 
								   		WHERE RecordTypeID =: getKRSStandardID 
						   				AND KRS_RHB_Business_Unit__c = 'SRS' AND Name > 'M' AND Name < 'S'];
			return srsAccount;
			}
			set;		
		}
		
	public static list<Account> getSRSSthroughZ{
		get{
			list<Account> srsAccount = [SELECT ID, 
								  			   Name 
						   				FROM Account 
								   		WHERE RecordTypeID =: getKRSStandardID 
						   				AND KRS_RHB_Business_Unit__c = 'SRS' AND Name > 'S'];
			return srsAccount;
			}
			set;		
		}
    
    //Begin RHC/KHRS Gets
    public static ID getPFTask{
		get{
			ID pfTask;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'Partner_First_Task'){
   					pfTask = rt.ID;
   					}	
   				}
			return pfTask;
			}
		set;	
		}
		
	public static list<ID> getRHCAccIDs{
		get{
			list<ID> rhcAccIDs = new list<ID>();
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'PF_Chain' || rt.DeveloperName == 'PF_Client'){
   					rhcAccIDs.add(rt.ID);
   					}
				}
				return rhcAccIDs;
			}
		set;
		}	
    
    //Begin KAH Gets
	public static ID getKAHAccountID{
		get{
			ID kahAccount;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'Referring_Facility_Child'){
   					kahAccount = rt.ID;
   					}	
   				}
   			return kahAccount;
			}
		set;		
		}
	
	public static list<ID> getKAHProfileIDs{
		get{
			list<ID> kahIds = new list<ID>();
			for(Profile up : pFiles){
    			if(up.Name == 'Sales: KAH Associate' || up.Name == 'Sales: KAH Market Manager' || up.Name == 'Sales: KAH Manager'){
    				kahIDs.add(up.ID);
    				}
    			}
    			return kahIDs;
			}
		set;	
		}
	
	public static ID getKAHContactID{
		get{
			ID kahType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'General_Contact'){
   					kahType = rt.ID;
   					}	
   				}
   			return kahType;	
			}
		set;	
		}
	
	public static ID getKAHSalesPerfID{
		get{
			ID kahType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'KAH'){
   					kahType = rt.ID;
   					}	
   				}
   			return kahType;	
			}
		set;	
		}
		
	public static ID getLegacySalesPerfID{
		get{
			ID legacyType;
			for(RecordType rt: typeList){
   				if(rt.DeveloperName == 'Legacy'){
   					legacyType = rt.ID;
   					}	
   				}
   			return legacyType;
			}
		set;	
		}	
	
	public static ID getKAHAssociateID{
		get{
			ID SALES_KAH_ASSOCIATE;
			for(Profile up : pFiles){
    			if(up.Name == 'Sales: KAH Associate'){
    				SALES_KAH_ASSOCIATE = up.ID;
    				}
    			}
    		return SALES_KAH_ASSOCIATE;		
			}
		set;
		}
	
	public static ID getKAHMarketManagerID{
		get{
			id SALES_KAH_Market_Manager;
			for(Profile up : pFiles){
    			if(up.Name == 'Sales: KAH Market Manager'){
    				SALES_KAH_Market_Manager = up.ID;
    				}
				}
			return SALES_KAH_Market_Manager;	
		}
		set;
		}
		
	public static ID getKAHAdminAccount{
		get{
			ID unassignedAdminAccount;
			try{
				unassignedAdminAccount = [SELECT ID FROM Account WHERE Name = 'Unassigned Account - Admin Maintenance'].ID;
				}
			catch(Exception E){
				if(test.isRunningTest()){
					Account a = new Account(Name = 'Unassigned Account - Admin Maintenance');
					insert a;
					unassignedAdminAccount = a.ID;
					}
				}	
			return unassignedAdminAccount;
			}
		set;	
		}	
    
    //Begin Error Correct Methods
    public static String removeDiacritics(String text){
        for (String letter : patterns.keySet())
            text = text.replaceAll(patterns.get(letter), letter);
        return text;
    	}
    	
    static Map<String, String> patterns = new Map<String, String>{
        'A' => '[\u0041\u24B6\uFF21\u00C0\u00C1\u00C2\u1EA6\u1EA4\u1EAA\u1EA8\u00C3\u0100\u0102\u1EB0\u1EAE\u1EB4\u1EB2\u0226\u01E0\u00C4\u01DE\u1EA2\u00C5\u01FA\u01CD\u0200\u0202\u1EA0\u1EAC\u1EB6\u1E00\u0104\u023A\u2C6F]',
        'AA' => '[\uA732]',
        'AE' => '[\u00C6\u01FC\u01E2]',
        'AO' => '[\uA734]',
        'AU' => '[\uA736]',
        'AV' => '[\uA738\uA73A]',
        'AY' => '[\uA73C]',
        'B' => '[\u0042\u24B7\uFF22\u1E02\u1E04\u1E06\u0243\u0182\u0181]',
        'C' => '[\u0043\u24B8\uFF23\u0106\u0108\u010A\u010C\u00C7\u1E08\u0187\u023B\uA73E]',
        'D' => '[\u0044\u24B9\uFF24\u1E0A\u010E\u1E0C\u1E10\u1E12\u1E0E\u0110\u018B\u018A\u0189\uA779]',
        'DZ' => '[\u01F1\u01C4]',
        'Dz' => '[\u01F2\u01C5]',
        'E' => '[\u0045\u24BA\uFF25\u00C8\u00C9\u00CA\u1EC0\u1EBE\u1EC4\u1EC2\u1EBC\u0112\u1E14\u1E16\u0114\u0116\u00CB\u1EBA\u011A\u0204\u0206\u1EB8\u1EC6\u0228\u1E1C\u0118\u1E18\u1E1A\u0190\u018E]',
        'F' => '[\u0046\u24BB\uFF26\u1E1E\u0191\uA77B]',
        'G' => '[\u0047\u24BC\uFF27\u01F4\u011C\u1E20\u011E\u0120\u01E6\u0122\u01E4\u0193\uA7A0\uA77D\uA77E]',
        'H' => '[\u0048\u24BD\uFF28\u0124\u1E22\u1E26\u021E\u1E24\u1E28\u1E2A\u0126\u2C67\u2C75\uA78D]',
        'I' => '[\u0049\u24BE\uFF29\u00CC\u00CD\u00CE\u0128\u012A\u012C\u0130\u00CF\u1E2E\u1EC8\u01CF\u0208\u020A\u1ECA\u012E\u1E2C\u0197]',
        'J' => '[\u004A\u24BF\uFF2A\u0134\u0248]',
        'K' => '[\u004B\u24C0\uFF2B\u1E30\u01E8\u1E32\u0136\u1E34\u0198\u2C69\uA740\uA742\uA744\uA7A2]',
        'L' => '[\u004C\u24C1\uFF2C\u013F\u0139\u013D\u1E36\u1E38\u013B\u1E3C\u1E3A\u0141\u023D\u2C62\u2C60\uA748\uA746\uA780]',
        'LJ' => '[\u01C7]',
        'Lj' => '[\u01C8]',
        'M' => '[\u004D\u24C2\uFF2D\u1E3E\u1E40\u1E42\u2C6E\u019C]',
        'N' => '[\u004E\u24C3\uFF2E\u01F8\u0143\u00D1\u1E44\u0147\u1E46\u0145\u1E4A\u1E48\u0220\u019D\uA790\uA7A4]',
        'NJ' => '[\u01CA]',
        'Nj' => '[\u01CB]',
        'O' => '[\u004F\u24C4\uFF2F\u00D2\u00D3\u00D4\u1ED2\u1ED0\u1ED6\u1ED4\u00D5\u1E4C\u022C\u1E4E\u014C\u1E50\u1E52\u014E\u022E\u0230\u00D6\u022A\u1ECE\u0150\u01D1\u020C\u020E\u01A0\u1EDC\u1EDA\u1EE0\u1EDE\u1EE2\u1ECC\u1ED8\u01EA\u01EC\u00D8\u01FE\u0186\u019F\uA74A\uA74C]',
        'OI' => '[\u01A2]',
        'OO' => '[\uA74E]',
        'OU' => '[\u0222]',
        'P' => '[\u0050\u24C5\uFF30\u1E54\u1E56\u01A4\u2C63\uA750\uA752\uA754]',
        'Q' => '[\u0051\u24C6\uFF31\uA756\uA758\u024A]',
        'R' => '[\u0052\u24C7\uFF32\u0154\u1E58\u0158\u0210\u0212\u1E5A\u1E5C\u0156\u1E5E\u024C\u2C64\uA75A\uA7A6\uA782]',
        'S' => '[\u0053\u24C8\uFF33\u1E9E\u015A\u1E64\u015C\u1E60\u0160\u1E66\u1E62\u1E68\u0218\u015E\u2C7E\uA7A8\uA784]',
        'T' => '[\u0054\u24C9\uFF34\u1E6A\u0164\u1E6C\u021A\u0162\u1E70\u1E6E\u0166\u01AC\u01AE\u023E\uA786]',
        'TZ' => '[\uA728]',
        'U' => '[\u0055\u24CA\uFF35\u00D9\u00DA\u00DB\u0168\u1E78\u016A\u1E7A\u016C\u00DC\u01DB\u01D7\u01D5\u01D9\u1EE6\u016E\u0170\u01D3\u0214\u0216\u01AF\u1EEA\u1EE8\u1EEE\u1EEC\u1EF0\u1EE4\u1E72\u0172\u1E76\u1E74\u0244]',
        'V' => '[\u0056\u24CB\uFF36\u1E7C\u1E7E\u01B2\uA75E\u0245]',
        'VY' => '[\uA760]',
        'W' => '[\u0057\u24CC\uFF37\u1E80\u1E82\u0174\u1E86\u1E84\u1E88\u2C72]',
        'X' => '[\u0058\u24CD\uFF38\u1E8A\u1E8C]',
        'Y' => '[\u0059\u24CE\uFF39\u1EF2\u00DD\u0176\u1EF8\u0232\u1E8E\u0178\u1EF6\u1EF4\u01B3\u024E\u1EFE]',
        'Z' => '[\u005A\u24CF\uFF3A\u0179\u1E90\u017B\u017D\u1E92\u1E94\u01B5\u0224\u2C7F\u2C6B\uA762]',
        'a' => '[\u0061\u24D0\uFF41\u1E9A\u00E0\u00E1\u00E2\u1EA7\u1EA5\u1EAB\u1EA9\u00E3\u0101\u0103\u1EB1\u1EAF\u1EB5\u1EB3\u0227\u01E1\u00E4\u01DF\u1EA3\u00E5\u01FB\u01CE\u0201\u0203\u1EA1\u1EAD\u1EB7\u1E01\u0105\u2C65\u0250]',
        'aa' => '[\uA733]',
        'ae' => '[\u00E6\u01FD\u01E3]',
        'ao' => '[\uA735]',
        'au' => '[\uA737]',
        'av' => '[\uA739\uA73B]',
        'ay' => '[\uA73D]',
        'b' => '[\u0062\u24D1\uFF42\u1E03\u1E05\u1E07\u0180\u0183\u0253]',
        'c' => '[\u0063\u24D2\uFF43\u0107\u0109\u010B\u010D\u00E7\u1E09\u0188\u023C\uA73F\u2184]',
        'd' => '[\u0064\u24D3\uFF44\u1E0B\u010F\u1E0D\u1E11\u1E13\u1E0F\u0111\u018C\u0256\u0257\uA77A]',
        'dz' => '[\u01F3\u01C6]',
        'e' => '[\u0065\u24D4\uFF45\u00E8\u00E9\u00EA\u1EC1\u1EBF\u1EC5\u1EC3\u1EBD\u0113\u1E15\u1E17\u0115\u0117\u00EB\u1EBB\u011B\u0205\u0207\u1EB9\u1EC7\u0229\u1E1D\u0119\u1E19\u1E1B\u0247\u025B\u01DD]',
        'f' => '[\u0066\u24D5\uFF46\u1E1F\u0192\uA77C]',
        'g' => '[\u0067\u24D6\uFF47\u01F5\u011D\u1E21\u011F\u0121\u01E7\u0123\u01E5\u0260\uA7A1\u1D79\uA77F]',
        'h' => '[\u0068\u24D7\uFF48\u0125\u1E23\u1E27\u021F\u1E25\u1E29\u1E2B\u1E96\u0127\u2C68\u2C76\u0265]',
        'hv' => '[\u0195]',
        'i' => '[\u0069\u24D8\uFF49\u00EC\u00ED\u00EE\u0129\u012B\u012D\u00EF\u1E2F\u1EC9\u01D0\u0209\u020B\u1ECB\u012F\u1E2D\u0268\u0131]',
        'j' => '[\u006A\u24D9\uFF4A\u0135\u01F0\u0249]',
        'k' => '[\u006B\u24DA\uFF4B\u1E31\u01E9\u1E33\u0137\u1E35\u0199\u2C6A\uA741\uA743\uA745\uA7A3]',
        'l' => '[\u006C\u24DB\uFF4C\u0140\u013A\u013E\u1E37\u1E39\u013C\u1E3D\u1E3B\u017F\u0142\u019A\u026B\u2C61\uA749\uA781\uA747]',
        'lj' => '[\u01C9]',
        'm' => '[\u006D\u24DC\uFF4D\u1E3F\u1E41\u1E43\u0271\u026F]',
        'n' => '[\u006E\u24DD\uFF4E\u01F9\u0144\u00F1\u1E45\u0148\u1E47\u0146\u1E4B\u1E49\u019E\u0272\u0149\uA791\uA7A5]',
        'nj' => '[\u01CC]',
        'o' => '[\u006F\u24DE\uFF4F\u00F2\u00F3\u00F4\u1ED3\u1ED1\u1ED7\u1ED5\u00F5\u1E4D\u022D\u1E4F\u014D\u1E51\u1E53\u014F\u022F\u0231\u00F6\u022B\u1ECF\u0151\u01D2\u020D\u020F\u01A1\u1EDD\u1EDB\u1EE1\u1EDF\u1EE3\u1ECD\u1ED9\u01EB\u01ED\u00F8\u01FF\u0254\uA74B\uA74D\u0275]',
        'oi' => '[\u01A3]',
        'ou' => '[\u0223]',
        'oo' => '[\uA74F]',
        'p' => '[\u0070\u24DF\uFF50\u1E55\u1E57\u01A5\u1D7D\uA751\uA753\uA755]',
        'q' => '[\u0071\u24E0\uFF51\u024B\uA757\uA759]',
        'r' => '[\u0072\u24E1\uFF52\u0155\u1E59\u0159\u0211\u0213\u1E5B\u1E5D\u0157\u1E5F\u024D\u027D\uA75B\uA7A7\uA783]',
        's' => '[\u0073\u24E2\uFF53\u00DF\u015B\u1E65\u015D\u1E61\u0161\u1E67\u1E63\u1E69\u0219\u015F\u023F\uA7A9\uA785\u1E9B]',
        't' => '[\u0074\u24E3\uFF54\u1E6B\u1E97\u0165\u1E6D\u021B\u0163\u1E71\u1E6F\u0167\u01AD\u0288\u2C66\uA787]',
        'tz' => '[\uA729]',
        'u' => '[\u0075\u24E4\uFF55\u00F9\u00FA\u00FB\u0169\u1E79\u016B\u1E7B\u016D\u00FC\u01DC\u01D8\u01D6\u01DA\u1EE7\u016F\u0171\u01D4\u0215\u0217\u01B0\u1EEB\u1EE9\u1EEF\u1EED\u1EF1\u1EE5\u1E73\u0173\u1E77\u1E75\u0289]',
        'v' => '[\u0076\u24E5\uFF56\u1E7D\u1E7F\u028B\uA75F\u028C]',
        'vy' => '[\uA761]',
        'w' => '[\u0077\u24E6\uFF57\u1E81\u1E83\u0175\u1E87\u1E85\u1E98\u1E89\u2C73]',
        'x' => '[\u0078\u24E7\uFF58\u1E8B\u1E8D]',
        'y' => '[\u0079\u24E8\uFF59\u1EF3\u00FD\u0177\u1EF9\u0233\u1E8F\u00FF\u1EF7\u1E99\u1EF5\u01B4\u024F\u1EFF]',
        'z' => '[\u007A\u24E9\uFF5A\u017A\u1E91\u017C\u017E\u1E93\u1E95\u01B6\u0225\u0240\u2C6C\uA763]'
    };
    
    
    //Begin Test Data Generation Methods
    public static string getTestJSON{
    	get{
    		string testJson = '{"results" : [{"address_components":[{"long_name" : "1700","short_name" : "1700","types" : ["street_number"]},{"long_name" : "East 123rd Street","short_name" :"E 123rd St","types" : ["route"]},{"long_name" : "Rosehill North Business Park","short_name": "Rosehill North Business Park","types" : ["neightborhood","political"]},{"long_name" : "Olathe","short_name" : "Olathe","types" : ["locality", "political"]},{"long_name" : "Johnson County","short_name":"Johnson County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "Kansas","short_name" : "KS","types" : ["administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "66061","short_name" : "66061","types" : [ "postal_code" ]},{"long_name" : "5882","short_name" : "5882","types" : [ "postal_code_suffix" ]}],"formatted_address":"1700 E 123rd St, Olathe, KS 66061, USA","geometry" : {"location" : {"lat" : 38.906494,"lng" : -94.787249},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 38.90784298029149,"lng" : -94.78590001970851},"southwest" : {"lat" : 38.9051450197085,"lng" : -94.78859798029151}}},"place_id" : "ChIJ-_zEG5SVwIcRmbVmco91PCA","plus_code" : {"compound_code" : "W647+H4 Olathe, Kansas, United States","global_code" :"86C7W647+H4"},"types" : [ "establishment", "point_of_interest" ]}],"status" : "OK"}';
    		return testJson;
    	}
    	set;
    }
    
    public static list<Account> getTestList{
    	get{
    		list<Account> testList = new list<Account>();
    		id CenterID = getCenterID;
    		Account objAccount = new Account(Name='TestAccount', 
        								 RecordTypeId = CenterID,
        								 ShippingPostalCode = '40202',
        								 ShippingStreet = '680 S 4th S',
        								 ShippingCity = 'Louisville',
        								 ShippingState = 'KY',
        								 Phone = '555-555-5555',
        								 Shipping_Geolocation__Latitude__s = 38.2459027,
        								 Shipping_Geolocation__Longitude__s = -85.7704417);
        	Account objAccount2 = new Account(Name='TestAccount2', 
        								 RecordTypeId = CenterID,
        								 ShippingPostalCode = '40202',
        								 ShippingStreet = '680 S 4th S',
        								 ShippingCity = 'Louisville',
        								 ShippingState = 'KY',
        								 Phone = '555-555-5555',
        								 Shipping_Geolocation__Latitude__s = 38.2459027,
        								 Shipping_Geolocation__Longitude__s = -85.7704417);
			Account objAccount3 = new Account(Name='TestAccount', 
        								 RecordTypeId = CenterID,
        								 ShippingPostalCode = '40202',
        								 ShippingStreet = '680 S 4th S',
        								 ShippingCity = 'Louisville',
        								 ShippingState = 'KY',
        								 Phone = '555-555-5555',
        								 Shipping_Geolocation__Latitude__s = 38.2459027,
        								 Shipping_Geolocation__Longitude__s = -85.7704417);        								 							 
        	testList.add(objAccount);
        	testList.add(objAccount2);
        	testList.add(objAccount3);
    		return testList;
    		}
    	set;
    }
    
}