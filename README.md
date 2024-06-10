# EMarket
EMarket is a group project for study purposes. The project focuses on using Docker to build an online application based on PostgreSQL, Node.js, and React.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need to have Docker and Docker Compose installed on your machine. If you haven't installed them yet, you can download Docker [here](https://www.docker.com/products/docker-desktop) and follow the instructions.

### Installation

1. Clone the repository
```bash
git clone https://github.com/NonNoname1201/EMarket.git
```

2. Navigate to the project directory
```bash
cd EMarket
```

3. Build and run the Docker containers using Docker Compose
```bash
docker-compose up -d
```
or
```bash
docker-compose up --build -d
```

The application should now be running on your local machine. The Node.js server is accessible at `http://localhost:4001` and the PostgreSQL database at `localhost:4000`.

To stop the application, use the following command:
```bash
docker-compose down
```
or 
```bash
docker-compose down --rmi all --volumes
```


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details