/**
 * Class to run scheduled job every half hour from Task 2
 */

public with sharing class RunSchedulerJobFromTask2 {
    // cron expression for scheduling job to start every half hour
    public static String crExprFirstHalfHour = '0 0 * 1/1 * ? *';
    public static String crExprSecondHalfHour = '0 30 * 1/1 * ? *';
    // method to run scheduling job
    public static List<String> runningSchJobEveryHalfHour() {
        List<String> jobIds = new List<String>();
        // batch job for first half hour - at every 0 min of every hour
        ScheduledJobForTwoBatchFromTask2 firstsSchBatchesFromTask2 = new ScheduledJobForTwoBatchFromTask2();
        String firstJobId = System.schedule('BatchTask2 update of contacts - FirstHalfHour',
                crExprFirstHalfHour,
                firstsSchBatchesFromTask2);
        jobIds.add(firstJobId);
        // batch job for second half hour - at every 30 min of every hour
        ScheduledJobForTwoBatchFromTask2 secondSchBatchesFromTask2 = new ScheduledJobForTwoBatchFromTask2();
        String secondJobId = System.schedule('BatchTask2 update of contacts - SecondHalfHour',
                crExprSecondHalfHour,
                secondSchBatchesFromTask2);
        jobIds.add(secondJobId);
        return jobIds;
    }
}