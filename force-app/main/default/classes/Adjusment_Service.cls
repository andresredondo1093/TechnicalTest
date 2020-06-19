public with sharing class Adjusment_Service {
    public static final string PENDING_ACCEPTED = 'PENDING_ACCEPTED';

    public static Adjustment__c createAdjustment(Integer amount, String status, String caseId, String externalId){
        Adjustment__c adj = new Adjustment__c();
        adj.Name = 'Adjustment';
        adj.Amount__c = amount;
        adj.Status__c = status;
        adj.Case__c = caseId;
        adj.External_Id__c = externalId;
        insert adj;
        return adj;
    }

    public static void afterUpdate(Map<Id, Adjustment__c> newMap, Map<Id, Adjustment__c> oldMap){
            if(newMap.values().get(0).Amount__c > 1000 && PENDING_ACCEPTED.equals(newMap.values().get(0).Status__c) && !PENDING_ACCEPTED.equals(oldMap.values().get(0).Status__c)){
                WS_TransacionAPI_Token.changeStatus(newMap.values().get(0).External_Id__c, newMap.values().get(0).Status__c, newMap.values().get(0).Id);
            }
    }
}