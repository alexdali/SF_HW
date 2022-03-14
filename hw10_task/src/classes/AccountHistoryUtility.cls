/**
 * Created by dmina on 11.03.2022.
 */

public with sharing class AccountHistoryUtility {
//
//    @isTest
//    private static void  testOne(){
//        Account acc = new Account(Name = 'Hello World' + Datetime.now());
//        insert acc;
//
//        Test.startTest();
//
//        AccountHistoryUtil accHistClass = new AccountHistoryUtil();
//
//        accHistClass.processAccountUpdate(acc.Id);
//
//        AccountHistory[] accHist = accHistClass.retrieveAccountHistory(acc.Id);
//        Test.stopTest();
//        System.assertEQuals(1, accHist.size());
//    }

    public void processAccountsUpdate(List<Id> listAccIds){
        //Account acc = new Account(Id = accountId, Type = 'Other');
        //update acc;
        List<Account> accList =[SELECT Id, BillingCountry FROM Account
        WHERE Id IN :listAccIds];
        for(Account acc : accList) {
            acc.BillingCountry = 'US';
        }
        update accList;
    }

    public AccountHistory[] retrieveAccountHistory(List<Id> listAccIds){
        List<AccountHistory> ah;
        if(Test.isRunningTest()){  //if TEST, create dummy AccountHistory
            ah = new List<AccountHistory>{}; //OldValue, NewValue not writeable
//            List<Account> accList =[SELECT Id, BillingCountry FROM Account
//            WHERE Id IN :listAccIds];
            for(Id accId : listAccIds) {
                ah.add(new AccountHistory(AccountId=accId, Field='BillingCountry'));
            }
        }
        else {
            ah=  [SELECT AccountId, Field, OldValue, NewValue
            FROM AccountHistory WHERE AccountId = :listAccIds];
//            ah = [SELECT AccountId FROM AccountHistory
//                    WHERE Field IN
//                ('BillingCountry', 'BillingCity', 'BillingState', 'BillingStreet', 'BillingPostalCode')
//                AND AccountId IN :accIdList];
        }
        return ah;
    }
}