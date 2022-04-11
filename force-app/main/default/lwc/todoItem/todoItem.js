import { api, LightningElement } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TodoItem extends LightningElement {
    @api todo;


    renderedCallback() {
        this.setColor();
    }

    setColor() {
        const itemCard = this.template.querySelector('lightning-card');
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

    handleSelect(event) {
        event.preventDefault();
        const selectEvent = new CustomEvent('todoselect', {
            bubbles: true
        });
        this.dispatchEvent(selectEvent);
    }

    handleEditClick() {
        this.setColor();
        // console.log('todoItem handleEditRecordClick this.todo: ', JSON.stringify(this.todo));
        const selectEvent = new CustomEvent('editselect', {
            detail: this.todo.Id
        });
        this.dispatchEvent(selectEvent);
    }
    // @track error;
    handleDeleteClick(event) {
        console.log('todoItem handleDeleteClick this.todo.Id: ', this.todo.Id);
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