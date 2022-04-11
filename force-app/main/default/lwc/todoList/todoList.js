import { LightningElement, wire, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import findTodos from '@salesforce/apex/TodoController.findTodos';
// Import message service features required for subscribing and the message channel
import {
    publish,
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';

/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 300;

export default class TodoList extends LightningElement {
    searchKey = '';
    create = false;
    todos;
    error;
    todoId;
    btnLabel;
    @api categoryList = ['Today', 'Tomorrow', 'Later'];
    updateFlag;
    wiredValue;

    // @wire(findTodos, { searchKey: '$searchKey', categoryList: '$categoryList', update: '$updateFlag' })
    // todos;
    @wire(findTodos, { searchKey: '$searchKey', categoryList: '$categoryList', update: '$updateFlag' })
    wiredTodos(value) {
        console.log('todoList wiredTodos value: ', JSON.stringify(value));
        console.log('todoList wiredTodos this.todos: ', JSON.stringify(this.todos));
        this.wiredValue = value;
        const { data, error } = value;
        if (error) {
            console.log('todoList wiredTodos error: ', JSON.stringify(error));
            this.error = error;
            // this.dispatchToast(error);
        } else if (data) {
            console.log('todoList wiredTodos data: ', JSON.stringify(data));
            console.log('todoList wiredTodos this.todos: ', JSON.stringify(this.todos));
        }
    }

    // @api
    set updateTodos(value) {
        console.log('todoList before set updateTodos this.updateFlag: ' + this.updateFlag);
        console.log('todoList set updateTodos value: ' + value);
        this.updateFlag = value;
        // this.updateFlag = !this.updateFlag;
        console.log('todoList after set updateTodos this.updateFlag: ' + this.updateFlag);
        refreshApex(this.wiredValue);
        console.log('todoList after refresh set updateTodos this.updateFlag: ' + this.updateFlag);
    }

    @api
    get updateTodos() {
        return this.updateFlag;
    }

    renderedCallback() {
        console.log('todoList renderedCallback categoryList: ' + JSON.stringify(this.categoryList));
        console.log('todoList renderedCallback updateFlag: ' + this.updateFlag);
    }

    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            RECORD_SELECTED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    // Handler for message received by component
    handleMessage(message) {
        console.log('todoList handleMessage message: ', JSON.stringify(message));
        refreshApex(this.wiredValue);
    }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    // Respond to UI event by publishing message
    handleTodoSelect(event) {
        console.log('todoList handleTodoSelect event: ', JSON.stringify(event));
        const payload = { recordId: event.target.todo.Id };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

    handleSearchTermChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

    handleTodoEdit(event) {
        // Get todo record id from event
        const recordId = event.detail;
        console.log('todoList handleTodoEdit recordId: ', recordId);
        this.todoId = recordId;
        this.create = true;
        this.btnLabel = "Update ToDo";
        console.log('todolist handleTodoEdit this.todoId: ', this.todoId);
        this.template.querySelector('c-modal-item').show();
        const payload = { recordId: event.target.todoId };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

    handleTodoDelete(event) {
        const recordId = event.detail;
        console.log('todoList handleTodoDelete recordId: ', recordId);
        refreshApex(this.wiredValue);
        const payload = { recordId: null, action: 'delete' };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

    handleBtnCreateClick() {
        this.todoId = null;
        this.create = true;
        this.btnLabel = "Create ToDo";
        console.log('todolist handleBtnCreateClick this.todoId: ', this.todoId);
        this.template.querySelector('c-modal-item').show();
    }

    handleModalOkClick(event) {
        refreshApex(this.wiredValue);
        console.log('todolist handleModalOkClick: ', JSON.stringify(event));
        if (event.detail) {
            this.create = false;
            this.template.querySelector('c-modal-item').hide();
            const payload = { recordId: event.detail };
            publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
        }
    }


    handleModalCancelClick() {
        console.log('todoList handleModalCancelClick');
        const modal = this.template.querySelector('c-modal-item');
        modal.hide();
    }

    get hasResults() {
        return (this.wiredValue.data.length > 0);
    }
}