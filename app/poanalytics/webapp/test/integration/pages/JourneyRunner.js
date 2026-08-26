sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"anubhav/ana/poanalytics/test/integration/pages/PurchaseAnalyticsList.gen",
	"anubhav/ana/poanalytics/test/integration/pages/PurchaseAnalyticsObjectPage.gen"
], function (JourneyRunner, PurchaseAnalyticsListGenerated, PurchaseAnalyticsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('anubhav/ana/poanalytics') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseAnalyticsListGenerated: PurchaseAnalyticsListGenerated,
			onThePurchaseAnalyticsObjectPageGenerated: PurchaseAnalyticsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

