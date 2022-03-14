/**
 * Task description:
 * 	Create Queueble Job to perform similar logic:
 * q.	For accounts in which BillingAddress is not empty select all related Contacts
 * r.	Set to all Contacts Is Synced = false; Processed By Queue = true;
 * s.	Run created class using DevConsole.
 */
public class ForQueueableJobToUpdateContacts implements Queueable {
    public void execute(QueueableContext context) {
        Integer limitCount = Limits.getLimitQueryRows() - Limits.getQueryRows();
        // get Account list, in which BillingAddress is not empty
        List<Account> accList = new List<Account>();
        accList = [SELECT Id,
                    (SELECT Id, Is_Synced__c, Processed_By_Queue__c
                    FROM Contacts)
                    FROM Account
                    WHERE (BillingCountry != NULL OR BillingStreet != NULL OR BillingCity!= NULL
                    OR BillingState!= NULL OR BillingPostalCode!= NULL)
                    LIMIT :limitCount];
        // update all related contacts
        List<Contact> contList = new List<Contact>();
        for (Account acc : accList) {
            for (Contact cont : acc.Contacts) {
                cont.Is_Synced__c = false;
                cont.Processed_By_Queue__c = true;
                contList.add(cont);
            }
        }
        update contList;
    }
}