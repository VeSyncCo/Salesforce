public class ContentDocumentLinkHandler extends TriggerHandlerBase {
    
    
    public override void mainEntry(TriggerHandlerObj inputParam){
        try{
            
            if(inputParam.isInsert && inputParam.isBefore){
                
            }
            
            if(inputParam.isUpdate && inputParam.isBefore){
                
            }
            
            if(inputParam.isInsert && inputParam.isAfter){
                publishPlatformEvent((Map<Id,ContentDocumentLink>)inputParam.newMap);
            }
            
            if(inputParam.isUpdate && inputParam.isAfter){
                
            }
  
        }
        catch(Exception e){
            
        }
    }
    
    
    public void publishPlatformEvent(Map<Id,ContentDocumentLink> newMap){
        List<Case_Attachment_Event__e> eventList = new List<Case_Attachment_Event__e>();
        List<ContentVersion > versionDataList = new List<ContentVersion>();
        Set<Id> caseDocumentIdSet = new Set<Id>();
        Set<Id> caseLinkIdSet = new Set<Id>();
        Set<Id> caseIdSet = new Set<Id>();
        for(ContentDocumentLink contentLink : newMap.Values()){
            if(String.valueOf(contentLink.LinkedEntityId.getSobjectType()) == 'Case'){
                caseDocumentIdSet.add(contentLink.ContentDocumentId);
                caseLinkIdSet.add(contentLink.Id);
                caseIdSet.add(contentLink.LinkedEntityId);
            }
        }
        system.debug(caseLinkIdSet);
        Map<Id, ContentDocument> contentDocumentMap = new Map<Id, ContentDocument>([SELECT Id,title,LatestPublishedVersionId FROM ContentDocument WHERE Id in: caseDocumentIdSet ]);
        Map<Id, Case> caseMap =new Map<Id, Case>([SELECT Id, CaseNumber FROM case WHERE ID in: caseIdSet]);
        List<ContentDistribution > distributionLinkList = new List<ContentDistribution >();
    
        
        for(Id caseLink : caseLinkIdSet){
            Case_Attachment_Event__e event  = new Case_Attachment_Event__e();
            event.Case_ID__c = newMap.get(caseLink).LinkedEntityId;
            event.Content_Document_ID__c = contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).Id;
            event.Content_Version_ID__c = contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).LatestPublishedVersionId;
            event.Case_Number__c = caseMap.get(newMap.get(caseLink).LinkedEntityId).CaseNumber;
            eventList.add(event);
            
            ContentDistribution  distributionLink = new ContentDistribution();
            distributionLink.ContentVersionId =contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).LatestPublishedVersionId;
            distributionLink.Name = contentDocumentMap.get(newMap.get(caseLink).ContentDocumentId).title;
            distributionLinkList.add(distributionLink);
        }
        
        Insert distributionLinkList;
        
        if(eventList.size() > 0){
            
            EventBus.publish(eventList);
        }
    }
}