trigger Adjustment_Trigger on Adjustment__c (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            Adjusment_Service.afterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        
    }
}