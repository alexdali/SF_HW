/**
 * Task description:
 *
 * On the 1st org:
 * - Implement REST web service with
 * @HttpGet, @HttpPost, @HttpDelete, @HttpPut, @HttpPatch
 * methods for the Account object
 * (get, create, delete, upsert, update Account record)
 */

@RestResource(UrlMapping='/Accounts/*')
global with sharing class AccountRestManager {
    @HttpGet
    global static Account getAccountById() {
        RestRequest request = RestContext.request;
        // grab the accId from the end of the URL
        String accId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        Account result =  [SELECT Id, Name, AccountNumber, Phone
        FROM Account
        WHERE Id = :accId];
        return result;
    }
    @HttpPost
    global static String postAccount(String name, String accNumber, String phone) {
        Account account = new Account();
        account.Name = name;
        account.Phone = phone;
        account.AccountNumber = accNumber;
        insert account;
        return account.Id;
    }
    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id = :accId];
        delete thisAccount;
    }
    @HttpPut
    global static Id upsertAccount(String name, String accNumber,
            String phone, String id) {
        Account thisAccount = new Account(
                Id=id,
                Name=name,
                AccountNumber=accNumber,
                Phone=phone);
        // Match Account by Id, if present.
        // Otherwise, create new Account.
        upsert thisAccount;
        // Return the Account ID.
        return thisAccount.Id;
    }
    @HttpPatch
    global static Id updateAccountFields() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id = :accId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Account sObject
            thisAccount.put(fieldName, params.get(fieldName));
        }
        update thisAccount;
        return thisAccount.Id;
    }
}