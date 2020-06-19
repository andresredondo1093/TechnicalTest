/**
 * @author          Adesso
 * @description     Controller Class, where I manage every funcionality related with 'customer_Transactions' LWC
 * @history         2020/06/19   |  Adesso  |  Creation.
 */
public with sharing class Customer_Transaction_Ctrl {
    /**
     * @description     I get the customer transacion data, I get the external Id and I call the ws that provide me that info.
     * @param           recordId The id of the acurrent account.
     * @return          The Ws response.
     */
    @AuraEnabled(cacheable=true)
    public static String getCustomerTransaction(String recordId){
        String externalId = Account_Selector.getAccountExternalId(recordId);
        String response = WS_TransacionAPI_Token.getCustomTransaction(externalId);
        return response;
    }

    /**
     * @description     I create the Case and the related adjustment and I call the WS that creates the adjustment in the master data system.
     * @param           recordId The id of the acurrent account.
     */
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