// UserService.js
const bcrypt = require('bcryptjs');
const client = require('../db');
const User = require('./User');

class UserService {
    async createUser(username, password, firstname, lastname, email, phone, address, isAdmin = false) {
        const hashedPassword = await bcrypt.hash(password, 10);
        let user;

        try {
            user = new User(username, hashedPassword, firstname, lastname, email, phone, address, isAdmin);
        } catch (error) {
            return {error: `Invalid user data: ${error}`};
        }

        try {
            const query = 'INSERT INTO Users(username, password, firstname, lastname, email, phone, address, isadmin) VALUES($1, $2, $3, $4, $5, $6, $7, $8)';
            await client.query(query, [username, hashedPassword, firstname, lastname, email, phone, address, isAdmin]);
        } catch (error) {
            return {error: `Error creating user: ${error}`};
        }

        return {user};
    }

    async getUserByUsername(username) {
        const query = 'SELECT * FROM Users WHERE username = $1';
        const result = await client.query(query, [username]);

        if (result.rows.length > 0) {
            const user = new User(result.rows[0].username, result.rows[0].password, result.rows[0].firstname, result.rows[0].lastname, result.rows[0].email, result.rows[0].phone, result.rows[0].address);
            user.isAdmin = result.rows[0].isadmin;
            return user;
        }

        return null;
    }

    async getUserIdByUsername(username) {
        const query = 'SELECT * FROM Users WHERE username = $1';
        const result = await client.query(query, [username]);

        if (result.rows.length > 0) {
            return result.rows[0].id;
        }

        return null;
    }

    async updateUser(username, firstname, lastname, email, phone, address) {
        try {
            const query = 'UPDATE Users SET firstname = $1, lastname = $2, email = $3, phone = $4, address = $5 WHERE username = $6';
            await client.query(query, [firstname, lastname, email, phone, address, username]);
        } catch (error) {
            return {error: `Error updating user: ${error}`};
        }
        return await this.getUserByUsername(username);
    }

    async validatePassword(inputPassword, hashedPassword) {
        return await bcrypt.compare(inputPassword, hashedPassword);
    }
}

module.exports = UserService;