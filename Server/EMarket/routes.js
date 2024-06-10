// routes.js
const express = require('express');
const UserService = require('./Auth/UserService');
const AuthService = require('./Auth/AuthService');
const CartService = require('./Cart/CartService');
const User = require('./Auth/User');
const database = require('./db');
const router = express.Router();
const authService = new AuthService();
const userService = new UserService();
const cartService = new CartService();

router.get('/api/data', async (req, res) => {
    try {
        const result = await database.query('SELECT * FROM users').rows;
        res.send(result);
    } catch (err) {
        console.error(err);
        res.status(500).send('An error occurred while fetching data from the database.');
    }
});

router.post('/signup', async (req, res, next) => {
    try {
        const {username, password, firstname, lastname, email, phone, address} = req.body;
        if(username === "" || password == "" || firstname === "" || lastname === "" || email === "" || phone == "" || address === ""){
            res.status(400).json({message: 'Missing required fields'});
            return;
        }
        const result = await userService.createUser(username, password, firstname, lastname, email, phone, address, false);
        if (result.error) {
            res.status(400).json({message: result.error});
        } else {
            res.json({message: 'User created successfully'});
        }
    } catch (error) {
        next(error);
    }
    /*
        "username": "exampleUser",
        "password": "examplePassword",
        "firstname": "Example",
        "lastname": "User",
        "email": "exampleUser@example.com",
        "phone": "1234567890",
        "address": "123 Example Street"
    */
});

router.post('/signupadmin', async (req, res, next) => {
    try {
        const {username, password, firstname, lastname, email, phone, address} = req.body;
        const result = await userService.createUser(username, password, firstname, lastname, email, phone, address, true);

        if (result.error) {
            res.status(500).json({message: result.error});
        } else {
            res.json({message: 'Admin created successfully'});
        }
    } catch (error) {
        next(error);
    }
});

router.post('/login', async (req, res) => {
    const {username, password} = req.body;
    const user = await userService.getUserByUsername(username);
    if (!user) {
        res.status(401).json({message: 'Invalid credentials'});
        return;
    }

    const isValid = await userService.validatePassword(password, user.password);
    if (isValid) {
        const token = authService.generateToken(user);
        res.json({token, isAdmin: user.isAdmin});
    } else {
        res.status(401).json({message: 'Invalid credentials'});
    }

    await cartService.loadCart();
});

router.post('/logout', authService.authenticateToken, (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    authService.logout(token);
    res.json({message: 'Logged out successfully'});
});

router.get('/profile', authService.authenticateToken, async (req, res) => {
    const user = req.user;
    const filteredData = {
        firstname: user.firstname,
        lastname: user.lastname,
        username: user.username,
        email: user.email,
        phone: user.phone,
        address: user.address
    }
    res.json(filteredData);
    //{
    // "customerid":1, --
    // "firstname":"Jan",
    // "lastname":"Kowalski",
    // "username":"jkowalski",
    // "email":"123@123.com",
    // "phone":"123123",
    // "password":"password", --
    // "addressid":1
    // }
});

router.put('/profile', authService.authenticateToken, async (req, res) => {
    const user = req.user;
    const {firstname, lastname, email, phone, address} = req.body;

    if (firstname === undefined || firstname === "" || lastname === undefined || lastname === "" || email === undefined || email === "" || phone === undefined || phone === "" || address === undefined || address === "") {
        res.status(400).json({message: 'No data provided'});
        return;
    }

    var regEx = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    if (email !== undefined && email !== "" && !regEx.test(email)) {
        res.status(400).json({message: 'Invalid email format'});
        return;
    }

    regEx = /^[0-9]{9}$/;
    if (phone !== undefined && phone !== "" && !regEx.test(phone)) {
        res.status(400).json({message: 'Invalid phone number format'});
        return;
    }

    var changes = new User(
        user.username,
        user.password,
        firstname ? firstname : user.firstname,
        lastname ? lastname : user.lastname,
        email ? email : user.email,
        phone ? phone : user.phone,
        address ? address : user.address
    );

    try {
        const result = await userService.updateUser(changes.firstname, changes.lastname, changes.email, changes.phone, changes.address);

        if (result.error) {
            res.status(500).json({message: result.error});
        } else {
            req.session.user = result;
            res.json({message: 'Profile updated successfully'});

        }
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error updating profile'});
    }
});

router.get('/products', async (req, res) => {
    const page = Math.max(1, parseInt(req.query.page)) || 1; // Default to page 1 if not provided
    const limit = Math.max(1, parseInt(req.query.limit)) || 10; // Default to 10 items per page if not provided
    const offset = (page - 1) * limit;

    const query = `
        SELECT products.productid,
               products.productname,
               products.description,
               products.price,
               brands.brandname,
               products.quantityinstock,
               productimages.imageurl
        FROM products
                 INNER JOIN brands ON products.brand = brands.brandid
                 INNER JOIN productimages ON products.productid = productimages.productid
        ORDER BY products.productid
        LIMIT $1 OFFSET $2
    `;
    const values = [limit, offset];

    database.query(query, values, (error, results) => {
        if (error) {
            throw error;
        }
        res.status(200).json(results.rows);
    });
});

