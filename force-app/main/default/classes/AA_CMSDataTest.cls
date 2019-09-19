@isTest
public class AA_CMSDataTest {

    public static testMethod void test1(){
    	list<Account> aInsert = new list<Account>();
        Account a = new Account(Name='TestAccount', NPI__c = '12');
        aInsert.add(a);
        
        Account a2 = new Account(Name='TestAccount2', NPI__c = '22');
        aInsert.add(a2);
        insert aInsert;
        CMS_Data__c cms = new CMS_Data__c(Account__c = a.ID,
                                          CMS_Cert_Beds__c = 98,
                                          CMS_Cert__c = 'Test',
                                          CMS_ContCare_Fac__c = true,
                                          CMS_County_Name__c = 'Test County',
                                          CMS_Health_Insp_Rating__c = 3,
                                          CMS_InHosp__c = true,
                                          CMS_Old_Survey__c = true,
                                          CMS_Overall_Rating__c = 5,
                                          CMS_Ownership__c = 'Coprorate',
                                          CMS_Participation__c = system.today(),
                                          CMS_Processing_Date__c = system.today(),
                                          CMS_Provider_ID__c = '5478',
                                          CMS_QM_Rating__c = 5,
                                          CMS_ResCertBeds__c = 24,
                                          CMS_RPTS_HPRPD__c = 67,
                                          CMS_SSA_County__c = '203',
                                          CMS_Staffing_Rating__c = 4,
                                          CMS_WHSS__c = 444,
                                          CMS_Average_Length_of_Stay__c = 11, 
                        				  CMS_OT_Cost__c = 2, 
                        				  CMS_OT_Prcnt__c = 3, 
                        				  CMS_PT_Cost__c = 4,
										  CMS_PT_Prcnt__c = 5, 
										  CMS_RH_Days__c = 6, 
										  //CMS_RH_Prcnt__c = 7, 
										  CMS_RL_Cost__c = 8, 
										  //CMS_RL_Prcnt__c = 9, 
										  CMS_RM_Days__c = 10, 
										  //CMS_RM_Prcnt__c = 11, 
										  CMS_RU_Days__c = 12, 
										  //CMS_RU_Prcnt__c = 13, 
										  CMS_RV_Days__c = 14, 
							 			  //CMS_RV_Prcnt__c = 15, 
										  CMS_SLP_Cost__c = 16, 
										  CMS_SLP_Prcnt__c = 17
                                          );
        
        insert cms;
        
        AA_CMSData.getCMSData(a.id);
        AA_CMSData.getCMSData(a2.id);
        
        ApexPages.currentPage().getParameters().put('id', a2.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cms);
        AA_CMSData testPlan = new AA_CMSData(sc);
        testPlan.pullPDFData();
        
        }
}