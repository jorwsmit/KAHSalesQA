@isTest(seeAllData=false)
private class Sales_TestFCRcontroller {

  @testSetup static void setup(){
    User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
    
    ID pID = [SELECT ID, Name FROM Profile WHERE Name = 'Sales: KAH Associate'].ID;
    ID roleID = [SELECT ID, Name FROM UserRole WHERE Name = 'KAH - Corporate'].ID;
    
    System.runAs ( thisUser ) {
      User usrHH = new User(Alias = 'saHH', Email='KAHSalesAssociateHH@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', Line_of_Business__c='HH', ProfileId = pID,
      TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociateHH@testorg.com', UserRoleId=roleID);

      insert usrHH;

      Sales_Performance__c spHH = new Sales_Performance__c(KAH_HH_Admit_Target__c=10, KAH_HH_PPS_Qualified_Admits__c=10, OwnerId=usrHH.Id);

      insert spHH;

      User usrHP = new User(Alias = 'saHP', Email='KAHSalesAssociateHP@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', Line_of_Business__c='HP', ProfileId = pID,
      TimeZoneSidKey='America/Los_Angeles', UserName='KAHSalesAssociateHP@testorg.com', UserRoleId=roleID);

      insert usrHP;

      Sales_Performance__c spHP = new Sales_Performance__c(KAH_HP_Total_Admits__c=10, KAH_HP_Admit_Target__c=10, OwnerId=usrHP.Id);

      insert spHP;
    }
  }

  @isTest static void getUsers(){
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getUsers();
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void createFCRhhCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    String result;
    Date d = Date.today();
    Test.StartTest();
    result = Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void createFCRhpCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    String result;
    Date d = Date.today();
    Test.StartTest();
    result = Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void createFCRfcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    String result;
    Date d = Date.today();
    Test.StartTest();
    result = Sales_FCRcontroller.createFCR(usr.Id, 'fcr', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void createFCRfcrAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    String result;
    Date d = Date.today();
    Test.StartTest();
    result = Sales_FCRcontroller.createFCR(usr.Id, 'fcrAF', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void createFCRsa(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    String result;
    Date d = Date.today();
    Test.StartTest();
    result = Sales_FCRcontroller.createFCR(usr.Id, 'sa', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void createFCRaf(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    String result;
    Date d = Date.today();
    Test.StartTest();
    result = Sales_FCRcontroller.createFCR(usr.Id, 'af', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRhhCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRhpCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRfcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcr', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRcompletedFcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcr', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    Sales_FCRcontroller.completeFCR(fcrId);

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRcompletedFcrAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcrAF', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    Sales_FCRcontroller.completeFCR(fcrId);

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRfcrAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcrAF', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRaf(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'af', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFCRsa(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'sa', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFCR(fcrId, usr.Id);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSPhh(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSP(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSPhp(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSP(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void updateFCRhhCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String j = '{"fcrType":"hhCR","fcr":{},"fcrAF":{},"hhCR":{},"hpCR":{},"sa":{},"af":{}}';
    Boolean result;
    Test.StartTest();
    result = Sales_FCRcontroller.updateFCR(fcrId, j);
    Test.StopTest();
    System.assert(result!=null);
  }
  @isTest static void updateFCRhpCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String j = '{"fcrType":"hpCR","fcr":{},"fcrAF":{},"hhCR":{},"hpCR":{},"sa":{},"af":{}}';
    Boolean result;
    Test.StartTest();
    result = Sales_FCRcontroller.updateFCR(fcrId, j);
    Test.StopTest();
    System.assert(result!=null);
  }
  @isTest static void updateFCRfcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String j = '{"fcrType":"fcr","fcr":{},"fcrAF":{},"hhCR":{},"hpCR":{},"sa":{},"af":{}}';
    Boolean result;
    Test.StartTest();
    result = Sales_FCRcontroller.updateFCR(fcrId, j);
    Test.StopTest();
    System.assert(result!=null);
  }
  @isTest static void updateFCRfcrAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String j = '{"fcrType":"fcrAF","fcr":{},"fcrAF":{},"hhCR":{},"hpCR":{},"sa":{},"af":{}}';
    Boolean result;
    Test.StartTest();
    result = Sales_FCRcontroller.updateFCR(fcrId, j);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getManagedUsers(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    d.toStartofWeek();
    List<String> dates = new List<String>{String.valueOf(d)+' '+String.valueOf(d.addDays(7))};
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getManagedUsers(dates);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void completeFCRhhCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String j = '{"fcrType":"hhCR","fcr":{},"fcrAF":{},"hhCR":{'+
    '"Sales_CR_KAH_1_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_1_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_1_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_1_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_D":"1 - Specialist demonstrates little or no evidence of this behavior"'+
    '},"hpCR":{},"sa":{},"af":{}}';
    Sales_FCRcontroller.updateFCR(fcrId, j);
    Boolean result;
    Test.StartTest();
    result = Sales_FCRcontroller.completeFCR(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void completeFCRhpCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String j = '{"fcrType":"hpCR","fcr":{},"fcrAF":{},"hhCR":{},"hpCR":{'+
    '"Sales_CR_KAH_1_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_1_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_1_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_1_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_2_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_3_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_4_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_5_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_6_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_7_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_8_D":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_A":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_B":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_C":"1 - Specialist demonstrates little or no evidence of this behavior",'+
    '"Sales_CR_KAH_9_D":"1 - Specialist demonstrates little or no evidence of this behavior"'+
    '},"sa":{},"af":{}}';
    Sales_FCRcontroller.updateFCR(fcrId, j);
    Boolean result;
    Test.StartTest();
    result = Sales_FCRcontroller.completeFCR(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummaryHhCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    Field_Coaching_Report__c fcr = [select Sales_CR_KAH_1_A__c from Field_Coaching_Report__c where Id =: fcrId];
    fcr.Sales_CR_KAH_1_A__c = '4 - Specialist demonstrates significant or strong evidence of this behavior';
    update fcr;
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummary(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummaryHpCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    Field_Coaching_Report__c fcr = [select Sales_CR_KAH_1_A__c from Field_Coaching_Report__c where Id =: fcrId];
    fcr.Sales_CR_KAH_1_A__c = '3 - Specialist demonstrates frequent evidence of this behavior';
    update fcr;
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummary(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummaryFCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcr', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    Field_Coaching_Report__c fcr = [select Sales_FCR_KAH_1_A__c from Field_Coaching_Report__c where Id =: fcrId];
    fcr.Sales_FCR_KAH_1_A__c = '4 - Exceeding Expectations';
    update fcr;
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummary(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummaryFcrAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcrAF', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    Field_Coaching_Report__c fcr = [select Sales_FCR_KAH_1_A__c from Field_Coaching_Report__c where Id =: fcrId];
    fcr.Sales_FCR_KAH_1_A__c = '3 - Achieving Expectations';
    update fcr;
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummary(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummarySA(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'sa', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummary(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummaryAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'af', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummary(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummarySPhh(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummarySp(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getSummarySPhp(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getSummarySp(fcrId);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getWeekListHHcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    d.toStartofWeek();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getWeekList(usr.Id, String.valueOf(d)+' '+String.valueOf(d.addDays(7)));
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getWeekListHPcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    Date d = Date.today();
    Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    d.toStartofWeek();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getWeekList(usr.Id, String.valueOf(d)+' '+String.valueOf(d.addDays(7)));
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getWeekListFcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    Sales_FCRcontroller.createFCR(usr.Id, 'fcr', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    d.toStartofWeek();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getWeekList(usr.Id, String.valueOf(d)+' '+String.valueOf(d.addDays(7)));
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getWeekListFcrAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    Sales_FCRcontroller.createFCR(usr.Id, 'fcrAF', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    d.toStartofWeek();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getWeekList(usr.Id, String.valueOf(d)+' '+String.valueOf(d.addDays(7)));
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getWeekListSa(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    Sales_FCRcontroller.createFCR(usr.Id, 'sa', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    d.toStartofWeek();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getWeekList(usr.Id, String.valueOf(d)+' '+String.valueOf(d.addDays(7)));
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getWeekListAf(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    Sales_FCRcontroller.createFCR(usr.Id, 'af', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com');
    d.toStartofWeek();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getWeekList(usr.Id, String.valueOf(d)+' '+String.valueOf(d.addDays(7)));
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void deleteFCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    Test.StartTest();
    Sales_FCRcontroller.deleteFCR(fcrId);
    Test.StopTest();
  }

  @isTest static void saveSummaryTextSa(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.saveSummaryText(fcrId, new List<String>{'input', 'false', 'true'}, false);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void saveSummaryTextLeader(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();
    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.saveSummaryText(fcrId,  new List<String>{'input',
    'input', 'input', String.valueOf(d.format()), String.valueOf(d.format())}, true);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void pushFCRsa(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Test.StartTest();
    Sales_FCRcontroller.pushFCR(usr.Id, 'sa');
    Test.StopTest();
  }

  @isTest static void pushFCRaf(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Test.StartTest();
    Sales_FCRcontroller.pushFCR(usr.Id, 'sa');
    Test.StopTest();
  }

  @isTest static void submitBug(){
    Test.StartTest();
    Sales_FCRcontroller.submitBug('subject', 'description');
    Test.StopTest();
  }

  @isTest static void getFcrListhhCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFcrList(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFcrListhpCR(){
    User usr = [SELECT id FROM User WHERE Alias='saHP'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'hhCR', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFcrList(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFcrListfcr(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcr', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFcrList(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFcrListfcrAF(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'fcrAF', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFcrList(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFcrListaf(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'af', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFcrList(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getFcrListsa(){
    User usr = [SELECT id FROM User WHERE Alias='saHH'];
    Date d = Date.today();
    JSONParser parser = JSON.createParser(Sales_FCRcontroller.createFCR(usr.Id, 'sa', mmddyyyy(d), 'Full Day', 'Test', 'Test@test.com'));
    parser.nextToken();
    parser.nextValue();
    String fcrId = parser.getText();

    String result;
    Test.StartTest();
    result = Sales_FCRcontroller.getFcrList(usr.Id, 0);
    Test.StopTest();
    System.assert(result!=null);
  }

  @isTest static void getHelpIds(){
    Test.StartTest();
    Sales_FCRcontroller.getHelp('manageFCR');
    Sales_FCRcontroller.getHelp('listFCR');
    Test.StopTest();
  }


  private static String mmddyyyy(Date d){
    String month=String.valueOf(d.month()), day=String.valueOf(d.day());
    if(d.month()<10)  month = '0'+d.month();
    if(d.day()<10)  day = '0'+d.day();
    return month+'/'+day+'/'+d.year();
  }


}