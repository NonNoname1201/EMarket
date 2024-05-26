\c postgres;

DROP DATABASE IF EXISTS emarket;
DROP USER IF EXISTS api;

CREATE DATABASE emarket;
\! sleep 1;
\c emarket;

CREATE USER api WITH PASSWORD '>2sPbT5A41N<9-5v';
GRANT ALL PRIVILEGES ON DATABASE emarket TO api;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO api;

CREATE TABLE Countries
(
    CountryID   SERIAL PRIMARY KEY,
    CountryName VARCHAR(100)
);
INSERT INTO Countries (CountryName) VALUES ('Poland');
INSERT INTO Countries (CountryName) VALUES ('Germany');
INSERT INTO Countries (CountryName) VALUES ('France');

CREATE TABLE Cities
(
    CityID    SERIAL PRIMARY KEY,
    CityName  VARCHAR(100),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES
        Countries (CountryID)
);
INSERT INTO Cities (CityName, CountryID) VALUES ('Warsaw', 1);
INSERT INTO Cities (CityName, CountryID) VALUES ('Krakow', 1);
INSERT INTO Cities (CityName, CountryID) VALUES ('Lublin', 1);
INSERT INTO Cities (CityName, CountryID) VALUES ('Berlin', 2);
INSERT INTO Cities (CityName, CountryID) VALUES ('Paris', 3);

CREATE TABLE Addresses
(
    AddressID SERIAL PRIMARY KEY,
    Address   VARCHAR(255),
    CityID    INT,
    FOREIGN KEY (CityID) REFERENCES Cities (CityID)
);
INSERT INTO Addresses (Address, CityID) VALUES ('ul. Marszalkowska 1', 1);
INSERT INTO Addresses (Address, CityID) VALUES ('ul. Wawelska 1', 2);
INSERT INTO Addresses (Address, CityID) VALUES ('ul. Krakowska 1', 2);
INSERT INTO Addresses (Address, CityID) VALUES ('ul. Lubelska 1', 3);
INSERT INTO Addresses (Address, CityID) VALUES ('ul. Nadbystrzycka', 3);
INSERT INTO Addresses (Address, CityID) VALUES ('Unter den Linden 1', 4);
INSERT INTO Addresses (Address, CityID) VALUES ('Avenue des Champs-Élysées 1', 5);

CREATE TABLE Customers
(
    CustomerID SERIAL PRIMARY KEY,
    FirstName  VARCHAR(100),
    LastName   VARCHAR(100),
    UserName   VARCHAR(100),
    Email      VARCHAR(100),
    Phone      VARCHAR(100),
    Password   VARCHAR(100),
    AddressID  INT,
    FOREIGN KEY (AddressID) REFERENCES Addresses (AddressID)
);
INSERT INTO Customers (FirstName, LastName, UserName, Email, Phone, Password, AddressID) VALUES ('Jan', 'Kowalski', 'jkowalski', '123@123.com', '123123', 'password', 1);
INSERT INTO Customers (FirstName, LastName, UserName, Email, Phone, Password, AddressID) VALUES ('Anna', 'Nowak', 'anowak', '234@234.com', '234234', 'password', 2);
INSERT INTO Customers (FirstName, LastName, UserName, Email, Phone, Password, AddressID) VALUES ('Piotr', 'Kowalczyk', 'pkowalczyk', '345@435.com', '345345', 'password', 3);

CREATE TABLE Admins
(
    AdminID   SERIAL PRIMARY KEY,
    UserName  VARCHAR(100),
    Password  VARCHAR(100),
    FirstName VARCHAR(100),
    LastName  VARCHAR(100),
    Email     VARCHAR(100),
    Phone     VARCHAR(100),
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES Addresses (AddressID),
    HourlyWage NUMERIC(10, 2)
);
INSERT INTO Admins (UserName, Password, FirstName, LastName, Email, Phone, AddressID, HourlyWage) VALUES ('admin', 'admin', 'Admin', 'Admin', 'admin@admin.com', '123123', 1, 10.00);

CREATE TABLE Brands
(
    BrandID   SERIAL PRIMARY KEY,
    BrandName VARCHAR(100)
);
INSERT INTO Brands (BrandName) VALUES ('Apple');
INSERT INTO Brands (BrandName) VALUES ('Samsung');
INSERT INTO Brands (BrandName) VALUES ('Huawei');

CREATE TABLE Categories
(
    CategoryID   SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100)
);
INSERT INTO Categories (CategoryName) VALUES ('Smartphones');
INSERT INTO Categories (CategoryName) VALUES ('Laptops');
INSERT INTO Categories (CategoryName) VALUES ('Tablets');
INSERT INTO Categories (CategoryName) VALUES ('Smartwatches');

