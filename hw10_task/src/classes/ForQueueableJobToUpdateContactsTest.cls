/**
 * for testing ForQueueableJobToUpdateContactsTest
 */

@IsTest
public class ForQueueableJobToUpdateContactsTest {
    @IsTest
    static void testQueueable() {
        //setup test data
        List<Id> accIdList = TestDataFactory.createAccountsWithContacts(150, 2);
        // Create our Queueable instance
        ForQueueableJobToUpdateContacts updateContacts = new ForQueueableJobToUpdateContacts();
        // Perform Test
        Test.startTest();
        System.enqueueJob(updateContacts);
        Test.stopTest();
        // Verify
        List<Contact> contactList = [SELECT Id, Is_Synced__c, Processed_By_Queue__c
                                    FROM Contact
                                    WHERE Is_Synced__c = FALSE AND Processed_By_Queue__c = TRUE];
        System.assertEquals(accIdList.size()*2, contactList.size());
    }
}