using { BookshopService as BS } from './bookshop-service';

// --- Books ---
annotate BS.Books with @(
  Capabilities: {
    InsertRestrictions: { Insertable: true },
    UpdateRestrictions: { Updatable: true },
    DeleteRestrictions: { Deletable: true }
  },
  UI: {
    HeaderInfo: {
      TypeName      : 'Book',
      TypeNamePlural: 'Books',
      Title         : { Value: title, Label: 'Title' },
      Description   : { Value: descr, Label: 'Description' }
    },
    SelectionFields: [ title, author, genre ],
    LineItem: [
      { Value: title, Label: 'Title' },
      { Value: IBAN, Label: 'IBAN' },
      { Value: author.firstName, Label: 'Author' },
      { Value: genre.name, Label: 'Genre' },
      { Value: price, Label: 'Price' },
      { Value: stock, Label: 'Stock', Criticality: stockCriticality }
    ],
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        ID: 'GeneralInfo',
        Label: 'General Info',
        Target: '@UI.FieldGroup#Main'
      },
      {
        $Type: 'UI.ReferenceFacet',
        ID: 'Reviews',
        Label: 'Reviews',
        Target: 'reviews/@UI.LineItem'
      }
    ],
    FieldGroup#Main: {
      Data: [
        { Value: title, Label: 'Title' },
        { Value: descr, Label: 'Description' },
        { Value: publishedAt, Label: 'Published At' },
        { Value: price, Label: 'Price' },
        { Value: IBAN, Label: 'IBAN' },
        { Value: stock, Label: 'Stock', Criticality: stockCriticality }
      ]
    }
  }
);

// --- Authors ---
annotate BS.Authors with @(
  UI: {
    HeaderInfo: {
      TypeName: 'Author',
      TypeNamePlural: 'Authors',
      Title: { Value: lastName },
      Description: { Value: firstName }
    },
    LineItem: [
      { Value: lastName, Label: 'Last Name' },
      { Value: firstName, Label: 'First Name' },
      { Value: books, Label: 'Books' }
    ]
  }
);

// --- Reviews ---
annotate BS.Reviews with @(
  UI: {
    LineItem: [
      {
        Value: rating,
        Label: 'Rating',
        Criticality: ratingCriticality,
        DataPoint: {
          Title: 'Rating',
          Value: rating,
          Visualization: #Rating,
          Criticality: ratingCriticality
        }
      },
      { Value: comment, Label: 'Comment' },
      { Value: reviewer, Label: 'Reviewer' }
    ],
    HeaderInfo: {
      TypeName: 'Review',
      TypeNamePlural: 'Reviews',
      Title: { Value: reviewer },
      Description: { Value: comment }
    },
    FieldGroup#Main: {
      Data: [
        { Value: rating, Label: 'Rating', Criticality: ratingCriticality },
        { Value: comment, Label: 'Comment' },
        { Value: reviewer, Label: 'Reviewer' },
        { Value: book.title, Label: 'Book' }
      ]
    },
    Facets: [
      { ID: 'ReviewDetails', Label: 'Review Details', Target: '@UI.FieldGroup#Main' }
    ]
  }
);

// --- Orders ---
annotate BS.Orders with @(
  UI: {
    HeaderInfo: {
      TypeName      : 'Order',
      TypeNamePlural: 'Orders',
      Title         : { Value: 'orderNo' },
      Description   : { Value: 'createdAt' }
    },
    LineItem: [
      { Value: orderNo, Label: 'Order No' },
      { Value: createdAt, Label: 'Created At' },
      { Value: customer.firstName, Label: 'Customer' },
      { Value: customer.lastName, Label: 'Customer Last Name' }
    ],
    Facets: [
      { ID: 'OrderGeneralInfo', Label: 'General Info', Target: '@UI.FieldGroup#Main' },
      { ID: 'OrderItems', Label: 'Order Items', Target: 'items' }
    ],
    FieldGroup#Main: {
      Data: [
        { Value: orderNo, Label: 'Order No' },
        { Value: createdAt, Label: 'Created At' },
        { Value: customer.firstName, Label: 'First Name' },
        { Value: customer.lastName, Label: 'Last Name' }
      ]
    }
  }
);

// --- Order Items ---
annotate BS.OrderItems with @(
  UI: {
    LineItem: [
      { Value: book.title, Label: 'Book' },
      { Value: quantity, Label: 'Quantity' },
      { Value: price, Label: 'Unit Price' },
      { Value: currency, Label: 'Currency' }
    ]
  }
);
