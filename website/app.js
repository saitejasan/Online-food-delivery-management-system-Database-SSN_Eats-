const express = require('express');
const pg = require('pg');
const bodyParser = require('body-parser');


const app = express();
const port = process.env.PORT || 3000;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.set('views', './views');
app.set('view engine', 'ejs');
const session = require('express-session');
app.use(session({
    secret: 'hhhhhhhh',
    resave: false,
    saveUninitialized: true
  }));
  const requireLogin = (req, res, next) => {
    if (req.session && req.session.userId) {
      next();
    } else {
      res.redirect('/');
    }
  };
// Set up PostgreSQL connection
const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL || 'postgres://postgres:Harini@143@localhost:5432/SSN_Eats_Project',
  ssl: process.env.NODE_ENV === 'production',
});

// Set up Express routes
app.get('/', async (req, res) => {
    res.render('login',{message:''});
});
app.post('/', async (req, res) => {
    const { username, password } = req.body;
  
    if (username === 'nishant' && password === '123' || username === 'saiteja' && password === '123') {
      // Set the session data
      req.session.userId = 1;
      res.redirect('/deliverypartners');
    } else {
      res.render('login', { message: 'Invalid username or password' });
    }
  });
app.get('/deliverypartners',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM deliverypartners ORDER BY dpid');
    res.render('deliverypartners',{deliverypartners:rows});
});

app.post('/deliverypartners',requireLogin, async (req, res) => {
    const numberResult = await pool.query('SELECT COUNT(*) FROM deliverypartners');
    const number = parseInt(numberResult.rows[0].count) + 1;
    const { type, username, password, firstname, lastname, age, email, mobile, ssn, sex, aid } = req.body;
    const values = [number, type, username, password, firstname, lastname, age, email, mobile, ssn, sex, aid];
    await pool.query('INSERT INTO deliverypartners (dpid, type, username, password, firstname, lastname, age, email, mobile, ssn, sex, aid) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)', values);
    res.redirect('/deliverypartners');
});

app.delete('/deliverypartners/:dpid',requireLogin, async (req, res) => {
    const dpid = req.params.dpid;
  
    try {
      await pool.query('DELETE FROM deliverypartners WHERE dpid = $1', [dpid]);
      res.status(200).json({ message: 'Delivery partner deleted successfully.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting delivery partner.' });
    }
  });
  
app.get('/orderdetails',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM orderdetails');
    res.render('orderdetails',{orderdetails:rows});
});

app.post('/orderdetails',requireLogin, async (req, res) => {
    const { orderid, itemid, preparationtime, deliverytime } = req.body;
    const idResult = await pool.query('SELECT COUNT(*) FROM orderdetails');
    const id = idResult.rows[0].count + 1;
    const values = [id, orderid, itemid, preparationtime, deliverytime, preparationtime + deliverytime];
    await pool.query('INSERT INTO orderdetails (orderdetailid, orderid, itemid, preparationtime, deliverytime, totaltime) VALUES ($1, $2, $3, $4, $5, $6)', values);
    res.redirect('/orderdetails');
});
  
app.delete('/orderdetails/:orderdetailid',requireLogin, async (req, res) => {
    const orderdetailid = req.params.orderdetailid;
  
    try {
      await pool.query('DELETE FROM orderdetails WHERE orderdetailid = $1', [orderdetailid]);
      res.status(200).json({ message: 'Order detail deleted successfully.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting order detail.' });
    }
  });
  
app.get('/menuitems',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM menuitems');
    res.render('menuitems',{menuitems:rows});
});

app.post('/menuitems',requireLogin, async (req, res) => {
    const { itemname, price, type } = req.body;
  
    // Get the current count of rows in the menuitems table
    const result = await pool.query('SELECT COUNT(*) FROM menuitems');
    const count = parseInt(result.rows[0].count);
  
    // Insert the new menu item with the next available id
    const id = count + 1;
    const values = [id, itemname, price, type];
    await pool.query('INSERT INTO menuitems (itemid, itemname, price, type) VALUES ($1, $2, $3, $4)', values);
  
    res.redirect('/menuitems');
});
  
app.delete('/menuitems/:itemid', requireLogin,async (req, res) => {
    const itemid = req.params.itemid;
  
    try {
      await pool.query('DELETE FROM menuitems WHERE itemid = $1', [itemid]);
      res.status(200).json({ message: 'Menu item deleted successfully.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting menu item.' });
    }
  });
  
app.get('/orders',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM orders');
    res.render('orders',{orders:rows});
});

app.post('/orders',requireLogin, async (req, res) => {
    const { ordernumber, restaurantid, userid, dpid } = req.body;
    const idResult = await pool.query('SELECT COUNT(*) FROM orders');
    const id = idResult.rows[0].count + 1;
    const values = [id, ordernumber, restaurantid, userid, dpid];
    await pool.query('INSERT INTO orders (orderid, ordernumber, restaurantid, userid, dpid) VALUES ($1, $2, $3, $4, $5)', values);
    res.redirect('/orders');
});
app.delete('/orders/:orderid',requireLogin, async (req, res) => {
    const orderid = req.params.orderid;
  
    try {
      await pool.query('DELETE FROM orders WHERE orderid = $1', [orderid]);
      res.status(200).json({ message: 'Order deleted successfully.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting order.' });
    }
  });
  

app.get('/owners',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM owners ORDER BY ownerid');
    res.render('owners',{owners:rows});
});

