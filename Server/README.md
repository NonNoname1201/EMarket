# EMarket Server Side

This is the server side of the EMarket project. It is a RESTful API that serves the client side of the project. The server is built using Node.js and Express.js. The database is PostgreSQL.

## Workflow:
### 1. Build your image.

```bash
docker build -t emarket_server -f Dockerfile.express .
```

### 2. Run your container

```bash
docker run -d -p 4001:3000 --name emarket_server emarket_server
```

## API is ready to go!

### 3. Test your API

```bash
curl http://localhost:4001/api/products
```

### 4. Stop your container if you are done

```bash
docker stop emarket_server
```

### Happy coding! 🎉

# Notes:
- The server is running on port 4001.
- The server is running on the localhost.
- The server is running in development mode.
- The server is not secure. Future versions will include security features.
- Full documentation is available in the [google docs](https://docs.google.com/document/d/1Gu7faRNwiOf1NaBavhG5rYm5TiCsT2sJ9YG6qZXN8gQ).