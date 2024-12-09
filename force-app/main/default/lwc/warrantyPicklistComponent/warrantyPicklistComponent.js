import { LightningElement, api } from 'lwc';
import getcaseDetails from '@salesforce/apex/WarrantyPicklistController.getCaseDetails';
import returnPicklistValues from '@salesforce/apex/WarrantyPicklistController.returnPicklistValues';
import saveCaseRecord from '@salesforce/apex/WarrantyPicklistController.saveCaseRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

   
export default class WarrantyPicklistComponent extends LightningElement {

    @api recordId;
    mainCategoryValue;
    allegedIssueValue;
    detailValue;
    subDetailValue;

    maincategoryOptions;
    allegedIssueOptions;
    detailOptions;
    subDetailOptions;
    allegedInjuryValue;
    allegedPropertyValue;
    allegedHardwareValue;
    allegedThermalValue;

    mainCategoryDisabled;
    allegedIssueDisabled;
    detailDisabled;
    subDetailDisabled;
    disableCheckboxes;

    connectedCallback(){

        this.mainCategoryDisabled = true;
        this.allegedIssueDisabled = true;
        this.detailDisabled = true;
        this.subDetailDisabled = true;
        this.disableCheckboxes = true;
        this.setCaseValues();
    }

    renderedCallback(){

    }


    handleMainCategoryChange(event){
        this.mainCategoryValue = event.detail.value;
        this.allegedIssueValue = '';
        this.detailValue = '';
        this.subDetailValue = '';

        this.allegedIssueDisabled = false;
        this.detailDisabled = true;
        this.subDetailDisabled = true;

        this.handlePicklistFieldsValues();
    }

    handleAllegedIssueChange(event){
        this.allegedIssueValue = event.detail.value;
        this.detailValue = '';
        this.subDetailValue = '';

        this.detailDisabled = false;
        this.subDetailDisabled = true;
        this.handlePicklistFieldsValues();
    }

    handleDetailChange(event){
        this.detailValue = event.detail.value;
        this.subDetailValue = '';

        this.subDetailDisabled = false;
        this.handlePicklistFieldsValues();

    }

    handleSubDetailChange(event){
        this.subDetailValue = event.detail.value;
    }

    handleCheckBoxChange(event){
        console.log(event.target.checked);

        if(event.target.name == 'AllegedInjury'){
            this.allegedInjuryValue = event.target.checked;
        }
        else if(event.target.name == 'AllegedPropertyDamage'){
            this.allegedPropertyValue = event.target.checked;
        }
        else if(event.target.name == 'AllegedHardwareIssue'){
            this.allegedHardwareValue = event.target.checked;
        }
        else if(event.target.name == 'AllegedThermalIssue'){ 
            this.allegedThermalValue = event.target.checked;
        }

    }
    


    handleEdit(event){

        let recid = 'Edit';
        this.template.querySelector(`[data-id="${recid}"]`).classList.add('hide');
        
        recid = 'Cancel';
        this.template.querySelector(`[data-id="Cancel"]`).classList.remove('hide');

        recid = 'Save';
        this.template.querySelector('[data-id="Save"]').classList.remove('hide');

        this.mainCategoryDisabled = false;
        if(this.allegedIssueValue != ''){
            this.allegedIssueDisabled = false;
        }
        if(this.detailValue != ''){
            this.detailDisabled = false;
        }
        if(this.subDetailValue != ''){
            this.subDetailDisabled = false;
        }

        this.disableCheckboxes = false;

        this.handlePicklistFieldsValues();

    }

    setCaseValues(){
        getcaseDetails({recordId: this.recordId}).then(result=>{
            console.log(result);
            if(result != null){
                console.log(result.Alleged_Property_Damage__c);
                this.mainCategoryValue = result.Main_Category__c == undefined? '' : result.Main_Category__c;
                this.allegedIssueValue = result.Alleged_Issue__c == undefined? '' : result.Alleged_Issue__c;
                this.detailValue = result.Detail__c == undefined? '' : result.Detail__c;
                this.subDetailValue = result.Sub_Detail__c == undefined? '' : result.Sub_Detail__c;

                this.maincategoryOptions = this.mainCategoryValue != ''? [{label: this.mainCategoryValue, value: this.mainCategoryValue}] : null;
                this.allegedIssueOptions = this.allegedIssueValue != ''? [{label: this.allegedIssueValue, value: this.allegedIssueValue}] : null;
                this.detailOptions = this.detailValue != ''? [{label: this.detailValue, value: this.detailValue}] : null;
                this.subDetailOptions = this.subDetailValue != ''? [{label: this.subDetailValue, value: this.subDetailValue}] : null;
                
                this.allegedInjuryValue = result.Alleged_Injury__c == undefined? false : result.Alleged_Injury__c;
                this.allegedPropertyValue = result.Alleged_Property_Damage__c == undefined? false : result.Alleged_Property_Damage__c;
                this.allegedHardwareValue = result.Alleged_Hardware_Issue__c == undefined? false : result.Alleged_Hardware_Issue__c;
                this.allegedThermalValue = result.Alleged_Thermal_Issue__c == undefined? false : result.Alleged_Thermal_Issue__c;
            }
        });
    }

