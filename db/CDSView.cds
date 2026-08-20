using { anubhav.db.master, anubhav.db.transaction } from './datamodel';

namespace anubhav.cds;

context CDSView{

    define view ![POWorklist] as 
        select from transaction.purchaseorder{
            key PO_ID as ![PurchaseOrderId],
            key Items.PO_ITEM_POS as ![ItemPosition],
            PARTNER_GUID.BP_ID as ![SupplierId],
            PARTNER_GUID.COMPANY_NAME as ![CompanyName],
            Items.GROSS_AMOUNT as ![GrossAmount],
            Items.NET_AMOUNT as ![NetAmount],
            Items.TAX_AMOUNT  as ![TaxAmount],
            Items.CURRENCY  as ![CurrencyCode],
            OVERALL  as ![Status],
            Items.PRODUCT_GUID.CATEGORY as ![ProductCategory],
            Items.PRODUCT_GUID.DESCRIPTION as ![ProductName],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country]
        }

    define view ![ItemView] as 
        select from transaction.poitems{
            key PARENT_KEY.PARTNER_GUID.NODE_KEY as ![SupplierId],
            key PRODUCT_GUID.NODE_KEY as ![ProductKey],
            CURRENCY as ![CurrencyCode],
            GROSS_AMOUNT as ![GrossAmount],
            NET_AMOUNT as ![NetAmount],
            TAX_AMOUNT as ![TaxAmount],
            PARENT_KEY.OVERALL as ![Status]
        };

    //view on view + lazy loading (mixin)
    define view ![ProductView] as select from master.product
    //mixin is a keyword in capm to perform lazy loading , on-demand join
    //it will always only load data from only and only product table initially
    //when user drill down, that is when it will perform a join to fetch items data
    mixin{
        PO_ORDER: Association to many ItemView on PO_ORDER.ProductKey = $projection.ProductId
    } into 
    {
        key NODE_KEY as ![ProductId],
        DESCRIPTION as ![Description],
        CATEGORY as ![Category],
        PRICE as ![Price],
        SUPPLIER_GUID.COMPANY_NAME as ![Vendor],
        SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
        //Exposed association = @ runtime the data will be loaded
        PO_ORDER as![To_Items]
    };

    define view CProductView as 
        select from ProductView{
            key ProductId,
            key Country,
            round(sum(To_Items.GrossAmount),2) as![TotalAmount],
            To_Items.CurrencyCode
        } group by ProductId, Country, To_Items.CurrencyCode;

}
// context yamini{
//     define view supplier as
//         select from master.businesspartner
//         mixin{
//             orders: Association to many CDSView.POWorklist on   
//             ...
//         } into {

//         }
// }
