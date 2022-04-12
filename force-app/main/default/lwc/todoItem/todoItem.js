import { api, LightningElement } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { setColorByCategory } from 'c/ldsUtils';

export default class TodoItem extends LightningElement {
    @api todo;


    renderedCallback() {
        this.setColor();
    }


    setColor() {
        const itemCard = this.template.querySelector('lightning-card.todo-card');
        if (this.todo != null && itemCard != null) {
            setColorByCategory(itemCard, this.todo.Category__c)
        }
    }


    handleSelect(event) {
        event.preventDefault();
        const selectEvent = new CustomEvent('todoselect', {
            bubbles: true
        });
        this.dispatchEvent(selectEvent);
    }

    handleEditClick() {
        this.setColor();
        const editEvent = new CustomEvent('editselect', {
            detail: this.todo.Id
        });
        this.dispatchEvent(editEvent);
    }

    handleDeleteClick(event) {
        event.preventDefault();
        deleteRecord(this.todo.Id)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                this.dispatchEvent(new CustomEvent('deleteselect', {
                    detail: this.todo.Id
                }));
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
}