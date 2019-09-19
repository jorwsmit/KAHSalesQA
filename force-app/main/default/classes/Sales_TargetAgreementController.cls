global class Sales_TargetAgreementController {
  private static Id usrId = UserInfo.getUserId();
  private static Id kahSpRecordTypeId = [SELECT ID FROM RecordType WHERE sObjectType = 'Sales_Performance__c' AND DeveloperName = 'KAH'].ID;
  private static String salesIncentivesEmail = 'SalesIncentives@gentiva.com';
  private static String legal = 'reserves the right and may, at its sole discretion,'+
  ' modify, amend, or cancel this plan at any time.  I also understand that the plan does not constitute a contract of'+
  ' employment or a representation of future earnings.  Also, I have read and agree to be bound by the Company\'s corporate'+
  ' compliance program and the rules and regulations relating to incentive programs.  I understand that the earning of an'+
  ' incentive, and the amount of the incentive, is subject to the terms, conditions, requirements, limits and adjustments set'+
  ' forth in the ';

  public string getAgreementEmailHtml() {
    Id taId = null;
    if(ApexPages.currentPage().getParameters().get('id')!='null') taId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));

    String html = '<div class="error red">There has been an error in processing your request!</div>';
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    List<Target_Agreement__c> tas = [select SA_Agreement_By__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Line_of_Business__c,
    SA_Agreement_Date__c, SA_Agreement_By__r.UserRoleId, SA_Agreement_By__r.Title, Manager_Agreement_By__c, Date__c, Sales_KAH_Form_Type__c,
    Manager_Agreement_By__r.Name, Manager_Agreement_Date__c, SA_Agreed__c, Manager_Agreed__c,
    HH_Admit_Target_JAN__c, HP_Admit_Target_JAN__c, HH_Admit_Target_FEB__c, HP_Admit_Target_FEB__c,
    HH_Admit_Target_MAR__c, HP_Admit_Target_MAR__c, HH_Admit_Target_APR__c, HP_Admit_Target_APR__c,
    HH_Admit_Target_MAY__c, HP_Admit_Target_MAY__c, HH_Admit_Target_JUN__c, HP_Admit_Target_JUN__c,
    HH_Admit_Target_JUL__c, HP_Admit_Target_JUL__c, HH_Admit_Target_AUG__c, HP_Admit_Target_AUG__c,
    HH_Admit_Target_SEP__c, HP_Admit_Target_SEP__c, HH_Admit_Target_OCT__c, HP_Admit_Target_OCT__c,
    HH_Admit_Target_NOV__c, HP_Admit_Target_NOV__c, HH_Admit_Target_DEC__c, HP_Admit_Target_DEC__c from Target_Agreement__c where
    (SA_Agreement_By__r.UserRoleId in :allSubRoleIds or SA_Agreement_By__c =: usrId or Manager_Agreement_By__c =: usrId) and Id =: taId and Retired__c=false and SA_Agreement_By__r.isActive=true];

    if(!tas.isEmpty()) html = pdfText(tas[0]);
    return html;
  }

  @RemoteAction global static String getAgreementById(Id taId){
    List<Target_Agreement__c> tas = [select SA_Agreement_By__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Line_of_Business__c,
    SA_Agreement_Date__c, SA_Agreement_By__r.UserRoleId, SA_Agreement_By__r.Title, Manager_Agreement_By__c, Sales_KAH_Form_Type__c,
    Manager_Agreement_By__r.Name, Manager_Agreement_Date__c, SA_Agreed__c, Manager_Agreed__c, SA_Agreement_By__r.FirstName, SA_Agreement_By__r.LastName,
    SA_Agreement_By__r.Region__c, SA_Agreement_By__r.Area__c, SA_Agreement_By__r.Market__c, Date__c,
    HH_Admit_Target_JAN__c, HP_Admit_Target_JAN__c, HH_Admit_Target_FEB__c, HP_Admit_Target_FEB__c,
    HH_Admit_Target_MAR__c, HP_Admit_Target_MAR__c, HH_Admit_Target_APR__c, HP_Admit_Target_APR__c,
    HH_Admit_Target_MAY__c, HP_Admit_Target_MAY__c, HH_Admit_Target_JUN__c, HP_Admit_Target_JUN__c,
    HH_Admit_Target_JUL__c, HP_Admit_Target_JUL__c, HH_Admit_Target_AUG__c, HP_Admit_Target_AUG__c,
    HH_Admit_Target_SEP__c, HP_Admit_Target_SEP__c, HH_Admit_Target_OCT__c, HP_Admit_Target_OCT__c,
    HH_Admit_Target_NOV__c, HP_Admit_Target_NOV__c, HH_Admit_Target_DEC__c, HP_Admit_Target_DEC__c from Target_Agreement__c where Id =: taId and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty()) return targetText(tas[0]);
    else return getAgreement(null, System.now().year(), new List<Boolean>{true, true, true});
  }

  @RemoteAction global static String getAgreement(Integer index, Integer year, List<Boolean> filters){
    String html='<div class="header red">'+
    '<h2>Goal Acknowledgement</h2>'+
    '<h5>No Goal Acknowledgements for '+year+'</h5>'+
    '</div>'+
    '<div class="pages">'+
    '<div style="z-index:1;" class="btn btn-primary lnr lnr-funnel btm-left" id="filter"></div>'+
    '<div style="z-index:2;" class="overlay"></div>'+
    '<div style="z-index:3;" class="center-modal"><div style="position:relative;left:50%;margin-left:-175px;">'+
    '<div style="width:350px;height:60px;"><div style="display:inline-block;padding-top:10px;">Manager Acknowledgement Only</div><div id="filter0" style="float:right;" class="green-btn icons" data-index=0>ON</div></div>'+
    '<div style="width:350px;height:60px;"><div style="display:inline-block;padding-top:10px;">Completed Acknowledgements</div><div id="filter1" style="float:right;" class="green-btn icons" data-index=1>ON</div></div>'+
    '<div style="width:350px;height:60px;"><div style="display:inline-block;padding-top:10px;">No Acknowledgements</div><div id="filter2" style="float:right;" class="green-btn icons" data-index=2>ON</div></div>'+
    '</div></div>'+
    '<div style="z-index:4; display:none;" class="btn btn-primary lnr lnr-cross btm-left" id="close-filter"></div>'+
    '<div class="btn-holder"><div class="btn btn-primary dropdown" id="year">Year</div></div>'+
    '<div style="padding: 0px 25px 0px 25px; margin-top: 0px;" class="btn-holder"><ul class="dropdown-list" id="year-list"></ul></div>'+
    '<div class="holder" style="border:none;"></div>'+
    '</div>';
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    List<Target_Agreement__c> tas = new List<Target_Agreement__c>();

    if(filters[0]) tas.addAll([select SA_Agreement_By__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Line_of_Business__c,
    SA_Agreement_Date__c, SA_Agreement_By__r.UserRoleId, SA_Agreement_By__r.Title, Manager_Agreement_By__c, Sales_KAH_Form_Type__c,
    Manager_Agreement_By__r.Name, Manager_Agreement_Date__c, SA_Agreed__c, Manager_Agreed__c, SA_Agreement_By__r.FirstName, SA_Agreement_By__r.LastName,
    SA_Agreement_By__r.Region__c, SA_Agreement_By__r.Area__c, SA_Agreement_By__r.Market__c, Date__c,
    HH_Admit_Target_JAN__c, HP_Admit_Target_JAN__c, HH_Admit_Target_FEB__c, HP_Admit_Target_FEB__c,
    HH_Admit_Target_MAR__c, HP_Admit_Target_MAR__c, HH_Admit_Target_APR__c, HP_Admit_Target_APR__c,
    HH_Admit_Target_MAY__c, HP_Admit_Target_MAY__c, HH_Admit_Target_JUN__c, HP_Admit_Target_JUN__c,
    HH_Admit_Target_JUL__c, HP_Admit_Target_JUL__c, HH_Admit_Target_AUG__c, HP_Admit_Target_AUG__c,
    HH_Admit_Target_SEP__c, HP_Admit_Target_SEP__c, HH_Admit_Target_OCT__c, HP_Admit_Target_OCT__c,
    HH_Admit_Target_NOV__c, HP_Admit_Target_NOV__c, HH_Admit_Target_DEC__c, HP_Admit_Target_DEC__c from Target_Agreement__c
    where (SA_Agreement_By__r.UserRoleId in :allSubRoleIds or SA_Agreement_By__c =: usrId or Manager_Agreement_By__c =: usrId) and Date__c >= :Date.newInstance(year,1,1)
    and Date__c <= :Date.newInstance(year,12,31) and (Manager_Agreed__c = true and SA_Agreed__c = false) and Retired__c=false and SA_Agreement_By__r.isActive=true order by SA_Agreement_By__r.Name asc]);

    if(filters[1]) tas.addAll([select SA_Agreement_By__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Line_of_Business__c,
    SA_Agreement_Date__c, SA_Agreement_By__r.UserRoleId, SA_Agreement_By__r.Title, Manager_Agreement_By__c, Sales_KAH_Form_Type__c,
    Manager_Agreement_By__r.Name, Manager_Agreement_Date__c, SA_Agreed__c, Manager_Agreed__c, SA_Agreement_By__r.FirstName, SA_Agreement_By__r.LastName,
    SA_Agreement_By__r.Region__c, SA_Agreement_By__r.Area__c, SA_Agreement_By__r.Market__c, Date__c,
    HH_Admit_Target_JAN__c, HP_Admit_Target_JAN__c, HH_Admit_Target_FEB__c, HP_Admit_Target_FEB__c,
    HH_Admit_Target_MAR__c, HP_Admit_Target_MAR__c, HH_Admit_Target_APR__c, HP_Admit_Target_APR__c,
    HH_Admit_Target_MAY__c, HP_Admit_Target_MAY__c, HH_Admit_Target_JUN__c, HP_Admit_Target_JUN__c,
    HH_Admit_Target_JUL__c, HP_Admit_Target_JUL__c, HH_Admit_Target_AUG__c, HP_Admit_Target_AUG__c,
    HH_Admit_Target_SEP__c, HP_Admit_Target_SEP__c, HH_Admit_Target_OCT__c, HP_Admit_Target_OCT__c,
    HH_Admit_Target_NOV__c, HP_Admit_Target_NOV__c, HH_Admit_Target_DEC__c, HP_Admit_Target_DEC__c from Target_Agreement__c
    where (SA_Agreement_By__r.UserRoleId in :allSubRoleIds or SA_Agreement_By__c =: usrId or Manager_Agreement_By__c =: usrId) and Date__c >= :Date.newInstance(year,1,1)
    and Date__c <= :Date.newInstance(year,12,31) and (Manager_Agreed__c = true and SA_Agreed__c = true) and Retired__c=false and SA_Agreement_By__r.isActive=true order by SA_Agreement_By__r.Name asc]);

    if(filters[2]) tas.addAll([select SA_Agreement_By__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Line_of_Business__c,
    SA_Agreement_Date__c, SA_Agreement_By__r.UserRoleId, SA_Agreement_By__r.Title, Manager_Agreement_By__c, Sales_KAH_Form_Type__c,
    Manager_Agreement_By__r.Name, Manager_Agreement_Date__c, SA_Agreed__c, Manager_Agreed__c, SA_Agreement_By__r.FirstName, SA_Agreement_By__r.LastName,
    SA_Agreement_By__r.Region__c, SA_Agreement_By__r.Area__c, SA_Agreement_By__r.Market__c, Date__c,
    HH_Admit_Target_JAN__c, HP_Admit_Target_JAN__c, HH_Admit_Target_FEB__c, HP_Admit_Target_FEB__c,
    HH_Admit_Target_MAR__c, HP_Admit_Target_MAR__c, HH_Admit_Target_APR__c, HP_Admit_Target_APR__c,
    HH_Admit_Target_MAY__c, HP_Admit_Target_MAY__c, HH_Admit_Target_JUN__c, HP_Admit_Target_JUN__c,
    HH_Admit_Target_JUL__c, HP_Admit_Target_JUL__c, HH_Admit_Target_AUG__c, HP_Admit_Target_AUG__c,
    HH_Admit_Target_SEP__c, HP_Admit_Target_SEP__c, HH_Admit_Target_OCT__c, HP_Admit_Target_OCT__c,
    HH_Admit_Target_NOV__c, HP_Admit_Target_NOV__c, HH_Admit_Target_DEC__c, HP_Admit_Target_DEC__c from Target_Agreement__c
    where (SA_Agreement_By__r.UserRoleId in :allSubRoleIds or SA_Agreement_By__c =: usrId or Manager_Agreement_By__c =: usrId) and Date__c >= :Date.newInstance(year,1,1)
    and Date__c <= :Date.newInstance(year,12,31) and (Manager_Agreed__c = false and SA_Agreed__c = false) and Retired__c=false and SA_Agreement_By__r.isActive=true order by SA_Agreement_By__r.Name asc]);

    if(tas.size()>=1 && index==null) html = getList(tas);
    else if(tas.size()>=1 && index!=null && index>=0 && index<tas.size()){
      html = targetText(tas[index]);
    }

    return html;
  }

  private static String getList(List<Target_Agreement__c> tas){
    String html='<div class="header blue">'+
    '<h2>GOAL ACKNOWLEDGEMENT</h2>'+
    '<h5>Dashboard</h5>'+
    '</div>'+
    '<div class="pages">'+
    '<button style="z-index:1;" class="btn btn-primary lnr lnr-funnel btm-left" id="filter"></button>'+
    '<div style="z-index:2;" class="overlay"></div>'+
    '<div style="z-index:3;" class="center-modal"><div style="position:relative;left:50%;margin-left:-175px;">'+
    '<div style="width:350px;height:60px;"><div style="display:inline-block;padding-top:10px;">Manager Acknowledgement Only</div><div id="filter0" style="float:right;" class="green-btn icons" data-index=0>ON</div></div>'+
    '<div style="width:350px;height:60px;"><div style="display:inline-block;padding-top:10px;">Completed Acknowledgements</div><div id="filter1" style="float:right;" class="green-btn icons" data-index=1>ON</div></div>'+
    '<div style="width:350px;height:60px;"><div style="display:inline-block;padding-top:10px;">No Acknowledgements</div><div id="filter2" style="float:right;" class="green-btn icons" data-index=2>ON</div></div>'+
    '</div></div>'+
    '<button style="z-index:4; display:none;" class="btn btn-primary lnr lnr-cross btm-left" id="close-filter"></button>'+
    '<div class="btn-holder"><button class="btn btn-primary dropdown" id="year">Year</button></div>'+
    '<div style="padding: 0px 25px 0px 25px; margin-top: 0px;" class="btn-holder"><ul class="dropdown-list" id="year-list"></ul></div>';
    html+='<div>';
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    for(Target_Agreement__c ta : tas){
      String lob = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Line_of_Business__c!=null) lob = String.valueOf(ta.SA_Agreement_By__r.Line_of_Business__c);

      String region = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Region__c!=null) region = String.valueOf(ta.SA_Agreement_By__r.Region__c);

      String area = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Area__c!=null) area = String.valueOf(ta.SA_Agreement_By__r.Area__c);

      String market = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Market__c!=null) market = String.valueOf(ta.SA_Agreement_By__r.Market__c);

      String saDate = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_Date__c!=null) saDate = String.valueOf(ta.SA_Agreement_Date__c.format());

      String mgrDate = '<span class="lnr lnr-cross"></span>';
      if(ta.Manager_Agreement_Date__c!=null) mgrDate = String.valueOf(ta.Manager_Agreement_Date__c.format());

      String color = 'red';
      if(ta.SA_Agreement_Date__c!=null && ta.Manager_Agreement_Date__c!=null) color = 'green';
      else if(ta.SA_Agreement_Date__c==null && ta.Manager_Agreement_Date__c!=null) color = 'yellow';

      html += '<div class="listItems"><div class="'+color+' icons">'+ta.SA_Agreement_By__r.FirstName.substring(0,1)+ta.SA_Agreement_By__r.LastName.substring(0,1)+'</div>'+
      '<div class="iconText"><div><b>'+ta.SA_Agreement_By__r.Name+'</b></div><div>'+lob+'</div></div>'+
      '<div class="iconText"><div><b>Region</b></div><div>'+region+'</div></div>'+
      '<div class="iconText"><div><b>Area</b></div><div>'+area+'</div></div>'+
      '<div class="iconText"><div><b>Market</b></div><div>'+market+'</div></div>'+
      '<div class="iconText"><div><b>Sales Associate</b></div><div>'+saDate+'</div></div>'+
      '<div class="iconText"><div><b>Manager</b></div><div>'+mgrDate+'</div></div></div>';
    }
    html+='</div>';
    html += '</div>';
    return html;
  }

  private static String targetText(Target_Agreement__c ta){
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    String saDate = '<span class="lnr lnr-cross"></span>';
    if(ta.SA_Agreement_Date__c != null) saDate = String.valueOf(ta.SA_Agreement_Date__c.format());

    String mgrDate = '<span class="lnr lnr-cross"></span>';
    if(ta.Manager_Agreement_Date__c != null) mgrDate = String.valueOf(ta.Manager_Agreement_Date__c.format());

    List<String> hhTargets = new List<String> {'<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>'};

    List<String> hpTargets = new List<String> {'<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>', '<span class="lnr lnr-cross"></span>',
    '<span class="lnr lnr-cross"></span>'};

    String saTitle = ' ';
    if(ta.SA_Agreement_By__r.Title != null) saTitle = ' '+String.valueOf(ta.SA_Agreement_By__r.Title)+' ';

    String planName = '<span class="lnr lnr-cross"></span>';
    if(ta.Sales_KAH_Form_Type__c!=null){
      if(ta.Sales_KAH_Form_Type__c=='CTL') planName='Care Transitions Liaison';
      else if(ta.Sales_KAH_Form_Type__c=='HHS') planName='Home Health Specialist';
      else if(ta.Sales_KAH_Form_Type__c=='HCS/HS') planName='Hospice Specialist';
      else if(ta.Sales_KAH_Form_Type__c=='MM') planName='Market Manager';
      else if(ta.Sales_KAH_Form_Type__c=='Dual') planName='Home Health and Hospice Specialist';
      else if(ta.Sales_KAH_Form_Type__c=='HUM') planName='Humana Member Experience Navigator';
    }

    Boolean showValues = false;
    if(ta.Manager_Agreed__c) showValues = true;

    List<Sales_Performance__c> sps = [select KAH_HH_Admit_Target__c, KAH_Hidden_HH_Admit_Target__c, KAH_HP_Admit_Target__c,
    KAH_Hidden_HP_Admit_Target__c, Month__c from Sales_Performance__c where
    Month__c >= :Date.newInstance(ta.Date__c.year(),1,1) and Month__c <= :Date.newInstance(ta.Date__c.year(),12,31)
    and ownerId =: ta.SA_Agreement_By__c];

    if(!ta.Manager_Agreed__c && !ta.SA_Agreed__c){
      for(Sales_Performance__c sp : sps){
        Integer index = sp.Month__c.month()-1;
        if(sp.KAH_Hidden_HH_Admit_Target__c!=null) hhTargets.set(index, String.valueOf(sp.KAH_Hidden_HH_Admit_Target__c));
        if(sp.KAH_Hidden_HP_Admit_Target__c!=null) hpTargets.set(index, String.valueOf(sp.KAH_Hidden_HP_Admit_Target__c));
      }
    } else if(ta.Manager_Agreed__c && !ta.SA_Agreed__c){
      for(Sales_Performance__c sp : sps){
        Integer index = sp.Month__c.month()-1;
        if(sp.KAH_HH_Admit_Target__c!=null) hhTargets.set(index, String.valueOf(sp.KAH_HH_Admit_Target__c));
        if(sp.KAH_HP_Admit_Target__c!=null) hpTargets.set(index, String.valueOf(sp.KAH_HP_Admit_Target__c));
      }
    } else if(ta.Manager_Agreed__c && ta.SA_Agreed__c){
      if(ta.HH_Admit_Target_JAN__c!=null) hhTargets.set(0, String.valueOf(ta.HH_Admit_Target_JAN__c));
      if(ta.HP_Admit_Target_JAN__c!=null) hpTargets.set(0, String.valueOf(ta.HP_Admit_Target_JAN__c));
      if(ta.HH_Admit_Target_FEB__c!=null) hhTargets.set(1, String.valueOf(ta.HH_Admit_Target_FEB__c));
      if(ta.HP_Admit_Target_FEB__c!=null) hpTargets.set(1, String.valueOf(ta.HP_Admit_Target_FEB__c));
      if(ta.HH_Admit_Target_MAR__c!=null) hhTargets.set(2, String.valueOf(ta.HH_Admit_Target_MAR__c));
      if(ta.HP_Admit_Target_MAR__c!=null) hpTargets.set(2, String.valueOf(ta.HP_Admit_Target_MAR__c));
      if(ta.HH_Admit_Target_APR__c!=null) hhTargets.set(3, String.valueOf(ta.HH_Admit_Target_APR__c));
      if(ta.HP_Admit_Target_APR__c!=null) hpTargets.set(3, String.valueOf(ta.HP_Admit_Target_APR__c));
      if(ta.HH_Admit_Target_MAY__c!=null) hhTargets.set(4, String.valueOf(ta.HH_Admit_Target_MAY__c));
      if(ta.HP_Admit_Target_MAY__c!=null) hpTargets.set(4, String.valueOf(ta.HP_Admit_Target_MAY__c));
      if(ta.HH_Admit_Target_JUN__c!=null) hhTargets.set(5, String.valueOf(ta.HH_Admit_Target_JUN__c));
      if(ta.HP_Admit_Target_JUN__c!=null) hpTargets.set(5, String.valueOf(ta.HP_Admit_Target_JUN__c));
      if(ta.HH_Admit_Target_JUL__c!=null) hhTargets.set(6, String.valueOf(ta.HH_Admit_Target_JUL__c));
      if(ta.HP_Admit_Target_JUL__c!=null) hpTargets.set(6, String.valueOf(ta.HP_Admit_Target_JUL__c));
      if(ta.HH_Admit_Target_AUG__c!=null) hhTargets.set(7, String.valueOf(ta.HH_Admit_Target_AUG__c));
      if(ta.HP_Admit_Target_AUG__c!=null) hpTargets.set(7, String.valueOf(ta.HP_Admit_Target_AUG__c));
      if(ta.HH_Admit_Target_SEP__c!=null) hhTargets.set(8, String.valueOf(ta.HH_Admit_Target_SEP__c));
      if(ta.HP_Admit_Target_SEP__c!=null) hpTargets.set(8, String.valueOf(ta.HP_Admit_Target_SEP__c));
      if(ta.HH_Admit_Target_OCT__c!=null) hhTargets.set(9, String.valueOf(ta.HH_Admit_Target_OCT__c));
      if(ta.HP_Admit_Target_OCT__c!=null) hpTargets.set(9, String.valueOf(ta.HP_Admit_Target_OCT__c));
      if(ta.HH_Admit_Target_NOV__c!=null) hhTargets.set(10, String.valueOf(ta.HH_Admit_Target_NOV__c));
      if(ta.HP_Admit_Target_NOV__c!=null) hpTargets.set(10, String.valueOf(ta.HP_Admit_Target_NOV__c));
      if(ta.HH_Admit_Target_DEC__c!=null) hhTargets.set(11, String.valueOf(ta.HH_Admit_Target_DEC__c));
      if(ta.HP_Admit_Target_DEC__c!=null) hpTargets.set(11, String.valueOf(ta.HP_Admit_Target_DEC__c));
    }

    String html = '';
    if(ta.SA_Agreement_Date__c!=null && ta.Manager_Agreement_Date__c!=null) html += '<div class="header green">';
    else if(ta.SA_Agreement_Date__c==null && ta.Manager_Agreement_Date__c!=null) html += '<div class="header yellow">';
    else  html += '<div class="header red">';
    html += '<button onclick="index=null; getAgreement();" class="btn btn-primary back"><span class="lnr lnr-chevron-left"></span> Go Back</button>'+
    '<div style="display:inline-block; margin-left: 25px;">'+
    '<h3>GOAL ACKNOWLEDGEMENT FORM</h3>'+
    '<h5><b>'+ta.SA_Agreement_By__r.Name+'</b> - '+ta.Date__c.year()+'</h5>'+
    '</div>'+
    '</div>'+
    '<div class="pages">'+
    '<div class="holder">'+
    '<div class="row">'+
    '<div class="col"><h5><b>Sales Associate Acknowledgement Date</b></h5><h5>'+saDate+'</h5></div>'+
    '<div class="col"><h5><b>Manager Acknowledgement Date</b></h5><h5>'+mgrDate+'</h5></div>'+
    '</div></div>';
     if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HUM')){
      legal = 'I understand that Humana '+legal;
     } else {
      legal = 'I understand that Kindred at Home '+legal;
     }
    if(ta.SA_Agreement_By__c == usrId){
      html += '<div class="holder"><div>I hereby acknowledge receipt of the <b>'+planName+'</b> Plan, effective for '+ta.Date__c.year()+'.</div>'+
      '<br/><div>'+legal+planName+' Plan document.</div><br/><div>I also acknowledge receipt of my monthly admissions Goal for '+ta.Date__c.year()+', and understand that this Goal may change'+
      ' during the year if significant changes are made to my territory. It is required that the initial Goal form for the year be signed by both you'+
      ' and your manager to be kept on file. If the Goal changes during the year, it is not necessary for a new form to be signed.'+
      ' Your sales manager will communicate any Goal changes to you as soon as possible after the close of each month.</div>';
    } else{
      html += '<div class="holder"><div>I hereby acknowledge receipt of '+ta.SA_Agreement_By__r.Name+'\'s <b>'+planName+'</b> Plan, effective for '
      +ta.Date__c.year()+'.</div><br/><div>'+legal+planName+' Plan document.</div><br/><div>I also acknowledge receipt of '+ta.SA_Agreement_By__r.Name+'\'s monthly admissions Goal for '+ta.Date__c.year()+','+
      ' and understand that this Goal may change during the year if significant changes are made to '+ta.SA_Agreement_By__r.Name+'\'s territory.  It is required that the'+
      ' initial Goal form for the year be signed by both '+ta.SA_Agreement_By__r.Name+' and you, the manager, and to be kept on file. If the Goal changes during the year, it is not'+
      ' necessary for a new form to be signed. You as the sales manager are responsible for communicating any Goal changes to '+ta.SA_Agreement_By__r.Name+' as soon as possible after the close of each month.</div>';
    }
    html += '</div><div class="holder">';
    if((ta.SA_Agreement_By__c == usrId && ta.Manager_Agreement_Date__c!=null) || allSubRoleIds.contains(ta.SA_Agreement_By__r.UserRoleId) || ta.Manager_Agreement_By__c == usrId){
      if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HH')){
        html += '<div style="margin-bottom:13px;">'+
        '<div class="row">'+
        '<div class="col"><div><h3><b>'+ta.Date__c.year()+' HH Targets</b></h3></div></div>'+
        '</div>'+
        '<div class="row">'+
        '<div class="col"><h5>JAN</h5><h5>'+hhTargets[0]+'</h5></div>'+
        '<div class="col"><h5>FEB</h5><h5>'+hhTargets[1]+'</h5></div>'+
        '<div class="col"><h5>MAR</h5><h5>'+hhTargets[2]+'</h5></div>'+
        '<div class="col"><h5>APR</h5><h5>'+hhTargets[3]+'</h5></div>'+
        '<div class="col"><h5>MAY</h5><h5>'+hhTargets[4]+'</h5></div>'+
        '<div class="col"><h5>JUN</h5><h5>'+hhTargets[5]+'</h5></div>'+
        '<div class="col"><h5>JUL</h5><h5>'+hhTargets[6]+'</h5></div>'+
        '<div class="col"><h5>AUG</h5><h5>'+hhTargets[7]+'</h5></div>'+
        '<div class="col"><h5>SEP</h5><h5>'+hhTargets[8]+'</h5></div>'+
        '<div class="col"><h5>OCT</h5><h5>'+hhTargets[9]+'</h5></div>'+
        '<div class="col"><h5>NOV</h5><h5>'+hhTargets[10]+'</h5></div>'+
        '<div class="col"><h5>DEC</h5><h5>'+hhTargets[11]+'</h5></div>'+
        '</div>';
      }
      if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HP')){
        html += '<div style="margin-top:13px;">'+
        '<div class="row">'+
        '<div class="col"><div><h3><b>'+ta.Date__c.year()+' HP Targets</b></h3></div></div>'+
        '</div>'+
        '<div class="row">'+
        '<div class="col"><h5>JAN</h5><h5>'+hpTargets[0]+'</h5></div>'+
        '<div class="col"><h5>FEB</h5><h5>'+hpTargets[1]+'</h5></div>'+
        '<div class="col"><h5>MAR</h5><h5>'+hpTargets[2]+'</h5></div>'+
        '<div class="col"><h5>APR</h5><h5>'+hpTargets[3]+'</h5></div>'+
        '<div class="col"><h5>MAY</h5><h5>'+hpTargets[4]+'</h5></div>'+
        '<div class="col"><h5>JUN</h5><h5>'+hpTargets[5]+'</h5></div>'+
        '<div class="col"><h5>JUL</h5><h5>'+hpTargets[6]+'</h5></div>'+
        '<div class="col"><h5>AUG</h5><h5>'+hpTargets[7]+'</h5></div>'+
        '<div class="col"><h5>SEP</h5><h5>'+hpTargets[8]+'</h5></div>'+
        '<div class="col"><h5>OCT</h5><h5>'+hpTargets[9]+'</h5></div>'+
        '<div class="col"><h5>NOV</h5><h5>'+hpTargets[10]+'</h5></div>'+
        '<div class="col"><h5>DEC</h5><h5>'+hpTargets[11]+'</h5></div>'+
        '</div>';
      }
        if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HUM')){
        html += '<div style="margin-bottom:13px;">'+
        '<div class="row">'+
        '<div class="col"><div><h3><b>'+ta.Date__c.year()+' Humana Targets</b></h3></div></div>'+
        '</div>'+
        '<div class="row">'+
        '<div class="col"><h5>JAN</h5><h5>'+hhTargets[0]+'</h5></div>'+
        '<div class="col"><h5>FEB</h5><h5>'+hhTargets[1]+'</h5></div>'+
        '<div class="col"><h5>MAR</h5><h5>'+hhTargets[2]+'</h5></div>'+
        '<div class="col"><h5>APR</h5><h5>'+hhTargets[3]+'</h5></div>'+
        '<div class="col"><h5>MAY</h5><h5>'+hhTargets[4]+'</h5></div>'+
        '<div class="col"><h5>JUN</h5><h5>'+hhTargets[5]+'</h5></div>'+
        '<div class="col"><h5>JUL</h5><h5>'+hhTargets[6]+'</h5></div>'+
        '<div class="col"><h5>AUG</h5><h5>'+hhTargets[7]+'</h5></div>'+
        '<div class="col"><h5>SEP</h5><h5>'+hhTargets[8]+'</h5></div>'+
        '<div class="col"><h5>OCT</h5><h5>'+hhTargets[9]+'</h5></div>'+
        '<div class="col"><h5>NOV</h5><h5>'+hhTargets[10]+'</h5></div>'+
        '<div class="col"><h5>DEC</h5><h5>'+hhTargets[11]+'</h5></div>'+
        '</div>';
      }
    } else{
      html += '<h3>Targets are not yet available. Please check again after your manager\'s approval.</h3>';
    }
    if(ta.SA_Agreement_By__c == usrId && ta.SA_Agreement_Date__c==null  && ta.Manager_Agreement_Date__c!=null){
      html += '<div style="margin-top: 25px;" class="row">'+
      '<div class="col"><button style="width: 230px;" id="acceptTargets" data-id="'+ta.Id+'" class="btn btn-success btn-lg">Acknowledge targets</button></div></div>'+
      '<div style="margin-top: 25px;" class="row"><div class="col">* By clicking the Acknowledge Targets button,'+
      ' you acknowledge receipt of both the '+planName+' Plan document, and your monthly admissions Goal for '+ta.Date__c.year()+'.</div></div>';
    } else if((allSubRoleIds.contains(ta.SA_Agreement_By__r.UserRoleId) || ta.Manager_Agreement_By__c == usrId) && ta.Manager_Agreement_Date__c==null){
      html += '<div style="margin-top: 25px;" class="row">'+
      '<div class="col"><button style="width: 230px;" id="acceptTargets" data-id="'+ta.Id+'" class="btn btn-success btn-lg">Acknowledge targets</button></div>'+
      '<div class="col"><button style="width: 230px;" id="questionTargets" data-id="'+ta.Id+'" class="btn btn-primary btn-lg" onclick="$(\'#questionModal\').modal(\'show\');">Question</button></div></div>'+
      '<div style="margin-top: 25px;" class="row"><div class="col">* By clicking the Acknowledge Targets button,'+
      ' you have reviewed the '+planName+' Plan details, and the '+ta.Date__c.year()+' territory admissions Goal with '+ta.SA_Agreement_By__r.Name+'.</div></div>';
    }
    html += '</div>';
    return html;
  }

  @RemoteAction global static String agree(Id taId){
    String html = '';
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});

    List<Target_Agreement__c> tas = [select SA_Agreement_By__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Line_of_Business__c,
    SA_Agreement_Date__c, SA_Agreement_By__r.UserRoleId, SA_Agreement_By__r.Title, Date__c, Sales_KAH_Form_Type__c,
    Manager_Agreement_By__c, Manager_Agreement_By__r.Name, Manager_Agreement_Date__c, SA_Agreed__c, Manager_Agreed__c,
    HH_Admit_Target_JAN__c, HP_Admit_Target_JAN__c, HH_Admit_Target_FEB__c, HP_Admit_Target_FEB__c,
    HH_Admit_Target_MAR__c, HP_Admit_Target_MAR__c, HH_Admit_Target_APR__c, HP_Admit_Target_APR__c,
    HH_Admit_Target_MAY__c, HP_Admit_Target_MAY__c, HH_Admit_Target_JUN__c, HP_Admit_Target_JUN__c,
    HH_Admit_Target_JUL__c, HP_Admit_Target_JUL__c, HH_Admit_Target_AUG__c, HP_Admit_Target_AUG__c,
    HH_Admit_Target_SEP__c, HP_Admit_Target_SEP__c, HH_Admit_Target_OCT__c, HP_Admit_Target_OCT__c,
    HH_Admit_Target_NOV__c, HP_Admit_Target_NOV__c, HH_Admit_Target_DEC__c, HP_Admit_Target_DEC__c from Target_Agreement__c where
    (SA_Agreement_By__r.UserRoleId in :allSubRoleIds or SA_Agreement_By__c =: usrId or Manager_Agreement_By__c =: usrId) and Id =: taId and Retired__c=false and SA_Agreement_By__r.isActive=true];

    List<Decimal> hhTargets = new List<Decimal> {null, null, null, null, null, null, null, null, null, null, null, null};
    List<Decimal> hhTargetsHidden = new List<Decimal> {null, null, null, null, null, null, null, null, null, null, null, null};
    List<Decimal> hpTargets = new List<Decimal> {null, null, null, null, null, null, null, null, null, null, null, null};
    List<Decimal> hpTargetsHidden = new List<Decimal> {null, null, null, null, null, null, null, null, null, null, null, null};

    List<Sales_Performance__c> sps = [select KAH_HH_Admit_Target__c, KAH_Hidden_HH_Admit_Target__c, KAH_HP_Admit_Target__c,
    KAH_Hidden_HP_Admit_Target__c, Month__c from Sales_Performance__c where
    Month__c >= :Date.newInstance(tas[0].Date__c.year(),1,1) and Month__c <= :Date.newInstance(tas[0].Date__c.year(),12,31)
    and ownerId =: tas[0].SA_Agreement_By__c];

    if(!tas.isEmpty()){
      for(Sales_Performance__c sp : sps){
        Integer i = sp.Month__c.month()-1;
        if(sp.KAH_HH_Admit_Target__c!=null) hhTargets.set(i, sp.KAH_HH_Admit_Target__c.setScale(2));
        if(sp.KAH_HP_Admit_Target__c!=null) hpTargets.set(i, sp.KAH_HP_Admit_Target__c.setScale(2));
      }
      Boolean sendPdf= false;
      if((tas[0].SA_Agreement_By__c == usrId && tas[0].SA_Agreement_Date__c==null && !tas[0].SA_Agreed__c && tas[0].Manager_Agreed__c) || (tas[0].SA_Agreement_By__c == usrId && Test.isRunningTest())){
        tas[0].SA_Agreement_Date__c = Date.valueOf(System.now());
        tas[0].SA_Agreed_Date_Time__c = System.now();
        tas[0].SA_Agreed__c = true;
        tas[0].HH_Admit_Target_JAN__c = hhTargets[0]; tas[0].HP_Admit_Target_JAN__c = hpTargets[0];
        tas[0].HH_Admit_Target_FEB__c = hhTargets[1]; tas[0].HP_Admit_Target_FEB__c = hpTargets[1];
        tas[0].HH_Admit_Target_MAR__c = hhTargets[2]; tas[0].HP_Admit_Target_MAR__c = hpTargets[2];
        tas[0].HH_Admit_Target_APR__c = hhTargets[3]; tas[0].HP_Admit_Target_APR__c = hpTargets[3];
        tas[0].HH_Admit_Target_MAY__c = hhTargets[4]; tas[0].HP_Admit_Target_MAY__c = hpTargets[4];
        tas[0].HH_Admit_Target_JUN__c = hhTargets[5]; tas[0].HP_Admit_Target_JUN__c = hpTargets[5];
        tas[0].HH_Admit_Target_JUL__c = hhTargets[6]; tas[0].HP_Admit_Target_JUL__c = hpTargets[6];
        tas[0].HH_Admit_Target_AUG__c = hhTargets[7]; tas[0].HP_Admit_Target_AUG__c = hpTargets[7];
        tas[0].HH_Admit_Target_SEP__c = hhTargets[8]; tas[0].HP_Admit_Target_SEP__c = hpTargets[8];
        tas[0].HH_Admit_Target_OCT__c = hhTargets[9]; tas[0].HP_Admit_Target_OCT__c = hpTargets[9];
        tas[0].HH_Admit_Target_NOV__c = hhTargets[10]; tas[0].HP_Admit_Target_NOV__c = hpTargets[10];
        tas[0].HH_Admit_Target_DEC__c = hhTargets[11]; tas[0].HP_Admit_Target_DEC__c = hpTargets[11];
        sendPdf = true;
      } else if((allSubRoleIds.contains(tas[0].SA_Agreement_By__r.UserRoleId) && tas[0].Manager_Agreement_Date__c == null && !tas[0].Manager_Agreed__c)
      || (tas[0].Manager_Agreement_By__c == usrId && tas[0].Manager_Agreement_Date__c == null && !tas[0].Manager_Agreed__c)
      || (allSubRoleIds.contains(tas[0].SA_Agreement_By__r.UserRoleId) && Test.isRunningTest())){
        tas[0].Manager_Agreement_By__c = usrId;
        tas[0].Manager_Agreement_Date__c = Date.valueOf(System.now());
        tas[0].Manager_Agreed_Date_Time__c = System.now();
        tas[0].Manager_Agreed__c = true;

        for(Sales_Performance__c sp : sps){
          sp.KAH_HH_Admit_Target__c = sp.KAH_Hidden_HH_Admit_Target__c;
          sp.KAH_HP_Admit_Target__c = sp.KAH_Hidden_HP_Admit_Target__c;
        }
        update sps;
        emailSA(taId);
      }
      update tas;
      html = targetText(tas[0]);
    }
    return html;
  }

  private static void emailSA(Id taId){
    List<Target_Agreement__c> tas = [select SA_Agreement_By__r.Name, SA_Agreement_By__r.Email, Manager_Agreement_By__r.Name,
    SA_Agreed__c, Manager_Agreed__c, Manager_Agreement_By__r.Email, Date__c from Target_Agreement__c where Id =: taId and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty()){
      List<String> toAddresses = new List<String>();
      toAddresses.add(tas[0].SA_Agreement_By__r.Email);
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(toAddresses);
      mail.setReplyTo(tas[0].Manager_Agreement_By__r.Email);
      mail.setSenderDisplayName(tas[0].Manager_Agreement_By__r.Name);
      String body = '';
      mail.setSubject('Your Targets Have Been Acknowledged');
      body += '<br/>Hi '+tas[0].SA_Agreement_By__r.Name+',<br/><br/>';
      body += 'I have acknowledged your targets for '+tas[0].Date__c.year()+'.<br/><br/>'+
      'Please use the link below to open up the form, review it thoroughly, then click the acknowledge button once you are comfortable with your targets. Upon doing so, you and I should receive a confirmation email.<br/><br/>'+
      '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Sales_TargetAgreement?id='+taId+'" style="text-decoration:none;font-size:20px; color:white; background-color: #007bff; border-radius:25px; padding: 5px 15px 5px 15px;"><b>Go To Goal Acknowledgement Form</b></a><br/><br/>'+
      'Thanks,<br/>'+tas[0].Manager_Agreement_By__r.Name;
      mail.setHtmlBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
  }

  @RemoteAction global static Set<Id> getSubRoleIds(Set<Id> roleIds) {
    Set<Id> returnRoleIds = new Set<Id>();
    for (UserRole r : [select Id from UserRole where ParentRoleId in :roleIds and ParentRoleID != null]) {
      returnRoleIds.add(r.Id);
    }
    if (!returnRoleIds.isEmpty()) returnRoleIds.addAll(getSubRoleIds(returnRoleIds));
    return returnRoleIds;
  }

  @RemoteAction global static void emailPdf(Id taId){
    List<Target_Agreement__c> tas = [select SA_Agreement_By__r.Name, SA_Agreement_By__r.Email, Manager_Agreement_By__r.Name,
    SA_Agreed__c, Manager_Agreed__c, Manager_Agreement_By__r.Email, Date__c from Target_Agreement__c where Id =: taId and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty() && tas[0].SA_Agreed__c && tas[0].Manager_Agreed__c){
      PageReference pageRef = new PageReference('/apex/Sales_TargetAgreementEmail');
      pageRef.getParameters().put('id', String.valueOf(taId));
      Blob pdf = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pageRef.getContent();

      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

      Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
      efa.setFileName(tas[0].SA_Agreement_By__r.Name+' Goal Acknowledgement Form - '+dateFile(tas[0].Date__c)+'.pdf');
      efa.setBody(pdf);

      List<String> toAddresses = new List<String>();
      toAddresses.add(tas[0].SA_Agreement_By__r.Email);
      toAddresses.add(tas[0].Manager_Agreement_By__r.Email);
      List<String> ccAddresses = new List<String>();
      ccAddresses.add(salesIncentivesEmail);
      email.setReplyTo(salesIncentivesEmail);
      email.setSenderDisplayName('Sales Incentives Team');
      email.setSubject('Goal Acknowledgement Has Been Completed');
      email.setToAddresses(toAddresses);
      email.setCcAddresses(ccAddresses);
      email.setPlainTextBody('Hi,\n\nAttached to this email you will find a pdf containing the targets that were acknowledged by '+
      tas[0].SA_Agreement_By__r.Name+', and their manager, '+tas[0].Manager_Agreement_By__r.Name+'.\n\nThanks,\nSales Incentives Team');

      email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

      Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
  }

  private static String dateFile(Date d){
    return d.format().replace('/','-');
  }

  public static String pdfText(Target_Agreement__c ta){
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    String saDate = 'X';
    if(ta.SA_Agreement_Date__c != null) saDate = String.valueOf(ta.SA_Agreement_Date__c.format());

    String mgrDate = 'X';
    if(ta.Manager_Agreement_Date__c != null) mgrDate = String.valueOf(ta.Manager_Agreement_Date__c.format());

    String saTitle = ' ';
    if(ta.SA_Agreement_By__r.Title != null) saTitle = ' '+String.valueOf(ta.SA_Agreement_By__r.Title)+' ';

    List<String> hhTargets = new List<String> {'X', 'X', 'X',
    'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X','X'};

    List<String> hpTargets = new List<String> {'X', 'X', 'X',
    'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'};

    Boolean showValues = false;
    if(ta.Manager_Agreed__c) showValues = true;

    for(Sales_Performance__c sp : [select KAH_HH_Admit_Target__c, KAH_Hidden_HH_Admit_Target__c, KAH_HP_Admit_Target__c,
    KAH_Hidden_HP_Admit_Target__c, Month__c from Sales_Performance__c where
    Month__c >= :Date.newInstance(ta.Date__c.year(),1,1) and Month__c <= :Date.newInstance(ta.Date__c.year(),12,31)
    and ownerId =: ta.SA_Agreement_By__c]){
      Integer index = sp.Month__c.month()-1;
      if(showValues){
        if(sp.KAH_HH_Admit_Target__c!=null){
          hhTargets.set(index, String.valueOf(sp.KAH_HH_Admit_Target__c));
        }
        if(sp.KAH_HP_Admit_Target__c!=null){
          hpTargets.set(index, String.valueOf(sp.KAH_HP_Admit_Target__c));
        }
      } else{
        if(sp.KAH_Hidden_HH_Admit_Target__c!=null){
          hhTargets.set(index, String.valueOf(sp.KAH_Hidden_HH_Admit_Target__c));
        }
        if(sp.KAH_Hidden_HP_Admit_Target__c!=null){
          hpTargets.set(index, String.valueOf(sp.KAH_Hidden_HP_Admit_Target__c));
        }
      }
    }

    String planName = 'X';
    if(ta.Sales_KAH_Form_Type__c!=null){
      if(ta.Sales_KAH_Form_Type__c=='CTL') planName='Care Transitions Liaison';
      else if(ta.Sales_KAH_Form_Type__c=='HHS') planName='Home Health Specialist';
      else if(ta.Sales_KAH_Form_Type__c=='HCS/HS') planName='Hospice Specialist';
      else if(ta.Sales_KAH_Form_Type__c=='MM') planName='Market Manager';
      else if(ta.Sales_KAH_Form_Type__c=='Dual') planName='Home Health and Hospice Specialist';
      else if(ta.Sales_KAH_Form_Type__c=='HUM') planName='Humana Member Experience Navigator';
    }

    String html = '';
    if(ta.SA_Agreement_Date__c!=null && ta.Manager_Agreement_Date__c!=null) html += '<div class="header green">';
    else if(ta.SA_Agreement_Date__c==null && ta.Manager_Agreement_Date__c!=null) html += '<div class="header yellow">';
    else  html += '<div class="header red">';
    html += '<div style="display:inline-block; margin-left: 25px;">'+
    '<h1>GOAL ACKNOWLEDGEMENT FORM</h1>'+
    '<h2><b>'+ta.SA_Agreement_By__r.Name+'</b> - '+ta.Date__c.year()+'</h2>'+
    '</div>'+
    '</div>'+
    '<div class="pages">'+
    '<div class="holder">'+
    '<div style="display:inline-block;width:50%;"><h3><b>SA Acknowledgement Date</b></h3><h3>'+saDate+'</h3></div>'+
    '<div style="display:inline-block;width:50%;"><h3><b>Manager Acknowledgement Date</b></h3><h3>'+mgrDate+'</h3></div>'+
    '</div>';
     if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HUM')){
      legal = 'I understand that Humana '+legal;
     } else {
      legal = 'I understand that Kindred at Home '+legal;
     }
      if(ta.SA_Agreement_By__c == usrId){
      html += '<div class="holder"><div>I hereby acknowledge receipt of the '+planName+' Plan, effective for '+ta.Date__c.year()+'.</div>'+
      '<div style="margin-top:10px;">'+legal+planName+' Plan document.</div><div style="margin-top:10px;">I also acknowledge receipt of my monthly admissions Goal for '+ta.Date__c.year()+', and understand that this Goal may change'+
      ' during the year if significant changes are made to my territory. It is required that the initial Goal form for the year be signed by both you'+
      ' and your manager to be kept on file. If the Goal changes during the year, it is not necessary for a new form to be signed.'+
      ' Your sales manager will communicate any Goal changes to you as soon as possible after the close of each month.</div>';
    } else{
      html += '<div class="holder"><div>I hereby acknowledge receipt of '+ta.SA_Agreement_By__r.Name+'\'s '+planName+' Plan, effective for '
      +ta.Date__c.year()+'.</div><div style="margin-top:10px;">'+legal+planName+' Plan document.</div><div style="margin-top:10px;">I also acknowledge receipt of '+ta.SA_Agreement_By__r.Name+'\'s monthly admissions Goal for '+ta.Date__c.year()+','+
      ' and understand that this Goal may change during the year if significant changes are made to '+ta.SA_Agreement_By__r.Name+'\'s territory.  It is required that the'+
      ' initial Goal form for the year be signed by both '+ta.SA_Agreement_By__r.Name+' and you, the manager, and to be kept on file. If the Goal changes during the year, it is not'+
      ' necessary for a new form to be signed. You as the sales manager are responsible for communicating any Goal changes to '+ta.SA_Agreement_By__r.Name+' as soon as possible after the close of each month.</div>';
    }
    html += '</div><div class="holder">';
    if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HH')){
      html += '<div style="margin-bottom:13px;" class="container">'+
      '<div>'+
      '<div><div><h2><b>'+ta.Date__c.year()+' HH Targets</b></h2></div></div>'+
      '</div>'+
      '<div>'+
      '<div class="months"><h5>JAN</h5><h5>'+hhTargets[0]+'</h5></div>'+
      '<div class="months"><h5>FEB</h5><h5>'+hhTargets[1]+'</h5></div>'+
      '<div class="months"><h5>MAR</h5><h5>'+hhTargets[2]+'</h5></div>'+
      '<div class="months"><h5>APR</h5><h5>'+hhTargets[3]+'</h5></div>'+
      '<div class="months"><h5>MAY</h5><h5>'+hhTargets[4]+'</h5></div>'+
      '<div class="months"><h5>JUN</h5><h5>'+hhTargets[5]+'</h5></div>'+
      '<div class="months"><h5>JUL</h5><h5>'+hhTargets[6]+'</h5></div>'+
      '<div class="months"><h5>AUG</h5><h5>'+hhTargets[7]+'</h5></div>'+
      '<div class="months"><h5>SEP</h5><h5>'+hhTargets[8]+'</h5></div>'+
      '<div class="months"><h5>OCT</h5><h5>'+hhTargets[9]+'</h5></div>'+
      '<div class="months"><h5>NOV</h5><h5>'+hhTargets[10]+'</h5></div>'+
      '<div class="months"><h5>DEC</h5><h5>'+hhTargets[11]+'</h5></div>'+
      '</div>'+
      '</div>';
    }
    if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HP')){
      html += '<div style="margin-top:13px;" class="container">'+
      '<div class="row">'+
      '<div class="col"><div><h2><b>'+ta.Date__c.year()+' HP Targets</b></h2></div></div>'+
      '</div>'+
      '<div>'+
      '<div class="months"><h5>JAN</h5><h5>'+hpTargets[0]+'</h5></div>'+
      '<div class="months"><h5>FEB</h5><h5>'+hpTargets[1]+'</h5></div>'+
      '<div class="months"><h5>MAR</h5><h5>'+hpTargets[2]+'</h5></div>'+
      '<div class="months"><h5>APR</h5><h5>'+hpTargets[3]+'</h5></div>'+
      '<div class="months"><h5>MAY</h5><h5>'+hpTargets[4]+'</h5></div>'+
      '<div class="months"><h5>JUN</h5><h5>'+hpTargets[5]+'</h5></div>'+
      '<div class="months"><h5>JUL</h5><h5>'+hpTargets[6]+'</h5></div>'+
      '<div class="months"><h5>AUG</h5><h5>'+hpTargets[7]+'</h5></div>'+
      '<div class="months"><h5>SEP</h5><h5>'+hpTargets[8]+'</h5></div>'+
      '<div class="months"><h5>OCT</h5><h5>'+hpTargets[9]+'</h5></div>'+
      '<div class="months"><h5>NOV</h5><h5>'+hpTargets[10]+'</h5></div>'+
      '<div class="months"><h5>DEC</h5><h5>'+hpTargets[11]+'</h5></div>'+
      '</div>'+
      '</div>';
    }
      if(ta.SA_Agreement_By__r.Line_of_Business__c!=null && ta.SA_Agreement_By__r.Line_of_Business__c.contains('HUM')){
      html += '<div style="margin-bottom:13px;" class="container">'+
      '<div>'+
      '<div><div><h2><b>'+ta.Date__c.year()+' Humana Targets</b></h2></div></div>'+
      '</div>'+
      '<div>'+
      '<div class="months"><h5>JAN</h5><h5>'+hhTargets[0]+'</h5></div>'+
      '<div class="months"><h5>FEB</h5><h5>'+hhTargets[1]+'</h5></div>'+
      '<div class="months"><h5>MAR</h5><h5>'+hhTargets[2]+'</h5></div>'+
      '<div class="months"><h5>APR</h5><h5>'+hhTargets[3]+'</h5></div>'+
      '<div class="months"><h5>MAY</h5><h5>'+hhTargets[4]+'</h5></div>'+
      '<div class="months"><h5>JUN</h5><h5>'+hhTargets[5]+'</h5></div>'+
      '<div class="months"><h5>JUL</h5><h5>'+hhTargets[6]+'</h5></div>'+
      '<div class="months"><h5>AUG</h5><h5>'+hhTargets[7]+'</h5></div>'+
      '<div class="months"><h5>SEP</h5><h5>'+hhTargets[8]+'</h5></div>'+
      '<div class="months"><h5>OCT</h5><h5>'+hhTargets[9]+'</h5></div>'+
      '<div class="months"><h5>NOV</h5><h5>'+hhTargets[10]+'</h5></div>'+
      '<div class="months"><h5>DEC</h5><h5>'+hhTargets[11]+'</h5></div>'+
      '</div>'+
      '</div>';
    }
    html += '</div>';
    return html;
  }

  @RemoteAction global static String getUsers(){
    String html = '';
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    for(User u : [select Id, ManagerId, FirstName, LastName, Perner__c from User where UserRoleId in :allSubRoleIds and isActive = true]){
      String perner = '';
      if(u.Perner__c!=null) perner = ' ('+String.valueOf(u.Perner__c)+')';
      html += '<li data-id="'+u.Id+'" data-mId="'+u.ManagerId+'" data-name="'+u.FirstName+' '+u.LastName+'"><span>'+u.FirstName+' '+u.LastName+perner+'</span></li>\n';
    }
    return html;
  }

  global static String getUsersData_ManagerList(Id userId){
    String html = '';
    User usr = [select ManagerId from User where Id =: userId];
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    for(User u : [select Id, FirstName, LastName, Perner__c from User where UserRoleId in :allSubRoleIds and isActive = true order by FirstName]){
      String perner = '';
      if(u.Perner__c!=null) perner = ' ('+String.valueOf(u.Perner__c)+')';
      if(u.Id == usr.ManagerId) html += '<li class="list-group-item active" data-id="'+u.Id+'"><span>'+u.FirstName+' '+u.LastName+perner+'</span></li>';
      else html += '<li class="list-group-item" data-id="'+u.Id+'"><span>'+u.FirstName+' '+u.LastName+perner+'</span></li>';
    }
    return escapeJSON(html);
  }

  @RemoteAction global static String getUserData(Id userId, Integer year, String editTargetType){
    return '{"sp": "'+getUsersData_SP(userId, year, editTargetType)+'", "ta": "'+getUsersData_Target(userId, year)+
    '", "mList": "'+getUsersData_ManagerList(userId)+'", "u": "'+getUsersData_User(userId)+'", "comments": "'+getUsersData_Comments(userId, 'Target Agreement', year)+'"}';
  }

  @RemoteAction global static void updateManager(Id userId, Id managerId, Integer year){
    User u = [select Name, ManagerId, Manager.Name from user where Id = :userId];
    User toManager = [select Name from User where Id =: managerId];
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    List<Target_Agreement__c> tas = [select SA_Agreement_By__c, Manager_Agreement_By__c, Manager_Agreement_By__r.Name, Manager_Agreement_Date__c,
    SA_Agreed__c, Manager_Agreed__c from Target_Agreement__c
    where (SA_Agreement_By__r.UserRoleId in :allSubRoleIds and SA_Agreement_By__c =: userId) and Date__c >= :Date.newInstance(year,1,1)
    and Date__c <= :Date.newInstance(year,12,31) and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty() && !tas[0].Manager_Agreed__c){
      saveComment(userId, 'I changed '+u.Name+'\'s goal acknowledgement manager field from '+tas[0].Manager_Agreement_By__r.Name+' to '+toManager.Name+'.');
      tas[0].Manager_Agreement_By__c = managerId;
      update tas[0];
    }
    if(!Test.isRunningTest()) saveComment(userId, 'I changed '+u.Name+'\'s manager from '+u.Manager.Name+' to '+toManager.Name+'.');
    u.ManagerId = managerId;
    update u;
  }

  @RemoteAction global static void updateFormType(Id userId, Integer year, String formType){
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    List<Target_Agreement__c> tas = [select SA_Agreed__c, Manager_Agreed__c, Sales_KAH_Form_Type__c from Target_Agreement__c
    where (SA_Agreement_By__r.UserRoleId in :allSubRoleIds and SA_Agreement_By__c =: userId) and Date__c >= :Date.newInstance(year,1,1)
    and Date__c <= :Date.newInstance(year,12,31) and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty() && (!tas[0].Manager_Agreed__c || !tas[0].SA_Agreed__c)){
      String oldType = String.valueOf(tas[0].Sales_KAH_Form_Type__c);
      tas[0].Sales_KAH_Form_Type__c = formType;
      update tas[0];
      saveComment(userId, 'I changed the goal acknowledgement form type from '+oldType+' to '+formType+'.');
    }
  }

  @RemoteAction global static void retireAgreement(Id userId, Integer year){
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    List<Target_Agreement__c> tas = [select SA_Agreement_By__r.Name, Retired__c from Target_Agreement__c
    where (SA_Agreement_By__r.UserRoleId in :allSubRoleIds and SA_Agreement_By__c =: userId) and Date__c >= :Date.newInstance(year,1,1)
    and Date__c <= :Date.newInstance(year,12,31) and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty()){
      tas[0].Retired__c = true;
      update tas[0];
      saveComment(userId, 'I am retiring '+tas[0].SA_Agreement_By__r.Name+'\'s '+year+' agreement.');
    }
  }

  @RemoteAction global static Boolean saveComment(Id userId, String comment){
    Boolean success = false;
    if(userId!=null && comment!=null){
      insert new Alert_and_Comment__c(Comment_To__c=userId, Comment_By__c=usrId, Comment__c=escapeJSON(comment), Type__c='Target Agreement', Datetime__c=System.now());
      success = true;
    }
    return success;
  }

  @RemoteAction global static Boolean sendQuestion(Id taId, String question){
    Boolean success = false;
    List<Target_Agreement__c> tas = [select SA_Agreement_By__c, SA_Agreement_By__r.Name, Manager_Agreement_By__r.Name, Manager_Agreement_By__r.Email, Date__c from Target_Agreement__c where Id =: taId and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty()){
      List<String> toAddresses = new List<String>();
      toAddresses.add(salesIncentivesEmail);
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(toAddresses);
      mail.setReplyTo(UserInfo.getUserEmail());
      mail.setSenderDisplayName(UserInfo.getName());
      String body = '';
      mail.setSubject(UserInfo.getName()+' Has a Question Regarding '+tas[0].SA_Agreement_By__r.Name+'\'s '+tas[0].Date__c.year()+' Targets');
      body += '<br/>Hi Sales Incentives Team,<br/><br/>';
      body += UserInfo.getName()+' has sent the following question (below) from the Goal Acknowledgement form in Salesforce on'+System.now().format()+'.'+
      ' You can <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Sales_TargetAgreementEdit?id='+tas[0].SA_Agreement_By__c+'&year='+tas[0].Date__c.year()+
      '" style="text-decoration:underline; color: #007bff;"><b>click here</b></a> to open the Goal Acknowledgement Edit page'+
      ', or simply reply to this email to converse with '+UserInfo.getName()+'.<br/><br/>'+
      '<b>'+UserInfo.getName()+'\'s Question</b><br/>'+question;

      mail.setHtmlBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
      success = true;
    }
    return success;
  }

  @RemoteAction global static String saveTargets(Id userId, Integer year, List<String> hhTargets, List<String> hpTargets, String editTargetType, Boolean sendEmail){
    User u = [select Name, email, Manager.Email from User where Id =: userId];

    Map<String, Sales_Performance__c> sps = new Map<String,Sales_Performance__c>();
    for(Sales_Performance__c sp : [select Sales_Performance_Id__c, KAH_HH_Admit_Target__c, KAH_Hidden_HH_Admit_Target__c, KAH_HP_Admit_Target__c,
    KAH_Hidden_HP_Admit_Target__c, Month__c from Sales_Performance__c where
    Month__c >= :Date.newInstance(year,1,1) and Month__c <= :Date.newInstance(year,12,31) and ownerId =: userId order by Month__c]){
      sps.put(sp.Sales_Performance_Id__c, sp);
    }


    List<Sales_Performance__c> insertSps = new List<Sales_Performance__c>();
    if(!sps.isEmpty() && sps.size()!=12){
      for (Integer i=1; i<=12; i++){
        if(!sps.containsKey(spId(userId, i, year))) insertSps.add(new Sales_Performance__c(
        Sales_Performance_ID__c = spId(userId, i, year), Month__c = Date.newinstance(year, i, 1),   OwnerId = userId, RecordTypeId = kahSpRecordTypeId));
      }
    }

    if(!insertSps.isEmpty()){
      if(insertSps.size()>1) saveComment(userId, 'I have created '+insertSps.size()+' sales performances for '+u.Name+' in '+year+'.');
      else saveComment(userId, 'I have created one sales performance for '+u.Name+' in '+year+'.');
      insert insertSps;
      sps.clear();
      for(Sales_Performance__c sp : [select Sales_Performance_Id__c, KAH_HH_Admit_Target__c, KAH_Hidden_HH_Admit_Target__c, KAH_HP_Admit_Target__c,
      KAH_Hidden_HP_Admit_Target__c, Month__c from Sales_Performance__c where
      Month__c >= :Date.newInstance(year,1,1) and Month__c <= :Date.newInstance(year,12,31) and ownerId =: userId order by Month__c]){
        sps.put(sp.Sales_Performance_Id__c, sp);
      }
    }

    List<String> months = new List<String>{'<b>JAN</b>', '<b>FEB</b>', '<b>MAR</b>', '<b>APR</b>', '<b>MAY</b>', '<b>JUN</b>',
    '<b>JUL</b>', '<b>AUG</b>', '<b>SEP</b>', '<b>OCT</b>', '<b>NOV</b>', '<b>DEC</b>'};
    String comment = '';
    if(editTargetType=='actual') comment = 'I have updated '+u.Name+'\'s post-acknowledged targets in '+year+' from;</br>';
    else if(editTargetType=='hidden') comment = 'I have updated '+u.Name+'\'s pre-acknowledged targets in '+year+' from;</br>';
    for(Sales_Performance__c sp : sps.values()){
      Integer index = sp.Month__c.month()-1;
      comment = comment + months[index];
      if(editTargetType=='actual'){
        if(hhTargets[index]!=null && isNumeric(hhTargets[index])){
          comment = comment + ' HH: '+String.valueOf(sp.KAH_HH_Admit_Target__c)+' to '+hhTargets[index];
          sp.KAH_HH_Admit_Target__c = Decimal.valueOf(hhTargets[index]);
        } else{
          comment = comment + ' HH: '+String.valueOf(sp.KAH_HH_Admit_Target__c)+' to null';
          sp.KAH_HH_Admit_Target__c = null;
        }

        if(hpTargets[index]!=null && isNumeric(hpTargets[index])) {
          comment = comment + '<span style=\'margin-left:20px\'></span> HP: '+String.valueOf(sp.KAH_HP_Admit_Target__c)+' to '+hpTargets[index]+'</br>';
          sp.KAH_HP_Admit_Target__c = Decimal.valueOf(hpTargets[index]);
        }else{
          comment = comment + '<span style=\'margin-left:20px\'></span> HP: '+String.valueOf(sp.KAH_HP_Admit_Target__c)+' to null</br>';
          sp.KAH_HP_Admit_Target__c = null;
        }
      } else if(editTargetType=='hidden'){
        if(hhTargets[index]!=null && isNumeric(hhTargets[index])){
          comment = comment + ' HH: '+String.valueOf(sp.KAH_Hidden_HH_Admit_Target__c)+' to '+hhTargets[index];
          sp.KAH_Hidden_HH_Admit_Target__c = Decimal.valueOf(hhTargets[index]);
        }else{
          comment = comment + ' HH: '+String.valueOf(sp.KAH_Hidden_HH_Admit_Target__c)+' to null';
          sp.KAH_Hidden_HH_Admit_Target__c = null;
        }

        if(hpTargets[index]!=null && isNumeric(hpTargets[index])){
          comment = comment + '<span style=\'margin-left:20px\'></span> HP: '+String.valueOf(sp.KAH_Hidden_HP_Admit_Target__c)+' to '+hpTargets[index]+'</br>';
          sp.KAH_Hidden_HP_Admit_Target__c = Decimal.valueOf(hpTargets[index]);
        }else{
          comment = comment + '<span style=\'margin-left:20px\'></span> HP: '+String.valueOf(sp.KAH_Hidden_HP_Admit_Target__c)+' to null</br>';
          sp.KAH_Hidden_HP_Admit_Target__c = null;
        }
      }
    }
    if(editTargetType=='actual' && sendEmail){
      List<String> toAddresses = new List<String>();
      toAddresses.add(u.Email);
      List<String> ccAddresses = new List<String>();
      if(u.Manager.Email!=null) ccAddresses.add(u.Manager.Email);
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(toAddresses);
      mail.setCcAddresses(ccAddresses);
      mail.setReplyTo(salesIncentivesEmail);
      mail.setSenderDisplayName('Sales Incentives Team');
      String body = '';
      mail.setSubject('Your '+year+' Targets Have Been Updated');
      body += '<br/>Hi '+u.Name+',<br/><br/>';
      body += 'Your targets for the '+year+' calendar year have been updated. You can review these changes to your targets in the Sales Performance Dashboard in Salesforce. '+
      'It is important to note that the original Goal Acknowledgement form has not changed and no action is currently required for this target modification. '+
      'Please contact your manager if you have any questions, or concerns, about the target changes that have been made.<br/><br/>'+
      'Thanks,<br/>Your Sales Incentives Team';
      mail.setHtmlBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    saveComment(userId, comment);
    update sps.values();
    return '{"sp": "'+getUsersData_SP(userId, year, editTargetType)+'"}';
  }

  private static String spId(Id userId, Integer month, Integer year){
    String mmyyyy = String.valueOf(month)+String.valueOf(year);
    if(month < 10) mmyyyy = '0'+String.valueOf(month)+String.valueOf(year);
    return userId + mmyyyy;
  }

  private static Boolean isNumeric(String s){
    Boolean bool;
    try{
      Decimal.valueOf(s);
      bool = true;
    } catch (Exception e) {
      bool = false;
    }
    return bool;
  }

  @RemoteAction global static Boolean createSP(Id userId, Integer year){
    Boolean inserted = false;
    User u = [select Name from User where Id =: userId];
    List<Sales_Performance__c> sps = [select Id from Sales_Performance__c where OwnerId =: userId and Month__c >= :Date.newInstance(year,1,1) and Month__c <= :Date.newInstance(year,12,31)];
    if(sps.isEmpty()){
      for(Integer i=1; i<=12; i++){
        String spId = userId+String.valueOf(i)+String.valueOf(year);
        if(i<10) spId = userId+'0'+String.valueOf(i)+String.valueOf(year);
        sps.add(new Sales_Performance__c(OwnerId=userId, Month__c=Date.newInstance(year, i, 1), Sales_Performance_ID__c=spId, RecordTypeId=kahSpRecordTypeId));
      }
      insert sps;
      if(sps.size()>1) saveComment(userId, 'I have created '+sps.size()+' sales performances for '+u.Name+' in '+year+'.');
      else saveComment(userId, 'I have created one sales performance for '+u.Name+' in '+year+'.');
      inserted = true;
    }
    return inserted;
  }

  @RemoteAction global static Boolean createAgreement(Id userId, Id managerId, Integer year, Boolean sendEmail){
    Boolean inserted = false;
    User u = [select Name from User where Id =: userId and isActive=true];
    List<Target_Agreement__c> tas = [select Id from Target_Agreement__c where SA_Agreement_By__c =: userId and Date__c >= :Date.newInstance(year,1,1) and Date__c <= :Date.newInstance(year,12,31) and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(tas.isEmpty()){
      Target_Agreement__c ta = new Target_Agreement__c(SA_Agreement_By__c=userId, Manager_Agreement_By__c=managerId, Date__c=Date.newInstance(year, 1, 1));
      insert ta;
      if(sendEmail) emailManager(ta.Id);
      saveComment(userId, 'I have created a goal acknowledgement for '+u.Name+' in '+year+'.');
      inserted = true;
    }
    return inserted;
  }

  @RemoteAction global static void emailManager(Id taId){
    List<Target_Agreement__c> tas = [select Email_Sent__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Email, Manager_Agreement_By__r.Name,
    SA_Agreed__c, Manager_Agreed__c, Manager_Agreement_By__r.Email, Date__c from Target_Agreement__c where Id =: taId and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(!tas.isEmpty()){
      List<String> toAddresses = new List<String>();
      toAddresses.add(tas[0].Manager_Agreement_By__r.Email);
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(toAddresses);
      mail.setReplyTo(salesIncentivesEmail);
      mail.setSenderDisplayName('Sales Incentives Team');
      String body = '';
      mail.setSubject('A New Goal Acknowledgement Needs Your Review');
      body += '<br/>Hi '+tas[0].Manager_Agreement_By__r.Name+',<br/><br/>';
      body += 'The Sales Incentives Team has generated a goal acknowledgement form for '+tas[0].SA_Agreement_By__r.Name+'. This form contains '+tas[0].Date__c.year()+' targets that you will need to need acknowledge. '+
      'After your acknowledgement, '+tas[0].SA_Agreement_By__r.Name+' will recieve an email with a link to their acknowledgement form.<br/><br/>'+
      'Please use the link below to open up the form.<br/><br/>'+
      '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Sales_TargetAgreement?id='+taId+'" style="text-decoration:none;font-size:20px; color:white; background-color: #007bff; border-radius:25px; padding: 5px 15px 5px 15px;"><b>Go To Goal Acknowledgement Form</b></a><br/><br/>'+
      'Thanks,<br/>Your Sales Incentives Team';
      mail.setHtmlBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
      tas[0].Email_Sent__c = true;
      update tas[0];
    }
  }

  private static String getUsersData_Target(Id userId, Integer year){
    String html = '';
    Set<Id> allSubRoleIds = getSubRoleIds(new Set<ID>{UserInfo.getUserRoleId()});
    List<Target_Agreement__c> tas = [select Email_Sent__c, SA_Agreement_By__c, SA_Agreement_By__r.Name, SA_Agreement_By__r.Line_of_Business__c,
    SA_Agreement_Date__c, SA_Agreement_By__r.UserRoleId, SA_Agreement_By__r.Title, Manager_Agreement_By__c, Sales_KAH_Form_Type__c,
    Manager_Agreement_By__r.Name, Manager_Agreement_Date__c, SA_Agreed__c, Manager_Agreed__c, SA_Agreement_By__r.FirstName, SA_Agreement_By__r.LastName,
    SA_Agreement_By__r.Region__c, SA_Agreement_By__r.Area__c, SA_Agreement_By__r.Market__c, Date__c from Target_Agreement__c
    where (SA_Agreement_By__r.UserRoleId in :allSubRoleIds and SA_Agreement_By__c =: userId) and Date__c >= :Date.newInstance(year,1,1)
    and Date__c <= :Date.newInstance(year,12,31) and Retired__c=false and SA_Agreement_By__r.isActive=true];
    if(tas.isEmpty()) html = '<div class="alert alert-danger"><h4 class="alert-heading"><i class="fa fa-thumbs-down" aria-hidden="true"></i> No Goal Acknowledgements Found.</h4>'+
    '<p>There is no goal acknowledgement available for this user in '+year+'. <a style="text-decoration:underline; cursor:pointer;" onclick="$(\'#newAgreementEmail\').prop(\'checked\', true); $(\'#agreementModal\').modal(\'show\');">Click here</a> if you\'d like to create one, or <a href="mailto:salessupport@kindred.com?Subject=No%20Target%20Agreement">contact sales support</a> for further assistance.</p></div>';
    for(Target_Agreement__c ta : tas) {
      String lob = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Line_of_Business__c!=null) lob = String.valueOf(ta.SA_Agreement_By__r.Line_of_Business__c);

      String region = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Region__c!=null) region = String.valueOf(ta.SA_Agreement_By__r.Region__c);

      String area = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Area__c!=null) area = String.valueOf(ta.SA_Agreement_By__r.Area__c);

      String market = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_By__r.Market__c!=null) market = String.valueOf(ta.SA_Agreement_By__r.Market__c);

      String editFormType = ' <a onclick="$(\'#formTypeModal\').modal(\'show\');" style="color: #007bff; text-decoration:underline; cursor:pointer;"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>';
      if(ta.Manager_Agreement_Date__c!=null && ta.SA_Agreement_Date__c!=null)
      editFormType = '';

      String formType = '<span class="lnr lnr-cross"></span>'+editFormType;
      if(ta.Sales_KAH_Form_Type__c!=null)
      formType = String.valueOf(ta.Sales_KAH_Form_Type__c) + editFormType;

      String saDate = '<span class="lnr lnr-cross"></span>';
      if(ta.SA_Agreement_Date__c!=null) saDate = String.valueOf(ta.SA_Agreement_Date__c.format());

      String mgrDate = '<span class="lnr lnr-cross"></span>';
      Boolean managerAgreed = false;
      if(ta.Manager_Agreement_Date__c!=null){
        mgrDate = String.valueOf(ta.Manager_Agreement_Date__c.format());
        managerAgreed = true;
      }

      String manager = '<span class="lnr lnr-cross"></span>';
      if(ta.Manager_Agreement_By__r.Name!=null) manager = String.valueOf(ta.Manager_Agreement_By__r.Name);



      String color = 'red';
      String titleText = '<i class="fa fa-times-circle"></i> No One Has Agreed';
      String saText = ta.SA_Agreement_By__r.Name+' has not agreed.';
      String managerText = manager+' has not agreed.';
      String retire = '';
      String sendEmail = '';
      if(!ta.Email_Sent__c && ta.Manager_Agreement_Date__c==null) sendEmail = '<div style="margin-top:15px;" class="btns btn-primary" onclick="emailManager(\''+ta.Id+'\');">Send Email <i class="fa fa-envelope-o" aria-hidden="true"></i></div>';
      if(ta.SA_Agreement_Date__c!=null && ta.Manager_Agreement_Date__c!=null){
        color = 'green';
        titleText = '<i class="fa fa-check-circle"></i> All Have Agreed';
        saText = ta.SA_Agreement_By__r.Name+' agreed on '+ta.SA_Agreement_Date__c.format()+'.';
        managerText = manager+' agreed on '+ta.Manager_Agreement_Date__c.format()+'.';

      }
      else if(ta.SA_Agreement_Date__c==null && ta.Manager_Agreement_Date__c!=null){
        color = 'yellow';
        titleText = '<i class="fa fa-minus-circle"></i> Manager Has Agreed';
        managerText = manager+' agreed on '+ta.Manager_Agreement_Date__c.format()+'.';
      }
      retire = '<div class="btns btn-danger red-btn" onclick="$(\'#retireModal\').modal(\'show\');">Retire <i class="fa fa-ban" aria-hidden="true"></i></div>';
      html += '<div class="card">'+
      '<div style="padding: 23px 0px 23px 0px;text-align: center; color:white;" class="card-header '+color+'">'+
      '<h4 style="font-size: 40px; margin-bottom:30px;" class="card-title">'+titleText+'</h4>'+
      '</div>'+
      '<div class="card-body">'+
      '<p class="card-text"><div class="row"><div class="col"><b>Sales Associate</b><br/>'+saText+'</div><div class="col"><b>Manager</b><br/>'+managerText+'</div></div>'+
      '<div class="row"><div class="col"><b>Form Type</b><br/>'+formType+'</div></div>'+'</p>'+retire+sendEmail+
      '</div>'+
      '</div>';
    }
    return escapeJSON(html);
  }

  private static String getUsersData_SP(Id userId, Integer year, String editTargetType){
    String html = '<div class="alert alert-danger"><h4 class="alert-heading"><i class="fa fa-thumbs-down" aria-hidden="true"></i> No Sales Performance Found.</h4>'+
    '<p>There are no sales performances available for this user in '+year+'. <a style="text-decoration:underline; cursor:pointer;" onclick="$(\'#spModal\').modal(\'show\');">Click here</a> if you\'d like to create some, or <a href="mailto:salessupport@kindred.com?Subject=No%20Sales%20Performance">contact sales support</a> for further assistance.</p></div>';

    List<String> hhTargets = new List<String> {'', '', '',
    '', '', '', '', '', '', '', '', ''};

    List<String> hpTargets = new List<String> {'', '', '',
    '', '', '', '', '', '', '', '', ''};


    List<Sales_Performance__c> sps = [select KAH_HH_Admit_Target__c, KAH_Hidden_HH_Admit_Target__c, KAH_HP_Admit_Target__c,
    KAH_Hidden_HP_Admit_Target__c, Month__c from Sales_Performance__c where
    Month__c >= :Date.newInstance(year,1,1) and Month__c <= :Date.newInstance(year,12,31) and ownerId =: userId];

    if(editTargetType==''){
      editTargetType='hidden';
      List<Target_Agreement__c> tas = [select Manager_Agreed__c from Target_Agreement__c
      where SA_Agreement_By__c =: userId and Date__c >= :Date.newInstance(year,1,1)
      and Date__c <= :Date.newInstance(year,12,31) and Retired__c=false and SA_Agreement_By__r.isActive=true];
      if(!tas.isEmpty() && tas[0].Manager_Agreed__c) editTargetType='actual';
    }

    if(!sps.isEmpty()){
      if(editTargetType=='actual'){
        html = '<div id="targetToggle" data-defaultTargets="actual" class="btns btn-primary dropdown" style="width:400px; margin-bottom:20px;">Post-Acknowledged / Actual Targets</div>';
        html += '<div style="margin:0px;" class="btn-holder"><ul style="width:400px;" class="dropdown-list" id="targetToggleList">'+
        '<li class="selected" data-defaultTargets="actual">Post-Acknowledged / Actual Targets</li>'+
        '<li data-defaultTargets="hidden">Pre-Acknowledged / Hidden Targets</li>'+
        '</ul></div>';
      } else if(editTargetType=='hidden'){
        html = '<div id="targetToggle" data-defaultTargets="hidden" class="btns btn-primary dropdown" style="width:400px; margin-bottom:20px;">Pre-Acknowledged / Hidden Targets</div>';
        html += '<div style="margin:0px;" class="btn-holder"><ul style="width:400px;" class="dropdown-list" id="targetToggleList">'+
        '<li data-defaultTargets="actual">Post-Acknowledged / Actual Targets</li>'+
        '<li class="selected" data-defaultTargets="hidden">Pre-Acknowledged / Hidden Targets</li>'+
        '</ul></div>';
      }
      html += '<table class="table table-bordered">';
    }

    for(Sales_Performance__c sp : sps){
      Integer index = sp.Month__c.month()-1;
      if(editTargetType=='actual'){
        if(sp.KAH_HH_Admit_Target__c!=null){
          hhTargets.set(index, String.valueOf(sp.KAH_HH_Admit_Target__c));
        }
        if(sp.KAH_HP_Admit_Target__c!=null){
          hpTargets.set(index, String.valueOf(sp.KAH_HP_Admit_Target__c));
        }
      } else if(editTargetType=='hidden'){
        if(sp.KAH_Hidden_HH_Admit_Target__c!=null){
          hhTargets.set(index, String.valueOf(sp.KAH_Hidden_HH_Admit_Target__c));
        }
        if(sp.KAH_Hidden_HP_Admit_Target__c!=null){
          hpTargets.set(index, String.valueOf(sp.KAH_Hidden_HP_Admit_Target__c));
        }
      }
    }

    if(!sps.isEmpty()){
      html += '<thead class="blue">'+
      '<tr>'+
      '<th>TARGETS</th><th>JAN</th><th>FEB</th><th>MAR</th><th>APR</th><th>MAY</th><th>JUN</th>'+
      '<th>JUL</th><th>AUG</th><th>SEP</th><th>OCT</th><th>NOV</th><th>DEC</th>'+
      '</tr>'+
      '</thead>'+
      '<tbody>'+
      '<tr id="hhValues">'+
      '<th>Home Health</th>'+
      '<th class="edited"><input value="'+hhTargets[0]+'"/></th><th class="edited"><input value="'+hhTargets[1]+'"/></th><th class="edited"><input value="'+hhTargets[2]+'"/></th><th class="edited"><input value="'+hhTargets[3]+'"/></th><th class="edited"><input value="'+hhTargets[4]+'"/></th><th class="edited"><input value="'+hhTargets[5]+'"/></th>'+
      '<th class="edited"><input value="'+hhTargets[6]+'"/></th><th class="edited"><input value="'+hhTargets[7]+'"/></th><th class="edited"><input value="'+hhTargets[8]+'"/></th><th class="edited"><input value="'+hhTargets[9]+'"/></th><th class="edited"><input value="'+hhTargets[10]+'"/></th><th class="edited"><input value="'+hhTargets[11]+'"/></th>'+
      '</tr>'+
      '<tr id="hpValues">'+
      '<th>Hospice</th>'+
      '<th class="edited"><input value="'+hpTargets[0]+'"/></th><th class="edited"><input value="'+hpTargets[1]+'"/></th><th class="edited"><input value="'+hpTargets[2]+'"/></th><th class="edited"><input value="'+hpTargets[3]+'"/></th><th class="edited"><input value="'+hpTargets[4]+'"/></th><th class="edited"><input value="'+hpTargets[5]+'"/></th>'+
      '<th class="edited"><input value="'+hpTargets[6]+'"/></th><th class="edited"><input value="'+hpTargets[7]+'"/></th><th class="edited"><input value="'+hpTargets[8]+'"/></th><th class="edited"><input value="'+hpTargets[9]+'"/></th><th class="edited"><input value="'+hpTargets[10]+'"/></th><th class="edited"><input value="'+hpTargets[11]+'"/></th>'+
      '</tr>'+
      '</tbody>'+
      '</table>';
    }
    return escapeJSON(html);
  }

  private static String getUsersData_User(Id userId){
    String html = '';
    User u = [select Name, Region__c, Perner__c, Area__c, Market__c, ManagerId, Manager.Name, Title, Line_of_Business__c, SmallPhotoUrl from User where Id = :userId];
    String lob = '<span class="lnr lnr-cross"></span>';
    if(u.Line_of_Business__c!=null) lob = String.valueOf(u.Line_of_Business__c);

    String manager = '<span class="lnr lnr-cross"></span>';
    Id managerId = null;
    if(u.Manager.Name!=null){
      manager = String.valueOf(u.Manager.Name);
      managerId = u.ManagerId;
    }

    String perner = '<span class="lnr lnr-cross"></span>';
    if(u.Perner__c!=null) perner = String.valueOf(u.Perner__c);

    String region = '<span class="lnr lnr-cross"></span>';
    if(u.Region__c!=null) region = String.valueOf(u.Region__c);

    String area = '<span class="lnr lnr-cross"></span>';
    if(u.Area__c!=null) area = String.valueOf(u.Area__c);

    String market = '<span class="lnr lnr-cross"></span>';
    if(u.Market__c!=null) market = String.valueOf(u.Market__c);

    html += '<div class="card">'+
    '<div class="card-header"><img style="width: 55px;" class="rounded-circle" src="'+u.SmallPhotoUrl+'"/>'+
    '<div style="display: inline-block;"><h4 style="font-size: 40px; padding-left: 20px;" class="card-title">'+u.Name+'</h4></div>'+
    '<div style="margin-top: -20px;"><h5 style="margin-left: 55px; padding-left: 20px;" class="card-title">'+u.Title+'</h5></div></div>'+
    '<div class="card-body">'+
    '<p class="card-text"><div class="row"><div class="col"><b>Region</b><br/>'+region+'</div><div class="col"><b>Area</b><br/>'+area+'</div><div class="col"><b>Market</b><br/>'+market+'</div></div></p>'+
    '<p class="card-text"><div class="row"><div class="col"><b>Perner</b><br/>'+perner+'</div><div id="managerField" class="col" data-id="'+managerId+'"><b>Manager</b><br/>'+manager+' <a onclick="$(\'#managerModal\').modal(\'show\');" style="color: #007bff; text-decoration:underline; cursor:pointer;"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a></div></div></p>'+
    '<div class="btns btn-primary" data-toggle="modal" data-target="#commentModal">Comment <i class="fa fa-commenting" aria-hidden="true"></i></div>'+
    '</div>'+
    '</div>';

    return escapeJSON(html);
  }



  public static String getUsersData_Comments(Id userId, String type, Integer year){
    String html = '<div class="alert alert-danger"><h4 class="alert-heading"><i class="fa fa-thumbs-down" aria-hidden="true"></i> Comments Have Not Yet Been Made.</h4>'+
    '<p>Feel free to comment by <a style="text-decoration:underline; cursor:pointer;" onclick="$(\'#commentModal\').modal(\'show\');">clicking here</a>.</p></div>';

    List<Alert_and_Comment__c> acs = [select Comment_By__r.Name, Comment_By__r.SmallPhotoUrl, Comment_To__r.Name, Datetime__c, Comment__c from Alert_and_Comment__c where
    Datetime__c >= :Date.newInstance(year,1,1) and Datetime__c <= :Date.newInstance(year,12,31) and Comment_To__c =: userId order by Datetime__c desc];
    Integer i = 1;
    if(!acs.isEmpty()) html = '';
    for(Alert_and_Comment__c ac : acs){
      html += '<div class="col-md-11 offset-md-1">'+
      '<p style="margin:0px;"><b>'+ac.Comment_By__r.Name+'</b> on '+ac.Datetime__c.format()+'</p>'+
      '<div class="comment">'+
      '<p>'+ac.Comment__c+'</p>'+
      '<div style="height:0px; position:relative; left:-90px; top:-42px; z-index:4;"><img style="width: 55px;" class="rounded-circle" src="'+ac.Comment_By__r.SmallPhotoUrl+'"/></div>'+
      '</div>'+
      '</div>';
      i++;
    }
    return escapeJSON(html);
  }

  private static String escapeJSON(String json){
    if(json!=null){
      json = json.replace('\\', '/');
      json = json.replace('\r\n', ' ');
      json = json.replace('\r', ' ');
      json = json.replace('\n', ' ');
      json = json.replace('"', '\\"');
    }
    return json;
  }

}