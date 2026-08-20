const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CDSService extends cds.ApplicationService { init() {

  const { ProductSet, ItemSet } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    //console.log('After READ ProductSet', productSet)
    let aIds = productSet.map(anubhav => anubhav.ProductId);
    //CQL - CDS query language
    const orderCount = await SELECT.from(ItemSet)
                             .columns('ProductKey', {func: 'count', as : 'spiderman'})
                             .where({'ProductKey': {in : aIds}})
                             .groupBy('ProductKey');


    for (let i = 0; i < productSet.length; i++) {
      const element = productSet[i];
      const foundRecord = orderCount.find(wa => wa.ProductKey === element.ProductId);
      if(foundRecord){
        element.purchCount = foundRecord.spiderman;
      }else{
        element.purchCount = 0;
      }
    }

  })
  this.before (['CREATE', 'UPDATE'], ItemSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemSet', req.data)
  })
  this.after ('READ', ItemSet, async (itemSet, req) => {
    console.log('After READ ItemSet', itemSet)
  })


  return super.init()
}}
