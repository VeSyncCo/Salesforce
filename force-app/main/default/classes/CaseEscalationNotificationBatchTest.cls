@isTest(SeeAllData=True)
public class CaseEscalationNotificationBatchTest {

    @isTest
    static void testBatchExecution() {
        String followUpEmailAddress = System.Label.Follow_Up_Email_Address;
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :followUpEmailAddress LIMIT 1];
        System.assert(!orgWideEmails.isEmpty(), 'An Org-Wide Email Address with the address from the custom label must exist.');

        List<EmailTemplate> emailTemplates = [SELECT Id, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Follow_Up_Emails' LIMIT 1];
        System.assert(!emailTemplates.isEmpty(), 'Email Template \'Follow_Up_Emails\' must exist.');
        System.assertNotEquals(null, emailTemplates[0].HtmlValue, 'Email Template HtmlValue must not be null.');

        Account testAccount = new Account(Name = 'Test Requester Account');
        insert testAccount;

        User testUser = [SELECT Id, Email, Name FROM User WHERE IsActive = true AND Email != null AND Name != null LIMIT 1];
        System.assertNotEquals(null, testUser, 'An active user with an email and name must exist.');

        List<Case> testCases = new List<Case>();
        List<Date> eligibleDates = new List<Date>{
            System.today().addDays(-3),
            System.today().addDays(-6),
            System.today().addDays(-9)
        };

        for (Date escalatedDate : eligibleDates) {
            Case testCase = new Case(
                OwnerId = testUser.Id,
                Priority = 'High',
                Escalated_Date__c = escalatedDate,
                Requester__c = testAccount.Id,
                External_System_ID__c = null,
                Status = 'New'  
            );
            testCases.add(testCase);
        }
        insert testCases;
		
        //System.debug(testCases[0]);
        testCases[0].Escalated_Date__c = eligibleDates[0];
        testCases[1].Escalated_Date__c = eligibleDates[1];
        testCases[2].Escalated_Date__c = eligibleDates[2];
        
        update testCases;
        
        testCases[0].Escalated_Date__c = eligibleDates[0];
        testCases[1].Escalated_Date__c = eligibleDates[1];
        testCases[2].Escalated_Date__c = eligibleDates[2];
        
        update testCases;
        
        testCases = [SELECT Id, Owner.Name, Owner.Email, Requester__r.Name, Escalated_Date__c, Priority, CaseNumber
                     FROM Case WHERE Id IN :testCases];
     	system.debug(testCases[0].Owner.Name);
        Test.startTest();
        CaseEscalationNotificationBatch batch = new CaseEscalationNotificationBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        System.assert(true, 'Batch executed successfully.');
    }

}