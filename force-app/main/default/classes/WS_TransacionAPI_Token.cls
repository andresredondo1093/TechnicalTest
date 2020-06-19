/**
 * @author          Adesso
 * @description     WS class, where I manage all the ws related with the data master system.
 * @history         2020/06/19   |  Adesso  |  Creation.
 */
public with sharing class WS_TransacionAPI_Token {
    /**
     * @description     I get the token to be authenticate for the rest WS.
     * @return          The token of the WS.
     */
    public static string getToken(){

        String endpoint = 'http://api.example.com/';
        String method = 'GET';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setBody('{token:{"operatorRole":"AGENT"}}');

        for(String aux : headerMap.keySet()){
            req.setHeader(aux, headerMap.get(aux));
        }
		Http http = new Http();
        // HTTPResponse res = http.send(req);
        return 'token';
    }

    /**
     * @description     I get the customer transacion data from the WS
     * @param           customerId The id of the acurrent account.
     * @return          The Ws response.
     */
    public static string getCustomTransaction(String customerId){
        String endpoint = 'https://api.example/accounts/v1/transactions/' + customerId;
        String method = 'GET';

        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        headerMap.put('Authorization', 'Bearer ' + getToken());

        HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
        req.setMethod(method);

        for(String aux : headerMap.keySet()){
            req.setHeader(aux, headerMap.get(aux));
        }
		Http http = new Http();
        // HTTPResponse res = http.send(req);
        return '[ { "iban":"ES4700759339324669344918", "accountStatus":"enabled", "product":"current", "transactions":[ { "resourceId":"1234567890", "name":"Supermarket", "balanceType":"closingBooked", "amount":{ "amount":"215", "currency":"EUR" }, "transactionDate":"2020-04-25T15:30:35.035Z" } ] }, { "iban":"ES4700759339324669344919", "accountStatus":"enabled", "product":"saving", "transactions":[ { "resourceId":"1234567890", "name":"Supermarket", "balanceType":"closingBooked", "amount":{ "amount":"220", "currency":"EUR" }, "transactionDate":"2020-04-26T15:30:35.035Z" } ] } ]';
    }

    /**
     * @description     I Create an adjustment in the data master system.
     * @param           body The body I send in the WS
     * @return          The Ws response.
     */
    public static string postAdjustment(String body){
        String endpoint = 'https://api.example.com/adjustments/v1/adjustment';
        String method = 'POST';

        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        headerMap.put('Authorization', 'Bearer ' + getToken());

        HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setBody(body);

        for(String aux : headerMap.keySet()){
            req.setHeader(aux, headerMap.get(aux));
        }
		Http http = new Http();
        // HTTPResponse res = http.send(req);
        return '182315c3-2913-4a19-9cae-c99784270889';
    }

    /**
     * @description     I Update the current adjustment, also I trigger the approval process and I create a Task for all the users in the group member I recieve.
     * @param           adjustmentId The Id of the adjustment in the data master system
     * @param           status The new status of the adjustment
     * @param           recordId The Id of the adjustment
     */
    @future
    public static void changeStatus(String adjustmentId, String status, String recordId){
        String endpoint = 'https://api.example.com/adjustments//v1/adjustments/' + adjustmentId + '/status/' + status;
        String method = 'PATCH';

        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        headerMap.put('Authorization', 'Bearer ' + getToken());

        HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
        req.setMethod(method);

        for(String aux : headerMap.keySet()){
            req.setHeader(aux, headerMap.get(aux));
        }
		Http http = new Http();
        // HTTPResponse res = http.send(req);
        String response = 'MANAGER';
        List<GroupMember> groupMemList =  [select id, UserOrGroupId from GroupMember where Group.DeveloperName = :response];
        List<Id> userIdList = new List<Id>();

        for(GroupMember gm: groupMemList){
            userIdList.add(gm.UserOrGroupId);
        }

        //call approval process
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        approvalRequest.setComments('New adjustment');
        approvalRequest.setObjectId(recordId);
        approvalRequest.setNextApproverIds(userIdList);
        // Approval.ProcessResult approvalResult = Approval.process(approvalRequest);

        List<Task> taskList = new List<Task>();
        for(Id ugi: userIdList){
            Task tsk = new Task();
            tsk.Subject = 'New adjustment to approve';
            tsk.WhatId = recordId;
            tsk.Description = 'Adjustment Description';
            tsk.ActivityDate = System.today();
            tsk.Priority = 'High';
            tsk.isReminderSet = true;
            tsk.OwnerId = ugi;
            taskList.add(tsk);
        }
        insert taskList;
        
    }
}