public class WarrantyPicklistController {
    
    @Auraenabled
    public Static case getCaseDetails(Id recordId){
        
        try{
            Case caseRecord = [Select Id,Main_Category__c, Alleged_Issue__c, Detail__c, SubDetail__c from case where Id =: recordId];
            
            return caseRecord;
        }
        catch(Exception e){
            system.debug(e.getmessage());
        }
        return null;
    } 
    
    @AuraEnabled
    public static wrapper returnPicklistValues(Id recordId, String mainCategory, String allegedIssue, String detail, String subDetail ){
        Case caseRecord= [Select Brand__c, Product_Category__c from case where Id=: recordId];
        
        if(caseRecord.Brand__c == '' || caseRecord.Brand__c == null || caseRecord.Product_Category__c == ''  || caseRecord.Product_Category__c == null){
            return null;
        }
        else{
            List<String> mainCatgeoryValues = new List<String>();
            List<String> allegedIssueValues = new List<String>();
            List<String> detailValues = new List<String>();
            List<String> subDetailValues = new List<String>();
            
            for(Case_Picklist_Mapping__c mapValue : [Select Main_Category__c from Case_Picklist_Mapping__c where Warranty_Mapping__c = true AND Brand__c = :caseRecord.Brand__c AND(Product_Category__c = :caseRecord.Product_Category__c OR Product_Category__c LIKE 'All%') order by Main_Category__c ]){
                if(!mainCatgeoryValues.contains(mapValue.Main_Category__c)){
                    mainCatgeoryValues.add(mapValue.Main_Category__c);
                }
            }
            
            if(mainCategory != null && mainCategory != ''){
                for(Case_Picklist_Mapping__c mapValue : [Select Alleged_Issue__c from Case_Picklist_Mapping__c where Warranty_Mapping__c = true AND Brand__c = :caseRecord.Brand__c AND Main_Category__c =:mainCategory  AND(Product_Category__c = :caseRecord.Product_Category__c OR Product_Category__c LIKE 'All%') order by Alleged_Issue__c ]){
                    if(!allegedIssueValues.contains(mapValue.Alleged_Issue__c)){
                        allegedIssueValues.add(mapValue.Alleged_Issue__c);
                    }
                }
                
                if(allegedIssue != null && allegedIssue != ''){
                    for(Case_Picklist_Mapping__c mapValue : [Select Detail__c from Case_Picklist_Mapping__c where Warranty_Mapping__c = true AND Brand__c = :caseRecord.Brand__c AND Main_Category__c =:mainCategory AND Alleged_Issue__c =: allegedIssue   AND(Product_Category__c = :caseRecord.Product_Category__c OR Product_Category__c LIKE 'All%') order by Detail__c ]){
                        if(!detailValues.contains(mapValue.Detail__c)){
                            detailValues.add(mapValue.Detail__c);
                        }
                    }
                    
                    if(detail != null && detail != ''){
                        for(Case_Picklist_Mapping__c mapValue : [Select Sub_Detail__c from Case_Picklist_Mapping__c where Warranty_Mapping__c = true AND Brand__c = :caseRecord.Brand__c AND Main_Category__c =:mainCategory AND Alleged_Issue__c =: allegedIssue AND Detail__c =:detail   AND(Product_Category__c = :caseRecord.Product_Category__c OR Product_Category__c LIKE 'All%') order by Sub_Detail__c ]){
                            if(!subDetailValues.contains(mapValue.Sub_Detail__c)){
                                subDetailValues.add(mapValue.Sub_Detail__c);
                            }
                        }
                    }
                }
            }
            
            Wrapper wrap = new Wrapper();
            wrap.mainCategoryValueSet = mainCatgeoryValues;
            wrap.allegedIssueValueSet = allegedIssueValues;
            wrap.detailValueSet = detailValues;
            wrap.subDetailValueSet = subDetailValues;
            
            return wrap;
            
        }
        
        
    }
    
    
    public Class wrapper{
        @auraEnabled public List<String> mainCategoryValueSet;
        @auraEnabled public List<String> allegedIssueValueSet ;
        @auraEnabled public List<String> detailValueSet ;
        @auraEnabled public List<String> subDetailValueSet;
        
        public wrapper(){
            //typeValueSet = new List<String>();
            mainCategoryValueSet = new List<String>();
            allegedIssueValueSet = new List<String>();
            detailValueSet = new List<String>();
            subDetailValueSet = new List<String>(); 
        }
    }
    
    @AuraEnabled
    public static String saveCaseRecord(Id recordId, String mainCategory, String allegedIssue, String detail, String subDetail ){
        
        try{
            Case caseRecord = [Select Id,Main_Category__c, Alleged_Issue__c, Detail__c, SubDetail__c from case where Id =: recordId];
            
            caseRecord.Main_Category__c =  caseRecord.Main_Category__c != mainCategory ? (mainCategory == ''? null : mainCategory) : caseRecord.Main_Category__c;
            caseRecord.Alleged_Issue__c =  caseRecord.Alleged_Issue__c != allegedIssue ? (allegedIssue == '' ? null : allegedIssue) : caseRecord.Alleged_Issue__c;
            caseRecord.Detail__c =  caseRecord.Detail__c != detail ? (detail == '' ? null: detail) : caseRecord.Detail__c;
            caseRecord.SubDetail__c =  caseRecord.SubDetail__c != subDetail ? (subDetail == ''? null: subDetail) : caseRecord.SubDetail__c;
            
            update caseRecord;
        }
        catch(Exception e){
            return e.getMessage();
        }
        return 'Updated';
    }
    
}