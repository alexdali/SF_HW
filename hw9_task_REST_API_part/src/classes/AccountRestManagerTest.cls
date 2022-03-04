/**
 * Task description:
 *
 * Test the integration between two orgs.
 * Test Apex REST class
 */

@IsTest
private class AccountRestManagerTest {

    private static String baseEndpoint = 'https://mytest69-dev-ed.my.salesforce.com/services/apexrest/Accounts/';

    @IsTest static void testGetAccountById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = baseEndpoint + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountRestManager.getAccountById();
        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals('Test record', thisAccount.Name);
    }
    @IsTest static void testPostAccount() {
        // Call the method to test
        Id thisAccountId = AccountRestManager.postAccount(
                'Test PostAccount', 'NewTestPost', '000000000');
        // Verify results
        System.assert(thisAccountId != null);
        Account thisAccount = [SELECT Id,Name FROM Account WHERE Id=:thisAccountId];
        System.assert(thisAccount != null);
        System.assertEquals(thisAccount.Name, 'Test PostAccount');
    }
    @IsTest static void testDeleteAccount() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = baseEndpoint + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        AccountRestManager.deleteAccount();
        // Verify record is deleted
        List<Account> accList = [SELECT Id FROM Account WHERE Id=:recordId];
        System.assert(accList.size() == 0);
    }
    @IsTest static void testUpsertAccount() {
        // 1. Insert new record
        Id acc1Id = AccountRestManager.upsertAccount(
                'Test PutAccount', 'NewTestPost', '000000000', null);
        // Verify new record was created
        System.assert(acc1Id != null);
        Account acc1 = [SELECT Id,Name FROM Account WHERE Id=:acc1Id];
        System.assert(acc1 != null);
        System.assertEquals(acc1.Name, 'Test PutAccount');
        // 2. Update status of existing record to Working
        Id acc2Id = AccountRestManager.upsertAccount(
                'Test PutAccount2', 'NewTestPost', '000000000', acc1Id);
        // Verify record was updated
        System.assertEquals(acc1Id, acc2Id);
        Account acc2 = [SELECT Id,Name FROM Account WHERE Id=:acc2Id];
        System.assert(acc2 != null);
        System.assertEquals(acc2.Name, 'Test PutAccount2');
    }
    @IsTest static void testUpdateAccountFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = baseEndpoint + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name": "Test PatchAccount"}');
        RestContext.request = request;
        // Update Name of existing record
        Id thisAccountId = AccountRestManager.updateAccountFields();
        // Verify record was updated
        System.assert(thisAccountId != null);
        Account thisAccount = [SELECT Id,Name FROM Account WHERE Id=:thisAccountId];
        System.assert(thisAccount != null);
        System.assertEquals(thisAccount.Name, 'Test PatchAccount');
    }
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Account accountTest = new Account(
                Name='Test record',
                AccountNumber='New00000000',
                Phone='00000000');
        insert accountTest;
        return accountTest.Id;
    }
}