@IsTest
public class AgentWorkHandlerTest {
    @TestSetup
    static void setupTestData() {
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            caseList.add(new Case(
                Subject = 'Test Case ' + i,
                Status = 'New',
                Origin = 'Web',
                Brand__c='Levoit',
                Country__c='United States Of America',
                OwnerId=UserInfo.getUserId(),
                Priority='Medium',
                Description='this record is for test class purpose'  
            ));
        }
        insert caseList;
        Set<Id> testCaseID = new Set<Id>();
        for (Case c : caseList) {
            testCaseID.add(c.Id);
        }
        
        
        
    }
    @IsTest
    static void testMainEntry(){
        ServiceChannel channel = [Select Id from ServiceChannel limit 1];
        Group gr = [Select Id,name, QueueRoutingConfigId from Group where QueueRoutingConfigId != null limit 1];
      	
        AgentWorkHandler.testCoverage();
    }
}