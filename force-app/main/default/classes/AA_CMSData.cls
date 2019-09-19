public with sharing class AA_CMSData{

	public CMS_Data__c cmsData	{get;set;}
	public integer dateVal	{get;set;}
	public string accName	{get;set;}

    @AuraEnabled
    public static CMS_Data__c getCMSData(ID id){
        system.debug('ID: ' + id);
        CMS_Data__c cData = new CMS_Data__c();
        try{
        cData = [SELECT CMS_County_Name__c, //County Name
                        CMS_Ownership__c, //Ownership
                        CMS_Cert_Beds__c, //Number of Certified Beds
                        CMS_Bed_Occupancy__c,
                        CMS_Bed_Occupancy2__c, //% of occupied beds
                        CMS_Participation__c,//First approved by CMS
                        CMS_Processing_Date__c, //Last updated?
                        CMS_ResCertBeds__c, //Residents in Beds
                        CMS_Cert__c, //Certification        
                        CMS_InHosp__c, //Inside Hospital
                        CMS_Health_Insp_Rating__c, //Health Inspection Rating
                        CMS_Overall_Rating__c, //Overall Rating
                        CMS_QM_Rating__c, // QM Rating
                        CMS_Staffing_Rating__c, //Staffing Rating
                        CMS_SSA_County__c, //County Code
                        CMS_ContCare_Fac__c, //CCRC Facility
                        CMS_RPTS_HPRPD__c, //Staffing Hrs per resident/Day
                        CMS_WHSS__c, //Weighted Health Survey Score
                        CMS_Average_Length_of_Stay__c, 
                        CMS_OT_Cost__c, 
                        CMS_OT_Prcnt__c, 
                        CMS_PT_Cost__c,
						CMS_PT_Prcnt__c, 
						CMS_RH_Days__c, 
						CMS_RH_Prcnt__c, 
						CMS_RL_Cost__c, 
						CMS_RL_Prcnt__c, 
						CMS_RM_Days__c, 
						CMS_RM_Prcnt__c, 
						CMS_RU_Days__c, 
						CMS_RU_Prcnt__c, 
						CMS_RV_Days__c, 
						CMS_RV_Prcnt__c, 
						CMS_SLP_Cost__c, 
						CMS_SLP_Prcnt__c,
                        LastModifiedDate
                        FROM CMS_Data__c
                        WHERE Account__c =: id];
            }
        catch(exception E){
            system.debug('No CMS Data Present for Account');
            }
        return cData;
        }
        
        public AA_CMSData(ApexPages.StandardController controller){
        	
        	}
        
        public void pullPDFData(){
        	dateVal = system.today().year();
        	cmsData = new CMS_Data__c();
        	ID id = ApexPages.currentPage().getParameters().get('id');
        	
        	try{
        	cmsData = [SELECT CMS_County_Name__c, //County Name
                        CMS_Ownership__c, //Ownership
                        CMS_Cert_Beds__c, //Number of Certified Beds
                        CMS_Bed_Occupancy__c,
                        CMS_Bed_Occupancy2__c, //% of occupied beds
                        CMS_Participation__c,//First approved by CMS
                        CMS_Processing_Date__c, //Last updated?
                        CMS_ResCertBeds__c, //Residents in Beds
                        CMS_Cert__c, //Certification        
                        CMS_InHosp__c, //Inside Hospital
                        CMS_Health_Insp_Rating__c, //Health Inspection Rating
                        CMS_Overall_Rating__c, //Overall Rating
                        CMS_QM_Rating__c, // QM Rating
                        CMS_Staffing_Rating__c, //Staffing Rating
                        CMS_SSA_County__c, //County Code
                        CMS_ContCare_Fac__c, //CCRC Facility
                        CMS_RPTS_HPRPD__c, //Staffing Hrs per resident/Day
                        CMS_WHSS__c, //Weighted Health Survey Score
                        CMS_Average_Length_of_Stay__c, 
                        CMS_OT_Cost__c, 
                        CMS_OT_Prcnt__c, 
                        CMS_PT_Cost__c,
						CMS_PT_Prcnt__c, 
						CMS_RH_Days__c, 
						CMS_RH_Prcnt__c, 
						CMS_RL_Cost__c, 
						CMS_RL_Prcnt__c, 
						CMS_RM_Days__c, 
						CMS_RM_Prcnt__c, 
						CMS_RU_Days__c, 
						CMS_RU_Prcnt__c, 
						CMS_RV_Days__c, 
						CMS_RV_Prcnt__c, 
						CMS_SLP_Cost__c, 
						CMS_SLP_Prcnt__c,
						Account__r.Name,
                        LastModifiedDate
                        FROM CMS_Data__c
                        WHERE ID =: id];
                        accName = cmsData.Account__r.Name;
            		}
            	catch(exception E){
            	system.debug('No CMS Data Present for Account');
            	}
        	}
        
}