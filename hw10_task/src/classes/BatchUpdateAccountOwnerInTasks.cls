/**
 * Task description:
 * Create Batch Job which select all tasks with  Is Synced = false
 * e.	Batch should copy from Account.Owner.Name to Task.AccountOwner__c
 * f.	Set Task.IsSynced__c = true;
 * g.	Update Account field Updated By Task = true;
 * h.	Use Query Locator
 */

public class BatchUpdateAccountOwnerInTasks implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT Name, Owner.Name, Updated_By_Task__c, ' +
                        '(SELECT Task.Is_Synced__c, Task.Account_Owner__c ' +
                        'FROM Account.Tasks ' +
                        'Where Task.Is_Synced__c = false) ' +
                        'FROM Account'
        );
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
        List<Task> taskList = new List<Task>();
        List<Account> accList = new List<Account>();
        for (Account acc : scope) {
            for (Task tsk : acc.Tasks) {
                tsk.Account_Owner__c = (String)acc.Owner.Name;
                tsk.Is_Synced__c = true;
                taskList.add(tsk);
            }
            acc.Updated_By_Task__c = true;
            accList.add(acc);
        }
        update taskList;
        update accList;
    }
    public void finish(Database.BatchableContext bc){
    }
}