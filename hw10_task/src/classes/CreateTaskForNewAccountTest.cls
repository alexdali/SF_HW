/**
 * for testing CreateTaskForNewAccount
 */

@IsTest
private class CreateTaskForNewAccountTest {
    @IsTest
    private static void testCreateTaskForAccount() {
        //setup test data
        List<Account> accList = TestDataFactory.createAccounts(10);
        List<Id> accIds = TestDataFactory.getListIds(accList);
        // Perform test
        Test.startTest();
        // call method for test
        CreateTaskForNewAccount.createTaskForAccount(accIds);
        Test.stopTest();
        // Verify
        List<Task> tsList = [SELECT Id, Subject
                            FROM Task
                            WHERE Subject LIKE 'Negotiations with %' AND WhatId IN :accIds];
        System.assertEquals(tsList.size(), accIds.size());
    }
}