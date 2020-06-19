import { api, LightningElement, track, wire} from 'lwc';
import getCustomerData from '@salesforce/apex/Customer_Transaction_Ctrl.getCustomerTransaction';
import postAdjustment from '@salesforce/apex/Customer_Transaction_Ctrl.postAdjustment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Customer_Transactions extends LightningElement {
    @track data = [];
    @api recordId;

    // @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    // account;
    handleClickGet() {
        // alert(this.recordId);
        getCustomerData({ recordId : this.recordId})

        .then(result => {
            debugger;
            console.log(result);
            this.data = JSON.parse(result);
        
        })
        .catch(error => {
            console.log('ERROR');
            console.log(JSON.stringify(error));
        });
       
    }

    handleClickPost() {
        // alert(this.recordId);
        postAdjustment({ recordId : this.recordId})

        .then(result => {
            const toast = new ShowToastEvent({
                title: 'Success',
                message: 'Adjustments created!',
                variant: 'success',
            });
            this.dispatchEvent(toast);
        
        })
        .catch(error => {
            console.log('ERROR');
            console.log(JSON.stringify(error));
        });
       
    }
}