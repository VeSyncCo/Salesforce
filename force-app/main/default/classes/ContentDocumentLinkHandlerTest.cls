@isTest
public class ContentDocumentLinkHandlerTest {
    
    @isTest
    static void testInsertContentDocumentLinkWithEmailMessage() {
        
 
        User testUser = new User(
            Username = 'testusercondoc@example.com',
            LastName = 'condoc',
            Alias = 'testcon',
            Email = 'testusercondoc@example.com',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        

        VeSync_Bypass_Setting__c bypassSetting = new VeSync_Bypass_Setting__c(
            Bypass_All_Automations__c = false,    
            SetUpOwnerId = UserInfo.getUserId(),
            Bypass_Trigger__c = 'Test Custom Setting'
        );
        insert bypassSetting;
 
        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'New',
            OwnerId = testUser.Id 
        );
        insert testCase;
        
 
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('This is a test document')
        );
        insert contentVersion;
        
    
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :contentVersion.Id LIMIT 1];
        System.assert(contentDocument.Id != null, 'ContentDocumentId should not be null');
        

        EmailMessage email = new EmailMessage(
            Subject = 'Test Email Subject',
            FromAddress = 'test@example.com',
            ToAddress = 'test@example.com',
            Status = '3',  
            ParentId = testCase.Id
        );
        insert email;
        
 
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            LinkedEntityId = testCase.Id,
            ContentDocumentId = contentDocument.Id,
            ShareType = 'V'
        );
        
        
        ContentDocumentLink emailContentDocumentLink = new ContentDocumentLink(
            LinkedEntityId = email.Id,
            ContentDocumentId = contentDocument.Id,
            ShareType = 'V'
        );
        
        Test.startTest();
        
  
        insert contentDocumentLink;
        insert emailContentDocumentLink;
        
        Test.stopTest();
        
   
        ContentDocumentLink resultLink = [SELECT Id, ContentDocumentId, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE Id = :contentDocumentLink.Id];
        
          Assert.areNotEqual(resultLink, null, 'The ContentDocumentLink record should exist in the database.');
          Assert.areEqual(resultLink.ContentDocumentId, contentDocument.Id, 'ContentDocumentId should match the inserted document.');
          Assert.areEqual(resultLink.LinkedEntityId, testCase.Id, 'LinkedEntityId should match the Case.');
          Assert.areEqual(resultLink.ShareType, 'V', 'ShareType should be "V" as per the setup.');
        

        ContentDocumentLink emailLink = [SELECT Id, ContentDocumentId, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE Id = :emailContentDocumentLink.Id];
        
        Assert.areNotEqual(emailLink, null, 'The ContentDocumentLink for EmailMessage should exist in the database.');
        Assert.areEqual(emailLink.ContentDocumentId, contentDocument.Id, 'ContentDocumentId for email should match the inserted document.');
          Assert.areEqual(emailLink.LinkedEntityId, email.Id, 'LinkedEntityId should match the EmailMessage.');
          Assert.areEqual(emailLink.ShareType, 'V', 'ShareType should be "V" for email.');
    }
}