# Salesforce Rest API

## Description
Salesforce Rest API is a simple and powerful web service based on RESTful principles. It exposes a wide range of Salesforce functionality via REST resources and HTTP methods.

## Client Credentials Authentication Flow
### Use the client ID and client secret to get an access token
```curl
curl --location 'https://etekcity1234--dev.sandbox.my.salesforce.com/services/oauth2/token?client_id=3MVG9ZTfbiXSaZsx48jVNv_bJKgkODSFmzXnRLEsK54RWbWrr_AkTBZJYVKpf_rGotvHIm7V_8SA4ys03avUV&grant_type=client_credentials&client_secret=0827646DD0A353DEED2321E541B488A3B7169FAA5333A75A1946F539AFE50B7C' \
--header 'grant_type: client_credentials' \
--header 'response_type: code' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Cookie: BrowserId=LJzVCXWfEe-XvX2_onYdZQ; CookieConsentPolicy=0:1; LSKey-c$CookieConsentPolicy=0:1' \
--data-urlencode 'grant_type=client_credentials' \
--data-urlencode 'client_id=3MVG9ZTfbiXSaZsx48jVNv_bJKgkODSFmzXnRLEsK54RWbWrr_AkTBZJYVKpf_rGotvHIm7V_8SA4ys03avUV' \
--data-urlencode 'client_secret=0827646DD0A353DEED2321E541B488A3B7169FAA5333A75A1946F539AFE50B7C'
```

### Tokens:
***URL***: 
https://etekcity1234--dev.sandbox.my.salesforce.com
***Client ID***: 
3MVG9ZTfbiXSaZsx48jVNv_bJKgkODSFmzXnRLEsK54RWbWrr_AkTBZJYVKpf_rGotvHIm7V_8SA4ys03avUV
***Client Secret***: 
0827646DD0A353DEED2321E541B488A3B7169FAA5333A75A1946F539AFE50B7C

Here is the response:
```json
{
    "access_token": "00DD20000001uxc!ARYAQJEQWuQq2KG5ixp8dwLFKm8Pottom.fxMku_Ctb1UBmY23WxZjSq1d8LwEz.F3pQ9tmYxjJKKpYy7UphxKY.aL.5PPDw",
    "signature": "2VZRjJoufqLMhCLUh8EQCMTVSUG8MCG8BnIGD/KnJP8=",
    "instance_url": "https://etekcity1234--dev.sandbox.my.salesforce.com",
    "id": "https://test.salesforce.com/id/00DD20000001uxcMAA/005Hu00000QWCnfIAH",
    "token_type": "Bearer",
    "issued_at": "1729232138961"
}
```

### Use the access token to make a request

#### Query
If I need to know which case need to issue replacement order, use the query below:
```SQL
SELECT Id, CaseNumber, RecordType.Name,  Status, Subject, Case_Handling_Method__c, Region__c, Subsidiary__c, Delivery_Location__c, Requester__c, CreatedDate FROM Case WHERE Case_Handling_Method__c = 'Replacement' and Delivery_Location__c != ''
```
This is the cURL command:
```curl
curl --location 'https://etekcity1234--dev.sandbox.my.salesforce.com/services/data/v57.0/query/?q=SELECT%20Id%2C%20CaseNumber%2C%20RecordType.Name%2C%20%20Status%2C%20Subject%2C%20Case_Handling_Method__c%2C%20Region__c%2C%20Subsidiary__c%2C%20Delivery_Location__c%2C%20Requester__c%2C%20CreatedDate%20FROM%20Case%20WHERE%20Case_Handling_Method__c%20%3D%20%27Replacement%27%20and%20Delivery_Location__c%20!%3D%20%27%27%0A' \
--header 'Content-Type: application/json'
```

