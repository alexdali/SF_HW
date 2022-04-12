import { LightningElement, api } from 'lwc';

const CSS_CLASS = 'modal-hidden';

export default class ModalItem extends LightningElement {
    showModal = false;
    showFooter = false;


    @api show() {
        this.showModal = true;
        // console.log('show this.showModal: ', this.showModal);
    }

    @api hide() {
        this.showModal = false;
        // console.log('hide this.showModal: ', this.showModal);
    }

    handleClick(event) {
        const createdEvent = new CustomEvent('createdtodo', { detail: 'event modalItem!!!' });
        this.dispatchEvent(createdEvent);
        this.showModal = false;
    }
    handleCancelClickP(event) {
        this.hide();
    }
    handleDialogClose() {
        this.hide();
    }
    handleSlotFooterChange() {
        if (this.showModal === false) {
            return;
        }
        const footerEl = this.template.querySelector('footer');
        footerEl.classList.remove(CSS_CLASS);
    }
 }

