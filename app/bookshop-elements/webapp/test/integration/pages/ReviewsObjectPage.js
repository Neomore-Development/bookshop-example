sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'bookshopelements.bookshopelements',
            componentId: 'ReviewsObjectPage',
            contextPath: '/Books/reviews'
        },
        CustomPageDefinitions
    );
});