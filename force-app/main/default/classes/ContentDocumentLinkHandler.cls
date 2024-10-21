public class ContentDocumentLinkHandler extends TriggerHandlerBase {
    
    
    public override void mainEntry(TriggerHandlerObj inputParam){
        try{
            
            if(inputParam.isInsert && inputParam.isBefore){
                
            }
            
            if(inputParam.isUpdate && inputParam.isBefore){
                
            }
            
            if(inputParam.isInsert && inputParam.isAfter){
                
            }
            
            if(inputParam.isUpdate && inputParam.isAfter){
                
            }
  
        }
        catch(Exception e){
            
        }
    }
    
    
    public Static void publishPlatformEvent(Map<Id,ContentDocumentLink> newMap){
        List<Case_Attachment_Event__e> eventList = new List<Case_Attachment_Event__e>();
        List<ContentVersion > versionDataList = new List<ContentVersion>();
        Set<Id> caseDocumentIdSet = new Set<Id>();
        Set<Id> caseLinkIdSet = new Set<Id>();
        for(ContentDocumentLink contentLink : newMap.Values()){
            if(String.valueOf(contentLink.LinkedEntityId.getSobjectType()) == 'Case'){
                caseDocumentIdSet.add(contentLink.ContentDocumentId);
                caseLinkIdSet.add(contentLink.Id);
            }
        }
        Map<Id, ContentDocument> contentDocumentMap = new Map<Id, ContentDocument>([Select Id,title,LatestPublishedVersionId from ContentDocument where Id in: caseDocumentIdSet ]);
        List<ContentDistribution > distributionLinkList = new List<ContentDistribution >();
    
        
        for(Id caseLink : caseLinkIdSet){
            Case_Attachment_Event__e event  = new Case_Attachment_Event__e();
            event.Case_ID__c = newMap.get(caseLink).LinkedEntityId;
            event.Content_Document_ID__c = contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).Id;
            event.Content_Version_ID__c = contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).LatestPublishedVersionId;
            eventList.add(event);
            
            ContentDistribution  distributionLink = new ContentDistribution();
            distributionLink.ContentVersionId =contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).LatestPublishedVersionId;
            distributionLink.Name = contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).title;
            distributionLinkList.add(distributionLink);
        }
        
        Insert distributionLinkList;
        
        if(eventList.size() > 0){
            system.debug(eventList);
            EventBus.publish(eventList);
        }
    }
}