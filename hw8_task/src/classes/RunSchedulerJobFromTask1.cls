/**
 * Class to run scheduled job every half hour  from Task 1
 */

public with sharing class RunSchedulerJobFromTask1 {
    // cron expression for scheduling job to start every half hour
    public static String crExprFirstHalfHour = '0 0 * 1/1 * ? *';
    public static String crExprSecondHalfHour = '0 30 * 1/1 * ? *';
    // method to run scheduling job
    public static List<String> runningSchJobEveryHalfHour() {
        List<String> jobIds = new List<String>();
        // batch job for first half hour - at every 0 min of every hour
        ScheduledJobForTwoBatchFromTask1 firstsSchBatchesFromTask1 = new ScheduledJobForTwoBatchFromTask1();
        String firstJobId = System.schedule('BatchTask1 update of tasks and contacts - FirstHalfHour',
                crExprFirstHalfHour,
                firstsSchBatchesFromTask1);
        jobIds.add(firstJobId);
        // batch job for second half hour - at every 30 min of every hour
        ScheduledJobForTwoBatchFromTask1 secondSchBatchesFromTask1 = new ScheduledJobForTwoBatchFromTask1();
        String secondJobId = System.schedule('BatchTask1 update of tasks and contacts - SecondHalfHour',
                crExprSecondHalfHour,
                secondSchBatchesFromTask1);
        jobIds.add(secondJobId);
        return jobIds;
    }
}