router.get('/products/seller/:sellerName', async (req, res) => {
    const page = Math.max(1, parseInt(req.query.page)) || 1; // Default to page 1 if not provided
    const limit = Math.max(1, parseInt(req.query.limit)) || 10; // Default to 10 items per page if not provided
    const offset = (page - 1) * limit;
    const sellerName = req.params.sellerName;

    const query = `
        SELECT products.productid,
               products.productname,
               products.description,
               products.price,
               brands.brandname,
               products.quantityinstock,
               productimages.imageurl
        FROM products
                 INNER JOIN brands ON products.brand = brands.brandid
                 INNER JOIN productimages ON products.productid = productimages.productid
        WHERE brands.brandname = $1
        ORDER BY products.productid
        LIMIT $2 OFFSET $3
    `;
    const values = [sellerName, limit, offset];

    database.query(query, values, (error, results) => {
        if (error) {
            throw error;
        }
        res.status(200).json(results.rows);
    });
});

router.get('/products/productbyid/:productId', async (req, res) => {
    const productId = req.params.productId;
    console.log(`Fetching product with ID: ${productId}`);

    const query = `
        SELECT products.productid,
               products.productname,
               products.description,
               products.price,
               brands.brandname,
               products.quantityinstock,
               productimages.imageurl
        FROM products
                 INNER JOIN brands ON products.brand = brands.brandid
                 INNER JOIN productimages ON products.productid = productimages.productid
        WHERE products.productid = $1
    `;
    const values = [productId];

    database.query(query, values, (error, results) => {
        if (error) {
            console.error('Error executing query:', error);
            res.status(500).json({message: 'Error retrieving product details'});
            return;
        }
        if (results.rows.length > 0) {
            res.status(200).json(results.rows[0]);
        } else {
            console.log(`Product with ID ${productId} not found`);
            res.status(404).json({message: 'Product not found'});
        }
    });
});

router.post('/products/add', authService.authenticateToken, authService.isAdmin, async (req, res) => {
    const {productname, description, price, brandname, quantityinstock, imageurl} = req.body;
    if (!productname || !description || !price || !brandname || !quantityinstock || !imageurl) {
        res.status(400).json({message: 'Missing required fields'});
        return;
    }

    const brandQuery = `
        SELECT brandid
        FROM brands
        WHERE brandname = $1
    `;
    const brandValues = [brandname];

    database.query(brandQuery, brandValues, async (error, results) => {
        if (error) {
            console.error(error);
            res.status(500).json({message: 'Error querying brand'});
            return;
        }

        let brandId;
        if (results.rows.length > 0) {
            brandId = results.rows[0].brandid;
        } else {
            const insertBrandQuery = `
                INSERT INTO brands (brandname)
                VALUES ($1)
                RETURNING brandid
            `;
            const brandResult = await database.query(insertBrandQuery, brandValues);
            brandId = brandResult.rows[0].brandid;
        }

        const productQuery = `
            INSERT INTO products (productname, description, price, brand, quantityinstock)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING productid
        `;
        const productValues = [productname, description, price, brandId, quantityinstock];

        const productResult = await database.query(productQuery, productValues);
        const productId = productResult.rows[0].productid;

        const checkImageQuery = `
            SELECT productid
            FROM productimages
            WHERE imageurl = $1
        `;
        const checkImageValues = [imageurl];

        const imageResult = await database.query(checkImageQuery, checkImageValues);

        if (imageResult.rows.length === 0) {
            const imageQuery = `
                INSERT INTO productimages (productid, imageurl)
                VALUES ($1, $2)
            `;
            const imageValues = [productId, imageurl];

            await database.query(imageQuery, imageValues);
        }

        res.status(200).json({message: 'Product added successfully'});
    });
});

router.get('/cart', authService.authenticateToken, async (req, res) => {
    try {
        const userId = req.user.id;
        const cartItems = await cartService.getCartItems(userId);
        res.json(cartItems);
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving cart items'});
    }
});

router.post('/cart', authService.authenticateToken, async (req, res) => {
    try {
        const id = req.body.id;
        const quantity = req.body.quantity;
        await cartService.addProduct(id, quantity, req.user.username);
        res.status(201).json({message: 'Product added to cart'});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error adding product to cart'});
    }
});

