// User.js
class User {
    constructor(username, password, firstname, lastname, email, phone, address) {
        this.username = username;
        this.password = password;
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.phone = phone;
        this.address = address; //string
        this.isAdmin = false;
    }
}

module.exports = User;