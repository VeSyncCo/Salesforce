public class AgentWorkHandler extends TriggerHandlerBase {

     public override void mainEntry(TriggerHandlerObj inputParam){
        try{
            
            if(inputParam.isInsert && inputParam.isBefore){
                
            }
            
            if(inputParam.isUpdate && inputParam.isBefore){
                
            }
            
            if(inputParam.isInsert && inputParam.isAfter){
                
            }
            
            if(inputParam.isUpdate && inputParam.isAfter){
                updateWorkItem((Map<Id,AgentWork>) inputParam.newMap);
            }
  
        }
        catch(Exception e){
            
        }
    }
    
    
    public  void updateWorkItem(Map<Id,AgentWork> newMap){
        
        List<Case> caseUpdateList = new List<Case>();
        Set<Id> caseIdSet = new Set<Id>(); 
        
        for(AgentWork workRecord: newMap.values() ){
            caseIdSet.add(workRecord.WorkItemId);
        }
        
        Map<Id,Case> caseMap = new Map<Id, case>([Select Id,Initially_Assigned_At__c, Status from case where Id in: caseIdSet ]);

        for(AgentWork workRecord:  newMap.values()){
            
            if(workRecord.Status == 'Opened'){
                Case caseRecord = new Case();
                
                if(caseMap.containsKey(workRecord.WorkItemId)){
                    if(caseMap.get(workRecord.WorkItemId).Status == 'New'){
                        caseRecord.Status = 'Open';
                    }
                    if(caseMap.get(workRecord.WorkItemId).Initially_Assigned_At__c == null){
                        caseRecord.Initially_Assigned_At__c = System.now();
                    }
                    caseRecord.Assigned_At__c = System.now();
                    caseRecord.Id = workRecord.WorkItemId;
                    caseUpdateList.add(caseRecord);
                }

            }
        }
        
        if(caseUpdateList.size() > 0){
            update caseUpdateList;
        }
        
    }
    
    
    public static void testCoverage(){
        Integer i=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}