app.post('/owners',requireLogin, async (req, res) => {
    const { firstname, lastname, gender, mobile, email, aid} = req.body;
    const idResult = await pool.query('SELECT COUNT(*) FROM owners');
    const id = idResult.rows[0].count + 1;
    const values = [id, firstname, lastname, gender, mobile, email, aid];
    await pool.query('INSERT INTO owners (ownerid, firstname, lastname, gender, mobile, email, aid) VALUES ($1, $2, $3, $4, $5, $6, $7)', values);
    res.redirect('/owners');
  });
  app.delete('/owners/:ownerId',requireLogin, async (req, res) => {
    const ownerId = req.params.ownerId;
  
    try {
      await pool.query('DELETE FROM owners WHERE ownerid = $1', [ownerId]);
      res.status(200).json({ message: 'Owner deleted successfully.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting owner.' });
    }
  });
  
app.get('/restaurant_items',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM restaurant_items');
    res.render('restaurant_items',{restaurant_items:rows});
});

app.post('/restaurant_items',requireLogin, async (req, res) => {
    const { restaurantid, itemid } = req.body;
    const values = [restaurantid, itemid];
    await pool.query('INSERT INTO restaurant_items (restaurantid, itemid) VALUES ($1, $2)', values);
    res.redirect('/restaurant_items');
  });
  app.delete('/restaurant_items/:restaurantid/:itemid',requireLogin, async (req, res) => {
    const restaurantid = req.params.restaurantid;
    const itemid = req.params.itemid;
  
    try {
      await pool.query('DELETE FROM restaurant_items WHERE restaurantid = $1 AND itemid = $2', [restaurantid, itemid]);
      res.status(200).json({ message: 'Restaurant item deleted successfully.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting restaurant item.' });
    }
  });
app.get('/restaurants',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM restaurants ORDER BY restaurantid');
    res.render('restaurants',{restaurants:rows});
});

app.post('/restaurants',requireLogin, async (req, res) => {
    const { ownerid, restaurantname, phone, aid } = req.body;
    const idResult = await pool.query('SELECT COUNT(*) FROM restaurants');
    const id = idResult.rows[0].count + 1;
    const values = [id, ownerid, restaurantname, phone, aid];
    await pool.query('INSERT INTO restaurants (restaurantid, ownerid, restaurantname, phone, aid) VALUES ($1, $2, $3, $4, $5)', values);
    res.redirect('/restaurants');
  });

  app.delete('/restaurants/:restaurantId',requireLogin, async (req, res) => {
    const restaurantId = req.params.restaurantId;
  
    try {
      await pool.query('DELETE FROM restaurants WHERE restaurantid = $1', [restaurantId]);
      res.status(200).json({ message: 'Restaurant deleted successfully.' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting restaurant.' });
    }
  });
app.get('/users',requireLogin, async (req, res) => {
    const { rows } = await pool.query('SELECT * FROM users ORDER BY userid');
    res.render('users',{users:rows});
});
app.post('/users', requireLogin,async (req, res) => {
    const { firstname, lastname, age, sex, email, mobile, aid } = req.body;
    
    const idResult = await pool.query('SELECT COUNT(*) FROM users');
    const id = parseInt(idResult.rows[0].count) + 1;
    
    const values = [id, firstname, lastname, age, sex, email, mobile, aid];
    await pool.query('INSERT INTO users (userid, firstname, lastname, age, sex, email, mobile, aid) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)', values);
    
    res.redirect('/users');
  });
app.delete('/users/:userId',requireLogin, async (req, res) => {
const userId = req.params.userId;

try {
    await pool.query('DELETE FROM users WHERE userid = $1', [userId]);
    res.status(200).json({ message: 'User deleted successfully.' });
} catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Error deleting user.' });
}
});

// Get all addresses
app.get('/addresses', requireLogin, async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM addresses ORDER BY aid');
  res.render('addresses', { addresses: rows });
});

// Add a new address
app.post('/addresses', requireLogin, async (req, res) => {
  const { address, city, state, zip } = req.body;

  const aidResult = await pool.query('SELECT COUNT(*) FROM addresses');
  const aid = parseInt(aidResult.rows[0].count) + 1;

  const values = [aid, address, city, state, zip];
  await pool.query('INSERT INTO addresses (aid, address, city, state, zip) VALUES ($1, $2, $3, $4, $5)', values);

  res.redirect('/addresses');
});

// Delete an address
app.delete('/addresses/:addressId', requireLogin, async (req, res) => {
  const addressId = req.params.addressId;

  try {
      await pool.query('DELETE FROM addresses WHERE aid = $1', [addressId]);
      res.status(200).json({ message: 'Address deleted successfully.' });
  } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error deleting address.' });
  }
});


app.get('/query',requireLogin, async (req, res) => {
    res.render('query');
});

app.post('/query', requireLogin,async (req, res) => {
    try {
      // Extract the SQL query from the request body
      const { query } = req.body;
      // Execute the query using the PostgreSQL client
      const { rows } = await pool.query(query);
      console.log(rows);
      res.json({ success: true, rows });
    } catch (error) {
      console.error(error);
     res.json({ success: false, message: error.message });
    }
  });
  app.get('/logout', (req, res) => {
    req.session.destroy(err => {
      if (err) {
        return res.redirect('/'); // In case of error, redirect to the homepage
      }
  
      res.clearCookie('connect.sid'); // Clear the cookie
      res.redirect('/'); // Redirect to the login page
    });
  });
  
// Start the server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