Here is the response:
```json
{
    "totalSize": 1,
    "done": true,
    "records": [
        {
            "attributes": {
                "type": "Case",
                "url": "/services/data/v57.0/sobjects/Case/500D200000AjlaXIAR"
            },
            "Id": "500D200000AjlaXIAR",
            "CaseNumber": "00001846",
            "RecordType": {
                "attributes": {
                    "type": "RecordType",
                    "url": "/services/data/v57.0/sobjects/RecordType/012D2000000BtxbIAC"
                },
                "Name": "Warranty"
            },
            "Status": "New",
            "Subject": "My CP158 is not working (replacement case)",
            "Case_Handling_Method__c": "Replacement",
            "Region__c": "NA",
            "Subsidiary__c": "a0PD2000004iCgAMAU",
            "Delivery_Location__c": "a0QD2000004wxXuMAI",
            "Requester__c": "001D2000012py7SIAQ",
            "CreatedDate": "2024-10-17T09:10:02.000+0000"
        }
    ]
}
```

#### SObject Rows
Use this method to get the details of a specific case:
```curl
curl --location 'https://etekcity1234--dev.sandbox.my.salesforce.com/services/data/v57.0/sobjects/Case/500D200000AjlaXIAR' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer 00DD20000001uxc!ARYAQKjGplAozXp_masUqherIpDifawhdHF5h5vniJX9rG5tFvAjFsbkW.YahcrkWqWHFz5XNQC1pDVhuhkyWMbDGDu89Gz4' \
--header 'Cookie: BrowserId=LJzVCXWfEe-XvX2_onYdZQ; CookieConsentPolicy=0:1; LSKey-c$CookieConsentPolicy=0:1'
```

