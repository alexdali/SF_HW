/**
 * Task description:
 * Create Batch Job, which select all contacts with Is Synced = false
 * i.	Batch should copy from Account.BillingAddress to Contact.MailingAddress
 * j.	Set Contact.IsSynced__c = true;
 * k.	Update Account field Updated By Contact = true;
 * l.	Use Iterable
 */

public class BatchUpdateContactAddressByIterator implements Database.Batchable<SObject> {
    public Iterable<SObject> start(Database.BatchableContext bc) {
        Integer count = Limits.getLimitQueryRows() - Limits.getQueryRows();
        return [SELECT Id, BillingCountry, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                (SELECT Id, Is_Synced__c, MailingStreet, MailingCity,
                MailingState, MailingPostalCode
                FROM Contacts
                WHERE Is_Synced__c = FALSE)
                FROM Account
                LIMIT :count];
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
        List<Contact> contList = new List<Contact>();
        List<Account> accList = new List<Account>();
        for (Account acc : scope) {
            for (Contact cont : acc.Contacts) {
                cont.MailingCountry = acc.BillingCountry;
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