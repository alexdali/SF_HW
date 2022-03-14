/**
 * for testing BatchUpdateContactAddressByIterator
 */

@IsTest
private class BatchUpdateContactAddressByIteratorTest {
    @TestSetup
    static void setup() {
        List<Account> accList = TestDataFactory.createAccounts(10);
        List<Contact> contList = new List<Contact>();
        contList = TestDataFactory.createContactsIsSyncedFalseForAccounts(accList,1);
    }
    @IsTest static void test() {
        Test.startTest();
        BatchUpdateContactAddressByIterator batchUpdateContact = new BatchUpdateContactAddressByIterator();
        Id batchId = Database.executeBatch(batchUpdateContact);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        List<Contact> ctList = [SELECT Id, LastName, MailingCountry, MailingState, Is_Synced__c
                                FROM Contact WHERE Is_Synced__c = TRUE
                                AND MailingCountry = 'US' AND MailingState = 'NY'];
        System.assertEquals(10, ctList.size());
        System.assertEquals(10, [SELECT COUNT() FROM Account WHERE Updated_By_Contact__c = TRUE]);
    }
}