public class CaseEscalationNotificationBatch implements Database.Batchable<sObject>,Schedulable {

    private static final String HREF = '<a href="';
    private static final String HYPERLINKVAR1 = '/';
    private static final String HYPERLINKVAR2 = '">';
    private static final String HYPERLINKVAR3 = '</a>';

    public Database.QueryLocator start(Database.BatchableContext bc){
        List<Date> eligibleDateList = new List<Date>();
        eligibleDateList.add(system.today()-3);
        eligibleDateList.add(system.today()-6);
        eligibleDateList.add(system.today()-9);
        String query = 'Select Id, Owner.Name, OwnerId, Requester__r.Name, CaseNumber, Escalated_Date__c, Priority, Owner.Email from Case where Escalated_Date__c in: eligibleDateList and IsClosed = false and External_System_ID__c = null';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Case> scope){
        try{
            String excludeFromReminders = System.Label.Exclude_From_Reminders;
            String address = System.Label.Follow_Up_Email_Address;

            EmailTemplate followUpTemplate = [SELECT Id, Subject, HtmlValue, Body, DeveloperName FROM EmailTemplate WHERE DeveloperName = 'Follow_Up_Emails' LIMIT 1];
            List<Messaging.SingleEmailMessage> reminderEmailList = new List<Messaging.SingleEmailMessage>();
            OrgWideEmailAddress senderAddress  = [SELECT Id, Address FROM OrgWideEmailAddress where Address =:address LIMIT 1];

            for(Case caseRecord : scope){
                // Reset htmlBody for each email to avoid cumulative replacements
                String htmlBody = followUpTemplate.HtmlValue;

                htmlBody = htmlBody.replace('{!Case.Requester__c}', caseRecord.Requester__r.Name);
                htmlBody = htmlBody.replace('{!Case.Escalated_Date__c}', String.valueOf(caseRecord.Escalated_Date__c));
                htmlBody = htmlBody.replace('{!Case.CaseNumber}', caseRecord.CaseNumber);
                htmlBody = htmlBody.replace('{!Case.Priority}', caseRecord.Priority);
                htmlBody = htmlBody.replace('{!Case.OwnerFullName}', caseRecord.Owner.Name);
                htmlBody = htmlBody.replace('{!CaseLink}', HREF + URL.getOrgDomainUrl().toExternalForm() + HYPERLINKVAR1 + caseRecord.Id + HYPERLINKVAR2 + caseRecord.CaseNumber + HYPERLINKVAR3);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {caseRecord.Owner.Email});
                email.setHtmlBody(htmlBody);
                email.setOrgWideEmailAddressId(senderAddress.Id);

                reminderEmailList.add(email);
            }

            if(reminderEmailList.size() > 0){
                Messaging.sendEmail(reminderEmailList);
            }
        }
        catch(Exception e){
            // Consider logging the exception
        }
    }

    public void finish(Database.BatchableContext bc){
    }
    
    public void execute(System.SchedulableContext cntxt){
        Database.executeBatch(new CaseEscalationNotificationBatch());
    }
}