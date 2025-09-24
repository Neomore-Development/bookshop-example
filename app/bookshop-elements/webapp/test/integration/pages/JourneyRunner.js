sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"bookshopelements/bookshopelements/test/integration/pages/BooksList",
	"bookshopelements/bookshopelements/test/integration/pages/BooksObjectPage",
	"bookshopelements/bookshopelements/test/integration/pages/ReviewsObjectPage"
], function (JourneyRunner, BooksList, BooksObjectPage, ReviewsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('bookshopelements/bookshopelements') + '/test/flp.html#app-preview',
        pages: {
			onTheBooksList: BooksList,
			onTheBooksObjectPage: BooksObjectPage,
			onTheReviewsObjectPage: ReviewsObjectPage
        },
        async: true
    });

    return runner;
});

