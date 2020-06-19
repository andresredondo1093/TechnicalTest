public with sharing class Case_Service {
    public static Case createCase(String accountId){
        Case cs = new Case();
        cs.AccountId = accountId;
        cs.Status = 'New';
        cs.Origin = 'Web';
        insert cs;
        return cs;
    }
}