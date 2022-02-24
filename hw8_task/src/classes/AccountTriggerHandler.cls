/**
 *  Task description:
 * 	For AccountTriggerHandler move task creation logic to future method; set Task.IsSynced = false
 *
 * 	In AccountTriggerHandler create future method:
 * a.	For accounts in which BillingAddress changed select all related Contacts
 * b.	Set to all Contacts Is Synced = false; Processed By Future = true;
 *
 * 	In AccountTriggerHandler call Queueable Job, which perform similar logic:
 * c.	For accounts in which BillingAddress changed select all related Contacts
 * d.	Set to all Contacts Is Synced = false; Processed By Queue = true;
 */

public with sharing class AccountTriggerHandler {
    // Future method: create task for updated accounts
    @Future
    public static void futureMethodForTaskForAccount(List<Id> accIds) {
        List<Task> taskList = new List<Task>();
        for(Account acc : [SELECT Id, Name FROM Account WHERE Id IN :accIds]) {
            Task tsk = new Task(Subject='Negotiations with ' + acc.Name,
                                Is_Synced__c=false, WhatId=acc.Id);
            taskList.add(tsk);
        }
        insert taskList;
    }
    // Future method: update all related Contacts for accounts in which BillingAddress changed
    @Future
    public static void futureMethodForUpdateRelatedContacts(List<Id> accIds) {
        // getting AccountHistory object list for accounts in which BillingAddress changed
        List<AccountHistory> accHistList = [SELECT AccountId FROM AccountHistory
                                            WHERE Field IN
                                            ('BillingCountry', 'BillingCity', 'BillingState', 'BillingStreet', 'BillingPostalCode')
                                            AND AccountId IN :accIds];
        // getting Id list from AccountHistory object list
        List<Id> updAccIds = new List<Id>();
        for(AccountHistory acchist : accHistList) {
            updAccIds.add(acchist.AccountId);
        }
        // update all related contacts with AccountId from Id list
        List<Contact> contList = new List<Contact>();
        for(Contact cont : [SELECT Id, Is_Synced__c, Processed_By_Future__c
                            FROM Contact WHERE AccountId IN :updAccIds]) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Future__c = true;
            contList.add(cont);
        }
        update contList;
    }
    // method to call Queueable Apex for update Account related Contacts
    public static void updateAccountContactsByQJob(List<Account> accList) {
        // instantiate a new instance of the Queueable class
        QueueableApexForUpdateAccountContacts updateQJob = new QueueableApexForUpdateAccountContacts(accList);
        // enqueue the job for processing
        Id jobID = System.enqueueJob(updateQJob);
    }
}