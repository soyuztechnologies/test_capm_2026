//type pools / include program in abap
using { anubhav.common } from './common';
using { cuid, Currency } from '@sap/cds/common';

//unique name for project
namespace anubhav.db;

//grouping of data
context master{
    //anubhav_db_master_businesspartner
    entity businesspartner{
        key NODE_KEY: common.Guid @title : '{i18n>PARTNER_KEY}';
        BP_ROLE: String(2);
        EMAIL_ADDRESS: String(125);
        PHONE_NUMBER: String(32);
        FAX_NUMBER: String(32);
        WEB_ADDRESS: String(44);
        COMPANY_NAME: String(250) @title : '{i18n>COMPANY_NAME}';
        BP_ID: String(32);
        //foreign key relationship
        ADDRESS_GUID: Association to one address;
    }

    entity address{
        key NODE_KEY: common.Guid;
        CITY: String(44) @title : '{i18n>CITY}';
        POSTAL_CODE: String(8);
        STREET: String(44);
        BUILDING: String(128);
        COUNTRY: String(44) @title : '{i18n>SPIDERMAN}';
        ADDRESS_TYPE: String(44);
        VAL_START_DATE: Date;
        VAL_END_DATE: Date;
        LATITUDE: Decimal;
        LONGITUDE: Decimal;
        //we can also have the backward relationship - NOT MANDATORY
        //$self - predicate provided by capm to refer current table PK
        businesspartner: Association to one businesspartner on
                            businesspartner.ADDRESS_GUID = $self;
    }

    entity employees: cuid{
        nameFirst: String(256);
        nameMiddle: String(256);
        nameLast: String(256);
        nameInitials: String(40);
        sex: common.gender;
        language: String(1);
        phoneNumber: common.PhoneNumber;
        email: common.Email;
        loginName: String(12);
        Currency: Currency;
        salaryAmount: common.AmountT ;
        accountNumber: String(40);
        bankId: String(40);
        bankName: String(64);
        country: String(3);
    }

    entity product{
        key NODE_KEY :common.Guid @title : '{i18n>PRODUCT_KEY}';
        PRODUCT_ID: String(28);
        TYPE_CODE: String(2);
        CATEGORY: String(32);
        //capm will automatically create a text table with this field
        DESCRIPTION: localized String(255) @title : '{i18n>PROD_NAME}';
        SUPPLIER_GUID: Association to one businesspartner;
        TAX_TARIF_CODE: Integer;
        MEASURE_UNIT: String(2);
        WEIGHT_MEASURE: Decimal(5,2) @(Semantic.quantity.unit: 'WEIGHT_UNIT');
        WEIGHT_UNIT: String(2);
        CURRENCY: Currency;
        PRICE: Decimal(15,2) @(Semantic.amount.currencyCode: 'CURRENCY_code');
        WIDTH: Decimal(5,2) @(Semantic.quantity.unit: 'DIM_UNIT');
        HEIGHT: Decimal(5,2) @(Semantic.quantity.unit: 'DIM_UNIT');
        DEPTH: Decimal(5,2) @(Semantic.quantity.unit: 'DIM_UNIT');
        DIM_UNIT: String(2);
    }

    entity StatusCode {
        key STATUS: String(1);
        text: String(10);
    }

}

context transaction{

    entity purchaseorder: common.Amount, cuid{
        //key NODE_KEY : common.Guid @title : '{i18n>PO_KEY}';
        PO_ID: String(32) @title : '{i18n>PO_ID}';
        PARTNER_GUID: Association to one master.businesspartner @title : '{i18n>PARTNER_KEY}';
        LIFECYCLE_STATUS: String(1) @title : '{i18n>STATUS}';
        OVERALL: Association to one master.StatusCode @title : '{i18n>STATUS}';
        NOTE: String(255) @title : '{i18n>NOTE}';
        Items: Composition of many poitems on
                        Items.PARENT_KEY = $self @title : '{i18n>PO_ITEM_KEY}';        
    }

    entity poitems: common.Amount, cuid{
        //key NODE_KEY : common.Guid @title : '{i18n>PO_ITEM_KEY}';
        PARENT_KEY: Association to one purchaseorder @title : '{i18n>PO_KEY}';
        PO_ITEM_POS: Integer @title : '{i18n>PO_ITEM_POS}';
        PRODUCT_GUID: Association to one master.product @title : '{i18n>PRODUCT_KEY}';

        
    }

}

