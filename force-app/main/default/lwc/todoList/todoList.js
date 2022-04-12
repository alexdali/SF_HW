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


    @wire(findTodos, { searchKey: '$searchKey', categoryList: '$categoryList', updateFlag: '$updateFlag' })
    wiredTodos(value) {
        this.wiredValue = value;
        const { data, error } = value;
        if (error) {
            this.error = error;
            // this.dispatchToast(error);
        } else if (data) {
            this.todos = data;
        }
    }


    set updateTodos(value) {
        this.updateFlag = value;
        refreshApex(this.wiredValue);
    }

    @api
    get updateTodos() {
        return this.updateFlag;
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
        refreshApex(this.wiredValue);
    }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    // Respond to UI event by publishing message
    handleTodoSelect(event) {
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
        const recordId = event.detail;
        this.todoId = recordId;
        this.create = true;
        this.btnLabel = "Update ToDo";
        this.template.querySelector('c-modal-item').show();
        const payload = { recordId: event.detail };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

    handleTodoDelete(event) {
        const recordId = event.detail;
        refreshApex(this.wiredValue);
        const payload = { recordId: null, action: 'delete' };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

    handleBtnCreateClick() {
        this.todoId = null;
        this.create = true;
        this.btnLabel = "Create ToDo";
        this.template.querySelector('c-modal-item').show();
    }

    handleModalOkClick(event) {
        if (event.detail) {
            this.create = false;
            this.template.querySelector('c-modal-item').hide();
            const payload = { recordId: event.detail };
            publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
            // Send creation or update event from child component in transit to higher-level component
            this.dispatchEvent(
                new CustomEvent(
                    'todoupsert',
                    { detail: event.detail }
                ),
            );
            this.updateFlag = !this.updateFlag;
            refreshApex(this.wiredValue);
        }
    }


    handleModalCancelClick() {
        const modal = this.template.querySelector('c-modal-item');
        modal.hide();
    }

    get hasResults() {
        return (this.wiredValue.data.length > 0);
    }
}