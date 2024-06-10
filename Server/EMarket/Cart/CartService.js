const client = require('../db');
const UserService = require('../Auth/UserService');
const userService = new UserService();

class CartService {
    constructor() {
        this.userId = 0;
        this.cart = [];
        this.loadCart = this.loadCart.bind(this);
    }

    async loadCart() {
        const query = 'SELECT * FROM shoppingcartitems WHERE userid = $1';
        const result = await client.query(query, [this.userId]);
        this.cart = result.rows;
        this.userId = await userService.getUserIdByUsername(result);
    }

    async addProduct(productId, quantity, username) {


        try {
            const existingProductIndex = this.cart.findIndex(p => p.product.id === productId);
            if (existingProductIndex >= 0) {
                // If the product already exists in the cart, update the quantity
                this.cart[existingProductIndex].quantity += quantity;
                const query = 'UPDATE shoppingcartitems SET quantity = $1 WHERE productid = $2';
                await client.query(query, [this.cart[existingProductIndex].quantity, productId]);
            } else {
                // If the product doesn't exist in the cart, add it
                const query = 'INSERT INTO shoppingcartitems (productid, quantity, userid) VALUES ($1, $2, $3)';
                await client.query(query, [productId, quantity, this.userId]);
                this.cart.push({product: productId, quantity});
            }
        } catch (error) {
            console.error(`Error adding product to cart: ${error}`);
            throw error; // or handle the error as you see fit
        }
    }

    // Remove a product from the cart
    removeProduct(productId) {
        this.cart = this.cart.filter(p => p.product.id !== productId);
    }

    // Modify the quantity of a product in the cart
    modifyProductQuantity(productId, quantity) {
        const existingProductIndex = this.cart.findIndex(p => p.product.id === productId);
        if (existingProductIndex >= 0) {
            // If the product exists in the cart, update the quantity
            this.cart[existingProductIndex].quantity = quantity;
        }
    }

    async getCartItems() {
        const cartItemsWithProductDetails = [];

        // First, get the cart items for the user from the database
        const cartQuery = 'SELECT * FROM shoppingcartitems WHERE userid = $1';
        const cartResult = await client.query(cartQuery, [this.userId]);
        const cartItems = cartResult.rows;

        // Then, for each cart item, get the full product details
        for (const item of cartItems) {
            const productQuery = 'SELECT * FROM products WHERE productid = $1';
            const productResult = await client.query(productQuery, [item.productid]);
            if (productResult.rows.length > 0) {
                const productDetails = productResult.rows[0];
                cartItemsWithProductDetails.push({
                    product: productDetails,
                    quantity: item.quantity
                });
            }
        }

        return cartItemsWithProductDetails;
    }
}

module.exports = CartService;