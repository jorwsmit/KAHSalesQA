@RestResource(urlMapping='/AssessmentTransfer/*')
global class iPathAssessmentTransferController { 

     public class TransferException extends Exception{}

     public class transferPayload {
          String chainUUID;
          String action;
          String transferNotes;
          String levelOfCare;
          Id transferee;
          List<String> documentFilenames;
     }

     public class transfereePayload {
          String chainUUID;
          String action;
     }

     public class UUID {
          UUID() {}
          public String newUUID() {
               String hex = EncodingUtil.convertToHex(Crypto.generateAESKey(128));
               return String.join(new String[] {
                    hex.substring(0,8), hex.substring(8,12), hex.substring(12,16), hex.substring(16,20), hex.substring(20)
               }, '-').toUpperCase();
          }
     }

     @HttpGet
     global static Map<String,List<Assessment_Transfer__c>> downloadTransfers() {
          RestRequest req = RestContext.request;  
        
          try {
               List<Assessment_Transfer__c> transfersIncoming = [SELECT Source_Chain_UUID__c, Patient_Last_Name__c, Patient_First_Name__c, Source_Level_Of_Care__c, Expiration_Time__c, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Phone, CreatedBy.Email, Notes__c FROM Assessment_Transfer__c WHERE Resolution__c = NULL AND Expiration_Time__c > :DateTime.NOW() AND Transferee__c = :UserInfo.getUserId()];
               List<Assessment_Transfer__c> transfersOutgoing = [SELECT Source_Chain_UUID__c, Patient_Last_Name__c, Patient_First_Name__c, Source_Level_Of_Care__c, Resolution__c, Resolution_Time__c, CreatedDate, Transferee__r.FirstName, Transferee__r.LastName, Expiration_Time__c, Notes__c FROM Assessment_Transfer__c WHERE (Resolution__c = 'Accept' OR (Resolution__c = null AND Expiration_Time__c > :DateTime.NOW()))  AND CreatedById = :UserInfo.getUserId()];
               List<Assessment_Transfer__c> transfersOutgoing_Filtered = new List<Assessment_Transfer__c>();
               List<Assessment_Transfer__c> allIncoming = [SELECT Target_Chain_UUID__c, Source_Chain_UUID__c, Resolution_Time__c, CreatedDate, Resolution__c, Expiration_Time__c FROM Assessment_Transfer__c WHERE Transferee__c = :UserInfo.getUserId()];
               
               for (Assessment_Transfer__c assessmentOutgoing: transfersOutgoing) {
                    if (assessmentOutgoing.Resolution_Time__c != null) {
                         Boolean foundNewerIncoming = false;
                         
                         for(Assessment_Transfer__c incoming:allIncoming) {
                            if(incoming.Target_Chain_UUID__c == assessmentOutgoing.Source_Chain_UUID__c && incoming.Resolution_Time__c > assessmentOutgoing.Resolution_Time__c) {
                                foundNewerIncoming = true;
                                break;
                            }
                         }
                        
                         if (!foundNewerIncoming) {
                             transfersOutgoing_Filtered.add(assessmentOutgoing);
                         }
                    } else {
                         transfersOutgoing_Filtered.add(assessmentOutgoing);
                    }
               }

               DateTime rollbackDateTime = DateTime.now();
               rollbackDateTime = rollbackDateTime.addDays(-30);
               List<Assessment_Transfer__c> transferNotifications = [SELECT Source_Chain_UUID__c, Resolution__c, Resolution_Time__c, Transferee__r.FirstName, Transferee__r.LastName, Expiration_Time__c, Patient_Last_Name__c, Patient_First_Name__c, CreatedBy.FirstName, CreatedBy.LastName FROM Assessment_Transfer__c WHERE ((Transferee__c = :UserInfo.getUserId() AND (Resolution__c != 'Accept' AND Resolution__c != 'Refuse')) OR (CreatedById = :UserInfo.getUserId() AND (Resolution__c != 'Cancel' AND Resolution__c != ''))) AND CreatedDate > :rollbackDateTime ORDER BY LastModifiedDate DESC];
               
               Map<String, List<Assessment_Transfer__c>> transfers = new Map<String, List<Assessment_Transfer__c>>();
               transfers.put('Incoming', transfersIncoming);
               transfers.put('Outgoing', transfersOutgoing_Filtered);
               transfers.put('Notifications', transferNotifications);
               
               return transfers;
          } catch (Exception mainError) {
               throw new TransferException('Could not perform GET for Assessment Transfer');
          }
     }
     
     @HttpPost
     global static Map<String,String> transferPatient() {
          RestRequest req = RestContext.request;
          
          try {
               transferPayload transfer = (transferPayload)System.JSON.deserialize(req.requestBody.toString(), transferPayload.class);
               if (transfer.action == 'Initiate') {
                    List<Assessment_TCH__c> assessmentTCH = [SELECT Patient_First_Name__c, Patient_Last_Name__c, Meta_Filename__c, Meta_Submitted_Date__c, Meta_Document_Status__c, Meta_Creation_Date__c FROM Assessment_TCH__c WHERE Meta_ChainUUID__c = :transfer.chainUUID ORDER BY CreatedDate DESC];
                    List<Assessment_TCC__c> assessmentTCC = [SELECT Patient_First_Name__c, Patient_Last_Name__c, Meta_Filename__c, Meta_Submitted_Date__c, Meta_Document_Status__c, Meta_Creation_Date__c FROM Assessment_TCC__c WHERE Meta_ChainUUID__c = :transfer.chainUUID ORDER BY CreatedDate DESC];

                    Assessment_Transfer__c assessmentTransfer = new Assessment_Transfer__c();
                    DateTime maxExpirationDate = DateTime.now();
                    maxExpirationDate = maxExpirationDate.addDays(1);

                    if (assessmentTCH.size() > 0) {
                    	system.debug('fileNames: ' + transfer.documentFilenames + ' transferNotes:' + transfer.transferNotes);
                         if (transfer.documentFilenames != null) {
                             Set<String> filenames = new Set<String>();
                             for(Assessment_TCH__c assessment : assessmentTCH) {
                                  filenames.add(assessment.Meta_Filename__c);
                             }
                         
                             for(String filename : transfer.documentFilenames) {
                                  if (!filenames.contains(filename)) {
                                       return new Map<String,String> {'Initiate' => 'Failure', 'Chain' => transfer.chainUUID, 'Error' => 'Documents are not synchronized.  Try syncing your device and initiating the transfer again.'};
                                  }
                             }
                         }
                         
                         DateTime documentExpiration = assessmentTCH[0].Meta_Creation_Date__c.addDays(2);
                         if (documentExpiration < maxExpirationDate && assessmentTCH[0].Meta_Document_Status__c == '1') {
                              assessmentTransfer.Expiration_Time__c = documentExpiration;
                         } else {
                              assessmentTransfer.Expiration_Time__c = maxExpirationDate;
                         }
                
                         if(String.isBlank(transfer.transferNotes)) {
                            assessmentTransfer.Notes__c = '[None]';
                         }
                         else {
                            assessmentTransfer.Notes__c = transfer.transferNotes;
                         }
                         
                         assessmentTransfer.Patient_First_Name__c = assessmentTCH[0].Patient_First_Name__c;
                         assessmentTransfer.Patient_Last_Name__c = assessmentTCH[0].Patient_Last_Name__c;
                         assessmentTransfer.Source_Chain_UUID__c = transfer.chainUUID;
                         assessmentTransfer.Source_Level_Of_Care__c = 'TCH';
                         assessmentTransfer.Transferee__c = transfer.transferee;
                         
                    } else if (assessmentTCC.size() > 0) {
                         if (transfer.documentFilenames != null) {
                             Set<String> filenames = new Set<String>();
                             for(Assessment_TCC__c assessment : assessmentTCC) {
                                  filenames.add(assessment.Meta_Filename__c);
                             }
                         
                             for(String filename : transfer.documentFilenames) {
                                  if (!filenames.contains(filename)) {
                                       return new Map<String,String> {'Initiate' => 'Failure', 'Chain' => transfer.chainUUID, 'Error' => 'Documents are not synchronized.  Try syncing your device and initiating the transfer again.'};
                                  }
                             }
                         }
                         
                         DateTime documentExpiration = assessmentTCC[0].Meta_Creation_Date__c.addDays(2);                
                         if (documentExpiration < maxExpirationDate && assessmentTCC[0].Meta_Document_Status__c == '1') {
                              assessmentTransfer.Expiration_Time__c = documentExpiration;
                         } else {
                              assessmentTransfer.Expiration_Time__c = maxExpirationDate;
                         }
                
                         if(String.isBlank(transfer.transferNotes)) {
                            assessmentTransfer.Notes__c = '[None]';
                         }
                         else {
                            assessmentTransfer.Notes__c = transfer.transferNotes;
                         }
                         
                         assessmentTransfer.Patient_First_Name__c = assessmentTCC[0].Patient_First_Name__c;
                         assessmentTransfer.Patient_Last_Name__c = assessmentTCC[0].Patient_Last_Name__c;
                         assessmentTransfer.Source_Chain_UUID__c = transfer.chainUUID;
                         assessmentTransfer.Source_Level_Of_Care__c = 'TCC';
                         assessmentTransfer.Transferee__c = transfer.transferee;
                    } else {
                         throw new TransferException('Could not find assessments matching chain');
                    }

                    insert assessmentTransfer;
                    
                    sendPlainTextEmail(transfer.transferee, 'Assessment Transfer Notification',
                        UserInfo.getName() + ' has transferred an assessment to you for a patient with the last name \"' + assessmentTransfer.Patient_Last_Name__c + '\". ' +
                        'To take action, open the iPath app, and go to your assessment dashboard or tap on the notifications icon.\r\n\r\n' +
                        'Please Note: If you don’t see the transferred assessment, you may need to go to \"My Profile\" and tap the \"Force Sync Refresh\" button to get your app to sync with Salesforce.');
                    
                    return new Map<String,String> {'Initiate' => 'Success', 'transfer' => assessmentTransfer.Transferee__c};
               } else if (transfer.action == 'Cancel') {

                    List<Assessment_Transfer__c> assessmentTransfers = [SELECT Source_Chain_UUID__c FROM Assessment_Transfer__c WHERE Source_Chain_UUID__c = :transfer.chainUUID AND Resolution__c = NULL AND CreatedById = :UserInfo.getUserId()];
                    if (assessmentTransfers.size() > 0) {
                         assessmentTransfers[0].Resolution__c = 'Cancel';
                         assessmentTransfers[0].Resolution_Time__c = DateTime.now();
                         update assessmentTransfers[0];
                         return new Map<String,String> {'Cancel' => 'Success', 'Chain' => transfer.chainUUID};
                    } else {
                         return new Map<String,String> {'Cancel' => 'Failure', 'Chain' => transfer.chainUUID};
                    }
                    
               } if (transfer.action == 'Accept') {
                    List<Assessment_Transfer__c> assessmentTransfers = [SELECT Source_Chain_UUID__c, Source_Level_Of_Care__c FROM Assessment_Transfer__c WHERE Source_Chain_UUID__c = :transfer.chainUUID AND Resolution__c = NULL AND Transferee__c = :UserInfo.getUserId() AND Expiration_Time__c > :DateTime.NOW()];
                    if (assessmentTransfers.size() > 0) {
                         assessmentTransfers[0].Target_Level_Of_Care__c = transfer.levelOfCare;
                         assessmentTransfers[0].Resolution__c = 'Accept';
                         assessmentTransfers[0].Resolution_Time__c = DateTime.now();

                         Boolean updateOwner = false;
                         String sourceFileName = '';
                         
                         if (assessmentTransfers[0].Source_Level_Of_Care__c == transfer.levelOfCare) {
                              assessmentTransfers[0].Target_Chain_UUID__c = assessmentTransfers[0].Source_Chain_UUID__c;
                              updateOwner = true;
                         } else {
                              UUID uuid = new UUID();
                              assessmentTransfers[0].Target_Chain_UUID__c = uuid.newUUID();
                         }
                         update assessmentTransfers[0];

                         if (updateOwner) {
                              if (assessmentTransfers[0].Source_Level_Of_Care__c == 'TCH') {
                                   List<Assessment_TCH__c> assessments = [SELECT Meta_ChainUUID__c, Meta_Owner__c FROM Assessment_TCH__c WHERE Meta_ChainUUID__c = :assessmentTransfers[0].Source_Chain_UUID__c];
                                   for(Assessment_TCH__c assessment : assessments) {
                                        assessment.Meta_Owner__c = UserInfo.getUserId();
                                        update assessment;
                                   }
                              } else {
                                   List<Assessment_TCC__c> assessments = [SELECT Meta_ChainUUID__c, Meta_Owner__c FROM Assessment_TCC__c WHERE Meta_ChainUUID__c = :assessmentTransfers[0].Source_Chain_UUID__c];
                                   for(Assessment_TCC__c assessment : assessments) {
                                        assessment.Meta_Owner__c = UserInfo.getUserId();
                                        update assessment;
                                   }
                              }     
                         } else {
                              if (assessmentTransfers[0].Source_Level_Of_Care__c == 'TCH') {
                                   List<Assessment_TCH__c> assessments = [SELECT Meta_ChainUUID__c, Meta_Document_Version__c, Meta_Filename__c FROM Assessment_TCH__c WHERE Meta_ChainUUID__c = :assessmentTransfers[0].Source_Chain_UUID__c ORDER BY CreatedDate DESC];
                                   sourceFileName = assessments[0].Meta_Filename__c;
                              } else {
                                   List<Assessment_TCC__c> assessments = [SELECT Meta_ChainUUID__c, Meta_Document_Version__c, Meta_Filename__c FROM Assessment_TCC__c WHERE Meta_ChainUUID__c = :assessmentTransfers[0].Source_Chain_UUID__c ORDER BY CreatedDate DESC];
                                   sourceFileName = assessments[0].Meta_Filename__c;
                              }
                         }

                         return new Map<String,String> {'Accept' => 'Success', 'Source Chain' => assessmentTransfers[0].Source_Chain_UUID__c, 'Target Chain' => assessmentTransfers[0].Target_Chain_UUID__c, 'Level Of Care' => transfer.levelOfCare, 'Source File' => sourceFileName};
                         
                    } else {
                         return new Map<String,String> {'Accept' => 'Failure', 'Chain' => transfer.chainUUID};
                    }

               } else if (transfer.action == 'Refuse') {

                    List<Assessment_Transfer__c> assessmentTransfers = [SELECT Source_Chain_UUID__c FROM Assessment_Transfer__c WHERE Source_Chain_UUID__c = :transfer.chainUUID AND Resolution__c = NULL AND Transferee__c = :UserInfo.getUserId() AND Expiration_Time__c > :DateTime.NOW()];
                    if (assessmentTransfers.size() > 0) {
                         assessmentTransfers[0].Resolution__c = 'Refuse';
                         assessmentTransfers[0].Resolution_Time__c = DateTime.now();
                         update assessmentTransfers[0];
                         return new Map<String,String> {'Refuse' => 'Success', 'Chain' => transfer.chainUUID};
                    } else {
                         return new Map<String,String> {'Refuse' => 'Failure', 'Chain' => transfer.chainUUID};
                    }

               }

               throw new TransferException('Could not identify transfer action');
          } catch(Exception mainError) {
               throw new TransferException('Could not perform POST for Assessment Transfer');
          }
     }
     
     private static void sendPlainTextEmail(Id recipientUserId, String subject, String body) {
        try {
            // Get email address of recipient
            User recipient = [Select Email From User where Id = :recipientUserId];
                    
            // Create email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {recipient.Email});
            mail.setBccSender(false);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
                            
            // Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
        catch (Exception emailError) {
            // Log exception and then simply continue normally
            System.debug('Exception during emailing: ' + emailError.getMessage());
        }
    }
    
}