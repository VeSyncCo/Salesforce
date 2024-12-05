public without sharing virtual class TriggerHandlerBase {

    public class NotImplementedException extends Exception{}
    
    public virtual void mainEntry(TriggerHandlerObj inputParam){        
        throw new NotImplementedException('Error Not Implemented');
    }
    
    public virtual void inProgressEntry(TriggerHandlerObj inputParam){
        try{  
            
            String typeName = inputParam.TriggerObject + Constants.HANDLERSUFFIX;
            
            Type t = Type.forName('',typeName);
            TriggerHandlerBase activeFunction = (TriggerHandlerBase)t.newInstance();            
            
            CentralDispatcher.activeFunction = activeFunction;    
            activeFunction.mainEntry(inputParam);            
            
            CentralDispatcher.activeFunction = this;
            
        }catch(Exception e) {
            system.debug('Message'+e.getLineNumber()+e.getMessage());
        }
    }
    
}