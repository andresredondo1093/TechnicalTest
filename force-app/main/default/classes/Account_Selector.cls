/**
 * @author          Adesso
 * @description     Select class when I manage every database access related with the Account object
 * @history         2020/06/19   |  Adesso  |  Creation.
 */
public with sharing class Account_Selector {
    /**
     * @description     I get the External_Id__c field of the Account giving the record Id.
     * @param           recordId The id of the current Account
     * @return          the External_Id__c of the account record.
     */
    public static string getAccountExternalId(String recordId){
        return [Select External_Id__c from account where id =: recordId].External_Id__c;
    }
}