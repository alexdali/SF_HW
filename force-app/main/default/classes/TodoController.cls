public with sharing class TodoController {
    @AuraEnabled(cacheable=true)
    public static List<ToDo__c> getTodos() {
        return [
            SELECT
                Id, Name,
                Description__c, Category__c, Priority__c, Is_Done__c, CreatedDate
            FROM ToDo__c
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<ToDo__c> getTodoList() {
        return [
            SELECT
                Id, Name,
                Description__c, Category__c, Priority__c, Is_Done__c, CreatedDate
            FROM ToDo__c
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<ToDo__c> findTodos(String searchKey, List<String> categoryList, Boolean updateFlag) {
        List<ToDo__c> findList = new List<ToDo__c>();

        String key = '%' + searchKey + '%';
        findList = [
            SELECT Id, Name,
                Description__c, Category__c, Priority__c, Is_Done__c, CreatedDate
            FROM ToDo__c
            WHERE Name LIKE :key
            AND Category__c IN :categoryList
            WITH SECURITY_ENFORCED
            ORDER BY LastModifiedDate DESC
        ];

        return findList;
    }

    @AuraEnabled(cacheable=true)
    public static ToDo__c getSingleTodo(String recordId) {
        System.debug('getSingleTodo recordId: ' + recordId);
        List<ToDo__c> findList = new List<ToDo__c>();
        findList = [
            SELECT Id, Name,
                Description__c,
                Category__c,
                Priority__c,
                Is_Done__c,
                CreatedDate
            FROM ToDo__c
            WHERE Id =:recordId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        ToDo__c res = (findList.size()>0) ? findList[0] : null;

        return res;
    }

    @AuraEnabled
    public static void updateTodos(List<ToDo__c> todosForUpdate) {
        // Make sure we can update the database before trying to update
        if (!Schema.sObjectType.ToDo__c.isUpdateable()) {
            throw new SecurityException(
                'Insufficient permissions to update todos'
            );
        }
        update todosForUpdate;
    }
}