    handlePicklistFieldsValues(){
        returnPicklistValues({recordId: this.recordId,mainCategory: this.mainCategoryValue,allegedIssue: this.allegedIssueValue,detail: this.detailValue,subDetail: this.subDetailValue}).then(result=>{
            if(result != null){
                this.maincategoryOptions = [];

                for(let temp in result.mainCategoryValueSet){
                    this.maincategoryOptions.push({label : result.mainCategoryValueSet[temp], value : result.mainCategoryValueSet[temp]});
                }
                if(this.maincategoryOptions == null || this.maincategoryOptions == undefined|| this.maincategoryOptions.length == 0){
                    this.mainCategoryValue = '';
                    this.maincategoryOptions = [];
                }

                if(result.allegedIssueValueSet != undefined && result.allegedIssueValueSet.length > 0){
                    this.allegedIssueOptions = [];
                    for(let temp in result.allegedIssueValueSet){
                        this.allegedIssueOptions.push({label : result.allegedIssueValueSet[temp], value : result.allegedIssueValueSet[temp]});
                    }  
                }
                else{
                    this.allegedIssueValue = '';
                    this.allegedIssueOptions = [];
                }

                if(result.detailValueSet != undefined && result.detailValueSet.length > 0){
                    this.detailOptions = [];
                    for(let temp in result.detailValueSet){
                        this.detailOptions.push({label : result.detailValueSet[temp], value : result.detailValueSet[temp]});
                    }
                }
                else{
                    this.detailValue = '';
                    this.detailOptions = [];
                }

            

                if(result.subDetailValueSet != undefined && result.subDetailValueSet.length > 0){
                    this.subDetailOptions = [];
                    for(let temp in result.subDetailValueSet){
                        this.subDetailOptions.push({label : result.subDetailValueSet[temp], value : result.subDetailValueSet[temp]});
                    }
                }
                else{
                    this.subDetailValue = '';
                    this.subDetailOptions = [];
                }


            }
            else{
                this.maincategoryOptions = [];
                this.allegedIssueOptions = [];
                this.detailOptions = [];
                this.subDetailOptions = [];

                this.mainCategoryValue = '';
                this.allegedIssueValue = '';
                this.detailValue = '';
                this.subDetailValue = '';
            }
        });
    }

    handleCancel(event){
        let recid = 'Edit';
        this.template.querySelector(`[data-id="${recid}"]`).classList.remove('hide');
        
        recid = 'Cancel';
        this.template.querySelector(`[data-id="Cancel"]`).classList.add('hide');

        recid = 'Save';
        this.template.querySelector('[data-id="Save"]').classList.add('hide');

        this.mainCategoryDisabled = true;
        this.allegedIssueDisabled = true;
        this.detailDisabled = true;
        this.subDetailDisabled = true;
        this.disableCheckboxes = true;
        this.setCaseValues();
    }

    handleSave(event){
        let recid = 'Edit';
        this.template.querySelector(`[data-id="${recid}"]`).classList.remove('hide');
        
        recid = 'Cancel';
        this.template.querySelector(`[data-id="Cancel"]`).classList.add('hide');

        recid = 'Save';
        this.template.querySelector('[data-id="Save"]').classList.add('hide');

        this.mainCategoryDisabled = true;
        this.allegedIssueDisabled = true;
        this.detailDisabled = true;
        this.subDetailDisabled = true;
        this.disableCheckboxes = true;

        saveCaseRecord({recordId: this.recordId,allegedInjury: this.allegedInjuryValue,allegedProperty: this.allegedPropertyValue,allegedHardware: this.allegedHardwareValue,allegedThermal: this.allegedThermalValue ,mainCategory: this.mainCategoryValue, allegedIssue: this.allegedIssueValue, detail: this.detailValue, subDetail: this.subDetailValue}).then(result=>{
            if(result == 'Updated'){

                const event = new ShowToastEvent({
                    title: 'Success',
                    message:'Warranty Details saved successfully',
                    variant: 'success'
                });
                this.dispatchEvent(event);
                this.setCaseValues();
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message:result,
                    variant: 'error'
                });
                this.dispatchEvent(event);
            }
        });
    }
}