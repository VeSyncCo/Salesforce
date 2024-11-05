public without sharing class CentralDispatcher {

    public static TriggerHandlerBase activefunction = null;    
    
    public static void mainEntry(TriggerHandlerObj inputParam){
        
        boolean triggerEnabled = false;
        String triggerHandlerName = inputParam.TriggerObject + Constants.HANDLERSUFFIX;  
        String triggerName = inputParam.TriggerObject + Constants.TRIGGERSUFFIX;
        
        VeSync_Bypass_Setting__c bypassRecord = VeSync_Bypass_Setting__c.getInstance(userInfo.getUserId());
        
        if(bypassRecord != null){
            Map<String, Object> mapCustomSettings = bypassRecord.getPopulatedFieldsAsMap();   
            
            Boolean bypassAllAutomations =  Boolean.valueOf(mapCustomSettings.get('Bypass_All_Automations__c'));
            String bypassTrigger = String.valueOf(mapCustomSettings.get('Bypass_Trigger__c'));	
            
            triggerEnabled = (bypassAllAutomations == true || bypassTrigger.contains(triggerName)) ? false : true;
        }
        
        if(triggerEnabled){
            try{
                if(activefunction!=null) {
                    activefunction.InProgressEntry(inputParam);
                }
                else{
                    string typeName;
                    typeName = triggerHandlerName;                    
                    Type t = Type.forName('',typeName);
                    activefunction = (TriggerHandlerBase)t.newInstance();                               
                    activefunction.mainEntry(inputParam);
                }
                
            }
            catch(Exception e){
                
            }
        }
    }
}