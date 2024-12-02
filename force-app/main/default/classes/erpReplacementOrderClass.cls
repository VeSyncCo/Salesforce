public class erpReplacementOrderClass {

	public ERP_Replacement_Order__c RO { get; set; }
    public Id replacementOrderId { get; set; }
    
    //constructor to get the Case record
    public erpReplacementOrderClass(ApexPages.StandardController controller) {
        RO = (ERP_Replacement_Order__c) controller.getRecord();
        replacementOrderId = RO.Id;
    }
    
    //Method that can is called from the Visual Force page action attribute
    public PageReference createReplacementOrder() {
        System.debug('replacementOrderId: ' + replacementOrderId);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://erp-spapi.itekcity.com/asyncRequestNetSuite');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"url":"https://5624281-sb1.restlets.api.netsuite.com/app/site/hosting/restlet.nl?script=4507&deploy=1","ns_env":"sandbox","action":"createReplacementOrder","data":{"replacementOrderId":"'+replacementOrderId+'"}}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        // redirect back to the record
       	PageReference pageRef = new PageReference('/'+replacementOrderId);
        pageRef.setRedirect(true);
       	return pageRef; //Returns to the record page
    }
    
    //Method that can is called from the Visual Force page action attribute
    public PageReference voidReplacementOrder() {
        System.debug('replacementOrderId: ' + replacementOrderId);
        System.debug('RO: ' + RO);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://erp-spapi.itekcity.com/asyncRequestNetSuite');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"url":"https://5624281-sb1.restlets.api.netsuite.com/app/site/hosting/restlet.nl?script=4507&deploy=1","ns_env":"sandbox","action":"voidReplacementOrder","data":{"replacementOrderId":"'+replacementOrderId+'"}}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        // redirect back to the record
       	PageReference pageRef = new PageReference('/'+replacementOrderId);
        pageRef.setRedirect(true);
       	return pageRef; //Returns to the record page
    }
}