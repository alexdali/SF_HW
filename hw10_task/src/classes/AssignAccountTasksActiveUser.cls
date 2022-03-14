/**
 * Assigning tasks of an account
 * from the incoming collection to the active user
 *
 * @param accountsId    collection of strings (Account ID)
 */

public with sharing class AssignAccountTasksActiveUser {
    @InvocableMethod(Label='Assigning Account Tasks to active User' Description='Assigning Account tasks  to active User' Category='Task')
    public static void assignAccountTasks (String[] accountsId) {
        Account[] accList = [SELECT Name,
                            (SELECT Status, OwnerId FROM Tasks WHERE Status != 'Completed')
                            FROM Account
                            WHERE Account.Id IN :accountsId];
        User activeUser = [SELECT Id
                            FROM User
                            WHERE IsActive=TRUE
                            LIMIT 1];
        Task[] updatedTasks = new List<Task>();
        for (Account acc : accList) {
            for (Task tc: acc.Tasks) {
                if (tc.Status != 'Completed') {
                    tc.OwnerId = activeUser.Id;
                    updatedTasks.add(tc);
                }
            }
        }
        try {
            update updatedTasks;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }

    }
}