// AuthService.js
const jwt = require('jsonwebtoken');
const UserService = require('./UserService');
const {decode} = require("jsonwebtoken");

class AuthService {
    constructor() {
        this.loggedOutTokens = [];
        this.authenticateToken = this.authenticateToken.bind(this);
    }

    generateToken(user) {
        const payload = {username: user.username};
        const secret = 'ABBA';
        const options = {expiresIn: '1h'};
        return jwt.sign(payload, secret, options);
    }

    logout(token) {
        this.loggedOutTokens.push(token);
    }

    async authenticateToken(req, res, next) {
        const authHeader = req.headers['authorization'];
        const token = authHeader && authHeader.split(' ')[1];

        if (token == null || this.loggedOutTokens.includes(token)) {
            return res.sendStatus(401);
        }
        jwt.verify(token, 'ABBA', async (err, user) => {

            if (err){
                return res.sendStatus(401);
            }

            const userService = new UserService();
            try {
                req.user = await userService.getUserByUsername(user.username);
                if (!req.user) {
                    return res.sendStatus(401);
                }
                next();
            } catch (error) {
                console.log('\nSomething broke. And i hate it.\n', error);
                return res.sendStatus(500);
            }
        });
    }

    isAdmin(req, res, next) {
        if (req.user.isAdmin) {
            next();
        } else {
            res.status(403).json({message: 'User is not an admin'});
        }
    }


}

module.exports = AuthService;