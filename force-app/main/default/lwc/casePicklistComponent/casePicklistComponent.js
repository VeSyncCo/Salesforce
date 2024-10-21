import { LightningElement, api, track } from 'lwc';
import getCaseDetails from '@salesforce/apex/CasePicklistController.getCaseDetails';
import returnPicklistValues from '@salesforce/apex/CasePicklistController.returnPicklistValues';
import saveCaseRecord from '@salesforce/apex/CasePicklistController.saveCaseRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const options = [
    { label: 'New', value: 'new' },
    { label: 'In Progress', value: 'inProgress' },
    { label: 'Finished', value: 'finished' },
];
export default class CasePicklistComponent extends LightningElement {
    
    @api recordId;
    feedbackTypeValue;
    feedbackReasonValue;
    feedbackSubReasonValue;
    feedbackDetailValue;
    brand;
    
    typeOptions;
    reasonOptions;
    subReasonOptions;
    detailOptions;
    isDisabled;

    typeDisabled
    reasonDisabled;
    subReasonDisabled;
    detaildisabled;
    connectedCallback(){
        
        this.setCaseValues();
        this.typeDisabled = true;
        this.reasonDisabled = true;
        this.subReasonDisabled = true;
        this.detaildisabled = true;
        
    }
 
    renderedCallback(){

     

    }
    
    handleChange(event) {
        this.value = event.detail.value;
    }




    setCaseValues(){
        
       getCaseDetails({recordId: this.recordId}).then(result=>{
            if(result){

                let feedbackTypeValue = result.Feedback_Type__c == undefined? '' : result.Feedback_Type__c;
                let feedbackReasonValue = result.Feedback_Reason__c == undefined? '' : result.Feedback_Reason__c;
                let feedbackSubReasonValue = result.Feedback_SubReason__c == undefined? '' : result.Feedback_SubReason__c;
                let feedbackDetailValue = result.Feedback_Detail__c == undefined? '' : result.Feedback_Detail__c;

                this.typeOptions = feedbackTypeValue != ''?  [{label : feedbackTypeValue, value : feedbackTypeValue }] : null;
                this.reasonOptions = feedbackReasonValue != ''? [{label : feedbackReasonValue, value : feedbackReasonValue}] : null;
                this.subReasonOptions = feedbackSubReasonValue != ''? [{label : feedbackSubReasonValue, value : feedbackSubReasonValue}] : null;
                this.detailOptions = feedbackDetailValue != ''? [{label : feedbackDetailValue, value : feedbackDetailValue}] : null;
               

                this.feedbackTypeValue = feedbackTypeValue;
                this.feedbackReasonValue = feedbackReasonValue;
                this.feedbackSubReasonValue = feedbackSubReasonValue;
                this.feedbackDetailValue = feedbackDetailValue;
                
            }
       });
        

    }
 


    handleEdit(event){

        let recid = 'Edit';
        this.template.querySelector(`[data-id="${recid}"]`).classList.add('hide');
        
        recid = 'Cancel';
        this.template.querySelector(`[data-id="Cancel"]`).classList.remove('hide');

        recid = 'Save';
        this.template.querySelector('[data-id="Save"]').classList.remove('hide');

        this.typeDisabled = false;
        if(this.feedbackTypeValue != ''){
            this.reasonDisabled = false;
        }

        if(this.feedbackReasonValue != ''){
            this.subReasonDisabled = false;
        }
        
        if(this.feedbackSubReasonValue != ''){
            this.detaildisabled = false;
        }

        this.handlePicklistFieldsValues();
        
    }

    handleCancel(event){

        let recid = 'Edit';
        this.template.querySelector(`[data-id="${recid}"]`).classList.remove('hide');
        
        recid = 'Cancel';
        this.template.querySelector(`[data-id="Cancel"]`).classList.add('hide');

        recid = 'Save';
        this.template.querySelector('[data-id="Save"]').classList.add('hide');

        this.typeDisabled = true;
        this.reasonDisabled = true;
        this.subReasonDisabled = true;
        this.detaildisabled = true;

        this.setCaseValues();
        
    }

