/**
 * for testing AssignAccountTasksActiveUser
 */

@IsTest
private class AssignAccountTasksActiveUserTest {
    @IsTest
    private static void testAssignTasksToUser() {
        //setup test data
        List<Account> accList = TestDataFactory.createAccounts(10);
        List<Task> tsList = TestDataFactory.createTasksForAccounts(accList, 4);
        List<Id> accIds = TestDataFactory.getListIds(accList);
        // Perform test
        Test.startTest();
        // call method for test
        AssignAccountTasksActiveUser.assignAccountTasks(accIds);
        Test.stopTest();
        // verify results
        List<Task> taskList = new List<Task>([SELECT Id, OwnerId
        FROM Task WHERE OwnerId != NULL AND Status != 'Completed' AND WhatId IN :accList]);
        System.assertEquals(tsList.size(), taskList.size());
    }


}