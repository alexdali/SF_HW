import { LightningElement, wire, api } from 'lwc';
import { deleteRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors, setColorByCategory } from 'c/ldsUtils';
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
        this.wiredValue = value;
        const { data, error } = value;
        if (error) {
            this.dispatchToast(error);
        } else if (data) {
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
        if (message.recordId == null) {
            this.todo = null;
        }
        this.recordId = message.recordId;
        // getRecordNotifyChange([{ recordId: this.recordId }]);
        refreshApex(this.wiredValue);
    }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    renderedCallback() {
        this.setColor();
    }

    setColor() {
        const itemCard = this.template.querySelector('lightning-card.todo-card');
        if (this.todo != null && itemCard != null) {
            setColorByCategory(itemCard, this.todo.Category__c)
        }
    }


    handleModalCancelClick() {
        const modal = this.template.querySelector('c-modal-item');
        modal.hide();
    }
    handleModalOkClick(event) {
        refreshApex(this.wiredValue);
        if (event.detail) {
            this.template.querySelector('c-modal-item').hide();
        }
        const payload = { recordId: event.detail };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
        this.setColor();
    }

    handleEditClick() {
        this.template.querySelector('c-modal-item').show();
    }

    handleDeleteClick(event) {
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
        return (this.todo != null && this.todo != undefined);
    }
}