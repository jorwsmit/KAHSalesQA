/**
@ClassName    : TBN_UpdateDMAOnAccountAndContactHandler
@CreatedOn    : 23/06/2016
@CreatedBy    : Smitha
@Description  : This is a handler class for Account/contact trigger, which will populate DMA code and name value on Account/Contact
                when DMA records which matches the postal/zip code is found, when Account/Contact records are updated or created.
**/
public with sharing class TBN_UpdateDMAOnAccountAndContactHandler {
    
    /**
        @MethodName : onAfterInsert
        @param      : List<Sobject> lstSobjectsToUpdateDMA
        @Description: This method is called on insert of Account/Contact and will populate DMA code and name value on Account/Contact
    */
    public void onAfterInsert(List<Sobject> lstSobjectsToUpdateDMA) {
        
        try {
            
            updateDMAOnAccountOrContact(lstSobjectsToUpdateDMA);
        }
        catch(Exception ex){
            system.debug('===='+ex.getMessage());
        }
    }
    
    /**
        @MethodName : onAfterUpdate
        @param      : map<Id, Sobject> mapOldSobjectValues, map<Id, Sobject> mapNewSobjectValues
        @Description: This is called after update of Account/Contact to populate DMA code and name value on Account/Contact
    */
    public void onAfterUpdate(map<Id, Sobject> mapOldSobjectValues, map<Id, Sobject> mapNewSobjectValues) {
        
        try {
            
            updateDMAOnAccountOrContact(mapOldSobjectValues, mapNewSobjectValues);
        }
        catch(Exception ex){
            system.debug('===='+ex.getMessage());
        }
    }
    
    /**
        @MethodName : updateDMAOnAccountOrContact
        @param      : lstSobjectsToUpdateDMA
        @Description: This method is called on insert of Account/Contact and will populate DMA code and name value on Account/Contact
    */
    private void updateDMAOnAccountOrContact(List<Sobject> lstSobjectsToUpdateDMA) {
        
        // String to store object type
        String strSobjectType = '';
        // String to store field name
        String strFieldName = '';
        // set to hold the postal code on inerted/updated Accoount/Contact
        set<String> setPostalCode = new set<String>();
        // list of sobject to be updated with DMA code and name value
        list<Sobject> lstSobjectsToUpdate = new list<Sobject>();
        
        // identify the object type
        Id sobjectId = lstSobjectsToUpdateDMA[0].Id;
        strSobjectType = sobjectId.getSObjectType().getDescribe().getName();
        
        // deciding the field name based on object type
        if(strSobjectType == 'Contact')
            strFieldName = 'MailingPostalCode';
        else
            strFieldName = 'ShippingPostalCode';
        
        // iterating through the list and collecting Postal Code from inserted Account/Contact
        for(Sobject objAccountContact : lstSobjectsToUpdateDMA) {
            
            if( String.isNotBlank( String.valueOf(objAccountContact.get(strFieldName)) ) ) {
                
                String strTest = String.valueOf(objAccountContact.get(strFieldName));
                string strPostalCode;
                if(strTest.indexOf('-')!=-1){
                    String[] arrTest = strTest.split('-');
                    setPostalCode.add(arrTest[0]);
                }
                else
                    setPostalCode.add( String.valueOf(objAccountContact.get(strFieldName)) );
                lstSobjectsToUpdate.add(objAccountContact);
            }
        }
        // call the method to update matching DMA values on Account/Contact
        updateSobjectWithMatchingDMARecords(setPostalCode, lstSobjectsToUpdate, strSobjectType, strFieldName);
        
    }
    
    /**
        @MethodName : updateDMAOnAccountOrContact
        @param      : map<Id, Sobject> mapOldSobjectValues, map<Id, Sobject> mapNewSobjectValues
        @Description: This is called after update of Account/Contact to populate DMA code and name value on Account/Contact
    */
    private void updateDMAOnAccountOrContact(map<Id, Sobject> mapOldSobjectValues, map<Id, Sobject> mapNewSobjectValues) {
        
        // String to store object type
        String strSobjectType = '';
        // String to store field name
        String strFieldName = '';
        // set to hold the postal code on inerted/updated Accoount/Contact
        set<String> setPostalCode = new set<String>();
        // list of sobject to be updated with DMA code and name value
        list<Sobject> lstSobjectsToUpdate = new list<Sobject>();
        
        // identify the object type
        Id sobjectId = mapNewSobjectValues.values()[0].Id;
        strSobjectType = sobjectId.getSObjectType().getDescribe().getName();
        
        // deciding the field name based on object type
        if(strSobjectType == 'Contact')
            strFieldName = 'MailingPostalCode';
        else
            strFieldName = 'ShippingPostalCode';
            
        // iterating through the list and collecting Postal Code from inserted Account/Contact
        for(Sobject objAccountContact : mapNewSobjectValues.values()) {
            
            if( String.isNotBlank( String.valueOf(objAccountContact.get(strFieldName)) ) &&
                String.valueOf( mapOldSobjectValues.get( Id.valueOf( String.valueOf(objAccountContact.Id) ) ).get(strFieldName) ) 
                                != String.valueOf( objAccountContact.get(strFieldName) ) ) {
                
                String strPostalCodeVal = String.valueOf(objAccountContact.get(strFieldName));
                string strPostalCode;
                if(strPostalCodeVal.indexOf('-')!=-1){
                    String[] arrTest = strPostalCodeVal .split('-');
                    setPostalCode.add(arrTest[0]);
                }
                else    
                    setPostalCode.add( String.valueOf(objAccountContact.get(strFieldName)) );
                lstSobjectsToUpdate.add(objAccountContact);
            }
        }
        // call the method to update matching DMA values on Account/Contact
        updateSobjectWithMatchingDMARecords(setPostalCode, lstSobjectsToUpdate, strSobjectType, strFieldName);
    }
    
    /**
        @MethodName : updateSobjectWithMatchingDMARecords
        @param      : set<String> setPostalCode, list<Sobject> lstSobjectsToUpdateDMA, String strObjectType, String strFieldName
        @Description: This method will populate DMA code and name value on Account/Contact
                      when DMA records which matches the postal/zip code is found. This is called when Account/Contact records are updated or created
    */
    private void updateSobjectWithMatchingDMARecords(set<String> setPostalCode, list<Sobject> lstSobjectsToUpdateDMA, String strObjectType, String strFieldName) {
        
        
        // list of sobject to be updated with DMA code and name value
        list<Sobject> lstSobjectsToUpdate = new list<Sobject>();
        // map to hold the DMA object with postal code as key
        map<String, DMA_Master__c> mapPostalCodeToDMAMasterLocal = new map<String, DMA_Master__c>();
        
        // get DMA_Master__c whose postal code matches with inserted Account/Contact postal code
        for(DMA_Master__c objDMAMaster : [ SELECT Name, DMA_Name__c, DMA_Postal_Code__c
                                           FROM DMA_Master__c
                                           WHERE DMA_Postal_Code__c IN : setPostalCode ] ) {
            
            mapPostalCodeToDMAMasterLocal.put(objDMAMaster.DMA_Postal_Code__c, objDMAMaster);
        }
        
        // assign DMA code and name value from matching DMA_Master__c records, to respective fields on Account/Contact
        for(Sobject objAccountContact : lstSobjectsToUpdateDMA) {
            
            String strPostalCodeVal = String.valueOf( objAccountContact.get(strFieldName) );
            string strPostalCode;
            if(strPostalCodeVal.indexOf('-')!=-1){
                String[] arrTest = strPostalCodeVal.split('-');
                strPostalCode= arrTest[0];
            }
            else
                strPostalCode = String.valueOf( objAccountContact.get(strFieldName) );
            if( mapPostalCodeToDMAMasterLocal.containsKey( strPostalCode )) {
                
                sObject obj = Schema.getGlobalDescribe().get(strObjectType).newSObject();
                obj.Id = objAccountContact.Id;
                obj.put('DMA_Name__c', mapPostalCodeToDMAMasterLocal.get(strPostalCode).DMA_Name__c);
                obj.put('DMA_Code__c', mapPostalCodeToDMAMasterLocal.get(strPostalCode).Name);
                lstSobjectsToUpdate.add(obj);
            }
        }
        
        if(!lstSobjectsToUpdate.isEmpty())
            update lstSobjectsToUpdate;
    }
}