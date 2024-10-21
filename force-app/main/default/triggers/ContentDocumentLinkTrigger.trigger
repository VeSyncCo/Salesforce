trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    
    if(Trigger.IsInsert){
        if(Trigger.IsAfter){
            ContentDocumentLinkHandler.publishPlatformEvent(Trigger.newMap);
        }
    }

}