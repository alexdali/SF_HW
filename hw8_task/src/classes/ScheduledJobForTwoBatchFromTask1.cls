/**
 * Task description:
 * 	Create Scheduled Job for 2 created batches:
 *      1. BatchUpdateAccountOwnerInTasks
 *      2. BatchUpdateContactAddressByIterator
 */

global class ScheduledJobForTwoBatchFromTask1 implements Schedulable {
    global void execute(SchedulableContext ctx) {
        BatchUpdateAccountOwnerInTasks schJobUpdateTasks = new BatchUpdateAccountOwnerInTasks();
        Database.executeBatch(schJobUpdateTasks);
        BatchUpdateContactAddressByIterator schJobUpdateContacts = new BatchUpdateContactAddressByIterator();
        Database.executeBatch(schJobUpdateContacts);
    }
}