Response:
```json
{
    "attributes": {
        "type": "Case",
        "url": "/services/data/v57.0/sobjects/Case/500D200000AjlaXIAR"
    },
    "Id": "500D200000AjlaXIAR",
    "IsDeleted": false,
    "MasterRecordId": null,
    "CaseNumber": "00001846",
    "ContactId": null,
    "AccountId": null,
    "AssetId": null,
    "ProductId": "01tD200000A1cXUIAZ",
    "EntitlementId": null,
    "SourceId": null,
    "BusinessHoursId": "01mHu000000YGZiIAO",
    "ParentId": null,
    "SuppliedName": null,
    "SuppliedEmail": null,
    "SuppliedPhone": null,
    "SuppliedCompany": null,
    "Type": "Problem",
    "RecordTypeId": "012D2000000BtxbIAC",
    "Status": "New",
    "Reason": "New problem",
    "Origin": "Salesforce",
    "Language": null,
    "Subject": "My CP158 is not working (replacement case)",
    "Priority": "Standard",
    "Description": "My CP158 is not working",
    "IsClosed": false,
    "ClosedDate": null,
    "IsEscalated": false,
    "CurrencyIsoCode": "USD",
    "OwnerId": "005D2000005rLQ7IAM",
    "IsClosedOnCreate": false,
    "SlaStartDate": null,
    "SlaExitDate": null,
    "IsStopped": false,
    "StopStartDate": null,
    "CreatedDate": "2024-10-17T09:10:02.000+0000",
    "CreatedById": "005Hu00000QWCnfIAH",
    "LastModifiedDate": "2024-10-22T08:39:27.000+0000",
    "LastModifiedById": "005Hu00000QWCnfIAH",
    "SystemModstamp": "2024-10-22T08:39:27.000+0000",
    "ContactPhone": null,
    "ContactMobile": null,
    "ContactEmail": null,
    "ContactFax": null,
    "Comments": null,
    "LastViewedDate": "2024-10-22T08:45:24.000+0000",
    "LastReferencedDate": "2024-10-22T08:45:24.000+0000",
    "ServiceContractId": null,
    "MilestoneStatus": "",
    "Region__c": "NA",
    "Brand__c": "Cosori",
    "Reason__c": null,
    "Main_Category__c": "Hardware Issues",
    "Tags__c": null,
    "VeSync_App_Support__c": false,
    "Order__c": null,
    "Notes__c": null,
    "Resolution__c": null,
    "Cut_Cord__c": false,
    "Issued_Return_Label__c": false,
    "Return_Memo__c": null,
    "Type_Of_Question__c": null,
    "Product_Parts__c": null,
    "Batch__c": "TESTBN132456798",
    "Claims_Injury__c": false,
    "Claims_Property_Damage__c": false,
    "Warranty_Resolution__c": "Product Replacement",
    "Date_Of_Purchase__c": "2024-10-01",
    "Alleged_Issue__c": "Error Codes",
    "High_Priority_Confirmed__c": false,
    "External_System_ID__c": null,
    "External_System_Name__c": null,
    "DSRR_Request_Type__c": null,
    "DSRR_Request_Details__c": null,
    "Detail__c": "E2 Error code",
    "SubDetail__c": null,
    "Left_Negative_Review__c": false,
    "Related_to_HEPA__c": false,
    "Assigned_At__c": "2024-10-17T09:10:02.000+0000",
    "Initially_Assigned_At__c": "2024-10-17T09:10:02.000+0000",
    "Solved_At__c": null,
    "Case_Handling_Method__c": "Replacement",
    "Time_Spent_Last_Update__c": 0.0,
    "Type_Of_Shipment__c": "FedEx 2Day",
    "Shipping_Status__c": "Pending Fulfillment",
    "Replies__c": null,
    "Subsidiary__c": "a0PD2000004iCgAMAU",
    "Delivery_Location__c": "a0QD2000004wxXuMAI",
    "Need_Technical_Support__c": true,
    "Need_Follow_Up__c": true,
    "Ship_Date__c": "2024-10-10",
    "Tracking_Number__c": "1ZE4F4350399378037",
    "RMA__c": "RNA12345",
    "Case_Article_Recommendations__c": null,
    "First_Reply_Time_Minutes__c": null,
    "First_Reply_Time_Business_Hours__c": null,
    "First_Resolution_Time_Minutes__c": null,
    "First_Resolution_Time_Business_Hours__c": null,
    "Full_Resolution_Time_Minutes__c": null,
    "Full_Resolution_Time_Business_Hours__c": null,
    "Agent_Wait_Time_Minutes__c": null,
    "Agent_Wait_Time_Business_Hours__c": null,
    "Requester_Wait_Time_Minutes__c": null,
    "Requester_Wait_Time_Business_Hours__c": null,
    "On_Hold_Time_Minutes__c": null,
    "On_Hold_Time_Business_Hours__c": null,
    "Product_Category__c": "Air Fryer",
    "Requester__c": "001D2000012py7SIAQ",
    "Requester_Email__c": "raghav.sharma@caeliusconsulting.com",
    "Feedback_Type__c": null,
    "Feedback_Reason__c": null,
    "Feedback_SubReason__c": null,
    "Feedback_Detail__c": null,
    "AttachmentURL__c": null,
    "Inquiry_Type__c": null,
    "Inquiry_Details__c": null,
    "Inquiry_Subdetails__c": null,
    "Channel_Seller__c": "App (VeSync)",
    "Provided_Feedback__c": false,
    "Support_Email_Used__c": null,
    "Return_Needed__c": false,
    "Alleged_Injury__c": false,
    "Alleged_Property_Damage__c": false,
    "Alleged_Thermal_Issue__c": false,
    "Alleged_Hardware_Issue__c": false,
    "Return_Tracking_Number__c": null,
    "RequesterTest__c": null,
    "Case_Opened_At__c": null,
    "Resolution_Time__c": null,
    "Recall__c": false,
    "Survey_Invitation__c": null
}
```

#### Update the case
Use this method to update the case:
```curl
curl --location --request PATCH 'https://etekcity1234--dev.sandbox.my.salesforce.com/services/data/v57.0/sobjects/Case/500D200000AjlaXIAR' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer 00DD20000001uxc!ARYAQKjGplAozXp_masUqherIpDifawhdHF5h5vniJX9rG5tFvAjFsbkW.YahcrkWqWHFz5XNQC1pDVhuhkyWMbDGDu89Gz4' \
--header 'Cookie: BrowserId=LJzVCXWfEe-XvX2_onYdZQ; CookieConsentPolicy=0:1; LSKey-c$CookieConsentPolicy=0:1' \
--data '{
	"Return_Tracking_Number__c": "TEST TRACKING NUMBER"
}'
```

Response with Status 204 No Content -> Success
Response with Status 400 Bad Request -> Error
```json
[
    {
        "message": "No such column 'Return_Tracking_Number1__c' on sobject of type Case",
        "errorCode": "INVALID_FIELD"
    }
]
```