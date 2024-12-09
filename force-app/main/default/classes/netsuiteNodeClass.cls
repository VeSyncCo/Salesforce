public class netsuiteNodeClass {
	@future(callout=true)
    public static void asyncCallout(String endPoint, String bodyString) {
        System.debug('asyncCallout endPoint:' + endPoint);
        System.debug('asyncCallout bodyString:' + bodyString);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody(bodyString);
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
}