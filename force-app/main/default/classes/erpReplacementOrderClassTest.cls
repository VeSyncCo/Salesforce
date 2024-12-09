@IsTest
public class erpReplacementOrderClassTest {
    @TestSetup
    static void setupTestData() {
        // Create a Case record as the master for ERP_Replacement_Order__c
        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Web',
            Priority = 'Medium'
        );
        insert testCase;

        // Create an ERP_Customer__c record, fulfilling mandatory fields
        ERP_Customer__c testCustomer = new ERP_Customer__c(
            ERP_Customer_ID__c = '12345',
            Name = 'Test Customer'
        );
        insert testCustomer;

        // Create a Subsidiary record
        Subsidiary__c testSubsidiary = new Subsidiary__c(
            Subsidiary_Name__c = 'Test Subsidiary',
            External_System_Name__c = 'Zendesk'
        );
        insert testSubsidiary;

        // Create a Location record
        Location__c sampleLocation = new Location__c(
            Name = 'Sample Location'
        );
        insert sampleLocation;
        //Create Country Record
        Country__c sampleCountry=new Country__c(
        Name='Sample Country',
        Country_Code__c='10');
        insert sampleCountry;

        // Create an ERP_Replacement_Order__c record linked to Case and ERP_Customer__c
        ERP_Replacement_Order__c replacementOrder = new ERP_Replacement_Order__c(
            Case__c = testCase.Id,
            ERP_Customer__c = testCustomer.Id,
            Order_Status__c = 'NEW',
            Address_1__c = 'Sample Address 1',
            Addressee__c = 'Sample Addressee',
            Country__c = sampleCountry.Id,
            Location__c = sampleLocation.Id,
            Subsidiary__c=testSubsidiary.Id,
            Replacement_Order_Number__c='12345'
        );
        insert replacementOrder;

        // Set the current page as the one containing the replacement order record's ID
        PageReference pageRef = new PageReference('/' + replacementOrder.Id);
        Test.setCurrentPage(pageRef);
    }

    @IsTest
    static void testCreateReplacementOrder() {
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Fetch the test record
        ERP_Replacement_Order__c replacementOrder = [SELECT Id FROM ERP_Replacement_Order__c LIMIT 1];

        // Create instance of the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(replacementOrder);
        erpReplacementOrderClass handler = new erpReplacementOrderClass(sc);

        // Test createReplacementOrder
        Test.startTest();
        PageReference result = handler.createReplacementOrder();
        Test.stopTest();

        // Assertions
        Assert.areNotEqual(null, result, 'Page reference should not be null.');
        Assert.areEqual('/' + replacementOrder.Id, result.getUrl(), 'Redirect URL should match replacement order ID.');
    }

    @IsTest
    static void testVoidReplacementOrder() {
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Fetch the test record
        ERP_Replacement_Order__c replacementOrder = [SELECT Id FROM ERP_Replacement_Order__c LIMIT 1];

        // Create instance of the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(replacementOrder);
        erpReplacementOrderClass handler = new erpReplacementOrderClass(sc);

        // Test voidReplacementOrder
        Test.startTest();
        PageReference result = handler.voidReplacementOrder();
        Test.stopTest();

        // Assertions
        Assert.areNotEqual(null, result, 'Page reference should not be null.');
        Assert.areEqual('/' + replacementOrder.Id, result.getUrl(), 'Redirect URL should match replacement order ID.');
    }

    // Inner mock class for HTTP responses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status":"success"}');
            response.setStatusCode(201);
            return response;
        }
    }
}