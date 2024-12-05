trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    
    if(Trigger.IsInsert){
        if(Trigger.IsAfter){
            TriggerHandlerObj trigObj = new TriggerHandlerObj();
            trigObj.TriggerObject = 'ContentDocumentLink';        // reference the trigger object here
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
        }
    }
    
}