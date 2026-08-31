using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';

service CatalogService @(path: 'CatalogService',
                         requires: 'authenticated-user') {

    //@readonly
    //@Capabilities.Deletable: false
    entity EmployeeSet @(restrict : 
                                    [
                                        {
                                            grant: ['READ'],
                                            to: 'Display',
                                            where: 'bankName = $user.Spiderman'
                                        },
                                        {
                                            grant: ['WRITE','DELETE'],
                                            to: 'Edit'
                                        }
                                    ]
                        )
    
     as projection on master.employees;    
    entity ProductSet as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    entity StatusCodeSet as projection on master.StatusCode;
    entity PurchaseOrderSet 
        @(odata.draft.enabled: true,
          odata.draft.bypass: true,
          Common.DefaultValuesFunction: 'getDefaultOrderData')
    as projection on transaction.purchaseorder{
        *,
        case 
            when OVERALL.STATUS = 'A' then cast(3 as Integer)
            when OVERALL.STATUS = 'D' then cast(3 as Integer)
            when OVERALL.STATUS = 'X' then cast(1 as Integer)
            when OVERALL.STATUS = 'P' then cast(2 as Integer)
            when OVERALL.STATUS = 'N' then cast(2 as Integer)
            else cast(0 as Integer)
            end as Superman: Integer
    }
    // instance-bound action, when we cann this action, as a caller we must pass PK
    // we will receive the PK as a input automatically
    actions{
        // The annotation side effect will inform fiori that there is a change in backend data for
        // GROSS_AMOUNT, hence once the boost action is triggered, kindly load the amount from backend
        @Common : { SideEffects : {
            $Type : 'Common.SideEffectsType',
            TargetProperties: ['in/GROSS_AMOUNT']
        }, }
        action boost() returns PurchaseOrderSet;
    };
    entity PurchaseOrderItemSet as projection on transaction.poitems;

    function getDefaultOrderData() returns PurchaseOrderSet;
    //non instance bound funtion - get top 3 most expensive pos
    function getMostExpOrders(zkas : Integer) returns many PurchaseOrderSet;
    
}

annotate CatalogService with @mcp @odata;