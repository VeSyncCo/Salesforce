public class CasePicklistController {
    
    @AuraEnabled(cacheable = true)
    public Static case getCaseDetails(Id recordId){
        
        Case caseRecord = [Select Id,
                           Brand__c,
                           Feedback_Type__c,
                           Feedback_Reason__c,
                           Feedback_SubReason__c,
                           Feedback_Detail__c 
                           FROM case 
                           WHERE Id =: recordId];
        
        return caseRecord;
    }
    
    
    
    @AuraEnabled
    public static Wrapper returnPicklistValues(Id recordId, String feedbackType, String reason, String subReason, String detail ){
        Case caseRecord= [Select Brand__c, Product_Category__c from case where Id=: recordId];
        String Brand = caseRecord.Brand__c;  
        
        system.debug(caseRecord);
        if(Brand == '' || Brand == null){
            return null;
        }
        else {
            
            
            List<String> typeValues = new List<String>();
            List<String> reasonValues = new List<String>();
            List<String> subReasonValues = new List<String>();
            List<String> detailValues = new List<String>();
            
            for(Case_Picklist_Mapping__c mapValue : [SELECT Feedback_Type__c 
                                                     FROM Case_Picklist_Mapping__c 
                                                     WHERE Feedback_Mapping__c = TRUE 
                                                     AND Brand__c = :Brand 
                                                     AND (Product_Category__c = :caseRecord.Product_Category__c 
                                                          OR Product_Category__c LIKE 'All%') order by Feedback_Type__c
                                                    ]) {
                                                        if(!typeValues.contains(mapValue.Feedback_Type__c))
                                                            typeValues.add(mapValue.Feedback_Type__c);
                                                    }           
            if(feedbackType != null ){
                for(Case_Picklist_Mapping__c mapValue : [Select  Feedback_Reason__c from Case_Picklist_Mapping__c  WHERE Feedback_Mapping__c = TRUE and Brand__c =: Brand and Feedback_Type__c =: feedbackType AND (Product_Category__c = :caseRecord.Product_Category__c OR Product_Category__c LIKE 'All%')  order by Feedback_Reason__c]){
                    if(!reasonValues.contains(mapValue.Feedback_Reason__c))
                        reasonValues.add(mapValue.Feedback_Reason__c);
                }
                
                if(reason != null){
                    for(Case_Picklist_Mapping__c mapValue : [Select  Feedback_SubReason__c from Case_Picklist_Mapping__c  WHERE Feedback_Mapping__c = TRUE and Brand__c =: Brand and Feedback_Type__c =: feedbackType and  Feedback_Reason__c =: reason AND (Product_Category__c = :caseRecord.Product_Category__c OR Product_Category__c LIKE 'All%') order by Feedback_SubReason__c]){
                        if(!subReasonValues.contains(mapValue.Feedback_SubReason__c))
                            subReasonValues.add(mapValue.Feedback_SubReason__c);
                    }
                    
                    if(subreason != null){
                        for( Case_Picklist_Mapping__c mapValue : [Select  Feedback_Detail__c from Case_Picklist_Mapping__c  WHERE Feedback_Mapping__c = TRUE and Brand__c =: Brand and Feedback_Type__c =: feedbackType and  Feedback_Reason__c =: reason AND Feedback_SubReason__c =:subReason AND (Product_Category__c = :caseRecord.Product_Category__c OR Product_Category__c LIKE 'All%') order by Feedback_Detail__c ]){
                            if(!detailValues.contains(mapValue.Feedback_Detail__c))
                                detailValues.add(mapValue.Feedback_Detail__c);
                        }
                    }
                }
            }
            
            Wrapper wrap = new Wrapper();
            wrap.typeValueSet = typeValues;
            wrap.reasonValueSet = reasonValues;
            wrap.subreasonValueSet = subReasonValues;
            wrap.detailValueSet = detailValues;
            
            return wrap;
        }
        
        
    }
    
    @AuraEnabled
    public static String saveCaseRecord(Id caseId, String feedbackType, String reason, String subReason, String detail ){
        
        try{
            
            Case caseRecord = [Select Id,
                               Brand__c,
                               Feedback_Type__c,
                               Feedback_Reason__c,
                               Feedback_SubReason__c,
                               Feedback_Detail__c 
                               FROM case 
                               WHERE Id =: caseId];
            
            caseRecord.Feedback_Type__c =  caseRecord.Feedback_Type__c != feedbackType ? (feedbackType == ''? null : feedbackType) : caseRecord.Feedback_Type__c;
            caseRecord.Feedback_Reason__c =  caseRecord.Feedback_Reason__c != reason ? (reason == '' ? null : reason) : caseRecord.Feedback_Reason__c;
            caseRecord.Feedback_SubReason__c =  caseRecord.Feedback_SubReason__c != subReason ? (subReason == '' ? null: subReason) : caseRecord.Feedback_SubReason__c;
            caseRecord.Feedback_Detail__c =  caseRecord.Feedback_Detail__c != detail ? (detail == ''? null: detail) : caseRecord.Feedback_Detail__c;
            
            update caseRecord;
        }
        catch(Exception e){
            return e.getMessage();
        }
        
        return 'Updated';
        
    }
    
    
    public Class wrapper{
        @auraEnabled public List<String> typeValueSet;
        @auraEnabled public List<String> reasonValueSet ;
        @auraEnabled public List<String> subreasonValueSet ;
        @auraEnabled public List<String> detailValueSet;
        
        public wrapper(){
            typeValueSet = new List<String>();
            reasonValueSet = new List<String>();
            subreasonValueSet = new List<String>();
            detailValueSet = new List<String>();
            
        }
    }
}