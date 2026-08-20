const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseOrderItemSet } = cds.entities('CatalogService')

  //non instance bound function
  this.on('getMostExpOrders', async (req) => {

    const zkas = req.data.zkas;

    //get the tx api - transaction
    const tx = cds.tx(req);
    //get the top 3 most exp product
    const response = await tx.read(PurchaseOrderSet).orderBy({
      GROSS_AMOUNT: 'desc'
    }).limit(zkas);

    return response;

  });


  this.on('boost', async(req) => {

    try {
        //Extract the pk of data which was passed when action was invoked
        let primaryKey = req.params[0];

        console.log("aaya kya ", JSON.stringify(primaryKey));

        //CDS QL
        //Get the CDS transaction api object
        const tx = cds.tx(req);
        //CDS QL to change data in database
        // UPDATE table SET gross_amount = gross + 20000 WHERE node_key = pk
        await tx.update(PurchaseOrderSet).with({
          GROSS_AMOUNT: {'+=': 20000},
          NOTE: 'boosted!!'
        }).where(primaryKey);

        //Query data which is now updated in database
        return await tx.read(PurchaseOrderSet).where(primaryKey);
    } catch (error) {
        return new Error(error);
    }

  });

  this.on('getDefaultOrderData', async(req) => {
    return {
      OVERALL_STATUS : 'P',
      LIFECYCLE_STATUS : 'N'
    }
  });

  this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
    //console.log('Before CREATE/UPDATE EmployeeSet', req.data)
    if(parseFloat(req.data.salaryAmount) > 1000000){
      req.error(500, "Hey Amigo!! check the salary, none of employee gets more than a million");
    }
  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], AddressSet, async (req) => {
    console.log('Before CREATE/UPDATE AddressSet', req.data)
  })
  this.after ('READ', AddressSet, async (addressSet, req) => {
    console.log('After READ AddressSet', addressSet)
  })
  this.before (['CREATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
    if(!req.data.PO_ID){
      return req.error(500,"Bro, gimee the po id atleast");
    }
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
    //console.log('After READ PurchaseOrderSet', purchaseOrderSet)
    for (let i = 0; i < purchaseOrderSet.length; i++) {
      const element = purchaseOrderSet[i];
      if(!element.NOTE){
        element.NOTE = "Not Found";
      }
      
    }
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderItemSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderItemSet', req.data)
  })
  this.after ('READ', PurchaseOrderItemSet, async (purchaseOrderItemSet, req) => {
    console.log('After READ PurchaseOrderItemSet', purchaseOrderItemSet)
  })


  return super.init()
}}
