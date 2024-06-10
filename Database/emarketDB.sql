\c postgres;

DROP DATABASE IF EXISTS emarket;
DROP USER IF EXISTS api;

CREATE DATABASE emarket;
\! sleep 1;
\c emarket;

CREATE USER api WITH PASSWORD '>2sPbT5A41N<9-5v';
GRANT ALL PRIVILEGES ON DATABASE emarket TO api;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO api;

CREATE TABLE Users
(
    UserID    SERIAL PRIMARY KEY,
    UserName  VARCHAR(100) NOT NULL,
    Password  VARCHAR(100) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName  VARCHAR(100) NOT NULL,
    Email     VARCHAR(100) NOT NULL,
    Phone     VARCHAR(100) NOT NULL,
    Address   VARCHAR(100) NOT NULL,
    IsAdmin   BOOLEAN DEFAULT FALSE
);

ALTER TABLE Users ADD CONSTRAINT Unique_UserName UNIQUE (UserName);
ALTER TABLE Users ADD CONSTRAINT Unique_Email UNIQUE (Email);
ALTER TABLE Users ADD CONSTRAINT Unique_Phone UNIQUE (Phone);

INSERT INTO Users (FirstName, LastName, UserName, Email, Phone, Password, Address) VALUES ('Jan', 'Kowalski', 'jkowalski', '123@123.com', '123123', 'password', 'ul. Marszalkowska 1');
INSERT INTO Users (FirstName, LastName, UserName, Email, Phone, Password, Address) VALUES ('Anna', 'Nowak', 'anowak', '234@234.com', '234234', 'password', 'ul. Wawelska 1');
INSERT INTO Users (FirstName, LastName, UserName, Email, Phone, Password, Address) VALUES ('Piotr', 'Kowalczyk', 'pkowalczyk', '345@435.com', '345345', 'password', 'ul. Krakowska 1');

CREATE TABLE Brands
(
    BrandID   SERIAL PRIMARY KEY,
    BrandName VARCHAR(100) NOT NULL
);

ALTER TABLE Brands ADD CONSTRAINT Unique_BrandName UNIQUE (BrandName);

INSERT INTO Brands (BrandName) VALUES ('Apple');
INSERT INTO Brands (BrandName) VALUES ('Samsung');
INSERT INTO Brands (BrandName) VALUES ('Huawei');


