/**
 * @author          Adesso
 * @description     Service Class, where I manage every funcionality related with the adjustment__c object
 * @history         2020/06/19   |  Adesso  |  Creation.
 */
public with sharing class Adjusment_Service {
    public static final string PENDING_ACCEPTED = 'PENDING_ACCEPTED';
    /**
     * @description     I create an adjustment.
     * @param           amount The amount of the current adjustment
     * @param           status The status of the current adjustment
     * @param           caseId The caseId of the current adjustment
     * @param           externalId The externalId of the current adjustment
     * @return          The Adjustment__c that I have been created.
     */
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

    /**
     * @description     AdterUpdate method, where I manage and orchestrate the logic of the after update Adjustment__c trigger.
     * @param           oldMap The Trigger.oldMap Trigger context variable. A map of IDs to the old versions of the Adjustment__c records.
     * @param           newMap The Trigger.newMap Trigger context variable. A map of IDs to the new versions of the Adjustment__c records.
     */
    public static void afterUpdate(Map<Id, Adjustment__c> newMap, Map<Id, Adjustment__c> oldMap){
            if(newMap.values().get(0).Amount__c > 1000 && PENDING_ACCEPTED.equals(newMap.values().get(0).Status__c) && !PENDING_ACCEPTED.equals(oldMap.values().get(0).Status__c)){
                WS_TransacionAPI_Token.changeStatus(newMap.values().get(0).External_Id__c, newMap.values().get(0).Status__c, newMap.values().get(0).Id);
            }
    }
}