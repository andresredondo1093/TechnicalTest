public with sharing class Customer_Transaction_Ctrl {
    @AuraEnabled(cacheable=true)
    public static String getCustomerTransaction(String recordId){
        String externalId = Account_Selector.getAccountExternalId(recordId);
        String response = WS_TransacionAPI_Token.getCustomTransaction(externalId);
        return response;
    }
    
    @AuraEnabled
    public static void postAdjustment(String recordId){
        String externalId = Account_Selector.getAccountExternalId(recordId);
        Case cs = Case_Service.createCase(recordId);

        String externalAdjInprog = WS_TransacionAPI_Token.postAdjustment('{ "AccountId":"' + externalId + '", "amount":{ "amount":"1100", "currency":"EUR" } }');
        String externalAdjClosed = WS_TransacionAPI_Token.postAdjustment('{ "AccountId":"' + externalId + '", "amount":{ "amount":"900", "currency":"EUR" }, "adjustmentStatus":"CLOSED" }');
        
        Adjustment__c adj = Adjusment_Service.createAdjustment(1100, 'IN_PROGRESS', cs.Id, externalAdjInprog);
        Adjustment__c adj2 = Adjusment_Service.createAdjustment(900, 'CLOSED', cs.Id, externalAdjClosed);


    }

}