CREATE TABLE Products
(
    ProductID       SERIAL PRIMARY KEY,
    ProductName     VARCHAR(100) NOT NULL,
    Description     VARCHAR(255),
    Price           NUMERIC(10, 2) NOT NULL,
    Brand           INT NOT NULL,
    FOREIGN KEY (Brand) REFERENCES Brands (BrandID),
    QuantityInStock INT NOT NULL
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


CREATE TABLE ProductImages
(
    ProductImageID SERIAL PRIMARY KEY,
    ProductID      INT NOT NULL,
    ImageURL       VARCHAR(255) NOT NULL,
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
    ProductID       INT NOT NULL,
    UserID      INT NOT NULL,
    Review          VARCHAR(255) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (UserID) REFERENCES Users (UserID)
);

ALTER TABLE ProductReviews ADD CONSTRAINT Unique_ProductID_UserID_Review UNIQUE (ProductID, UserID);

INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (1, 1, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (2, 2, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (3, 3, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (4, 1, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (5, 2, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (6, 3, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (7, 1, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (8, 2, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (9, 3, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (10, 1, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (11, 2, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (12, 3, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (1, 2, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (2, 3, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (3, 1, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (4, 2, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (5, 3, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (6, 1, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (7, 2, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (8, 3, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (9, 1, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (10, 2, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (11, 3, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (12, 1, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (1, 3, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (2, 1, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (3, 2, 'Great phone!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (4, 3, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (5, 1, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (6, 2, 'Great laptop!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (7, 3, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (8, 1, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (9, 2, 'Great tablet!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (10, 3, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (11, 1, 'Great watch!');
INSERT INTO ProductReviews (ProductID, UserID, Review) VALUES (12, 2, 'Great watch!');

CREATE TABLE ProductRatings
(
    ProductRatingID SERIAL PRIMARY KEY,
    ProductID       INT NOT NULL,
    UserID      INT NOT NULL,
    Rating          INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (UserID) REFERENCES Users (UserID)
);

ALTER TABLE ProductRatings ADD CONSTRAINT Unique_ProductID_UserID_Rating UNIQUE (ProductID, UserID);

INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (1, 1, 4);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (2, 2, 5);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (3, 3, 3);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (4, 1, 3);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (5, 2, 5);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (6, 3, 5);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (7, 1, 4);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (8, 2, 3);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (9, 3, 5);
INSERT INTO ProductRatings (ProductID, UserID, Rating) VALUES (10, 1, 5);


CREATE TABLE ShoppingCartItems
(
    ShoppingCartItemID SERIAL PRIMARY KEY,
    ProductID          INT NOT NULL,
    UserID         INT NOT NULL,
    Quantity           INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    FOREIGN KEY (UserID) REFERENCES Users (UserID)
);

ALTER TABLE ShoppingCartItems ADD CONSTRAINT Unique_ProductID_UserID_Cart UNIQUE (ProductID, UserID);


CREATE TABLE PaymentMethods
(
    PaymentMethodID   SERIAL PRIMARY KEY,
    PaymentMethodName VARCHAR(100) NOT NULL
);

ALTER TABLE PaymentMethods ADD CONSTRAINT Unique_PaymentMethodName UNIQUE (PaymentMethodName);

INSERT INTO PaymentMethods (PaymentMethodName) VALUES ('Credit Card');
INSERT INTO PaymentMethods (PaymentMethodName) VALUES ('PayPal');
INSERT INTO PaymentMethods (PaymentMethodName) VALUES ('Bank Transfer');


CREATE TYPE OrderStatus AS ENUM ('Pending', 'Shipped', 'Delivered', 'Cancelled');
CREATE TABLE Orders
(
    OrderID         SERIAL PRIMARY KEY,
    UserID      INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods (PaymentMethodID),
    OrderDate       DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users (UserID),
    OrderStatus     OrderStatus NOT NULL
);

INSERT INTO Orders (UserID, PaymentMethodID, OrderDate, OrderStatus) VALUES (1, 1, '2021-01-01', 'Delivered');
INSERT INTO Orders (UserID, PaymentMethodID, OrderDate, OrderStatus) VALUES (2, 2, '2021-01-02', 'Delivered');
INSERT INTO Orders (UserID, PaymentMethodID, OrderDate, OrderStatus) VALUES (3, 3, '2021-01-03', 'Delivered');


CREATE TABLE OrderDetails
(
    OrderDetailID   SERIAL PRIMARY KEY,
    OrderID         INT NOT NULL,
    ProductID       INT NOT NULL,
    Quantity        INT NOT NULL,
    PriceAtPurchase NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

ALTER TABLE OrderDetails ADD CONSTRAINT Unique_OrderID_ProductID UNIQUE (OrderID, ProductID);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES (1, 1, 1, 999.99);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES (2, 2, 1, 899.99);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES (3, 3, 1, 799.99);


CREATE TABLE DeliveryMethods
(
    DeliveryMethodID SERIAL PRIMARY KEY,
    DeliveryMethodName VARCHAR(100) NOT NULL
);

ALTER TABLE DeliveryMethods ADD CONSTRAINT Unique_DeliveryMethodName UNIQUE (DeliveryMethodName);

INSERT INTO DeliveryMethods (DeliveryMethodName) VALUES ('Courier');
INSERT INTO DeliveryMethods (DeliveryMethodName) VALUES ('Parcel Locker');


CREATE TABLE Deliveries
(
    DeliveryID         SERIAL PRIMARY KEY,
    OrderID            INT NOT NULL,
    DeliveryMethodID   INT NOT NULL,
    DeliveryDate       DATE,
    DeliveryAddress    VARCHAR(100) NOT NULL,
    DeliveryStatus     VARCHAR(255) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    FOREIGN KEY (DeliveryMethodID) REFERENCES DeliveryMethods (DeliveryMethodID)
);

ALTER TABLE Deliveries ADD CONSTRAINT Unique_OrderID UNIQUE (OrderID);

INSERT INTO Deliveries (OrderID, DeliveryMethodID, DeliveryDate, DeliveryAddress, DeliveryStatus) VALUES (1, 1, '2021-01-02', 'ul. Marszalkowska 1', 'Delivered');
INSERT INTO Deliveries (OrderID, DeliveryMethodID, DeliveryDate, DeliveryAddress, DeliveryStatus) VALUES (2, 2, '2021-01-03', 'ul. Wawelska 1', 'Delivered');
INSERT INTO Deliveries (OrderID, DeliveryMethodID, DeliveryDate, DeliveryAddress, DeliveryStatus) VALUES (3, 1, '2021-01-04', 'ul. Krakowska 1', 'Delivered');


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO api;

GRANT USAGE, SELECT ON SEQUENCE users_userid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE brands_brandid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE products_productid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE productimages_productimageid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE productreviews_productreviewid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE productratings_productratingid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE shoppingcartitems_shoppingcartitemid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE paymentmethods_paymentmethodid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE orders_orderid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE orderdetails_orderdetailid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE deliverymethods_deliverymethodid_seq TO api;
GRANT USAGE, SELECT ON SEQUENCE deliveries_deliveryid_seq TO api;