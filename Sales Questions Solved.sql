-- SALES CASE STUDY

-- Question 1
-- Find total sales done by each customer and order it by salesAmount
-- Answer Query

WITH cte AS(
SELECT 
a.FullName AS CustomerName,
CASE
   WHEN b.UnitPriceDiscount >0 then (b.UnitPrice- (b.UnitPrice*b.UnitPriceDiscount)/100)
   ELSE b.UnitPrice
   END
   AS UnitPrice,
b.OrderQty
FROM
sales.customers as a
INNER JOIN
sales.orders as b
ON a.CustomerID= b.CustomerID
)
SELECT
CustomerName,
ROUND(SUM(UnitPrice*OrderQty),2) AS TotalSales
FROM cte
GROUP BY CustomerName
ORDER BY SUM(UnitPrice*OrderQty) DESC;

-- QUESTION 2
-- Find categorywise sales amount
-- Answer Query

WITH sales AS(
SELECT 
c.CategoryName,
CASE
   WHEN o.UnitPriceDiscount >0 then (o.UnitPrice- (o.UnitPrice*o.UnitPriceDiscount)/100)
   ELSE o.UnitPrice
   END
   AS UnitPrice,
o.OrderQty
FROM 
sales.orders AS o
INNER JOIN
sales.products AS p
ON o.ProductID= p.ProductID
INNER JOIN
sales.productsubcategories AS s
ON p.SubCategoryID= s.SubCategoryID
INNER JOIN
sales.productcategories AS c
ON c.CategoryID= s.CategoryID)
SELECT 
CategoryName,
ROUND(SUM(UnitPrice*OrderQty), 2) AS SalesAmount
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- QUESTION 3
-- Which Employee has made more number of sales?
-- Answer Query


WITH employee AS(
SELECT 
emp.FullName AS EmployeeName,
CASE
   WHEN orders.UnitPriceDiscount >0 then (orders.UnitPrice- (orders.UnitPrice*orders.UnitPriceDiscount)/100)
   ELSE orders.UnitPrice
   END
   AS UnitPrice,
orders.OrderQty
FROM
sales.orders AS orders
INNER JOIN
sales.employees as emp
ON orders.EmployeeID= emp.EmployeeID)
SELECT
EmployeeName,
ROUND(SUM(UnitPrice*OrderQty), 2) AS SalesAmount
FROM employee
GROUP BY 1
ORDER BY 2 DESC;

-- QUESTION 4
-- Which product was ordered most number of times?
-- Answer Query

SELECT 
p.ProductName,
COUNT(o.SalesOrderID) AS OrderCount
FROM
sales.orders AS o
INNER JOIN
sales.products AS p
ON p.ProductID= o.ProductID
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- ADDITIONAL PRACTICE QUESTIONS
-- Question 1
-- Find total orders by category,subcategory

-- Categorywise Ordercount

SELECT 
pc.CategoryName,
COUNT(SalesOrderID) AS OrderCounts
FROM
sales.orders AS o
INNER JOIN 
sales.products AS p
ON o.ProductID= p.ProductID
INNER JOIN
sales.productsubcategories AS psc
ON p.SubCategoryID= psc.SubCategoryID
INNER JOIN
sales.productcategories AS pc
ON psc.CategoryID= pc.CategoryID
GROUP BY
pc.CategoryName
ORDER BY 2 DESC;

-- Subcategory wise order count

SELECT 
psc.SubCategoryName,
COUNT(SalesOrderID) AS OrderCounts
FROM
sales.orders AS o
INNER JOIN 
sales.products AS p
ON o.ProductID= p.ProductID
INNER JOIN
sales.productsubcategories AS psc
ON p.SubCategoryID= psc.SubCategoryID
INNER JOIN
sales.productcategories AS pc
ON psc.CategoryID= pc.CategoryID
GROUP BY
psc.SubCategoryName
ORDER BY 2 DESC;


-- Categorywise and subcategorywise order counts

WITH cte AS(
SELECT 
pc.CategoryName,
psc.SubCategoryName,
o.SalesOrderID,
COUNT(o.SalesOrderID) OVER (PARTITION BY pc.CategoryName, psc.SubCategoryName) AS OrderCounts
FROM
sales.orders AS o
INNER JOIN 
sales.products AS p
ON o.ProductID= p.ProductID
INNER JOIN
sales.productsubcategories AS psc
ON p.SubCategoryID= psc.SubCategoryID
INNER JOIN
sales.productcategories AS pc
ON psc.CategoryID= pc.CategoryID
GROUP BY
pc.CategoryName,
psc. SubCategoryName, 3
ORDER BY 4 DESC),
sales AS(
SELECT 
cte.CategoryName,
cte.SubCategoryName,
cte. OrderCounts,
ROW_NUMBER() OVER (PARTITION BY cte.CategoryName, cte.SubCategoryName ORDER BY cte.OrderCounts) AS r_number
FROM cte
GROUP BY 1, 2, 3 
ORDER BY 4 DESC)
SELECT 
CategoryName,
SubCategoryName,
OrderCounts
FROM Sales 
WHERE r_number=1;

-- Question 2
-- Find the sales made by the female employees
-- Answer Query

SELECT 
e.FullName AS EmployeeName,
o.SalesOrderID,
o.SalesOrderDetailID
FROM
sales.employees AS e
INNER JOIN
sales.orders AS o
ON e.EmployeeID= o.EmployeeID
WHERE e.Gender= "F";

-- Question 3
-- Find the sales made by the vendor
-- Answer Query

SELECT 
v.VendorName,
v.VendorID,
o. SalesOrderID,
o. SalesOrderDetailID
FROM
sales.orders AS o
INNER JOIN
sales.vendorproduct AS vp
ON o.ProductID= vp.ProductID
INNER JOIN
sales.vendors AS v
ON vp.VendorID= v.VendorID;

-- Question 4
-- Find the sales made by the manager
-- Answer Query

SELECT 
e. FullName AS ManagerName,
o.SalesOrderID,
o.SalesOrderDetailID
FROM
sales.orders AS o
INNER JOIN
sales.employees AS e
ON o.EmployeeID= e.ManagerID;

-- Question 5
-- Find the distinct product brought by the customers

SELECT 
DISTINCT p.ProductName
FROM
sales.orders AS o
INNER JOIN
sales.products AS p
ON o.ProductID= p.ProductID
ORDER BY 1;

-- Question 6
-- Find top 5 customer who made more number of orders
-- Answer Query

SELECT 
c.FullName AS CustomerName,
COUNT(o.SalesOrderDetailID) AS OrderCount
FROM
sales.orders AS o
INNER JOIN
sales.customers AS c
ON o.CustomerID= c.CustomerID
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Question 7
-- Find top product of a vendor based on orderQuantity
-- Answer Query

WITH cte AS (
SELECT 
v.VendorName,
p.ProductName,
SUM(o.OrderQty) AS OrderCount
FROM 
sales.vendorproduct AS vp
INNER JOIN
sales.orders AS o
ON vp.ProductID= o.ProductID
INNER JOIN
sales.vendors AS v
ON v.VendorID= vp.VendorID
INNER JOIN
sales.products AS p
ON p.ProductID= vp.ProductID
GROUP BY 1, 2
ORDER BY 1, 3 DESC)
SELECT 
VendorName,
ProductName,
OrderCount
FROM 
cte
WHERE
(VendorName, OrderCount) IN (SELECT VendorName, MAX(OrderCount) FROM cte GROUP BY 1);