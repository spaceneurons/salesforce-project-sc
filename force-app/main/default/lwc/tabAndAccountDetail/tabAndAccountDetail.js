import { LightningElement, api, wire, track} from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import searchAcc from'@salesforce/apex/GetOppForTabAndAcc.searchAcc';
import getAcc from'@salesforce/apex/GetOppForTabAndAcc.getAcc';
import GetProd from'@salesforce/apex/GetOppForTabAndAcc.getProd';
import GetTotalRecords from'@salesforce/apex/GetOppForTabAndAcc.getTotalRecords';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";



import getOpportunitiesWithClosedDate from '@salesforce/apex/GetOppForTabAndAcc.getOpportunitiesWithClosedDate';
import getProduct from '@salesforce/apex/GetOppForTabAndAcc.getProduct';
import getAccountNumber from '@salesforce/apex/GetOppForTabAndAcc.getAccountNumber';
import Amount from '@salesforce/schema/Opportunity.Amount';
import Name from '@salesforce/schema/Opportunity.Name';
import CloseDate from '@salesforce/schema/Opportunity.CloseDate';
import CreatedDate from '@salesforce/schema/Opportunity.CreatedDate';
import getOppoortunitiesForOneAccount from '@salesforce/apex/GetOppForTabAndAcc.getOppoortunitiesForOneAccount';

const actions = [
    { label: 'Open', name: 'open' },
];

