/**
 * for testing TriggerOnceRun
 */

@IsTest
private class TriggerOnceRunTest {
    @IsTest static void TestCreateTaskWhenUpdateAccount() {
        // Test data setup
        List<Account> accList = TestDataFactory.createAccounts(10);
        // Perform test
        Test.startTest();
        for (Account acc : accList) {
            acc.BillingState='CA';
        }
        update accList;
        Test.stopTest();
        // Verify
        System.assert(ForTriggerRunRestriction.isFirstRun==false);
        List<Task> tsList = [SELECT Id, Subject FROM Task WHERE Subject='Task by once-run trigger'];
        System.assertEquals(10, tsList.size());
    }
}