global without sharing class SalesHD_Census {
// public Unit_Census__c census {get; set;}
public String accountUnits {get; set;}

public Id unitId {get; set;}
public Integer beds {get; set;}
public Integer census {get; set;}
public Date censusDate {get; set;}
public Boolean censusModal {get; set;}

private static Id currentUser = UserInfo.getUserId();

public SalesHD_Census(ApexPages.StandardController stdController) {
	// census = (Unit_Census__c)stdController.getRecord();
	accountUnits = JSON.serializePretty(getAccountUnits());
}

private Map<Id, List<Account_Unit__c> > getAccountUnits(){
	Map<Id, List<Account_Unit__c> > accountUnits = new Map<Id, List<Account_Unit__c> >();

	for(Account_Unit__c au : [select Id, Unit__c, Unit__r.Name, SalesHD_Unit_Census_Date__c,
	                          SalesHD_Unit_Census__c, SalesHD_Unit_Beds__c, Account__c, Account__r.Name from Account_Unit__c where
	                          Active__c=true and Unit__r.Name!='Administrative' and Account__c in
	                                             (select AccountId from AccountTeamMember where UserId =: currentUser and Account.RecordType.Name='HD Accounts')]) {
		if(accountUnits.containsKey(au.Account__c)) {
			accountUnits.get(au.Account__c).add(au);
		} else{
			accountUnits.put(au.Account__c, new List<Account_Unit__c> {au});
		}
	}
	return accountUnits;
}

@RemoteAction global static String getCensus(Id unitId){
	Integer census = null;
	Integer beds = null;
    Time t = time.newInstance(0, 0, 0, 0);
    Datetime dt = Datetime.newInstance(System.now().date(), t);
	String censusDate = dt.format('yyyy-MM-dd');
	// String censusDate = null;
	for(Unit_Census__c uc : [select Census__c,Beds__c,Census_Date__c from Unit_Census__c where
	                         Census_Date__c<=Today and Account_Unit__c=:unitId order by Census_Date__c desc limit 1]) {
		census = Integer.valueOf(uc.Census__c);
		beds = Integer.valueOf(uc.Beds__c);
        // dt = Datetime.newInstance(uc.Census_Date__c, t);
		// censusDate = dt.format('yyyy-MM-dd');
	}
	return '{"census":'+census+' , "beds":'+beds+', "censusDate":"'+censusDate+'"}';
}

public PageReference saveCensus() {
	try{

		if(censusDate<=System.now().date()) {
			List<Account_Unit__c> aus = [select SalesHD_Unit_Census_Date__c, SalesHD_Unit_Census__c, SalesHD_Unit_Beds__c
			                             from Account_Unit__c where Id=:unitId];
			List<Account_Unit__c> updateAU = new List<Account_Unit__c>();
			for(Account_Unit__c au : aus) {
				if(au.SalesHD_Unit_Census_Date__c==null || au.SalesHD_Unit_Census_Date__c<=censusDate) {
					au.SalesHD_Unit_Census_Date__c = censusDate;
					au.SalesHD_Unit_Census__c = census;
					au.SalesHD_Unit_Beds__c = beds;
					updateAU.add(au);
				}
			}

			if(!updateAU.isEmpty()) update updateAU;

			List<Unit_Census__c> ucs = [select id,Census__c,Beds__c,Census_Date__c from Unit_Census__c where Census_Date__c=:censusDate and Account_Unit__c=:unitId];
			if(ucs.isEmpty()) {
				insert new Unit_Census__c(Census__c=census, Beds__c=beds, Census_Date__c=censusDate, Account_Unit__c=unitId);
			} else{
				for(Unit_Census__c uc : ucs) {
					uc.Census__c = census; uc.Beds__c=beds;
				}
				update ucs;
			}
            accountUnits = JSON.serializePretty(getAccountUnits());
			censusModal = true;
		} else{
			censusModal = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Census cannot be set for future dates.'));
		}

	}
	catch(DmlException ex) {
		ApexPages.addMessages(ex);
	}
	return null;
}


}