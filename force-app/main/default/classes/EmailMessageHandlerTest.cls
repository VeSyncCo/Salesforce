@isTest
public class EmailMessageHandlerTest {

    @TestSetup
    static void setupTestData() {
        // Insert bypass setting record
        VeSync_Bypass_Setting__c bypassSetting = new VeSync_Bypass_Setting__c(
            Bypass_All_Automations__c = false,    
            SetUpOwnerId = UserInfo.getUserId(),
            Bypass_Trigger__c = 'Test Custom Setting'
        );
        insert bypassSetting;
     
        // Create a Test Case
        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Email'
        );
        insert testCase;

        // Create EmailMessage records, mark the first as incoming and link to the Case
        List<EmailMessage> emailMessages = new List<EmailMessage>();
        for (Integer i = 0; i < 2; i++) {
            EmailMessage email = new EmailMessage(
                Subject = 'Test Email ' + i,
                ParentId = testCase.Id,
                FromAddress = 'test@example.com',
                ToAddress = 'support@example.com',
                Incoming = (i == 0) // Set the first email as incoming
            );
            emailMessages.add(email);
        }
        insert emailMessages;

        // Insert ContentVersion records for various attachment types (image, video, and other)
        ContentVersion cvImage = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'test_image.jpg', 
            VersionData = Blob.valueOf('Test image content')
        );
        ContentVersion cvVideo = new ContentVersion(
            Title = 'Test Video',
            PathOnClient = 'test_video.mp4', 
            VersionData = Blob.valueOf('Test video content')
        );
        ContentVersion cvDocument = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'test_document.pdf', 
            VersionData = Blob.valueOf('Test document content')
        );
        insert new List<ContentVersion>{cvImage, cvVideo, cvDocument};

        // Re-query ContentVersion records for the ContentDocumentId
        cvImage = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cvImage.Id];
        cvVideo = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cvVideo.Id];
        cvDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cvDocument.Id];

        // Link the ContentDocumentLink to the EmailMessage
        ContentDocumentLink imageLink = new ContentDocumentLink(
            LinkedEntityId = emailMessages[0].Id,
            ContentDocumentId = cvImage.ContentDocumentId,
            ShareType = 'I'
        );
        ContentDocumentLink videoLink = new ContentDocumentLink(
            LinkedEntityId = emailMessages[0].Id,
            ContentDocumentId = cvVideo.ContentDocumentId,
            ShareType = 'I'
        );
        ContentDocumentLink documentLink = new ContentDocumentLink(
            LinkedEntityId = emailMessages[0].Id,
            ContentDocumentId = cvDocument.ContentDocumentId,
            ShareType = 'I'
        );
        insert new List<ContentDocumentLink>{imageLink, videoLink, documentLink};
    }

    @isTest
    static void testHandleAfterUpdateWithCalloutMock() {
        // Register the mock callout response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        // Retrieve the EmailMessage records created in setup
        List<EmailMessage> emailMessages = [SELECT Id, Subject, ParentId FROM EmailMessage LIMIT 2];
        Assert.isTrue(emailMessages.size() == 2, 'EmailMessage records not created properly in setup.');

        // Modify Subject to trigger the after update logic
        for (EmailMessage email : emailMessages) {
            email.Subject = 'Updated Email Subject';
        }

        // Start test context
        Test.startTest();
        update emailMessages;  // This triggers the after update handler
        Test.stopTest();  // This allows asynchronous operations to complete

        // Retrieve the updated Case and check fields
        List<Case> cases = [SELECT Id, First_Reply_Time__c, Last_Reply_Time__c, Has_Image_Video_Attachments__c FROM Case];
        for (Case c : cases) {
            // Debugging for verifying field values
            System.debug('First Reply Time: ' + c.First_Reply_Time__c);
            System.debug('Last Reply Time: ' + c.Last_Reply_Time__c);
            System.debug('Has Image Video Attachments: ' + c.Has_Image_Video_Attachments__c);

            // Assert that First_Reply_Time__c is set (from the first incoming email)
            Assert.areNotEqual(c.First_Reply_Time__c, null, 'First_Reply_Time__c should be set.');
            // Assert that Last_Reply_Time__c is set
            Assert.areNotEqual(c.Last_Reply_Time__c, null, 'Last_Reply_Time__c should be set.');
            // Assert that Has_Image_Video_Attachments__c is true (because attachments are linked)
            Assert.areEqual(c.Has_Image_Video_Attachments__c, true, 'Has_Image_Video_Attachments__c should be true.');
        }
    }

    // Mock HTTP response class
    public class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response with status 200 (OK)
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{"status":"success"}');
            return res;
        }
    }
}