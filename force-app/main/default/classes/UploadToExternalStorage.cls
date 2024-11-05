public class UploadToExternalStorage {
    
    public static void upload(id objId){
        Set<Id> ids=new Set<Id>();
        for(ContentDocumentLink link:[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:objId])
        {
            ids.add(link.ContentDocumentId);
        }
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        NamedCredential named=[SELECT DeveloperName, Endpoint FROM NamedCredential where DeveloperName='Amazon_S3'];
        
        for(ContentVersion attach:versions)
        {
            String attachmentBody = EncodingUtil.base64Encode(attach.VersionData);
            String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
            string contentType='application/pdf';
            system.debug('contentType:'+contentType);
            string filename = attach.Title.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '-');
        	filename = filename.replaceAll(' ','-').toLowercase();
            HttpRequest req = new HttpRequest();
            req.setMethod('PUT');
            req.setEndpoint('callout:S3Upload/My%20Folder/'+filename.toLowerCase()+ '.'+attach.FileExtension.toLowerCase());
            
            req.setHeader('Date', formattedDateString);
            req.setHeader('ACL', 'public-read');            
            Blob pdfBlob = EncodingUtil.base64Decode(attachmentBody);
            req.setBodyAsBlob(pdfBlob);
            string fileUrl=named.Endpoint+filename.toLowerCase()+ '.'+attach.FileExtension.toLowerCase();
            system.debug(fileUrl);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            system.debug(res.getStatusCode());
            system.debug(res.getBody());
        }
    }
    

}