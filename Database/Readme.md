# This is a PostgreSQL database image for the eMarket application. 
### The image is based on the official PostgreSQL image.
### The image is initialized with the eMarket database and the api user.


# Workflow:
## 1. Build your image.

```bash
docker build -t emarket_db -f Dockerfile.psql .
```

## 2. Run your container

```bash
docker run -d -p 4000:5432 --name emarket_db emarket_db
```

## 3. Connect to your database as the postgres user or the eMarketApi user
```bash
docker exec -it emarket_db psql -U postgres -d emarket
```
or 
```bash
docker exec -it -e PGPASSWORD=>2sPbT5A41N<9-5v emarket_db psql -U api -d emarket
```

## 4. Get data from your database

```sql
SELECT * FROM Products;
```

## 5. Stop your container if you are done

```bash
docker stop emarket_db
```
### Happy coding! 🎉
# Notes:
- The password for the api user is `>2sPbT5A41N<9-5v`.
- postgres user is the default superuser for the PostgreSQL database.
- postgres user has no password and will not work if accessed within Jetbrains IDEs, use the api user instead.
- postgres user is used for debugging and testing purposes only. If your system uses this user, change to api as postgres user will be removed in the future.