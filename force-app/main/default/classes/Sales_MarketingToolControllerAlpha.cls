global class Sales_MarketingToolControllerAlpha {

  @RemoteAction global static String getMarkets(){
    String html='';
    Schema.DescribeFieldResult fieldResult = ContentVersion.Sales_Market__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry f : ple){
      html+='<li class="listItems" style="padding:7px 15px 7px 15px;" onclick="market=\''+f.getValue()+'\'; showSearch();">'+f.getValue()+'</li>\n';
    }
    return html;
  }

  @RemoteAction global static String getSpecPrograms(){
  	
  	list<Profile> pList = New list<Profile>();
  	pList = [SELECT ID, Name From Profile WHERE (Name = 'System Administrator' OR Name = 'Marketing Support' OR Name = 'Sales: KAH Manager')];
  	list<ID> profileIDs = new list <ID>();
  	for(Profile p: pList){
  		profileIDs.add(p.ID);
  		}
  	
    String html='';
    List<Home_Facility__c> hf = [select Account__c from Home_Facility__c where User__c =: UserInfo.getUserId()];
    List<Sales_Specialty_Program_Access__c> sp = new List<Sales_Specialty_Program_Access__c>();
    if(!hf.isEmpty()){
      sp = [select Speciality_Programs__c from Sales_Specialty_Program_Access__c where Home_Facility__c =: hf[0].Account__c];
    }
    for(Program__c program : [select name from Program__c where name!='Wound Care' and name!='Stroke Recovery' and name!='Pulmonary' and name!='Cardiac' and name!='Bereavement']){
      if((!sp.isEmpty() && sp[0].Speciality_Programs__c!=null && sp[0].Speciality_Programs__c.contains(program.name)) || (sp.isEmpty() && profileIDs.contains(UserInfo.getProfileId())) ||
      (sp.isEmpty() && profileIDs.contains(UserInfo.getProfileId()) || (sp.isEmpty() && profileIDs.contains(UserInfo.getProfileId())))){
        html+='<div id="btn-'+String.valueOf(program.name).toLowerCase().replaceAll(' ', '-')+'" class="btn-outline" onclick="navSpec(\'btn-'+String.valueOf(program.name).toLowerCase().replaceAll(' ', '-')+'\')">'+program.name+'</div>\n';
      }
    }
    return html;
  }

  @RemoteAction global static String getCollateral(String lob, String cspec, String spec, String refcus, String market){
    Map<String, String> fileType = new Map<String, String>();
    fileType.put('WORD', '<i class="fa fa-file-word-o" aria-hidden="true"></i>');
    fileType.put('WORD_X', '<i class="fa fa-file-word-o" aria-hidden="true"></i>');
    fileType.put('EXCEL', '<i class="fa fa-file-excel-o" aria-hidden="true"></i>');
    fileType.put('EXCEL_M', '<i class="fa fa-file-excel-o" aria-hidden="true"></i>');
    fileType.put('EXCEL_X', '<i class="fa fa-file-excel-o" aria-hidden="true"></i>');
    fileType.put('CSV', '<i class="fa fa-file-excel-o" aria-hidden="true"></i>');
    fileType.put('JPEG', '<i class="fa fa-file-image-o" aria-hidden="true"></i>');
    fileType.put('JPG', '<i class="fa fa-file-image-o" aria-hidden="true"></i>');
    fileType.put('TIFF', '<i class="fa fa-file-image-o" aria-hidden="true"></i>');
    fileType.put('PNG', '<i class="fa fa-file-image-o" aria-hidden="true"></i>');
    fileType.put('MOV', '<i class="fa fa-file-video-o" aria-hidden="true"></i>');
    fileType.put('M4V', '<i class="fa fa-file-video-o" aria-hidden="true"></i>');
    fileType.put('MP4', '<i class="fa fa-file-video-o" aria-hidden="true"></i>');
    fileType.put('POWER_POINT', '<i class="fa fa-file-powerpoint-o" aria-hidden="true"></i>');
    fileType.put('POWER_POINT_X', '<i class="fa fa-file-powerpoint-o" aria-hidden="true"></i>');
    fileType.put('PDF', '<i class="fa fa-file-pdf-o" aria-hidden="true"></i>');
    fileType.put('unknownFileType', '<i class="fa fa-file-o" aria-hidden="true"></i>');

    String html='';

    if(lob=='Home Health') lob='HH';
    else if(lob=='Hospice') lob='HP';
    else if(lob=='Hospital') lob='TCH';

    if(refcus=='Referral Source') refcus='Professional';
    else if(refcus=='Customer') refcus='Patient';

    if(cspec=='Core Collateral'){
      if(refcus=='Bereavement'){
        for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Collateral (Salesforce)') and Program__r.name='Bereavement' and isLatest=true order by Title asc]){
          html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
        }
      } else if(refcus=='Volunteer'){
        for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Collateral (Salesforce)') and Program__r.name='Volunteer' and isLatest=true order by Title asc]){
          html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
        }
      } else if(refcus=='We Honor Veterans'){
        for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Collateral (Salesforce)') and Program__r.name='We Honor Veterans' and isLatest=true order by Title asc]){
          html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
        }
      } else if(refcus=='Kindred Networks' && market!=null){
        for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Collateral (Salesforce)') and Sales_Market__c=:market and isLatest=true order by Title asc]){
          html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
        }
      } else {
        if(lob=='HH' && refcus=='Professional'){
          for(ContentVersion cv : [select Id, Title, FileType, Sales_KAH_Disease_Specific__c from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Collateral (Salesforce)') and Audience_Tag__c includes (:refcus) and isLatest=true order by Title asc]){
            if(cv.Sales_KAH_Disease_Specific__c) html+='<li class="listItems isDiseaseSpecific" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
            else html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
          }
        } else{
          for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Collateral (Salesforce)') and Audience_Tag__c includes (:refcus) and isLatest=true order by Title asc]){
            html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
          }
        }
      }
    } else if(cspec=='Specialty Programs'){
      if(refcus=='Kindred Networks'){
        for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Specialty') and Sales_Market__c=:market and Program__r.name=:spec and isLatest=true order by Title asc]){
          html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
        }
      } else {
        for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Specialty') and Audience_Tag__c includes (:refcus) and Program__r.name=:spec and isLatest=true order by Title asc]){
          html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
        }
      }
    } else if(cspec=='Success Story Videos'){
      for(ContentVersion cv : [select Id, Title, FileType from ContentVersion where LOB__c includes (:lob) and Category_Tags__c includes ('Success Story Videos') and isLatest=true order by Title asc]){
        html+='<li class="listItems" onclick="navTo(\''+String.valueOf(cv.Id)+'\')" style="padding:7px 15px 7px 15px;">' + fileType.get(String.valueOf(cv.FileType)) + '<span> ' + String.valueOf(cv.Title) + '</span></li>';
      }
    }
    if(html=='') html= '<li style="text-align:center;"><div class="lnr lnr-cross inline"></div> No collateral found</li>';
    return html;
  }
}