CREATE SCHEMA sales;


-- CREATING TABLE CUSTOMER


CREATE TABLE sales.Customer(
CustomerID INT PRIMARY KEY
, Email VARCHAR(30) UNIQUE NOT NULL
, Address TEXT
, Phone CHAR(10) NOT NULL
, Age SMALLINT NOT NULL
, DOB DATE);

-- INSERTING VALUES INSIDE THE TABLE sales.Customer

INSERT INTO sales.Customer(CustomerID, Email, Address, Phone, Age, DOB) values
(101, 'abc@gmail.com', 'West Street', '1234567890', 22, '1999-09-12'),
(102, 'def@yahoo.com', 'South Street', '1122547898', 25, '1997-09-08'),
(103, 'ghi@hotmail.com', 'East Street', '2346678979', 30, '1993-08-07');

SELECT * FROM sales.Customer;

-- CREATING TABLE PRODUCTS

CREATE TABLE sales.Products(
ProductID INT PRIMARY KEY
, ProductName VARCHAR(30) NOT NULL
, Price DECIMAL(10,2) CHECK (Price >0)
, Description_of_product TEXT
, CategoryorProductType VARCHAR(20) NOT NULL);

-- INSERTING VALUES INTO THE TABLE sales.Products

INSERT INTO sales.Products(ProductID, ProductName, Price, Description_of_product, CategoryorProductType) values
(1111, 'Antique Piece', 10000.50, 'Beautiful decor for your desks made of wood', 'Decor'),
(2222, 'Wrist watch', 3500.60, 'Precious time in your hand with high quality leather bands and 2 year warranty', 'Watches'),
(3333, 'Shoes', 2500.99, 'Walk with stylish footwear', 'Footwear'); 

SELECT * FROM sales.Products;

-- CREATING TABLE ORDERS

CREATE TABLE sales.Orders(
OrdersID INT AUTO_INCREMENT PRIMARY KEY
,CustomerID INT
, CONSTRAINT fk_cid FOREIGN KEY(CustomerID) REFERENCES sales.Customer(CustomerID)
,ProductID INT
,CONSTRAINT fk_pid FOREIGN KEY (ProductID) REFERENCES sales.Products(ProductID)
, OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
, OrderStatus VARCHAR(20)
, ShippingAddress TEXT
, PaymentMethod VARCHAR(20)
, PaymentStatus VARCHAR(20)
, ShippingMethod VARCHAR(30)
, TrackingNumber VARCHAR(50)
, Notes TEXT);

-- INSERTING VALUES INTO THE TABLE sales.Orders

INSERT INTO sales.Orders(CustomerID, ProductID, OrderStatus, ShippingAddress, PaymentMethod, PaymentStatus, ShippingMethod, TrackingNumber, Notes) VALUES
(101, 1111, 'Delivered', 'West Street', 'GPay', 'Paid', 'Standard Shipment', 'ASP13568', 'The product has been delievered properly and on time'),
(102, 2222, 'Shipped', 'South Street', 'PayTM', 'Due', 'Express Shipment', 'ASFGHUI8756657886', 'The product will reach the customer soon'),
(103, 3333, 'Ordered', 'East Street', 'Paypal', 'Paid', 'Express Shipment', 'FASYIUB6657667', 'The product is successfully');

SELECT * from sales.Orders;

