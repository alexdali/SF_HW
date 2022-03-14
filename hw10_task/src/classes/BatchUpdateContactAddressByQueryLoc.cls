/**
 * Task description:
 * Create Batch Job which select all Сontacts with Is Synced = false
 * t.	Batch should copy from Account.BillingAddress to Contact.MailingAddress
 * u.	Set Contact.IsSynced__c = true;
 * v.	Update Account field Updated By Contact = true;
 * w.	Use Query Locator
  */

public class BatchUpdateContactAddressByQueryLoc implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, ' +
                        '(SELECT Id, Is_Synced__c, MailingStreet, MailingCity, ' +
                        'MailingState, MailingPostalCode ' +
                        'FROM Contacts ' +
                        'WHERE Is_Synced__c = FALSE) ' +
                        'FROM Account'
        );
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
        List<Contact> contList = new List<Contact>();
        List<Account> accList = new List<Account>();
        for (Account acc : scope) {
            for (Contact cont : acc.Contacts) {
                cont.MailingStreet = acc.BillingStreet;
                cont.MailingCity = acc.BillingCity;
                cont.MailingState = acc.BillingState;
                cont.MailingPostalCode = acc.BillingPostalCode;
                cont.Is_Synced__c = true;
                contList.add(cont);
            }
            acc.Updated_By_Contact__c = true;
            accList.add(acc);
        }
        update contList;
        update accList;
    }
    public void finish(Database.BatchableContext bc){
    }
}