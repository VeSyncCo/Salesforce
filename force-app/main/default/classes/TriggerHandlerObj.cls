public class TriggerHandlerObj {
	public String triggerObject {get;set;}
    public Boolean isBefore {get;set;}
    public Boolean isDelete {get;set;}
    public Boolean isAfter{get;set;}
    public Boolean isInsert {get;set;}
    public Boolean isUpdate {get;set;}		
    public Boolean isUndelete {get;set;}
    public Boolean isExecuting {get;set;}
    public List<SObject> newList {get;set;}
    public Map<ID, SObject> newMap {get;set;}
    public List<SObject> oldList {get;set;}
    public Map<ID,SObject> oldMap {get;set;}
}