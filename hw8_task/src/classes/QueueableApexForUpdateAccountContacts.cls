/**
 * Queueable Job:
 * for accounts that have changed BillingAddress, update all related Contacts
 */

public class QueueableApexForUpdateAccountContacts implements Queueable {
    private List<Account> accList;
    public QueueableApexForUpdateAccountContacts(List<Account> records) {
        this.accList = records;
    }
    public void execute(QueueableContext context) {
        // getting AccountHistory object list for accounts in which BillingAddress changed
        List<AccountHistory> accHistList = [SELECT AccountId FROM AccountHistory
        WHERE Field IN
        ('BillingCountry', 'BillingCity', 'BillingState', 'BillingStreet', 'BillingPostalCode')
        AND AccountId IN :accList];
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
            cont.Processed_By_Queue__c = true;
            contList.add(cont);
        }
        update contList;
    }
}