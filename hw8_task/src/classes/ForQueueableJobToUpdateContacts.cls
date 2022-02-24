/**
 * Task description:
 * 	Create Queueble Job to perform similar logic:
 * q.	For accounts in which BillingAddress is not empty select all related Contacts
 * r.	Set to all Contacts Is Synced = false; Processed By Queue = true;
 * s.	Run created class using DevConsole.
 */
public class ForQueueableJobToUpdateContacts implements Queueable {
    private List<Account> accList;
    public ForQueueableJobToUpdateContacts(List<Account> records) {
        this.accList = records;
    }
    public void execute(QueueableContext context) {
        // from the Account sobject list to get list of Id, in which BillingAddress is not empty
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