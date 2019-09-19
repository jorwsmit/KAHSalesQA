global class Sales_FCRcontroller {

  /*
  private static Id kahCrHH = '0121B0000018FvsQAE';
  private static Id kahCrHP = '0121B0000018FvtQAE';
  private static Id kahFcr = '0121B0000018FvuQAE';
  private static Id kahFcrAf = '0121B0000018FvvQAE';
  private static Id kahSa = '0121B0000018FvwQAE';
  private static Id kahAf = '0121B0000018FvxQAE';
  */

  public String selectedName {get; set;}
  public String selectedEmail {get; set;}


  private static recordType kahCrHH = [select id from recordType where developerName='CR_KAH_HH'];
  private static recordType kahCrHP = [select id from recordType where developerName='CR_KAH_HP'];
  private static recordType kahFcr = [select id from recordType where developerName='FCR_KAH_SalesPro'];
  private static recordType kahFcrAf = [select id from recordType where developerName='FCR_KAH_TAF'];
  private static recordType kahSa = [select id from recordType where developerName='PRA_KAH'];
  private static recordType kahAf = [select id from recordType where developerName='TAF_KAH'];
  
  private static List<String> monthList = new List<String>{'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY',
  'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'};

  public class JSON2Apex {
    public Fcr fcr;
    public FcrAF fcrAF;
    public HhCR hhCR;
    public HpCR hpCR;
    public Sa sa;
    public Af af;
    public string fcrType;
  }

  public class Fcr {
    public String Sales_FCR_KAH_1_A;
    public String Sales_FCR_KAH_1_B;
    public String Sales_FCR_KAH_1_C;
    public String Sales_FCR_KAH_1_D;
    public String Sales_FCR_KAH_1_E;
    public String Sales_FCR_KAH_1_F;
    public String Sales_FCR_KAH_1_Text;
    public String Sales_FCR_KAH_2_A;
    public String Sales_FCR_KAH_2_B;
    public String Sales_FCR_KAH_2_C;
    public String Sales_FCR_KAH_2_D;
    public String Sales_FCR_KAH_2_E;
    public String Sales_FCR_KAH_2_Text;
    public String Sales_FCR_KAH_3_A;
    public String Sales_FCR_KAH_3_B;
    public String Sales_FCR_KAH_3_C;
    public String Sales_FCR_KAH_3_D;
    public String Sales_FCR_KAH_3_E;
    public String Sales_FCR_KAH_3_F;
    public String Sales_FCR_KAH_3_G;
    public String Sales_FCR_KAH_3_H;
    public String Sales_FCR_KAH_3_Text;
    public String Sales_FCR_KAH_4_Leader_Text;
    public String Sales_FCR_KAH_4_Rep_Text;
  }

  public class FcrAF {
    public String Sales_FCR_KAH_1_A;
    public String Sales_FCR_KAH_1_B;
    public String Sales_FCR_KAH_1_C;
    public String Sales_FCR_KAH_1_D;
    public String Sales_FCR_KAH_1_E;
    public String Sales_FCR_KAH_1_F;
    public String Sales_FCR_KAH_1_Text;
    public String Sales_FCR_KAH_2_A;
    public String Sales_FCR_KAH_2_B;
    public String Sales_FCR_KAH_2_C;
    public String Sales_FCR_KAH_2_D;
    public String Sales_FCR_KAH_2_E;
    public String Sales_FCR_KAH_2_Text;
    public String Sales_FCR_KAH_TAF_3_A;
    public String Sales_FCR_KAH_TAF_3_B;
    public String Sales_FCR_KAH_TAF_3_C;
    public String Sales_FCR_KAH_TAF_3_D1;
    public String Sales_FCR_KAH_TAF_3_D2;
    public String Sales_FCR_KAH_TAF_3_D3;
    public String Sales_FCR_KAH_TAF_3_E;
    public String Sales_FCR_KAH_TAF_3_F;
    public String Sales_FCR_KAH_TAF_3_G;
    public String Sales_FCR_KAH_3_Text;
    public String Sales_FCR_KAH_4_Leader_Text;
    public String Sales_FCR_KAH_4_Rep_Text;

  }

  public class HpCR {
    public String Sales_CR_KAH_1_A;
    public String Sales_CR_KAH_1_B;
    public String Sales_CR_KAH_1_C;
    public String Sales_CR_KAH_1_D;
    public String Sales_CR_KAH_2_A;
    public String Sales_CR_KAH_2_B;
    public String Sales_CR_KAH_2_C;
    public String Sales_CR_KAH_2_D;
    public String Sales_CR_KAH_3_A;
    public String Sales_CR_KAH_3_B;
    public String Sales_CR_KAH_3_C;
    public String Sales_CR_KAH_3_D;
    public String Sales_CR_KAH_4_A;
    public String Sales_CR_KAH_4_B;
    public String Sales_CR_KAH_4_C;
    public String Sales_CR_KAH_4_D;
    public String Sales_CR_KAH_5_A;
    public String Sales_CR_KAH_5_B;
    public String Sales_CR_KAH_5_C;
    public String Sales_CR_KAH_5_D;
    public String Sales_CR_KAH_6_A;
    public String Sales_CR_KAH_6_B;
    public String Sales_CR_KAH_6_C;
    public String Sales_CR_KAH_6_D;
    public String Sales_CR_KAH_7_A;
    public String Sales_CR_KAH_7_B;
    public String Sales_CR_KAH_7_C;
    public String Sales_CR_KAH_7_D;
    public String Sales_CR_KAH_8_A;
    public String Sales_CR_KAH_8_B;
    public String Sales_CR_KAH_8_C;
    public String Sales_CR_KAH_8_D;
    public String Sales_CR_KAH_9_A;
    public String Sales_CR_KAH_9_B;
    public String Sales_CR_KAH_9_C;
    public String Sales_CR_KAH_9_D;
  }

  public class HhCR {
    public String Sales_CR_KAH_1_A;
    public String Sales_CR_KAH_1_B;
    public String Sales_CR_KAH_1_C;
    public String Sales_CR_KAH_1_D;
    public String Sales_CR_KAH_2_A;
    public String Sales_CR_KAH_2_B;
    public String Sales_CR_KAH_2_C;
    public String Sales_CR_KAH_2_D;
    public String Sales_CR_KAH_3_A;
    public String Sales_CR_KAH_3_B;
    public String Sales_CR_KAH_3_C;
    public String Sales_CR_KAH_3_D;
    public String Sales_CR_KAH_4_A;
    public String Sales_CR_KAH_4_B;
    public String Sales_CR_KAH_4_C;
    public String Sales_CR_KAH_4_D;
    public String Sales_CR_KAH_6_A;
    public String Sales_CR_KAH_6_B;
    public String Sales_CR_KAH_6_C;
    public String Sales_CR_KAH_6_D;
    public String Sales_CR_KAH_7_A;
    public String Sales_CR_KAH_7_B;
    public String Sales_CR_KAH_7_C;
    public String Sales_CR_KAH_7_D;
    public String Sales_CR_KAH_8_A;
    public String Sales_CR_KAH_8_B;
    public String Sales_CR_KAH_8_C;
    public String Sales_CR_KAH_8_D;
    public String Sales_CR_KAH_9_A;
    public String Sales_CR_KAH_9_B;
    public String Sales_CR_KAH_9_C;
    public String Sales_CR_KAH_9_D;
  }

  public class Sa {
    public String Sales_PRA_KAH_1_A;
    public String Sales_PRA_KAH_1_B;
    public String Sales_PRA_KAH_2_A;
    public String Sales_PRA_KAH_2_B;
    public String Sales_PRA_KAH_3_A;
    public String Sales_PRA_KAH_3_B;
    public String Sales_PRA_KAH_4_A;
    public String Sales_PRA_KAH_4_B;
    public String Sales_PRA_KAH_5_A;
    public String Sales_PRA_KAH_5_B;
    public String Sales_PRA_KAH_6_A;
    public String Sales_PRA_KAH_6_B;
    public String Sales_PRA_KAH_7_A;
    public String Sales_PRA_KAH_7_B;
    public String Sales_PRA_KAH_8_A;
    public String Sales_PRA_KAH_8_B;
  }

  public class Af {
    public String Sales_TAF_KAH_1_Text;
    public String Sales_TAF_KAH_2_Text;
    public String Sales_TAF_KAH_3_Text;
    public String Sales_TAF_KAH_4a_Text;
    public String Sales_TAF_KAH_4b_Text;
    public String Sales_TAF_KAH_4c_Text;
  }

  public Field_Coaching_Report__c thisFcr {get; set;}

  public Sales_FCRcontroller(ApexPages.StandardController stdController) {
    thisFcr = (Field_Coaching_Report__c)stdController.getRecord();

    for(User u : [select email, name from User where Id=:ApexPages.currentPage().getParameters().get('userId')]){
      selectedName = u.name;
      selectedEmail = u.email;
    }
  }

  public static JSON2Apex parse(String json) {
    return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
  }

  @RemoteAction global static string getUsers(){
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    allSubRoleIds.add(UserInfo.getUserRoleId());
    String html='';
    for(User u : [select id, name, email from user where userRoleId in :allSubRoleIds]){
      html+='<li data-email="'+u.email+'" id="'+u.id+'" style="display:none;" class="link" onclick="areYouSure(\''+u.name+'\',\''+u.id+'\')">'+u.name+'</li>';
    }
    return html;
  }

  private static Set<Id> getSubRoleIds(Set<Id> roleIds) {
    Set<Id> returnRoleIds = new Set<Id>();
    for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
      returnRoleIds.add(r.Id);
    }
    if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
    return returnRoleIds;
  }


  @RemoteAction global static String createFCR(String uId, String fcrType, String dates, String rideLength, String salesName, String salesEmail){
    Date d = Date.newInstance(Integer.valueOf(dates.substring(6,dates.length())), Integer.valueOf(dates.substring(0,2)), Integer.valueOf(dates.substring(3,5)));

    String lob = 'hh';
    Id fcrTypeId;

    User u = [select Name, MediumPhotoUrl, Line_of_Business__c from user where Id=:uId];
    if(u.Line_of_Business__c!=null && u.Line_of_Business__c=='HP' && fcrType=='hhCR'){
      fcrType = 'hpCR';
      fcrTypeId = kahCrHP.Id;
    } else if(fcrType=='hhCR'){
      fcrTypeId = kahCrHH.Id;
    }else if(fcrType=='fcr'){
      fcrTypeId = kahFcr.Id;
    }else if(fcrType=='fcrAF'){
      fcrTypeId = kahFcrAf.Id;
    }else if(fcrType=='sa'){
      fcrTypeId = kahSa.Id;
    }else if(fcrType=='af'){
      fcrTypeId = kahAf.Id;
    }


    Field_Coaching_Report__c fcr = new Field_Coaching_Report__c(
      Employee__c=uId, OwnerId=uId, RecordTypeId=fcrTypeId, 
      Date__c=d, Status__c='In-process', Length_of_Field_Ride__c=rideLength,
      Sales_Name__c=salesName, Sales_Email__c=salesEmail);
    insert fcr;
    return '{"fcrId":"'+fcr.Id+'", "usrName":"'+u.Name+'", "usrPhotoURL":"'+u.MediumPhotoUrl+'", "fcrType":"'+fcrType+'"}';
  }

  @RemoteAction global static String getFCR(String fcrId, String uId){
    Field_Coaching_Report__c fcr = [select RecordTypeId, Status__c, Sales_CR_KAH_1_A__c,Sales_CR_KAH_1_B__c,Sales_CR_KAH_1_C__c,Sales_CR_KAH_1_D__c,Sales_CR_KAH_2_A__c,
    Sales_CR_KAH_2_B__c,Sales_CR_KAH_2_C__c,Sales_CR_KAH_2_D__c,Sales_CR_KAH_3_A__c,Sales_CR_KAH_3_B__c,Sales_CR_KAH_3_C__c,Sales_CR_KAH_3_D__c,
    Sales_CR_KAH_4_A__c,Sales_CR_KAH_4_B__c,Sales_CR_KAH_4_C__c,Sales_CR_KAH_4_D__c,Sales_CR_KAH_5_A__c,Sales_CR_KAH_5_B__c,Sales_CR_KAH_5_C__c,
    Sales_CR_KAH_5_D__c,Sales_CR_KAH_6_A__c,Sales_CR_KAH_6_B__c,Sales_CR_KAH_6_C__c,Sales_CR_KAH_6_D__c,Sales_CR_KAH_7_A__c,Sales_CR_KAH_7_B__c,
    Sales_CR_KAH_7_C__c,Sales_CR_KAH_7_D__c,Sales_CR_KAH_8_A__c,Sales_CR_KAH_8_B__c,Sales_CR_KAH_8_C__c,Sales_CR_KAH_8_D__c,Sales_CR_KAH_9_A__c,
    Sales_CR_KAH_9_B__c,Sales_CR_KAH_9_C__c,Sales_CR_KAH_9_D__c,Sales_FCR_KAH_1_A__c,Sales_FCR_KAH_1_B__c,Sales_FCR_KAH_1_C__c,Sales_FCR_KAH_1_D__c,
    Sales_FCR_KAH_1_E__c,Sales_FCR_KAH_1_F__c,Sales_FCR_KAH_1_Text__c,Sales_FCR_KAH_2_A__c,Sales_FCR_KAH_2_B__c,Sales_FCR_KAH_2_C__c,Sales_FCR_KAH_2_D__c,
    Sales_FCR_KAH_2_E__c,Sales_FCR_KAH_2_Text__c,Sales_FCR_KAH_3_A__c,Sales_FCR_KAH_3_B__c,Sales_FCR_KAH_3_C__c,Sales_FCR_KAH_3_D__c,Sales_FCR_KAH_3_E__c,
    Sales_FCR_KAH_3_F__c,Sales_FCR_KAH_3_G__c,Sales_FCR_KAH_3_H__c,Sales_FCR_KAH_3_Text__c,Sales_FCR_KAH_TAF_3_A__c,Sales_FCR_KAH_TAF_3_B__c,
    Sales_FCR_KAH_TAF_3_C__c,Sales_FCR_KAH_TAF_3_D1__c,Sales_FCR_KAH_TAF_3_D2__c,Sales_FCR_KAH_TAF_3_D3__c,Sales_FCR_KAH_TAF_3_E__c,Sales_FCR_KAH_TAF_3_F__c,
    Sales_FCR_KAH_TAF_3_G__c,Sales_FCR_KAH_4_Leader_Text__c,Sales_FCR_KAH_4_Rep_Text__c,Sales_PRA_KAH_1_A__c,Sales_PRA_KAH_1_B__c,Sales_PRA_KAH_2_A__c,
    Sales_PRA_KAH_2_B__c,Sales_PRA_KAH_3_A__c,Sales_PRA_KAH_3_B__c,Sales_PRA_KAH_4_A__c,Sales_PRA_KAH_4_B__c,Sales_PRA_KAH_5_A__c,
    Sales_PRA_KAH_5_B__c,Sales_PRA_KAH_6_A__c,Sales_PRA_KAH_6_B__c,Sales_PRA_KAH_7_A__c,Sales_PRA_KAH_7_B__c,Sales_PRA_KAH_8_A__c,Sales_PRA_KAH_8_B__c,
    Sales_TAF_KAH_1_Text__c,Sales_TAF_KAH_2_Text__c,Sales_TAF_KAH_3_Text__c,Sales_TAF_KAH_4a_Text__c,Sales_TAF_KAH_4b_Text__c,
    Sales_TAF_KAH_4c_Text__c from Field_Coaching_Report__c where Id = :fcrId];

    User u = [select Name, MediumPhotoUrl from user where Id=:uId];

    String fcrType = '';
    if(fcr.RecordTypeId == kahCrHH.Id){
      fcrType = 'hhCR';
    } else if(fcr.RecordTypeId == kahCrHP.Id){
      fcrType = 'hpCR';
    } else if(fcr.RecordTypeId == kahFcr.Id){
      fcrType = 'fcr';
    }  else if(fcr.RecordTypeId == kahFcrAf.Id){
      fcrType = 'fcrAF';
    } else if(fcr.RecordTypeId == kahSa.Id){
      fcrType = 'sa';
    } else if(fcr.RecordTypeId == kahAf.Id){
      fcrType = 'af';
    }

    Boolean completed = false;
    if(fcr.Status__c == 'Completed'){
      completed = true;
    }

    return '{"fcrId":"'+fcrId+'", "usrName":"'+u.Name+'", "usrPhotoURL":"'+u.MediumPhotoUrl+'", "fcrType":"'+fcrType+'", "completed":'+completed+', "fields":{'+
    '"hpCR":{'+
    '"Sales_CR_KAH_1_A__c":"'+fcr.Sales_CR_KAH_1_A__c+'", "Sales_CR_KAH_1_B__c":"'+fcr.Sales_CR_KAH_1_B__c+'",'+
    '"Sales_CR_KAH_1_C__c":"'+fcr.Sales_CR_KAH_1_C__c+'", "Sales_CR_KAH_1_D__c":"'+fcr.Sales_CR_KAH_1_D__c+'",'+
    '"Sales_CR_KAH_2_A__c":"'+fcr.Sales_CR_KAH_2_A__c+'",'+
    '"Sales_CR_KAH_2_B__c":"'+fcr.Sales_CR_KAH_2_B__c+'", "Sales_CR_KAH_2_C__c":"'+fcr.Sales_CR_KAH_2_C__c+'",'+
    '"Sales_CR_KAH_2_D__c":"'+fcr.Sales_CR_KAH_2_D__c+'", "Sales_CR_KAH_3_A__c":"'+fcr.Sales_CR_KAH_3_A__c+'",'+
    '"Sales_CR_KAH_3_B__c":"'+fcr.Sales_CR_KAH_3_B__c+'", "Sales_CR_KAH_3_C__c":"'+fcr.Sales_CR_KAH_3_C__c+'",'+
    '"Sales_CR_KAH_3_D__c":"'+fcr.Sales_CR_KAH_3_D__c+'",'+
    '"Sales_CR_KAH_4_A__c":"'+fcr.Sales_CR_KAH_4_A__c+'", "Sales_CR_KAH_4_B__c":"'+fcr.Sales_CR_KAH_4_B__c+'",'+
    '"Sales_CR_KAH_4_C__c":"'+fcr.Sales_CR_KAH_4_C__c+'", "Sales_CR_KAH_4_D__c":"'+fcr.Sales_CR_KAH_4_D__c+'",'+
    '"Sales_CR_KAH_5_A__c":"'+fcr.Sales_CR_KAH_5_A__c+'", "Sales_CR_KAH_5_B__c":"'+fcr.Sales_CR_KAH_5_B__c+'",'+
    '"Sales_CR_KAH_5_C__c":"'+fcr.Sales_CR_KAH_5_C__c+'",'+
    '"Sales_CR_KAH_5_D__c":"'+fcr.Sales_CR_KAH_5_D__c+'", "Sales_CR_KAH_6_A__c":"'+fcr.Sales_CR_KAH_6_A__c+'",'+
    '"Sales_CR_KAH_6_B__c":"'+fcr.Sales_CR_KAH_6_B__c+'", "Sales_CR_KAH_6_C__c":"'+fcr.Sales_CR_KAH_6_C__c+'",'+
    '"Sales_CR_KAH_6_D__c":"'+fcr.Sales_CR_KAH_6_D__c+'", "Sales_CR_KAH_7_A__c":"'+fcr.Sales_CR_KAH_7_A__c+'",'+
    '"Sales_CR_KAH_7_B__c":"'+fcr.Sales_CR_KAH_7_B__c+'",'+
    '"Sales_CR_KAH_7_C__c":"'+fcr.Sales_CR_KAH_7_C__c+'", "Sales_CR_KAH_7_D__c":"'+fcr.Sales_CR_KAH_7_D__c+'",'+
    '"Sales_CR_KAH_8_A__c":"'+fcr.Sales_CR_KAH_8_A__c+'", "Sales_CR_KAH_8_B__c":"'+fcr.Sales_CR_KAH_8_B__c+'",'+
    '"Sales_CR_KAH_8_C__c":"'+fcr.Sales_CR_KAH_8_C__c+'", "Sales_CR_KAH_8_D__c":"'+fcr.Sales_CR_KAH_8_D__c+'",'+
    '"Sales_CR_KAH_9_A__c":"'+fcr.Sales_CR_KAH_9_A__c+'",'+
    '"Sales_CR_KAH_9_B__c":"'+fcr.Sales_CR_KAH_9_B__c+'", "Sales_CR_KAH_9_C__c":"'+fcr.Sales_CR_KAH_9_C__c+'",'+
    '"Sales_CR_KAH_9_D__c":"'+fcr.Sales_CR_KAH_9_D__c+'"'+
    '}, "hhCR":{'+
    '"Sales_CR_KAH_1_A__c":"'+fcr.Sales_CR_KAH_1_A__c+'", "Sales_CR_KAH_1_B__c":"'+fcr.Sales_CR_KAH_1_B__c+'",'+
    '"Sales_CR_KAH_1_C__c":"'+fcr.Sales_CR_KAH_1_C__c+'", "Sales_CR_KAH_1_D__c":"'+fcr.Sales_CR_KAH_1_D__c+'",'+
    '"Sales_CR_KAH_2_A__c":"'+fcr.Sales_CR_KAH_2_A__c+'",'+
    '"Sales_CR_KAH_2_B__c":"'+fcr.Sales_CR_KAH_2_B__c+'", "Sales_CR_KAH_2_C__c":"'+fcr.Sales_CR_KAH_2_C__c+'",'+
    '"Sales_CR_KAH_2_D__c":"'+fcr.Sales_CR_KAH_2_D__c+'", "Sales_CR_KAH_3_A__c":"'+fcr.Sales_CR_KAH_3_A__c+'",'+
    '"Sales_CR_KAH_3_B__c":"'+fcr.Sales_CR_KAH_3_B__c+'", "Sales_CR_KAH_3_C__c":"'+fcr.Sales_CR_KAH_3_C__c+'",'+
    '"Sales_CR_KAH_3_D__c":"'+fcr.Sales_CR_KAH_3_D__c+'",'+
    '"Sales_CR_KAH_4_A__c":"'+fcr.Sales_CR_KAH_4_A__c+'", "Sales_CR_KAH_4_B__c":"'+fcr.Sales_CR_KAH_4_B__c+'",'+
    '"Sales_CR_KAH_4_C__c":"'+fcr.Sales_CR_KAH_4_C__c+'", "Sales_CR_KAH_4_D__c":"'+fcr.Sales_CR_KAH_4_D__c+'",'+
    '"Sales_CR_KAH_6_A__c":"'+fcr.Sales_CR_KAH_6_A__c+'",'+
    '"Sales_CR_KAH_6_B__c":"'+fcr.Sales_CR_KAH_6_B__c+'", "Sales_CR_KAH_6_C__c":"'+fcr.Sales_CR_KAH_6_C__c+'",'+
    '"Sales_CR_KAH_6_D__c":"'+fcr.Sales_CR_KAH_6_D__c+'", "Sales_CR_KAH_7_A__c":"'+fcr.Sales_CR_KAH_7_A__c+'",'+
    '"Sales_CR_KAH_7_B__c":"'+fcr.Sales_CR_KAH_7_B__c+'",'+
    '"Sales_CR_KAH_7_C__c":"'+fcr.Sales_CR_KAH_7_C__c+'", "Sales_CR_KAH_7_D__c":"'+fcr.Sales_CR_KAH_7_D__c+'",'+
    '"Sales_CR_KAH_8_A__c":"'+fcr.Sales_CR_KAH_8_A__c+'", "Sales_CR_KAH_8_B__c":"'+fcr.Sales_CR_KAH_8_B__c+'",'+
    '"Sales_CR_KAH_8_C__c":"'+fcr.Sales_CR_KAH_8_C__c+'", "Sales_CR_KAH_8_D__c":"'+fcr.Sales_CR_KAH_8_D__c+'",'+
    '"Sales_CR_KAH_9_A__c":"'+fcr.Sales_CR_KAH_9_A__c+'",'+
    '"Sales_CR_KAH_9_B__c":"'+fcr.Sales_CR_KAH_9_B__c+'", "Sales_CR_KAH_9_C__c":"'+fcr.Sales_CR_KAH_9_C__c+'",'+
    '"Sales_CR_KAH_9_D__c":"'+fcr.Sales_CR_KAH_9_D__c+'"'+
    '}, "fcr":{'+
    '"Sales_FCR_KAH_1_A__c":"'+fcr.Sales_FCR_KAH_1_A__c+'",'+
    '"Sales_FCR_KAH_1_B__c":"'+fcr.Sales_FCR_KAH_1_B__c+'", "Sales_FCR_KAH_1_C__c":"'+fcr.Sales_FCR_KAH_1_C__c+'",'+
    '"Sales_FCR_KAH_1_D__c":"'+fcr.Sales_FCR_KAH_1_D__c+'",'+
    '"Sales_FCR_KAH_1_E__c":"'+fcr.Sales_FCR_KAH_1_E__c+'", "Sales_FCR_KAH_1_F__c":"'+fcr.Sales_FCR_KAH_1_F__c+'",'+
    '"Sales_FCR_KAH_1_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_1_Text__c)+'", "Sales_FCR_KAH_2_A__c":"'+fcr.Sales_FCR_KAH_2_A__c+'",'+
    '"Sales_FCR_KAH_2_B__c":"'+fcr.Sales_FCR_KAH_2_B__c+'", "Sales_FCR_KAH_2_C__c":"'+fcr.Sales_FCR_KAH_2_C__c+'",'+
    '"Sales_FCR_KAH_2_D__c":"'+fcr.Sales_FCR_KAH_2_D__c+'",'+
    '"Sales_FCR_KAH_2_E__c":"'+fcr.Sales_FCR_KAH_2_E__c+'", "Sales_FCR_KAH_2_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_2_Text__c)+'",'+
    '"Sales_FCR_KAH_3_A__c":"'+fcr.Sales_FCR_KAH_3_A__c+'", "Sales_FCR_KAH_3_B__c":"'+fcr.Sales_FCR_KAH_3_B__c+'",'+
    '"Sales_FCR_KAH_3_C__c":"'+fcr.Sales_FCR_KAH_3_C__c+'", "Sales_FCR_KAH_3_D__c":"'+fcr.Sales_FCR_KAH_3_D__c+'",'+
    '"Sales_FCR_KAH_3_E__c":"'+fcr.Sales_FCR_KAH_3_E__c+'",'+
    '"Sales_FCR_KAH_3_F__c":"'+fcr.Sales_FCR_KAH_3_F__c+'", "Sales_FCR_KAH_3_G__c":"'+fcr.Sales_FCR_KAH_3_G__c+'",'+
    '"Sales_FCR_KAH_3_H__c":"'+fcr.Sales_FCR_KAH_3_H__c+'", "Sales_FCR_KAH_3_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_3_Text__c)+'",'+
    '"Sales_FCR_KAH_4_Leader_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'", "Sales_FCR_KAH_4_Rep_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'"'+
    '}, "fcrAF":{'+
    '"Sales_FCR_KAH_1_A__c":"'+fcr.Sales_FCR_KAH_1_A__c+'",'+
    '"Sales_FCR_KAH_1_B__c":"'+fcr.Sales_FCR_KAH_1_B__c+'", "Sales_FCR_KAH_1_C__c":"'+fcr.Sales_FCR_KAH_1_C__c+'",'+
    '"Sales_FCR_KAH_1_D__c":"'+fcr.Sales_FCR_KAH_1_D__c+'",'+
    '"Sales_FCR_KAH_1_E__c":"'+fcr.Sales_FCR_KAH_1_E__c+'", "Sales_FCR_KAH_1_F__c":"'+fcr.Sales_FCR_KAH_1_F__c+'",'+
    '"Sales_FCR_KAH_1_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_1_Text__c)+'", "Sales_FCR_KAH_2_A__c":"'+fcr.Sales_FCR_KAH_2_A__c+'",'+
    '"Sales_FCR_KAH_2_B__c":"'+fcr.Sales_FCR_KAH_2_B__c+'", "Sales_FCR_KAH_2_C__c":"'+fcr.Sales_FCR_KAH_2_C__c+'",'+
    '"Sales_FCR_KAH_2_D__c":"'+fcr.Sales_FCR_KAH_2_D__c+'",'+
    '"Sales_FCR_KAH_2_E__c":"'+fcr.Sales_FCR_KAH_2_E__c+'", "Sales_FCR_KAH_2_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_2_Text__c)+'",'+
    '"Sales_FCR_KAH_TAF_3_A__c":"'+fcr.Sales_FCR_KAH_TAF_3_A__c+'", "Sales_FCR_KAH_TAF_3_B__c":"'+fcr.Sales_FCR_KAH_TAF_3_B__c+'",'+
    '"Sales_FCR_KAH_TAF_3_C__c":"'+fcr.Sales_FCR_KAH_TAF_3_C__c+'", "Sales_FCR_KAH_TAF_3_D1__c":"'+fcr.Sales_FCR_KAH_TAF_3_D1__c+'",'+
    '"Sales_FCR_KAH_TAF_3_D2__c":"'+fcr.Sales_FCR_KAH_TAF_3_D2__c+'",'+
    '"Sales_FCR_KAH_TAF_3_D3__c":"'+fcr.Sales_FCR_KAH_TAF_3_D3__c+'", "Sales_FCR_KAH_TAF_3_E__c":"'+fcr.Sales_FCR_KAH_TAF_3_E__c+'",'+
    '"Sales_FCR_KAH_TAF_3_F__c":"'+fcr.Sales_FCR_KAH_TAF_3_F__c+'", "Sales_FCR_KAH_TAF_3_G__c":"'+fcr.Sales_FCR_KAH_TAF_3_G__c+'",'+
    '"Sales_FCR_KAH_3_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_3_Text__c)+'",'+
    '"Sales_FCR_KAH_4_Leader_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'", "Sales_FCR_KAH_4_Rep_Text__c":"'+escapeJSON(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'"'+
    '}, "sa":{'+
    '"Sales_PRA_KAH_1_A__c":"'+fcr.Sales_PRA_KAH_1_A__c+'", "Sales_PRA_KAH_1_B__c":"'+fcr.Sales_PRA_KAH_1_B__c+'",'+
    '"Sales_PRA_KAH_2_A__c":"'+fcr.Sales_PRA_KAH_2_A__c+'", "Sales_PRA_KAH_2_B__c":"'+fcr.Sales_PRA_KAH_2_B__c+'",'+
    '"Sales_PRA_KAH_3_A__c":"'+fcr.Sales_PRA_KAH_3_A__c+'", "Sales_PRA_KAH_3_B__c":"'+fcr.Sales_PRA_KAH_3_B__c+'",'+
    '"Sales_PRA_KAH_4_A__c":"'+fcr.Sales_PRA_KAH_4_A__c+'",'+
    '"Sales_PRA_KAH_4_B__c":"'+fcr.Sales_PRA_KAH_4_B__c+'", "Sales_PRA_KAH_5_A__c":"'+fcr.Sales_PRA_KAH_5_A__c+'",'+
    '"Sales_PRA_KAH_5_B__c":"'+fcr.Sales_PRA_KAH_5_B__c+'", "Sales_PRA_KAH_6_A__c":"'+fcr.Sales_PRA_KAH_6_A__c+'",'+
    '"Sales_PRA_KAH_6_B__c":"'+fcr.Sales_PRA_KAH_6_B__c+'", "Sales_PRA_KAH_7_A__c":"'+fcr.Sales_PRA_KAH_7_A__c+'",'+
    '"Sales_PRA_KAH_7_B__c":"'+fcr.Sales_PRA_KAH_7_B__c+'",'+
    '"Sales_PRA_KAH_8_A__c":"'+fcr.Sales_PRA_KAH_8_A__c+'", "Sales_PRA_KAH_8_B__c":"'+fcr.Sales_PRA_KAH_8_B__c+'"'+
    '}, "af":{'+
    '"Sales_TAF_KAH_1_Text__c":"'+escapeJSON(fcr.Sales_TAF_KAH_1_Text__c)+'", "Sales_TAF_KAH_2_Text__c":"'+escapeJSON(fcr.Sales_TAF_KAH_2_Text__c)+'",'+
    '"Sales_TAF_KAH_3_Text__c":"'+escapeJSON(fcr.Sales_TAF_KAH_3_Text__c)+'", "Sales_TAF_KAH_4a_Text__c":"'+escapeJSON(fcr.Sales_TAF_KAH_4a_Text__c)+'",'+
    '"Sales_TAF_KAH_4b_Text__c":"'+escapeJSON(fcr.Sales_TAF_KAH_4b_Text__c)+'", "Sales_TAF_KAH_4c_Text__c":"'+escapeJSON(fcr.Sales_TAF_KAH_4c_Text__c)+'"'+
    '}'+
    '}'+
    '}';
  }

  private static String escapeJSON(String json){
    if(json!=null){
      json = json.replace('\\', '/');
      json = json.replace('\r\n', ' ');
      json = json.replace('\n', ' ');
      json = json.replace('\r', ' ');
      json = json.replace('"', '\\"');
    }
    return json;
  }

  @RemoteAction global static String getSP(String uId, Integer monthOffset){
    String html = '{"body":"';
    Date month = Date.newInstance(System.now().year(), System.now().month()+monthOffset, 1);
    String spCalls='<div class=\\"lnr lnr-cross\\"></div>', spTargetHH='<div class=\\"lnr lnr-cross\\"></div>', spActualHH='<div class=\\"lnr lnr-cross\\"></div>',
    spTargetHP='<div class=\\"lnr lnr-cross\\"></div>', spActualHP='<div class=\\"lnr lnr-cross\\"></div>', spPercentHH='<div class=\\"lnr lnr-cross\\"></div>',
    spPercentHP='<div class=\\"lnr lnr-cross\\"></div>';

    List<Sales_Performance__c> sps = [select Owner.Name, Sales_Calls__c, KAH_HH_Admit_Target__c, KAH_HH_PPS_Qualified_Admits__c, KAH_HP_Admit_Target__c, KAH_HP_Total_Admits__c
    from Sales_Performance__c where Month__c=:month and OwnerId=:uId];

    List<User> u = [select Line_of_Business__c, LastLoginDate from user where Id=:uId];

    if(u[0].Line_of_Business__c!=null && u[0].Line_of_Business__c.contains('HH')){
      String hhColor='red';
      Decimal num = 0.0;
      if(!sps.isEmpty() && sps[0].KAH_HH_PPS_Qualified_Admits__c!=null) spActualHH = String.valueOf(sps[0].KAH_HH_PPS_Qualified_Admits__c.setScale(1));
      if(!sps.isEmpty() && sps[0].KAH_HH_Admit_Target__c!=null){
        spTargetHH = String.valueOf(sps[0].KAH_HH_Admit_Target__c.setScale(1));
        if(sps[0].KAH_HH_PPS_Qualified_Admits__c!=null) num = ((sps[0].KAH_HH_PPS_Qualified_Admits__c/sps[0].KAH_HH_Admit_Target__c)*100).setScale(1);
        if(num >= 105) hhColor = 'blue';
        else if(num >= 100) hhColor = 'green';
        else if(num >= 85) hhColor = 'yellow';
      }

      html+='<div class=\\"salesPerformance '+hhColor+'\\">'+
      '<div class=\\"bold\\">HH Admits</div>'+
      '<div class=\\"regular\\"><span class=\\"spData\\"><div>Target</div><div>'+spTargetHH+'</div></span>'+
      '<span class=\\"spData\\"><div>Actual</div><div>'+spActualHH+'</div></span>'+
      '<span class=\\"spData\\"><div>% to Target</div><div>'+num+'%</div></span></div>';
      html+='</div>';
    }


    if(u[0].Line_of_Business__c!=null && u[0].Line_of_Business__c.contains('HP')){
      String hpColor='red';
      Decimal num = 0.0;
      if(!sps.isEmpty() && sps[0].KAH_HP_Total_Admits__c!=null) spActualHP = String.valueOf(sps[0].KAH_HP_Total_Admits__c.setScale(1));
      if(!sps.isEmpty() && sps[0].KAH_HP_Admit_Target__c!=null){
        spTargetHP = String.valueOf(sps[0].KAH_HP_Admit_Target__c.setScale(1));
        if(sps[0].KAH_HP_Total_Admits__c!=null) num = ((sps[0].KAH_HP_Total_Admits__c/sps[0].KAH_HP_Admit_Target__c)*100).setScale(1);
        if(num >= 105)hpColor = 'blue';
        else if(num >= 100) hpColor = 'green';
        else if(num >= 85) hpColor = 'yellow';
      }

      if(spTargetHP.isNumericSpace() && Integer.valueOf(spTargetHP)!=0) spPercentHP = String.valueOf(((Decimal.valueOf(spActualHP)/Decimal.valueOf(spTargetHP))*100).setScale(1));

      html+='<div class=\\"salesPerformance '+hpColor+'\\">'+
      '<div class=\\"bold\\">HP Admits</div>'+
      '<div class=\\"regular\\"><span class=\\"spData\\"><div>Target</div><div>'+spTargetHP+'</div></span>'+
      '<span class=\\"spData\\"><div>Actual</div><div>'+spActualHP+'</div></span>'+
      '<span class=\\"spData\\"><div>% to Target</div><div>'+num+'%</div></span></div>';
      html+='</div>';
    }


    Decimal avgCalls = 0.0;
    if(!sps.isEmpty() && sps[0].Sales_Calls__c!=null){
      spCalls = String.valueOf(sps[0].Sales_Calls__c);
      avgCalls = ((Decimal.valueOf(spCalls)/21)*5).setScale(1);
    }

    html+='<div class=\\"salesPerformance\\">'+
    '<div class=\\"bold\\">Sales Calls</div>'+
    '<div class=\\"regular\\"><span class=\\"spData\\"><div>Avg Calls Per Week</div><div>'+avgCalls+'</div></span><span class=\\"spData\\"><div>Completed Calls</div><div>'+spCalls+'</div></span></div>';
    html+='</div>';
    html+='", "footer":"';

    Integer num = 0;
    for(AggregateResult ar : [select count(id) num from Contact_Team__c where User__c = :uId]){
      num += Integer.valueOf(ar.get('num'));
    }
    for(AggregateResult ar : [select count(id) num from AccountTeammember where UserId = :uId]){
      num += Integer.valueOf(ar.get('num'));
    }

    html+='<div class=\\"regular\\">'+
    '<span class=\\"spData\\"><div>Total Assignments</div><div>'+num+'</div></span>';
    if(u[0].LastLoginDate!=null) html += '<span class=\\"spData\\"><div>Last Login</div><div>'+Date.valueOf(u[0].LastLoginDate).format()+'</div></span>';
    else html += '<span class=\\"spData\\"><div>Last Login</div><div><div class=\\"lnr lnr-cross\\"></div></div></span>';
    html += '</div>'+
    '"}';

    return html;
  }

  @RemoteAction global static Boolean updateFCR(String fcrId, String json){
    JSON2Apex data = parse(json);
    List<Field_Coaching_Report__c> fcrs = [select Id, Status__c from Field_Coaching_Report__c where Id=:fcrId];
    for(Field_Coaching_Report__c fcr : fcrs){
      if(fcr.Status__c != 'Completed'){
        if(data.fcrType == 'fcr'){
          fcr.Sales_FCR_KAH_1_A__c = data.Fcr.Sales_FCR_KAH_1_A;
          fcr.Sales_FCR_KAH_1_B__c = data.Fcr.Sales_FCR_KAH_1_B;
          fcr.Sales_FCR_KAH_1_C__c = data.Fcr.Sales_FCR_KAH_1_C;
          fcr.Sales_FCR_KAH_1_D__c = data.Fcr.Sales_FCR_KAH_1_D;
          fcr.Sales_FCR_KAH_1_E__c = data.Fcr.Sales_FCR_KAH_1_E;
          fcr.Sales_FCR_KAH_1_F__c = data.Fcr.Sales_FCR_KAH_1_F;
          fcr.Sales_FCR_KAH_1_Text__c = data.Fcr.Sales_FCR_KAH_1_Text;
          fcr.Sales_FCR_KAH_2_A__c = data.Fcr.Sales_FCR_KAH_2_A;
          fcr.Sales_FCR_KAH_2_B__c = data.Fcr.Sales_FCR_KAH_2_B;
          fcr.Sales_FCR_KAH_2_C__c = data.Fcr.Sales_FCR_KAH_2_C;
          fcr.Sales_FCR_KAH_2_D__c = data.Fcr.Sales_FCR_KAH_2_D;
          fcr.Sales_FCR_KAH_2_E__c = data.Fcr.Sales_FCR_KAH_2_E;
          fcr.Sales_FCR_KAH_2_Text__c = data.Fcr.Sales_FCR_KAH_2_Text;
          fcr.Sales_FCR_KAH_3_A__c = data.Fcr.Sales_FCR_KAH_3_A;
          fcr.Sales_FCR_KAH_3_B__c = data.Fcr.Sales_FCR_KAH_3_B;
          fcr.Sales_FCR_KAH_3_C__c = data.Fcr.Sales_FCR_KAH_3_C;
          fcr.Sales_FCR_KAH_3_D__c = data.Fcr.Sales_FCR_KAH_3_D;
          fcr.Sales_FCR_KAH_3_E__c = data.Fcr.Sales_FCR_KAH_3_E;
          fcr.Sales_FCR_KAH_3_F__c = data.Fcr.Sales_FCR_KAH_3_F;
          fcr.Sales_FCR_KAH_3_G__c = data.Fcr.Sales_FCR_KAH_3_G;
          fcr.Sales_FCR_KAH_3_H__c = data.Fcr.Sales_FCR_KAH_3_H;
          fcr.Sales_FCR_KAH_3_Text__c = data.Fcr.Sales_FCR_KAH_3_Text;
          // fcr.Sales_FCR_KAH_4_Leader_Text__c = data.Fcr.Sales_FCR_KAH_4_Leader_Text;
        } else if(data.fcrType == 'fcrAF'){
          fcr.Sales_FCR_KAH_1_A__c = data.FcrAF.Sales_FCR_KAH_1_A;
          fcr.Sales_FCR_KAH_1_B__c = data.FcrAF.Sales_FCR_KAH_1_B;
          fcr.Sales_FCR_KAH_1_C__c = data.FcrAF.Sales_FCR_KAH_1_C;
          fcr.Sales_FCR_KAH_1_D__c = data.FcrAF.Sales_FCR_KAH_1_D;
          fcr.Sales_FCR_KAH_1_E__c = data.FcrAF.Sales_FCR_KAH_1_E;
          fcr.Sales_FCR_KAH_1_F__c = data.FcrAF.Sales_FCR_KAH_1_F;
          fcr.Sales_FCR_KAH_1_Text__c = data.FcrAF.Sales_FCR_KAH_1_Text;
          fcr.Sales_FCR_KAH_2_A__c = data.FcrAF.Sales_FCR_KAH_2_A;
          fcr.Sales_FCR_KAH_2_B__c = data.FcrAF.Sales_FCR_KAH_2_B;
          fcr.Sales_FCR_KAH_2_C__c = data.FcrAF.Sales_FCR_KAH_2_C;
          fcr.Sales_FCR_KAH_2_D__c = data.FcrAF.Sales_FCR_KAH_2_D;
          fcr.Sales_FCR_KAH_2_E__c = data.FcrAF.Sales_FCR_KAH_2_E;
          fcr.Sales_FCR_KAH_2_Text__c = data.FcrAF.Sales_FCR_KAH_2_Text;
          fcr.Sales_FCR_KAH_3_Text__c = data.FcrAF.Sales_FCR_KAH_3_Text;
          fcr.Sales_FCR_KAH_TAF_3_A__c = data.FcrAF.Sales_FCR_KAH_TAF_3_A;
          fcr.Sales_FCR_KAH_TAF_3_B__c = data.FcrAF.Sales_FCR_KAH_TAF_3_B;
          fcr.Sales_FCR_KAH_TAF_3_C__c = data.FcrAF.Sales_FCR_KAH_TAF_3_C;
          fcr.Sales_FCR_KAH_TAF_3_D1__c = data.FcrAF.Sales_FCR_KAH_TAF_3_D1;
          fcr.Sales_FCR_KAH_TAF_3_D2__c = data.FcrAF.Sales_FCR_KAH_TAF_3_D2;
          fcr.Sales_FCR_KAH_TAF_3_D3__c = data.FcrAF.Sales_FCR_KAH_TAF_3_D3;
          fcr.Sales_FCR_KAH_TAF_3_E__c = data.FcrAF.Sales_FCR_KAH_TAF_3_E;
          fcr.Sales_FCR_KAH_TAF_3_F__c = data.FcrAF.Sales_FCR_KAH_TAF_3_F;
          fcr.Sales_FCR_KAH_TAF_3_G__c = data.FcrAF.Sales_FCR_KAH_TAF_3_G;
          // fcr.Sales_FCR_KAH_4_Leader_Text__c = data.FcrAF.Sales_FCR_KAH_4_Leader_Text;
        }

        if(data.fcrType == 'hpCR'){
          fcr.Sales_CR_KAH_1_A__c = data.HpCR.Sales_CR_KAH_1_A;
          fcr.Sales_CR_KAH_1_B__c = data.HpCR.Sales_CR_KAH_1_B;
          fcr.Sales_CR_KAH_1_C__c = data.HpCR.Sales_CR_KAH_1_C;
          fcr.Sales_CR_KAH_1_D__c = data.HpCR.Sales_CR_KAH_1_D;
          fcr.Sales_CR_KAH_2_A__c = data.HpCR.Sales_CR_KAH_2_A;
          fcr.Sales_CR_KAH_2_B__c = data.HpCR.Sales_CR_KAH_2_B;
          fcr.Sales_CR_KAH_2_C__c = data.HpCR.Sales_CR_KAH_2_C;
          fcr.Sales_CR_KAH_2_D__c = data.HpCR.Sales_CR_KAH_2_D;
          fcr.Sales_CR_KAH_3_A__c = data.HpCR.Sales_CR_KAH_3_A;
          fcr.Sales_CR_KAH_3_B__c = data.HpCR.Sales_CR_KAH_3_B;
          fcr.Sales_CR_KAH_3_C__c = data.HpCR.Sales_CR_KAH_3_C;
          fcr.Sales_CR_KAH_3_D__c = data.HpCR.Sales_CR_KAH_3_D;
          fcr.Sales_CR_KAH_4_A__c = data.HpCR.Sales_CR_KAH_4_A;
          fcr.Sales_CR_KAH_4_B__c = data.HpCR.Sales_CR_KAH_4_B;
          fcr.Sales_CR_KAH_4_C__c = data.HpCR.Sales_CR_KAH_4_C;
          fcr.Sales_CR_KAH_4_D__c = data.HpCR.Sales_CR_KAH_4_D;
          fcr.Sales_CR_KAH_5_A__c = data.HpCR.Sales_CR_KAH_5_A;
          fcr.Sales_CR_KAH_5_B__c = data.HpCR.Sales_CR_KAH_5_B;
          fcr.Sales_CR_KAH_5_C__c = data.HpCR.Sales_CR_KAH_5_C;
          fcr.Sales_CR_KAH_5_D__c = data.HpCR.Sales_CR_KAH_5_D;
          fcr.Sales_CR_KAH_6_A__c = data.HpCR.Sales_CR_KAH_6_A;
          fcr.Sales_CR_KAH_6_B__c = data.HpCR.Sales_CR_KAH_6_B;
          fcr.Sales_CR_KAH_6_C__c = data.HpCR.Sales_CR_KAH_6_C;
          fcr.Sales_CR_KAH_6_D__c = data.HpCR.Sales_CR_KAH_6_D;
          fcr.Sales_CR_KAH_7_A__c = data.HpCR.Sales_CR_KAH_7_A;
          fcr.Sales_CR_KAH_7_B__c = data.HpCR.Sales_CR_KAH_7_B;
          fcr.Sales_CR_KAH_7_C__c = data.HpCR.Sales_CR_KAH_7_C;
          fcr.Sales_CR_KAH_7_D__c = data.HpCR.Sales_CR_KAH_7_D;
          fcr.Sales_CR_KAH_8_A__c = data.HpCR.Sales_CR_KAH_8_A;
          fcr.Sales_CR_KAH_8_B__c = data.HpCR.Sales_CR_KAH_8_B;
          fcr.Sales_CR_KAH_8_C__c = data.HpCR.Sales_CR_KAH_8_C;
          fcr.Sales_CR_KAH_8_D__c = data.HpCR.Sales_CR_KAH_8_D;
          fcr.Sales_CR_KAH_9_A__c = data.HpCR.Sales_CR_KAH_9_A;
          fcr.Sales_CR_KAH_9_B__c = data.HpCR.Sales_CR_KAH_9_B;
          fcr.Sales_CR_KAH_9_C__c = data.HpCR.Sales_CR_KAH_9_C;
          fcr.Sales_CR_KAH_9_D__c = data.HpCR.Sales_CR_KAH_9_D;
        } else if(data.fcrType == 'hhCR'){
          fcr.Sales_CR_KAH_1_A__c = data.HhCR.Sales_CR_KAH_1_A;
          fcr.Sales_CR_KAH_1_B__c = data.HhCR.Sales_CR_KAH_1_B;
          fcr.Sales_CR_KAH_1_C__c = data.HhCR.Sales_CR_KAH_1_C;
          fcr.Sales_CR_KAH_1_D__c = data.HhCR.Sales_CR_KAH_1_D;
          fcr.Sales_CR_KAH_2_A__c = data.HhCR.Sales_CR_KAH_2_A;
          fcr.Sales_CR_KAH_2_B__c = data.HhCR.Sales_CR_KAH_2_B;
          fcr.Sales_CR_KAH_2_C__c = data.HhCR.Sales_CR_KAH_2_C;
          fcr.Sales_CR_KAH_2_D__c = data.HhCR.Sales_CR_KAH_2_D;
          fcr.Sales_CR_KAH_3_A__c = data.HhCR.Sales_CR_KAH_3_A;
          fcr.Sales_CR_KAH_3_B__c = data.HhCR.Sales_CR_KAH_3_B;
          fcr.Sales_CR_KAH_3_C__c = data.HhCR.Sales_CR_KAH_3_C;
          fcr.Sales_CR_KAH_3_D__c = data.HhCR.Sales_CR_KAH_3_D;
          fcr.Sales_CR_KAH_4_A__c = data.HhCR.Sales_CR_KAH_4_A;
          fcr.Sales_CR_KAH_4_B__c = data.HhCR.Sales_CR_KAH_4_B;
          fcr.Sales_CR_KAH_4_C__c = data.HhCR.Sales_CR_KAH_4_C;
          fcr.Sales_CR_KAH_4_D__c = data.HhCR.Sales_CR_KAH_4_D;
          fcr.Sales_CR_KAH_6_A__c = data.HhCR.Sales_CR_KAH_6_A;
          fcr.Sales_CR_KAH_6_B__c = data.HhCR.Sales_CR_KAH_6_B;
          fcr.Sales_CR_KAH_6_C__c = data.HhCR.Sales_CR_KAH_6_C;
          fcr.Sales_CR_KAH_6_D__c = data.HhCR.Sales_CR_KAH_6_D;
          fcr.Sales_CR_KAH_7_A__c = data.HhCR.Sales_CR_KAH_7_A;
          fcr.Sales_CR_KAH_7_B__c = data.HhCR.Sales_CR_KAH_7_B;
          fcr.Sales_CR_KAH_7_C__c = data.HhCR.Sales_CR_KAH_7_C;
          fcr.Sales_CR_KAH_7_D__c = data.HhCR.Sales_CR_KAH_7_D;
          fcr.Sales_CR_KAH_8_A__c = data.HhCR.Sales_CR_KAH_8_A;
          fcr.Sales_CR_KAH_8_B__c = data.HhCR.Sales_CR_KAH_8_B;
          fcr.Sales_CR_KAH_8_C__c = data.HhCR.Sales_CR_KAH_8_C;
          fcr.Sales_CR_KAH_8_D__c = data.HhCR.Sales_CR_KAH_8_D;
          fcr.Sales_CR_KAH_9_A__c = data.HhCR.Sales_CR_KAH_9_A;
          fcr.Sales_CR_KAH_9_B__c = data.HhCR.Sales_CR_KAH_9_B;
          fcr.Sales_CR_KAH_9_C__c = data.HhCR.Sales_CR_KAH_9_C;
          fcr.Sales_CR_KAH_9_D__c = data.HhCR.Sales_CR_KAH_9_D;
        }
        fcr.Sales_PRA_KAH_1_A__c = data.Sa.Sales_PRA_KAH_1_A;
        fcr.Sales_PRA_KAH_1_B__c = data.Sa.Sales_PRA_KAH_1_B;
        fcr.Sales_PRA_KAH_2_A__c = data.Sa.Sales_PRA_KAH_2_A;
        fcr.Sales_PRA_KAH_2_B__c = data.Sa.Sales_PRA_KAH_2_B;
        fcr.Sales_PRA_KAH_3_A__c = data.Sa.Sales_PRA_KAH_3_A;
        fcr.Sales_PRA_KAH_3_B__c = data.Sa.Sales_PRA_KAH_3_B;
        fcr.Sales_PRA_KAH_4_A__c = data.Sa.Sales_PRA_KAH_4_A;
        fcr.Sales_PRA_KAH_4_B__c = data.Sa.Sales_PRA_KAH_4_B;
        fcr.Sales_PRA_KAH_5_A__c = data.Sa.Sales_PRA_KAH_5_A;
        fcr.Sales_PRA_KAH_5_B__c = data.Sa.Sales_PRA_KAH_5_B;
        fcr.Sales_PRA_KAH_6_A__c = data.Sa.Sales_PRA_KAH_6_A;
        fcr.Sales_PRA_KAH_6_B__c = data.Sa.Sales_PRA_KAH_6_B;
        fcr.Sales_PRA_KAH_7_A__c = data.Sa.Sales_PRA_KAH_7_A;
        fcr.Sales_PRA_KAH_7_B__c = data.Sa.Sales_PRA_KAH_7_B;
        fcr.Sales_PRA_KAH_8_A__c = data.Sa.Sales_PRA_KAH_8_A;
        fcr.Sales_PRA_KAH_8_B__c = data.Sa.Sales_PRA_KAH_8_B;

        fcr.Sales_TAF_KAH_1_Text__c = data.Af.Sales_TAF_KAH_1_Text;
        fcr.Sales_TAF_KAH_2_Text__c = data.Af.Sales_TAF_KAH_2_Text;
        fcr.Sales_TAF_KAH_3_Text__c = data.Af.Sales_TAF_KAH_3_Text;
        fcr.Sales_TAF_KAH_4a_Text__c = data.Af.Sales_TAF_KAH_4a_Text;
        fcr.Sales_TAF_KAH_4b_Text__c = data.Af.Sales_TAF_KAH_4b_Text;
        fcr.Sales_TAF_KAH_4c_Text__c = data.Af.Sales_TAF_KAH_4c_Text;
      }
    }

    update fcrs;
    return true;
  }

  private static List<Map<Id, Integer>> placeData(List<Map<Id, Integer>> data, Id rt, Date d, List<String> dates){
    Boolean placed = false;
    for(Integer i=0; !placed; i++){
      if(d >= Date.valueOf(dates[i].substring(0,dates[i].indexOf(' '))) && d <= Date.valueOf(dates[i].substring(dates[i].indexOf(' ')+1, dates[i].length()))){
        Map<Id, Integer> temp = data.remove(i);
        if(temp.containsKey(rt)){
          Integer j = temp.remove(rt);
          j++;
          temp.put(rt, j);
        } else {
          temp.put(rt, 1);
        }
        data.add(i, temp);
        placed = true;
      }
    }
    return data;
  }

  @RemoteAction global static String getManagedUsers(List<String> dates){
    Id roleId = UserInfo.getUserRoleId();
    String html = '';
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    allSubRoleIds.add(UserInfo.getUserRoleId());

    Map<Id, List<Map<Id, Integer>>> data = new Map<Id, List<Map<Id, Integer>>>();
    Map<Id, String> names = new Map<Id, String>();

    for(User u : [select Id, Name from User where UserRoleId in :allSubRoleIds and isActive=true order by name asc]){
      names.put(u.Id, u.Name);
    }

    for(Field_Coaching_Report__c fcr : [select OwnerId, Owner.Name, RecordTypeId, Date__c from Field_Coaching_Report__c
    where Owner.UserRoleId in :allSubRoleIds and Owner.isActive =true and Date__c>=:Date.valueOf(dates[0].substring(0,dates[0].indexOf(' ')))
    and Date__c<=:Date.valueOf(dates[dates.size()-1].substring(dates[dates.size()-1].indexOf(' ')+1, dates[dates.size()-1].length())) order by OwnerId, RecordTypeId] ){
      if(data.containsKey(fcr.OwnerId)){
        List<Map<Id, Integer>> temp = data.remove(fcr.OwnerId);
        data.put(fcr.OwnerId, placeData(temp, fcr.RecordTypeId, fcr.Date__c, dates));
      } else {
        data.put(fcr.OwnerId, placeData(new List<Map<Id, Integer>>{new Map<Id, Integer>(), new Map<Id, Integer>(), new Map<Id, Integer>(),
          new Map<Id, Integer>(), new Map<Id, Integer>(), new Map<Id, Integer>()}, fcr.RecordTypeId, fcr.Date__c, dates));
        }
      }

      for(Id key : names.keySet()){
        if(data.containsKey(key)){
          List<Map<Id, Integer>> d = data.remove(key);
          html += '<tr>'+
          '<td class="blueLink" style="padding-left:15px;" data-userId="'+key+'">'+names.get(key)+'<i style="float:right;margin-top:2px;" class="fa fa-plus-circle" aria-hidden="true"></i></td>';
          for(Integer i=0; i< d.size(); i++){
            if(d[i].isEmpty()){
              html += '<td style="cursor:default;"></td>';
            } else {
              html += '<td>';
              for(Id recordType : d[i].keySet()){
                if(recordType==kahCrHH.Id)
                html += '<div class="totalDots inline blue">'+d[i].get(recordType)+'</div>';
                else if(recordType==kahCrHP.Id)
                html += '<div class="totalDots inline blue">'+d[i].get(recordType)+'</div>';
                else if(recordType==kahFcr.Id && d[i].containsKey(kahFcrAf.Id))
                html += '<div class="totalDots inline green">'+(d[i].get(recordType)+d[i].get(kahFcrAf.Id))+'</div>';
                else if(recordType==kahFcr.Id)
                html += '<div class="totalDots inline green">'+d[i].get(recordType)+'</div>';
                else if(recordType==kahFcrAf.Id && !d[i].containsKey(kahFcr.Id))
                html += '<div class="totalDots inline green">'+d[i].get(recordType)+'</div>';
                else if(recordType==kahSa.Id)
                html += '<div class="totalDots inline yellow">'+d[i].get(recordType)+'</div>';
                else if(recordType==kahAf.Id)
                html += '<div class="totalDots inline red">'+d[i].get(recordType)+'</div>';
              }
              html += '</td>';
            }
          }
          html+='</tr>';
        } else {
          html += '<tr>'+
          '<td class="blueLink" style="padding-left:15px;" data-userId="'+key+'">'+names.get(key)+'<i style="float:right;margin-top:2px;" class="fa fa-plus-circle" aria-hidden="true"></i></td>'+
          '<td style="cursor:default;"></td>'+
          '<td style="cursor:default;"></td>'+
          '<td style="cursor:default;"></td>'+
          '<td style="cursor:default;"></td>'+
          '<td style="cursor:default;"></td>'+
          '<td style="cursor:default;"></td>'+
          '</tr>';
        }
      }
      return html;
    }

    @RemoteAction global static Boolean completeFCR(Id fcrId){
      Boolean completed = false;
      Boolean isPrivate = false;
      List<Field_Coaching_Report__c> fcrs = [select Id, OwnerId, CreatedById, RecordTypeId, Sales_CR_KAH_1_A__c,Sales_CR_KAH_1_B__c,Sales_CR_KAH_1_C__c,Sales_CR_KAH_1_D__c,Sales_CR_KAH_2_A__c,
      Sales_CR_KAH_2_B__c,Sales_CR_KAH_2_C__c,Sales_CR_KAH_2_D__c,Sales_CR_KAH_3_A__c,Sales_CR_KAH_3_B__c,Sales_CR_KAH_3_C__c,Sales_CR_KAH_3_D__c,
      Sales_CR_KAH_4_A__c,Sales_CR_KAH_4_B__c,Sales_CR_KAH_4_C__c,Sales_CR_KAH_4_D__c,Sales_CR_KAH_5_A__c,Sales_CR_KAH_5_B__c,Sales_CR_KAH_5_C__c,
      Sales_CR_KAH_5_D__c,Sales_CR_KAH_6_A__c,Sales_CR_KAH_6_B__c,Sales_CR_KAH_6_C__c,Sales_CR_KAH_6_D__c,Sales_CR_KAH_7_A__c,Sales_CR_KAH_7_B__c,
      Sales_CR_KAH_7_C__c,Sales_CR_KAH_7_D__c,Sales_CR_KAH_8_A__c,Sales_CR_KAH_8_B__c,Sales_CR_KAH_8_C__c,Sales_CR_KAH_8_D__c,Sales_CR_KAH_9_A__c,
      Sales_CR_KAH_9_B__c,Sales_CR_KAH_9_C__c,Sales_CR_KAH_9_D__c, Sales_CR_KAH_1_Score__c, Sales_CR_KAH_2_Score__c, Sales_CR_KAH_3_Score__c,
      Sales_CR_KAH_4_Score__c, Sales_CR_KAH_5_Score__c, Sales_CR_KAH_6_Score__c, Sales_CR_KAH_7_Score__c,
      Sales_CR_KAH_8_Score__c, Sales_CR_KAH_9_Score__c, Sales_CR_KAH_Overall_Score__c, Sales_FCR_KAH_1_Score__c,
      Sales_FCR_KAH_2_Score__c, Sales_FCR_KAH_3_Score__c, Sales_FCR_KAH_Overall_Score__c, Sales_CR_KAH_Overall_Avg_Score__c,
      Sales_FCR_KAH_1_A__c,Sales_FCR_KAH_1_B__c,Sales_FCR_KAH_1_C__c,Sales_FCR_KAH_1_D__c,
      Sales_FCR_KAH_1_E__c,Sales_FCR_KAH_1_F__c,Sales_FCR_KAH_2_A__c,Sales_FCR_KAH_2_B__c,Sales_FCR_KAH_2_C__c,Sales_FCR_KAH_2_D__c,
      Sales_FCR_KAH_2_E__c,Sales_FCR_KAH_3_A__c,Sales_FCR_KAH_3_B__c,Sales_FCR_KAH_3_C__c,Sales_FCR_KAH_3_D__c,Sales_FCR_KAH_3_E__c,
      Sales_FCR_KAH_3_F__c,Sales_FCR_KAH_3_G__c,Sales_FCR_KAH_3_H__c,Sales_FCR_KAH_TAF_3_A__c,Sales_FCR_KAH_TAF_3_B__c,
      Sales_FCR_KAH_TAF_3_C__c,Sales_FCR_KAH_TAF_3_D1__c,Sales_FCR_KAH_TAF_3_D2__c,Sales_FCR_KAH_TAF_3_D3__c,Sales_FCR_KAH_TAF_3_E__c,Sales_FCR_KAH_TAF_3_F__c,
      Sales_FCR_KAH_TAF_3_G__c, Sales_Name__c, Sales_Email__c from Field_Coaching_Report__c where Id=:fcrId];
      for(Field_Coaching_Report__c fcr : fcrs){

        if(fcr.RecordTypeId == kahCrHP.Id){

          if (fcr.OwnerId != fcr.CreatedById) isPrivate = true;

          if (fcr.Sales_CR_KAH_1_A__c!=null && fcr.Sales_CR_KAH_1_B__c!=null && fcr.Sales_CR_KAH_1_C__c!=null && fcr.Sales_CR_KAH_1_D__c!=null
          && fcr.Sales_CR_KAH_2_A__c!=null && fcr.Sales_CR_KAH_2_B__c!=null && fcr.Sales_CR_KAH_2_C__c!=null && fcr.Sales_CR_KAH_2_D__c!=null
          && fcr.Sales_CR_KAH_3_A__c!=null && fcr.Sales_CR_KAH_3_B__c!=null && fcr.Sales_CR_KAH_3_C__c!=null && fcr.Sales_CR_KAH_3_D__c!=null
          && fcr.Sales_CR_KAH_4_A__c!=null && fcr.Sales_CR_KAH_4_B__c!=null && fcr.Sales_CR_KAH_4_C__c!=null && fcr.Sales_CR_KAH_4_D__c!=null
          && fcr.Sales_CR_KAH_5_A__c!=null && fcr.Sales_CR_KAH_5_B__c!=null && fcr.Sales_CR_KAH_5_C__c!=null && fcr.Sales_CR_KAH_5_D__c!=null
          && fcr.Sales_CR_KAH_6_A__c!=null && fcr.Sales_CR_KAH_6_B__c!=null && fcr.Sales_CR_KAH_6_C__c!=null && fcr.Sales_CR_KAH_6_D__c!=null
          && fcr.Sales_CR_KAH_7_A__c!=null && fcr.Sales_CR_KAH_7_B__c!=null && fcr.Sales_CR_KAH_7_C__c!=null && fcr.Sales_CR_KAH_7_D__c!=null
          && fcr.Sales_CR_KAH_8_A__c!=null && fcr.Sales_CR_KAH_8_B__c!=null && fcr.Sales_CR_KAH_8_C__c!=null && fcr.Sales_CR_KAH_8_D__c!=null
          && fcr.Sales_CR_KAH_9_A__c!=null && fcr.Sales_CR_KAH_9_B__c!=null && fcr.Sales_CR_KAH_9_C__c!=null && fcr.Sales_CR_KAH_9_D__c!=null){
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_1_A__c);
            summarizeFields(fcr.Sales_CR_KAH_1_B__c);
            summarizeFields(fcr.Sales_CR_KAH_1_C__c);
            summarizeFields(fcr.Sales_CR_KAH_1_D__c);
            fcr.Sales_CR_KAH_1_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_2_A__c);
            summarizeFields(fcr.Sales_CR_KAH_2_B__c);
            summarizeFields(fcr.Sales_CR_KAH_2_C__c);
            summarizeFields(fcr.Sales_CR_KAH_2_D__c);
            fcr.Sales_CR_KAH_2_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_3_A__c);
            summarizeFields(fcr.Sales_CR_KAH_3_B__c);
            summarizeFields(fcr.Sales_CR_KAH_3_C__c);
            summarizeFields(fcr.Sales_CR_KAH_3_D__c);
            fcr.Sales_CR_KAH_3_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_4_A__c);
            summarizeFields(fcr.Sales_CR_KAH_4_B__c);
            summarizeFields(fcr.Sales_CR_KAH_4_C__c);
            summarizeFields(fcr.Sales_CR_KAH_4_D__c);
            fcr.Sales_CR_KAH_4_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_5_A__c);
            summarizeFields(fcr.Sales_CR_KAH_5_B__c);
            summarizeFields(fcr.Sales_CR_KAH_5_C__c);
            summarizeFields(fcr.Sales_CR_KAH_5_D__c);
            fcr.Sales_CR_KAH_5_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_6_A__c);
            summarizeFields(fcr.Sales_CR_KAH_6_B__c);
            summarizeFields(fcr.Sales_CR_KAH_6_C__c);
            summarizeFields(fcr.Sales_CR_KAH_6_D__c);
            fcr.Sales_CR_KAH_6_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_7_A__c);
            summarizeFields(fcr.Sales_CR_KAH_7_B__c);
            summarizeFields(fcr.Sales_CR_KAH_7_C__c);
            summarizeFields(fcr.Sales_CR_KAH_7_D__c);
            fcr.Sales_CR_KAH_7_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_8_A__c);
            summarizeFields(fcr.Sales_CR_KAH_8_B__c);
            summarizeFields(fcr.Sales_CR_KAH_8_C__c);
            summarizeFields(fcr.Sales_CR_KAH_8_D__c);
            fcr.Sales_CR_KAH_8_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_9_A__c);
            summarizeFields(fcr.Sales_CR_KAH_9_B__c);
            summarizeFields(fcr.Sales_CR_KAH_9_C__c);
            summarizeFields(fcr.Sales_CR_KAH_9_D__c);
            fcr.Sales_CR_KAH_9_Score__c = sectionScore;
            sectionScore = 0;
            if(numberFilled!=0){
              fcr.Sales_CR_KAH_Overall_Score__c = (Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1);
            } else fcr.Sales_CR_KAH_Overall_Score__c = 0;

            fcr.Sales_CR_KAH_Overall_Avg_Score__c = (Decimal.valueOf(totalScore)/9.0).setScale(1);

            completed = true;
            fcr.Status__c = 'Completed';
          }
        } else if(fcr.RecordTypeId == kahCrHH.Id){

          if (fcr.OwnerId != fcr.CreatedById) isPrivate = true;

          if(fcr.Sales_CR_KAH_1_A__c!=null && fcr.Sales_CR_KAH_1_B__c!=null && fcr.Sales_CR_KAH_1_C__c!=null && fcr.Sales_CR_KAH_1_D__c!=null
          && fcr.Sales_CR_KAH_2_A__c!=null && fcr.Sales_CR_KAH_2_B__c!=null && fcr.Sales_CR_KAH_2_C__c!=null && fcr.Sales_CR_KAH_2_D__c!=null
          && fcr.Sales_CR_KAH_3_A__c!=null && fcr.Sales_CR_KAH_3_B__c!=null && fcr.Sales_CR_KAH_3_C__c!=null && fcr.Sales_CR_KAH_3_D__c!=null
          && fcr.Sales_CR_KAH_4_A__c!=null && fcr.Sales_CR_KAH_4_B__c!=null && fcr.Sales_CR_KAH_4_C__c!=null && fcr.Sales_CR_KAH_4_D__c!=null
          && fcr.Sales_CR_KAH_6_A__c!=null && fcr.Sales_CR_KAH_6_B__c!=null && fcr.Sales_CR_KAH_6_C__c!=null && fcr.Sales_CR_KAH_6_D__c!=null
          && fcr.Sales_CR_KAH_7_A__c!=null && fcr.Sales_CR_KAH_7_B__c!=null && fcr.Sales_CR_KAH_7_C__c!=null && fcr.Sales_CR_KAH_7_D__c!=null
          && fcr.Sales_CR_KAH_8_A__c!=null && fcr.Sales_CR_KAH_8_B__c!=null && fcr.Sales_CR_KAH_8_C__c!=null && fcr.Sales_CR_KAH_8_D__c!=null
          && fcr.Sales_CR_KAH_9_A__c!=null && fcr.Sales_CR_KAH_9_B__c!=null && fcr.Sales_CR_KAH_9_C__c!=null && fcr.Sales_CR_KAH_9_D__c!=null){
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_1_A__c);
            summarizeFields(fcr.Sales_CR_KAH_1_B__c);
            summarizeFields(fcr.Sales_CR_KAH_1_C__c);
            summarizeFields(fcr.Sales_CR_KAH_1_D__c);
            fcr.Sales_CR_KAH_1_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_2_A__c);
            summarizeFields(fcr.Sales_CR_KAH_2_B__c);
            summarizeFields(fcr.Sales_CR_KAH_2_C__c);
            summarizeFields(fcr.Sales_CR_KAH_2_D__c);
            fcr.Sales_CR_KAH_2_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_3_A__c);
            summarizeFields(fcr.Sales_CR_KAH_3_B__c);
            summarizeFields(fcr.Sales_CR_KAH_3_C__c);
            summarizeFields(fcr.Sales_CR_KAH_3_D__c);
            fcr.Sales_CR_KAH_3_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_4_A__c);
            summarizeFields(fcr.Sales_CR_KAH_4_B__c);
            summarizeFields(fcr.Sales_CR_KAH_4_C__c);
            summarizeFields(fcr.Sales_CR_KAH_4_D__c);
            fcr.Sales_CR_KAH_4_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_6_A__c);
            summarizeFields(fcr.Sales_CR_KAH_6_B__c);
            summarizeFields(fcr.Sales_CR_KAH_6_C__c);
            summarizeFields(fcr.Sales_CR_KAH_6_D__c);
            fcr.Sales_CR_KAH_6_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_7_A__c);
            summarizeFields(fcr.Sales_CR_KAH_7_B__c);
            summarizeFields(fcr.Sales_CR_KAH_7_C__c);
            summarizeFields(fcr.Sales_CR_KAH_7_D__c);
            fcr.Sales_CR_KAH_7_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_8_A__c);
            summarizeFields(fcr.Sales_CR_KAH_8_B__c);
            summarizeFields(fcr.Sales_CR_KAH_8_C__c);
            summarizeFields(fcr.Sales_CR_KAH_8_D__c);
            fcr.Sales_CR_KAH_8_Score__c = sectionScore;
            sectionScore = 0;
            summarizeFields(fcr.Sales_CR_KAH_9_A__c);
            summarizeFields(fcr.Sales_CR_KAH_9_B__c);
            summarizeFields(fcr.Sales_CR_KAH_9_C__c);
            summarizeFields(fcr.Sales_CR_KAH_9_D__c);
            fcr.Sales_CR_KAH_9_Score__c = sectionScore;
            sectionScore = 0;
            if(numberFilled!=0){
              fcr.Sales_CR_KAH_Overall_Score__c = (Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1);
            } else fcr.Sales_CR_KAH_Overall_Score__c = 0;

            fcr.Sales_CR_KAH_Overall_Avg_Score__c = (Decimal.valueOf(totalScore)/8.0).setScale(1);

            completed = true;
            fcr.Status__c = 'Completed';
          }
        } else if(fcr.RecordTypeId == kahSa.Id || fcr.RecordTypeId == kahAf.Id){

          completed = true;
          fcr.Status__c = 'Completed';
        } else if(fcr.RecordTypeId == kahFcr.Id){
          sectionScore = 0;
          sectionNumberFilled = 0;
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_A__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_B__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_C__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_D__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_E__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_F__c);
          if(sectionNumberFilled!=0){
            fcr.Sales_FCR_KAH_1_Score__c = (Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_1_Score__c = 0;
          sectionScore = 0;
          sectionNumberFilled = 0;
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_A__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_B__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_C__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_D__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_E__c);
          if(sectionNumberFilled!=0){
            fcr.Sales_FCR_KAH_2_Score__c = (Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_2_Score__c = 0;
          sectionScore = 0;
          sectionNumberFilled = 0;
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_A__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_B__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_C__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_D__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_E__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_F__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_F__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_3_F__c);
          if(sectionNumberFilled!=0){
            fcr.Sales_FCR_KAH_3_Score__c = (Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_3_Score__c = 0;
          sectionScore = 0;
          sectionNumberFilled = 0;
          if(numberFilled!=0){
            fcr.Sales_FCR_KAH_Overall_Score__c = (Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_Overall_Score__c = 0;

          completed = true;
          fcr.Status__c = 'Completed';

        } else if(fcr.RecordTypeId == kahFcrAf.Id){
          sectionScore = 0;
          sectionNumberFilled = 0;
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_A__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_B__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_C__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_D__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_E__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_1_F__c);
          if(sectionNumberFilled!=0){
            fcr.Sales_FCR_KAH_1_Score__c = (Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_1_Score__c = 0;
          sectionScore = 0;
          sectionNumberFilled = 0;
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_A__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_B__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_C__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_D__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_2_E__c);
          if(sectionNumberFilled!=0){
            fcr.Sales_FCR_KAH_2_Score__c = (Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_2_Score__c = 0;
          sectionScore = 0;
          sectionNumberFilled = 0;
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_A__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_B__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_C__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_D1__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_D2__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_D3__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_E__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_F__c);
          summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_G__c);
          if(sectionNumberFilled!=0){
            fcr.Sales_FCR_KAH_3_Score__c = (Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_3_Score__c = 0;
          if(numberFilled!=0){
            fcr.Sales_FCR_KAH_Overall_Score__c = (Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1);
          } else fcr.Sales_FCR_KAH_Overall_Score__c = 0;
          sectionScore = 0;
          sectionNumberFilled = 0;

          completed = true;
          fcr.Status__c = 'Completed';

        }
      }
      update fcrs;
      if(completed) completedEmail(fcrs[0].OwnerId, fcrs[0].RecordTypeId,
      fcrs[0].Id, isPrivate, fcrs[0].Sales_Name__c, fcrs[0].Sales_Email__c);
      return completed;
    }


    public static Integer totalScore = 0;
    public static Integer sectionScore = 0;
    public static Integer numberFilled = 0;
    public static Integer sectionNumberFilled = 0;
    @RemoteAction global static String getSummary(Id fcrId){

      String html = '';
      String complete = '<div class="bold">';
      for(Field_Coaching_Report__c fcr : [select OwnerId, Owner.Name, RecordTypeId, Date__c, Status__c, Completed_Date__c, Length_of_Field_Ride__c, Sales_CR_KAH_1_A__c,
      Sales_CR_KAH_1_B__c,Sales_CR_KAH_1_C__c,Sales_CR_KAH_1_D__c,Sales_CR_KAH_2_A__c,Sales_CR_KAH_2_B__c,Sales_CR_KAH_2_C__c,
      Sales_CR_KAH_2_D__c,Sales_CR_KAH_3_A__c,Sales_CR_KAH_3_B__c,Sales_CR_KAH_3_C__c,Sales_CR_KAH_3_D__c,Sales_CR_KAH_4_A__c,
      Sales_CR_KAH_4_B__c,Sales_CR_KAH_4_C__c,Sales_CR_KAH_4_D__c,Sales_CR_KAH_5_A__c,Sales_CR_KAH_5_B__c,Sales_CR_KAH_5_C__c,
      Sales_CR_KAH_5_D__c,Sales_CR_KAH_6_A__c,Sales_CR_KAH_6_B__c,Sales_CR_KAH_6_C__c,Sales_CR_KAH_6_D__c,Sales_CR_KAH_7_A__c,Sales_CR_KAH_7_B__c,
      Sales_CR_KAH_7_C__c,Sales_CR_KAH_7_D__c,Sales_CR_KAH_8_A__c,Sales_CR_KAH_8_B__c,Sales_CR_KAH_8_C__c,Sales_CR_KAH_8_D__c,Sales_CR_KAH_9_A__c, Sales_CR_KAH_Overall_Avg_Score__c,
      Sales_CR_KAH_9_B__c,Sales_CR_KAH_9_C__c,Sales_CR_KAH_9_D__c,Sales_FCR_KAH_1_A__c,Sales_FCR_KAH_1_B__c,Sales_FCR_KAH_1_C__c,Sales_FCR_KAH_1_D__c,
      Sales_FCR_KAH_1_E__c,Sales_FCR_KAH_1_F__c,Sales_FCR_KAH_1_Text__c,Sales_FCR_KAH_2_A__c,Sales_FCR_KAH_2_B__c,Sales_FCR_KAH_2_C__c,Sales_FCR_KAH_2_D__c,
      Sales_FCR_KAH_2_E__c,Sales_FCR_KAH_2_Text__c,Sales_FCR_KAH_3_A__c,Sales_FCR_KAH_3_B__c,Sales_FCR_KAH_3_C__c,Sales_FCR_KAH_3_D__c,Sales_FCR_KAH_3_E__c,
      Sales_FCR_KAH_3_F__c,Sales_FCR_KAH_3_G__c,Sales_FCR_KAH_3_H__c,Sales_FCR_KAH_3_Text__c,Sales_FCR_KAH_TAF_3_A__c,Sales_FCR_KAH_TAF_3_B__c,
      Sales_FCR_KAH_TAF_3_C__c,Sales_FCR_KAH_TAF_3_D1__c,Sales_FCR_KAH_TAF_3_D2__c,Sales_FCR_KAH_TAF_3_D3__c,Sales_FCR_KAH_TAF_3_E__c,Sales_FCR_KAH_TAF_3_F__c,
      Sales_FCR_KAH_TAF_3_G__c,Sales_FCR_KAH_4_Leader_Text__c, Sales_FCR_KAH_4_Leader_Actions_1__c, Sales_FCR_KAH_4_Leader_Actions_2__c,
      Sales_FCR_KAH_4_Actions_1_Completed__c, Sales_FCR_KAH_4_Actions_2_Completed__c, Sales_FCR_KAH_4_Rep_Text__c,Sales_PRA_KAH_1_A__c,Sales_PRA_KAH_1_B__c,Sales_PRA_KAH_2_A__c,
      Sales_PRA_KAH_2_B__c,Sales_PRA_KAH_3_A__c,Sales_PRA_KAH_3_B__c,Sales_PRA_KAH_4_A__c,Sales_PRA_KAH_4_B__c,Sales_PRA_KAH_5_A__c,
      Sales_PRA_KAH_5_B__c,Sales_PRA_KAH_6_A__c,Sales_PRA_KAH_6_B__c,Sales_PRA_KAH_7_A__c,Sales_PRA_KAH_7_B__c,Sales_PRA_KAH_8_A__c,Sales_PRA_KAH_8_B__c,
      Sales_TAF_KAH_1_Text__c,Sales_TAF_KAH_2_Text__c,Sales_TAF_KAH_3_Text__c,Sales_TAF_KAH_4a_Text__c,Sales_TAF_KAH_4b_Text__c,
      Sales_TAF_KAH_4c_Text__c, Sales_FCR_KAH_4_Actions_1_Date__c, Sales_FCR_KAH_4_Actions_2_Date__c, Sales_KAH_SA_Acknowledged__c, Sales_KAH_SA_Acknowledged_Date__c,
      Sales_Name__c, Sales_Email__c from Field_Coaching_Report__c where Id = :fcrId]){
        if(fcr.Status__c == 'Completed') complete = '<div class="bold" style="color:#89b983;"><i class="fa fa-check-circle"></i> ';
        else{
          if(UserInfo.getUserId() != fcr.OwnerId) html += '<div id="backButton" class="blue" style="cursor:pointer;border-radius:25px;color:white;padding:5px;text-align:center;" onclick="backSave(true, \''+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/Sales_FCR?fcrId='+fcr.Id+'&userId='+fcr.OwnerId+'\')"><i class="fa fa-chevron-left"></i> Back</div>';
          else html += '<div id="backButton" class="blue" style="cursor:pointer;border-radius:25px;color:white;padding:5px;text-align:center;" onclick="backSave(false, \''+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/Sales_FCR?fcrId='+fcr.Id+'&userId='+fcr.OwnerId+'\')"><i class="fa fa-chevron-left"></i> Back</div>';
        }
        String summaryName = fcr.Owner.Name;
          if(fcr.Sales_Name__c!=null) summaryName = fcr.Sales_Name__c;
        if(fcr.RecordTypeId==kahCrHH.Id){
          
          html += '<div class="pageTitle">'+complete+'Home Health Competency Rating</div><div class="regular">'+summaryName+'</div><div class="thin">'+fcr.Date__c.format()+'</div></div>'+
          '<div id="sp"></div>'+
          '<div class="fieldTitle bold">SELF STARTER</div>'+
          '<div class="fieldTitle regular">Strong work ethic, willing to work above and beyond the call of duty.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_A__c)+'</div>'+
          '<div class="fieldTitle regular">Self-confident across all selling scenarios positioning themselves as a hospice expert.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_B__c)+'</div>'+
          '<div class="fieldTitle regular">Self motivated, requires no external motivation, actively seeks new business and growth opportunities.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_C__c)+'</div>'+
          '<div class="fieldTitle regular">Proactive Learner, continually evaluates processes and practices for improvement.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">RESULTS ORIENTED</div>'+
          '<div class="fieldTitle regular">Driven for success, actively tracks goals and results to goals with a commitment to grow.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_A__c)+'</div>'+
          '<div class="fieldTitle regular">Has a sense of urgency and responsiveness.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_B__c)+'</div>'+
          '<div class="fieldTitle regular">Proactive with issue resolution and plans for growth with the program.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_C__c)+'</div>'+
          '<div class="fieldTitle regular">Sets high expectations and holds self and program accountable for performance.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">TEAMWORK</div>'+
          '<div class="fieldTitle regular">Respectful, appreciative, and shows commitment to working well with colleagues and internal team.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_A__c)+'</div>'+
          '<div class="fieldTitle regular">Demonstrates 360 degree communication - active communication processes to ensure collaboration and teamwork.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_B__c)+'</div>'+
          '<div class="fieldTitle regular">Able to identify issues and works to be part of the resolution process.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_C__c)+'</div>'+
          '<div class="fieldTitle regular">Flexible and resourceful, makes self available to internal staff and customers.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">RELATIONSHIP BUILDING</div>'+
          '<div class="fieldTitle regular">Able to build strong collaborate relationships internally, strong networked with Kindred at Home Hospice team.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_A__c)+'</div>'+
          '<div class="fieldTitle regular">Members Interpersonal sensitivity, shows empathy in both internal and external relationships and communications.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_B__c)+'</div>'+
          '<div class="fieldTitle regular">Builds strong partnerships across company divisions in bridge markets.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_C__c)+'</div>'+
          '<div class="fieldTitle regular">Understands the advantage of strong internal and external relationships and works hard to build those relationships.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">CONSULTATIVE SELLING</div>'+
          '<div class="fieldTitle regular">Active Listener - focuses sales calls on the referral source\'s needs.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_A__c)+'</div>'+
          '<div class="fieldTitle regular">Seeks to understand the customer\'s needs, referral source, patient or family and shares relevant solutions.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_B__c)+'</div>'+
          '<div class="fieldTitle regular">Successfully deals with objections.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_C__c)+'</div>'+
          '<div class="fieldTitle regular">Consistently "asks for the business" utilizing effective closing techniques.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">TIME MANAGMENT AND ORGANIZATIONAL SKILLS</div>'+
          '<div class="fieldTitle regular">Prioritizes daily and weekly activities to meet performance expectations.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_A__c)+'</div>'+
          '<div class="fieldTitle regular">Understands program goals and manages time to work on key priorities to reach those goals.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_B__c)+'</div>'+
          '<div class="fieldTitle regular">Always prepared and available for patient and family conversations.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_C__c)+'</div>'+
          '<div class="fieldTitle regular">Prioritizes program communication and relationship building.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">INFLUENTIAL COMMUNICATION SKILLS</div>'+
          '<div class="fieldTitle regular">Active listener.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_A__c)+'</div>'+
          '<div class="fieldTitle regular">Credible, engaging, and compassionate use of industry knowledge and acumen.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_B__c)+'</div>'+
          '<div class="fieldTitle regular">Has the ability to influence referral sources, patients and family, and the internal team.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_C__c)+'</div>'+
          '<div class="fieldTitle regular">Effective communicator, tailors communication and fosters two way active dialog when speaking with others.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">NETWORKING ABILITY</div>'+
          '<div class="fieldTitle regular">High visibility within the community.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_A__c)+'</div>'+
          '<div class="fieldTitle regular">Highly networked with the internal team for community knowledge and leads.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_B__c)+'</div>'+
          '<div class="fieldTitle regular">Continually stays abreast of area market, key clinical players, competitive landscape, and potential new referral sources.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_C__c)+'</div>'+
          '<div class="fieldTitle regular">Proactively seeks opportunities to connect with those who can provide knowledge and contacts to build business.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          String averageScore = '<span class="lnr lnr-cross"></span>';
          if((Decimal.valueOf(totalScore)/8.0).setScale(1)>0) averageScore = String.valueOf((Decimal.valueOf(totalScore)/8.0).setScale(1));
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">OVERALL AVERAGE SCORE</div>'+
          '<div class="fieldInput regular">'+averageScore+
          crSectionText((Decimal.valueOf(totalScore)/8.0).setScale(1))+'</div>'+
          '<div class="line"></div>'+
          '<div><div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">CREATED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Date__c)+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">COMPLETED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Completed_Date__c)+'</div></div></div>';
        } else if(fcr.RecordTypeId==kahCrHP.Id){
          html += '<div class="pageTitle">'+complete+'Hospice Competency Rating</div><div class="regular">'+summaryName+'</div><div class="thin">'+fcr.Date__c.format()+'</div></div>'+
          '<div id="sp"></div>'+
          '<div class="fieldTitle bold">SELF STARTER</div>'+
          '<div class="fieldTitle regular">Strong work ethic, willing to work above and beyond the call of duty.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_A__c)+'</div>'+
          '<div class="fieldTitle regular">Self-confident across all selling scenarios positioning themselves as a hospice expert.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_B__c)+'</div>'+
          '<div class="fieldTitle regular">Self motivated, requires no external motivation, actively seeks new business and growth opportunities.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_C__c)+'</div>'+
          '<div class="fieldTitle regular">Proactive Learner, continually evaluates processes and practices for improvement.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_1_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">RESULTS ORIENTED</div>'+
          '<div class="fieldTitle regular">Driven for success, actively tracks goals and results to goals with a commitment to grow.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_A__c)+'</div>'+
          '<div class="fieldTitle regular">Has a sense of urgency and responsiveness.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_B__c)+'</div>'+
          '<div class="fieldTitle regular">Proactive with issue resolution and plans for growth with the program.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_C__c)+'</div>'+
          '<div class="fieldTitle regular">Sets high expectations and holds self and program accountable for performance.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_2_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">TEAMWORK</div>'+
          '<div class="fieldTitle regular">Respectful, appreciative, and shows commitment to working well with colleagues and internal team.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_A__c)+'</div>'+
          '<div class="fieldTitle regular">Demonstrates 360 degree communication - active communication processes to ensure collaboration and teamwork.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_B__c)+'</div>'+
          '<div class="fieldTitle regular">Able to identify issues and works to be part of the resolution process.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_C__c)+'</div>'+
          '<div class="fieldTitle regular">Flexible and resourceful, makes self available to internal staff and customers.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_3_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">RELATIONSHIP BUILDING</div>'+
          '<div class="fieldTitle regular">Able to build strong collaborate relationships internally, strong networked with Kindred at Home Hospice team.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_A__c)+'</div>'+
          '<div class="fieldTitle regular">Members Interpersonal sensitivity, shows empathy in both internal and external relationships and communications.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_B__c)+'</div>'+
          '<div class="fieldTitle regular">Builds strong partnerships across company divisions in bridge markets.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_C__c)+'</div>'+
          '<div class="fieldTitle regular">Understands the advantage of strong internal and external relationships and works hard to build those relationships.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_4_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">PASSION FOR HOSPICE MISSION</div>'+
          '<div class="fieldTitle regular">Demonstrates passion for the Hospice Industry and work.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_5_A__c)+'</div>'+
          '<div class="fieldTitle regular">Motivated by and demonstrates an overriding professional responsibility to do the right thing for the patient and family.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_5_B__c)+'</div>'+
          '<div class="fieldTitle regular">Demonstrates sensitivity to the needs, beliefs, and expectations of others.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_5_C__c)+'</div>'+
          '<div class="fieldTitle regular">Show compassion and sensitivity with patients and families.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_5_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">CONSULTATIVE SELLING</div>'+
          '<div class="fieldTitle regular">Active Listener - focuses sales calls on the referral source\'s needs.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_A__c)+'</div>'+
          '<div class="fieldTitle regular">Seeks to understand the customer\'s needs, referral source, patient or family and shares relevant solutions.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_B__c)+'</div>'+
          '<div class="fieldTitle regular">Successfully deals with objections.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_C__c)+'</div>'+
          '<div class="fieldTitle regular">Consistently "asks for the business" utilizing effective closing techniques.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_6_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">TIME MANAGMENT AND ORGANIZATIONAL SKILLS</div>'+
          '<div class="fieldTitle regular">Prioritizes daily and weekly activities to meet performance expectations.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_A__c)+'</div>'+
          '<div class="fieldTitle regular">Understands program goals and manages time to work on key priorities to reach those goals.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_B__c)+'</div>'+
          '<div class="fieldTitle regular">Always prepared and available for patient and family conversations.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_C__c)+'</div>'+
          '<div class="fieldTitle regular">Prioritizes program communication and relationship building.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_7_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">INFLUENTIAL COMMUNICATION SKILLS</div>'+
          '<div class="fieldTitle regular">Active listener.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_A__c)+'</div>'+
          '<div class="fieldTitle regular">Credible, engaging, and compassionate use of industry knowledge and acumen.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_B__c)+'</div>'+
          '<div class="fieldTitle regular">Has the ability to influence referral sources, patients and family, and the internal team.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_C__c)+'</div>'+
          '<div class="fieldTitle regular">Effective communicator, tailors communication and fosters two way active dialog when speaking with others.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_8_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">NETWORKING ABILITY</div>'+
          '<div class="fieldTitle regular">High visibility within the community.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_A__c)+'</div>'+
          '<div class="fieldTitle regular">Highly networked with the internal team for community knowledge and leads.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_B__c)+'</div>'+
          '<div class="fieldTitle regular">Continually stays abreast of area market, key clinical players, competitive landscape, and potential new referral sources.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_C__c)+'</div>'+
          '<div class="fieldTitle regular">Proactively seeks opportunities to connect with those who can provide knowledge and contacts to build business.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_CR_KAH_9_D__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore;
          html += crSectionText(sectionScore);
          html += '</div>';
          sectionScore = 0;
          String averageScore = '<span class="lnr lnr-cross"></span>';
          if((Decimal.valueOf(totalScore)/9.0).setScale(1)>0) averageScore = String.valueOf((Decimal.valueOf(totalScore)/9.0).setScale(1));
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">OVERALL AVERAGE SCORE</div>'+
          '<div class="fieldInput regular">'+averageScore+
          crSectionText((Decimal.valueOf(totalScore)/9.0).setScale(1))+'</div>'+
          '<div class="line"></div>'+
          '<div><div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">CREATED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Date__c)+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">COMPLETED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Completed_Date__c)+'</div></div></div>';
        } else if(fcr.RecordTypeId==kahFcr.Id){
          html += '<div class="pageTitle">'+complete+'Field Coaching Report</div><div class="regular">'+summaryName+'</div><div class="thin">'+fcr.Date__c.format()+'</div></div>'+
          '<div id="sp"></div>'+
          '<div class="fieldTitle bold">PRE-CALL PLANNING / ORGANIZATION SKILLS</div>'+
          '<div class="fieldTitle regular">Maintains appropriate call plan, call notes and updates information after each customer visit in CRM.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_A__c)+'</div>'+
          '<div class="fieldTitle regular">Maintains appropriate collateral resources.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_B__c)+'</div>'+
          '<div class="fieldTitle regular">Updates CRM call documentation / notes timely and appropriately.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_C__c)+'</div>'+
          '<div class="fieldTitle regular">Utilizes CRM call recurrence ensuring call frequency and cycle.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_D__c)+'</div>'+
          '<div class="fieldTitle regular">Completes expense reports in a timely manner.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_E__c)+'</div>'+
          '<div class="fieldTitle regular">Adheres to the professional apperance standards, promotes a positive image.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_F__c)+'</div>'+
          '<div class="fieldTitle regular">Comments and recommendations.</div>'+
          '<div class="fieldInput thin">'+nullTextCheck(fcr.Sales_FCR_KAH_1_Text__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore+'</div>'+
          '<div class="fieldTitle bold">AVERAGE SCORE</div>';
          if(sectionNumberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';
          sectionScore = 0;
          sectionNumberFilled = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">PRODUCT AND MARKET KNOWLEDGE / INTERNAL RAPPORT BUILDING</div>'+
          '<div class="fieldTitle regular">Incorporates available resources as needed to support the selling process - clinical support team, in-services, industry articles, etc.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_A__c)+'</div>'+
          '<div class="fieldTitle regular">Demonstrates superior customer service and follow-up with customers and patients.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_B__c)+'</div>'+
          '<div class="fieldTitle regular">Participates in business development meetings and partners effectively with operations and clinical.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_C__c)+'</div>'+
          '<div class="fieldTitle regular">Exhibits knowldge of competitors offerings, stategies and market share.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_D__c)+'</div>'+
          '<div class="fieldTitle regular">Demonstrates selling skill and strategy across customer segments: hospital, physician, and facility sellings.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_E__c)+'</div>'+
          '<div class="fieldTitle regular">Comments and recommendations.</div>'+
          '<div class="fieldInput thin">'+nullTextCheck(fcr.Sales_FCR_KAH_2_Text__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore+'</div>'+
          '<div class="fieldTitle bold">AVERAGE SCORE</div>';
          if(sectionNumberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';
          sectionScore = 0;
          sectionNumberFilled = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">SELLING SKILLS AND SALES PROCESSES</div>'+
          '<div class="fieldTitle regular">Call planning: Posts clear sales call objective in CRM.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_A__c)+'</div>'+
          '<div class="fieldTitle regular">Opening the Call: Appropriately introduces self, company and intrest spark.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_B__c)+'</div>'+
          '<div class="fieldTitle regular">Establishing Customer Needs: Asks apporpriate probing questions conversationally to understand the customer\'s situation and identify the customer\'s needs.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_C__c)+'</div>'+
          '<div class="fieldTitle regular">Confirms Shared Understaning: Confirms and clarifies the customer\'s needs.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_D__c)+'</div>'+
          '<div class="fieldTitle regular">Presents Targeted Solutions: Offers relevant features and effectively articulates the benefit.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_E__c)+'</div>'+
          '<div class="fieldTitle regular">Solicit Feedback: Engages the customer in verbal / non-verbal feedback.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_F__c)+'</div>'+
          '<div class="fieldTitle regular">Dealing with Obstacles: Effectively deals with obstacles.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_G__c)+'</div>'+
          '<div class="fieldTitle regular">Close: Identifies and matches buying signals to the right close. Deals effectively with rejection and recovery. Discusses apporpriate next steps.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_3_H__c)+'</div>'+
          '<div class="fieldTitle regular">Comments and recommendations.</div>'+
          '<div class="fieldInput thin">'+nullTextCheck(fcr.Sales_FCR_KAH_3_Text__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore+'</div>'+
          '<div class="fieldTitle bold">AVERAGE SCORE</div>';
          if(sectionNumberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';
          sectionScore = 0;
          sectionNumberFilled = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">TOTAL SCORE</div>'+
          '<div class="fieldInput regular">'+totalScore+'</div>'+
          '<div class="fieldTitle bold">CUMULATIVE AVERAGE SCORE</div>';
          if(numberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';

          String completedText1 = completedText(fcr.Sales_FCR_KAH_4_Actions_1_Date__c, fcr.Sales_FCR_KAH_4_Actions_1_Completed__c, fcr.Sales_FCR_KAH_4_Leader_Actions_1__c);
          String completedText2 = completedText(fcr.Sales_FCR_KAH_4_Actions_2_Date__c, fcr.Sales_FCR_KAH_4_Actions_2_Completed__c, fcr.Sales_FCR_KAH_4_Leader_Actions_2__c);

          String date1 = '';
          if(fcr.Sales_FCR_KAH_4_Actions_1_Date__c!=null) date1 = ' value="'+String.valueOf(fcr.Sales_FCR_KAH_4_Actions_1_Date__c.format())+'"';
          String date2 = '';
          if(fcr.Sales_FCR_KAH_4_Actions_2_Date__c!=null) date2 = ' value="'+String.valueOf(fcr.Sales_FCR_KAH_4_Actions_2_Date__c.format())+'"';

          html += '<div class="line"></div>';
          if(UserInfo.getUserId() != fcr.OwnerId){
            html += '<div class="fieldTitle bold">SALES LEADER\'S COMMENTS</div>'+
            '<div class="fieldTitle regular">Leader\'s Comments <span onclick="$(\'#leaderEdit\').slideDown();$(\'#leaderField\').slideUp();" class="edit blue leader-edit"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="leaderField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'</div><div id="leaderEdit" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'</textarea>'+
            '<div id="saSave" class="edit blue" onclick="save(true);">SAVE</div></div></div>'+
            '<div class="line"></div>'+
            '<div class="fieldTitle bold">FOLLOW-UP ACTIONS FOR SALES ASSOCIATE</div>'+
            '<div class="fieldTitle regular">Follow-up Action 1 <span onclick="$(\'#leaderActionsEdit1\').slideDown();$(\'#leaderAction1\').slideUp();" class="edit blue leader-edit"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="leaderAction1">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_1__c)+'</div><div id="leaderActionsEdit1" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Leader_Actions_1__c)+'</textarea>'+
            '<input id="datepicker1" class="fieldInput thin datepick" placeholder="Complete By" readonly'+date1+'></input>'+
            '<div id="saSave" class="edit blue" onclick="save(true);">SAVE</div></div></div><div id="followup1">'+completedText1+'</div>'+
            '<div class="fieldTitle regular">Follow-up Action 2 <span onclick="$(\'#leaderActionsEdit2\').slideDown();$(\'#leaderAction2\').slideUp();" class="edit blue leader-edit"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="leaderAction2">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_2__c)+'</div><div id="leaderActionsEdit2" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Leader_Actions_2__c)+'</textarea>'+
            '<input id="datepicker2" class="fieldInput thin datepick" placeholder="Complete By" readonly'+date2+'></input>'+
            '<div id="saSave" class="edit blue" onclick="save(true);">SAVE</div></div></div><div id="followup2">'+completedText2+'</div>';
          } else {
            html += '<div class="fieldTitle bold">SALES LEADER\'S COMMENTS</div>'+
            '<div class="fieldTitle regular">Leader\'s Comments</div>'+
            '<div class="fieldInput thin"><div id="leaderField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'</div></div>'+
            '<div class="line"></div>'+
            '<div class="fieldTitle bold">FOLLOW-UP ACTIONS FOR SALES ASSOCIATE</div>'+
            '<div class="fieldTitle regular">Follow-up Action 1</div>'+
            '<div class="fieldInput thin"><div id="leaderAction1">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_1__c)+'</div></div>'+
            '<div id="followup1">'+completedText1+'</div>'+
            '<div class="fieldTitle regular">Follow-up Action 2</div>'+
            '<div class="fieldInput thin"><div id="leaderAction2">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_2__c)+'</div></div>'+
            '<div id="followup2">'+completedText2+'</div>';
          }

          if(UserInfo.getUserId() == fcr.OwnerId){
            html += '<div class="line"></div><div class="fieldTitle bold">SALES ASSOCIATE\'S COMMENTS</div><div class="fieldTitle regular">Associate\'s Comments <span onclick="$(\'#saEdit\').slideDown();$(\'#saField\').slideUp();" class="edit blue"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="saField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'</div><div id="saEdit" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'</textarea>'+
            '<div id="saSave" class="edit blue" onclick="save(false);">SAVE</div></div></div>';

            if(!fcr.Sales_KAH_SA_Acknowledged__c){
              html += '<div style="margin-top: 20px;" class="fieldTitle regular" id="acknowledgedText">By clicking the button below, you are acknowledging that you thoroughly reviewed this field coaching report.</div><div class="acknowledgeButton blue">Acknowledge</div>';
            } else {
              html += '<div style="margin-top: 20px;" class="fieldTitle regular">You have acknowledged that you thoroughly reviewed this field coaching report.</div><div style="cursor: default;" class="acknowledgeButton green"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Acknowledged</div>';
            }

          } else {
            html += '<div class="line"></div><div class="fieldTitle bold">SALES ASSOCIATE\'S COMMENTS</div><div class="fieldTitle regular">Associate\'s Comments</div>'+
            '<div class="fieldInput thin"><div id="saField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'</div></div>';

            if(fcr.Sales_KAH_SA_Acknowledged__c){
              html += '<div style="margin-top: 20px;" class="fieldTitle regular">'+summaryName+' has acknowledged that they thoroughly reviewed this field coaching report.</div><div style="cursor: default;" class="acknowledgeButton green"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Acknowledged</div>';
            }
          }

          html += '<div class="line"></div>'+
          '<div><div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">CREATED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Date__c)+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">RIDE LENGTH'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+fcr.Length_of_Field_Ride__c+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">COMPLETED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Completed_Date__c)+'</div></div></div>';
        } else if(fcr.RecordTypeId==kahFcrAf.Id){
          html += '<div class="pageTitle">'+complete+'Field Coaching Report - TAF</div><div class="regular">'+summaryName+'</div><div class="thin">'+fcr.Date__c.format()+'</div></div>'+
          '<div id="sp"></div>'+
          '<div class="fieldTitle bold">PRE-CALL PLANNING / ORGANIZATION SKILLS</div>'+
          '<div class="fieldTitle regular">Maintains appropriate call plan, call notes and updates information after each customer visit in CRM.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_A__c)+'</div>'+
          '<div class="fieldTitle regular">Maintains appropriate collateral resources.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_B__c)+'</div>'+
          '<div class="fieldTitle regular">Updates CRM call documentation / notes timely and appropriately.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_C__c)+'</div>'+
          '<div class="fieldTitle regular">Utilizes CRM call recurrence ensuring call frequency and cycle.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_D__c)+'</div>'+
          '<div class="fieldTitle regular">Completes expense reports in a timely manner.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_E__c)+'</div>'+
          '<div class="fieldTitle regular">Adheres to the professional apperance standards, promotes a positive image.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_1_F__c)+'</div>'+
          '<div class="fieldTitle regular">Comments and recommendations.</div>'+
          '<div class="fieldInput thin">'+nullTextCheck(fcr.Sales_FCR_KAH_1_Text__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore+'</div>'+
          '<div class="fieldTitle bold">AVERAGE SCORE</div>';
          if(sectionNumberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';
          sectionScore = 0;
          sectionNumberFilled = 0;

          String completedText1 = completedText(fcr.Sales_FCR_KAH_4_Actions_1_Date__c, fcr.Sales_FCR_KAH_4_Actions_1_Completed__c, fcr.Sales_FCR_KAH_4_Leader_Actions_1__c);
          String completedText2 = completedText(fcr.Sales_FCR_KAH_4_Actions_2_Date__c, fcr.Sales_FCR_KAH_4_Actions_2_Completed__c, fcr.Sales_FCR_KAH_4_Leader_Actions_2__c);

          String date1 = '';
          if(fcr.Sales_FCR_KAH_4_Actions_1_Date__c!=null) date1 = ' value="'+String.valueOf(fcr.Sales_FCR_KAH_4_Actions_1_Date__c.format())+'"';
          String date2 = '';
          if(fcr.Sales_FCR_KAH_4_Actions_2_Date__c!=null) date2 = ' value="'+String.valueOf(fcr.Sales_FCR_KAH_4_Actions_2_Date__c.format())+'"';

          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">PRODUCT AND MARKET KNOWLEDGE / INTERNAL RAPPORT BUILDING</div>'+
          '<div class="fieldTitle regular">Incorporates available resources as needed to support the selling process - clinical support team, in-services, industry articles, etc.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_A__c)+'</div>'+
          '<div class="fieldTitle regular">Demonstrates superior customer service and follow-up with customers and patients.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_B__c)+'</div>'+
          '<div class="fieldTitle regular">Participates in business development meetings and partners effectively with operations and clinical.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_C__c)+'</div>'+
          '<div class="fieldTitle regular">Exhibits knowldge of competitors offerings, stategies and market share.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_D__c)+'</div>'+
          '<div class="fieldTitle regular">Demonstrates selling skill and strategy across customer segments: hospital, physician, and facility sellings.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_2_E__c)+'</div>'+
          '<div class="fieldTitle regular">Comments and recommendations.</div>'+
          '<div class="fieldInput thin">'+nullTextCheck(fcr.Sales_FCR_KAH_2_Text__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore+'</div>'+
          '<div class="fieldTitle bold">AVERAGE SCORE</div>';
          if(sectionNumberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';
          sectionScore = 0;
          sectionNumberFilled = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">SELLING SKILLS AND SALES PROCESSES (TAF)</div>'+
          '<div class="fieldTitle regular">He/she knew what they wanted from the call.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_A__c)+'</div>'+
          '<div class="fieldTitle regular">The ask was specific with a sense of urgency.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_B__c)+'</div>'+
          '<div class="fieldTitle regular">There was a show.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_C__c)+'</div>'+
          '<div class="fieldTitle regular">Best Reason #1 - They lead into their best reasons.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_D1__c)+'</div>'+
          '<div class="fieldTitle regular">Best Reason #2 - They counted their best reasons from 1 to 3..</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_D2__c)+'</div>'+
          '<div class="fieldTitle regular">Best Reason #3 - They used "you" and "your" in their best reasons.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_D3__c)+'</div>'+
          '<div class="fieldTitle regular">They repeated the Ask exactly as their initial Ask.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_E__c)+'</div>'+
          '<div class="fieldTitle regular">they stopped talking after the ask.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_F__c)+'</div>'+
          '<div class="fieldTitle regular">An appropriate "share" was provided.</div>'+
          '<div class="fieldInput thin">'+summarizeFcrFields(fcr.Sales_FCR_KAH_TAF_3_G__c)+'</div>'+
          '<div class="fieldTitle regular">Comments and recommendations.</div>'+
          '<div class="fieldInput thin">'+nullTextCheck(fcr.Sales_FCR_KAH_3_Text__c)+'</div>'+
          '<div class="fieldTitle bold">SCORE</div>'+
          '<div class="fieldInput regular">'+sectionScore+'</div>'+
          '<div class="fieldTitle bold">AVERAGE SCORE</div>';
          if(sectionNumberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(sectionScore)/Decimal.valueOf(sectionNumberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';
          sectionScore = 0;
          sectionNumberFilled = 0;
          html += '<div class="line"></div>'+
          '<div class="fieldTitle bold">TOTAL SCORE</div>'+
          '<div class="fieldInput regular">'+totalScore+'</div>'+
          '<div class="fieldTitle bold">CUMULATIVE AVERAGE SCORE</div>';
          if(numberFilled!=0){
            html += '<div class="fieldInput regular">'+(Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1);
            html += fcrAverageText((Decimal.valueOf(totalScore)/Decimal.valueOf(numberFilled)).setScale(1));
            html+='</div>';
          } else html += '<div class="fieldInput regular">0</div>';
          html += '<div class="line"></div>';
          if(UserInfo.getUserId() != fcr.OwnerId){
            html += '<div class="fieldTitle bold">SALES LEADER\'S COMMENTS</div>'+
            '<div class="fieldTitle regular">Leader\'s Comments <span onclick="$(\'#leaderEdit\').slideDown();$(\'#leaderField\').slideUp();" class="edit blue leader-edit"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="leaderField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'</div><div id="leaderEdit" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'</textarea>'+
            '<div id="saSave" class="edit blue" onclick="save(true);">SAVE</div></div></div>'+
            '<div class="line"></div>'+
            '<div class="fieldTitle bold">FOLLOW-UP ACTIONS FOR SALES ASSOCIATE</div>'+
            '<div class="fieldTitle regular">Follow-up Action 1 <span onclick="$(\'#leaderActionsEdit1\').slideDown();$(\'#leaderAction1\').slideUp();" class="edit blue leader-edit"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="leaderAction1">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_1__c)+'</div><div id="leaderActionsEdit1" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Leader_Actions_1__c)+'</textarea>'+
            '<input id="datepicker1" class="fieldInput thin datepick" placeholder="Complete By" readonly'+date1+'></input>'+
            '<div id="saSave" class="edit blue" onclick="save(true);">SAVE</div></div></div><div id="followup1">'+completedText1+'</div>'+
            '<div class="fieldTitle regular">Follow-up Action 2 <span onclick="$(\'#leaderActionsEdit2\').slideDown();$(\'#leaderAction2\').slideUp();" class="edit blue leader-edit"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="leaderAction2">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_2__c)+'</div><div id="leaderActionsEdit2" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Leader_Actions_2__c)+'</textarea>'+
            '<input id="datepicker2" class="fieldInput thin datepick" placeholder="Complete By" readonly'+date2+'></input>'+
            '<div id="saSave" class="edit blue" onclick="save(true);">SAVE</div></div></div><div id="followup2">'+completedText2+'</div>';
          } else {
            html += '<div class="fieldTitle bold">SALES LEADER\'S COMMENTS</div>'+
            '<div class="fieldTitle regular">Leader\'s Comments</div>'+
            '<div class="fieldInput thin"><div id="leaderField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Text__c)+'</div></div>'+
            '<div class="line"></div>'+
            '<div class="fieldTitle bold">FOLLOW-UP ACTIONS FOR SALES ASSOCIATE</div>'+
            '<div class="fieldTitle regular">Follow-up Action 1</div>'+
            '<div class="fieldInput thin"><div id="leaderAction1">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_1__c)+'</div></div>'+
            '<div id="followup1">'+completedText1+'</div>'+
            '<div class="fieldTitle regular">Follow-up Action 2</div>'+
            '<div class="fieldInput thin"><div id="leaderAction2">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Leader_Actions_2__c)+'</div></div>'+
            '<div id="followup2">'+completedText2+'</div>';
          }
          if(UserInfo.getUserId() == fcr.OwnerId){
            html += '<div class="line"></div><div class="fieldTitle bold">SALES ASSOCIATE\'S COMMENTS</div><div class="fieldTitle regular">Associate\'s Comments <span onclick="$(\'#saEdit\').slideDown();$(\'#saField\').slideUp();" class="edit blue"><i class="fa fa-pencil" aria-hidden="true"></i></span></div>'+
            '<div class="fieldInput thin"><div id="saField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'</div><div id="saEdit" style="display:none;"><textarea type="text">'+textAreas(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'</textarea>'+
            '<div id="saSave" class="edit blue" onclick="save(false);">SAVE</div></div></div>';

            if(!fcr.Sales_KAH_SA_Acknowledged__c){
              html += '<div style="margin-top: 20px;" class="fieldTitle regular" id="acknowledgedText">By clicking the button below, you are acknowledging that you thoroughly reviewed this field coaching report.</div><div class="acknowledgeButton blue">Acknowledge</div>';
            } else {
              html += '<div style="margin-top: 20px;" class="fieldTitle regular">You have acknowledged that you thoroughly reviewed this field coaching report.</div><div style="cursor: default;" class="acknowledgeButton green"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Acknowledged</div>';
            }

          } else {
            html += '<div class="line"></div><div class="fieldTitle bold">SALES ASSOCIATE\'S COMMENTS</div><div class="fieldTitle regular">Associate\'s Comments</div>'+
            '<div class="fieldInput thin"><div id="saField">'+nullTextCheck(fcr.Sales_FCR_KAH_4_Rep_Text__c)+'</div></div>';

            if(fcr.Sales_KAH_SA_Acknowledged__c){
              html += '<div style="margin-top: 20px;" class="fieldTitle regular">'+summaryName+' has acknowledged that they thoroughly reviewed this field coaching report.</div><div style="cursor: default;" class="acknowledgeButton green"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Acknowledged</div>';
            }
          }
          html += '<div class="line"></div>'+
          '<div><div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">CREATED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Date__c)+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">RIDE LENGTH'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+fcr.Length_of_Field_Ride__c+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">COMPLETED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Completed_Date__c)+'</div></div></div>';
        } else if(fcr.RecordTypeId==kahSa.Id){
          html += '<div class="pageTitle">'+complete+'Pre-ride Self Assessment</div><div class="regular">'+summaryName+'</div><div class="thin">'+fcr.Date__c.format()+'</div></div>'+
          '<div id="sp"></div>'+
          '<div class="fieldTitle bold">CALL PLANNING</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_1_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_1_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">SELLING SKILLS AND SELLING PROCESS</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_2_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_2_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">CUSTOMER SEGMENT</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_3_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_3_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">CUSTOMER SEGMENT CONTACT</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_4_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_4_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">DISCIPLINES</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_5_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_5_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">SPECIALTY PROGRAMS</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_6_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_6_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">DIAGNOSES SPECIFIC</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_7_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_7_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">RELEVANT FEATURES / BENEFITS</div>'+
          '<div class="fieldTitle regular">I\'m best at</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_8_A__c)+'</div>'+
          '<div class="fieldTitle regular">I could most benefit to learn</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_PRA_KAH_8_B__c)+'</div>'+
          '<div class="line"></div>'+
          '<div><div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">CREATED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Date__c)+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">COMPLETED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Completed_Date__c)+'</div></div></div>';
        } else if(fcr.RecordTypeId==kahAf.Id){
          html += '<div class="pageTitle">'+complete+'The Asking Formula</div><div class="regular">'+summaryName+'</div><div class="thin">'+fcr.Date__c.format()+'</div></div>'+
          '<div id="sp"></div>'+
          '<div class="fieldTitle bold">KNOW</div>'+
          '<div class="fieldTitle regular">Know what you want.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_TAF_KAH_1_Text__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">ASK</div>'+
          '<div class="fieldTitle regular">Ask for what you want.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_TAF_KAH_2_Text__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">SHOW</div>'+
          '<div class="fieldTitle regular">Show what you want.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_TAF_KAH_3_Text__c)+'</div>'+
          '<div class="line"></div>'+
          '<div class="fieldTitle bold">DEVELOP</div>'+
          '<div class="fieldTitle regular">Best Reason #1.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_TAF_KAH_4a_Text__c)+'</div>'+
          '<div class="fieldTitle regular">Best Reason #2.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_TAF_KAH_4b_Text__c)+'</div>'+
          '<div class="fieldTitle regular">Best Reason #3.</div>'+
          '<div class="fieldInput thin">'+summarizeFields(fcr.Sales_TAF_KAH_4c_Text__c)+'</div>'+
          '<div class="line"></div>'+
          '<div><div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">CREATED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Date__c)+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">RIDE LENGTH'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+fcr.Length_of_Field_Ride__c+'</div></div>'+
          '<div class="threeRow"><div class="fieldInput regular" style="margin-bottom:0px;">COMPLETED DATE'+
          '</div><div class="fieldInput thin" style="margin-bottom:0px;">'+completedDate(fcr.Completed_Date__c)+'</div></div></div>';
        }
      }

      return html;
    }

    private static String completedText(Date d, Boolean complete, String text){
      String s = '';
      if(d!=null && !complete){
        s = '<div class="completeAction red-btn" data-complete=false onclick="completeAction(this);">Complete by '+String.valueOf(d.format())+'</div>';
      } else if(text!=null && !complete){
        s = '<div class="completeAction red-btn" data-complete=false onclick="completeAction(this);">Complete Action</div>';
      } else if (complete){
        s = '<div class="completeAction green" style="cursor:default; border-radius:25px; padding: 5px 10px 5px 10px; color:white;" data-complete=true><span class="lnr lnr-thumbs-up"></span> Completed</div>';
      }
      return s;
    }

    @RemoteAction global static String getSummarySp(Id fcrId){
      String html = '';
      Date d1 = Date.newInstance(Date.today().year(), Date.today().month(), 1).addMonths(-2);
      Date d2 = Date.newInstance(Date.today().year(), Date.today().month(), 1).addMonths(1).addDays(-1);
      User u = [select Id, LastLoginDate, Line_of_Business__c from user where Id in (select OwnerId from Field_Coaching_Report__c where Id=:fcrId)];
      List<Sales_Performance__c> sps =  [select Month__c, Sales_Calls__c, KAH_HH_Admit_Target__c, KAH_HH_PPS_Qualified_Admits__c, KAH_HP_Admit_Target__c, KAH_HP_Total_Admits__c
      from Sales_Performance__c where Month__c>=:d1 and Month__c<=:d2 and OwnerId =: u.Id order by Month__c asc];
      if(!sps.isEmpty()) html += '<div class="fieldTitle bold">PRODUCTIVITY</div>';
      for(Sales_Performance__c sp :sps){
        html += '<div class="fieldTitle bold">'+monthList[Integer.valueOf(sp.Month__c.month())-1]+' '+sp.Month__c.year()+'</div>';
        if (u.Line_of_Business__c!=null && u.Line_of_Business__c=='HH'){
          Decimal num = 0.0;
          if(sp.KAH_HH_Admit_Target__c!=null && sp.KAH_HH_Admit_Target__c!=0){
            num = ((sp.KAH_HH_PPS_Qualified_Admits__c/sp.KAH_HH_Admit_Target__c)*100).setScale(1);
          }
          html += '<div style="margin-top:5px;"><div class="fieldTitle regular">HH Admits</div>'+
          '<div><div class="threeRowStatic"><div class="fieldInput regular" style="margin-bottom:0px;">Target'+
          '</div><div class="fieldInput thin">'+spNullCheck(sp.KAH_HH_Admit_Target__c)+'</div></div>'+
          '<div class="threeRowStatic"><div class="fieldInput regular" style="margin-bottom:0px;">Actual'+
          '</div><div class="fieldInput thin">'+spNullCheck(sp.KAH_HH_PPS_Qualified_Admits__c)+'</div></div>'+
          '<div class="threeRowStatic"><div class="fieldInput regular" style="margin-bottom:0px;">% to Target'+
          '</div><div class="fieldInput thin">'+num+'</div></div></div></div>';
        }
        if (u.Line_of_Business__c!=null && u.Line_of_Business__c=='HP'){
          Decimal num = 0.0;
          if(sp.KAH_HP_Total_Admits__c!=null && sp.KAH_HP_Admit_Target__c!=0){
            num = ((sp.KAH_HP_Total_Admits__c/sp.KAH_HP_Admit_Target__c)*100).setScale(1);
          }
          html += '<div style="margin-top:5px;"><div class="fieldTitle regular">HP Admits</div>'+
          '<div><div class="threeRowStatic"><div class="fieldInput regular" style="margin-bottom:0px;">Target'+
          '</div><div class="fieldInput thin">'+spNullCheck(sp.KAH_HP_Admit_Target__c)+'</div></div>'+
          '<div class="threeRowStatic"><div class="fieldInput regular" style="margin-bottom:0px;">Actual'+
          '</div><div class="fieldInput thin">'+spNullCheck(sp.KAH_HP_Total_Admits__c)+'</div></div>'+
          '<div class="threeRowStatic"><div class="fieldInput regular" style="margin-bottom:0px;">% to Target'+
          '</div><div class="fieldInput thin">'+num+'</div></div></div></div>';
        }
      }

      Integer num = 0;
      for(AggregateResult ar : [select count(id) num from Contact_Team__c where User__c =: u.Id]){
        num += Integer.valueOf(ar.get('num'));
      }
      for(AggregateResult ar : [select count(id) num from AccountTeammember where UserId =: u.Id]){
        num += Integer.valueOf(ar.get('num'));
      }

      html += '<div style="margin-top:10px;"><div style="display:inline-block;"><div class="fieldInput regular" style="margin-bottom:0px;">Total Assignments'+
      '</div><div class="fieldInput thin" style="margin-bottom:0px; text-align:center;">'+num+'</div></div>'+
      '<div style="display:inline-block; float:right;"><div class="fieldInput regular" style="margin-bottom:0px;">Last Login';
      if(u.LastLoginDate!=null) html += '</div><div class="fieldInput thin" style="margin-bottom:0px; text-align:center;">'+Date.valueOf(u.LastLoginDate).format()+'</div></div></div>';
      else  html += '</div><div class="fieldInput thin" style="margin-bottom:0px; text-align:center;"><span class="lnr lnr-cross"></span></div></div></div>';

      if(!sps.isEmpty()) html += '<div class="line"></div>';
      return html;
    }

    private static String completedDate(Date completedDate){
      if(completedDate == null) return '<span class="lnr lnr-cross"></span>';
      else return String.valueOf(completedDate.format());
    }

    private static String crAverageText(Decimal average){
      if(average >= 4) return ' - Significant or strong evidence of behaviors';
      if(average >= 3) return ' - Frequent evidence of behaviors';
      if(average >= 2) return ' - Some infrequent evidence of behaviors';
      if(average >= 1) return ' - Little or no evidence of behaviors';
      else return '';
    }

    private static String fcrAverageText(Decimal average){
      if(average >= 4) return ' - Exceeding Expectations';
      if(average >= 3) return ' - Achieving Expectations';
      if(average >= 2) return ' - Approaching Expectations';
      if(average >= 1) return ' - Underperforming';
      else return '';
    }

    private static String crSectionText(Decimal score){
      if(score >= 13) return ' - Indicates Strong Evidence';
      if(score >= 9) return ' - Indicates Solid Evidence';
      if(score >= 4) return ' - Indicates a Development Opportunity';
      return '';
    }

    private static String hhCrTotalText(Integer score){
      if(score >= 97) return ' - Indicates Strong Evidence';
      if(score >= 65) return ' - Indicates Solid Evidence';
      if(score >= 32) return ' - Indicates a Development Opportunity';
      return '';
    }
    private static String hpCrTotalText(Integer score){
      if(score >= 109) return ' - Indicates Strong Evidence';
      if(score >= 73) return ' - Indicates Solid Evidence';
      if(score >= 36) return ' - Indicates a Development Opportunity';
      return '';
    }

    private static String textAreas(String field){
      if(field==null) return '';
      else return field;
    }

    private static String summarizeFields(String field){
      if(field != null){
        if(field.substring(0,1).isNumeric()){
          totalScore += Integer.valueOf(field.substring(0,1));
          sectionScore += Integer.valueOf(field.substring(0,1));
          if(field!='0 - Not Observed'){
            numberFilled++;
            sectionNumberFilled++;
          }
        }
      } else{
        field = '<span class="lnr lnr-cross"></span>';
      }
      return field;
    }

    private static String summarizeFcrFields(String field){
      if(field != null){
        if(field.substring(0,1).isNumeric()){
          totalScore += Integer.valueOf(field.substring(0,1));
          sectionScore += Integer.valueOf(field.substring(0,1));
          if(field!='0 - Not Observed'){
            numberFilled++;
            sectionNumberFilled++;
          }
        }
      } else{
        field = '0 - Not Observed';
      }
      return field;
    }

    private static String spNullCheck(Decimal num){
      String str = '<span class="lnr lnr-cross"></span>';
      if(num != null) str = String.valueOf(num.setScale(2));
      return str;
    }

    private static String nullTextCheck(String s){
      String str = '<span class="lnr lnr-cross"></span>';
      if(s != null) str = s;
      return str;
    }

    @RemoteAction global static String getWeekList(Id usrId, String dates){
      String html = '';

      Map<Id,  List<List<String>>> data = new Map<Id,  List<List<String>>>();

      for(Field_Coaching_Report__c fcr : [select Id, Name, OwnerId, RecordTypeId, Status__c, CreatedById from Field_Coaching_Report__c
      where OwnerId = :usrId and Owner.isActive =true and Date__c>=:Date.valueOf(dates.substring(0, dates.indexOf(' ')))
      and Date__c<=:Date.valueOf(dates.substring(dates.indexOf(' ')+1, dates.length())) order by Recordtype.Name asc, Date__c asc] ){
        if(data.containsKey(fcr.RecordTypeId)){
          List<List<String>> temp = data.remove(fcr.RecordTypeId);
          temp.add(new List<String>{String.valueOf(fcr.Id), String.valueOf(fcr.OwnerId), String.valueOf(fcr.Name), String.valueOf(fcr.Status__c), String.valueOf(fcr.CreatedById)});
          data.put(fcr.RecordTypeId, temp);
        } else{
          data.put(fcr.RecordTypeId, new List<List<String>>{new List<String>{String.valueOf(fcr.Id), String.valueOf(fcr.OwnerId), String.valueOf(fcr.Name), String.valueOf(fcr.Status__c), String.valueOf(fcr.CreatedById)}});
        }
      }

      for(Id key : data.keySet()){
        String fcrType = '';
        if(key==kahCrHH.Id){
          fcrType = 'hhCR';
          html += '<ul class="barCr';
        } else if(key==kahCrHP.Id){
          fcrType = 'hpCR';
          html += '<ul class="barCr';
        } else if(key==kahFcr.Id){
          fcrType = 'fcr';
          html += '<ul class="barFcr';
        } else if(key==kahFcrAf.Id){
          fcrType = 'fcrAF';
          html += '<ul class="barFcr';
        } else if(key==kahSa.Id){
          fcrType = 'sa';
          html += '<ul class="barSa';
        } else if(key==kahAf.Id){
          fcrType = 'af';
          html += '<ul class="barAf';
        }

        if(data.get(key).size()==1)
        html += ' one">';
        else
        html += '">';

        for(List<String> fcrIdUsrIdNameStatus : data.remove(key)){
          String privateIcon = '<span style="margin-left:14px;"></span>';
          if(fcrIdUsrIdNameStatus[4] != usrId && (fcrType=='hhCR' || fcrType=='hpCR')) privateIcon = '<i style="position:relative;right:8px;bottom:2px;" class="fa fa-eye-slash" aria-hidden="true"></i>';
          if(fcrIdUsrIdNameStatus[3] == 'Completed'){
            html += '<li data-id="'+fcrIdUsrIdNameStatus[0]+'">'+privateIcon+'<i style="position:relative; right:5px;" class="fa fa-check" aria-hidden="true"></i>'+
            '<div onclick="window.open(\''+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/Sales_SummaryFCR?fcrId='+fcrIdUsrIdNameStatus[0]+'&fcrType='+fcrType+'\')" class="blueLink inline">'+fcrIdUsrIdNameStatus[2]+'</div>';
          } else{
            html += '<li data-id="'+fcrIdUsrIdNameStatus[0]+'">'+privateIcon+'<span style="margin-left:14px;"></span>'+
            '<div onclick="window.open(\''+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/Sales_FCR?fcrId='+fcrIdUsrIdNameStatus[0]+'&userId='+fcrIdUsrIdNameStatus[1]+'\')" class="blueLink inline">'+fcrIdUsrIdNameStatus[2]+'</div>'+
            '<div onclick="fcrId=\''+fcrIdUsrIdNameStatus[0]+'\';$(\'#delete\').fadeIn();" class="redLink inline" style="margin-left:10px;"><i class="fa fa-times-circle" aria-hidden="true"></i> Delete</div></li>';
          }
        }
        html += '</ul>';
      }

      return html;
    }

    private static List<Id> getSubRoleIds(List<Id> roleIds) {
      List<Id> returnRoleIds = new List<Id>();
      for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
        returnRoleIds.add(r.Id);
      }
      if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
      return returnRoleIds;
    }


    @RemoteAction global static void deleteFCR(Id fcrId){
      List<Field_Coaching_Report__c> fcrs = [select Id from Field_Coaching_Report__c where Id = :fcrId];
      if(fcrs.size()!=0) delete fcrs;
    }

    private static Date summaryDates(String input){
      if(input!=null){
        return Date.newInstance(Integer.valueOf(input.mid(input.lastIndexOf('/')+1, input.length()-1)), Integer.valueOf(input.left(input.indexOf('/'))),
        Integer.valueOf(input.mid(input.indexOf('/')+1, (input.lastIndexOf('/')-input.indexOf('/'))-1)));
      } else return null;
    }

    @RemoteAction global static String saveSummaryText(Id fcrId, List<String> input, Boolean isLeader){
      for(Integer i=0; i<input.size(); i++) if(input[i] == '') input[i] = null;
      List<Field_Coaching_Report__c> fcrs = [select Id, Sales_FCR_KAH_4_Rep_Text__c, Sales_FCR_KAH_4_Leader_Text__c,
      Sales_FCR_KAH_4_Leader_Actions_1__c, Sales_FCR_KAH_4_Leader_Actions_2__c, Sales_FCR_KAH_4_Actions_1_Date__c, Sales_KAH_SA_Acknowledged__c, Sales_KAH_SA_Acknowledged_Date__c,
      Sales_FCR_KAH_4_Actions_2_Date__c, OwnerId, Sales_FCR_KAH_4_Actions_1_Completed__c, Sales_FCR_KAH_4_Actions_2_Completed__c from Field_Coaching_Report__c where Id = :fcrId];
      for(Field_Coaching_Report__c fcr : fcrs){
        if(isLeader && UserInfo.getUserId() != fcr.OwnerId){
          fcr.Sales_FCR_KAH_4_Leader_Text__c = String.valueOf(escapeJSON(input[0]));
          fcr.Sales_FCR_KAH_4_Leader_Actions_1__c = String.valueOf(escapeJSON(input[1]));
          fcr.Sales_FCR_KAH_4_Leader_Actions_2__c = String.valueOf(escapeJSON(input[2]));
          fcr.Sales_FCR_KAH_4_Actions_1_Date__c = summaryDates(input[3]);
          fcr.Sales_FCR_KAH_4_Actions_2_Date__c = summaryDates(input[4]);
        } else if(!isLeader && UserInfo.getUserId() == fcr.OwnerId){
          fcr.Sales_FCR_KAH_4_Rep_Text__c = String.valueOf(escapeJSON(input[0]));
          fcr.Sales_FCR_KAH_4_Actions_1_Completed__c = Boolean.valueOf(input[1]);
          fcr.Sales_FCR_KAH_4_Actions_2_Completed__c = Boolean.valueOf(input[2]);
          if(Boolean.valueOf(input[3]) && fcr.Sales_KAH_SA_Acknowledged__c==false && fcr.Sales_KAH_SA_Acknowledged_Date__c==null){
            fcr.Sales_KAH_SA_Acknowledged__c = Boolean.valueOf(input[3]);
            fcr.Sales_KAH_SA_Acknowledged_Date__c = Date.valueOf(System.now());
          }
        }
      }
      update fcrs;
      String leaderText = escapeJSON('<div class="lnr lnr-cross"></div>');
      String leaderAction1 = escapeJSON('<div class="lnr lnr-cross"></div>');
      String datepicker1 = null;
      String leaderAction2 = escapeJSON('<div class="lnr lnr-cross"></div>');
      String datepicker2 = null;
      String repText = escapeJSON('<div class="lnr lnr-cross"></div>');
      Boolean acknowledged = false;
      String acknowledgedDate = null;

      if(fcrs[0].Sales_FCR_KAH_4_Leader_Text__c!=null) leaderText = String.valueOf(fcrs[0].Sales_FCR_KAH_4_Leader_Text__c);
      if(fcrs[0].Sales_FCR_KAH_4_Leader_Actions_1__c!=null) leaderAction1 = String.valueOf(fcrs[0].Sales_FCR_KAH_4_Leader_Actions_1__c);
      if(fcrs[0].Sales_FCR_KAH_4_Actions_1_Date__c!=null) datepicker1 = '"'+String.valueOf(fcrs[0].Sales_FCR_KAH_4_Actions_1_Date__c.format())+'"';
      if(fcrs[0].Sales_FCR_KAH_4_Leader_Actions_2__c!=null) leaderAction2 = String.valueOf(fcrs[0].Sales_FCR_KAH_4_Leader_Actions_2__c);
      if(fcrs[0].Sales_FCR_KAH_4_Actions_2_Date__c!=null) datepicker2 = '"'+String.valueOf(fcrs[0].Sales_FCR_KAH_4_Actions_2_Date__c.format())+'"';
      if(fcrs[0].Sales_FCR_KAH_4_Rep_Text__c!=null) repText = String.valueOf(fcrs[0].Sales_FCR_KAH_4_Rep_Text__c);
      if(fcrs[0].Sales_KAH_SA_Acknowledged__c) acknowledged = true;
      if(fcrs[0].Sales_KAH_SA_Acknowledged_Date__c!=null) acknowledgedDate = '"'+String.valueOf(fcrs[0].Sales_KAH_SA_Acknowledged_Date__c.format())+'"';

      return '{"leaderText": "'+leaderText+'", "leaderAction1": "'+leaderAction1+'", "datepicker1": '+datepicker1+
      ', "completed1": '+fcrs[0].Sales_FCR_KAH_4_Actions_1_Completed__c+', "leaderAction2": "'+leaderAction2+
      '", "datepicker2": '+datepicker2+', "completed2": '+fcrs[0].Sales_FCR_KAH_4_Actions_2_Completed__c+
      ', "repText": "'+repText+'", "acknowledged": '+acknowledged+', "acknowledgedDate": '+acknowledgedDate+'}';
    }

    @RemoteAction global static void pushFCR(Id usrId, String fcrType){
      User u = [select Email, Name from user where id = :usrId];
      String subject='', a = '', color='';
      if(fcrType=='sa'){
        subject = 'Pre-ride Self Assessment';
        a = 'a ';
        color = '#ddae4f';
      }else if(fcrType=='af'){
        subject = 'The Asking Formula';
        a = 'an ';
        color = '#bf4c4c';
      }

      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> toAddresses = new List<String>();
      toAddresses.add(u.Email);
      mail.setToAddresses(toAddresses);
      mail.setReplyTo(UserInfo.getUserEmail());
      mail.setSenderDisplayName(UserInfo.getName());
      String body = '';
      mail.setSubject(subject+' Request');
      body += '<b style="font-size: 20px;">'+subject+' Request</b>';
      body += '<br/>Hi '+U.Name+',<br/><br/>';
      body += 'Please fill out '+a+subject+
      '. There is a button below that will take you to the necessary form. '+
      'Please fill it out at your earliest conviniece!<br/><br/>'+
      'Feel free to reply to this email with any questions that you may have.<br/><br/>'+
      '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Sales_FCR?fcrType='+fcrType+'&userId='+usrId+'" style="text-decoration:none;font-size:20px; color:white; background-color:'+color+'; border-radius:25px; padding: 5px 15px 5px 15px;"><b>Start '+subject+'</b></a><br/><br/>'+
      'Thanks,<br/>'+UserInfo.getName();
      mail.setHtmlBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction global static void completedEmail(Id usrId, String fcrType,
    String fcrId, Boolean isPrivate, String salesName, String salesEmail){

      List<User> u = [select Id, Email, Name, UserRoleId from user where id = :usrId];
      String subject='', color='';
      if(fcrType==kahSa.Id){
        subject = 'Pre-ride Self Assessment';
        color = '#ddae4f';
      }else if(fcrType==kahAf.Id){
        subject = 'The Asking Formula';
        color = '#bf4c4c';
      }else if(fcrType==kahCrHH.Id || fcrType==kahCrHP.Id){
        subject = 'Competency Rating';
        color = '#bf4c4c';
      }else if(fcrType==kahFcr.Id){
        subject = 'Field Coaching Report (SalesPro)';
        color = '#bf4c4c';
      }else if(fcrType==kahFcrAf.Id){
        subject = 'Field Coaching Report (TAF)';
        color = '#bf4c4c';
      }

      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

      List<User> toUsers = new List<User>();
      toUsers.addAll(getManagers(u[0].UserRoleId));
      if (!toUsers.isEmpty()) toUsers.addAll(getManagers(toUsers[0].userRoleId));
      if(!isPrivate) toUsers.addAll(u);

      List<String> emailAddresses = new List<String>();
      for(User usr : toUsers) emailAddresses.add(usr.Email);
      emailAddresses.add(salesEmail);
      mail.setToAddresses(emailAddresses);

      mail.setReplyTo(UserInfo.getUserEmail());
      mail.setSenderDisplayName(UserInfo.getName());
      String body = '';
      if(!isPrivate) mail.setSubject(subject+' Completed!');
      if(isPrivate) mail.setSubject('PRIVATE: '+subject+' Completed!');
      body += '<b style="font-size: 20px;">'+subject+' Completed!</b></br></br>';
      if(isPrivate) body += '</br></br><b style="font-size: 15px;color:#bf4c4c;">THIS IS A PRIVATE COMPETENCY RATING FORM! <span style="text-decoration:underline;">'+salesName+' SHOULD NOT BE FORWARDED THIS EMAIL!!!</span></b></br></br>';
      body += 'A coaching assessment form has been completed for '+salesName+'.'+
      ' There is a button below that will take you to the necessary form. '+
      'Feel free to reply to this email with any questions that you may have.<br/><br/>'+
      '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Sales_SummaryFCR?fcrId='+fcrId+'" style="text-decoration:none;font-size:20px; color:white; background-color:'+color+'; border-radius:25px; padding: 5px 15px 5px 15px;"><b>Click to open '+subject+'</b></a><br/><br/>'+
      'Thanks,<br/>'+UserInfo.getName();
      mail.setHtmlBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    private static List<User> getManagers(Id roleId){
      UserRole r = [select ParentRoleID from UserRole where Id =: roleId];
      List<User> u = new List<User>();
      if(r.ParentRoleID!=null) u = [select Id, Email, UserRoleId from User where UserRoleId =: r.ParentRoleID];
      if (u.isEmpty() && r.ParentRoleID!=null) return getManagers(r.ParentRoleID);
      else return u;
    }

    @RemoteAction global static void submitBug(String bugSubject, String bugText){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> toAddresses = new List<String>{'9o2tosrq39+38f0h+9f94v@in.meistertask.com'};
      mail.setToAddresses(toAddresses);
      mail.setReplyTo(UserInfo.getUserEmail());
      mail.setSenderDisplayName(UserInfo.getName());
      String body = '';
      mail.setSubject(bugSubject);
      body += '<b style="font-size: 20px;">'+UserInfo.getName()+' ('+UserInfo.getUserEmail()+') Has Found a Bug. </br>';
      body += '<p style="font-size: 15px;">'+bugText+'</p>';
      mail.setHtmlBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction global static String getFcrList(Id usrId, Integer offset){
      String html = '';
      Date d1 = Date.newInstance(System.now().year()+offset, 1, 1);
      Date d2 = Date.newInstance(System.now().year()+offset, 12, 31);
      List<Field_Coaching_Report__c> fcrs = [select Id, Name, Status__c, Completed_Date__c, Completed_By_del__r.Name, Date__c, RecordTypeId, CreatedById from Field_Coaching_Report__c where OwnerId = :usrId and Date__c>=:d1 and Date__c<=:d2 order by Date__c asc];
      for(Field_Coaching_Report__c fcr : fcrs){
        String fcrType;
        if(fcr.RecordTypeId==kahCrHH.Id){
          fcrType = 'cr';
        } else if(fcr.RecordTypeId==kahCrHP.Id){
          fcrType = 'cr';
        } else if(fcr.RecordTypeId==kahFcr.Id){
          fcrType = 'fcr';
        } else if(fcr.RecordTypeId==kahFcrAf.Id){
          fcrType = 'fcr';
        } else if(fcr.RecordTypeId==kahSa.Id){
          fcrType = 'psa';
        } else if(fcr.RecordTypeId==kahAf.Id){
          fcrType = 'taf';
        }

        if(((fcrType=='cr' && fcr.CreatedById==usrId) || fcrType!='cr') && ((fcrType=='fcr' && fcr.Status__c == 'Completed') || fcrType!='fcr')){
          if(fcr.Status__c == 'Completed') html += '<tr onclick="window.open(\''+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/Sales_summaryFCR?fcrId='+fcr.Id+'&fcrType='+fcrType+'\')">';
          else html += '<tr onclick="window.open(\''+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/Sales_FCR?fcrId='+fcr.Id+'&userId='+usrId+'\')">';
          html += '<td><i class="'+fcrType+' fa fa-circle" aria-hidden="true"></i><div class="fcrType">'+fcrType.toUpperCase()+'</div></td>'+
          '<td><div class="largeFont">'+fcr.Name+'</div>';
          if(fcr.Status__c == 'Completed') html += '<div class="smallFont"><i class="complete fa fa-check-circle" aria-hidden="true"></i> Completed by '+fcr.Completed_By_del__r.Name+' on '+fcr.Completed_Date__c.format()+'</div></td>';
          else html += '<div class="smallFont"><i class="incomplete fa fa-times-circle" aria-hidden="true"></i> Incomplete</div></td>';
          html += '</tr>';
        }
      }
      return html;
    }

    @RemoteAction global static String getHelp(String page){
      String docId;
      if(page=='manageFCR'){
        List<ContentVersion> cv = [select Id from ContentVersion where Title='KAH - Field Coaching Report (Manager)' and IsLatest=true];
        if(!cv.isEmpty()) docId = String.valueOf(cv[0].Id);
      } else if(page=='listFCR'){
        List<ContentVersion> cv = [select Id from ContentVersion where Title='KAH - Field Coaching Report (Associate)' and IsLatest=true];
        if(!cv.isEmpty()) docId = String.valueOf(cv[0].Id);
      }
      return docId;
    }

  }