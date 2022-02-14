/**
 * Creating a new task object with the subject "Negotiation with {Account.Name}"
 * for accounts from the collection
 *
 * @param accountsId    collection of strings (Account ID)
 */

public with sharing class CreateTaskForAccount {
    @InvocableMethod(Label='Create Task for Account' Description='Create Task for Account' Category='Task')
    public static void createTaskForAccount (String[] accountsId) {
        Account[] accList = [SELECT Name FROM Account WHERE Account.Id IN :accountsId];
        Task[] tasksList = new List<Task>();
        for (Account acc : accList) {
            String subj = 'Negotiations with ' + acc.Name;
            tasksList.add(new Task(Subject=subj, WhatId=acc.Id));
        }
        try {
            insert tasksList;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}