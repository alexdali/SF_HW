import { LightningElement } from 'lwc';

export default class TodoApp extends LightningElement {
    value = 'All';
    category;
    todoId;
    btnLabel;
    updatedTodos = false;


    get categoryList() {
        this.setCategory();
        return this.category;
    }

    setCategory() {
        if (this.value == 'All') {
            this.category = ['Today', 'Tomorrow', 'Later'];
        } else {
            this.category = [this.value];
        }
        this.updatedTodos = true;
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
        this.value = event.detail.value;
        this.setCategory();
    }

    handleUpsertTodo(event) {
        if (event.detail) {
            this.value = 'All';
        }
    }
}