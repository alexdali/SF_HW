import { LightningElement } from 'lwc';

export default class TodoApp extends LightningElement {
    value = 'All';
    category;
    // categoryList;
    todoId;
    btnLabel;
    updatedTodos = false;

    renderedCallback() {
        console.log('TodoApp renderedCallback updatedTodos: ' + this.updatedTodos);
        // console.log('todoList renderedCallback updateFlag: ' + this.updateFlag);
    }

    get categoryList() {
        this.setCategory();
        return this.category;
    }

    setCategory() {
        console.log('TodoApp value: ' + this.value);
        if (this.value == 'All') {
            this.category = ['Today', 'Tomorrow', 'Later'];
        } else {
            this.category = [this.value];
        }
        // return this.category = [this.value];
        console.log('TodoApp category: ' + JSON.stringify(this.category));
        // return this.category;
    }

    get options() {
        return [
            { label: 'All', value: 'All' },
            { label: 'Today', value: 'Today' },
            { label: 'Tomorrow', value: 'Tomorrow' },
            { label: 'Later', value: 'Later' },
        ];
    }

    handleChange(event) {
        console.log('TodoApp handleChange event: ' + event.detail.value);
        // this.setCategory(event.detail.value);
        this.value = event.detail.value;
        this.setCategory();
    }

    // handleBtnCreateClick() {
    //     //console.log('before this.create: ', this.create);
    //     // this.create = !this.create;
    //     // this.todoId = null;
    //     // this.create = true;
    //     this.btnLabel = "Create ToDo";
    //     // console.log('after this.create: ', this.create);
    //     // console.log('todolist handleBtnCreateClick this.todoId: ',
    //     // this.todoId);
    //     this.updatedTodos = false;
    //     this.template.querySelector('c-modal-item').show();
    //     // this.updatedTodos = false;
    // }

    // handleModalOkClick(event) {
    //     console.log('todoApp handleModalOkClick this.updatedTodos: ', this.updatedTodos);
    //     console.log('todoApp handleModalOkClick: ', JSON.stringify(event));
    //     // console.log('event.detail.id: ', event.detail.id);
    //     // const todoId = event.detail;
    //     if (event.detail) {
    //         // this.create = false;
    //         this.template.querySelector('c-modal-item').hide();
    //         // const payload = { recordId: event.detail };
    //         // publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    //         this.updatedTodos = true;
    //     }
    // }

    // handleModalCancelClick() {
    //     console.log('todoApp handleModalCancelClick');
    //     const modal = this.template.querySelector('c-modal-item');
    //     modal.hide();
    // }
}