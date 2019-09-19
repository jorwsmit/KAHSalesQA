public class iPathMobileEmailTemplate_Controller{

    public User userObj { get; private set; }
    public Account center { get; private set; }
    public String firstName { get; private set; }
    public String emailContent { get; private set; }
    public Map<String, String> collateralsMap { get; private set; }
    private List<Weblink__c> globalWeblinks;
    
    public iPathMobileEmailTemplate_Controller() {
         // Setup current user information
         userObj = [Select u.Name, u.Title, u.MobilePhone, u.Phone From User u where u.id = :UserInfo.getUserId()];

         // Setup center
         String centerId = ApexPages.currentPage().getParameters().get('centerId');

         if (String.isNotBlank(centerId)) {
            List<Account> centers = [Select Facility_Number__c, Website, QL_ScheduleTour__c, QL_ContactUs__c from Account where Id=:centerId];
            
            if(!centers.isEmpty()) {
                center = centers[0];
            }
         }

         // Setup firstName
         firstName = ApexPages.currentPage().getParameters().get('firstName');

         if(firstName == null) {
            firstName = '';
         }
         
         // Setup emailContent
         emailContent = ApexPages.currentPage().getParameters().get('emailContent');

         if(emailContent == null) {
            emailContent = '';
         }

         // Setup collaterals
         String collateralsJSON = ApexPages.currentPage().getParameters().get('collateralsJSON');
         
         if (String.isNotBlank(collateralsJSON)) {
            collateralsMap = (Map<String,String>)JSON.deserializeStrict(collateralsJSON, Map<String,String>.class);
         }
         
         // Setup generic (non facility-specific) links
         globalWebLinks = [SELECT Label__c, URL__c FROM Weblink__c WHERE Global__c=true];
    }

    public String getemail_bar_general() {
        return getImageURL('email_bar_general.png', 'Email_Template_Images');
    }

    public String getlogo_kindred() {
        return getImageURL('logo_kindred.png', 'Email_Template_Images');
    }

    public String getcenter_logo() {
        //replaceFirst trims one or more leading zeros, similar logic exists within the iPath app at - (NSString*)getDocumentFilename 
        return getImageURL(center.Facility_Number__c.replaceFirst('^0+','') + '.jpg','Center_Logos');
    }

    public String geticn_twitter() {
        return getImageURL('icn_twitter.png', 'Email_Template_Images');
    }

    public String geticn_facebook() {
        return getImageURL('icn_facebook.png', 'Email_Template_Images');
    }

    public String geticn_youtube() {
        return getImageURL('icn_youtube.png', 'Email_Template_Images');
    }

    public String geticn_linkedin() {
        return getImageURL('icn_linkedin.png', 'Email_Template_Images');
    }
    
    public String getctc_email() {
        return getImageURL('ctc_email.png', 'Email_Template_Images');
    }           

    private String getImageURL(String docName, String folderName) {
        if(String.isBlank(docName) || String.isBlank(folderName)) {
            return null;
        }
        else {
            List<Document> docs = [Select d.Id, d.FolderId From Document d WHERE d.Folder.DeveloperName = :folderName AND d.Name = :docName LIMIT 1];
                      
            if(docs == null || docs.size() == 0) {
                return null;
            }
            else {
                return 'https://' + system.URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id=' + docs[0].Id + '&oid=' + UserInfo.getOrganizationId();
            }
        }
    }
    
    public String getfindKindredLocationsWeblink() {
        return getWeblinkMatchingLabel('Kindred Location Finder');
    }
    
    public String getsuccessStoriesWeblink() {
        return getWeblinkMatchingLabel('Videos and Success Stories');
    }
    
    public String gettwitterWeblink() {
        return getWeblinkMatchingLabel('Kindred @ Twitter');
    }
    
    public String getfacebookWeblink() {
        return getWeblinkMatchingLabel('Kindred @ Facebook');
    }
    
    public String getyoutubeWeblink() {
        return getWeblinkMatchingLabel('Kindred @ Youtube');
    }
    
    public String getlinkedinWeblink() {
        return getWeblinkMatchingLabel('Kindred @ Linkedin');
    }
     
    public String getcontinueTheCareWeblink() {
        return getWeblinkMatchingLabel('Continue the Care');
    }
    
    private String addHttp(String str) {
        if(str != null && !str.startsWith('http')) {
            return 'http://' + str;
        } 
        else {
            return str;
        }
    }
    
    private String getWeblinkMatchingLabel(String label) {
        String result = null;
        
        if(String.isNotBlank(label) && globalWeblinks != null && globalWeblinks.size() > 0) {
            for(Weblink__c link:globalWeblinks) {
                if(link.Label__c == label) {
                    result = link.URL__c;
                    break;
                }
            }
        }
        
        return addHttp(result);
    }
    
    public String getcenterWebsiteLink() {
        if(center == null || String.isBlank(center.Website)) {
            return null;
        }
        else {
            return addHttp(center.Website);
        }
    }
    
    public String getscheduleATourLink() {
        if(center == null || String.isBlank(center.Website) || String.isBlank(center.QL_ScheduleTour__c)) {
            return null;
        }
        else {
            return addHttp(center.Website + center.QL_ScheduleTour__c);
        }
    }
    
    public String getrequestMoreInformationLink() {
        if(center == null || String.isBlank(center.Website) || String.isBlank(center.QL_ContactUs__c)) {
            return null;
        }
        else {
            return addHttp(center.Website + center.QL_ContactUs__c);
        }
    }

}