// app.js
const express = require('express');
const router = require('./routes');
const app = express();

app.use(express.json());
app.use('/', router);

app.use((req, res, next) => {
    console.log(`${req.method} ${req.path}`);
    next();
});

app.use((err, req, res, next) => {
    if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
        console.error(err);
        return res.status(400).send({ message: 'Invalid JSON payload received.' }); // Bad request
    }
    next();
});

app.use((req, res, next) => {
    res.status(404).send('Page Not Found');
    console.log('Page Not Found');
});

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something Broke!');
});



app.listen(3000, () => {
    console.log('Server is running on port 3000');
});