using { Currency } from '@sap/cds/common';

namespace anubhav.common;

//MY OWN DATA TYPE - domain
type Guid: String(64);

//domain with fix values
type gender: String(1) enum{
    male = 'M';
    female = 'F';
    undisclosed = 'U';
}

type PhoneNumber: String(30);
type Email: String(250);

//CURR type field - reference field CUKY  500 USD/EUR/INR/RUB
//QUANT - UNIT
type AmountT: Decimal(10,2) @(
    Semantic.amount.currencyCode: 'Currency'
);

aspect Amount{
    GROSS_AMOUNT: Decimal(15,2) @(Semantic.amount.currency: 'CURRENCY_code', title: '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT: Decimal(15,2) @(Semantic.amount.currency: 'CURRENCY_code', title: '{i18n>NET_AMOUNT}');
    TAX_AMOUNT: Decimal(15,2) @(Semantic.amount.currency: 'CURRENCY_code', title: '{i18n>TAX_AMOUNT}');
    CURRENCY: Currency @(title: '{i18n>CURRENCY_CODE}');
}