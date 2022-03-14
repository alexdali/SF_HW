/**
 * for testing ScheduledJobForTwoBatchFromTask1
 */

@IsTest
private class ScheduledJobForTwoBatchFromTask1Test {
    // Dummy CRON expression: every midnight.
    public static String CRON_EXP = '0 0 0 * * ?';
    @TestSetup
    static void setup() {
        List<Account> accList = TestDataFactory.createAccounts(10);
        List<Contact> contList = TestDataFactory.createContactsIsSyncedFalseForAccounts(accList,1);
        List<Task> taskList = TestDataFactory.createTasksForAccounts(accList, 1);
    }
    @IsTest
    static void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTask1Test',
                CRON_EXP,
                new ScheduledJobForTwoBatchFromTask1());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
                NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.debug('CronTrigger ct: ' + ct);
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        Datetime dt = Datetime.newInstance(Date.today().addDays(1), Time.newInstance(0, 0, 0, 0));  //        String dtString = dt.format('yyyy-MM-dd HH:mm:ss');
        System.debug('dtString: ' + dt.format('yyyy-MM-dd HH:mm:ss'));  //        System.assertEquals('2022-03-13 00:00:00', String.valueOf(ct.NextFireTime));
        System.assertEquals(dt.format('yyyy-MM-dd HH:mm:ss'), String.valueOf(ct.NextFireTime));
        // check first batch job has not been started
        List<Account> accountsList = [SELECT Id FROM Account WHERE Updated_By_Task__c = TRUE];
        System.assertEquals(0, accountsList.size(), 'Accounts were updated before job has run');
        List<Task> tsList =  [SELECT Id FROM Task WHERE Account_Owner__c != NULL];
        System.assertEquals(0, tsList.size(), 'Tasks were updated before job has run');
        // check second batch job has not been started
        List<Account> accountsList2 = [SELECT Id FROM Account WHERE Updated_By_Contact__c = TRUE];
        System.assertEquals(0, accountsList2.size(), 'Accounts were updated before job has run');
        List<Contact> ctList = [SELECT Id, LastName, MailingCountry, MailingState, Is_Synced__c
                                FROM Contact WHERE Is_Synced__c = TRUE
                                AND MailingCountry = 'US' AND MailingState = 'NY'];
        System.assertEquals(0, ctList.size(), 'Contacts were updated before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
    }
}