sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"anubhav/ui/manageorders/test/integration/pages/PurchaseOrderSetList.gen",
	"anubhav/ui/manageorders/test/integration/pages/PurchaseOrderSetObjectPage.gen",
	"anubhav/ui/manageorders/test/integration/pages/PurchaseOrderItemSetObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSetListGenerated, PurchaseOrderSetObjectPageGenerated, PurchaseOrderItemSetObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('anubhav/ui/manageorders') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetListGenerated: PurchaseOrderSetListGenerated,
			onThePurchaseOrderSetObjectPageGenerated: PurchaseOrderSetObjectPageGenerated,
			onThePurchaseOrderItemSetObjectPageGenerated: PurchaseOrderItemSetObjectPageGenerated
        },
        async: true
    });

    return runner;
});

