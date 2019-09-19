@RestResource(urlMapping='/CollateralEmail/*')
global class iPathCollateralEmailController {

    // Custom Exception
    public class CollateralException extends Exception{}

    @HttpPost
    global static Map<String,String> sendEmail(String trackingId, Id recipientId, String email, String centerId, List<Id> contentDocumentIds, String emailContent, String firstName, String lastName) {
        // Sends an email to the recipient with links to the selected content (collateral) documents
        // This method returns either an error message or (if successfully sent) the passed-in tracking id
        try {
            // Validations
            String validationError = doValidation(trackingId, recipientId, email, contentDocumentIds, emailContent);

            if(String.isNotBlank(validationError)) {
                throw new CollateralException(validationError);
            }
            else {
                // Email address to send to
                List<String> usingToAddresses = new List<String>();
                usingToAddresses.add(email);

                // Create map of download URL to Title from list of content document ids
                List<ContentVersion> collateralsList = [SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId in :contentDocumentIds AND IsLatest = true];
                Map<String,String> collateralsMap = new Map<String, String>();

                for(ContentVersion cv:collateralsList) {
                    collateralsMap.put('http://kindred.force.com/sfc/servlet.shepherd/version/download/' + cv.Id, cv.Title);
                }

                // Setup page reference
                PageReference pageRef = Page.iPathMobileEmailTemplate;
                pageRef.getParameters().put('centerId', centerId);
                if (firstName == null) {
                    pageRef.getParameters().put('firstName', recipientFirstName(recipientId));
                } else {
                    pageRef.getParameters().put('firstName', firstName);
                }
                pageRef.getParameters().put('emailContent', emailContent);
                pageRef.getParameters().put('collateralsJSON', JSON.serialize(collateralsMap));

                // Creating email message
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(usingToAddresses);
                mail.setBccSender(true);
                // Adding timestamp to email in order to make the subject line unique (Gmail sometimes removes CSS styles in threads) see pivotal tracker #84502202
                mail.setSubject('Additional Information about Kindred Healthcare, ' + System.now().format('HH:mm:ss'));

                // Get HTML content from VisualForce page and assign to mail body
                Blob content = Test.IsRunningTest() ? Blob.valueOf('<html><body>Test</body></html>') : pageRef.getContent();
                mail.setHtmlBody(content.toString());

                // Send email
                List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});

                if (!sendEmailResults.get(0).isSuccess()) {
                        throw new CollateralException(sendEmailResults.get(0).getErrors()[0].getMessage() + '; status code ' + sendEmailResults.get(0).getErrors()[0].getStatusCode());
                        }
                        else {
                            // Create activity to record the successful email send
                            Event emailEvent = new Event();
                            
                            emailEvent.EndDateTime = Datetime.now();
                            emailEvent.StartDateTime = emailEvent.EndDateTime.addHours(-1);
                            emailEvent.Type = 'Email';
                            emailEvent.Description = 'Collateral emailed to ' + email + ':\r\n' + String.join(collateralsMap.values(),'\r\n');
                            emailEvent.iPathTrackingId__c = trackingId;
                            emailEvent.ShowAs = 'Free';
                            emailEvent.WhoId = recipientId;
                            
                            insert emailEvent;
                            
                            return new Map<String,String> {'Result' => 'Success', 'TrackingId' => trackingId};
                        }
            }
        }
        catch (Exception e) {
            // Return error message to caller
            return new Map<String,String> {'Result' => 'Failed', 'Error' => e.getMessage()};
        }
    }

    private static String recipientFirstName(Id recipientId) {
        // The id passed in can be either for a contact or a lead. This method simply returns the FirstName assigned to the record (if non-blank, otherwise returns a default value)

        String defaultResult = 'Sir / Madam';

        if(recipientId == null) {
            return defaultResult;
        }
        else {
            Schema.SObjectType objType = recipientId.getSObjectType();

            if(objType == Lead.sObjectType) {
                List<Lead> leads = [SELECT FirstName FROM Lead WHERE Id = :recipientId];

                if(leads.size() == 0) {
                    throw new CollateralException('Lead not found; ');
                }
                else {
                    return String.isBlank(leads[0].FirstName) ? defaultResult : leads[0].FirstName;
                }
            }
            else if(objType == Contact.sObjectType) {
                List<Contact> contacts = [SELECT FirstName FROM Contact WHERE Id = :recipientId];

                if(contacts.size() == 0) {
                    throw new CollateralException('Contact not found; ');
                }
                else {
                    return String.isBlank(contacts[0].FirstName) ? defaultResult : contacts[0].FirstName;
                }
            }
            else {
                throw new CollateralException('Recipient ID must refer to either a Contact or a Lead; ');
            }
        }
    }

    private static String doValidation(String trackingId, Id recipientId, String email, List<Id> contentDocumentIds, String emailContent) {
        // Finds and returns errors in the parameters (or returns empty string if all good)
        String result = '';

        if (String.isBlank(trackingId)) {
            result += 'Tracking ID is required; ';
        }
        else {
            String likeString = '%' + trackingId + '%';
            List<Event> events = [SELECT Id FROM Event WHERE iPathTrackingId__c like :likeString];

            if(events.size() > 0) {
                // Note that there is still a possibility of rapid or concurrent sendEmail calls allowing the same trackingId to be saved in more than one activity record
                // (Not enforcing uniqueness on the field since we still want to see a duplicate activity created if there is ever a double-send of the email).
                // However this should rarely if ever happen in normal use if the calls are always timed sufficiently far apart (see pivotal tracker story #83965910)
                result += 'Cannot send the same email again; ';
            }
        }

        if (String.isBlank(email)) {
            result += 'Email cannot be blank; ';
        }

        if (contentDocumentIds == null || contentDocumentIds.size() == 0) {
            result += 'At least one content document ID is required; ';
        }
        else {
            for(Id cdID : contentDocumentIds) {
                if(cdId == null) {
                    result += 'All content document IDs must be non-null; ';
                    break;
                }
            }
        }

        if (String.isBlank(emailContent)) {
            result += 'Email body cannot be blank; ';
        }

        return result;
    }

}