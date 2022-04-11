declare module "@salesforce/apex/TodoController.getTodos" {
  export default function getTodos(): Promise<any>;
}
declare module "@salesforce/apex/TodoController.getTodoList" {
  export default function getTodoList(): Promise<any>;
}
declare module "@salesforce/apex/TodoController.findTodos" {
  export default function findTodos(param: {searchKey: any, categoryList: any, updateFlag: any}): Promise<any>;
}
declare module "@salesforce/apex/TodoController.getSingleTodo" {
  export default function getSingleTodo(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/TodoController.updateTodos" {
  export default function updateTodos(param: {todosForUpdate: any}): Promise<any>;
}
