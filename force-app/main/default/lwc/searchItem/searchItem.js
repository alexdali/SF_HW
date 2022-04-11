import { LightningElement, api } from 'lwc';

export default class SearchItem extends LightningElement {
    @api todo;

    selectHandler(event) {
        // Prevents the anchor element from navigating to a URL.
        event.preventDefault();

        // Creates the event with the todo ID data.
        const selectedEvent = new CustomEvent('selected', { detail: this.todo.Id });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}