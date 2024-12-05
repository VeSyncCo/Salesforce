trigger EmailMessageAttachmentTrigger on EmailMessage (after update, before update) {
    
    TriggerHandlerObj trigObj = new TriggerHandlerObj();
    trigObj.TriggerObject = 'EmailMessage';        // reference the trigger object here
    trigObj.IsBefore = trigger.IsBefore;
    trigObj.IsDelete = trigger.IsDelete;
    trigObj.IsAfter =  trigger.IsAfter;
    trigObj.IsInsert = trigger.IsInsert;
    trigObj.IsUpdate = trigger.IsUpdate;
    trigObj.IsUndelete = trigger.IsUndelete;        
    trigObj.IsExecuting = trigger.IsExecuting;
    trigObj.newList = trigger.new;
    trigObj.newMap = trigger.newmap;
    trigObj.oldList = trigger.old;
    trigObj.oldMap = trigger.oldmap;
    CentralDispatcher.mainEntry(trigObj);
    
    
   /* if (Trigger.isUpdate) {
         for(EmailMessage msg : Trigger.new) {
             Id msgId = msg.Id;
             if(msgId == null){
                 return;
             }
             System.debug(msgId);
             
             EmailMessage msgObj = [SELECT ParentId, Parent.CaseNumber, Image_Attachment_URL__c, Video_Attachment_URL__c, Other_Attachment_URL__c, Vesync_APP_Image_URLs__c  FROM EmailMessage WHERE Id =:msgId Limit 1].get(0);
             System.debug('msgObj:' + msgObj);
             
             String CaseNumber = msgObj.Parent.CaseNumber;
             String Image_Attachment_URL_current = msgObj.Image_Attachment_URL__c;
             String Video_Attachment_URL_current = msgObj.Video_Attachment_URL__c;
             String Other_Attachment_URL_current = msgObj.Other_Attachment_URL__c;

             if (Trigger.isBefore) {
                 // Process before insert
                 System.debug('isBefore update'); 
                 
                 // Update EmailMessage fields
                 // =============Has_Image_Video_Attachments__c ===============
                 Boolean has_image_video_attachment = false;
                 if(msgObj.Vesync_APP_Image_URLs__c != '' || Image_Attachment_URL_current  != '' || Video_Attachment_URL_current  != ''){
                     has_image_video_attachment = true;
                 }
                 System.debug('has_image_video_attachment:' + has_image_video_attachment);
                 msg.Has_Image_Video_Attachments__c = has_image_video_attachment;
                 
             } else if (Trigger.isAfter) {
                 // Process after insert
                 System.debug('isAfter update');      

                 ContentDocumentLink[] attachments = [SELECT Id, ContentDocumentId, ContentDocument.FileExtension FROM ContentDocumentLink where LinkedEntityId =:msgId limit 200];
                 System.debug(attachments);
                 
                 List<string> contentVideoUrls = new List<string>();
                 List<string> contentImageUrls = new List<string>();
                 List<string> contentOtherUrls = new List<string>();
                 List<string> imageExtentions = new List<string>{'bmp', '.gif', 'jpeg','jpg', 'png', 'tif', 'tiff', 'vsd'};
                 List<string> videlExtentions = new List<string>{'vi', 'mov', 'mpeg','mpg', 'swf', 'mp4'};
                 for(ContentDocumentLink link : attachments){
                     Id ContentDocumentId = link.ContentDocumentId;
                     String FileExtension = link.ContentDocument.FileExtension;
                     System.debug(link);
                     ContentVersion[] CVs = [SELECT Id, VersionDataUrl FROM ContentVersion WHERE ContentDocumentId =:ContentDocumentId limit 200];
                     System.debug(CVs);
                     for (ContentVersion CV : CVs) {
                         String url = CV.VersionDataUrl;
                         System.debug(url);
                         if(imageExtentions.contains(FileExtension)){
                             contentImageUrls.add(url);
                         }
                         if(videlExtentions.contains(FileExtension)){
                             contentVideoUrls.add(url);
                         }
                         if(imageExtentions.contains(FileExtension) == false && videlExtentions.contains(FileExtension)== false){
                             contentOtherUrls.add(url);
                         }
                     }
                 }
                 
                 String new_Image_Attachment_URL = string.join(contentImageUrls,',');
                 String new_Video_Attachment_URL = string.join(contentVideoUrls,',');
                 String new_Other_Attachment_URL = string.join(contentOtherUrls,',');
                 
                 // get org info
                 Organization org = [SELECT Id, Name, OrganizationType, IsSandbox, InstanceName FROM Organization].get(0);
                 System.debug('org:' + org);
                 
                 // =============Image_Attachment_URL__c ===============
                 if(new_Image_Attachment_URL != '' && Image_Attachment_URL_current == null){
                     uploadFileToS3ServiceAndReturnPreSignedUrlParams ImageObj =  new uploadFileToS3ServiceAndReturnPreSignedUrlParams();
                     ImageObj.sf_urls = new_Image_Attachment_URL;
                     ImageObj.sf_callback_field_id = 'Image_Attachment_URL__c';
                     ImageObj.sf_org_id = org.Id;
                     ImageObj.sf_case_number = CaseNumber;
                     ImageObj.sf_email_message_id = msgId;
                     System.debug('ImageObj:' + ImageObj);
                     String jsonStr = JSON.serialize(ImageObj);
                     netsuiteNodeClass.asyncCallout('https://erp-spapi.itekcity.com/salesforce_service/uploadFileToS3ServiceAndReturnPreSignedUrl', jsonStr);
                 }
                 // =============Video_Attachment_URL__c ===============
                 if(new_Video_Attachment_URL != '' && Video_Attachment_URL_current == null){
                     uploadFileToS3ServiceAndReturnPreSignedUrlParams ImageObj =  new uploadFileToS3ServiceAndReturnPreSignedUrlParams();
                     ImageObj.sf_urls = new_Video_Attachment_URL;
                     ImageObj.sf_callback_field_id = 'Video_Attachment_URL__c';
                     ImageObj.sf_org_id = org.Id;
                     ImageObj.sf_case_number = CaseNumber;
                     ImageObj.sf_email_message_id = msgId;
                     System.debug('VideoObj:' + ImageObj);
                     String jsonStr = JSON.serialize(ImageObj);
                     netsuiteNodeClass.asyncCallout('https://erp-spapi.itekcity.com/salesforce_service/uploadFileToS3ServiceAndReturnPreSignedUrl', jsonStr);
                 }
                 // =============Other_Attachment_URL__c ===============
                 if(new_Other_Attachment_URL != '' && Other_Attachment_URL_current == null){
                     uploadFileToS3ServiceAndReturnPreSignedUrlParams ImageObj =  new uploadFileToS3ServiceAndReturnPreSignedUrlParams();
                     ImageObj.sf_urls = new_Other_Attachment_URL;
                     ImageObj.sf_callback_field_id = 'Other_Attachment_URL__c';
                     ImageObj.sf_org_id = org.Id;
                     ImageObj.sf_case_number = CaseNumber;
                     ImageObj.sf_email_message_id = msgId;
                     System.debug('OtherObj:' + ImageObj);
                     String jsonStr = JSON.serialize(ImageObj);
                     netsuiteNodeClass.asyncCallout('https://erp-spapi.itekcity.com/salesforce_service/uploadFileToS3ServiceAndReturnPreSignedUrl', jsonStr);
                 }
                 
 
                 // Update CASE information
                 Id caseId = msgObj.ParentId;
                 Case caseObj = [SELECT Id, First_Reply_Time__c,Last_Reply_Time__c, Has_Image_Video_Attachments__c FROM Case WHERE Id =:caseId Limit 1].get(0);
                 System.debug('caseObj:' + caseObj);
                 
                 EmailMessage[] messages = [SELECT Id, CreatedDate, Incoming, Has_Image_Video_Attachments__c FROM EmailMessage where ParentId =:caseId order by CreatedDate asc limit 200];
                 System.debug('messages:' + messages);
                 
                 // Get all emailMessage list
                 // == First Reply Time
                 // caseObj.First_Reply_Time__c = messages[];
                 
                 Integer firstReplyMessageFound = 0;
                 for(EmailMessage m : messages){
                     System.debug('m1:' + m);
                     if(m.Incoming == false){
                          firstReplyMessageFound ++;
                         if(firstReplyMessageFound == 1){
                             caseObj.First_Reply_Time__c = m.CreatedDate;
                         }
                         caseObj.Last_Reply_Time__c = m.CreatedDate;
                     }
                     
                     if(m.Has_Image_Video_Attachments__c == true && caseObj.Has_Image_Video_Attachments__c == false){
                         caseObj.Has_Image_Video_Attachments__c = true;
                     }
                     
                     System.debug('firstReplyMessageFound:' + firstReplyMessageFound);
                     System.debug('caseObj:' + caseObj);
                 }

                 
                 update caseObj;
             }
         }
    }
    
    
    
    
   class uploadFileToS3ServiceAndReturnPreSignedUrlParams {
        public String sf_urls; 
        public String sf_callback_field_id;
        public String sf_org_id;
        public String sf_case_number;
        public String sf_email_message_id;
    }*/
}