/**
 * Utility class for test data creating
 */

@IsTest
public with sharing class TestDataFactory {
    //
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<numAccounts;i++) {
            Account a = new Account(Name='TestAccount' + i, BillingCountry='US', BillingState='NY');
            accList.add(a);
        }
        insert accList;
        return accList;
    }
    public static List<Contact> createContactsForAccounts(List<Account> accList, Integer numContPerAcct) {
        List<Contact> contactList = new List<Contact>();
        for(Account acct : accList) {
            for(Integer i=0;i<numContPerAcct;i++) {
                contactList.add(new Contact(FirstName=acct.Name + ' Contact ' + i,
                        LastName='LastName' + i,
                        AccountId=acct.Id));
            }
        }
        insert contactList;
        return contactList;
    }
    public static List<Contact> createContactsIsSyncedFalseForAccounts(List<Account> accList, Integer numContPerAcct) {
        List<Contact> contactList = new List<Contact>();
        for(Account acct : accList) {
            for(Integer i=0;i<numContPerAcct;i++) {
                contactList.add(new Contact(FirstName=acct.Name + ' Contact ' + i,
                        Is_Synced__c = false,
                        LastName='LastName' + i,
                        AccountId=acct.Id));
            }
        }
        insert contactList;
        return contactList;
    }
    public static List<Id> createAccountsWithContacts(Integer numAccounts, Integer numContPerAcct) {
        List<Account> accList = createAccounts(numAccounts);
        List<Contact> contactList = createContactsForAccounts(accList, numContPerAcct);
//        for(Account acct : accList) {
//            for(Integer i=0;i<numContPerAcct;i++) {
//                contactList.add(new Contact(FirstName=acct.Name + ' Contact ' + i,
//                                        LastName='LastName' + i,
//                                        AccountId=acct.Id));
//            }
//        }
//        insert contactList;
//        List<Id> listId = new List<Id>();
//        for (Account acc : accList) {
//            listId.add(acc.Id);
//        }
        List<Id> listId = getListIds(accList);
        return listId;
    }
    //
    public static List<Task> createTasksForAccounts(List<Account> accList, Integer numTaskPerAcct) {
        List<Task> taskList = new List<Task>();
        for(Account acc : accList) {
            for(Integer i=0;i<numTaskPerAcct;i++) {
                taskList.add(new Task(Subject='Task for testing ' + acc.Name,
                        Is_Synced__c = false, WhatId=acc.Id));
            }
        }
        insert taskList;
        return taskList;
    }
    //
    public static List<Id> getListIds(List<SObject> sObjList) {
        List<Id> listId = new List<Id>();
        for (SObject sObj : sObjList) {
            listId.add(sObj.Id);
        }
        return listId;
    }

}