    handleSave(event){

        let recid = 'Edit';
        this.template.querySelector(`[data-id="${recid}"]`).classList.remove('hide');
        
        recid = 'Cancel';
        this.template.querySelector(`[data-id="Cancel"]`).classList.add('hide');

        recid = 'Save';
        this.template.querySelector('[data-id="Save"]').classList.add('hide');

        this.typeDisabled = true;
        this.reasonDisabled = true;
        this.subReasonDisabled = true;
        this.detaildisabled = true;

        saveCaseRecord({caseId: this.recordId, feedbackType: this.feedbackTypeValue, reason: this.feedbackReasonValue, subReason: this.feedbackSubReasonValue, detail: this.feedbackDetailValue}).then(result=>{
            if(result == 'Updated'){

                const event = new ShowToastEvent({
                    title: 'Success',
                    message:'Feedback saved successfully',
                    variant: 'success'
                });
                this.dispatchEvent(event);
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message:result,
                    variant: 'error'
                });
                this.dispatchEvent(event);
            }
                  
            
        })
        
    }

    handlePicklistFieldsValues(){

        returnPicklistValues({recordId: this.recordId, feedbackType: this.feedbackTypeValue,reason: this.feedbackReasonValue, subReason: this.feedbackSubReasonValue, detail: this.feedbackDetailValue }).then(result=>{
            if(result != null){
                this.typeOptions = [];
                
                for(let temp in result.typeValueSet){
                    console.log(result.typeValueSet.length);
                    this.typeOptions.push({label : result.typeValueSet[temp], value : result.typeValueSet[temp]});
                    
                }
                if(this.typeOptions == null || this.typeOptions == undefined|| this.typeOptions.length == 0){
                    this.feedbackTypeValue = '';
                }

                if(result.reasonValueSet != undefined && result.reasonValueSet.length > 0){
                    this.reasonOptions = [];
                    for(let temp in result.reasonValueSet){
                        this.reasonOptions.push({label : result.reasonValueSet[temp], value : result.reasonValueSet[temp]});
                    }
                }
                
                if(this.reasonOptions == null || this.reasonOptions == undefined|| this.reasonOptions.length == 0){
                    this.feedbackReasonValue = '';
                }

                if(result.subreasonValueSet != undefined &&  result.subreasonValueSet.length > 0){
                    this.subReasonOptions = [];
                    for(let temp in result.subreasonValueSet){
                        
                        this.subReasonOptions.push({label : result.subreasonValueSet[temp], value : result.subreasonValueSet[temp]});
                    }
                    console.log(this.subReasonOptions);
                }
                if(this.subReasonOptions == null || this.subReasonOptions == undefined|| this.subReasonOptions.length == 0){
                    this.feedbackSubReasonValue = '';
                }

                this.detailOptions = [];
                if(result.detailValueSet != undefined && result.detailValueSet.length > 0){
                    
                    for(let temp in result.detailValueSet){
                        this.detailOptions.push({label : result.detailValueSet[temp], value : result.detailValueSet[temp]});
                    }
                }

                if(this.detailOptions == null || this.detailOptions == undefined|| this.detailOptions.length == 0){
                    this.feedbackDetailValue = '';
                }

            
                
            }
            else{
                
                this.typeOptions = [];
                this.reasonOptions = [];
                this.subReasonOptions = [];
                this.detailOptions = [];

                this.feedbackTypeValue = '';
                this.feedbackDetailValue = '';
                this.feedbackReasonValue = '';
                this.feedbackSubReasonValue = '';
            }
       });
    }


    handleTypeChange(event){

        this.feedbackTypeValue = event.target.value;
        this.feedbackReasonValue = '';
        this.feedbackSubReasonValue = '';
        this.feedbackDetailValue = '';

        this.reasonDisabled = false;
        this.subReasonDisabled = true;
        this.detaildisabled = true;
        this.handlePicklistFieldsValues();

    }

    handleReasonChange(event){

        this.feedbackReasonValue = event.target.value;
        this.feedbackSubReasonValue = '';
        this.feedbackDetailValue = '';
        this.subReasonDisabled = false;
        this.detaildisabled = true;
        this.handlePicklistFieldsValues();
    }

    handleSubReasonChange(event){
        this.feedbackSubReasonValue = event.target.value;
        this.feedbackDetailValue = '';

        this.detaildisabled = false;
        this.handlePicklistFieldsValues();
        
    }

    handleDetailChange(event){
        this.feedbackDetailValue = event.target.value;
    }

    
}