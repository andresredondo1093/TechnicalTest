public with sharing class Account_Selector {
    public static string getAccountExternalId(String recordId){
        return [Select External_Id__c from account where id =: recordId].External_Id__c;
    }
}