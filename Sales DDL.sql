DROP SCHEMA IF EXISTS sales;

CREATE SCHEMA sales;

USE sales;

--
-- Table structure for table customers
--

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  CustomerID bigint NOT NULL,
  FirstName text,
  LastName text,
  FullName text,
  PRIMARY KEY (CustomerID)
);

--
-- Table structure for table employees
--

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  EmployeeID bigint NOT NULL,
  ManagerID double DEFAULT NULL,
  FirstName text,
  LastName text,
  FullName text,
  JobTitle text,
  OrganizationLevel bigint DEFAULT NULL,
  MaritalStatus text,
  Gender text,
  Territory text,
  Country text,
  `Group` text,
  PRIMARY KEY (EmployeeID)
);

--
-- Table structure for table orders
--

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  SalesOrderID bigint DEFAULT NULL,
  SalesOrderDetailID bigint DEFAULT NULL,
  OrderDate datetime DEFAULT NULL,
  DueDate datetime DEFAULT NULL,
  ShipDate datetime DEFAULT NULL,
  EmployeeID bigint DEFAULT NULL,
  CustomerID bigint DEFAULT NULL,
  SubTotal double DEFAULT NULL,
  TaxAmt double DEFAULT NULL,
  Freight double DEFAULT NULL,
  TotalDue double DEFAULT NULL,
  ProductID bigint DEFAULT NULL,
  OrderQty bigint DEFAULT NULL,
  UnitPrice double DEFAULT NULL,
  UnitPriceDiscount double DEFAULT NULL,
  LineTotal double DEFAULT NULL
);

--
-- Table structure for table productcategories
--

DROP TABLE IF EXISTS productcategories;
CREATE TABLE productcategories (
  CategoryID bigint NOT NULL,
  CategoryName text,
  PRIMARY KEY (CategoryID)
);

--
-- Table structure for table products
--

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  ProductID bigint NOT NULL,
  ProductNumber text,
  ProductName text,
  ModelName text,
  MakeFlag bigint DEFAULT NULL,
  StandardCost double DEFAULT NULL,
  ListPrice double DEFAULT NULL,
  SubCategoryID bigint DEFAULT NULL
);

--
-- Table structure for table productsubcategories
--

DROP TABLE IF EXISTS productsubcategories;
CREATE TABLE productsubcategories (
  SubCategoryID bigint NOT NULL,
  CategoryID bigint DEFAULT NULL,
  SubCategoryName text,
  PRIMARY KEY (SubCategoryID)
);

--
-- Table structure for table vendorproduct
--

DROP TABLE IF EXISTS vendorproduct;
CREATE TABLE vendorproduct (
  ProductID bigint DEFAULT NULL,
  VendorID bigint DEFAULT NULL
);

--
-- Table structure for table vendors
--

DROP TABLE IF EXISTS vendors;
CREATE TABLE vendors (
  VendorID bigint NOT NULL,
  VendorName text,
  AccountNumber text,
  CreditRating bigint DEFAULT NULL,
  ActiveFlag bigint DEFAULT NULL,
  PRIMARY KEY (VendorID)
);


-- Dump completed on 2023-08-05 15:27:17