const COLUMNS=[
    { label: 'Name', fieldName: Name.fieldApiName, type: 'text'},
    { label: 'Amount', fieldName: Amount.fieldApiName, type: 'number' },
    { label: 'CloseDate', fieldName: CloseDate.fieldApiName, type: 'date' },
    { label: 'CreatedDate', fieldName: CreatedDate.fieldApiName, type: 'date' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
]

import NAME_FIELD from "@salesforce/schema/Opportunity.Name";
const FIELDS = [NAME_FIELD];
const columns = [
    { label: 'Name', fieldName: Name.fieldApiName, type: 'text'  },
    { label: 'Create Date', fieldName: CreatedDate.fieldApiName, type: 'date' },
    { label: 'Close Date', fieldName: CloseDate.fieldApiName, type: 'date' },
    { label: 'Amount', fieldName: Amount.fieldApiName, type: 'number' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class OppAccountInfo extends  NavigationMixin(LightningElement)   {
  data = [];
  columns = columns;

  @api objectApiName;
  @api recordId;
 
  
  @track Accs;
  @track Acc;
  @track Prods;
  @track showModal = false;
  @track productId = '';
  @track pageSize = 10;
  @track pageNumber = 1;
  @track totalRecords = 0;
  @track totalPages = 0;
  @track recordEnd = 0;
  @track recordStart = 0;
  @track isPrev = true;
  @track isNext = false;
  @track openModal=false;
    columns = COLUMNS;
    @track data;
    @track record =[];
    @track opp;
    @track searchKey = '';
    @track paginationRange = [];
    @track count = 0;
    @track totalRecords;
    @track dataForRecord;
    @track dataForFilterByAmount;
    constructor() {
        super();
        getAccountNumber().then(count => {
            if (count) {
    
                this.totalRecords = count;
                getOpportunitiesWithClosedDate({searchKey:'',offsetRange:null}).then(result => {
                    let i = 1;
                    this.data = result;
                    this.getNormaldata(result,1);
                    let paginationNumbers = Math.ceil(this.totalRecords / 10);
                    while (
                        this.paginationRange.push(i++) < paginationNumbers
                    ) {}
                });
            }
        });
    }
    @wire(getOppoortunitiesForOneAccount,{ids :'$recordId'}) infoAboutOneAccount(result){
        if(result.data){
            if(result.data.length >= 1){
                this.dataForRecord = result.data;
            }
            else{
                console.log('error with one account');
            }
        }
    }
    
    @wire(getOpportunitiesWithClosedDate,{searchKey : '$searchKey',offsetRange: null}) accounts(result){
        if (result.data) {

            this.error = undefined;
            this.getNormaldata(result.data,1);
            

        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'open':
                this.openModalWindow(row);
                break;
            default:
        }
    }

    openModalWindow(row){
        this.openModal = true;
        this.record=row;

        getProduct({ids : this.record.Id})
        .then(result =>{
            if(result.length >= 1){
                this.opp=result;
            }
            else{
                this.opp=null;
            }
        })
        .catch(error => {
            console.log('open modal wndow error');
        });
    }

    closeModal() {
        this.openModal = false;
    }

    handleKeyChange(event){
        this.searchKey = event.target.value;
    }

    handlePaginationClick(event) {
        let offsetNumber = event.target.dataset.targetNumber;
        getOpportunitiesWithClosedDate({searchKey: this.searchKey ,offsetRange: 10 * (offsetNumber - 1) })
            .then(data => {
                this.getNormaldata(data,offsetNumber);
            })
            .catch(error => {
                console.log('handleClick');
            });
    }

    getNormaldata(data,offsetNumber){
        this.data = data;
        var tempOppList = [];  
        let offset=0;
        if(offsetNumber==1){
            offset=10 * (offsetNumber - 1);
        }
        else{
            offset=10 * (offsetNumber - 1);
        }
        

        for(let j=0;j<this.data.length;j++){
            let tempRecord = Object.assign({}, this.data[j]);

            if(this.data[j].Opportunities != null){
                let total = 0;

                for(let i = 0; i<this.data[j].Opportunities.length;i++){
                    total += this.data[j].Opportunities[i].Amount;  
                }
                
                tempRecord.Total = total;
                tempRecord.NameAndSum =' Name: ' +  this.data[j].Name + ' Amount: ' + total;
                       
            }
            else{
                tempRecord.Total=0;
                tempRecord.NameAndSum = ' Name: ' +  this.data[j].Name + ' Amount: ' + 0;
            }

            tempOppList.push(tempRecord); 
        }
        
        this.data=tempOppList;
        tempOppList = [];
        let reg = new RegExp('^[0-9]+$');
        let listForSearchByNumber = [];

        if(this.searchKey != null && this.searchKey != '' && reg.test(this.searchKey))
        {
            for(let j=0;j<this.data.length;j++){
                let tempRecord = Object.assign({}, this.data[j]);
                
                if(this.data[j].Total == this.searchKey){
                    tempOppList.push(tempRecord);
                }    
            }

            for(let j = offset; j<tempOppList.length;j++){
                let tempRecord = Object.assign({}, tempOppList[j]);

                if(listForSearchByNumber.length == 10){
                    break;
                }

                if(tempOppList[j].Total==this.searchKey){
                    listForSearchByNumber.push(tempRecord);
                }
            }
            this.data=listForSearchByNumber;
        }
    }
  renderedCallback(){
    
  if (this.totalRecords.data)  this.getAccounts();
  
}
  
 @wire(searchAcc, {accountName: '$searchAcc', searchSum:'$searchSum', pageSize: '$pageSize', pageNumber: '$pageNumber'}) Accs;
 @wire(getAcc, {idAcc:"$recordId"}) Acc;
 @wire(GetProd, {id: '$productId'}) Prods;
 @wire(getRecord, {recordId: "$recordId", fields: FIELDS}) account;
                  get name() {
                  return this.account.data.fields.Name.value;
                  }
 @wire(GetTotalRecords, {accountName: '$searchAcc', searchSum:'$searchSum'}) totalRecords;
 
 searchAcc = '';
 searchSum = 999999.99;
 
getAccounts(){
  
  
 this.recordStart = (this.pageNumber - 1) * this.pageSize+1;
 if (this.totalRecords.data <= this.pageNumber*this.pageSize)    
    {this.recordEnd =this.totalRecords.data  } 
  else 
    {this.recordEnd = this.pageNumber*this.pageSize;}
 
 this.totalPages = Math.ceil(this.totalRecords.data / this.pageSize);
 this.isNext = (this.pageNumber == this.totalPages || this.totalPages == 0);
 this.isPrev = (this.pageNumber == 1 || this.totalRecords.data < this.pageSize);
 
}
 
    handleNext(){
        this.pageNumber = this.pageNumber+1;
        this.getAccounts();
    }
 
    handlePrev(){
        this.pageNumber = this.pageNumber-1;
        this.getAccounts();
    }
 
  changeHandlerAcc(event) {
    this.searchAcc = event.target.value;
    this.getAccounts();
  }
  changeHandlerSum(event) {
    this.searchSum = event.target.value;
    this.getAccounts();
  }
  get showSearch(){
    if(this.objectApiName == null){
            return true;} 
    else {
        return false;
  }
  }
//   openModal(event) {
//       this.showModal = true;
//      this.productId = event.detail.row.oppId;
//   }
//   closeModal() {
//       this.showModal = false;
//       this.productId = '';
//   }
  
  
 


}