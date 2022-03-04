/**
 * Trigger 'after insert' for Accounts
 */

trigger AccountTrigger on Account (after insert) {
    //get Id list from Trigger.newMap
    List<Id> accIds = new List<Id>(Trigger.newMap.keySet());
    //get Account list from Trigger.newMap
    List<Account> accList = Trigger.newMap.values();
    // Call future method to create Task for each account
    AccountTriggerHandler.futureMethodForTaskForAccount(accIds);
    // Call the future method of updating related contacts for each account
    AccountTriggerHandler.futureMethodForUpdateRelatedContacts(accIds);
    // Call Queueable Apex to update Account related Contacts
    AccountTriggerHandler.updateAccountContactsByQJob(accList);
}