/**
 * Created by dmina on 13.02.2022.
 */

public with sharing class CreateTaskForNewAccount {
    @InvocableMethod(Label='Create Task for new Account' Description='Task for new Account' Category='Task')
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