public class deleteCase {
    
    public static void deleteCaseList(){
    List<case> caseList = [select id, Origin from case where Origin = 'Email'];
    
    delete caseList;
    }
    
    

}