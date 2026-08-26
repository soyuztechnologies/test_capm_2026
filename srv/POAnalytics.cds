using { anubhav.cds as spiderman } from '../db/CDSView';


service POAnalytics @(path: 'POAnalytics') {

    entity PurchaseAnalytics as projection on spiderman.CDSView.POWorklist;

}

//the first block focus on enabling aggregate functions, these annotations are crutial for fiori app
// tools to properly recognize the support for ALP app. without them, when we use template
// the service is visible but no entitiy was available to proceed
annotate POAnalytics.PurchaseAnalytics with @(

    Aggregation.ApplySupported: {
        Transformations: [
            'aggregate',
            'topcount',
            'bottomcount',
            'identity',
            'concat',
            'groupby',
            'filter',
            'expand',
            'search'
        ],
        GroupableProperties: [
            CompanyName,
            Country,
            CurrencyCode,
            Status,
            ProductCategory,
            ProductName            
        ],
        AggregatableProperties:[
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : GrossAmount,
            },
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : TaxAmount,
            },
        ]
    },
    Analytics.AggregatedProperty #totalAmount: {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TotalAmount',
        AggregationMethod : 'sum',
        AggregatableProperty : GrossAmount,
        ![@Common.Label]: 'Zkas Total'
    },
    Analytics.AggregatedProperty #avgTax: {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'AverageTax',
        AggregationMethod : 'avg',
        AggregatableProperty : TaxAmount,
        ![@Common.Label]: 'Zkas Tax'
    },
);

//the secomd block is for dispalying the chart in the middle of ALP
//One point that was new to me was use of Dynamic measure as compare to abap cds

annotate POAnalytics.PurchaseAnalytics with @(
    //How my chart will be plotted - x-axis and y-axis
    UI.Chart: {
        $Type : 'UI.ChartDefinitionType',
        Title:  'Total Purchase from Company',
        ChartType : #Column,
        Dimensions:[
            CompanyName,
            Country,
            ProductCategory,
            ProductName,
            CurrencyCode
        ],
        DimensionAttributes:[
            {
                $Type : 'UI.ChartDimensionAttributeType',
                Dimension: CompanyName,
                Role: #Category
            },
        ],
        DynamicMeasures: [
            @Analytics.AggregatedProperty#totalAmount,
            @Analytics.AggregatedProperty#avgTax
        ],
        MeasureAttributes:[{
            $Type : 'UI.ChartMeasureAttributeType',
            DynamicMeasure: @Analytics.AggregatedProperty#totalAmount,
            Role: #Axis1
        }]

    },
    //when the app load, what is the default configuration
    UI.PresentationVariant: {
        $Type : 'UI.PresentationVariantType',
        Visualizations: [
            @UI.Chart
        ]
    },
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : PurchaseOrderId,
        },
        {
            $Type : 'UI.DataField',
            Value : CompanyName,
        },
        {
            $Type : 'UI.DataField',
            Value : ProductCategory,
        },
        {
            $Type : 'UI.DataField',
            Value : ProductName,
        },
        {
            $Type : 'UI.DataField',
            Value : GrossAmount,
        },
        {
            $Type : 'UI.DataField',
            Value : TaxAmount,
        },
        {
            $Type : 'UI.DataField',
            Value : NetAmount,
        },
    ],
    UI.SelectionFields: [
        CompanyName,
        Country,
        CurrencyCode,
        ProductCategory,
        Status,
        GrossAmount
    ]

);

//the third block for displaying a visual filter
//Show a Donut chart for country wise purchase as a VF
annotate POAnalytics.PurchaseAnalytics with @(
    UI.Chart #VFCountry : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bar,
        Dimensions: [Country],
        DynamicMeasures: [@Analytics.AggregatedProperty#totalAmount],
        DimensionAttributes: [{
            $Type : 'UI.ChartDimensionAttributeType',
            Dimension : Country,
            Role : #Category,
        },],
        MeasureAttributes:[
            {
                $Type : 'UI.ChartMeasureAttributeType',
                Measure : GrossAmount,
                Role : #Axis1,
            },
        ]
    },
    UI.PresentationVariant #VFPVCountry: {
        $Type : 'UI.PresentationVariantType',
        Visualizations: [
            @UI.Chart#VFCountry
        ]
    },
){
    Country @Common.ValueList #VFVLCountry: {
        $Type : 'Common.ValueListType',
        CollectionPath: 'PurchaseAnalytics',
        Parameters: [{
            $Type : 'Common.ValueListParameterInOut',
            LocalDataProperty : Country,
            ValueListProperty : 'Country',
        },],
        PresentationVariantQualifier: 'VFPVCountry'
    }
};

annotate POAnalytics.PurchaseAnalytics with @(
    UI.Chart #VFProductCategory : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bar,
        Dimensions: [ProductCategory],
        DynamicMeasures: [@Analytics.AggregatedProperty#avgTax],
        DimensionAttributes: [{
            $Type : 'UI.ChartDimensionAttributeType',
            Dimension : ProductCategory,
            Role : #Category,
        },],
        MeasureAttributes:[
            {
                $Type : 'UI.ChartMeasureAttributeType',
                Measure : TaxAmount,
                Role : #Axis1,
            },
        ]
    },
    UI.PresentationVariant #VFPVProductCategory: {
        $Type : 'UI.PresentationVariantType',
        Visualizations: [
            @UI.Chart#VFProductCategory
        ]
    },
){
    ProductCategory @Common.ValueList #VFVLProductCategory: {
        $Type : 'Common.ValueListType',
        CollectionPath: 'PurchaseAnalytics',
        Parameters: [{
            $Type : 'Common.ValueListParameterInOut',
            LocalDataProperty : ProductCategory,
            ValueListProperty : 'ProductCategory',
        },],
        PresentationVariantQualifier: 'VFPVProductCategory'
    }
};

