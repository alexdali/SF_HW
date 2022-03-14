/**
 * for testing ForFutureMethodToUpdateContacts
 */

@IsTest
private class ForFutureMethodToUpdateContactsTest {
    @IsTest
    private static void testUpdateContactsForAccount() {
        //setup test data
        List<Id> accIdList = TestDataFactory.createAccountsWithContacts(150, 2);
        // Perform test
        Test.startTest();
        // call method for test
        ForFutureMethodToUpdateContacts.updateContactsForAccount();
        Test.stopTest();
        // Verify
        List<Contact> contactList = [SELECT Id, Is_Synced__c, Processed_By_Future__c
                                    FROM Contact
                                    WHERE AccountId IN :accIdList
                                    AND Is_Synced__c = FALSE AND Processed_By_Future__c = TRUE];
        System.assertEquals(accIdList.size()*2, contactList.size());
    }
}