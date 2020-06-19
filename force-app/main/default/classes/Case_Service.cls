/**
 * @author          Adesso
 * @description     Service Class, where I manage every funcionality related with the Case object
 * @history         2020/06/19   |  Adesso  |  Creation.
 */
public with sharing class Case_Service {
    /**
     * @description     I simply create a case.
     * @param           accountId The id of the account that will be related with the Case.
     * @return          The created Case.
     */
    public static Case createCase(String accountId){
        Case cs = new Case();
        cs.AccountId = accountId;
        cs.Status = 'New';
        cs.Origin = 'Web';
        insert cs;
        return cs;
    }
}