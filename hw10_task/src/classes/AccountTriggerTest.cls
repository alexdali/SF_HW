/**
 *  for testing AccountTrigger
 */

@IsTest
private class AccountTriggerTest {
    @IsTest
    private static void testAccountTriggerHandlerMethods() {
        // setup test data
        List<Id> accIdList = TestDataFactory.createAccountsWithContacts(10, 2);
        // check AccountHistory before test
        List<AccountHistory> accHistList1 = [SELECT AccountId FROM AccountHistory
                            WHERE Field IN
                            ('BillingCountry', 'BillingCity', 'BillingState', 'BillingStreet', 'BillingPostalCode')
                            AND AccountId IN :accIdList];
        System.debug('accHistList.size() before test: ' + accHistList1.size());
        // Perform test
        Test.startTest();
        AccountHistoryUtility accHistClass = new AccountHistoryUtility();
        accHistClass.processAccountsUpdate(accIdList);
        AccountHistory[] accHist = accHistClass.retrieveAccountHistory(accIdList);
        insert accHist;
        Test.stopTest();
        // Verify
        List<AccountHistory> accHistList2 = [SELECT AccountId FROM AccountHistory
                                WHERE Field IN
                                ('BillingCountry', 'BillingCity', 'BillingState', 'BillingStreet', 'BillingPostalCode')
                                AND AccountId IN :accIdList];
        System.debug('accHistList.size() after test: ' + accHistList2.size());
        // check result of testing AccountTriggerHandler.futureMethodForTaskForAccount
        List<Task> taskList = [SELECT Id, Subject, WhatId
                                FROM Task
                                WHERE WhatId IN :accIdList
                                AND Subject LIKE 'Negotiations with%'];
        System.assertEquals(accIdList.size(), taskList.size());
        // check result of testing AccountTriggerHandler.futureMethodForUpdateRelatedContacts
        List<Contact> contactList1 = [SELECT Id, Is_Synced__c, Processed_By_Future__c
                                        FROM Contact
                                        WHERE AccountId IN :accIdList
                                        AND Is_Synced__c = FALSE
                                        AND Processed_By_Future__c = TRUE];
        System.assertEquals(accIdList.size()*2, contactList1.size());
        // check result of testing AccountTriggerHandler.updateAccountContactsByQJob
        List<Contact> contactList2 = [SELECT Id, Is_Synced__c, Processed_By_Queue__c
                                    FROM Contact
                                    WHERE AccountId IN :accIdList
                                    AND Is_Synced__c = FALSE
                                    AND Processed_By_Queue__c = TRUE];
        System.assertEquals(accIdList.size()*2, contactList2.size());
    }
}