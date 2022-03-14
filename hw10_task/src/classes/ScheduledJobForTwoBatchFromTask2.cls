/**
 * Task description:
 * 	Create Scheduled Job for 2 created batches:
 *      1. BatchUpdateContactAddressByIterator
 *      2. BatchUpdateContactAddressByQueryLoc
 */

global class ScheduledJobForTwoBatchFromTask2 implements Schedulable {
    global void execute(SchedulableContext ctx) {
        BatchUpdateContactAddressByQueryLoc schJobUpdateContactsByQueryLoc = new BatchUpdateContactAddressByQueryLoc();
        Database.executeBatch(schJobUpdateContactsByQueryLoc);
        BatchUpdateContactAddressByIterator schJobUpdateContactsByIter = new BatchUpdateContactAddressByIterator();
        Database.executeBatch(schJobUpdateContactsByIter);
    }
}