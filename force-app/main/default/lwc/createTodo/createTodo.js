import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import NAME_FIELD from '@salesforce/schema/ToDo__c.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/ToDo__c.Description__c';
import PRIORITY_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import ISDONE_FIELD from '@salesforce/schema/ToDo__c.Is_Done__c';
import CATEGORY_FIELD from '@salesforce/schema/ToDo__c.Category__c';
export default class CreateTodo extends LightningElement {
    @api todoId;
    objectApiName = TODO_OBJECT;
    nameField = NAME_FIELD;
    descriptionField = DESCRIPTION_FIELD;
    priorityField = PRIORITY_FIELD;
    isdoneField = ISDONE_FIELD;
    categoryField = CATEGORY_FIELD;
    fields = [NAME_FIELD, DESCRIPTION_FIELD, PRIORITY_FIELD, ISDONE_FIELD, CATEGORY_FIELD];
    @api btnLabel;


    handleSuccess(event) {
        this.dispatchEvent(
            new CustomEvent(
                'createdtodo',
                { detail: event.detail.id }
            ),
        );
    }
    handleError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating record',
                message: event.detail.message,
                variant: 'error',
            }),
        );
    }
    handleBtnCancel(event) {
        this.dispatchEvent(
            new CustomEvent(
                'cancelclick',
                { detail: 'cancel btn click!!!' }
            ),
        );
    }
}