router.put('/cart/:itemId', authService.authenticateToken, async (req, res) => {
    try {
        const userId = req.user.id;
        const itemId = req.params.id;
        const {quantity} = req.body;
        await cartService.modifyProductQuantity(itemId, quantity, userId);
        res.json({message: 'Cart item updated'});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error updating cart item'});
    }
});

router.delete('/cart/:itemId', authService.authenticateToken, async (req, res) => {
    try {
        const userId = req.user.id;
        const itemId = req.params.itemId;
        await cartService.removeProduct(itemId, userId);
        res.json({message: 'Cart item removed'});
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error removing cart item'});
    }
});


router.get('/orders', authService.authenticateToken, async (req, res) => {
    const query = 'SELECT * FROM orders WHERE userid = $1';
    const values = [await userService.getUserIdByUsername(req.user.username)];
    try {
        const result = await database.query(query, values);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving orders'});
    }
});

router.get('/orders/:orderId', authService.authenticateToken, async (req, res) => {
    const query = 'SELECT * FROM orders WHERE userid = $1 AND orderid = $2';
    const values = [await userService.getUserIdByUsername(req.user.username), res.params.orderId];
    try {
        const result = await database.query(query, values);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error retrieving orders'});
    }
});

router.post('/orders', authService.authenticateToken, async (req, res) => {
    const {items, paymentMethod} = req.body;
    const userId = await userService.getUserIdByUsername(req.user.username);
    const paymentIdQuery = 'SELECT paymentmethodid FROM paymentmethods WHERE paymentmethodname = $1';
    const paymentIdValues = [paymentMethod];

    try {
        const paymentIdResult = await database.query(paymentIdQuery, paymentIdValues);
        const paymentMethodId = paymentIdResult.rows[0].paymentmethodid;
        const orderQuery = 'INSERT INTO orders (userid, paymentmethodid) VALUES ($1, $2) RETURNING *';
        const orderValues = [userId, paymentMethodId];
        const orderResult = await database.query(orderQuery, orderValues);
        const orderId = orderResult.rows[0].orderid;

        for (const item of items) {
            const orderDetailsQuery = 'INSERT INTO orderdetails (orderid, productid, quantity) VALUES ($1, $2, $3)';
            const orderDetailsValues = [orderId, item.productid, item.quantity];
            await database.query(orderDetailsQuery, orderDetailsValues);
        }

        res.status(201).json(orderResult.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({message: 'Error creating order'});
    }
});

router.put('/orders/:orderId', authService.authenticateToken, async (req, res) => {
    const {items} = req.body;
    const {orderId} = req.params;
    const userId = await userService.getUserIdByUsername(req.user.username);

    try {
        await database.query('BEGIN');

        const deleteOrderDetailsQuery = 'DELETE FROM orderdetails WHERE orderid = $1';
        await database.query(deleteOrderDetailsQuery, [orderId]);

        for (const item of items) {

            if (!Number.isInteger(item.productid) || !Number.isInteger(item.quantity)) {
                throw new Error('Invalid productid or quantity');
            }

            const orderDetailsQuery = 'INSERT INTO orderdetails (orderid, productid, quantity) VALUES ($1, $2, $3)';
            const orderDetailsValues = [orderId, item.productid, item.quantity];
            await database.query(orderDetailsQuery, orderDetailsValues);
        }

        await database.query('COMMIT');

        const fetchOrderQuery = 'SELECT * FROM orders WHERE orderid = $1 AND userid = $2';
        const fetchOrderValues = [orderId, userId];
        const fetchOrderResult = await database.query(fetchOrderQuery, fetchOrderValues);

        if (fetchOrderResult.rows.length > 0) {
            res.json(fetchOrderResult.rows[0]);
        } else {
            res.status(404).json({message: 'Order not found'});
        }
    } catch (error) {
        await database.query('ROLLBACK');
        console.error(error);
        res.status(500).json({message: 'Error updating order'});
    }
});

router.delete('/orders/:orderId', authService.authenticateToken, async (req, res) => {
    const {orderId} = req.params;
    const userId = await userService.getUserIdByUsername(req.user.username);

    try {
        await database.query('BEGIN');

        const deleteOrderDetailsQuery = 'DELETE FROM orderdetails WHERE orderid = $1';
        await database.query(deleteOrderDetailsQuery, [orderId]);

        const deleteOrderQuery = 'DELETE FROM orders WHERE orderid = $1 AND userid = $2 RETURNING *';
        const deleteOrderValues = [orderId, userId];
        const deleteOrderResult = await database.query(deleteOrderQuery, deleteOrderValues);

        await database.query('COMMIT');

        if (deleteOrderResult.rows.length > 0) {
            res.json({message: 'Order deleted'});
        } else {
            res.status(404).json({message: 'Order not found'});
        }
    } catch (error) {
        await database.query('ROLLBACK');
        console.error(error);
        res.status(500).json({message: 'Error deleting order'});
    }
});

module.exports = router;