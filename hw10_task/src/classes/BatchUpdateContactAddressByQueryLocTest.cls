/**
     * for testing BatchUpdateContactAddressByQueryLoc
     */

@IsTest
private class BatchUpdateContactAddressByQueryLocTest {
    @IsTest static void test() {
        List<Account> accList = TestDataFactory.createAccounts(10);
        List<Contact> contList = new List<Contact>();
        contList = TestDataFactory.createContactsIsSyncedFalseForAccounts(accList,1);
        Test.startTest();
        BatchUpdateContactAddressByQueryLoc batchUpdateQueryLoc = new BatchUpdateContactAddressByQueryLoc();
        Id batchId = Database.executeBatch(batchUpdateQueryLoc);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [SELECT COUNT() FROM Account WHERE Updated_By_Contact__c = TRUE AND Id IN :accList]);
        System.assertEquals(10, [SELECT COUNT() FROM Contact WHERE Is_Synced__c = TRUE AND Id IN :contList]);
    }
}