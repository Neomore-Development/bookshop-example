using my.bookshop as shop from '../db/schema';

service BookshopService {

  @odata.draft.enabled
  entity Books as projection on shop.Books {
    ID,
    title,
    descr,
    stock,
    stockCriticality,
    price,
    currency,
    author,
    genre,
    fullTitle,
    IBAN,
    reviews: redirected to Reviews on reviews.book = $self
  };

  entity Authors as projection on shop.Authors {
    ID,
    firstName,
    lastName,
    books
  };

  entity Reviews as projection on shop.Reviews {
    ID,
    rating,
    comment,
    reviewer,
    book,

    @Core.Computed: true
    @UI.Criticality: #Neutral
    virtual ratingCriticality: Integer
  };

  entity Genres as projection on shop.Genres;

  entity Orders as projection on shop.Orders {
    *
  } excluding {
    createdAt,
    createdBy,
    modifiedAt,
    modifiedBy
  };

  entity OrderItems as projection on shop.OrderItems {
    ID,
    order,
    book,
    quantity,
    price,
    currency
  };

  entity Customers as projection on shop.Customers {
    ID,
    firstName,
    lastName,
    email
  };

  function topRatedBooks(limit : Integer) returns array of BookshopService.Books;

  action placeOrder(
    customer : UUID,
    items    : array of {
      book    : UUID;
      quantity: Integer;
    }
  ) returns BookshopService.Orders;

  action restockBook(book : UUID, amount : Integer) returns BookshopService.Books;

};
