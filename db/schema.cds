namespace my.bookshop;

using { Currency, cuid, managed, sap.common.CodeList } from '@sap/cds/common';

// Reuse common code lists
entity Languages : CodeList {
  key code : String(5);
  name     : localized String(100);
}

// Authors with composition to Books
entity Authors : cuid, managed {
  firstName : String(111);
  lastName  : String(111);
  dateOfBirth : Date;
  nationality : String(50);
  books : Composition of many Books
    on books.author = $self;
}

// Books entity with advanced features
entity Books : cuid, managed {
  title       : localized String(200);
  descr       : localized String(1000);
  stock       : Integer default 0;
  price       : Decimal(9,2);
  currency    : Currency;
  publishedAt : Date;
  IBAN        : String;
  genre       : Association to Genres;
  author      : Association to Authors;
  translations: Composition of many BookTranslations
                  on translations.book = $self;
  reviews     : Composition of many Reviews
                  on reviews.book = $self;

  // Virtual field calculated at runtime
  virtual fullTitle : String(300) @readonly;
  virtual stockCriticality: Integer;
}

// Genres hierarchy
entity Genres : cuid, managed {
  name     : localized String(100);
  parent   : Association to Genres;
  children : Composition of many Genres
               on children.parent = $self;
}

// Separate translations (per language)
entity BookTranslations : cuid, managed {
  book     : Association to Books;
  language : Association to Languages;
  title    : localized String(200);
  summary  : localized String(1000);
}

// Reviews with user info
entity Reviews : cuid, managed {
  book    : Association to Books;
  rating  : Integer enum {
    One = 1;
    Two = 2;
    Three = 3;
    Four = 4;
    Five = 5;
  };
  comment : String(1000);
  reviewer: String(111);
}

// Customers with draft handling enabled
@odata.draft.enabled
entity Customers : cuid, managed {
  firstName : String(111);
  lastName  : String(111);
  email     : String(255);
  addresses : Composition of many Addresses
                on addresses.customer = $self;
  orders    : Composition of many Orders
                on orders.customer = $self;
}

entity Addresses : cuid, managed {
  street   : String(200);
  city     : String(100);
  zip      : String(10);
  country  : String(50);
  customer : Association to Customers;
}

// Orders with nested compositions
entity Orders : cuid, managed {
  orderNo   : Integer;
  createdAt : Timestamp;
  customer  : Association to Customers;
  items     : Composition of many OrderItems
                on items.order = $self;

  // totalAmount calculated from items
  virtual totalAmount : Decimal(15,2) @readonly;
}

entity OrderItems : cuid, managed {
  order    : Association to Orders;
  book     : Association to Books;
  quantity : Integer;
  price    : Decimal(9,2);
  currency : Currency;
}