/**
 * for testing BatchUpdateAccountOwnerInTasks
 */

@IsTest
private class BatchUpdateAccountOwnerInTasksTest {
    @IsTest static void test() {
        // setup test data
        List<Account> accList = TestDataFactory.createAccounts(10);
        List<Task> taskList = TestDataFactory.createTasksForAccounts(accList, 1);
        // Perform Test
        Test.startTest();
        BatchUpdateAccountOwnerInTasks batchUpdate = new BatchUpdateAccountOwnerInTasks();
        Id batchId = Database.executeBatch(batchUpdate);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.debug('Account.size' + [SELECT COUNT() FROM Account WHERE Updated_By_Task__c = TRUE AND Id IN :accList]);
        System.assertEquals(10, [SELECT COUNT() FROM Account WHERE Updated_By_Task__c = TRUE AND Id IN :accList]);
        System.debug('Task.size ' + [SELECT COUNT() FROM Task WHERE Account_Owner__c != NULL AND Id IN :taskList]);
        System.assertEquals(10, [SELECT COUNT() FROM Task WHERE Account_Owner__c != NULL AND Id IN :taskList]);
    }
}