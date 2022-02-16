/**
 * Trigger that runs only once
 */

trigger TriggerOnceRun on Account (after update) {
    if (ForTriggerRunRestriction.isFirstRun) {
        ForTriggerRunRestriction.isFirstRun = false;
        Task[] taskList = new List<Task>();
        for (Account acc : Trigger.new) {
            taskList.add(new Task(
                    Subject='Task by once-run trigger',
                    WhatId=acc.Id));
        }
        if (taskList.size() > 0) {
            insert taskList;
        }
    }
}