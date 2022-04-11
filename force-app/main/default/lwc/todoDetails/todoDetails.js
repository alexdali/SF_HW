import { LightningElement, wire, api } from 'lwc';
import { deleteRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';
import getSingleTodo from '@salesforce/apex/TodoController.getSingleTodo';
// Import message service features required for subscribing and the message channel
import {
    publish,
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';

export default class TodoDetail extends LightningElement {
    subscription = null;
    recordId=null;
    todo;
    wiredValue;


    @wire(getSingleTodo, { recordId: '$recordId' })
    wiredRecord(value) {
        console.log('todoDetails wiredRecord value: ', JSON.stringify(value));
        this.wiredValue = value;
        const { data, error } = value;
        if (error) {
            console.log('todoDetails wiredRecord error: ', JSON.stringify(error));
            this.dispatchToast(error);
        } else if (data) {
            console.log('todoDetails wiredRecord data: ', JSON.stringify(data));
            this.todo = data;
            this.setColor();
        }
    }

    // By using the MessageContext @wire adapter, unsubscribe will be called
    // implicitly during the component descruction lifecycle.
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
        console.log('todoDetails handleMessage message: ', JSON.stringify(message));
        if (message.recordId == null) {
            this.todo = null;
        }
        this.recordId = message.recordId;
        console.log('todoDetails handleMessage this.recordId: ', this.recordId);
        // getRecordNotifyChange([{ recordId: this.recordId }]);
        refreshApex(this.wiredValue);
        console.log('todoDetails handleMessage this.todo: ', this.todo);
    }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    renderedCallback() {
        // console.log('todoDetails renderedCallback');
        this.setColor();
    }

    setColor() {
        const itemCard = this.template.querySelector('lightning-card.todo-card');
        if (this.todo != null && itemCard != null) {
            const category = this.todo.Category__c;
            if (category == 'Today') {
                itemCard.classList.add("brown-border");;
            }
            if (category == 'Tomorrow') {
                itemCard.classList.add("green-border");;
            }
            if (category == 'Later') {
                itemCard.classList.add("blue-border");;
            }
        }
    }

    handleModalCancelClick() {
        console.log('todoDetails handleModalCancelClick');
        const modal = this.template.querySelector('c-modal-item');
        modal.hide();
    }
    handleModalOkClick(event) {
        refreshApex(this.wiredValue);
        console.log('todoDetails handleModalOkClick: ', JSON.stringify(event));
        if (event.detail) {
            this.template.querySelector('c-modal-item').hide();
        }
        const payload = { recordId: event.detail };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
        this.setColor();
    }

    handleEditClick() {
        console.log('todoDetails handleEditClick this.todo.Id: ', this.todo.Id);
        this.template.querySelector('c-modal-item').show();
    }

    handleDeleteClick(event) {
        console.log('todoDetails handleDeleteClick this.todo.Id: ', this.todo.Id);
        event.preventDefault();
        deleteRecord(this.todo.Id)
            .then(() => {
                const payload = { recordId: null };
                publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }


    // Helper
    dispatchToast(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error loading contact',
                message: reduceErrors(error).join(', '),
                variant: 'error'
            })
        );
    }

    get hasResults() {
        // console.log('this.todo: ', JSON.stringify(this.todo));
        return (this.todo != null && this.todo != undefined);
    }
}