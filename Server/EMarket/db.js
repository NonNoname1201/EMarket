const {Client} = require('pg');

const client = new Client({
    host: 'db',
    port: 5432,
    database: 'emarket',
    user: 'api',
    password: '>2sPbT5A41N<9-5v',
});

client.connect();

module.exports = client;