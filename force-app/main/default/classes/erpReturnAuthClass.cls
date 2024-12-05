public class erpReturnAuthClass {

	public Return_Auth__c RA { get; set; }
    public Id returnAuthId { get; set; }
    
    //constructor to get the Case record
    public erpReturnAuthClass(ApexPages.StandardController controller) {
        RA =  (Return_Auth__c) controller.getRecord();
        returnAuthId = RA.Id;
    }
    
    //Method that can is called from the Visual Force page action attribute
    public PageReference createReturnLabel() {
        System.debug('returnAuthId: ' + returnAuthId);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://erp-spapi.itekcity.com/asyncRequestNetSuite');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"url":"https://5624281-sb1.restlets.api.netsuite.com/app/site/hosting/restlet.nl?script=4507&deploy=1","ns_env":"sandbox","action":"createReturnLabel","data":{"AuthorizationId":"'+returnAuthId+'"}}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        // redirect back to the record
       	PageReference pageRef = new PageReference('/'+returnAuthId);
        pageRef.setRedirect(true);
       	return pageRef; //Returns to the record page
    }
    
    //Method that can is called from the Visual Force page action attribute
    public PageReference voidReturnLabel() {
        System.debug('returnAuthId: ' + returnAuthId);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://erp-spapi.itekcity.com/syncRequestNetSuite');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"url":"https://5624281-sb1.restlets.api.netsuite.com/app/site/hosting/restlet.nl?script=4507&deploy=1","ns_env":"sandbox","action":"voidReturnLabel","data":{"AuthorizationId":"'+returnAuthId+'"}}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        // redirect back to the record
       	PageReference pageRef = new PageReference('/'+returnAuthId);
        pageRef.setRedirect(true);
       	return pageRef; //Returns to the record page
    }
    
    //Method that can is called from the Visual Force page action attribute
    public PageReference createReturnAuth() {
        System.debug('returnAuthId: ' + returnAuthId);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://erp-spapi.itekcity.com/asyncRequestNetSuite');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"url":"https://5624281-sb1.restlets.api.netsuite.com/app/site/hosting/restlet.nl?script=4507&deploy=1","ns_env":"sandbox","action":"createReturnAuth","data":{"AuthorizationId":"'+returnAuthId+'"}}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        // redirect back to the record
       	PageReference pageRef = new PageReference('/'+returnAuthId);
        pageRef.setRedirect(true);
       	return pageRef; //Returns to the record page
    }
}