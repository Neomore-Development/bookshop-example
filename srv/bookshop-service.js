const cds = require('@sap/cds')

module.exports = class BookshopService extends cds.ApplicationService {
  init() {

    const { Books, Authors, Reviews, Genres, Orders, OrderItems, Customers } = cds.entities('BookshopService')

    this.before(['CREATE', 'UPDATE'], Books, async (req) => {
      console.log('Before CREATE/UPDATE Books', req.data)
    })

    this.after('READ', Books, async (books, req) => {
      books.forEach((book) => {
        if (book.stock === 0) {
          book.stockCriticality = 1; // Low = Red
        } else if (book.stock <= 5) {
          book.stockCriticality = 2; // Medium = Yellow
        } else {
          book.stockCriticality = 3; // High = Green
        }
      });
    })

    this.before(['CREATE', 'UPDATE'], Authors, async (req) => {
      console.log('Before CREATE/UPDATE Authors', req.data)
    })
    this.after('READ', Authors, async (authors, req) => {
      console.log('After READ Authors', authors)
    })
    this.before(['CREATE', 'UPDATE'], Reviews, async (req) => {
      console.log('Before CREATE/UPDATE Reviews', req.data)
    })

    this.after('READ', Reviews, async (reviews, req) => {
      reviews.forEach((review) => {
        if (review.rating <= 2) {
          review.ratingCriticality = 1;
        } else if (review.rating === 3) {
          review.ratingCriticality = 2;
        } else {
          review.ratingCriticality = 3;
        }
      });
    });

    this.before(['CREATE', 'UPDATE'], Genres, async (req) => {
      console.log('Before CREATE/UPDATE Genres', req.data)
    })
    this.after('READ', Genres, async (genres, req) => {
      console.log('After READ Genres', genres)
    })
    this.before(['CREATE', 'UPDATE'], Orders, async (req) => {
      console.log('Before CREATE/UPDATE Orders', req.data)
    })
    this.after('READ', Orders, async (orders, req) => {
      console.log('After READ Orders', orders)
    })
    this.before(['CREATE', 'UPDATE'], OrderItems, async (req) => {
      console.log('Before CREATE/UPDATE OrderItems', req.data)
    })
    this.after('READ', OrderItems, async (orderItems, req) => {
      console.log('After READ OrderItems', orderItems)
    })
    this.before(['CREATE', 'UPDATE'], Customers, async (req) => {
      console.log('Before CREATE/UPDATE Customers', req.data)
    })
    this.after('READ', Customers, async (customers, req) => {
      console.log('After READ Customers', customers)
    })

    this.on('topRatedBooks', async (req) => {
      const limit = req.data.limit ?? 5;  // default to 5 if not provided
      const reviews = await SELECT.from(Reviews);
      console.log(reviews);
      const bookAverages = {};
      reviews.forEach((review) => {
        if (!bookAverages[review.book_ID]) {
          bookAverages[review.book_ID] = [review.rating];
        } else {
          bookAverages[review.book_ID].push(review.rating);
        }
      });
      const bookAveragesArray = Object.keys(bookAverages).map(key => {
        const average = bookAverages[key].reduce((acc, rating) => acc + Number(rating), 0) / bookAverages[key].length;
        return {
          ID: key,
          average: average
        };
      });
      bookAveragesArray.sort((a,b) => {
        return a.average < b.average ? 1 : -1;
      });
      const fetchBooks = bookAveragesArray.splice(0, limit);
      const books = await SELECT.from(Books)
        .columns('ID', 'title')
        .where({
          ID: fetchBooks.map((review => review.ID))
        });
      return books;
    });

    this.on('placeOrder', async (req) => {
      const { customer, items } = req.data;

      // Create order
      const order = await INSERT.into(Orders).entries({ customer });

      // Insert order items
      for (let item of items) {
        const book = await SELECT.one.from(Books).where({ ID: item.book });
        if (!book) req.error(404, `Book ${item.book} not found`);

        await INSERT.into(OrderItems).entries({
          order_ID: order.ID,
          book_ID: book.ID,
          quantity: item.quantity,
          price: book.price,
          currency_code: book.currency_code
        });
      }

      return order;
    });

    this.on('restockBook', async (req) => {
      const { book, amount } = req.data;
      await UPDATE(Books)
        .set({ stock: { '+=': amount } })
        .where({ ID: book });
      return SELECT.one.from(Books).where({ ID: book });
    });

    return super.init()
  }
}
