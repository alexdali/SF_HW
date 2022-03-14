/**
 * Task description:
 *	Create class with future method. Inside the method do the following:
 *	m.	Select 150 Accounts from database.
 *	n.	For accounts in which BillingAddress is not empty select all related Contacts
 *	o.	Set to all Contacts Is Synced = false; Processed By Future = true;
 *	p.	Run created class using DevConsole.
 */

public with sharing class ForFutureMethodToUpdateContacts {
    // update all related Contacts for accounts in which BillingAddress is not empty
    @Future
    public static void updateContactsForAccount() {
        // getting Account object list
        List<Account> accList = [SELECT Id, BillingAddress
                                FROM Account LIMIT 150];
        // getting Id list from Account sobject list
        List<Id> accIdWithAddress = new List<Id>();
        for(Account acc : accList) {
            if(acc.BillingAddress != null) {
                accIdWithAddress.add(acc.Id);
            }
        }
        // update all related contacts with AccountId from accIdWithAddress
        List<Contact> contList = new List<Contact>();
        for(Contact cont : [SELECT Id, Is_Synced__c, Processed_By_Future__c
                            FROM Contact
                            WHERE AccountId IN :accIdWithAddress]) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Future__c = true;
            contList.add(cont);
        }
        update contList;
    }
}