CREATE TABLE Products
(
    ProductID       SERIAL PRIMARY KEY,
    ProductName     VARCHAR(100),
    Description     VARCHAR(255),
    Price           NUMERIC(10, 2),
    Brand           INT,
    FOREIGN KEY (Brand) REFERENCES Brands (BrandID),
    QuantityInStock INT
);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('iPhone 12', 'The latest iPhone', 999.99, 1, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('Galaxy S21', 'The latest Samsung phone', 899.99, 2, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('Mate 40 Pro', 'The latest Huawei phone', 799.99, 3, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('MacBook Pro', 'The latest MacBook', 1999.99, 1, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('Galaxy Book', 'The latest Samsung laptop', 1499.99, 2, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('MateBook', 'The latest Huawei laptop', 1299.99, 3, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('iPad Pro', 'The latest iPad', 799.99, 1, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('Galaxy Tab', 'The latest Samsung tablet', 499.99, 2, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('MatePad', 'The latest Huawei tablet', 399.99, 3, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('Apple Watch', 'The latest Apple watch', 299.99, 1, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('Galaxy Watch', 'The latest Samsung watch', 199.99, 2, 100);
INSERT INTO Products (ProductName, Description, Price, Brand, QuantityInStock) VALUES ('Huawei Watch', 'The latest Huawei watch', 99.99, 3, 100);

CREATE TABLE ProductsCategories
(
    ProductCategoryID SERIAL PRIMARY KEY,
    ProductID         INT,
    CategoryID        INT,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID),
    UNIQUE (ProductID, CategoryID)
);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (1, 1);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (2, 1);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (3, 1);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (4, 2);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (5, 2);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (6, 2);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (7, 3);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (8, 3);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (9, 3);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (10, 4);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (11, 4);
INSERT INTO ProductsCategories (ProductID, CategoryID) VALUES (12, 4);

CREATE TABLE ProductImages
(
    ProductImageID SERIAL PRIMARY KEY,
    ProductID      INT,
    ImageURL       VARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (1, 'https://www.apple.com/newsroom/images/product/iphone/standard/Apple_announce-iphone12pro_10132020_big.jpg.large.jpg');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (2, 'https://www.samsung.com/us/smartphones/galaxy-s21-5g/buy/galaxy-s21-5g-phantom-gray-128gb-unlocked-sm-g991uzamxaa/_jcr_content/hero/hero-image.image.jpg');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (3, 'https://consumer.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/phones/mate40-pro/images/mate40-pro-5g-green.png');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (4, 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp-spacegray-select-202011?wid=892&hei=820&&qlt=80&.v=1603406905000');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (5, 'https://images.samsung.com/is/image/samsung/p6pim/uk/galaxy-book/galaxy-book-pro-360/gallery/uk-galaxy-book-pro-360-5g-mystic-blue-393282-393282-SM-W930FZBAEUA-001-R-Perspective-Blue?$720_576_PNG$');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (6, 'https://consumer.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/pc/matebook-14-2020/images/matebook-14-2020-green.png');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (7, 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/ipad-pro-12-11-select-wifi-spacegray-202104_FMT_WHH?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1617126714000');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (8, 'https://images.samsung.com/is/image/samsung/p6pim/uk/tablets/galaxy-tab-s7/gallery/uk-galaxy-tab-s7-11-0-t875-393282-393282-SM-T875NZKAEUA-001-R-Perspective-Black?$720_576_PNG$');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (9, 'https://consumer.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/tablets/matepad-10-4/images/matepad-10-4-green.png');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (10, 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/aw-hero-202009_FMT_WHH?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1599829638000');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (11, 'https://images.samsung.com/is/image/samsung/p6pim/uk/wearables/galaxy-watch/galaxy-watch-active2/gallery/uk-galaxy-watch-active2-44mm-sm-r820-393282-393282-SM-R820NZKAEUA-001-R-Perspective-Black?$720_576_PNG$');
INSERT INTO ProductImages (ProductID, ImageURL) VALUES (12, 'https://consumer.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/wearables/watch-fit/images/watch-fit-green.png');

CREATE TABLE ProductReviews
(
    ProductReviewID SERIAL PRIMARY KEY,
    ProductID       INT,
    CustomerID      INT,
    Review          VARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID)
);
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (1, 1, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (2, 2, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (3, 3, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (4, 1, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (5, 2, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (6, 3, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (7, 1, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (8, 2, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (9, 3, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (10, 1, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (11, 2, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (12, 3, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (1, 2, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (2, 3, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (3, 1, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (4, 2, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (5, 3, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (6, 1, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (7, 2, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (8, 3, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (9, 1, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (10, 2, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (11, 3, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (12, 1, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (1, 3, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (2, 1, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (3, 2, 'Great phone!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (4, 3, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (5, 1, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (6, 2, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (7, 3, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (8, 1, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (9, 2, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (10, 3, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (11, 1, 'Great watch!');
INSERT INTO ProductReviews (ProductID, CustomerID, Review) VALUES (12, 2, 'Great watch!');

CREATE TABLE ProductRatings
(
    ProductRatingID SERIAL PRIMARY KEY,
    ProductID       INT,
    CustomerID      INT,
    Rating          INT,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID)
);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (1, 1, 4);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (2, 2, 5);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (3, 3, 3);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (4, 1, 3);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (5, 2, 5);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (6, 3, 5);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (7, 1, 4);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (8, 2, 3);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (9, 3, 5);
INSERT INTO ProductRatings (ProductID, CustomerID, Rating) VALUES (10, 1, 5);

CREATE TABLE ShoppingCartItems
(
    ShoppingCartItemID SERIAL PRIMARY KEY,
    ProductID          INT,
    CustomerID         INT,
    Quantity           INT,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID)
);

CREATE TABLE PaymentMethods
(
    PaymentMethodID   SERIAL PRIMARY KEY,
    PaymentMethodName VARCHAR(100)
);
INSERT INTO PaymentMethods (PaymentMethodName) VALUES ('Credit Card');
INSERT INTO PaymentMethods (PaymentMethodName) VALUES ('PayPal');
INSERT INTO PaymentMethods (PaymentMethodName) VALUES ('Bank Transfer');

CREATE TYPE OrderStatus AS ENUM ('Pending', 'Shipped', 'Delivered', 'Cancelled');
CREATE TABLE Orders
(
    OrderID         SERIAL PRIMARY KEY,
    CustomerID      INT,
    PaymentMethodID INT,
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods (PaymentMethodID),
    OrderDate       DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    OrderStatus     OrderStatus
);
INSERT INTO Orders (CustomerID, PaymentMethodID, OrderDate, OrderStatus) VALUES (1, 1, '2021-01-01', 'Delivered');
INSERT INTO Orders (CustomerID, PaymentMethodID, OrderDate, OrderStatus) VALUES (2, 2, '2021-01-02', 'Delivered');
INSERT INTO Orders (CustomerID, PaymentMethodID, OrderDate, OrderStatus) VALUES (3, 3, '2021-01-03', 'Delivered');

CREATE TABLE OrderDetails
(
    OrderDetailID   SERIAL PRIMARY KEY,
    OrderID         INT,
    ProductID       INT,
    Quantity        INT,
    PriceAtPurchase NUMERIC(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES (1, 1, 1, 999.99);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES (2, 2, 1, 899.99);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES (3, 3, 1, 799.99);

CREATE TABLE DeliveryMethods
(
    DeliveryMethodID SERIAL PRIMARY KEY,
    DeliveryMethodName VARCHAR(100)
);
INSERT INTO DeliveryMethods (DeliveryMethodName) VALUES ('Courier');
INSERT INTO DeliveryMethods (DeliveryMethodName) VALUES ('Parcel Locker');

CREATE TABLE Deliveries
(
    DeliveryID         SERIAL PRIMARY KEY,
    OrderID            INT,
    DeliveryMethodID   INT,
    DeliveryDate       DATE,
    DeliveryAddress    VARCHAR(255),
    DeliveryStatus     VARCHAR(255),
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    FOREIGN KEY (DeliveryMethodID) REFERENCES DeliveryMethods (DeliveryMethodID)
);
INSERT INTO Deliveries (OrderID, DeliveryMethodID, DeliveryDate, DeliveryAddress, DeliveryStatus) VALUES (1, 1, '2021-01-02', 'ul. Marszalkowska 1', 'Delivered');
INSERT INTO Deliveries (OrderID, DeliveryMethodID, DeliveryDate, DeliveryAddress, DeliveryStatus) VALUES (2, 2, '2021-01-03', 'ul. Wawelska 1', 'Delivered');
INSERT INTO Deliveries (OrderID, DeliveryMethodID, DeliveryDate, DeliveryAddress, DeliveryStatus) VALUES (3, 1, '2021-01-04', 'ul. Krakowska 1', 'Delivered');

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO api;